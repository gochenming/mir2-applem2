unit DllMain;

interface

uses
  SysUtils, Classes, Windows, ExtCtrls, RSA, JSocket, MD5Unit, EDCode, SCShare, GeneralCommon,
  Hutil32, INIFiles, Controls, MyCommon, DES;

const
  CONNADDRS: array[0..2] of string = ('check.361m2.net', 'check2.361m2.net', 'check.361m2.com');
  CONNPORT: array[0..2] of Word = (9008, 9000, 9000);

Type

  TREGClass = class(TObject)
  private
    FTimer: TTimer;
    FRSA: TRSA;
    CSocket: TClientSocket;
    FFileName: string;
    FFileMD5: string;
    FMarkIndex: Integer;
    FSMarkIndex: Integer;
    FMD5MarkIndex: Integer;
    FReadStr: string;
    FIni: TINIFile;
    FPublicID: string;
    FCheckHint: string;
    FDESPassword: string;
    FServerMark: string;
    FboEndCheck: Boolean;
    FboCheckOK: Boolean;
    FExitUrl: string;
    FGameMsg: string;
    FFrameUrl: string;
    FPCName: string;
    FConnIndex: Byte;
    //FHTTP: TIdHTTP;
    //FIdCompressorZLibEx: TIdCompressorZLibEx;
    DefMsg: TDefaultMessage;
    procedure SendBeginCheck();
    procedure SendFileInfo();
    procedure SendSetUserName();
    procedure SendCheckPC();
    function GetHardwareID(): string;
//    function HtmlToText(HtmlText: WideString): WideString;
  public
    constructor Create;
    destructor Destroy; override;
    procedure OnTimer(Sender: TObject);
    procedure MainOutMessage(sMsg: string);
    procedure BeginCheck;
    procedure EndCheck;
    procedure ClientSocketConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure ClientSocketDisconnect(Sender: TObject;Socket: TCustomWinSocket);
    procedure ClientSocketError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure ClientSocketRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure SendSocket(sSendStr: string);
    procedure ProcessUserMsg(sMsg: string);
    procedure SetPublicID(sPublicID: string);
    function GetDEFPassword: PChar;
    function GetServerMark: PChar;
    function GetExitUrl: PChar;
    function GetGameMsgList: PChar;
    function GetFrameUrl: PChar;
  end;

  TMsgProc = procedure(Msg: PChar; nMode: Integer); stdcall;
  TCheckOKProc = procedure(); stdcall;

var
  OutMessage: TMsgProc;
  CheckOKProc: TCheckOKProc;
  FreeVar: Boolean;
  ApplicationHandle: THandle;
  MainHandle: THandle;
  RunGateProt: Integer;
  REGClass: TREGClass;

  function CheckEMailRule(sEMail: string): Boolean;

  procedure DESDecryText(InBuffer: PChar; OutBuffer: PChar; OutLength: Integer);


implementation

uses
  QuestMain;
{ TREGClass }

Const
  DLL_VAR = 20110104;

procedure DESDecryText(InBuffer: PChar; OutBuffer: PChar; OutLength: Integer);
var
  sBackStr: string;
begin
  sBackStr := '';
  Try
    sBackStr := DecryStrHex(strpas(InBuffer), '19850506');
  Except
    sBackStr := '';
  End;
  if sBackStr <> '' then begin
    if Length(sBackStr) > OutLength then Move(sBackStr[1], OutBuffer^, OutLength)
    else Move(sBackStr[1], OutBuffer^, Length(sBackStr));
  end;
end;

function CheckEMailRule(sEMail: string): Boolean;
var
  Chr: Char;
  str1, str2: string;
begin
  Result := False;
  str2 := GetValidStr3(sEMail, str1, ['@']);
  if Pos('.', str2) <= 0 then
    exit;
  Result := True;
  for Chr in str1 do begin
    if not (Chr in ['a'..'z', '0'..'9', '_', '-']) then begin
      Result := False;
      Exit;
    end;
  end;
  for Chr in str2 do begin
    if not (Chr in ['a'..'z', '0'..'9', '_', '.', '-']) then begin
      Result := False;
      Exit;
    end;
  end;
end;


function TREGClass.GetDEFPassword: PChar;
begin
  Result := PChar(FDESPassword);
end;

function TREGClass.GetExitUrl: PChar;
begin
  Result := PChar(FExitUrl);
end;

function TREGClass.GetFrameUrl: PChar;
begin
  Result := PChar(FFrameUrl);
end;

function TREGClass.GetGameMsgList: PChar;
begin
  Result := PChar(FGameMsg);
end;

function TREGClass.GetHardwareID(): string;
begin
  Result := UpperCase(GetMD5TextOf16(GetIdeSerialNumber + GetCpuID + FPublicID));
end;

function TREGClass.GetServerMark: PChar;
begin
  Result := PChar(FServerMark);
end;
 {
function TREGClass.HtmlToText(HtmlText: WideString): WideString;
var
  V: OleVariant;
  Document: IHTMLDocument2;
begin
  Result := HtmlText;
  if HtmlText = '' then
    Exit;
  CoInitialize(nil);
  Document := CoHTMLDocument.Create as IHtmlDocument2;
  try
    V := VarArrayCreate([0, 0], varVariant);
    V[0] := HtmlText;
    Document.Write(PSafeArray(TVarData(v).VArray));
    Document.Close;
    Result := Trim(Document.body.outerText);
  finally
    Document := nil;
    CoUninitialize;
  end;
end;    }

procedure TREGClass.BeginCheck;
begin
  FTimer.Enabled := True;
end;

procedure TREGClass.ClientSocketConnect(Sender: TObject; Socket: TCustomWinSocket);
begin
  MainOutMessage('正在验证授权信息，请稍候...');
  FCheckHint := '与验证服务器断开连接...';
  FReadStr := '';
  FboEndCheck := False;
  SendSocket('+');
  SendBeginCheck;
end;

procedure TREGClass.ClientSocketDisconnect(Sender: TObject; Socket: TCustomWinSocket);
begin
  EndCheck;
end;

procedure TREGClass.ClientSocketError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
  Inc(FConnIndex);
  ErrorCode := 0;
  if FConnIndex > 2 then begin
    FCheckHint := '连接所有服务器失败，请先暂时关闭本地安全策略...';
    Socket.Close;
    EndCheck;
  end else begin
    FboEndCheck := True;
    Socket.Close;
    FTimer.Interval := 1000;
    MainOutMessage('正在尝试使用备用地址[' + IntToStr(FConnIndex) + ']进行连接...');
    BeginCheck;
    FboEndCheck := False;
  end;
end;

procedure TREGClass.ClientSocketRead(Sender: TObject; Socket: TCustomWinSocket);
var
  sData: string;
begin
  FReadStr := FReadStr + Socket.ReceiveText;
  while True do begin
    if Pos(g_CodeEnd, FReadStr) <= 0 then break;
    FReadStr := ArrestStringEx(FReadStr, g_CodeHead, g_CodeEnd, sData);
    if Length(sData) >= DEFBLOCKSIZE then
      ProcessUserMsg(sData);
  end;
end;

constructor TREGClass.Create;
var
  Buffer: array[0..MAX_PATH] of Char;
begin
  inherited;
  Randomize;
  FDESPassword := '';
  FRSA := TRSA.Create(nil);
  FRSA.CommonalityKey := '7348771695260538414727771';
  FRSA.CommonalityMode := '1019792440150204761367420205883145987530635720731440113';
  FRSA.Server := False;
  FTimer := TTimer.Create(nil);
  FTimer.Enabled := False;
  FTimer.Interval := 2000 + Random(3000);
  FTimer.OnTimer := OnTimer;
  CSocket := TClientSocket.Create(nil);
  CSocket.ClientType := ctNonBlocking;
  CSocket.Active := False;
  CSocket.OnConnect := ClientSocketConnect;
  CSocket.OnDisconnect := ClientSocketDisconnect;
  CSocket.OnError := ClientSocketError;
  CSocket.OnRead := ClientSocketRead;
  FGameMsg := '';
  FExitUrl := '';
  FFrameUrl := '';
  FConnIndex := 0;
  FPCName := '';
  {FHTTP := TIDHTTP.Create(nil);
  FIdCompressorZLibEx := TIdCompressorZLibEx.Create(nil);
  FHTTP.Compressor := FIdCompressorZLibEx;
  FHTTP.HandleRedirects:= True;      }


  FINI := TINIFile.Create('./!Setup.txt');
  FPublicID := FINI.ReadString('Reg', 'PublicID', '');
  FillChar(Buffer, SizeOf(Buffer), #0);
  GetModuleFileName(0, @Buffer[0], MAX_PATH);
  FFileName := Buffer;
  FboCheckOK := False;
  FboEndCheck := False;
end;

destructor TREGClass.Destroy;
begin
  {FIdCompressorZLibEx.Free;
  FHTTP.Free;  }
  FINI.Free;
  FRSA.Free;
  FTimer.Free;
  CSocket.Free;
  inherited;
end;

procedure TREGClass.EndCheck;
begin
  if CSocket.Socket.Connected then CSocket.Close;
  if not FboEndCheck then begin
    FboEndCheck := True;
    if FboCheckOK then begin
      if FreeVar then begin
        MainOutMessage('通过验证，您使用的是免费版(部份功能限制)...');
        MainOutMessage('如果您觉得好用，请支持我们购买正式版...');
      end
      else MainOutMessage('成功通过验证，感谢您的支持...');
    end
    else MainOutMessage('[验证失败]：' + FCheckHint);
  end;
end;

procedure TREGClass.MainOutMessage(sMsg: string);
begin
  if Assigned(OutMessage) then
    OutMessage(PChar(sMsg), 1);
end;

procedure TREGClass.OnTimer(Sender: TObject);
var
  nSize: DWORD;
  NameBuffer: array[0..MAX_PATH - 1] of Char;
begin
  FboEndCheck := False;
  FTimer.Enabled := False;
  if FConnIndex = 0 then begin
    MainOutMessage('正在尝试连接远程验证服务器...');
    FFileMD5 := FileToMD5Text(FFileName);
    nSize := MAX_PATH - 1;
    GetComputerName(@NameBuffer, nSize);
    NameBuffer[nSize] := #0;
    FPCName := Strpas(NameBuffer);
  end;
  CSocket.Host := CONNADDRS[FConnIndex];
  CSocket.Port := CONNPORT[FConnIndex];
  CSocket.Active := True;
end;

procedure TREGClass.ProcessUserMsg(sMsg: string);
var
  sDefMsg: string;
  sData, S1, S2, S3, S4, S5, S6: string;
  DefMsg: TDefaultMessage;
begin
  try
    sDefMsg := Copy(sMsg, 1, DEFBLOCKSIZE);
    sData := Copy(sMsg, DEFBLOCKSIZE + 1, length(sMsg) - DEFBLOCKSIZE);
    DefMsg := DecodeMessage(sDefMsg);
    case DefMsg.Ident of
      SM_GETMARK: begin
          sData := FRSA.DecryptStr(sData);
          sData := GetValidStr3(sData, S1, ['/']);
          if StrToIntDef(sData, -1) = FMarkIndex then begin
            FSMarkIndex := StrToIntDef(S1, -1);
            if FSMarkIndex > 0 then SendFileInfo();
          end;
        end;
      SM_SETNAME_FAIL: begin
          sData := FRSA.DecryptStr(sData);
          sData := GetValidStr3(sData, S1, ['/']);
          if StrToIntDef(S1, -1) = FSMarkIndex then begin
            MessageBox(MainHandle, PChar(sData), '提示信息', MB_OK + MB_ICONINFORMATION);
            SendSetUserName;
          end;
        end;
      SM_SETNAME_OK: begin
          sData := FRSA.DecryptStr(sData);
          sData := GetValidStr3(sData, S1, ['/']);
          if StrToIntDef(S1, -1) = FSMarkIndex then begin
            FPublicID := sData;
            FINI.WriteString('Reg', 'PublicID', FPublicID);
            SendFileInfo;
          end;
        end;
      SM_CHECKMD5_OK: begin
          sData := FRSA.DecryptStr(sData);
          sData := GetValidStr3(sData, S1, ['/']);
          if StrToIntDef(S1, -1) = FSMarkIndex then begin
            FMD5MarkIndex := StrToIntDef(sData, -1);
            SendCheckPC();
          end;
        end;
      SM_BINDPCCOUNT_FAIL: begin
          sData := FRSA.DecryptStr(sData);
          sData := GetValidStr3(sData, S1, ['/']);
          if StrToIntDef(S1, -1) = FSMarkIndex then begin
            if MessageBox(MainHandle, PChar(sData), '提示信息', MB_OKCANCEL + MB_ICONQUESTION) = IDOK then begin
              FormQuest := TFormQuest.Create(nil);
              if FormQuest.ShowModal = mrYes then begin
                DefMsg := MakeDefaultMsg(CM_SENDSETNAME, 0, 0, 0, 0);
                SendSocket(EncodeMessage(DefMsg) + FRSA.EncryptStr(IntToStr(FMarkIndex) + '/' + FormQuest.FEditText));
              end else begin
                FCheckHint := '用户名信息错误...';
                EndCheck;
              end;
              FormQuest.Free;
            end else begin
              FCheckHint := '机器未授权...';
              EndCheck;
            end;
          end;
        end;
      SM_CHECKPC_FAIL,
        SM_BINDPCPASS_FAIL: begin
          sData := FRSA.DecryptStr(sData);
          sData := GetValidStr3(sData, S1, ['/']);
          if StrToIntDef(S1, -1) = FSMarkIndex then begin
            if MessageBox(MainHandle, PChar(sData), '提示信息', MB_OKCANCEL + MB_ICONQUESTION) = IDOK then begin
              FormQuest := TFormQuest.Create(nil);
              FormQuest.Label1.Caption := '请输入您的密码：';
              FormQuest.EditName.PasswordChar := '*';
              if FormQuest.ShowModal = mrYes then begin
                DefMsg := MakeDefaultMsg(CM_SENDBINDPC, 0, 0, 0, 0);
                SendSocket(EncodeMessage(DefMsg) + FRSA.EncryptStr(IntToStr(FMD5MarkIndex) + '/' + GetHardwareID + '/' + FormQuest.FEditText));
              end else begin
                FCheckHint := '机器未授权...';
                EndCheck;
              end;
              FormQuest.Free;
            end else begin
              FCheckHint := '机器未授权...';
              EndCheck;
            end;
          end;
        end;
      SM_CHECKPC_NEW_OK: begin
          sData := GetValidStrEx(sData, S1, ['/']);
          sData := GetValidStrEx(sData, S4, ['/']);
          sData := GetValidStrEx(sData, S5, ['/']);
          sData := GetValidStrEx(sData, S6, ['/']);
          sData := FRSA.DecryptStr(S1);
          sData := GetValidStr3(sData, S1, ['/']);
          sData := GetValidStr3(sData, S2, ['/']);
          sData := GetValidStr3(sData, S3, ['/']);
          if StrToIntDef(S1, -1) = FSMarkIndex then begin
            FDESPassword := S2;
            FServerMark := S3;
            FGameMsg := S4;
            FFrameUrl := S5;
            FExitUrl := S6;
            FboCheckOK := True;
            CheckOKProc();
            EndCheck;
          end;
        end;
      {SM_CHECKPC_OK: begin
          sData := FRSA.DecryptStr(sData);
          sData := GetValidStr3(sData, S1, ['/']);
          sData := GetValidStr3(sData, S2, ['/']);
          if StrToIntDef(S1, -1) = FSMarkIndex then begin
            FDESPassword := S2;
            FServerMark := sData;
            FboCheckOK := True;
            CheckOKProc();
            EndCheck;
          end;
        end;   }
      SM_MESSAGEBOX: begin
          sData := FRSA.DecryptStr(sData);
          sData := GetValidStr3(sData, S1, ['/']);
          if StrToIntDef(S1, -1) = FSMarkIndex then begin
            MessageBox(MainHandle, PChar(sData), '提示信息', MB_OK + MB_ICONINFORMATION);
          end;
        end;
    end;
  except
  end;
end;

procedure TREGClass.SendBeginCheck;
begin
  FMarkIndex := Random(9999) + 1000;
  FSMarkIndex := -1;
  DefMsg := MakeDefaultMsg(CM_SENDMARK, 0, 0, 0, 0);
  SendSocket(EncodeMessage(DefMsg) + FRSA.EncryptStr(IntToStr(FMarkIndex) + '/' + IntToStr(DLL_VAR) + '/' + IntToStr(RunGateProt)));
end;

procedure TREGClass.SendCheckPC;
begin
  DefMsg := MakeDefaultMsg(CM_SENDCHECKPC, 0, 0, 0, 0);
  SendSocket(EncodeMessage(DefMsg) + FRSA.EncryptStr(IntToStr(FMD5MarkIndex) + '/' + GetHardwareID() + '/' + FPCName));
end;

procedure TREGClass.SendFileInfo;
begin
  if (Length(FPublicID) <> 18) or (StrToInt64Def(FPublicID, 0) <= 0) then begin
    SendSetUserName;
  end else begin
    DefMsg := MakeDefaultMsg(CM_SENDMD5, 0, 0, 0, 0);
    SendSocket(EncodeMessage(DefMsg) + FRSA.EncryptStr(IntToStr(FMarkIndex) + '/' + FFileMD5 + '/' + FPublicID));
  end;
end;

procedure TREGClass.SendSetUserName;                      
begin
  FormQuest := TFormQuest.Create(nil);
  if FormQuest.ShowModal = mrYes then begin
    DefMsg := MakeDefaultMsg(CM_SENDSETNAME, 0, 0, 0, 0);
    SendSocket(EncodeMessage(DefMsg) + FRSA.EncryptStr(IntToStr(FMarkIndex) + '/' + FormQuest.FEditText));
  end else begin
    FCheckHint := '用户名信息错误...';
    EndCheck;
  end;
  FormQuest.Free;
end;

procedure TREGClass.SendSocket(sSendStr: string);
begin
  CSocket.Socket.SendText(g_CodeHead + sSendStr + g_CodeEnd);
end;

procedure TREGClass.SetPublicID(sPublicID: string);
begin
  FPublicID := sPublicID;
end;

initialization
begin
  REGClass := TREGClass.Create;
  //OleInitialize(nil);
end;


finalization
begin
  REGClass.Free;
  {try
    OleUninitialize;
  except
  end;  }
end;

end.
