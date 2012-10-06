unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms, StdCtrls, JSocket, WinSock, ExtCtrls, ComCtrls, Dialogs,
  Menus, IniFiles, GateShare, AppEvnts, GeneralCommon;
type
  TUserSession = record
    Socket: TCustomWinSocket; //0x00
    sRemoteIPaddr: string; //0x04
    sLocalIPaddr: string; //0x04
    dwUserTimeOutTick: LongWord; //0x24
    dwUserSendTick: LongWord;
    SocketHandle: Integer; //0x28
    sReadString: string;
    sSendString: string;
    //    MsgList: TStringList; //0x30
    boConnectCheck: Boolean; //是否通过空连接检测
    boIsSendOpen: Boolean;
    dwSuspendedTick: LongWord;
    dwSuspendedCount: Integer;

  end;
  pTUserSession = ^TUserSession;
  TSessionArray = array[0..GATEMAXSESSION - 1] of TUserSession;
  TFrmMain = class(TForm)
    ServerSocket: TServerSocket;
    MemoLog: TMemo;
    SendTimer: TTimer;
    ClientSocket: TClientSocket;
    Timer: TTimer;
    DecodeTimer: TTimer;
    StatusBar: TStatusBar;
    MainMenu: TMainMenu;
    MENU_CONTROL: TMenuItem;
    StartTimer: TTimer;
    MENU_CONTROL_START: TMenuItem;
    MENU_CONTROL_STOP: TMenuItem;
    MENU_CONTROL_RECONNECT: TMenuItem;
    MENU_CONTROL_CLEAELOG: TMenuItem;
    MENU_CONTROL_EXIT: TMenuItem;
    MENU_VIEW: TMenuItem;
    MENU_OPTION: TMenuItem;
    MENU_OPTION_GENERAL: TMenuItem;
    MENU_OPTION_IPFILTER: TMenuItem;
    H1: TMenuItem;
    S1: TMenuItem;
    ApplicationEvents1: TApplicationEvents;

    procedure MemoLogChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SendTimerTimer(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure DecodeTimerTimer(Sender: TObject);
    procedure ClientSocketConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure ClientSocketDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure ClientSocketError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure ClientSocketRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure ServerSocketClientConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure ServerSocketClientDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure ServerSocketClientError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure ServerSocketClientRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure StartTimerTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MENU_CONTROL_STARTClick(Sender: TObject);
    procedure MENU_CONTROL_STOPClick(Sender: TObject);
    procedure MENU_CONTROL_RECONNECTClick(Sender: TObject);
    procedure MENU_CONTROL_CLEAELOGClick(Sender: TObject);
    procedure MENU_CONTROL_EXITClick(Sender: TObject);
    procedure MENU_OPTION_GENERALClick(Sender: TObject);
    procedure MENU_OPTION_IPFILTERClick(Sender: TObject);
    procedure S1Click(Sender: TObject);
    procedure ApplicationEvents1Exception(Sender: TObject; E: Exception);
  private
    dwShowMainLogTick: LongWord;
    boShowLocked: Boolean;
    TempLogList: TStringList;
    nSessionCount: Integer;
    nLoginCount: Integer;
    nCheckCount: Integer;

    dwSendKeepAliveTick: LongWord;
    boServerReady: Boolean;

    dwReConnectServerTick: LongWord;
    CriticalSection: TRTLCriticalSection;
    boSendKeepAlive: Boolean;
    dwSuspendedCount: Integer;
    dwSuspendedTick: LongWord;
    procedure ResUserSessionArray();
    procedure StartService();
    procedure StopService();
    procedure LoadConfig();
    function IsBlockIP(sIPaddr: string): Boolean;
    function IsConnLimited(sIPaddr: string {; SocketHandle: Integer}): Boolean;

    procedure CloseSocket(nSocketHandle: Integer);
    //    function SendUserMsg(UserSession: pTUserSession; sSendMsg: string): Integer;
    procedure ShowMainLogMsg;
    procedure IniUserSessionArray;

    procedure SendOpenUser(UserSession: pTUserSession);
    procedure SendDataUser(UserSession: pTUserSession; sData: string);
    procedure SendCloseUser(UserSession: pTUserSession);
    procedure SendClientMsg(sMsg: string);
    procedure DecodeUserData(UserSession: pTUserSession);
    //procedure ProcessUserMsg(UserSession: pTUserSession; sData: string);

    procedure AttackDispose(sIPaddr: string; Socket: TCustomWinSocket);
    function SocketStandardSend(Socket: TCustomWinSocket; sSendMsg: string): string; overload;
    procedure SocketStandardSend(sSendMsg: string; UserSession: pTUserSession); overload;
    { Private declarations }
  public
    procedure CloseConnect(sIPaddr: string);
    function AddBlockIP(sIPaddr: string): Integer;
    function AddTempBlockIP(sIPaddr: string): Integer;
    procedure MyMessage(var MsgData: TWmCopyData); message WM_COPYDATA;
    procedure OnProgramException(Sender: TObject; E: Exception);
    { Public declarations }
  end;
procedure MainOutMessage(sMsg: string; nMsgLevel: Integer);
var
  FrmMain: TFrmMain;
  g_SessionArray: TSessionArray;
  ClientSockeMsgList: TStringList;
  sProcMsg: string;
implementation

uses HUtil32, GeneralConfig, IPaddrFilter;

{$R *.DFM}

procedure MainOutMessage(sMsg: string; nMsgLevel: Integer);
var
  tMsg: string;
begin
  try
    CS_MainLog.Enter;
    if nMsgLevel <= nShowLogLevel then begin
      tMsg := '[' + TimeToStr(Now) + '] ' + sMsg;
      MainLogMsgList.Add(tMsg);
    end;
  finally
    CS_MainLog.Leave;
  end;
end;

procedure TFrmMain.ServerSocketClientConnect(Sender: TObject;
  Socket: TCustomWinSocket);
var
  UserSession: pTUserSession;
  sRemoteIPaddr, sLocalIPaddr: string;
  nSockIndex: Integer;
begin
  Socket.nIndex := -1;
  sRemoteIPaddr := Socket.RemoteAddress;

  if IsBlockIP(sRemoteIPaddr) then begin
    MainOutMessage('过滤连接: ' + sRemoteIPaddr, 3);
    Socket.Close;
    Exit;
  end;

  if IsConnLimited(sRemoteIPaddr {, Socket.SocketHandle}) then begin
    case BlockMethod of
      mDisconnect: begin
          Socket.Close;
        end;
      mBlock: begin
          AddTempBlockIP(sRemoteIPaddr);
          CloseConnect(sRemoteIPaddr);
        end;
      mBlockList: begin
          AddBlockIP(sRemoteIPaddr);
          CloseConnect(sRemoteIPaddr);
        end;
    end;
    MainOutMessage('端口攻击: ' + sRemoteIPaddr, 3);
    Exit;
  end;

  //if g_boDynamicIPDisMode then begin
  sLocalIPaddr := ClientSocket.Socket.RemoteAddress;
  {end
  else begin
    sLocalIPaddr := Socket.LocalAddress;
  end; }

  if boGateReady then begin
    for nSockIndex := 0 to GATEMAXSESSION - 1 do begin
      UserSession := @g_SessionArray[nSockIndex];
      if UserSession.Socket = nil then begin
        UserSession.Socket := Socket;
        UserSession.sRemoteIPaddr := sRemoteIPaddr;
        UserSession.sLocalIPaddr := sLocalIPaddr;
        UserSession.boConnectCheck := False;
        UserSession.boIsSendOpen := False;
        UserSession.dwUserTimeOutTick := GetTickCount();
        UserSession.dwUserSendTick := GetTickCount;
        UserSession.SocketHandle := GetSocketHandle() {Socket.SocketHandle};
        UserSession.sReadString := '';
        UserSession.sSendString := '';
        UserSession.dwSuspendedTick := 0;
        UserSession.dwSuspendedCount := 0;
        //UserSession.MsgList.Clear;
        Socket.nIndex := nSockIndex;
        Inc(nSessionCount);
        break;
      end;
    end;
    if Socket.nIndex >= 0 then begin
      MainOutMessage('Connect: ' + sRemoteIPaddr, 5);
    end
    else begin
      Socket.Close;
      MainOutMessage('Kick Off: ' + sRemoteIPaddr, 5);
    end;
  end
  else begin
    Socket.Close;
    MainOutMessage('Kick Off: ' + sRemoteIPaddr, 5);
  end;
end;

procedure TFrmMain.ServerSocketClientDisconnect(Sender: TObject; Socket: TCustomWinSocket);
var
  I: Integer;
  UserSession: pTUserSession;
  nSockIndex: Integer;
  sRemoteIPaddr: string;
  IPaddr: pTSockaddr;
  nIPaddr: Integer;
begin
  sRemoteIPaddr := Socket.RemoteAddress;
  nSockIndex := Socket.nIndex;
  nIPaddr := inet_addr(PChar(sRemoteIPaddr));
  CurrIPaddrList.Lock;
  try
    for I := 0 to CurrIPaddrList.Count - 1 do begin
      IPaddr := CurrIPaddrList.Items[I];
      if IPaddr.nIPaddr = nIPaddr then begin
        Dec(IPaddr.nCount);
        if IPaddr.nCount <= 0 then begin
          Dispose(IPaddr);
          CurrIPaddrList.Delete(I);
        end;
        Break;
      end;
    end;
  finally
    CurrIPaddrList.UnLock;
  end;

  if (nSockIndex >= 0) and (nSockIndex < GATEMAXSESSION) then begin
    UserSession := @g_SessionArray[nSockIndex];
    if UserSession.boConnectCheck then
      Dec(nCheckCount);    
    if UserSession.boIsSendOpen then
      Dec(nLoginCount);
    SendCloseUser(UserSession);
    UserSession.Socket := nil;
    UserSession.sRemoteIPaddr := '';
    UserSession.sReadString := '';
    UserSession.sSendString := '';
    UserSession.SocketHandle := -1;
    //UserSession.MsgList.Clear;
    Dec(nSessionCount);
    MainOutMessage('DisConnect: ' + sRemoteIPaddr, 5);
  end;
  Socket.nIndex := -1;
end;

procedure TFrmMain.ServerSocketClientError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
  Socket.Close;
  ErrorCode := 0;
end;

procedure TFrmMain.ServerSocketClientRead(Sender: TObject; Socket: TCustomWinSocket);
var
  UserSession: pTUserSession;
  nSockIndex: Integer;
  //sRemoteAddress,
  sReviceMsg, s10, s1C: string;
  nPos: Integer;
//  nMsgLen: Integer;
begin
  nSockIndex := Socket.nIndex;
  //sRemoteAddress := Socket.RemoteAddress;
  if (nSockIndex >= 0) and (nSockIndex < GATEMAXSESSION) then begin
    UserSession := @g_SessionArray[nSockIndex];
    sReviceMsg := Socket.ReceiveText;
    nPos := Pos('*', sReviceMsg);
    if nPos > 0 then
    begin
      s10 := Copy(sReviceMsg, 1, nPos - 1);
      s1C := Copy(sReviceMsg, nPos + 1, Length(sReviceMsg) - nPos);
      sReviceMsg := s10 + s1C;
      UserSession.dwUserTimeOutTick := GetTickCount;
    end;
    if (sReviceMsg <> '') and (boServerReady) then begin
      UserSession.sReadString := UserSession.sReadString + sReviceMsg;
    end;
  end;
end;

procedure TFrmMain.MemoLogChange(Sender: TObject);
begin
  if MemoLog.Lines.Count > 200 then
    MemoLog.Clear;         
end;

procedure TFrmMain.FormDestroy(Sender: TObject);
//var
//  nIndex: Integer;
begin
  DeleteCriticalSection(CriticalSection);
  //DelMapHandle(gt_LoginGate, Handle);
  TempLogList.Free;
  {for nIndex := 0 to GATEMAXSESSION - 1 do begin
    g_SessionArray[nIndex].MsgList.Free;
  end;  }
end;

procedure TFrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if boClose then Exit;
  if Application.MessageBox('是否确认退出服务器？', '提示信息', MB_YESNO + MB_ICONQUESTION) = IDYES then begin
    if boServiceStart then begin
      StartTimer.Enabled := True;
      CanClose := False;
    end;
  end
  else
    CanClose := False;
end;

function TFrmMain.SocketStandardSend(Socket: TCustomWinSocket; sSendMsg: string): string;
var
  sData, sSendData: string;
  nSendLen: Integer;
begin
  if GetTickCount > dwSuspendedTick then begin
    sSendData := sSendMsg;
    while (sSendData <> '') and (Socket.Connected) do begin
      nSendLen := Length(sSendData);
      if nSendLen > MAXSENDMSGLEN then begin
        sData := Copy(sSendData, 1, MAXSENDMSGLEN);
        if Socket.SendText(sData) <> -1 then begin
          sSendData := Copy(sSendData, MAXSENDMSGLEN + 1, nSendLen - MAXSENDMSGLEN);
          dwSuspendedCount := 0;
        end
        else begin
          Inc(dwSuspendedCount);
          dwSuspendedTick := GetTickCount + LongWord(200 * dwSuspendedCount);
          if dwSuspendedCount >= 1000 then begin
            ClientSocket.Socket.Close;
            MainOutMessage('传输失败:  服务器...', 3);
            Exit;
          end;
          Break;
        end;
      end
      else begin
        if Socket.SendText(sSendData) <> -1 then begin
          sSendData := '';
          dwSuspendedCount := 0;
        end else begin
          Inc(dwSuspendedCount);
          dwSuspendedTick := GetTickCount + LongWord(200 * dwSuspendedCount);
          if dwSuspendedCount >= 1000 then begin
            ClientSocket.Socket.Close;
            MainOutMessage('传输失败:  服务器...', 3);
            Exit;
          end;
        end;
        break;
      end;
    end;
    Result := sSendData;
  end else
    Result := sSendMsg;

  {dwSuspendedCount := 0;
  dwSuspendedTick := 0;     }
end;

procedure TFrmMain.ClientSocketConnect(Sender: TObject; Socket: TCustomWinSocket);
begin
  boGateReady := True;
  nSessionCount := 0;
  nLoginCount := 0;
  nCheckCount := 0;
  dwKeepAliveTick := GetTickCount();
  ResUserSessionArray();
  boServerReady := True;
  dwSuspendedCount := 0;
  dwSuspendedTick := 0;
  boSendKeepAlive := False;
  sProcMsg := '';
  g_ClientSendStr := '';
  boKeepAliveTimcOut := False;

  EnterCriticalSection(CriticalSection);
  Try
    ClientSockeMsgList.Clear;
  Finally
    LeaveCriticalSection(CriticalSection);
  End;
end;

procedure TFrmMain.ClientSocketDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
var
  UserSession: pTUserSession;
  nIndex: Integer;
begin
  for nIndex := 0 to GATEMAXSESSION - 1 do begin
    UserSession := @g_SessionArray[nIndex];
    if UserSession.Socket <> nil then
      UserSession.Socket.Close;
    UserSession.Socket := nil;
    UserSession.sRemoteIPaddr := '';
    UserSession.SocketHandle := -1;
  end;
  boSendKeepAlive := False;
  dwSuspendedCount := 0;
  dwSuspendedTick := 0;
  ResUserSessionArray();
  EnterCriticalSection(CriticalSection);
  Try
    ClientSockeMsgList.Clear;
  Finally
    LeaveCriticalSection(CriticalSection);
  End;
  boGateReady := False;
  nSessionCount := 0;
  nLoginCount := 0;
  nCheckCount := 0;
  sProcMsg := '';
  g_ClientSendStr := '';
end;

procedure TFrmMain.ClientSocketError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
  Socket.Close;
  ErrorCode := 0;
  dwSuspendedCount := 0;
  dwSuspendedTick := 0;
  boServerReady := False;
  boSendKeepAlive := False;
  g_ClientSendStr := '';
end;

procedure TFrmMain.ClientSocketRead(Sender: TObject;
  Socket: TCustomWinSocket);
var
  sRecvMsg: string;
begin
  sRecvMsg := Socket.ReceiveText;
  EnterCriticalSection(CriticalSection);
  Try
    ClientSockeMsgList.Add(sRecvMsg);
  Finally
    LeaveCriticalSection(CriticalSection);
  End;

end;

procedure TFrmMain.SendClientMsg(sMsg: string);
begin
  g_ClientSendStr := g_ClientSendStr + sMsg;
  if (g_ClientSendStr <> '') and ClientSocket.Socket.Connected then
    g_ClientSendStr := SocketStandardSend(ClientSocket.Socket, g_ClientSendStr);
end;

procedure TFrmMain.SendCloseUser(UserSession: pTUserSession);
begin
  if boGateReady and UserSession.boIsSendOpen then begin
    SendClientMsg(MG_CodeHead +
      MG_CloseUser +
      IntToStr(UserSession.Socket.nIndex) + '/' +
      IntToStr(UserSession.SocketHandle) +
      MG_CodeEnd);
  end;
end;

procedure TFrmMain.SendDataUser(UserSession: pTUserSession; sData: string);
begin
  if boGateReady then begin
    if not UserSession.boIsSendOpen then
      SendOpenUser(UserSession);

    SendClientMsg(MG_CodeHead +
      MG_SendUser +
      IntToStr(UserSession.Socket.nIndex) + '/' +
      IntToStr(UserSession.SocketHandle) + '/' +
      sData +
      MG_CodeEnd);

    UserSession.dwUserTimeOutTick := GetTickCount;
  end;
end;

procedure TFrmMain.SendOpenUser(UserSession: pTUserSession);
begin
  if boGateReady then begin
    SendClientMsg(MG_CodeHead +
      MG_OpenUser +
      IntToStr(UserSession.Socket.nIndex) + '/' +
      IntToStr(UserSession.SocketHandle) + '/' +
      UserSession.sRemoteIPaddr + '/' +
      g_PublicAddr +
      MG_CodeEnd);
    UserSession.boIsSendOpen := True;
    Inc(nLoginCount);
  end;
end;

procedure TFrmMain.SendTimerTimer(Sender: TObject);
var
  nIndex: Integer;
  UserSession: pTUserSession;
begin
  if boGateReady and (not boKeepAliveTimcOut) then begin
    for nIndex := 0 to GATEMAXSESSION - 1 do begin
      UserSession := @g_SessionArray[nIndex];
      if UserSession.Socket <> nil then begin
        if not UserSession.boConnectCheck then begin
          if (GetTickCount - UserSession.dwUserTimeOutTick) > dwConnectTimeOut then begin
            MainOutMessage('空连接:  ' + UserSession.sRemoteIPaddr, 3);

            AttackDispose(UserSession.sRemoteIPaddr, UserSession.Socket);
          end;
        end
        else begin
          if (GetTickCount - UserSession.dwUserTimeOutTick) > dwKeepConnectTimeOut then begin
            MainOutMessage('连接超时:  ' + UserSession.sRemoteIPaddr, 3);
            UserSession.Socket.Close;
            UserSession.Socket := nil;
            UserSession.SocketHandle := -1;
            //UserSession.MsgList.Clear;
            UserSession.sRemoteIPaddr := '';
          end;
        end;
      end;
    end;
  end;
  if not boGateReady and (boServiceStart) then begin
    if (GetTickCount - dwReConnectServerTick) > 3 * 1000 then begin
      dwReConnectServerTick := GetTickCount();
      ClientSocket.Active := False;
      ClientSocket.Port := ServerPort;
      ClientSocket.Host := ServerAddr;
      ClientSocket.Active := True;
    end;
  end;
end;

procedure TFrmMain.TimerTimer(Sender: TObject);
begin
  if ServerSocket.Active then begin
    StatusBar.Panels[0].Text := IntToStr(ServerSocket.Port);
    StatusBar.Panels[2].Text := IntToStr(nLoginCount) + '/' + IntToStr(nCheckCount) + '/' + IntToStr(nSessionCount);
  end
  else begin
    StatusBar.Panels[0].Text := '????';
    StatusBar.Panels[2].Text := '????';
  end;
  if not boGateReady then begin
    StatusBar.Panels[1].Text := '---]    [---';
  end
  else begin
    if boKeepAliveTimcOut then begin
      StatusBar.Panels[1].Text := '---]$$$$[---';
    end
    else begin
      StatusBar.Panels[1].Text := '-----][-----';
    end;
  end;
end;

procedure TFrmMain.DecodeTimerTimer(Sender: TObject);
var
  sProcessMsg: string;
  sSocketMsg: string;
  sSocketHandle: string;
  sArryIndex: string;
  nSocketIndex: Integer;
  //  nSendRetCode: Integer;
  nSocketHandle: Integer;
  nArryIndex: Integer;
  UserSession: pTUserSession;
begin
  ShowMainLogMsg();
  if boDecodeLock or (not boGateReady) then
    Exit;
  try
    boDecodeLock := True;
    sProcessMsg := sProcMsg;
    sProcMsg := '';
    while (True) do begin
      EnterCriticalSection(CriticalSection);
      Try
        if ClientSockeMsgList.Count <= 0 then break;
        sProcessMsg := sProcessMsg + ClientSockeMsgList.Strings[0];
        ClientSockeMsgList.Delete(0);
      Finally
        LeaveCriticalSection(CriticalSection);
      End;

      while (True) do begin
        if TagCount(sProcessMsg, MG_CodeEnd) < 1 then break;
        sProcessMsg := ArrestStringEx(sProcessMsg, MG_CodeHead, MG_CodeEnd, sSocketMsg);
        if Length(sSocketMsg) < 2 then Continue;
        if sSocketMsg[1] = '+' then begin
          case sSocketMsg[2] of
            '-': begin
                CloseSocket(StrToIntDef(Copy(sSocketMsg, 3, Length(sSocketMsg) - 2), 0));
              end;
          else begin
              dwKeepAliveTick := GetTickCount();
              boKeepAliveTimcOut := False;
              boSendKeepAlive := False;
            end;
          end;
          Continue;
        end;
        sSocketMsg := GetValidStr3(sSocketMsg, sArryIndex, ['/']);
        sSocketMsg := GetValidStr3(sSocketMsg, sSocketHandle, ['/']);
        nSocketHandle := StrToIntDef(sSocketHandle, -1);
        nArryIndex := StrToIntDef(sArryIndex, -1);
        if (nSocketHandle < 0) or (nArryIndex < 0) or (nArryIndex >= GATEMAXSESSION) then Continue;
        if (g_SessionArray[nArryIndex].SocketHandle = nSocketHandle) and (g_SessionArray[nArryIndex].Socket <> nil) then begin
          g_SessionArray[nArryIndex].dwUserTimeOutTick := GetTickCount;
          SocketStandardSend(g_SessionArray[nArryIndex].sSendString + sSocketMsg, @g_SessionArray[nArryIndex]);
        end;
      end; //0x00452246
    end; //0x452252
    sProcMsg := sProcessMsg;

    for nSocketIndex := 0 to GATEMAXSESSION - 1 do begin
      UserSession := @g_SessionArray[nSocketIndex];
      if (UserSession.Socket <> nil) then begin
        if (UserSession.sSendString <> '') then begin
          SocketStandardSend(UserSession.sSendString, UserSession);
        end;
        if (UserSession.sReadString <> '') then begin
          DecodeUserData(UserSession);
        end;
      end;
    end;
    
    if (GetTickCount - dwSendKeepAliveTick) > 2 * 1000 then begin
      dwSendKeepAliveTick := GetTickCount();
      if boGateReady and (not boSendKeepAlive) then begin
        boSendKeepAlive := True;
        SendClientMsg(MG_CodeHead + '--' + MG_CodeEnd);
      end;
    end;
    if (GetTickCount - dwKeepAliveTick) > 60 * 1000 then begin
      boKeepAliveTimcOut := True;
      if (GetTickCount - dwKeepAliveTick) > 120 * 1000 then begin
        ClientSocket.Close;
      end;
    end;
    if g_ClientSendStr <> '' then
      SendClientMsg('');
  finally
    boDecodeLock := False;
  end;
end;

procedure TFrmMain.DecodeUserData(UserSession: pTUserSession);
var
  sMsg, sCode: string;
begin
  sMsg := UserSession.sReadString;
  UserSession.sReadString := '';
  while (sMsg <> '') do begin
    if TagCount(sMsg, g_CodeEnd) <= 0 then break;
    sMsg := ArrestStringEx(sMsg, g_CodeHead, g_CodeEnd, sCode);
    if sCode = '' then Continue;
    if not UserSession.boConnectCheck then begin
      if sCode <> '+' then begin
        sMsg := '';
        MainOutMessage('非法连接: ' + UserSession.sRemoteIPaddr, 3);
        AttackDispose(UserSession.sRemoteIPaddr, UserSession.Socket);
        Break;
      end
      else begin
        UserSession.boConnectCheck := True;
        Inc(nCheckCount);
      end;
    end
    else begin
      SendDataUser(UserSession, g_CodeHead + sCode + g_CodeEnd);
    end;
  end;
  UserSession.sReadString := sMsg;
end;

procedure TFrmMain.CloseSocket(nSocketHandle: Integer);
var
  nIndex: Integer;
  UserSession: pTUserSession;
begin
  for nIndex := 0 to GATEMAXSESSION - 1 do begin
    UserSession := @g_SessionArray[nIndex];
    if (UserSession.Socket <> nil) and (UserSession.SocketHandle = nSocketHandle) then begin
      UserSession.Socket.Close;
      break;
    end;
  end;
end;
{
function TFrmMain.SendUserMsg(UserSession: pTUserSession; sSendMsg: string):
 Integer;
begin
 Result := -1;
 if UserSession.Socket <> nil then begin
   Result := UserSession.Socket.SendText(sSendMsg);
 end;
end;     }

procedure TFrmMain.LoadConfig;
var
  Conf: TIniFile;
  sConfigFileName: string;
begin
  if g_boTeledata then
    sConfigFileName := TeledataConfigFileName
  else
    sConfigFileName := ConfigFileName;

  Conf := TIniFile.Create(sConfigFileName);
  TitleName := Conf.ReadString(GateClass, 'Title', TitleName);
  ServerPort := Conf.ReadInteger(GateClass, 'ServerPort', ServerPort);
  ServerAddr := Conf.ReadString(GateClass, 'ServerAddr', ServerAddr);
  GatePort := Conf.ReadInteger(GateClass, 'GatePort', GatePort);
  GateAddr := Conf.ReadString(GateClass, 'GateAddr', GateAddr);
  g_PublicAddr := Conf.ReadString(GateClass, 'PublicAddr', g_PublicAddr);
  nShowLogLevel := Conf.ReadInteger(GateClass, 'ShowLogLevel', nShowLogLevel);

  nMaxConnOfIPaddr := Conf.ReadInteger(GateClass, 'MaxConnOfIPaddr', nMaxConnOfIPaddr);
  dwKeepConnectTimeOut := Conf.ReadInteger(GateClass, 'KeepConnectTimeOut', dwKeepConnectTimeOut);
  dwConnectTimeOut := Conf.ReadInteger(GateClass, 'ConnectTimeOut', dwConnectTimeOut);

  nIPCountLimitTime1 := Conf.ReadInteger(GateClass, 'IPCountTime1', nIPCountLimitTime1);
  nIPCountLimit1 := Conf.ReadInteger(GateClass, 'IPCountLimit1', nIPCountLimit1);
  nIPCountLimitTime2 := Conf.ReadInteger(GateClass, 'IPCountTime2', nIPCountLimitTime2);
  nIPCountLimit2 := Conf.ReadInteger(GateClass, 'IPCountLimit2', nIPCountLimit2);

  BlockMethod := TBlockIPMethod(Conf.ReadInteger(GateClass, 'BlockMethod', Integer(BlockMethod)));

  boCheckClientMsg := Conf.ReadBool(GateClass, 'CheckClientMsg', boCheckClientMsg);

  nAddNewUserTime := Conf.ReadInteger(GateClass, 'AddNewUserTick', nAddNewUserTime);
  nChangePassword := Conf.ReadInteger(GateClass, 'ChangePasswordTick', nChangePassword);
  nLoadPassword := Conf.ReadInteger(GateClass, 'LoadPasswordTick', nLoadPassword);
  Conf.Free;
  LoadBlockIPList;
end;

procedure TFrmMain.StartService;
begin
  try
    MainOutMessage('正在启动服务...', 0);
    //SendGameCenterMsg(SG_STARTNOW, g_sNowStartGate);
    boServiceStart := True;
    boGateReady := False;
    boServerReady := False;
    nSessionCount := 0;
    MENU_CONTROL_START.Enabled := False;
    MENU_CONTROL_STOP.Enabled := True;

    dwReConnectServerTick := GetTickCount - 25 * 1000;
    boKeepAliveTimcOut := False;
    dwSendKeepAliveTick := GetTickCount();

    CurrIPaddrList := TGList.Create;
    BlockIPList := TGList.Create;
    TempBlockIPList := TGList.Create;
    IpList := TGList.Create;

    ClientSockeMsgList := TStringList.Create;

    ResUserSessionArray();
    LoadConfig();
    Caption := GateName + ' - ' + TitleName;
    ClientSocket.Active := False;
    ClientSocket.Host := ServerAddr;
    ClientSocket.Port := ServerPort;
    ClientSocket.Active := True;

    ServerSocket.Active := False;
    ServerSocket.Address := GateAddr;
    ServerSocket.Port := GatePort;
    ServerSocket.Active := True;

    SendTimer.Enabled := True;
    MainOutMessage('启动服务完成...', 0);
    //SendGameCenterMsg(SG_STARTOK, g_sNowStartOK);
  except
    on E: Exception do begin
      MENU_CONTROL_START.Enabled := True;
      MENU_CONTROL_STOP.Enabled := False;
      MainOutMessage(E.Message, 0);
    end;
  end;
end;

procedure TFrmMain.StopService;
var
  I: Integer;
  nSockIdx: Integer;
  IPaddr: pTSockaddr;
  //IPList: TList;
begin
  MainOutMessage('正在停止服务...', 3);
  boServiceStart := False;
  boGateReady := False;
  MENU_CONTROL_START.Enabled := True;
  MENU_CONTROL_STOP.Enabled := False;
  SendTimer.Enabled := False;
  for nSockIdx := 0 to GATEMAXSESSION - 1 do begin
    if g_SessionArray[nSockIdx].Socket <> nil then
      g_SessionArray[nSockIdx].Socket.Close;
  end;
  SaveBlockIPList;
  ServerSocket.Close;
  ClientSocket.Close;
  ClientSockeMsgList.Free;

  CurrIPaddrList.Lock;
  try
    for i := 0 to CurrIPaddrList.Count - 1 do begin
      IPaddr := CurrIPaddrList.Items[I];
      Dispose(IPaddr);
    end;
  finally
    CurrIPaddrList.UnLock;
    CurrIPaddrList.Free;
  end;

  BlockIPList.Lock;
  try
    for I := 0 to BlockIPList.Count - 1 do begin
      IPaddr := pTSockaddr(BlockIPList.Items[I]);
      Dispose(IPaddr);
    end;
  finally
    BlockIPList.UnLock;
    BlockIPList.Free;
  end;

  TempBlockIPList.Lock;
  try
    for I := 0 to TempBlockIPList.Count - 1 do begin
      IPaddr := pTSockaddr(TempBlockIPList.Items[I]);
      Dispose(IPaddr);
    end;
  finally
    TempBlockIPList.UnLock;
    TempBlockIPList.Free;
  end;

  IpList.Lock;
  try
    for i := 0 to IpList.Count - 1 do begin
      Dispose(pTBlockaddr(IpList[i]));
    end;
  finally
    IpList.UnLock;
    IpList.free;
  end;

  MainOutMessage('停止服务完成...', 3);
end;

procedure TFrmMain.ResUserSessionArray;
var
  UserSession: pTUserSession;
  nIndex: Integer;
begin
  for nIndex := 0 to GATEMAXSESSION - 1 do begin
    UserSession := @g_SessionArray[nIndex];
    UserSession.Socket := nil;
    UserSession.sRemoteIPaddr := '';
    UserSession.SocketHandle := -1;
    //UserSession.MsgList.Clear;
  end;
end;

procedure TFrmMain.IniUserSessionArray();
var
  UserSession: pTUserSession;
  nIndex: Integer;
begin
  for nIndex := 0 to GATEMAXSESSION - 1 do begin
    UserSession := @g_SessionArray[nIndex];
    UserSession.Socket := nil;
    UserSession.sRemoteIPaddr := '';
    UserSession.dwUserTimeOutTick := GetTickCount();
    UserSession.SocketHandle := -1;
    //UserSession.MsgList := TStringList.Create;
  end;
end;

procedure TFrmMain.StartTimerTimer(Sender: TObject);
begin
  if boStarted then begin
    StartTimer.Enabled := False;
    StopService();
    boClose := True;
    Close;
  end
  else begin
    boStarted := True;
    StartTimer.Enabled := False;
    StartService();
  end;

end;


procedure TFrmMain.FormCreate(Sender: TObject);
var
  nX, nY: Integer;
begin
  InitializeCriticalSection(CriticalSection);  
  g_dwGameCenterHandle := StrToIntDef(ParamStr(1), 0);
  nX := StrToIntDef(ParamStr(2), -1);
  nY := StrToIntDef(ParamStr(3), -1);
  g_boTeledata := False;
  if (nX >= 0) or (nY >= 0) then begin
    Left := nX;
    Top := nY;
  end;
  //AddMapHandle(gt_LoginGate, Handle);
  TempLogList := TStringList.Create;
  Application.OnException := OnProgramException;
  //SendGameCenterMsg(SG_FORMHANDLE, IntToStr(Self.Handle));
  IniUserSessionArray();
end;

procedure TFrmMain.MENU_CONTROL_STARTClick(Sender: TObject);
begin
  StartService();
end;

procedure TFrmMain.MENU_CONTROL_STOPClick(Sender: TObject);
begin
  if Application.MessageBox('是否确认停止服务？', '确认信息', MB_YESNO + MB_ICONQUESTION) = IDYES then
    StopService();
end;

procedure TFrmMain.MENU_CONTROL_RECONNECTClick(Sender: TObject);
begin
  dwReConnectServerTick := 0;
end;

procedure TFrmMain.MENU_CONTROL_CLEAELOGClick(Sender: TObject);
begin
  if Application.MessageBox('是否确认清除显示的日志信息？', '确认信息', MB_OKCANCEL + MB_ICONQUESTION) <> IDOK then
    Exit;
  MemoLog.Clear;
end;

procedure TFrmMain.MENU_CONTROL_EXITClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmMain.MENU_OPTION_GENERALClick(Sender: TObject);
begin
  frmGeneralConfig.Top := Self.Top + 20;
  frmGeneralConfig.Left := Self.Left;
  with frmGeneralConfig do begin
    EditGateIPaddr.Text := GateAddr;
    EditGatePort.Text := IntToStr(GatePort);
    EditServerIPaddr.Text := ServerAddr;
    EditServerPort.Text := IntToStr(ServerPort);
    EditTitle.Text := TitleName;
    TrackBarLogLevel.Position := nShowLogLevel;
  end;
  frmGeneralConfig.ShowModal;
end;

procedure TFrmMain.CloseConnect(sIPaddr: string);
var
  I: Integer;
  boCheck: Boolean;
begin
  if ServerSocket.Active then
    while (ServerSocket.Socket.ActiveConnections > 0) do begin
      boCheck := False;
      for I := 0 to ServerSocket.Socket.ActiveConnections - 1 do begin
        if sIPaddr = ServerSocket.Socket.Connections[I].RemoteAddress then begin
          ServerSocket.Socket.Connections[I].Close;
          boCheck := True;
          break;
        end;
      end;
      if not boCheck then
        break;
    end;
end;

procedure TFrmMain.MENU_OPTION_IPFILTERClick(Sender: TObject);
var
  I: Integer;
  sIPaddr: string;
begin
  with frmIPaddrFilter do begin
    frmIPaddrFilter.Top := Self.Top + 20;
    frmIPaddrFilter.Left := Self.Left;
    frmIPaddrFilter.ListBoxActiveList.Clear;
    frmIPaddrFilter.ListBoxTempList.Clear;
    frmIPaddrFilter.ListBoxBlockList.Clear;
    ListBoxIpList.Clear;
    if ServerSocket.Active then
      for I := 0 to ServerSocket.Socket.ActiveConnections - 1 do begin
        sIPaddr := ServerSocket.Socket.Connections[I].RemoteAddress;
        if sIPaddr <> '' then
          frmIPaddrFilter.ListBoxActiveList.Items.AddObject(sIPaddr,
            TObject(ServerSocket.Socket.Connections[I]));
      end;
    for i := 0 to IPList.Count - 1 do begin
      ListBoxIpList.Items.AddObject(StrPas(inet_ntoa(TInAddr(pTBlockaddr(IPList[i]).nBeginAddr))) + ' - ' +
        StrPas(inet_ntoa(TInAddr(pTBlockaddr(IPList[i]).nEndAddr))), TObject(IPList[i]));
    end;
    for I := 0 to TempBlockIPList.Count - 1 do begin
      frmIPaddrFilter.ListBoxTempList.Items.Add(StrPas(inet_ntoa(TInAddr(pTSockaddr(TempBlockIPList.Items[I]).nIPaddr))));
    end;
    for I := 0 to BlockIPList.Count - 1 do begin
      frmIPaddrFilter.ListBoxBlockList.Items.Add(StrPas(inet_ntoa(TInAddr(pTSockaddr(BlockIPList.Items[I]).nIPaddr))));
    end;

    frmIPaddrFilter.EditMaxConnect.Value := nMaxConnOfIPaddr;
    frmIPaddrFilter.EditClientTimeOutTime.Value := dwKeepConnectTimeOut div 1000;
    frmIPaddrFilter.EditConnectTimeOut.Value := dwConnectTimeOut div 1000;
    frmIPaddrFilter.Edit_CountLimit2.Value := nIPCountLimit2;
    frmIPaddrFilter.Edit_CountLimit1.Value := nIPCountLimit1;
    frmIPaddrFilter.Edit_LimitTime2.Value := nIPCountLimitTime2;
    frmIPaddrFilter.Edit_LimitTime1.Value := nIPCountLimitTime1;

    frmIPaddrFilter.CheckBoxCheckClientMsg.Checked := boCheckClientMsg;

    frmIPaddrFilter.EditAddNewUserTime.Enabled := boCheckClientMsg;
    frmIPaddrFilter.EditChangePassword.Enabled := boCheckClientMsg;
    frmIPaddrFilter.EditLoadPassword.Enabled := boCheckClientMsg;
    case BlockMethod of
      mDisconnect: frmIPaddrFilter.RadioDisConnect.Checked := True;
      mBlock: frmIPaddrFilter.RadioAddTempList.Checked := True;
      mBlockList: frmIPaddrFilter.RadioAddBlockList.Checked := True;
    end;
    frmIPaddrFilter.ShowModal;
  end;
end;

function TFrmMain.IsBlockIP(sIPaddr: string): Boolean;
var
  i: Integer;
  IPaddr: pTSockaddr;
  nIPaddr: Integer;
  Blockaddr: pTBlockaddr;
begin
  Result := False;
  nIPaddr := inet_addr(PChar(sIPaddr));
  IpList.Lock;
  try
    for i := 0 to IpList.Count - 1 do begin
      Blockaddr := IpList[i];
      if (LongWord(nIPaddr) >= Blockaddr.nBeginAddr) and (LongWord(nIPaddr) <= Blockaddr.nEndAddr) then begin
        Result := True;
        break;
      end;
    end;
  finally
    IpList.UnLock;
  end;

  if not Result then begin
    TempBlockIPList.Lock;
    try
      for i := 0 to TempBlockIPList.Count - 1 do begin
        IPaddr := pTSockaddr(TempBlockIPList.Items[i]);
        if IPaddr.nIPaddr = nIPaddr then begin
          Result := True;
          break;
        end;
      end;
    finally
      TempBlockIPList.UnLock;
    end;
    //-------------------------------
    if not Result then begin
      BlockIPList.Lock;
      try
        for i := 0 to BlockIPList.Count - 1 do begin
          IPaddr := pTSockaddr(BlockIPList.Items[i]);
          if IPaddr.nIPaddr = nIPaddr then begin
            Result := True;
            break;
          end;
        end;
      finally
        BlockIPList.UnLock;
      end;
    end;
  end;
end;

function TFrmMain.AddBlockIP(sIPaddr: string): Integer;
var
  I: Integer;
  IPaddr: pTSockaddr;
  nIPaddr: Integer;
begin
  BlockIPList.Lock;
  try
    Result := 0;
    nIPaddr := inet_addr(PChar(sIPaddr));
    for I := 0 to BlockIPList.Count - 1 do begin
      IPaddr := pTSockaddr(BlockIPList.Items[I]);
      if IPaddr.nIPaddr = nIPaddr then begin
        Result := BlockIPList.Count;
        break;
      end;
    end;
    if Result <= 0 then begin
      New(IPaddr);
      IPaddr^.nIPaddr := nIPaddr;
      BlockIPList.Add(IPaddr);
      Result := BlockIPList.Count;
    end;
  finally
    BlockIPList.UnLock;
  end;
end;

function TFrmMain.AddTempBlockIP(sIPaddr: string): Integer;
var
  I: Integer;
  IPaddr: pTSockaddr;
  nIPaddr: Integer;
begin
  TempBlockIPList.Lock;
  try
    Result := 0;
    nIPaddr := inet_addr(PChar(sIPaddr));
    for I := 0 to TempBlockIPList.Count - 1 do begin
      IPaddr := pTSockaddr(TempBlockIPList.Items[I]);
      if IPaddr.nIPaddr = nIPaddr then begin
        Result := TempBlockIPList.Count;
        break;
      end;
    end;
    if Result <= 0 then begin
      New(IPaddr);
      SafeFillChar(IPaddr^, SizeOf(TSockaddr), 0);
      IPaddr^.nIPaddr := nIPaddr;
      TempBlockIPList.Add(IPaddr);
      Result := TempBlockIPList.Count;
    end;
  finally
    TempBlockIPList.UnLock;
  end;
end;

procedure TFrmMain.ApplicationEvents1Exception(Sender: TObject; E: Exception);
begin
  MainOutMessage(E.Message, 0);
end;

procedure TFrmMain.AttackDispose(sIPaddr: string; Socket: TCustomWinSocket);
begin
  case BlockMethod of
    mDisconnect: begin
        if Socket <> nil then
          Socket.Close;
      end;
    mBlock: begin
        AddTempBlockIP(sIPaddr);
        CloseConnect(sIPaddr);
      end;
    mBlockList: begin
        AddBlockIP(sIPaddr);
        CloseConnect(sIPaddr);
      end;
  end;
end;  

function TFrmMain.IsConnLimited(sIPaddr: string {; SocketHandle: Integer}):
  Boolean;
var
  i: Integer;
  IPaddr: pTSockaddr;
  nIPaddr: Integer;
  boDenyConnect: Boolean;
begin
  Result := False;
  boDenyConnect := False;
  nIPaddr := inet_addr(PChar(sIPaddr));
  CurrIPaddrList.Lock;
  try
    for I := 0 to CurrIPaddrList.Count - 1 do begin
      IPaddr := CurrIPaddrList.Items[I];
      if IPaddr.nIPaddr = nIPaddr then begin
        Inc(IPaddr.nCount);
        if GetTickCount - IPaddr.dwIPCountTick1 < nIPCountLimitTime1 then begin
          Inc(IPaddr.nIPCount1);
          if IPaddr.nIPCount1 >= nIPCountLimit1 then
            boDenyConnect := True;
        end
        else begin
          IPaddr.dwIPCountTick1 := GetTickCount();
          IPaddr.nIPCount1 := 0;
        end;
        if GetTickCount - IPaddr.dwIPCountTick2 < nIPCountLimitTime2 then begin
          Inc(IPaddr.nIPCount2);
          if IPaddr.nIPCount2 >= nIPCountLimit2 then
            boDenyConnect := True;
        end
        else begin
          IPaddr.dwIPCountTick2 := GetTickCount();
          IPaddr.nIPCount2 := 0;
        end;
        if IPaddr.nCount > nMaxConnOfIPaddr then
          boDenyConnect := True;

        Result := boDenyConnect;
        exit;
      end;
    end;
    New(IPaddr);
    SafeFillChar(IPaddr^, SizeOf(TSockaddr), 0);
    IPaddr.nIPaddr := nIPaddr;
    IPaddr.nCount := 1;
    CurrIPaddrList.Add(IPaddr);
  finally
    CurrIPaddrList.UnLock;
  end;
end;

procedure TFrmMain.ShowMainLogMsg;
var
  I: Integer;
begin
  if (GetTickCount - dwShowMainLogTick) < 200 then
    Exit;
  dwShowMainLogTick := GetTickCount();
  try
    boShowLocked := True;
    try
      CS_MainLog.Enter;
      if MainLogMsgList.Count > 5 then begin
        TempLogList.add(MainLogMsgList.Strings[MainLogMsgList.Count - 1] + ' ['
          +
          IntToStr(MainLogMsgList.Count) + ']');
      end
      else begin
        for i := 0 to MainLogMsgList.Count - 1 do begin
          TempLogList.Add(MainLogMsgList.Strings[i]);
        end;
      end;
      MainLogMsgList.Clear;
    finally
      CS_MainLog.Leave;
    end;
    for I := 0 to TempLogList.Count - 1 do begin
      MemoLog.Lines.Add(TempLogList.Strings[I]);
    end;
    TempLogList.Clear;
  finally
    boShowLocked := False;
  end;
end;

procedure TFrmMain.SocketStandardSend(sSendMsg: string; UserSession: pTUserSession);
var
  sData, sSendData: string;
  nSendLen: Integer;
begin
  if GetTickCount < UserSession.dwSuspendedTick then begin
    UserSession.sSendString := sSendMsg;
  end else begin
    sSendData := sSendMsg;
    while (sSendData <> '') and (UserSession.Socket.Connected) do begin
      nSendLen := Length(sSendData);
      if nSendLen > MAXSENDMSGLEN then begin
        sData := Copy(sSendData, 1, MAXSENDMSGLEN);
        if UserSession.Socket.SendText(sData) <> -1 then begin
          sSendData := Copy(sSendData, MAXSENDMSGLEN + 1, nSendLen - MAXSENDMSGLEN);
          UserSession.dwSuspendedCount := 0;
        end
        else begin
          Inc(UserSession.dwSuspendedCount);
          UserSession.dwSuspendedTick := GetTickCount + LongWord(500 * UserSession.dwSuspendedCount);
          if UserSession.dwSuspendedCount >= 100 then begin
            UserSession.Socket.Close;
            UserSession.Socket := nil;
            UserSession.SocketHandle := -1;
            MainOutMessage('传输失败:  ' + UserSession.sRemoteIPaddr, 3);
            Exit;
          end;
          Break;
        end;
      end
      else begin
        if UserSession.Socket.SendText(sSendData) <> -1 then begin
          sSendData := '';
          UserSession.dwSuspendedCount := 0;
        end else begin
          Inc(UserSession.dwSuspendedCount);
          UserSession.dwSuspendedTick := GetTickCount + LongWord(500 * UserSession.dwSuspendedCount);
          if UserSession.dwSuspendedCount >= 100 then begin
            UserSession.Socket.Close;
            UserSession.Socket := nil;
            UserSession.SocketHandle := -1;
            MainOutMessage('传输失败:  ' + UserSession.sRemoteIPaddr, 3);
            Exit;
          end;
        end;
        break;
      end;
    end;
    UserSession.sSendString := sSendData;
  end;
end;

procedure TFrmMain.MyMessage(var MsgData: TWmCopyData);
{var
  sData: string;
  wIdent: Word;     }
begin
  {wIdent := HiWord(MsgData.From);
  sData := StrPas(MsgData.CopyDataStruct^.lpData);
  case wIdent of
    GS_QUIT: begin
        if boServiceStart then begin
          StartTimer.Enabled := True;
        end
        else begin
          boClose := True;
          Close();
        end;
      end;
    1: ;
    2: ;
    3: ;
  end;  }
end;

procedure TFrmMain.OnProgramException(Sender: TObject; E: Exception);
begin
  MainOutMessage(E.Message, 0);
end;
  (*
procedure TFrmMain.ProcessUserMsg(UserSession: pTUserSession; sData: string);
var
  sCode, sPos1, sPos2: string;
  DefMsg: TDefaultMessage;
  boSend: Boolean;
begin
  sCode := Copy(sData, 2, length(sData) - 1);
  sPos1 := Copy(sCode, 0, DEFBLOCKSIZE);
  sPos2 := Copy(sCode, DEFBLOCKSIZE + 1, Length(sCode) - DEFBLOCKSIZE);
  DefMsg := DecodeMessage(sPos1);
  boSend := False;
  case DefMsg.Ident of
    {CM_SELECTSERVER: begin
        if sPos2 <> '' then
          boSend := True;
      end;     }
    CM_IDPASSWORD: begin
        if sPos2 <> '' then begin
          sCode := DecodeString(sPos2);
          if TagCount(sCode, '/') = 1 then
            boSend := True;
        end;
      end;
    CM_CHECKMATRIXCARD: begin
        boSend := True;
      end;
    CM_ADDNEWUSER: begin
        //if (GetTickCount - UserSession.dwUserSendTick) > nAddNewUserTime then
        if sPos2 <> '' then
          boSend := True;
      end;
    CM_CHANGEPASSWORD: begin
        //if (GetTickCount - UserSession.dwUserSendTick) > nChangePassword then
        if sPos2 <> '' then begin
          sCode := DecodeString(sPos2);
          if TagCount(sCode, #9) = 2 then
            boSend := True;
        end;
      end; {
    CM_UPDATEUSER: begin
        if sPos2 <> '' then
          boSend := True;
      end;
    CM_GETBACKPASSWORD: begin
        if (GetTickCount - UserSession.dwUserSendTick) > nLoadPassword then
          if sPos2 <> '' then begin
            sCode := DecodeString(sPos2);
            if TagCount(sCode, #9) = 5 then
              boSend := True;
          end;
      end;  }
  end;
  UserSession.dwUserSendTick := GetTickCount();
  if not boSend then begin
    MainOutMessage('非法封包: ' + UserSession.sRemoteIPaddr, 3);
    AttackDispose(UserSession.sRemoteIPaddr, UserSession.Socket);
  end
  else
    SendDataUser(UserSession, g_CodeHead + sData + g_CodeEnd);
end;
         *)
procedure TFrmMain.S1Click(Sender: TObject);
begin
 // MainOutMessage(g_sProductName, 0);
  MainOutMessage(g_sUpDateTime, 0);
  //MainOutMessage(g_sProgram, 0);
  //MainOutMessage(g_sWebSite, 0);
end;

end.

