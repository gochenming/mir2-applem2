unit FrmMain;

interface

uses
  Windows, Messages, SysUtils, StrUtils, Variants, Classes, Graphics, Controls, Forms, Hutil32, SCShare, EDCode, GeneralCommon,
  Dialogs, StdCtrls, ComCtrls, Menus, RSA, JSocket, DB, ADODB, AppEvnts, ExtCtrls, MD5Unit;

const
  UPLOADTEMP = '.\UploadTemp\';
  UPLOADFILES = '.\UploadFiles\';

type

  TUploadFileInfo = packed record
    sFileName: string;
    sTempFileName: string;
    nFileSize: Integer;
    nClassID: Integer;
  end;

  pTUserSession = ^TUserSession;
  TUserSession = packed record
    sUserName: string;
    Socket: TCustomWinSocket;
    RemoteAddress: string;
    sReadStr: string;
    sWriteStr: string;
    nMark: Integer;
    boAdmin: Boolean;
    dwSuspendedCount: Integer;
    dwSuspendedTick: LongWord;
    dwCheckConnTick: LongWord;
    UploadInfo: TUploadFileInfo;
  end;



  TFormMain = class(TForm)
    MainMenu1: TMainMenu;
    H1: TMenuItem;
    A2: TMenuItem;
    GroupBox1: TGroupBox;
    MemoLog: TMemo;
    StatusBar: TStatusBar;
    ShareRSA: TRSA;
    SSocket: TServerSocket;
    ADOQuery: TADOQuery;
    ApplicationEvents1: TApplicationEvents;
    StateTimer: TTimer;
    Timer1: TTimer;
    Timer2: TTimer;
    O1: TMenuItem;
    R1: TMenuItem;
    V1: TMenuItem;
    procedure ApplicationEvents1Exception(Sender: TObject; E: Exception);
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure StateTimerTimer(Sender: TObject);
    procedure SSocketClientConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure SSocketClientDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure SSocketClientRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure SSocketClientError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure SSocketListen(Sender: TObject; Socket: TCustomWinSocket);
    procedure Timer2Timer(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure V1Click(Sender: TObject);
  private
    FboRun: Boolean;
    FSection: TRTLCriticalSection;
    FDefMsg: TDefaultMessage;
    procedure DecodeGateData(UserSession: pTUserSession);
    function SendGateData(UserSession: pTUserSession): Boolean;
    procedure GetSharePassword(UserSession: pTUserSession);
    procedure GetUserName(UserSession: pTUserSession; sData: string);
    procedure GetUserUpFileData(UserSession: pTUserSession; Msg: pTDefaultMessage; sData: string);
    procedure GetFileList(UserSession: pTUserSession; Msg: pTDefaultMessage);
    procedure SendSocket(UserSession: pTUserSession; sMsg: string);
    procedure GetDownFile(UserSession: pTUserSession; nID: Integer);

  public
    procedure MainOutMessage(sMsg: string);
    procedure Lock();
    procedure UnLock();
  end;

var
  FormMain: TFormMain;

implementation

uses FrmUploadList;

{$R *.dfm}

procedure TFormMain.ApplicationEvents1Exception(Sender: TObject; E: Exception);
begin
  MainOutMessage(E.Message);
end;

procedure TFormMain.DecodeGateData(UserSession: pTUserSession);
var
  sReadData: string;
  sDefMsg: string;
  sData: string;
  sMsg: string;
  DefMsg: TDefaultMessage;
begin
  sReadData := UserSession.sReadStr;
  UserSession.sReadStr := '';
  try
    while sReadData <> '' do begin
      sReadData := ArrestStringEx(sReadData, g_CodeHead, g_CodeEnd, sMsg);
      if sMsg = '' then Break;
      if Length(sMsg) >= DEFBLOCKSIZE then begin
        sDefMsg := Copy(sMsg, 1, DEFBLOCKSIZE);
        sData := Copy(sMsg, DEFBLOCKSIZE + 1, length(sMsg) - DEFBLOCKSIZE);
        DefMsg := DecodeMessage(sDefMsg);
        case DefMsg.Ident of
          CM_TOOLS_GETSHAREPASS: GetSharePassword(UserSession);
          CM_TOOLS_SENDUSERNAME: GetUserName(UserSession, sData);
          CM_SHARE_UPFILE: GetUserUpFileData(UserSession, @DefMsg, sData);
          CM_SHARE_GETLIST: GetFileList(UserSession, @DefMsg);
          CM_SHARE_DOWNFILE: GetDownFile(UserSession, DefMsg.Recog);
        end;
      end;
    end;
  finally
    UserSession.sReadStr := sReadData;
  end;
end;

procedure TFormMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := False;
  if Application.MessageBox('是否确定关闭工具服务器？', '提示信息', MB_OKCANCEL + MB_ICONQUESTION) = IDOK then
  begin
    CanClose := True;
  end;
end;

procedure TFormMain.FormCreate(Sender: TObject);
begin
  Randomize;

  InitializeCriticalSection(FSection);
  FboRun := False;
  MemoLog.Lines.Clear;
  MainOutMessage('正在启动服务...');
  ADOQuery.ConnectionString := 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=ToolDB.mdb;Persist Security Info=False';
  CreateDir(UPLOADTEMP);
  CreateDir(UPLOADFILES);
end;

procedure TFormMain.FormDestroy(Sender: TObject);
var
  I: Integer;
begin
  for I := SSocket.Socket.ConnectCount - 1 downto 0 do
    SSocket.Socket.Connections[I].Close;
  DeleteCriticalSection(FSection);
end;

procedure TFormMain.GetSharePassword(UserSession: pTUserSession);
begin
  UserSession.nMark := Random(999999);
  FDefMsg := MakeDefaultMsg(SM_SETTOOLMARK, 0, 0, 0, 0);
  SendSocket(UserSession, EncodeMessage(FDefMsg) + ShareRSA.EncryptStr(IntToStr(UserSession.nMark)));
end;

procedure TFormMain.GetUserName(UserSession: pTUserSession; sData: string);
var
  sUserName: string;
  sMark, sAdmin: string;
begin

  sData := ShareRSA.DecryptStr(sData);
  sData := GetValidStr3(sData, sMark, ['/']);
  sUserName := GetValidStr3(sData, sAdmin, ['/']);
  if StrToIntDef(sMark, 0) = UserSession.nMark then begin
    UserSession.sUserName := sUserName;
    UserSession.boAdmin := sAdmin = '1';
    FDefMsg := MakeDefaultMsg(SM_SHARE_LOGON_OK, 0, 0, 0, 0);
    SendSocket(UserSession, EncodeMessage(FDefMsg));
  end;
end;

procedure TFormMain.GetDownFile(UserSession: pTUserSession; nID: Integer);
const
  READSIZE = 6000;
var
  sFileName: string;
  FileHandle: THandle;
  DataBuffer: PChar;
  nReadSize, nFileSize: Integer;
begin
  if UserSession.sUserName <> '' then begin
    ADOQuery.SQL.Clear;
    ADOQuery.SQL.Add('select ID, FileName from FileList where ID = ' + IntToStr(nID));
    ADOQuery.Open;
    try
      if ADOQuery.RecordCount > 0 then begin
        sFileName := ADOQuery.FieldByName('FileName').AsString;
        if FileExists(sFileName) then begin
          FileHandle := FileOpen(sFileName, fmOpenRead or fmShareDenyWrite);
          GetMem(DataBuffer, READSIZE);
          Try
            if FileHandle > 0 then begin
              nFileSize := FileSeek(FileHandle, 0, 2);
              FileSeek(FileHandle, 0, 0);
              while True do begin
                nReadSize := FileRead(FileHandle, DataBuffer^, READSIZE);
                if nReadSize = READSIZE then begin
                  FDefMsg := MakeDefaultMsg(SM_SHARE_DOWNFILE_DATA, nReadSize, LoWord(nFileSize), HiWord(nFileSize), 0);
                end else begin
                  FDefMsg := MakeDefaultMsg(SM_SHARE_DOWNFILE_DATA, nReadSize, LoWord(nFileSize), HiWord(nFileSize), 1);
                end;
                SendSocket(UserSession, EncodeMessage(FDefMsg) + EncodeBuffer(DataBuffer, nReadSize));
                if nReadSize <> READSIZE then break;
              end; 
            end else begin
              FDefMsg := MakeDefaultMsg(SM_SHARE_DOWNFILE_FAIL, 0, 0, 0, 0);
              SendSocket(UserSession, EncodeMessage(FDefMsg) + EncodeString('获取文件数据失败...'));
            end;
          Finally
            FreeMem(DataBuffer, READSIZE);
            FileClose(FileHandle);
          End;
        end else begin
          FDefMsg := MakeDefaultMsg(SM_SHARE_DOWNFILE_FAIL, 0, 0, 0, 0);
          SendSocket(UserSession, EncodeMessage(FDefMsg) + EncodeString('下载的文件已被管理员删除...'));
        end;
      end else begin
        FDefMsg := MakeDefaultMsg(SM_SHARE_DOWNFILE_FAIL, 0, 0, 0, 0);
        SendSocket(UserSession, EncodeMessage(FDefMsg) + EncodeString('下载的文件数据不存在...'));
      end;
    finally
      ADOQuery.Close;
    end;
  end;
end;

procedure TFormMain.GetFileList(UserSession: pTUserSession; Msg: pTDefaultMessage);
var
  I: Integer;
  sSendMsg, sData: string;
begin
  if UserSession.sUserName <> '' then begin

    ADOQuery.SQL.Clear;
    ADOQuery.SQL.Add('select * from FileList where IsAdmin = True and ClassID = ' + IntToStr(Msg.Series) + ' and ID > ' + IntToStr(Msg.Recog) + ' order by ID');
    ADOQuery.Open;
    try
      sSendMsg := '';
      for I := 0 to ADOQuery.RecordCount - 1 do begin
        sData := IntToStr(ADOQuery.FieldByName('ID').AsInteger) + '/';
        sData := sData + IntToStr(ADOQuery.FieldByName('FileSize').AsInteger) + '/';
        sData := sData + ADOQuery.FieldByName('ShowFileName').AsString + '/';
        sData := sData + DateTimeToStr(ADOQuery.FieldByName('CreateTime').AsDateTime) + '/';
        sSendMsg := sSendMsg + EncodeString(sData) + '/';
        ADOQuery.Next;
      end;
    finally
      ADOQuery.Close;
    end;
    if sSendMsg <> '' then begin
      FDefMsg := MakeDefaultMsg(SM_SHARE_FILELIST, 1, 0, 0, Msg.Series);
      SendSocket(UserSession, EncodeMessage(FDefMsg) + sSendMsg);
    end;

    ADOQuery.SQL.Clear;
    ADOQuery.SQL.Add('select * from FileList where IsAdmin = False and ClassID = ' + IntToStr(Msg.Series) + ' and ID > ' + IntToStr(MakeLong(Msg.Param, Msg.tag)) + ' order by ID');
    ADOQuery.Open;
    try
      sSendMsg := '';
      for I := 0 to ADOQuery.RecordCount - 1 do begin
        sData := IntToStr(ADOQuery.FieldByName('ID').AsInteger) + '/';
        sData := sData + IntToStr(ADOQuery.FieldByName('FileSize').AsInteger) + '/';
        sData := sData + ADOQuery.FieldByName('ShowFileName').AsString + '/';
        sData := sData + DateTimeToStr(ADOQuery.FieldByName('CreateTime').AsDateTime) + '/';
        sData := sData + ADOQuery.FieldByName('UpName').AsString + '/';
        sSendMsg := sSendMsg + EncodeString(sData) + '/';
        ADOQuery.Next;
      end;
    finally
      ADOQuery.Close;
    end;

    if sSendMsg <> '' then begin
      FDefMsg := MakeDefaultMsg(SM_SHARE_FILELIST, 0, 0, 0, Msg.Series);
      SendSocket(UserSession, EncodeMessage(FDefMsg) + sSendMsg);
    end;
  end;
end;

procedure TFormMain.GetUserUpFileData(UserSession: pTUserSession; Msg: pTDefaultMessage; sData: string);
  function GetNewFileName(sOldName: string): string;
  var
    sExt: string;
    nIndex: Integer;
  begin
    sExt := ExtractFileExt(sOldName);
    Result := Copy(sOldName, 1, Length(sOldName) - Length(sExt));
    nIndex := 1;
    while True do begin
      if not FileExists(Result + '(' + IntToStr(nIndex) + ')' + sExt) then begin
        Result := Result + '(' + IntToStr(nIndex) + ')' + sExt;
        Exit;
      end;
      Inc(nIndex);
    end;
  end;
var
  sFileName, sExt, sSaveFileName: string;
  FileHandle: THandle;
  DataBuffer: PChar;
  nWriteSize: Integer;
begin
  if UserSession.sUserName <> '' then begin
    if (Msg.Recog > 0) and (Msg.Series = 0) then begin
      UserSession.UploadInfo.sFileName := '';
      UserSession.UploadInfo.nFileSize := -1;
      UserSession.UploadInfo.nClassID := -1;
      sFileName := DecodeString(sData);
      if (sFileName <> '') and ((Msg.Recog <= MAX_UPFILESIZE) or UserSession.boAdmin) then begin
        sExt := ExtractFileExt(sFileName);
        if (CompareText(sExt, '.txt') = 0) or (CompareText(sExt, '.rar') = 0) then begin
          UserSession.UploadInfo.sTempFileName := UPLOADTEMP + GetMD5Text(sFileName + UserSession.sUserName + DateTimeToStr(Now) + IntToStr(Random(999999)) + IntToStr(Msg.Recog));
          FileHandle := FileCreate(UserSession.UploadInfo.sTempFileName);
          if FileHandle > 0 then begin
            UserSession.UploadInfo.sFileName := sFileName;
            UserSession.UploadInfo.nFileSize := Msg.Recog;
            UserSession.UploadInfo.nClassID := Msg.Param;
            FileClose(FileHandle);
          end;
        end;
      end;
    end else
    if (Msg.Recog > 0) and (Msg.Series > 0) and (sData <> '') then begin
      if (UserSession.UploadInfo.nFileSize = Msg.Recog) and (UserSession.UploadInfo.sFileName <> '') and (UserSession.UploadInfo.sTempFileName <> '') then begin
        nWriteSize := MakeLong(Msg.Param, Msg.tag);
        if ((nWriteSize + Msg.Series) <= Msg.Recog) and (Msg.Series < 8000) then begin
          GetMem(DataBuffer, Msg.Series);
          Try
            DecodeBuffer(sData, DataBuffer, Msg.Series);
            FileHandle := FileOpen(UserSession.UploadInfo.sTempFileName, fmOpenReadWrite or fmShareDenyWrite);
            if FileHandle > 0 then begin
              Try
                FileSeek(FileHandle, nWriteSize, 0);
                FileWrite(FileHandle, DataBuffer^, Msg.Series);
              Finally
                FileClose(FileHandle);
              End;
            end;
          Finally
            FreeMem(DataBuffer, Msg.Series);
          End;
        end;
      end;
    end else
    if (Msg.Recog = -1) then begin
      if (UserSession.UploadInfo.sFileName <> '') and (UserSession.UploadInfo.sTempFileName <> '') then begin
        sData := DecodeString(sData);
        if FileToMD5Text(UserSession.UploadInfo.sTempFileName) = sData then begin
          CreateDir(UPLOADFILES + UserSession.sUserName + '\');
          sSaveFileName := UPLOADFILES + UserSession.sUserName + '\' + UserSession.UploadInfo.sFileName;
          if FileExists(sSaveFileName) then begin
            sSaveFileName := GetNewFileName(sSaveFileName);
          end;
          CopyFile(PChar(UserSession.UploadInfo.sTempFileName), PChar(sSaveFileName), False);
          ADOQuery.SQL.Clear;
          ADOQuery.SQL.Add('select Top 1 * from FileList');
          ADOQuery.Open;
          try
            ADOQuery.Append;
            ADOQuery.FieldByName('ClassID').AsInteger := UserSession.UploadInfo.nClassID;
            ADOQuery.FieldByName('FileName').AsString := sSaveFileName;
            ADOQuery.FieldByName('ShowFileName').AsString := UserSession.UploadInfo.sFileName;
            ADOQuery.FieldByName('FileSize').AsInteger := UserSession.UploadInfo.nFileSize;
            ADOQuery.FieldByName('UpName').AsString := UserSession.sUserName;
            ADOQuery.FieldByName('IsAdmin').AsBoolean := UserSession.boAdmin;
            ADOQuery.Post;
          finally
            ADOQuery.Close;
          end;
          FDefMsg := MakeDefaultMsg(SM_SHARE_UPLOADFILE_BACK, 1, 0, 0, 0);
        end else begin
          FDefMsg := MakeDefaultMsg(SM_SHARE_UPLOADFILE_BACK, -1, 0, 0, 0);
        end;
        SendSocket(UserSession, EncodeMessage(FDefMsg));
        DeleteFile(UserSession.UploadInfo.sTempFileName);
        UserSession.UploadInfo.sFileName := '';
        UserSession.UploadInfo.nFileSize := -1;
        UserSession.UploadInfo.sTempFileName := '';
      end;
    end;
  end;

end;

procedure TFormMain.Lock;
begin
  EnterCriticalSection(FSection);
end;

procedure TFormMain.MainOutMessage(sMsg: string);
begin
  MemoLog.Lines.Add(FormatDateTime('[MM-DD HH:MM:SS] ', Now) + sMsg);
end;

function TFormMain.SendGateData(UserSession: pTUserSession): Boolean;
var
  sData: string;
  //UserSession: pTSessionInfo;
  sWriteStr: string;
  nSendLen: Integer;
begin
  Result := False;
  sWriteStr := UserSession.sWriteStr;
  Try
    while (sWriteStr <> '') do begin
      UserSession.dwCheckConnTick := GetTickCount;
      nSendLen := Length(sWriteStr);
      if nSendLen > MAXSOCKETBUFFLEN then begin
        sData := Copy(sWriteStr, 1, MAXSOCKETBUFFLEN);
        if UserSession.Socket.SendText(sData) <> -1 then begin
          sWriteStr := Copy(sWriteStr, MAXSOCKETBUFFLEN + 1, nSendLen - MAXSOCKETBUFFLEN);
          UserSession.dwSuspendedCount := 0;
        end
        else begin
          Inc(UserSession.dwSuspendedCount);
          UserSession.dwSuspendedTick := GetTickCount + LongWord(500 * UserSession.dwSuspendedCount);
          if UserSession.dwSuspendedCount >= 100 then begin
            Result := True;
          end;
          Exit;
        end;
      end
      else begin
        if UserSession.Socket.SendText(sWriteStr) <> -1 then begin
          sWriteStr := '';
          UserSession.dwSuspendedCount := 0;
        end else begin
          Inc(UserSession.dwSuspendedCount);
          UserSession.dwSuspendedTick := GetTickCount + LongWord(500 * UserSession.dwSuspendedCount);
          if UserSession.dwSuspendedCount >= 100 then begin
            Result := True;
          end;
        end;
        Exit;
      end;
    end;
  Finally
    UserSession.sWriteStr := sWriteStr;
  End;
end;

procedure TFormMain.SendSocket(UserSession: pTUserSession; sMsg: string);
begin
  UserSession.sWriteStr := UserSession.sWriteStr + g_CodeHead + sMsg + g_CodeEnd;
end;

procedure TFormMain.SSocketClientConnect(Sender: TObject; Socket: TCustomWinSocket);
var
  UserSession: pTUserSession;
begin
  New(UserSession);
  UserSession.RemoteAddress := Socket.RemoteAddress;
  UserSession.sUserName := '';
  UserSession.Socket := Socket;
  UserSession.sReadStr := '';
  UserSession.sWriteStr := '';
  UserSession.dwSuspendedCount := 0;
  UserSession.dwSuspendedTick := 0;
  UserSession.nMark := Random(999999);
  UserSession.boAdmin := False;
  UserSession.UploadInfo.sFileName := '';
  UserSession.UploadInfo.sTempFileName := '';
  UserSession.UploadInfo.nFileSize := 0;
  UserSession.dwCheckConnTick := GetTickCount;
  Socket.nIndex := Integer(UserSession);
end;

procedure TFormMain.SSocketClientDisconnect(Sender: TObject; Socket: TCustomWinSocket);
begin
  Lock;
  Try
    if Socket.nIndex > -1 then
      Dispose(pTUserSession(Socket.nIndex));
  Finally
    UnLock;
  End;
  Socket.nIndex := -1;
end;

procedure TFormMain.SSocketClientError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
  Socket.Close;
  ErrorCode := 0;
end;

procedure TFormMain.SSocketClientRead(Sender: TObject; Socket: TCustomWinSocket);
begin
  if Socket.nIndex > -1 then begin
    Lock;
    Try
      pTUserSession(Socket.nIndex).sReadStr := pTUserSession(Socket.nIndex).sReadStr + Socket.ReceiveText;
      pTUserSession(Socket.nIndex).dwCheckConnTick := GetTickCount;
    Finally
      UnLock;
    End;
  end else
    Socket.Close;
end;

procedure TFormMain.SSocketListen(Sender: TObject; Socket: TCustomWinSocket);
begin
  Timer1.Enabled := True;
  MainOutMessage('端口绑定(' + Socket.LocalAddress + ':' + IntToStr(Socket.LocalPort) + ')...');
end;

procedure TFormMain.StateTimerTimer(Sender: TObject);
begin
  StateTimer.Enabled := False;
  SSocket.Active := True;
end;

procedure TFormMain.Timer1Timer(Sender: TObject);
var
  I: Integer;
  Socket: TCustomWinSocket;
  UserSession: pTUserSession;
begin
  if FboRun then Exit;
  FboRun := True;
  Try
   { Lock;
    Try      }
      for I := 0 to SSocket.Socket.ConnectCount - 1 do begin
        Socket := SSocket.Socket.Connections[I];
        if Socket.nIndex > -1 then begin
          UserSession := pTUserSession(Socket.nIndex);

          DecodeGateData(UserSession);

          if SendGateData(UserSession) then begin
            Socket.Close;
            Break;
          end else
          if (GetTickCount - UserSession.dwCheckConnTick) > 3 * 60 * 1000 then begin
            Socket.Close;
            Break;
          end;
        end;
      end;
    {Finally
      UnLock;
    End;   }
  Finally
    FboRun := False;
  End;
end;

procedure TFormMain.Timer2Timer(Sender: TObject);
begin
  StatusBar.Panels[0].Text := IntToStr(SSocket.Port);
  StatusBar.Panels[1].Text := '[' + IntToStr(SSocket.Socket.ConnectCount) + ']';
end;

procedure TFormMain.UnLock;
begin
  LeaveCriticalSection(FSection);
end;

procedure TFormMain.V1Click(Sender: TObject);
begin
  FormUploadList.Open();
end;

end.
