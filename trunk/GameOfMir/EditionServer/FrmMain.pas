unit FrmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, SEShare, Hutil32, 
  Dialogs, ComCtrls, StdCtrls, Buttons, INIFiles, JSocket, AppEvnts, WinSock, Share, ExtCtrls;

type
  TFormMain = class(TForm)
    GroupBox1: TGroupBox;
    tvFileList: TTreeView;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    mmoLog: TMemo;
    Label1: TLabel;
    edPass: TEdit;
    btSetPassWord: TButton;
    Label2: TLabel;
    cbAddrs: TComboBox;
    btAddAddrs: TButton;
    btDelAddrs: TButton;
    Label3: TLabel;
    edPort: TEdit;
    btStateServer: TButton;
    SSocket: TServerSocket;
    ApplicationEvents: TApplicationEvents;
    DecodeTimer: TTimer;
    Timer: TTimer;
    procedure btStateServerClick(Sender: TObject);
    procedure btSetPassWordClick(Sender: TObject);
    procedure ApplicationEventsException(Sender: TObject; E: Exception);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure edPortChange(Sender: TObject);
    procedure edPassChange(Sender: TObject);
    procedure btAddAddrsClick(Sender: TObject);
    procedure btDelAddrsClick(Sender: TObject);
    procedure SSocketListen(Sender: TObject; Socket: TCustomWinSocket);
    procedure SSocketClientError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure SSocketClientConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure SSocketClientDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure SSocketClientRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure TimerTimer(Sender: TObject);
    procedure DecodeTimerTimer(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    procedure SaveAddrList();
    function ScanFiles(): Integer;
    procedure ClearFileList();
    procedure ClearSessionArray();
    procedure InitializeUserSession(UserSession: pTUserSession);
    procedure SendDefMessage(UserSession: pTUserSession; wIdent: Word; nParam: Integer; DateTime: TDateTime = 0);
    procedure SendDefBuffer(UserSession: pTUserSession; wIdent, wParam, wTag: Word; Buffer: PChar; nLen: Integer);
    procedure SendDelayData(UserSession: pTUserSession);
    procedure AppendDelayData(UserSession: pTUserSession; DataBuffer: PChar; nDatLen: Integer);
    function GetAllFileListBuffer(out Buffer: PChar; out nBufferLen: Integer): Boolean;
    function GetFileBuffer(UserSession: pTUserSession; sFileName: string; FileTime: TDateTime; nDataIndex: Integer): Boolean;
    function GetFileBufferEx(UserSession: pTUserSession; sFileName: string): Boolean;
  public
    procedure MainOutMessage(sMsg: string);

  end;

const
  INIFILENAME = '.\SEdition.ini';

var
  FormMain: TFormMain;
  Ini: TIniFile;
  sPassWord: string = '';

implementation

{$R *.dfm}

uses
  MD5Unit, MyCommon;

procedure TFormMain.AppendDelayData(UserSession: pTUserSession; DataBuffer: PChar; nDatLen: Integer);
begin
  ReallocMem(UserSession.SendBuffer, UserSession.nSendLength + nDatLen);
  Move(DataBuffer^, UserSession.SendBuffer[UserSession.nSendLength], nDatLen);
  Inc(UserSession.nSendLength, nDatLen);
end;

procedure TFormMain.ApplicationEventsException(Sender: TObject; E: Exception);
begin
  MainOutMessage(E.Message);
end;

procedure TFormMain.SaveAddrList;
var
  I: Integer;
begin
  Ini.EraseSection('Addrs');
  for I := 0 to cbAddrs.Items.Count - 1 do begin
    Ini.WriteInteger('Addrs', cbAddrs.Items[I], Integer(cbAddrs.Items.Objects[I]));
  end;
end;

procedure TFormMain.ClearFileList;
var
  i: Integer;
  Sibling: TTreeNode;
  Data: PChar;
begin
  for I := 0 to tvFileList.Items.Count - 1 do begin
    Sibling := tvFileList.Items.Item[I];
    Data := PChar(Sibling.Data);
    if Data <> nil then
      FreeMem(Data);
  end;
  tvFileList.Items.Clear;
end;

procedure TFormMain.ClearSessionArray;
var
  i: Integer;
begin
  g_nSessionCount := 0;
  for I := Low(g_SessionArray) to High(g_SessionArray) do begin
    InitializeUserSession(@g_SessionArray[I]);
  end;
end;

procedure TFormMain.DecodeTimerTimer(Sender: TObject);
var
  I: Integer;
  UserSession: pTUserSession;
  DefMessage: pTDefMessage;
  Buff, TempBuff: PChar;
  nLen, nBufferLen: Integer;
  sStr, sPass: string;
begin
  if GetTickCount > g_dwCheckSessionTick then begin
    g_dwCheckSessionTick := GetTickCount + 2000;
    for I := Low(g_SessionArray) to High(g_SessionArray) do begin
      UserSession := @g_SessionArray[I];
      if (UserSession.Socket <> nil) and (not UserSession.boConnectCheck) then begin
        if (GetTickCount - UserSession.dwConnectTick) > 30 * 1000 then begin
          UserSession.Socket.Close;
          Continue;
        end;
      end;
    end;
  end;
  for I := Low(g_SessionArray) to High(g_SessionArray) do begin
    UserSession := @g_SessionArray[I];
    if (UserSession.Socket <> nil) and (UserSession.SendBuffer <> nil) then begin
      SendDelayData(UserSession);
    end
    else if (UserSession.Socket <> nil) and (UserSession.nReadLength >= SizeOf(TDefMessage)) then begin
      Buff := UserSession.ReadBuffer;
      nLen := UserSession.nReadLength;
      while (True) do begin
        if nLen >= SizeOf(TDefMessage) then begin
          DefMessage := pTDefMessage(Buff);
          if DefMessage.Recog = MSGHEADCODE then begin
            if (DefMessage.DataSize + SizeOf(TDefMessage)) > nLen then
              break;
            case DefMessage.Ident of
              SEC_PASS_GETFILE: begin
                  TempBuff := PChar(@Buff[SizeOf(TDefMessage)]);
                  sStr := Strpas(TempBuff);
                  sStr := GetValidStr3(sStr, sPass, ['/']);
                  if sPass = sPassword then begin
                    if not GetFileBufferEx(UserSession, sStr) then
                      SendDefMessage(UserSession, SEC_PASS_GETFILE_FAIL, 0);
                  end;
                end;
              SEC_CHECKPASS: begin
                  if (not UserSession.boConnectCheck) and (DefMessage.DataSize > 0) then begin
                    TempBuff := PChar(@Buff[SizeOf(TDefMessage)]);
                    if Strpas(TempBuff) = sPassword then begin
                      UserSession.boConnectCheck := True;
                      SendDefMessage(UserSession, SES_CHECKPASS_OK, 0);
                    end
                    else begin
                      SendDefMessage(UserSession, SES_CHECKPASS_FAIR, 0);
                    end;
                  end
                  else
                    SendDefMessage(UserSession, SES_CHECKPASS_FAIR, 0);
                end;
              SEC_GETFILELIST: begin
                  if UserSession.boConnectCheck then begin
                    if GetAllFileListBuffer(TempBuff, nBufferLen) and (nBufferLen > 0) then begin
                      SendDefBuffer(UserSession, SES_FILELIST, 0, 0, TempBuff, nBufferLen);
                      FreeMem(TempBuff);
                    end
                    else
                      SendDefMessage(UserSession, SES_FILELIST, 0);
                  end;
                end;
              SEC_GETFILE: begin
                  if UserSession.boConnectCheck and (DefMessage.DataSize > 0) then begin
                    TempBuff := PChar(@Buff[SizeOf(TDefMessage)]);
                    if not GetFileBuffer(UserSession, TempBuff, DefMessage.DataTime, DefMessage.Param) then
                      SendDefMessage(UserSession, SES_FILE, DefMessage.Param);
                  end;
                end;
            end;
            FreeMem(UserSession.ReadBuffer);
            UserSession.ReadBuffer := nil;
            UserSession.nReadLength := 0;
            nLen := 0;
            break;
          end
          else begin
            Inc(Buff);
            Dec(nLen);
          end;
        end
        else
          break;
      end;
      if nLen > 0 then begin
        if UserSession.nReadLength = nLen then
          exit;
        GetMem(TempBuff, nLen);
        Move(Buff^, TempBuff^, nLen);
        FreeMem(UserSession.ReadBuffer);
        UserSession.ReadBuffer := TempBuff;
        UserSession.nReadLength := nLen;
      end
      else begin
        if UserSession.ReadBuffer <> nil then
          FreeMem(UserSession.ReadBuffer);
        UserSession.ReadBuffer := nil;
        UserSession.nReadLength := 0;
      end;
    end;
  end;
end;

function TFormMain.ScanFiles: Integer;
  function GetNamePChar(sName: string): PChar;
  begin
    Result := AllocMem(Length(sName) + 1);
    Move(sName[1], Result[0], Length(sName));
  end;
  procedure AddExeToList(Sibling: TTreeNode; sExeName: string);
  begin
    if FileExists('.\Envir\' + sExeName) then
      tvFileList.Items.AddChildObject(Sibling, sExeName, GetNamePChar(sExeName));
  end;
var
  sr: TSearchRec;
  I: Integer;
  DirList, SaveDirList: TStringList;
  FileList: TStringList;
  DirName, SaveDirName: string;
  Sibling: TTreeNode;
begin
  Result := 0;
  DirList := TStringList.Create;
  FileList := TStringList.Create;
  SaveDirList := TStringList.Create;
  ClearFileList;
  {Sibling := tvFileList.Items.Add(nil, '服务端程序');
  AddExeToList(Sibling, 'EXE\M2Server.exe');
  AddExeToList(Sibling, 'EXE\DBServer.exe');
  AddExeToList(Sibling, 'EXE\LoginSrv.exe');
  AddExeToList(Sibling, 'EXE\LogDataServer.exe');
  AddExeToList(Sibling, 'EXE\RunGate.exe');
  AddExeToList(Sibling, 'EXE\SelGate.exe');
  AddExeToList(Sibling, 'EXE\LoginGate.exe');      }
  Sibling := tvFileList.Items.Add(nil, '服务端文件');
  try
    DirList.AddObject('.\Envir\', TObject(Sibling));
    SaveDirList.Add(' ');
    while DirList.Count > 0 do begin
      DirName := DirList[0];
      Sibling := TTreeNode(DirList.Objects[0]);
      SaveDirName := Trim(SaveDirList[0]);
      SaveDirList.Delete(0);
      DirList.Delete(0);
      I := FindFirst(DirName + '*.*', faAnyFile, sr);
      FileList.Clear;
      while I = 0 do begin
        if (Sr.Attr and faDirectory) = 0 then begin
          if sr.Name[1] <> '.' then begin
            FileList.Add(sr.Name);
          end;
        end
        else if (Sr.Attr and faDirectory) = faDirectory then begin
          if sr.Name[1] <> '.' then begin
            SaveDirList.Add(SaveDirName + sr.Name + '\');
            DirList.AddObject(DirName + sr.Name + '\', TObject(tvFileList.Items.AddChild(Sibling, sr.Name)));
          end;
        end;
        I := FindNext(sr);
      end;
      for I := 0 to FileList.Count - 1 do begin
        tvFileList.Items.AddChildObject(Sibling, FileList[i], GetNamePChar(SaveDirName + FileList[i]));
      end;
      FindClose(sr);
    end;
  finally
    DirList.Free;
    FileList.Free;
    SaveDirList.Free;
  end;
end;

procedure TFormMain.SendDefBuffer(UserSession: pTUserSession; wIdent, wParam, wTag: Word; Buffer: PChar; nLen: Integer);
var
  DefMessage: TDefMessage;
  SendBuffer: PChar;
begin
  DefMessage := MakeDefMessage(wIdent, wParam, Now, nLen);
  SendBuffer := AllocMem(SizeOf(TDefMessage) + nLen);
  Move(DefMessage, SendBuffer^, SizeOf(TDefMessage));
  Move(Buffer^, SendBuffer[SizeOf(TDefMessage)], nLen);
  try
    if UserSession.Socket.Connected then begin
      if UserSession.nSendLength > 0 then begin
        AppendDelayData(UserSession, SendBuffer, SizeOf(TDefMessage) + nLen);
      end else
      if UserSession.Socket.SendBuf(SendBuffer^, SizeOf(TDefMessage) + nLen) = -1 then
        AppendDelayData(UserSession, SendBuffer, SizeOf(TDefMessage) + nLen);
    end;
  finally
    FreeMem(SendBuffer);
  end;
end;

procedure TFormMain.SendDefMessage(UserSession: pTUserSession; wIdent: Word; nParam: Integer; DateTime: TDateTime);
var
  DefMessage: TDefMessage;
  SendBuffer: PChar;
begin
  DefMessage := MakeDefMessage(wIdent, nParam, DateTime, 0);
  SendBuffer := AllocMem(SizeOf(TDefMessage));
  Move(DefMessage, SendBuffer^, SizeOf(TDefMessage));
  try
    if UserSession.Socket.Connected then begin
      if UserSession.nSendLength > 0 then begin
        AppendDelayData(UserSession, SendBuffer, SizeOf(TDefMessage));
      end else
      if UserSession.Socket.SendBuf(SendBuffer^, SizeOf(TDefMessage)) = -1 then
        AppendDelayData(UserSession, SendBuffer, SizeOf(TDefMessage));
    end;
  finally
    FreeMem(SendBuffer);
  end;
end;

procedure TFormMain.SendDelayData(UserSession: pTUserSession);
const
  MAXSENDSIZE = 8192;
var
  TempBuff: PChar;
  nSendLength: Integer;
  SendBuffer: PChar;
begin
  nSendLength := UserSession.nSendLength;
  SendBuffer := UserSession.SendBuffer;
  while True do begin
    if nSendLength <= 0 then break;
    if nSendLength > MAXSENDSIZE then begin
      if UserSession.Socket.Connected then begin
        if UserSession.Socket.SendBuf(SendBuffer^, MAXSENDSIZE) <> -1 then begin
          SendBuffer := PChar(Integer(SendBuffer) + MAXSENDSIZE);
          Dec(nSendLength, MAXSENDSIZE);
        end else
          break;
      end else begin
        nSendLength := 0;
        break;
      end;
    end
    else begin
      if UserSession.Socket.Connected then begin
        if UserSession.Socket.SendBuf(SendBuffer^, nSendLength) <> -1 then begin
          FreeMem(UserSession.SendBuffer);
          UserSession.SendBuffer := nil;
          UserSession.nSendLength := 0;
          nSendLength := 0;
        end;
      end else begin
        FreeMem(UserSession.SendBuffer);
        UserSession.SendBuffer := nil;
        UserSession.nSendLength := 0;
        nSendLength := 0;
      end;
      break;
    end;
  end;
  if nSendLength <> UserSession.nSendLength then begin
    if nSendLength > 0 then begin
      GetMem(TempBuff, nSendLength);
      Move(SendBuffer^, TempBuff^, nSendLength);
      FreeMem(UserSession.SendBuffer);
      UserSession.SendBuffer := TempBuff;
      UserSession.nSendLength := nSendLength;
    end else begin
      FreeMem(UserSession.SendBuffer);
      UserSession.SendBuffer := nil;
      UserSession.nSendLength := 0;
    end;
  end;

end;

procedure TFormMain.SSocketClientConnect(Sender: TObject; Socket: TCustomWinSocket);
  function IsAllowIP(sRemoteIPaddr: string): Boolean;
  var
    nIPaddr: Integer;
    I: Integer;
  begin
    Result := False;
    nIPaddr := inet_addr(PChar(sRemoteIPaddr));
    if nIPaddr <> -1 then begin
      for I := 0 to cbAddrs.Items.Count - 1 do begin
        if nIPaddr = Integer(cbAddrs.Items.Objects[I]) then begin
          Result := True;
          Break;
        end;
      end;
    end;
  end;
var
  UserSession: pTUserSession;
  sRemoteIPaddr: string;
  nSockIndex: Integer;
begin
  Socket.nIndex := -1;
  sRemoteIPaddr := Socket.RemoteAddress;

  if not IsAllowIP(sRemoteIPaddr) then begin
    MainOutMessage('非法连接: ' + sRemoteIPaddr);
    Socket.Close;
    Exit;
  end;

  for nSockIndex := Low(g_SessionArray) to High(g_SessionArray) do begin
    UserSession := @g_SessionArray[nSockIndex];
    if UserSession.Socket = nil then begin
      InitializeUserSession(UserSession);
      UserSession.Socket := Socket;
      UserSession.SocketHandle := Socket.SocketHandle;
      UserSession.sRemoteIPaddr := sRemoteIPaddr;
      UserSession.dwConnectTick := GetTickCount;
      Socket.nIndex := nSockIndex;
      break;
    end;
  end;
  if Socket.nIndex >= 0 then begin
    MainOutMessage('连接: ' + sRemoteIPaddr);
    Inc(g_nSessionCount);
  end
  else begin
    Socket.Close;
    MainOutMessage('满员: ' + sRemoteIPaddr);
  end;
end;

procedure TFormMain.SSocketClientDisconnect(Sender: TObject; Socket: TCustomWinSocket);
var
  nSockIndex: Integer;
begin
  nSockIndex := Socket.nIndex;
  if nSockIndex in [Low(g_SessionArray)..High(g_SessionArray)] then begin
    MainOutMessage('断开: ' + g_SessionArray[nSockIndex].sRemoteIPaddr);
    InitializeUserSession(@g_SessionArray[nSockIndex]);
    Dec(g_nSessionCount);
  end;
end;

procedure TFormMain.SSocketClientError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
  Socket.Close;
  ErrorCode := 0;
end;

procedure TFormMain.SSocketClientRead(Sender: TObject; Socket: TCustomWinSocket);
var
  nSockIndex: Integer;
  UserSession: pTUserSession;
  nMsgLen: Integer;
  RecvBuffer: PChar;
begin
  nSockIndex := Socket.nIndex;
  if nSockIndex in [Low(g_SessionArray)..High(g_SessionArray)] then begin
    UserSession := @g_SessionArray[nSockIndex];
    if UserSession.Socket = Socket then begin
      nMsgLen := Socket.ReceiveLength;
      if (nMsgLen + UserSession.nReadLength) < MAXREADSIZE then begin
        GetMem(RecvBuffer, nMsgLen);
        nMsgLen := Socket.ReceiveBuf(RecvBuffer^, nMsgLen);
        ReallocMem(UserSession.ReadBuffer, UserSession.nReadLength + nMsgLen);
        Move(RecvBuffer^, UserSession.ReadBuffer[UserSession.nReadLength], nMsgLen);
        Inc(UserSession.nReadLength, nMsgLen);
        FreeMem(RecvBuffer);
      end
      else begin
        MainOutMessage('超长: ' + UserSession.sRemoteIPaddr + ' ' + IntToStr(nMsgLen + UserSession.nReadLength));
        Socket.Close;
      end;
    end;
  end;
end;

procedure TFormMain.SSocketListen(Sender: TObject; Socket: TCustomWinSocket);
begin
  MainOutMessage(Format('开始监听[%s:%d]...', [Socket.LocalAddress, Socket.LocalPort]));
  DecodeTimer.Enabled := True;
  Timer.Enabled := True;
end;

procedure TFormMain.TimerTimer(Sender: TObject);
begin
  GroupBox3.Caption := '日志窗口(连接数量：' + IntToStr(g_nSessionCount) + ')'
end;

procedure TFormMain.btAddAddrsClick(Sender: TObject);
var
  nIPaddr, I: Integer;
begin
  nIPaddr := inet_addr(PChar(Trim(cbAddrs.Text)));
  if nIPaddr = -1 then
    exit;
  for I := 0 to cbAddrs.Items.Count - 1 do begin
    if nIPaddr = Integer(cbAddrs.Items.Objects[I]) then
      exit;
  end;
  cbAddrs.Items.AddObject(Trim(cbAddrs.Text), TObject(nIPaddr));
  SaveAddrList;
  cbAddrs.Text := Format('允许地址：%d', [cbAddrs.Items.Count]);
end;

procedure TFormMain.btDelAddrsClick(Sender: TObject);
begin
  if (cbAddrs.ItemIndex >= 0) and (cbAddrs.ItemIndex < cbAddrs.Items.Count) then begin
    cbAddrs.Items.Delete(cbAddrs.ItemIndex);
    SaveAddrList;
  end;
  cbAddrs.Text := Format('允许地址：%d', [cbAddrs.Items.Count]);
end;

procedure TFormMain.btSetPassWordClick(Sender: TObject);
begin
  edPass.Text := GetMD5TextOf16(DateTimeToStr(Now));
end;

procedure TFormMain.btStateServerClick(Sender: TObject);
begin
  if Trim(edPass.Text) = '' then begin
  end;
  sPassword := GetMD5TextOf16(Trim(edPass.Text));
  btStateServer.Enabled := False;
  DecodeTimer.Enabled := False;
  Timer.Enabled := False;
  GroupBox3.Caption := '日志窗口';
  if SSocket.Active then begin
    btStateServer.Caption := '正在停止..';
    MainOutMessage('正在停止服务...');
    SSocket.Active := False;
    ClearSessionArray;
    g_nSessionCount := 0;
    MainOutMessage('服务已停止...');
  end
  else begin
    btStateServer.Caption := '正在启动..';
    MainOutMessage('正在启动服务...');
    MainOutMessage('正在扫描文件列表...');
    ScanFiles;
    ClearSessionArray;
    g_nSessionCount := 0;
    SSocket.Port := StrToIntDef(edPort.Text, 18888);
    SSocket.Active := True;
    MainOutMessage('服务启动完成...');
  end;

  if SSocket.Active then begin
    btStateServer.Caption := '停止服务(&S)';
    edPort.Enabled := False;
    edPass.Enabled := False;
    btSetPassWord.Enabled := False;
  end
  else begin
    btStateServer.Caption := '启动服务(&S)';
    edPort.Enabled := True;
    edPass.Enabled := True;
    btSetPassWord.Enabled := True;
  end;
  btStateServer.Enabled := True;
end;

procedure TFormMain.edPassChange(Sender: TObject);
begin
  Ini.WriteString('Setup', 'PassWord', edPass.Text);
end;

procedure TFormMain.edPortChange(Sender: TObject);
begin
  Ini.WriteString('Setup', 'Port', edPort.Text);
end;

procedure TFormMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if Application.MessageBox(PChar('是否确认关闭' + Caption + '程序?'), '确认信息', MB_OKCANCEL + MB_ICONQUESTION) = IDCANCEL then
  begin
    CanClose := False;
  end;
end;

procedure TFormMain.FormCreate(Sender: TObject);
var
  ValueList: TStringList;
  sAddr: string;
  nIPaddr: Integer;
begin
  mmoLog.Lines.Clear;
  cbAddrs.Clear;
  Ini := TIniFile.Create(INIFILENAME);
  edPort.Text := Ini.ReadString('Setup', 'Port', '18888');
  edPass.Text := Ini.ReadString('Setup', 'PassWord', '123456');
  ValueList := TStringList.Create;
  Ini.ReadSection('Addrs', ValueList);
  for sAddr in ValueList do begin
    nIPaddr := inet_addr(PChar(Trim(sAddr)));
    if nIPaddr <> -1 then begin
      cbAddrs.Items.AddObject(Trim(sAddr), TObject(nIPaddr));
    end;
  end;
  cbAddrs.Text := Format('允许地址：%d', [cbAddrs.Items.Count]);
  ValueList.Free;
  FillChar(g_SessionArray, SizeOf(g_SessionArray), #0);
end;

procedure TFormMain.FormDestroy(Sender: TObject);
begin
  ClearSessionArray;
  ClearFileList;
  Ini.Free;
end;

function TFormMain.GetAllFileListBuffer(out Buffer: PChar; out nBufferLen: Integer): Boolean;
var
  FileList: TStringList;
  Sibling: TTreeNode;
  sFileName: string;
  FileTime: TDateTime;
  dwFileHandle: HFILE;
  LastWriteTime: _FileTime;
  PSendBuffer: PChar;
begin
  Result := False;
  Buffer := nil;
  nBufferLen := 0;
  FileList := TStringList.Create;
  try
    for Sibling in tvFileList.Items do begin
      if Sibling.Data <> nil then begin
        sFileName := PChar(Sibling.Data);
        dwFileHandle := FileOpen('.\Envir\' + sFileName, fmOpenRead or fmShareDenyNone);
        try
          if dwFileHandle > 0 then begin
            if GetFileTime(dwFileHandle, nil, nil, @LastWriteTime) then begin
              FileTime := CovFileDate(LastWriteTime); //取文件上次修改时间
              FileList.Add(sFileName + #9 + FormatDateTime('yyyy-mm-dd hh:mm:ss', FileTime));
              Result := True;
            end;
          end;
        finally
          FileClose(dwFileHandle);
        end;
      end;
    end;
    if Result then begin
      PSendBuffer := FileList.GetText;
      nBufferLen := Length(PSendBuffer) + 1;
      Buffer := AllocMem(nBufferLen);
      Move(PSendBuffer^, Buffer^, nBufferLen);
      StrDispose(PSendBuffer);
    end;
  finally
    FileList.Free;
  end;
end;

function TFormMain.GetFileBufferEx(UserSession: pTUserSession; sFileName: string): Boolean;
var
  dwFileHandle: THandle;
  FileBuffer: PChar;
  nFileSize: Integer;
  SendBuffer: PChar;
  DefMessage: TDefMessage;
begin
  Result := False;
  if FileExists('.\Envir\' + sFileName) then begin
    dwFileHandle := FileOpen('.\Envir\' + sFileName, fmOpenRead or fmShareDenyWrite);
    if dwFileHandle > 0 then begin
      nFileSize := FileSeek(dwFileHandle, 0, soFromEnd);
      FileSeek(dwFileHandle, 0, soFromBeginning);
      GetMem(FileBuffer, nFileSize);
      Try
        if FileRead(dwFileHandle, FileBuffer^, nFileSize) = nFileSize then begin
          DefMessage := MakeDefMessage(SES_FILE, 0, 0, nFileSize);
          GetMem(SendBuffer, SizeOf(TDefMessage) + nFileSize);
          Try
            Move(DefMessage, SendBuffer^, SizeOf(TDefMessage));
            Move(FileBuffer^, SendBuffer[SizeOf(TDefMessage)], nFileSize);
            AppendDelayData(UserSession, SendBuffer, SizeOf(TDefMessage) + nFileSize);
          Finally
            FreeMem(SendBuffer);
          End;
        end;
      Finally
        FreeMem(FileBuffer, nFileSize);
        FileClose(dwFileHandle);
      End;
    end;
  end;
end;

function TFormMain.GetFileBuffer(UserSession: pTUserSession; sFileName: string; FileTime: TDateTime;
  nDataIndex: Integer): Boolean;
var
  dwFileHandle: HFILE;
  dwFileTime: TDateTime;
  LastWriteTime: _FileTime;
  FileBuffer: PChar;
  nFileSize: Integer;
  DefMessage: TDefMessage;
  SendBuffer: PChar;
begin
  Result := False;
  dwFileHandle := FileOpen('.\Envir\' + sFileName, fmOpenRead or fmShareDenyWrite);
  try
    if dwFileHandle > 0 then begin
      if GetFileTime(dwFileHandle, nil, nil, @LastWriteTime) then begin
        dwFileTime := CovFileDate(LastWriteTime); //取文件上次修改时间
        if dwFileTime > FileTime then begin
          nFileSize := FileSeek(dwFileHandle, 0, soFromEnd);
          if nFileSize > 0 then begin
            FileSeek(dwFileHandle, 0, soFromBeginning);
            GetMem(FileBuffer, nFileSize);
            Try
              if FileRead(dwFileHandle, FileBuffer^, nFileSize) = nFileSize then begin
                DefMessage := MakeDefMessage(SES_FILE, nDataIndex, dwFileTime, nFileSize);
                GetMem(SendBuffer, SizeOf(TDefMessage) + nFileSize);
                Try
                  Move(DefMessage, SendBuffer^, SizeOf(TDefMessage));
                  Move(FileBuffer^, SendBuffer[SizeOf(TDefMessage)], nFileSize);
                  AppendDelayData(UserSession, SendBuffer, SizeOf(TDefMessage) + nFileSize);
                Finally
                  FreeMem(SendBuffer);
                End;
              end;
            Finally
              FreeMem(FileBuffer);
            End;
          end else
            SendDefMessage(UserSession, SES_FILE, nDataIndex, dwFileTime);
        end else
          SendDefMessage(UserSession, SES_FILE, nDataIndex, FileTime);
        Result := True;
      end;
    end;
  finally
    FileClose(dwFileHandle);
  end;
end;

procedure TFormMain.InitializeUserSession(UserSession: pTUserSession);
begin
  UserSession.Socket := nil;
  UserSession.SocketHandle := -1;
  UserSession.sRemoteIPaddr := '';

  if UserSession.ReadBuffer <> nil then
    FreeMem(UserSession.ReadBuffer);
  UserSession.ReadBuffer := nil;
  UserSession.nReadLength := 0;

  if UserSession.FileStream <> nil then
    UserSession.FileStream.Free;
  UserSession.FileStream := nil;

  if UserSession.SendBuffer <> nil then
    FreeMem(UserSession.SendBuffer);
  UserSession.SendBuffer := nil;
  UserSession.nSendLength := 0;

  UserSession.boConnectCheck := False;
  UserSession.dwConnectTick := 0;
end;

procedure TFormMain.MainOutMessage(sMsg: string);
begin
  if sMsg = '' then
    exit;
  if mmoLog.Lines.Count > 200 then
    mmoLog.Lines.Delete(0);
  mmoLog.Lines.Add(FormatDateTime('[DD HH:MM:SS] ', Now) + sMsg);
end;

end.

