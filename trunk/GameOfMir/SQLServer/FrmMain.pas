unit FrmMain;

interface

uses
  Windows, Messages, SysUtils, StrUtils, Variants, Classes, Graphics, Controls, Forms, Share, Grobal2,
  Dialogs, StdCtrls, Grids, AppEvnts, JSocket, INIFIles, WinSock, ExtCtrls, SqlMain;

type
  TFormMain = class(TForm)
    GroupBox1: TGroupBox;
    edPort: TEdit;
    Label3: TLabel;
    btStateServer: TButton;
    Label2: TLabel;
    cbAddrs: TComboBox;
    btAddAddrs: TButton;
    btDelAddrs: TButton;
    GroupBox3: TGroupBox;
    mmoLog: TMemo;
    GroupBox2: TGroupBox;
    MonitorGrid: TStringGrid;
    SSocket: TServerSocket;
    ApplicationEvents: TApplicationEvents;
    DecodeTimer: TTimer;
    Timer: TTimer;
    edWEBProt: TEdit;
    Label1: TLabel;
    WEBSocket: TServerSocket;
    grp1: TGroupBox;
    lbl1: TLabel;
    lbl2: TLabel;
    lbl3: TLabel;
    lblreg: TLabel;
    lblLogin: TLabel;
    lblSendEmail: TLabel;
    lbl11: TLabel;
    lblRegOk: TLabel;
    tmr1: TTimer;
    lbl13: TLabel;
    lblChangepass: TLabel;
    lbl15: TLabel;
    lblLostpass: TLabel;
    tmr2: TTimer;
    lbl4: TLabel;
    lblGameGold: TLabel;
    lbl5: TLabel;
    lblwebGameGold: TLabel;
    lbl6: TLabel;
    lblCheckID: TLabel;
    chk1: TCheckBox;
    procedure ApplicationEventsException(Sender: TObject; E: Exception);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure edPortChange(Sender: TObject);
    procedure btAddAddrsClick(Sender: TObject);
    procedure btDelAddrsClick(Sender: TObject);
    procedure btStateServerClick(Sender: TObject);
    procedure DecodeTimerTimer(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure SSocketClientError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure SSocketListen(Sender: TObject; Socket: TCustomWinSocket);
    procedure SSocketClientConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure SSocketClientDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure SSocketClientRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure edWEBProtChange(Sender: TObject);
    procedure WEBSocketListen(Sender: TObject; Socket: TCustomWinSocket);
    procedure WEBSocketClientError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure WEBSocketClientConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure WEBSocketClientDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure WEBSocketClientRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure tmr1Timer(Sender: TObject);
    procedure tmr2Timer(Sender: TObject);
    procedure chk1Click(Sender: TObject);
  private
    m_boRun: Boolean;
    m_nRegCount: Integer;
    m_nLoginCount: Integer;
    m_nRegOkCount: Integer;
    m_nChangePassOk: Integer;
    m_nChangePassFail: Integer;
    m_nLostPassOk: Integer;
    m_nLostPassFail: Integer;
    m_nLostPassChange: Integer;
    m_nGameGoldCount: Integer;
    m_nWEBGameGoldCount: Integer;
    m_nWEBGoldCount: Integer;
    m_nWEBOutGoldCount: Integer;
    m_nCheckAccountCount: Integer;
    procedure SaveAddrList;
    procedure ClearSessionArray();
    procedure InitializeUserSession(UserSession: pTUserSession);
    procedure SendRegOkMail(sEMail, sKey, sAccount, sURL: string);
    procedure SendLostPasswordMail(sEMail, sAccount, sKey, sURL: string);
    function IsAllowIP(sRemoteIPaddr: string): Boolean;
    function ProcessHttpMsg(sData: string): string;
    function ProcessCreateNewCDKey(sData: string): string;
    function ProcessCheckCDKey(sData: string): string;
    function ProcessreSendEMail(sData: string): string;
    function ProcessChangeEMail(sData: string): string;
    function ProcessSetEMailOK(sData: string): string;
    function ProcessChangePassword(sData: string): string;
    function ProcessCheckLostPassword(sData: string): string;
    function ProcessreSendLostPassword(sData: string): string;
    function ProcessreSetLostPassword(sData: string): string;
    function ProcessreGameGoldChange(sData: string): string;
    procedure ProcessUserLogin(UserSession: pTUserSession; Msg: pTDefaultMessage; sData: string);
    procedure ProcessNewChr(UserSession: pTUserSession; Msg: pTDefaultMessage; sData: string);
    procedure ProcessNewGuild(UserSession: pTUserSession; Msg: pTDefaultMessage; sData: string);
    procedure ProcessGoldChange(UserSession: pTUserSession; Msg: pTDefaultMessage; sData: string);
    procedure ProcessGetLargessGold(UserSession: pTUserSession; Msg: pTDefaultMessage; sData: string);

    procedure ProcessUserMsg(UserSession: pTUserSession; sMsg: string);

    procedure SendKeepAlive(UserSession: pTUserSession);
    procedure SendKickUser(sAccount: string);
    procedure SendGameGoldChange(sAccount: string; nGoldCount: Integer);
    procedure SendSocket(UserSession: pTUserSession; sSendMsg: string);
    procedure SendAllSocket(sSendMsg: string);
    procedure AppendSendData(UserSession: pTUserSession; sSendMsg: string);
  public

  end;

var
  FormMain: TFormMain;

implementation

{$R *.dfm}

uses
  Hutil32, EDCode, Common, MyCommon, MD5Unit, SendEmail;

const
  INIFILENAME = '.\Setup.ini';

var
  Ini: TINIFile;

procedure TFormMain.AppendSendData(UserSession: pTUserSession; sSendMsg: string);
begin
  UserSession.SendString := UserSession.SendString + sSendMsg;
end;

procedure TFormMain.ApplicationEventsException(Sender: TObject; E: Exception);
begin
  //
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
{var
  UserID, UserGold: Integer;
  checkemail: integer;
  addrs: string;     }
begin

  {MainOutMessage(IntToStr(SQL.UserLogin('hfhclrdfnn', '07ace5dadb7e5e2f', '192.168.1.1', UserID, UserGold, addrs, checkemail)));
  MainOutMessage('UserID = ' + IntToStr(UserID));
  MainOutMessage('UserGold = ' + IntToStr(UserGold));
  MainOutMessage('addrs = ' + addrs);
  MainOutMessage('checkemail = ' + IntToStr(checkemail)); }
  if (cbAddrs.ItemIndex >= 0) and (cbAddrs.ItemIndex < cbAddrs.Items.Count) then begin
    cbAddrs.Items.Delete(cbAddrs.ItemIndex);
    SaveAddrList;
  end;
  cbAddrs.Text := Format('允许地址：%d', [cbAddrs.Items.Count]);
end;

procedure TFormMain.btStateServerClick(Sender: TObject);
begin
  btStateServer.Enabled := False;
  DecodeTimer.Enabled := False;
  Timer.Enabled := False;
  if SSocket.Active then begin
    btStateServer.Caption := '正在停止..';
    MainOutMessage('正在停止服务...');
    SSocket.Active := False;
    WEBSocket.Active := False;
    ClearSessionArray;
    g_nSessionCount := 0;

  end
  else begin
    btStateServer.Caption := '正在启动..';
    MainOutMessage('正在启动服务...');
    ClearSessionArray;
    g_nSessionCount := 0;
    SSocket.Port := StrToIntDef(edPort.Text, 20000);
    SSocket.Active := True;
    WEBSocket.Port := StrToIntDef(edWEBProt.Text, 8080);
    WEBSocket.Active := True;
  end;

  if SSocket.Active and WEBSocket.Active then begin
    btStateServer.Caption := '停止服务(&S)';
    edPort.Enabled := False;
    edWEBProt.Enabled := False;
    Timer.Enabled := True;
{$IFDEF TESTRELEASE}
    if SQL.Conn then
      MainOutMessage('连接SQL服务器成功...');
{$ENDIF}
    MainOutMessage('服务启动完成...');
  end
  else begin
    WEBSocket.Active := False;
    SSocket.Active := False;
    Timer.Enabled := False;
    btStateServer.Caption := '启动服务(&S)';
    edPort.Enabled := True;
    edWEBProt.Enabled := True;
    SQL.UnConn;
    MainOutMessage('服务已停止...');
  end;
  btStateServer.Enabled := True;
end;

procedure TFormMain.chk1Click(Sender: TObject);
begin
  Ini.WriteBool('Setup', 'IISVer', chk1.Checked);
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

function TFormMain.ProcessCheckLostPassword(sData: string): string;
var
  sAccount, sEMail, sURL, sKey: string;
  nUserID: Integer;
begin
  Result := '-1';
  sData := GetValidStrEx(Utf8ToAnsi(sData), sAccount, ['&']);
  sData := GetValidStrEx(sData, sEMail, ['&']);
  sData := GetValidStrEx(sData, sURL, ['&']);
  sAccount := LowerCase(sAccount);
  sEMail := LowerCase(sEMail);
  if not (Length(sAccount) in [5..16]) then exit;
  if not CheckCDKeyRule(sAccount) then exit;
  if not CheckEMailRule(sEMail) then exit;
  sKey := GetMD5Text(sAccount + sEMail + DateTimeToStr(Now) + IntToStr(GetTickCount) + IntToStr(Random(99999)));
  if SQL.CheckLostPassword(sAccount, sEMail, sKey, nUserID) then begin
    Inc(m_nLostPassOk);
    Result := LowerCase(IntToHex(nUserID, 0)) + sKey;
    SendLostPasswordMail(sEMail, sAccount, Result, HTTPDecode(sURL));
  end else Inc(m_nLostPassFail);
end;

function TFormMain.ProcessChangePassword(sData: string): string;
var
  sAccount, sPassword, sNewPassword: string;
begin
  Result := '-2';
  sData := GetValidStrEx(Utf8ToAnsi(sData), sAccount, ['&']);
  sData := GetValidStrEx(sData, sPassword, ['&']);
  sData := GetValidStrEx(sData, sNewPassword, ['&']);
  sAccount := LowerCase(sAccount);
  sPassWord := LowerCase(sPassWord);
  sNewPassword := LowerCase(sNewPassword);
  if not (Length(sAccount) in [5..16]) then exit;
  if not CheckCDKeyRule(sAccount) then exit;
  if not (Length(sPassWord) = 16) then exit;
  if not CheckMD5Rule(sPassWord) then exit;
  if not (Length(sNewPassword) = 16) then exit;
  if not CheckMD5Rule(sNewPassword) then exit;
  if SQL.ChangePassWord(sAccount, sPassword, sNewPassword) then begin
    Inc(m_nChangePassOk);
    SendKickUser(sAccount);
    Result := '1'
  end
  else begin
    Inc(m_nChangePassFail);
    Result := '-3';
  end;
end;

function TFormMain.processCheckCDKey(sData: string): string;
begin
  Result := WEB_MSGCODE_CDKEY_EXIST;
  if sData <> '' then begin
    sData := LowerCase(sData);
    if not (Length(sData) in [5..16]) then exit;
    if not CheckCDKeyRule(sData) then exit;
    Inc(m_nCheckAccountCount);
    if not SQL.CheckCDKey(sData) then
      Result := WEB_MSGCODE_CDKEY_NOTEXIST;
  end;
end;

function TFormMain.ProcessCreateNewCDKey(sData: string): string;
{
//注册账号规则
账号长度6-16位,只能由a-z和0-9以及_组成
密码任意,将进行MD5加密,固定长度16位,取MD5中间16位,传过来的参数已经进行了MD5加密
sBirthDay, sPhone, sMobilePhone, sIdentityCard 都只能为数字
sQuiz1, sAnswer1, sQuiz2, sAnswer2 长度10-20

}
{var
  sAccount, sPassWord, sUserName, sBirthDay, sQuiz1, sAnswer1, sQuiz2, sAnswer2,
    sEMail, sPhone, sMobilePhone, sIdentityCard: string;
  nBack: Integer;  }
var
  sAccount, sPassWord, sKey, sIntroducer, sEMail, sURL: string;
  nBack, nIntroducer: Integer;
begin
  Result := WEB_MSGCODE_CREATEKEY1;

  sData := GetValidStrEx(Utf8ToAnsi(sData), sAccount, ['&']);
  sData := GetValidStrEx(sData, sPassWord, ['&']);
  sData := GetValidStrEx(sData, sEMail, ['&']);
  sData := GetValidStrEx(sData, sIntroducer, ['&']);
  sData := GetValidStrEx(sData, sKey, ['&']);
  sData := GetValidStrEx(sData, sURL, ['&']);
  sAccount := LowerCase(HTTPDecode(sAccount));
  sPassWord := LowerCase(sPassWord);
  sKey := LowerCase(sKey);
  sEMail := LowerCase(HTTPDecode(sEMail));
  nIntroducer := StrToIntDef(HTTPDecode(sIntroducer), 0);
  //MainOutMessage(sIntroducer + ' - ' + IntToStr(nIntroducer));
  if not (Length(sAccount) in [5..10]) then exit;
  if not CheckCDKeyRule(sAccount) then exit;
  if not (Length(sPassWord) = 16) then exit;
  if not CheckMD5Rule(sPassWord) then exit;
  if not CheckEMailRule(sEMail) then exit;
  //if not CheckSQLCMDFiltr(sEMail) then exit;
  if not (Length(sKey) = 32) then exit;
  if not CheckMD5Rule(sKey) then exit;

  nBack := SQL.CreateNewCDKey(sAccount, sPassWord, '', '', '', '', '', '', sEMail, '', '', '', nIntroducer);
  if nBack > 0 then begin
    Inc(m_nRegCount);
    Result := IntToStr(nBack);
    SendRegOkMail(sEMail, sKey, sAccount, HTTPDecode(sURL));
  end
  else begin
    case nBack of
      -1: Result := WEB_MSGCODE_SYSERROR;
      -2: Result := WEB_MSGCODE_CREATEKEY2;
    end;
  end;
  (*Result := WEB_MSGCODE_CREATEKEY1;

  sData := GetValidStrEx(Utf8ToAnsi(sData), sAccount, ['&']);
  sData := GetValidStrEx(sData, sPassWord, ['&']);
  sData := GetValidStrEx(sData, sEMail, ['&']);
  sData := GetValidStrEx(sData, sUserName, ['&']);
  sData := GetValidStrEx(sData, sBirthDay, ['&']);
  sData := GetValidStrEx(sData, sQuiz1, ['&']);
  sData := GetValidStrEx(sData, sAnswer1, ['&']);
  sData := GetValidStrEx(sData, sQuiz2, ['&']);
  sData := GetValidStrEx(sData, sAnswer2, ['&']);
  sData := GetValidStrEx(sData, sPhone, ['&']);
  sData := GetValidStrEx(sData, sMobilePhone, ['&']);
  sData := GetValidStrEx(sData, sIdentityCard, ['&']);
  sAccount := LowerCase(sAccount);
  sPassWord := LowerCase(sPassWord);
  if not (Length(sAccount) in [5..16]) then
    exit;
  if not CheckCDKeyRule(sAccount) then
    exit;
  if not (Length(sPassWord) = 16) then
    exit;
  if not CheckMD5Rule(sPassWord) then
    exit;
  if not CheckEMailRule(sEMail) then
    exit;
  if not CheckSQLCMDFiltr(sEMail) then
    exit;
  if not CheckIntStrRule(sBirthDay) then
    exit;
  if not CheckIntStrRule(sPhone) then
    exit;
  if not CheckIntStrRule(sMobilePhone) then
    exit;
  if not CheckIntStrRule(sIdentityCard) then
    exit;
  if (sQuiz1 = '') or (sAnswer1 = '') then begin
    sQuiz1 := '';
    sAnswer1 := '';
  end;
  if (sQuiz2 = '') or (sAnswer2 = '') then begin
    sQuiz2 := '';
    sAnswer2 := '';
  end;
  nBack := SQL.CreateNewCDKey(sAccount, sPassWord, sUserName, sBirthDay, sQuiz1, sAnswer1, sQuiz2, sAnswer2,
    sEMail, sPhone, sMobilePhone, sIdentityCard);
  if nBack > 0 then begin
    Result := IntToStr(nBack);
    SendRegOkMail(sEMail, Result, sAccount);
  end
  else begin
    case nBack of
      -1: Result := WEB_MSGCODE_SYSERROR;
      -2: Result := WEB_MSGCODE_CREATEKEY2;
    end;
  end;     *)
end;

function TFormMain.ProcessHttpMsg(sData: string): string;
var
  sMsgCode, sParam: string;
  btMsgCode: Byte;
begin
  Result := WEB_MSGCODE_SYSERROR;
  sParam := GetValidStr3(sData, sMsgCode, ['&']);
  //sParam := GetValidStr3(sData, sData, ['=']);
  //sMsgCode := GetValidStr3(sMsg, sMsg, ['=']);
  btMsgCode := StrToIntDef(sMsgCode, 0);
  if (sParam <> '') and (btMsgCode > 0) then begin
    case btMsgCode of
      1: Result := ProcessCreateNewCDKey(sParam);
      2: Result := ProcessCheckCDKey(sParam);
      3: Result := ProcessreSendEMail(sParam);
      4: Result := ProcessChangeEMail(sParam);
      5: Result := ProcessSetEMailOK(sParam);
      6: Result := ProcessChangePassword(sParam);
      7: Result := ProcessCheckLostPassword(sParam);
      8: Result := ProcessreSendLostPassword(sParam);
      9: Result := ProcessreSetLostPassword(sParam);
      10: Result := ProcessreGameGoldChange(sParam);
    end;
  end;
end;

procedure TFormMain.DecodeTimerTimer(Sender: TObject);
const
  MAXSENDCOUNT = 8192;
var
  UserSession: pTUserSession;
  nSockIndex: Integer;
  sMsg, sData: string;
  nLen: Integer;
begin
  if m_boRun then
    exit;
  m_boRun := True;
  try
    for nSockIndex := Low(g_SessionArray) to High(g_SessionArray) do begin
      UserSession := @g_SessionArray[nSockIndex];
      if (UserSession.Socket <> nil) and UserSession.Socket.Connected then begin
        while (UserSession.SendString <> '') do begin
          nLen := Length(UserSession.SendString);
          if nLen > MAXSENDCOUNT then begin
            sData := Copy(UserSession.SendString, 1, MAXSENDCOUNT);
            if UserSession.Socket.SendText(sData) <> -1 then begin
              UserSession.SendString := Copy(UserSession.SendString, MAXSENDCOUNT + 1, nLen - MAXSENDCOUNT);
            end
            else
              break;
          end
          else begin
            if UserSession.Socket.SendText(UserSession.SendString) <> -1 then
              UserSession.SendString := '';
            break;
          end;
        end;
        if UserSession.ReadString <> '' then begin
          sMsg := UserSession.ReadString;
          UserSession.ReadString := '';
          while (sMsg <> '') do begin
            if Pos(g_CodeEnd, sMsg) > 0 then begin
              sMsg := ArrestStringEx(sMsg, g_CodeHead, g_CodeEnd, sData);
              if Length(sData) >= DEFBLOCKSIZE then begin
                ProcessUserMsg(UserSession, sData);
              end;
            end
            else
              break;
          end;
          UserSession.ReadString := sMsg;
        end;
      end;
    end;
  finally
    m_boRun := False;
  end;
end;

procedure TFormMain.ProcessNewChr(UserSession: pTUserSession; Msg: pTDefaultMessage; sData: string);
var
  sChrName, sAccount: string;
  DefMsg: TDefaultMessage;
begin
  sAccount := DecodeString(sData);
  sChrName := GetValidStr3(sAccount, sAccount, ['/']);
  if (length(sChrName) in [6..14]) and CheckCorpsChr(sChrName) then begin
{$IFDEF TESTRELEASE}
    if SQL.CreateNewChr(sChrName) then begin
      DefMsg := MakeDefaultMsg(SQL_SM_NEWCHR_OK, Msg.Recog, Msg.Param, Msg.tag, Msg.Series);
      SendSocket(UserSession, EncodeMessage(DefMsg) + sData);
    end else begin
      DefMsg := MakeDefaultMsg(SQL_SM_NEWCHR_FAIL, Msg.Recog, Msg.Param, Msg.tag, Msg.Series);
      SendSocket(UserSession, EncodeMessage(DefMsg));
    end;
{$ELSE}
    DefMsg := MakeDefaultMsg(SQL_SM_NEWCHR_OK, Msg.Recog, Msg.Param, Msg.tag, Msg.Series);
    SendSocket(UserSession, EncodeMessage(DefMsg) + sData);
{$ENDIF}
  end;
end;

procedure TFormMain.ProcessNewGuild(UserSession: pTUserSession; Msg: pTDefaultMessage; sData: string);
var
  sGuildName: string;
  DefMsg: TDefaultMessage;
begin
  sGuildName := DecodeString(sData);
  if (length(sGuildName) in [6..14]) and CheckCorpsChr(sGuildName) then begin
{$IFDEF TESTRELEASE}
    if SQL.CreateNewGuild(sGuildName) then begin
      DefMsg := MakeDefaultMsg(SQL_SM_NEWGUILD_OK, Msg.Recog, Msg.Param, Msg.tag, Msg.Series);
      SendSocket(UserSession, EncodeMessage(DefMsg) + sData);
    end else begin
      DefMsg := MakeDefaultMsg(SQL_SM_NEWGUILD_FAIL, Msg.Recog, Msg.Param, Msg.tag, Msg.Series);
      SendSocket(UserSession, EncodeMessage(DefMsg));
    end;
{$ELSE}
    DefMsg := MakeDefaultMsg(SQL_SM_NEWGUILD_OK, Msg.Recog, Msg.Param, Msg.tag, Msg.Series);
    SendSocket(UserSession, EncodeMessage(DefMsg) + sData);
{$ENDIF}
  end;
end;

function TFormMain.ProcessreGameGoldChange(sData: string): string;
var
  sAccount, sLogIndex, sGold, sServerName, sGameGold: string;
  nBack, nGameGold, nGoldCount, nGold: Integer;
begin
  Result := '-1';
  //MainOutMessage(sData);
  sData := GetValidStrEx(Utf8ToAnsi(sData), sAccount, ['&']);
  sData := GetValidStrEx(sData, sGameGold, ['&']);
  sData := GetValidStrEx(sData, sGold, ['&']);
  sData := GetValidStrEx(sData, sLogIndex, ['&']);
  sData := GetValidStrEx(sData, sServerName, ['&']);
  sAccount := LowerCase(sAccount);
  nGameGold := StrToIntDef(sGameGold, 0);
  nGold := StrToIntDef(sGold, -1);
  if not (Length(sAccount) in [5..16]) then exit;
  if not CheckCDKeyRule(sAccount) then exit;
  if (nGameGold <= 0) or (nGameGold >= 1000000) or (nGold < 0) or (nGold >= 1000000) then exit;
  if (sServerName <> '') and (sLogIndex <> '') and (Length(sLogIndex) < 50) then begin
    nBack := SQL.GameGoldChange(0, nGameGold, sLogIndex, sAccount, '#' + sGold, sServerName, True, nGold, nGoldCount);
    if (nBack = 1) then begin
      Inc(m_nWEBGameGoldCount, nGameGold);
      Inc(m_nWEBGoldCount, nGold);
      MainOutMessage(Format('[充值]：%s/%d/%d', [sAccount, nGameGold, nGold]));
      SendGameGoldChange(sAccount, nGoldCount);
      Result := '1';
    end;
  end;
end;

function TFormMain.ProcessreSendEMail(sData: string): string;
var
  sAccount, sEMail, sKey, sURL: string;
begin
  Result := '-1';
  sData := GetValidStrEx(Utf8ToAnsi(sData), sAccount, ['&']);
  sData := GetValidStrEx(sData, sEMail, ['&']);
  sData := GetValidStrEx(sData, sKey, ['&']);
  sData := GetValidStrEx(sData, sURL, ['&']);
  sAccount := LowerCase(sAccount);
  sKey := LowerCase(sKey);
  sEMail := LowerCase(sEMail);
  if not (Length(sAccount) in [5..16]) then exit;
  if not CheckCDKeyRule(sAccount) then exit;
  if not CheckEMailRule(sEMail) then exit;
  //if not CheckSQLCMDFiltr(sEMail) then exit;
  if not (Length(sKey) = 32) then exit;
  if not CheckMD5Rule(sKey) then exit;
  SendRegOkMail(sEMail, sKey, sAccount, HTTPDecode(sURL));
  Result := '1';
end;

function TFormMain.ProcessreSetLostPassword(sData: string): string;
var
  sAccount, sPassword, sKey, sID: string;
begin
  Result := '-1';
  sData := GetValidStrEx(Utf8ToAnsi(sData), sAccount, ['&']);
  sData := GetValidStrEx(sData, sPassword, ['&']);
  sData := GetValidStrEx(sData, sKey, ['&']);
  sAccount := LowerCase(sAccount);
  sPassword := LowerCase(sPassword);
  sKey := LowerCase(sKey);
  if not (Length(sAccount) in [5..16]) then exit;
  if not CheckCDKeyRule(sAccount) then exit;
  if not (Length(sPassWord) = 16) then exit;
  if not CheckMD5Rule(sPassWord) then exit;
  if not (Length(sKey) in [33..40]) then exit;
  if not CheckMD5Rule(sKey) then exit;
  sID := Copy(sKey, 1, Length(sKey) - 32);
  sKey := Copy(sKey, Length(sID) + 1, 32);
  if SQL.SetLostPassword(StrToIntDef('$' + sID, 0), sAccount, sPassword, sKey) then begin
    Inc(m_nLostPassChange);
    SendKickUser(sAccount);
    Result := '1';
  end;
end;

function TFormMain.ProcessreSendLostPassword(sData: string): string;
var
  sAccount, sEMail, sKey, sURL: string;
begin
  Result := '-1';
  sData := GetValidStrEx(Utf8ToAnsi(sData), sAccount, ['&']);
  sData := GetValidStrEx(sData, sEMail, ['&']);
  sData := GetValidStrEx(sData, sKey, ['&']);
  sData := GetValidStrEx(sData, sURL, ['&']);
  sAccount := LowerCase(sAccount);
  sKey := LowerCase(sKey);
  sEMail := LowerCase(sEMail);
  if not (Length(sAccount) in [5..16]) then exit;
  if not CheckCDKeyRule(sAccount) then exit;
  if not CheckEMailRule(sEMail) then exit;
  if not (Length(sKey) in [33..40]) then exit;
  if not CheckMD5Rule(sKey) then exit;
  SendLostPasswordMail(sEMail, sAccount, sKey, HTTPDecode(sURL));
  Result := '1';
end;

function TFormMain.ProcessSetEMailOK(sData: string): string;
var
  nUserID: Integer;
begin
  Result := '-2';
  nUserID := StrToIntDef(Utf8ToAnsi(sData), -1);
  if (nUserID > 0) then begin
    if SQL.SetEmailCheckOK(nUserID) then begin
      Inc(m_nRegOkCount);
      Result := '1';
    end else
      Result := '-1';
  end;
end;

function TFormMain.ProcessChangeEMail(sData: string): string;
var
  sUserID, sAccount, sEMail, sKey, sURL: string;
  nUserID: Integer;
begin
  Result := '-1';
  sData := GetValidStrEx(Utf8ToAnsi(sData), sUserID, ['&']);
  sData := GetValidStrEx(sData, sAccount, ['&']);
  sData := GetValidStrEx(sData, sEMail, ['&']);
  sData := GetValidStrEx(sData, sKey, ['&']);
  sData := GetValidStrEx(sData, sURL, ['&']);
  sAccount := LowerCase(sAccount);
  sKey := LowerCase(sKey);
  sEMail := LowerCase(sEMail);
  nUserID := StrToIntDef(sUserID, -1);
  if nUserID <= 0 then Exit;
  if not (Length(sAccount) in [5..16]) then exit;
  if not CheckCDKeyRule(sAccount) then exit;
  if not CheckEMailRule(sEMail) then exit;
  //if not CheckSQLCMDFiltr(sEMail) then exit;
  if not (Length(sKey) = 32) then exit;
  if not CheckMD5Rule(sKey) then exit;
  if SQL.SetUserEmail(nUserID, sEMail) then begin
    SendRegOkMail(sEMail, sKey, sAccount, HTTPDecode(sURL));
    Result := '1';
  end;
end;

procedure TFormMain.ProcessGetLargessGold(UserSession: pTUserSession; Msg: pTDefaultMessage; sData: string);
var
  DefMsg: TDefaultMessage;
  sAccount, sChrName: string;
  nGoldCount: Integer;
begin
  sData := DecodeString(sData);
  sData := GetValidStr3(sData, sAccount, ['/']);
  sData := GetValidStr3(sData, sChrName, ['/']);
  nGoldCount := 0;
  //MainOutMessage(sAccount + '/' + sChrName);
  if (sAccount <> '') and (sChrName <> '') then begin
    nGoldCount := SQL.GetLargessGold(sAccount, sChrName, UserSession.ServerName);
    if nGoldCount < 0 then nGoldCount := 0;
    Inc(m_nWEBOutGoldCount, nGoldCount);
  end;
  //MainOutMessage(IntToStr(nGoldCount));
  DefMsg := MakeDefaultMsg(SQL_SM_GETLARGESSGOLD, Msg.Recog, Msg.Param, Msg.tag, Msg.Series);
  SendSocket(UserSession, EncodeMessage(DefMsg) + EncodeString(IntToStr(nGoldCount)));
end;

procedure TFormMain.ProcessGoldChange(UserSession: pTUserSession; Msg: pTDefaultMessage; sData: string);
var
  DefMsg: TDefaultMessage;
{$IFDEF TESTRELEASE}
  sDel, sCount, sIDIndex, sAccount, sChrName: string;
  nCount, nIDIndex: Integer;
  boDel: Boolean;
  nBack: Integer;
  nGoldCount: Integer;
{$ENDIF}
begin
{$IFDEF TESTRELEASE}
  sData := DecodeString(sData);
  sData := GetValidStr3(sData, sDel, ['/']);
  sData := GetValidStr3(sData, sCount, ['/']);
  sData := GetValidStr3(sData, sIDIndex, ['/']);
  sChrName := GetValidStr3(sData, sAccount, ['/']);
  nCount := StrToIntDef(sCount, 0);
  nIDIndex := StrToIntDef(sIDIndex, 0);
  boDel := (sDel = '1');
  nBack := -6;
  nGoldCount := 0;
  if (nCount > 0) and (nIDIndex > 0) and (sChrName <> '') and (sAccount <> '') then begin
    nBack := SQL.GameGoldChange(nIDIndex, nCount, IntToStr(Msg.Recog), sAccount, sChrName, UserSession.ServerName, not boDel, 0, nGoldCount);
    if nBack = 1 then begin
      if boDel then Inc(m_nGameGoldCount, nCount)
      else Dec(m_nGameGoldCount, nCount);
    end;
  end;
  DefMsg := MakeDefaultMsg(SQL_SM_GAMEGOLDCHANGE, Msg.Recog, Msg.Param, Msg.tag, Msg.Series);
  SendSocket(UserSession, EncodeMessage(DefMsg) + EncodeString(IntToStr(nBack) + '/' + IntToStr(nGoldCount)));
{$ELSE}
  DefMsg := MakeDefaultMsg(SQL_SM_GAMEGOLDCHANGE, Msg.Recog, Msg.Param, Msg.tag, Msg.Series);
  SendSocket(UserSession, EncodeMessage(DefMsg) + EncodeString('1/9999999'));
{$ENDIF}
end;

procedure TFormMain.ProcessUserLogin(UserSession: pTUserSession; Msg: pTDefaultMessage; sData: string);
  function GetCardStrToInt(btIdx: Byte; sCard: string): Byte;
  var
    sInt: string;
  begin
    Result := 0;
    if (Length(sCard) = 16) and (btIdx <= 7) then begin
      sInt := Copy(sCard, btIdx * 2 + 1, 2);
      Result := StrToIntDef('$' + sInt, 0);
    end;
  end;
var
  sPassword, sLoginID, sLoginAddrs: string;
  DefMsg: TDefaultMessage;
  //boCheckEMail: Boolean;
{$IFDEF TESTRELEASE}
  nBack: Integer;
  //UserID, UserGold: Integer;
  btCard1, btCard2, btCard3: Byte;
  btCardID1, btCardID2, btCardID3: Byte;
  sCard1, sCard2, sCard3: string;
  UserLoginInfo: TUserLoginInfo;
{$ENDIF}
begin
  sData := GetValidStr3(DecodeString(sData), sLoginID, ['/', ' ']);
  sLoginAddrs := GetValidStr3(sData, sPassword, ['/', ' ']);
  sLoginID := LowerCase(sLoginID);
  //MainOutMessage('A:' + sLoginID);
  //MainOutMessage('P:' + sPassword);
  if not (Length(sLoginID) in [5..16]) then exit;
  if (sLoginAddrs = '') then exit;
  if not CheckCDKeyRule(sLoginID) then exit;
  if not (Length(sPassword) = 16) then exit;
  if not CheckMD5Rule(sPassword) then exit;
{$IFDEF TESTDEBUG}
  DefMsg := MakeDefaultMsg(SQL_SM_USERLOGIN_OK, Msg.Recog, 0, 0, 0);
  SendSocket(UserSession, EncodeMessage(DefMsg) + EncodeString(sLoginID + '/1000/9999999'));
{$ELSE}
  //MainOutMessage('S:' + sLoginID + '/' + sPassword);
  nBack := SQL.UserLogin(sLoginID, sPassword, sLoginAddrs, @UserLoginInfo);
  //MainOutMessage(Format('B: %d/%d/%s', [nBack, UserID, sLoginAddrs]));
  if (nBack > 0) and (UserLoginInfo.UserID > 0) then begin
    btCard1 := 0;
    btCard2 := 0;
    btCard3 := 0;
    btCardID1 := 0;
    btCardID2 := 0;
    btCardID3 := 0;
    if nBack > 1 then begin
      btCard1 := Random(79) + 1;
      btCard2 := Random(79) + 1;
      btCard3 := Random(79) + 1;
      if SQL.GetMatrixCard(nBack - 1, Char(btCard1 div 8 + 65), Char(btCard2 div 8 + 65), Char(btCard3 div 8 + 65),
         sCard1, sCard2, sCard3) then
      begin
        btCardID1 := GetCardStrToInt(btCard1 mod 8, sCard1);
        btCardID2 := GetCardStrToInt(btCard2 mod 8, sCard2);
        btCardID3 := GetCardStrToInt(btCard3 mod 8, sCard3);
      end else begin
        btCard1 := 0;
        btCard2 := 0;
        btCard3 := 0;
      end;
    end;
    Inc(m_nLoginCount);
    DefMsg := MakeDefaultMsg(SQL_SM_USERLOGIN_OK, Msg.Recog,
      MakeWord(btCard1, btCardID1), MakeWord(btCard2, btCardID2), MakeWord(btCard3, btCardID3));
    SendSocket(UserSession, EncodeMessage(DefMsg) + EncodeString(sLoginID + '/' + IntToStr(UserLoginInfo.UserID) + '/' + IntToStr(UserLoginInfo.UserGold) + '/' + IntToStr(Integer(UserLoginInfo.CheckEMail))));
  end else begin
    DefMsg := MakeDefaultMsg(SQL_SM_USERLOGIN_FAIL, Msg.Recog, abs(nBack), 0, 0);
    SendSocket(UserSession, EncodeMessage(DefMsg));
  end;
{$ENDIF}
end;

procedure TFormMain.ProcessUserMsg(UserSession: pTUserSession; sMsg: string);
var
  sDefMsg: string;
  sData: string;
  DefMsg: TDefaultMessage;
  sServerName, sServerCount: string;
begin
  sDefMsg := Copy(sMsg, 1, DEFBLOCKSIZE);
  sData := Copy(sMsg, DEFBLOCKSIZE + 1, length(sMsg) - DEFBLOCKSIZE);
  DefMsg := DecodeMessage(sDefMsg);
  case DefMsg.Ident of
    SQL_KEEPALIVE: begin
        UserSession.dwKeepAliveTick := GetTickCount;
        if sData <> '' then begin
          sData := DecodeString(sData);
          sData := GetValidStr3(sData, sServerName, ['/']);
          sData := GetValidStr3(sData, sServerCount, ['/']);
          UserSession.ServerName := sServerName;
          UserSession.ServerCount := sServerCount;
        end;
        SendKeepAlive(UserSession);
      end;
    SQL_CM_USERLOGIN: begin
        if sData <> '' then
          ProcessUserLogin(UserSession, @DefMsg, sData);
      end;
    SQL_CM_NEWCHR: begin
        if sData <> '' then
          ProcessNewChr(UserSession, @DefMsg, sData);
      end;
    SQL_CM_NEWGUILD: begin
        if sData <> '' then
          ProcessNewGuild(UserSession, @DefMsg, sData);
      end;
    SQL_CM_GAMEGOLDCHANGE: begin
        if sData <> '' then
          ProcessGoldChange(UserSession, @DefMsg, sData);
      end;
    SQL_CM_GETLARGESSGOLD: begin
        if sData <> '' then
          ProcessGetLargessGold(UserSession, @DefMsg, sData);
      end;
  end;
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

procedure TFormMain.SendAllSocket(sSendMsg: string);
var
  nSockIndex: Integer;
  UserSession: pTUserSession;
begin
  for nSockIndex := Low(g_SessionArray) to High(g_SessionArray) do begin
    UserSession := @g_SessionArray[nSockIndex];
    if (UserSession.Socket <> nil) and UserSession.Socket.Connected then begin
      SendSocket(UserSession, sSendMsg);
    end;
  end;
end;

procedure TFormMain.SendGameGoldChange(sAccount: string; nGoldCount: Integer);
var
  DefMsg: TDefaultMessage;
begin
  DefMsg := MakeDefaultMsg(SQL_SM_GAMEGOLDCHANGE_EX, nGoldCount, 0, 0, 0);
  SendAllSocket(EncodeMessage(DefMsg) + EncodeString(sAccount));
end;

procedure TFormMain.SendKeepAlive(UserSession: pTUserSession);
var
  DefMsg: TDefaultMessage;
begin
  DefMsg := MakeDefaultMsg(SQL_KEEPALIVE, 0, 0, 0, 0);
  SendSocket(UserSession, EncodeMessage(DefMsg));
end;

procedure TFormMain.SendKickUser(sAccount: string);
var
  DefMsg: TDefaultMessage;
begin
  DefMsg := MakeDefaultMsg(SQL_SM_KICKUSER, 0, 0, 0, 0);
  SendAllSocket(EncodeMessage(DefMsg) + EncodeString(sAccount));
end;

procedure TFormMain.SendRegOkMail(sEMail, sKey, sAccount, sURL: string);
var
  HtmlList: TStringList;
  SendStr: string;
begin
  if FileExists('reg.html') then begin
    HtmlList := TStringList.Create;
    Try
      Try
        HtmlList.LoadFromFile('reg.html');
        SendStr := HtmlList.Text;
        SendStr := AnsiReplaceText(SendStr, '<$URL>', sURL);
        SendStr := AnsiReplaceText(SendStr, '<$USERNAME>', sAccount);
        SendStr := AnsiReplaceText(SendStr, '<$USERKEY>', sKey);
        EMailThread.AddSendEmail(g_sServerName, sEMail, '激活通行证', SendStr);
      Except
      End;
    Finally
      HtmlList.Free;
    End;
  end;
end;

procedure TFormMain.SendLostPasswordMail(sEMail, sAccount, sKey, sURL: string);
var
  HtmlList: TStringList;
  SendStr: string;
begin
  if FileExists('lostpass.html') then begin
    HtmlList := TStringList.Create;
    Try
      Try
        HtmlList.LoadFromFile('lostpass.html');
        SendStr := HtmlList.Text;
        SendStr := AnsiReplaceText(SendStr, '<$URL>', sURL);
        SendStr := AnsiReplaceText(SendStr, '<$USERNAME>', sAccount);
        SendStr := AnsiReplaceText(SendStr, '<$USERKEY>', sKey);
        EMailThread.AddSendEmail(g_sServerName, sEMail, '重置通行证密码', SendStr);
      Except
      End;
    Finally
      HtmlList.Free;
    End;
  end;
end;

procedure TFormMain.SendSocket(UserSession: pTUserSession; sSendMsg: string);
begin
  if (UserSession.Socket <> nil) and UserSession.Socket.Connected then begin
    if UserSession.SendString <> '' then begin
      AppendSendData(UserSession, g_CodeHead + sSendMsg + g_CodeEnd);
    end
    else if UserSession.Socket.SendText(g_CodeHead + sSendMsg + g_CodeEnd) = -1 then begin
      AppendSendData(UserSession, g_CodeHead + sSendMsg + g_CodeEnd);
    end;
  end;
end;

procedure TFormMain.SSocketClientConnect(Sender: TObject; Socket: TCustomWinSocket);
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
    //MainOutMessage('连接: ' + sRemoteIPaddr);
    Inc(g_nSessionCount);
  end
  else begin
    Socket.Close;
    //MainOutMessage('满员: ' + sRemoteIPaddr);
  end;
end;

procedure TFormMain.SSocketClientDisconnect(Sender: TObject; Socket: TCustomWinSocket);
var
  nSockIndex: Integer;
begin
  nSockIndex := Socket.nIndex;
  if nSockIndex in [Low(g_SessionArray)..High(g_SessionArray)] then begin
    //MainOutMessage('断开: ' + g_SessionArray[nSockIndex].sRemoteIPaddr);
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
begin
  nSockIndex := Socket.nIndex;
  if nSockIndex in [Low(g_SessionArray)..High(g_SessionArray)] then begin
    UserSession := @g_SessionArray[nSockIndex];
    if UserSession.Socket = Socket then begin
      UserSession.ReadString := UserSession.ReadString + Socket.ReceiveText;
    end;
  end;
end;

procedure TFormMain.SSocketListen(Sender: TObject; Socket: TCustomWinSocket);
begin
  MainOutMessage(Format('开始监听[%s:%d]...', [Socket.LocalAddress, Socket.LocalPort]));
  DecodeTimer.Enabled := True;
end;

procedure TFormMain.TimerTimer(Sender: TObject);
var
  nSockIndex, nShowCount: Integer;
  UserSession: pTUserSession;
  TickTime: LongWord;
  TickName: string;
begin
  nShowCount := 1;
  MonitorGrid.Cells[0, nShowCount] := '';
  MonitorGrid.Cells[1, nShowCount] := '';
  MonitorGrid.Cells[2, nShowCount] := '';
  MonitorGrid.Cells[3, nShowCount] := '';
  for nSockIndex := Low(g_SessionArray) to High(g_SessionArray) do begin
    UserSession := @g_SessionArray[nSockIndex];
    if UserSession.Socket <> nil then begin
      MonitorGrid.Cells[1, nShowCount] := UserSession.sRemoteIPaddr;
      TickTime := GetTickCount - UserSession.dwKeepAliveTick;
      if TickTime < 30000 then
        TickName := '正常'
      else
        TickName := '超时';
      if TickTime > 60000 then begin
        UserSession.Socket.Close;
        Continue;
      end;
      if UserSession.ServerName <> '' then begin
        MonitorGrid.Cells[0, nShowCount] := UserSession.ServerName;
        MonitorGrid.Cells[2, nShowCount] := UserSession.ServerCount;
        MonitorGrid.Cells[3, nShowCount] := TickName;
      end
      else begin
        MonitorGrid.Cells[0, nShowCount] := '-';
        MonitorGrid.Cells[2, nShowCount] := '-';
        MonitorGrid.Cells[3, nShowCount] := '-';
      end;
      Inc(nShowCount);
    end;
  end;
  MonitorGrid.RowCount := _MAX(2, nShowCount);
end;

procedure TFormMain.tmr1Timer(Sender: TObject);
begin
  tmr1.Enabled := False;
  EMailThread.Resume;
end;

procedure TFormMain.tmr2Timer(Sender: TObject);
begin
  lblreg.Caption := IntToStr(m_nRegCount);
  lblLogin.Caption := IntToStr(m_nLoginCount);
  lblRegOk.Caption := IntToStr(m_nRegOkCount);
  lblChangepass.Caption := IntToStr(m_nChangePassOk) + '/' + IntToStr(m_nChangePassFail);
  lblLostpass.Caption := IntToStr(m_nLostPassOk) + '/' + IntToStr(m_nLostPassFail) + '/' + IntToStr(m_nLostPassChange);
  lblSendEmail.Caption := IntToStr(g_nSendEMailCount) + '/' + IntToStr(g_nSendEMailFail);
  //lblGameGold.Caption := IntToStr(m_nGameGoldCount);
  lblwebGameGold.Caption := Format('%d/%d/%d/%d', [m_nWEBGameGoldCount, m_nGameGoldCount, m_nWEBGoldCount, m_nWEBOutGoldCount]);
  lblCheckID.Caption := IntToStr(m_nCheckAccountCount);

end;

procedure TFormMain.WEBSocketClientConnect(Sender: TObject; Socket: TCustomWinSocket);
var
  WEBSession: pTWEBSession;
  sRemoteIPaddr: string;
begin
  Socket.nIndex := 0;
  sRemoteIPaddr := Socket.RemoteAddress;

  if not IsAllowIP(sRemoteIPaddr) then begin
    MainOutMessage('非法连接: ' + sRemoteIPaddr);
    Socket.Close;
    Exit;
  end;

  New(WEBSession);
  //SafeFillChar(WEBSession^, SizeOf(TWEBSession), #0);
  WEBSession.sRemoteIPaddr := sRemoteIPaddr;
  WEBSession.ReadString := '';
  WEBSession.SendString := '';
  Socket.nIndex := Integer(WEBSession);
end;

procedure TFormMain.WEBSocketClientDisconnect(Sender: TObject; Socket: TCustomWinSocket);
begin
  if Socket.nIndex <> 0 then
    Dispose(pTWEBSession(Socket.nIndex));
  Socket.nIndex := 0;
end;

procedure TFormMain.WEBSocketClientError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
  Socket.Close;
  ErrorCode := 0;
end;

procedure TFormMain.WEBSocketClientRead(Sender: TObject; Socket: TCustomWinSocket);
var
  WEBSession: pTWEBSession;
  sReadStr, sTempStr, sSendStr, sOldReadStr: string;
  nPos, nDataSize: Integer;
begin
  if Socket.nIndex <> 0 then begin
    WEBSession := pTWEBSession(Socket.nIndex);
    WEBSession.ReadString := WEBSession.ReadString + Socket.ReceiveText;
    if length(WEBSession.ReadString) > 4096 then begin
      Socket.Close;
      exit;
    end;
    while WEBSession.ReadString <> '' do begin
      nPos := Pos(#13#10#13#10, WEBSession.ReadString);
      if nPos <= 0 then break;
      sOldReadStr := WEBSession.ReadString;
      sSendStr := '';
      sTempStr := Copy(WEBSession.ReadString, 1, nPos);
      WEBSession.ReadString := Copy(WEBSession.ReadString, nPos + 4, Length(WEBSession.ReadString));
      nPos := Pos('Content-Length: ', sTempStr);
      if nPos > 0 then begin
        sTempStr := Copy(sTempStr, nPos + Length('Content-Length: '), 12);
        GetValidStr3(sTempStr, sTempStr, [#13, #10]);
        nDataSize := StrToIntDef(sTempStr, 0);
        if (nDataSize > 0) then begin
          if nDataSize <= Length(WEBSession.ReadString) then begin
            sReadStr := Copy(WEBSession.ReadString, 1, nDataSize);
            WEBSession.ReadString := Copy(WEBSession.ReadString, nDataSize + 1, Length(WEBSession.ReadString));
            sSendStr := ProcessHttpMsg(sReadStr);

            sReadStr := 'HTTP/1.1 200 OK'#13#10;
            sReadStr := sReadStr + 'Date: ' + DateTimeToGMT(Now) + #13#10;
            sReadStr := sReadStr + 'Server: Microsoft-IIS/5.1'#13#10;
            if sSendStr <> '' then
              sReadStr := sReadStr + 'Content-Length: ' + IntToStr(Length(sSendStr)) + #13#10;
            sReadStr := sReadStr + 'Content-Type: text/html'#13#10;
            sReadStr := sReadStr + 'Cache-control: private'#13#10#13#10;
            Socket.SendText(sReadStr + sSendStr);
            if chk1.Checked then Socket.Close;
            
          end else begin
            WEBSession.ReadString := sOldReadStr;
            break;
          end;
        end else begin
          Socket.Close;
          break;
        end;
      end else begin
        Socket.Close;
        break;
      end;
    end;
  end
  else
    Socket.Close;
end;

procedure TFormMain.WEBSocketListen(Sender: TObject; Socket: TCustomWinSocket);
begin
  MainOutMessage(Format('开始监听[%s:%d]...', [Socket.LocalAddress, Socket.LocalPort]));
end;

procedure TFormMain.edPortChange(Sender: TObject);
begin
  Ini.WriteString('Setup', 'Port', edPort.Text);
end;

procedure TFormMain.edWEBProtChange(Sender: TObject);
begin
  Ini.WriteString('Setup', 'WEBPort', edWEBProt.Text);
end;

procedure TFormMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if Application.MessageBox(PChar('是否确认关闭' + Caption + '程序?'), '确认信息', MB_OKCANCEL + MB_ICONQUESTION) =
    IDCANCEL then begin
    CanClose := False;
  end;
end;

procedure TFormMain.FormCreate(Sender: TObject);
var
  ValueList: TStringList;
  sAddr, sEMailName: string;
  nIPaddr: Integer;
begin
  Randomize;
  g_sEMailNameList := TStringList.Create;
  Ini := TIniFile.Create(INIFILENAME);
  g_sServerName := Ini.ReadString('Setup', 'ServerName', g_sServerName);
  edPort.Text := Ini.ReadString('Setup', 'Port', '20000');
  edWEBProt.Text := Ini.ReadString('Setup', 'WEBPort', '8080');
  g_sSQLAddrs := Ini.ReadString('Setup', 'SQLAddrs', g_sSQLAddrs);
  g_sSQLDBName := Ini.ReadString('Setup', 'SQLDBName', g_sSQLDBName);
  g_sSQLUserID := Ini.ReadString('Setup', 'SQLUserID', g_sSQLUserID);
  g_sSQLUserPass := Ini.ReadString('Setup', 'SQLUserPass', g_sSQLUserPass);
  chk1.Checked := Ini.ReadBool('Setup', 'IISVer', False);
  sEMailName := Ini.ReadString('Setup', 'EMailUserName', '');
  g_sEMailPassword := Ini.ReadString('Setup', 'EMailPassword', g_sEMailPassword);
  g_sEMailSmtpHost := Ini.ReadString('Setup', 'EMailSmtpHost', g_sEMailSmtpHost);
  g_sEMailSmtpPort := Ini.ReadInteger('Setup', 'EMailSmtpPort', g_sEMailSmtpPort);
  Ini.WriteString('Setup', 'ServerName', g_sServerName);
  Ini.WriteString('Setup', 'Port', edPort.Text);
  Ini.WriteString('Setup', 'WEBPort', edWEBProt.Text);
  Ini.WriteString('Setup', 'SQLAddrs', g_sSQLAddrs);
  Ini.WriteString('Setup', 'SQLDBName', g_sSQLDBName);
  Ini.WriteString('Setup', 'SQLUserID', g_sSQLUserID);
  Ini.WriteString('Setup', 'SQLUserPass', g_sSQLUserPass);
  Ini.WriteString('Setup', 'EMailUserName', sEMailName);
  Ini.WriteString('Setup', 'EMailPassword', g_sEMailPassword);
  Ini.WriteString('Setup', 'EMailSmtpHost', g_sEMailSmtpHost);
  Ini.WriteInteger('Setup', 'EMailSmtpPort', g_sEMailSmtpPort);
  ExtractStrings([','], [], PChar(sEMailName), g_sEMailNameList);
  ValueList := TStringList.Create;
  Ini.ReadSection('Addrs', ValueList);
  for sAddr in ValueList do begin
    nIPaddr := inet_addr(PChar(Trim(sAddr)));
    if nIPaddr <> -1 then begin
      cbAddrs.Items.AddObject(Trim(sAddr), TObject(nIPaddr));
    end;
  end;
  m_nRegCount := 0;
  m_nLoginCount := 0;
  m_nRegOkCount := 0;
  m_nChangePassOk := 0;
  m_nChangePassFail := 0;
  m_nLostPassOk := 0;
  m_nLostPassFail := 0;
  m_nLostPassChange := 0;
  g_nSendEMailCount := 0;
  g_nSendEMailFail := 0;
  m_nGameGoldCount := 0;
  m_nWEBGameGoldCount := 0;
  m_nWEBGoldCount := 0;
  m_nWEBOutGoldCount := 0;
  m_nCheckAccountCount := 0;
  cbAddrs.Text := Format('允许地址：%d', [cbAddrs.Items.Count]);
  mmoLog.Lines.Clear;
  MonitorGrid.Cells[0, 0] := '服务器名';
  MonitorGrid.Cells[1, 0] := '服务器地址';
  MonitorGrid.Cells[2, 0] := '用户数';
  MonitorGrid.Cells[3, 0] := '状态';
  SQL := TSQL.Create;
  m_boRun := False;
  EMailThread := TEMailThread.Create(True);
  tmr1.Enabled := True;
end;

procedure TFormMain.FormDestroy(Sender: TObject);
begin
  Ini.Free;
  SQL.Free;
  g_sEMailNameList.Free;
end;

procedure TFormMain.InitializeUserSession(UserSession: pTUserSession);
begin
  UserSession.Socket := nil;
  UserSession.SocketHandle := -1;
  UserSession.sRemoteIPaddr := '';
  UserSession.ReadString := '';
  UserSession.SendString := '';
  UserSession.dwConnectTick := 0;
  UserSession.ServerName := '';
  UserSession.ServerCount := '';
  UserSession.dwKeepAliveTick := GetTickCount;
  //UserSession.boKeepAlive := False;
end;

function TFormMain.IsAllowIP(sRemoteIPaddr: string): Boolean;
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

end.




