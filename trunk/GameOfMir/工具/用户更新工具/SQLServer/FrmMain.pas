unit FrmMain;

interface

uses
  Windows, SysUtils, Messages, StrUtils, Classes, Controls, Forms, Menus, StdCtrls, ADODB, Share, ComCtrls, DB, JSocket, ExtCtrls, AppEvnts,
  GeneralCommon, Hutil32, EDcode, SCShare, RSA, MD5Unit, MyCommon, DES, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP,
  IdZLibCompressorBase, IdCompressorZLibEx;
type
  TFormMain = class(TForm)
    MainMenu1: TMainMenu;
    MENU_ACCOUNT: TMenuItem;
    MENU_ACCOUNT_MANAGE: TMenuItem;
    H1: TMenuItem;
    A2: TMenuItem;
    GroupBox1: TGroupBox;
    MemoLog: TMemo;
    S1: TMenuItem;
    StatusBar: TStatusBar;
    SSocket: TServerSocket;
    StartTimer: TTimer;
    ApplicationEvents1: TApplicationEvents;
    Timer1: TTimer;
    DecodeTimer: TTimer;
    CHECKRSA: TRSA;
    LISTRSA: TRSA;
    ADDRSRSA: TRSA;
    TOOLSRSA: TRSA;
    IdHTTP1: TIdHTTP;
    IdCompressorZLibEx1: TIdCompressorZLibEx;
    ADRSA: TRSA;
    N1: TMenuItem;
    T1: TMenuItem;
    N201103111: TMenuItem;
    N2: TMenuItem;
    ShareRSA: TRSA;
    ADOConnection: TADOConnection;
    UserLogin: TADOStoredProc;
    GetBindPCList: TADOStoredProc;
    SetDownLoginInfo: TADOStoredProc;
    SetDownM2ServerInfo: TADOStoredProc;
    ChangeBindInfo: TADOStoredProc;
    AgentRegM2: TADOStoredProc;
    AgentRegLogin: TADOStoredProc;
    BindPC: TADOStoredProc;
    CheckPC: TADOStoredProc;
    CheckMD5: TADOStoredProc;
    SetName: TADOStoredProc;
    CheckOK: TADOStoredProc;
    ChangePassword: TADOStoredProc;
    TestConnect: TADOStoredProc;
    PackENRSA: TRSA;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure MENU_ACCOUNT_MANAGEClick(Sender: TObject);
    procedure StartTimerTimer(Sender: TObject);
    procedure ApplicationEvents1Exception(Sender: TObject; E: Exception);
    procedure SSocketClientError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure SSocketListen(Sender: TObject; Socket: TCustomWinSocket);
    procedure SSocketClientConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure SSocketClientDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure SSocketClientRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure Timer1Timer(Sender: TObject);
    procedure DecodeTimerTimer(Sender: TObject);
    procedure D1Click(Sender: TObject);
    procedure T1Click(Sender: TObject);
    procedure N201103111Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure ADOConnectionAfterConnect(Sender: TObject);
    procedure ADOConnectionBeforeConnect(Sender: TObject);
    procedure ADOConnectionLogin(Sender: TObject; Username, Password: string);
    procedure ADOConnectionDisconnect(Connection: TADOConnection; var EventStatus: TEventStatus);
  private
    FGateCount: Integer;
    FGateRun: Boolean;
    FCheckCount: Integer;
    FRegM2Count: Integer;
    FRegLoginCount: Integer;
    FTestSQLConnectTick: LongWord;
    DefMsg: TDefaultMessage;
    //function SocketStandardSend(Socket: TCustomWinSocket; sSendMsg: string): string; overload;
    procedure SocketStandardSend(sSendMsg: string; GateInfo: pTGateInfo); overload;
    procedure DecodeGateData(GateInfo: pTGateInfo);
    procedure SendKeepAlivePacket(GateInfo: pTGateInfo);
    procedure SendUserSocket(GateInfo: pTGateInfo; sMsg: string);
    procedure ReceiveSendUser(GateInfo: pTGateInfo; sArryIndex, sSockIndex, sData: string);
    procedure ReceiveOpenUser(GateInfo: pTGateInfo; sArryIndex, sSockIndex, sIPaddr: string);
    procedure ReceiveCloseUser(GateInfo: pTGateInfo; sArryIndex, sSockIndex: string);
    procedure ProcessUserMsg(GateInfo: pTGateInfo; UserInfo: pTUserInfo; sMsg: string);
    procedure SendClientSocket(GateInfo: pTGateInfo; UserInfo: pTUserInfo; sMsg: string);
    procedure SetFileMD5Info(sData: string);
    procedure SetLoginFileMD5Info(sData: string);

    procedure CloseUser(GateInfo: pTGateInfo; UserInfo: pTUserInfo);

    procedure SendCheckOK(GateInfo: pTGateInfo; UserInfo: pTUserInfo; sPublicMark: string);
    procedure SendFileData(GateInfo: pTGateInfo; UserInfo: pTUserInfo; sFileName, sWriteName, sMD5: string; nIdent: Integer);

    procedure ClientGetMark(GateInfo: pTGateInfo; UserInfo: pTUserInfo; sData: string);
    procedure ClientSetName(GateInfo: pTGateInfo; UserInfo: pTUserInfo; sData: string);
    procedure ClientCheckMD5(GateInfo: pTGateInfo; UserInfo: pTUserInfo; sData: string);
    procedure ClientCheckPC(GateInfo: pTGateInfo; UserInfo: pTUserInfo; sData: string);
    procedure ClientBindPC(GateInfo: pTGateInfo; UserInfo: pTUserInfo; sData: string);

    procedure CheckLogin(GateInfo: pTGateInfo; UserInfo: pTUserInfo; sData: string);
    procedure ClientGetDownList(GateInfo: pTGateInfo; UserInfo: pTUserInfo);
   // procedure ClientDownM2Server(GateInfo: pTGateInfo; UserInfo: pTUserInfo; sData: string);
    procedure ClientDownLogin(GateInfo: pTGateInfo; UserInfo: pTUserInfo; sData: string);

    procedure ClientDownM2Server_New(GateInfo: pTGateInfo; UserInfo: pTUserInfo; sData: string);
    procedure ClientGetDownData(GateInfo: pTGateInfo; UserInfo: pTUserInfo; nIdent: Integer);


    procedure CheckListLogin(GateInfo: pTGateInfo; UserInfo: pTUserInfo; sData: string);
    procedure ClientGetENInfo(GateInfo: pTGateInfo; UserInfo: pTUserInfo; sData: string);
    procedure ClientGetBindInfo(GateInfo: pTGateInfo; UserInfo: pTUserInfo);
    procedure ClientChangeBindInfo(GateInfo: pTGateInfo; UserInfo: pTUserInfo; nItemIdx: Integer);
    procedure CheckToolsUpDate(GateInfo: pTGateInfo; UserInfo: pTUserInfo; nUpVer: Integer);
    procedure CheckToolsLogin(GateInfo: pTGateInfo; UserInfo: pTUserInfo; nVar: Integer; sData: string);
    procedure ClientChangePassword(GateInfo: pTGateInfo; UserInfo: pTUserInfo; sData: string);

    procedure ClientGetShareUserName(GateInfo: pTGateInfo; UserInfo: pTUserInfo; sData: string);

    procedure ClientAgentRegLogin(GateInfo: pTGateInfo; UserInfo: pTUserInfo; Msg: pTDefaultMessage; sData: string);
    procedure ClientAgentRegM2(GateInfo: pTGateInfo; UserInfo: pTUserInfo; Msg: pTDefaultMessage; sData: string);

  public
    procedure MainOutMessage(sMsg: string);
    procedure MyMessage(var MsgData: TWmCopyData); message WM_COPYDATA;
  end;

var
  FormMain: TFormMain;

implementation

uses FrmAccount, ENThread, ComObj;

{$R *.dfm}

procedure TFormMain.ADOConnectionAfterConnect(Sender: TObject);
begin
  g_boSQLConnect := True;
  FTestSQLConnectTick := GetTickCount + 60 * 1000;
  MainOutMessage('连接至SQL服务器成功...');
end;

procedure TFormMain.ADOConnectionBeforeConnect(Sender: TObject);
begin
  MainOutMessage('正在连接SQL服务器...');
end;

procedure TFormMain.ADOConnectionDisconnect(Connection: TADOConnection; var EventStatus: TEventStatus);
var
  sMsg: string;
begin
  case EventStatus of
    esOK: sMsg := 'esOK';
    esErrorsOccured: sMsg := 'esErrorsOccured';
    esCantDeny: sMsg := 'esCantDeny';
    esCancel: sMsg := 'esCancel';
    esUnwantedEvent: sMsg := 'esUnwantedEvent';
  end;
  g_boSQLConnect := False;
  MainOutMessage('与SQL服务器断开连接...(' + sMsg + ')');
end;

procedure TFormMain.ADOConnectionLogin(Sender: TObject; Username, Password: string);
begin
  MainOutMessage('已成功登录至SQL服务器...');
end;

procedure TFormMain.ApplicationEvents1Exception(Sender: TObject; E: Exception);
begin
  MainOutMessage(E.Message);
end;

procedure TFormMain.CheckListLogin(GateInfo: pTGateInfo; UserInfo: pTUserInfo; sData: string);
var
  sAccount: string;
begin
  sData := DecodeString(sData);
  sData := GetValidStr3(sData, sAccount, ['/']);
  if not g_boSQLConnect then begin
    DefMsg := MakeDefaultMsg(SM_USERLISTLOGIN_FAIL, 0, 0, 0, 0);
    SendClientSocket(GateInfo, UserInfo, EncodeMessage(DefMsg) + EncodeString('系统错误，请联系管理员！'));
    Exit;
  end;
  if CheckEMailRule(sAccount) and (sData <> '') then begin
    UserLogin.Parameters[0].Value := 0;
    UserLogin.Parameters[1].Value := sAccount;
    UserLogin.Parameters[2].Value := UserInfo.sUserIPaddr;
    Try
      UserLogin.ExecProc;
      if UserLogin.Parameters[0].Value = 0 then begin
        if sData = UserLogin.Parameters[3].Value then begin
          if UserLogin.Parameters[4].Value then begin
            UserInfo.nDBIndex := UserLogin.Parameters[5].Value;
            UserInfo.sUserList := UserLogin.Parameters[13].Value;
            UserInfo.UserType := ut_List;
            DefMsg := MakeDefaultMsg(SM_USERLISTLOGIN_OK, 0, 0, 0, 0);
            SendClientSocket(GateInfo, UserInfo, EncodeMessage(DefMsg));
          end else begin
            DefMsg := MakeDefaultMsg(SM_USERLISTLOGIN_FAIL, 0, 0, 0, 0);
            SendClientSocket(GateInfo, UserInfo, EncodeMessage(DefMsg) + EncodeString('帐号尚未激活！'));
          end;
        end else begin
          DefMsg := MakeDefaultMsg(SM_USERLISTLOGIN_FAIL, 0, 0, 0, 0);
          SendClientSocket(GateInfo, UserInfo, EncodeMessage(DefMsg) + EncodeString('帐号或密码不正确！'));
        end;
      end else begin
        DefMsg := MakeDefaultMsg(SM_USERLISTLOGIN_FAIL, 0, 0, 0, 0);
        SendClientSocket(GateInfo, UserInfo, EncodeMessage(DefMsg) + EncodeString('帐号或密码不正确！'));
      end;
    Except
      on e: Exception do begin
        MainOutMessage('[Exception] UserLogin -> ExecProc(ListLogin)');
        MainOutMessage(E.Message);
      end;
    End;
  end;
end;

procedure TFormMain.CheckLogin(GateInfo: pTGateInfo; UserInfo: pTUserInfo; sData: string);
{var
  sAccount: string;     }
begin
  DefMsg := MakeDefaultMsg(SM_DOWNLOGIN_FAIL, 0, 0, 0, 0);
  SendClientSocket(GateInfo, UserInfo, EncodeMessage(DefMsg) + EncodeString('该版本已停用，请联系技术获取最新版本！'));

(* sData := DecodeString(sData);
 sData := GetValidStr3(sData, sAccount, ['/']);
 if CheckEMailRule(sAccount) and (sData <> '') then begin
    g_Query.SQL.Clear;
    g_Query.SQL.Add('select ID, Password, Active, LoginAddress, LoginTime from users where Account = ''' + sAccount + '''');
    g_Query.Open;
    try
      if g_Query.RecordCount > 0 then begin
        if sData = g_Query.FieldByName('Password').AsString then begin
          if g_Query.FieldByName('Active').AsBoolean then begin
            UserInfo.nDBIndex := g_Query.FieldByName('ID').AsInteger;
            UserInfo.UserType := ut_down;
            g_Query.Edit;
            g_Query.FieldByName('LoginAddress').AsString := UserInfo.sUserIPaddr;
            g_Query.FieldByName('LoginTime').AsDateTime := Now;
            g_Query.Post;
            DefMsg := MakeDefaultMsg(SM_DOWNLOGIN_OK, 0, 0, 0, 0);
            SendClientSocket(GateInfo, UserInfo, EncodeMessage(DefMsg));
          end else begin
            DefMsg := MakeDefaultMsg(SM_DOWNLOGIN_FAIL, 0, 0, 0, 0);
            SendClientSocket(GateInfo, UserInfo, EncodeMessage(DefMsg) + EncodeString('帐号尚未激活，请联系管理员激活！'));

          end;
        end else begin
          DefMsg := MakeDefaultMsg(SM_DOWNLOGIN_FAIL, 0, 0, 0, 0);
          SendClientSocket(GateInfo, UserInfo, EncodeMessage(DefMsg) + EncodeString('帐号或密码不正确！'));
        end;
      end else begin
        DefMsg := MakeDefaultMsg(SM_DOWNLOGIN_FAIL, 0, 0, 0, 0);
        SendClientSocket(GateInfo, UserInfo, EncodeMessage(DefMsg) + EncodeString('帐号或密码不正确！'));
      end;
    finally
      g_Query.Close;
    end;
 end;    *)
end;

procedure TFormMain.CheckToolsLogin(GateInfo: pTGateInfo; UserInfo: pTUserInfo; nVar: Integer; sData: string);
var
  sAccount, sPassword, sUrlList: string;
  NewLoginInfo: TNewLoginInfo;
  StringList: TStringList;
begin
  if nVar <= 0 then begin
    DefMsg := MakeDefaultMsg(SM_NEWTOOLS_LOGIN_FAIL, 0, 0, 0, 0);
    SendClientSocket(GateInfo, UserInfo, EncodeMessage(DefMsg) + EncodeString('当前版本已经停用，请到http://www.361m2.com下载最新版本V2.2'));
    Exit;
  end;
  sData := TOOLSRSA.DecryptStr(sData);
  sData := GetValidStr3(sData, sAccount, ['/']);
  sData := GetValidStr3(sData, sPassword, ['/']);
  if CheckEMailRule(sAccount) and (StrToIntDef(sData, -1) > 0) then begin
    Try
      UserLogin.Parameters[0].Value := 0;
      UserLogin.Parameters[1].Value := sAccount;
      UserLogin.Parameters[2].Value := UserInfo.sUserIPaddr;
      UserLogin.ExecProc;
      if UserLogin.Parameters[0].Value = 0 then begin
        if sPassword = GetMD5Text(UserLogin.Parameters[3].Value) then begin
          if UserLogin.Parameters[4].Value then begin
            UserInfo.nDBIndex := UserLogin.Parameters[5].Value;
            UserInfo.nAccountID := UserInfo.nDBIndex;
            UserInfo.sAccount := sAccount;
            UserInfo.boAdmin := UserLogin.Parameters[6].Value;
            NewLoginInfo.LoginInfo.boAgent := UserLogin.Parameters[7].Value;
            NewLoginInfo.LoginInfo.nBindCount := UserLogin.Parameters[8].Value;
            NewLoginInfo.LoginInfo.nMoney := UserLogin.Parameters[9].Value;
            NewLoginInfo.LoginInfo.nAgentM2 := UserLogin.Parameters[10].Value;
            NewLoginInfo.LoginInfo.nAgentLogin := UserLogin.Parameters[11].Value;
            NewLoginInfo.nResetCount := UserLogin.Parameters[12].Value;
            sUrlList := UserLogin.Parameters[14].Value;
            NewLoginInfo.sPackPassword := '';
            if UserLogin.Parameters[13].Value then begin
              NewLoginInfo.sPackPassword := GetMD5TextOf16(PackENRSA.EncryptStr(sUrlList));
            end;
            UserInfo.sUserList := sUrlList;

            if NewLoginInfo.LoginInfo.boAgent then begin
              UserInfo.UserType := ut_Tools_Agent;
              if FileExists(g_CurrentDir + 'AgentLog.txt') then begin
                StringList := TStringList.Create;
                Try
                  StringList.LoadFromFile(g_CurrentDir + 'AgentLog.txt');
                  DefMsg := MakeDefaultMsg(SM_TOOLS_LOGS, 0, 0, 0, 0);
                  SendClientSocket(GateInfo, UserInfo, EncodeMessage(DefMsg) + EncodeString(StringList.Text));
                Finally
                  StringList.Free;
                End;
              end;
            end else begin
              UserInfo.UserType := ut_Tools_User;
              if FileExists(g_CurrentDir + 'UserLog.txt') then begin
                StringList := TStringList.Create;
                Try
                  StringList.LoadFromFile(g_CurrentDir + 'UserLog.txt');
                  DefMsg := MakeDefaultMsg(SM_TOOLS_LOGS, 0, 0, 0, 0);
                  SendClientSocket(GateInfo, UserInfo, EncodeMessage(DefMsg) + EncodeString(StringList.Text));
                Finally
                  StringList.Free;
                End;
              end;
            end;
            DefMsg := MakeDefaultMsg(SM_NEWTOOLS_LOGIN_OK, StrToIntDef(sData, -1), 0, 0, 0);
            if nVar < 2 then
              SendClientSocket(GateInfo, UserInfo, EncodeMessage(DefMsg) + EncodeBuffer(@NewLoginInfo.LoginInfo, SizeOf(TLoginInfo)) + '/' + EncodeString(sUrlList))
            else
              SendClientSocket(GateInfo, UserInfo, EncodeMessage(DefMsg) + EncodeBuffer(@NewLoginInfo, SizeOf(TNewLoginInfo)) + '/' + EncodeString(sUrlList));

            if nVar < 20110403 then begin
              if FileExists(g_CurrentDir + 'Update.txt') then begin
                StringList := TStringList.Create;
                Try
                  StringList.LoadFromFile(g_CurrentDir + 'Update.txt');
                  if StringList.Count >= 2 then begin
                    DefMsg := MakeDefaultMsg(SM_TOOLS_UPDATE, StrToIntDef(StringList[0], 0), 0, 0, 0);
                    SendClientSocket(GateInfo, UserInfo, EncodeMessage(DefMsg) + EncodeString(StringList[1]));
                  end;
                Finally
                  StringList.Free;
                End;
              end;
            end;
          end else begin
            DefMsg := MakeDefaultMsg(SM_NEWTOOLS_LOGIN_FAIL, 0, 0, 0, 0);
            SendClientSocket(GateInfo, UserInfo, EncodeMessage(DefMsg) + EncodeString('帐号尚未激活，请联系管理员激活！'));
          end;
        end else begin
          DefMsg := MakeDefaultMsg(SM_NEWTOOLS_LOGIN_FAIL, 0, 0, 0, 0);
          SendClientSocket(GateInfo, UserInfo, EncodeMessage(DefMsg) + EncodeString('帐号或密码不正确！'));
        end;
      end else begin
        DefMsg := MakeDefaultMsg(SM_NEWTOOLS_LOGIN_FAIL, 0, 0, 0, 0);
        SendClientSocket(GateInfo, UserInfo, EncodeMessage(DefMsg) + EncodeString('帐号或密码不正确！'));
      end;
    Except
      on e: Exception do begin
        MainOutMessage('[Exception] UserLogin -> ExecProc(ToolsLogin)');
        MainOutMessage(E.Message);
      end;
    End;
  end;
end;

procedure TFormMain.CheckToolsUpDate(GateInfo: pTGateInfo; UserInfo: pTUserInfo; nUpVer: Integer);
var
  StringList: TStringList;
begin
  if FileExists(g_CurrentDir + 'Update.txt') then begin
    StringList := TStringList.Create;
    Try
      StringList.LoadFromFile(g_CurrentDir + 'Update.txt');
      if StringList.Count >= 2 then begin
        if StrToIntDef(StringList[0], 0) > nUpVer then begin
          DefMsg := MakeDefaultMsg(SM_TOOLS_UPDATE, 0, 0, 0, 0);
          SendClientSocket(GateInfo, UserInfo, EncodeMessage(DefMsg) + EncodeString(StringList[1]));
        end;
      end;
    Finally
      StringList.Free;
    End;
  end;
end;

procedure TFormMain.ClientGetBindInfo(GateInfo: pTGateInfo; UserInfo: pTUserInfo);
var
  UserBindInfo: TUserBindInfo;
  sSENDMSG: string;
begin
  sSendMsg := '';
  if g_boSQLConnect then begin
    GetBindPCList.Parameters[0].Value := 0;
    GetBindPCList.Parameters[1].Value := UserInfo.nAccountID;
    Try
      Try
        GetBindPCList.Open;
        while not GetBindPCList.Eof do begin
          UserBindInfo.ID := GetBindPCList.FieldByName('ID').AsInteger;
          UserBindInfo.PCName := GetBindPCList.FieldByName('PCName').AsString;
          UserBindInfo.IPAddres := GetBindPCList.FieldByName('IPAddress').AsString;
          UserBindInfo.CreateTime := GetBindPCList.FieldByName('CreateTime').AsDateTime;
          sSendMsg := sSendMsg + EncodeBuffer(@UserBindInfo, SizeOf(UserBindInfo)) + '/';
          GetBindPCList.Next;
        end;
      Except
        on e: Exception do begin
          MainOutMessage('[Exception] GetBindPCList -> Open ');
          MainOutMessage(E.Message);
        end;
      End;
    Finally
      GetBindPCList.Close;
    End;
  end;
  DefMsg := MakeDefaultMsg(SM_TOOLS_BINDLIST, 0, 0, 0, 0);
  SendClientSocket(GateInfo, UserInfo, EncodeMessage(DefMsg) + sSendMsg);
end;

procedure TFormMain.ClientGetDownList(GateInfo: pTGateInfo; UserInfo: pTUserInfo);
var
//  DownListInfo: TDownListInfo;
//  sSendMsg: string;
  TempList: TStringList;
begin
  TempList := TStringList.Create;
  Try
    if FileExists('.\M2Server.txt') then begin
      TempList.LoadFromFile('.\M2Server.txt');
      DefMsg := MakeDefaultMsg(SM_DOWNLIST, 1, 0, 0, 0);
      SendClientSocket(GateInfo, UserInfo, EncodeMessage(DefMsg) + EncodeString(TempList.Text));
    end;
    TempList.Clear;
    if FileExists('.\Login.txt') then begin
      TempList.LoadFromFile('.\Login.txt');
      DefMsg := MakeDefaultMsg(SM_DOWNLIST, 2, 0, 0, 0);
      SendClientSocket(GateInfo, UserInfo, EncodeMessage(DefMsg) + EncodeString(TempList.Text));
    end;
    TempList.Clear;
    if FileExists('.\DownList.txt') then begin
      TempList.LoadFromFile('.\DownList.txt');
      DefMsg := MakeDefaultMsg(SM_DOWNLIST, 3, 0, 0, 0);
      SendClientSocket(GateInfo, UserInfo, EncodeMessage(DefMsg) + EncodeString(TempList.Text));
    end;
  Finally
    TempList.Free;
  End;

  {DownListInfo.sFileName := '游戏引擎(M2Server.exe)';
  DownListInfo.nFileSize := 0;
  DownListInfo.dwTime := FileTime('.\M2Server\M2Server.exe');
  DownListInfo.DownType := dt_m2;
  sSendMsg := EncodeBuffer(@DownListInfo, SizeOf(DownListInfo)) + '/';
  sSendMsg := sSendMsg + EncodeString('下载地址') + '/';

  DownListInfo.sFileName := '登录器(Login.exe)';
  DownListInfo.nFileSize := 0;
  DownListInfo.dwTime := FileTime('.\Login\Login.exe');
  DownListInfo.DownType := dt_Login;
  sSendMsg := sSendMsg + EncodeBuffer(@DownListInfo, SizeOf(DownListInfo)) + '/';
  sSendMsg := sSendMsg + EncodeString('下载地址') + '/';

  DefMsg := MakeDefaultMsg(SM_DOWNLIST, 0, 0, 0, 0);
  SendClientSocket(GateInfo, UserInfo, EncodeMessage(DefMsg) + sSendMsg);  }
end;

procedure TFormMain.ClientGetENInfo(GateInfo: pTGateInfo; UserInfo: pTUserInfo; sData: string);
var
  sInfo, S1, S2, S3: string;
  sBackStr, sKey: string;
begin
  sBackStr := '';
  sKey := LowerCase(GetMD5TextOf16(LowerCase(UserInfo.sUserList)));
  sKey := Copy(sKey, 5, 8);
  while sData <> '' do begin
    sData := GetValidStr3(sData, sInfo, ['/']);
    if sInfo = '' then break;
    sInfo := DecodeString(sInfo);
    sInfo := GetValidStr3(sInfo, S1, ['/']);
    sInfo := GetValidStr3(sInfo, S2, ['/']);
    sInfo := GetValidStr3(sInfo, S3, ['/']);
    sBackStr := sBackStr + EncodeString(S1 + '/' + S2 + '/' + AnsiReplaceText(ADDRSRSA.EncryptStr(EncryStrHex(S3, sKey)), '=', '-')) + '/';
  end;
  if sBackStr <> '' then begin
    DefMsg := MakeDefaultMsg(SM_USERGETENINFO_OK, 0, 0, 0, 0);
    SendClientSocket(GateInfo, UserInfo, EncodeMessage(DefMsg) + sBackStr);
  end;
end;

procedure TFormMain.ClientDownLogin(GateInfo: pTGateInfo; UserInfo: pTUserInfo; sData: string);
var
  sPublicID, sUrlList, sFileName, sMD5, sFileMD5, sNameMD5, sReadMD5, sName: string;
  FileVersionInfo: TFileVersionInfo;
  EncryptSoftInfo: pTEncryptSoftInfo;
  sLoginName: string[12];
  nListID: Integer;
begin
  sData := DecodeString(sData);
  sReadMD5 := GetValidStr3(sData, sName, ['/']);
  sLoginName := sName;
  sPublicID := '';
  if not g_boSQLConnect then begin
    DefMsg := MakeDefaultMsg(SM_DOWNLOGINEXE_FAIL, 0, 0, 0, 0);
    SendClientSocket(GateInfo, UserInfo, EncodeMessage(DefMsg) + EncodeString('系统错误，请联系管理员...'));
    Exit;
  end;

  if (sLoginName <> '') and (Length(sLoginName) <= 12) then begin
    sNameMD5 := GetMD5Text(sLoginName);
    if FileExists('.\Login\Login.exe') then begin
      GetFileVersion('.\Login\Login.exe', @FileVersionInfo);
      SetDownLoginInfo.Parameters[0].Value := 0;
      SetDownLoginInfo.Parameters[1].Value := UserInfo.nDBIndex;
      SetDownLoginInfo.Parameters[2].Value := 1;
      SetDownLoginInfo.Parameters[3].Value := FileVersionInfo.sVersion;
      SetDownLoginInfo.Parameters[4].Value := '';
      SetDownLoginInfo.Parameters[5].Value := sNameMD5;
      SetDownLoginInfo.Parameters[6].Value := '';
      SetDownLoginInfo.Parameters[7].Value := 0;
      SetDownLoginInfo.Parameters[8].Value := '';
      SetDownLoginInfo.Parameters[9].Value := '';
      Try
        SetDownLoginInfo.ExecProc;
        if SetDownLoginInfo.Parameters[0].Value = 1 then begin
          sPublicID := GetMD5TextOf16(SetDownLoginInfo.Parameters[8].Value);
          sUrlList := LISTRSA.EncryptStr(LowerCase(SetDownLoginInfo.Parameters[9].Value));
          sMD5 := SetDownLoginInfo.Parameters[6].Value;
          nListID := SetDownLoginInfo.Parameters[7].Value; 
          if sReadMD5 = sMD5 then begin
            DefMsg := MakeDefaultMsg(SM_DOWNLOGINEXE_OK, 0, 0, 0, 0);
            SendClientSocket(GateInfo, UserInfo, EncodeMessage(DefMsg));
            Exit;
          end;
          if not (CompareText(sMD5, 'MAKEFILE') = 0) then begin
            sFileName := g_CurrentDir + LOGINFILESDIR + '\' + IntToStr(UserInfo.nDBIndex) + '\' + sLoginName + '\' + FileVersionInfo.sVersion + '.exe';
            if FileExists(sFileName) then begin
              sFileMD5 := FileToMD5Text(sFileName);
              if (sFileMD5 = sMD5) then begin
                //给用户下载
                SendFileData(GateInfo, UserInfo, sFileName, sLoginName, sFileMD5, SM_DOWNLOGINEXE_DATA);
                Exit;
              end;
              if not DeleteFile(sFileName) then begin
                DefMsg := MakeDefaultMsg(SM_DOWNLOGINEXE_FAIL, 0, 0, 0, 0);
                SendClientSocket(GateInfo, UserInfo, EncodeMessage(DefMsg) + EncodeString('生成文件失败，建议重新运行工具...'));
                Exit;
              end;
            end;
            Try
              SetDownLoginInfo.Parameters[0].Value := 0;
              SetDownLoginInfo.Parameters[1].Value := nListID;
              SetDownLoginInfo.Parameters[2].Value := 2;
              SetDownLoginInfo.Parameters[6].Value := 'MAKEFILE';
              SetDownLoginInfo.Parameters[7].Value := 0;
              SetDownLoginInfo.ExecProc;
              New(EncryptSoftInfo);
              EncryptSoftInfo.SoftType := es_Login;
              EncryptSoftInfo.nUserID := UserInfo.nDBIndex;
              EncryptSoftInfo.sGUID := sLoginName;
              EncryptSoftInfo.sDownList := sUrlList;
              EncryptSoftInfo.sLoginMark := sPublicID;
              EncryptSoft.AddEncryptSoft(EncryptSoftInfo);
              //发送等待生成提示
              DefMsg := MakeDefaultMsg(SM_DOWNLOGINEXE_MAKEFILE, 0, 0, 0, 0);
              SendClientSocket(GateInfo, UserInfo, EncodeMessage(DefMsg) + EncodeString('正在生成文件，请稍候...'));
            Except
              on e: Exception do begin
                MainOutMessage('[Exception] SetDownLoginInfo -> ExecProc(2)');
                MainOutMessage(E.Message);
              end;
            End;
          end else begin
            //发送等待生成提示
            DefMsg := MakeDefaultMsg(SM_DOWNLOGINEXE_MAKEFILE, 0, 0, 0, 0);
            SendClientSocket(GateInfo, UserInfo, EncodeMessage(DefMsg) + EncodeString('正在生成文件，请稍候...'));
          end;
        end else
        if SetDownLoginInfo.Parameters[0].Value = -2 then begin
          sPublicID := GetMD5TextOf16(SetDownLoginInfo.Parameters[8].Value);
          sUrlList := LISTRSA.EncryptStr(LowerCase(SetDownLoginInfo.Parameters[9].Value));
          Try
            SetDownLoginInfo.Parameters[0].Value := 0;
            SetDownLoginInfo.Parameters[1].Value := UserInfo.nDBIndex;
            SetDownLoginInfo.Parameters[2].Value := 3;
            SetDownLoginInfo.Parameters[3].Value := FileVersionInfo.sVersion;
            SetDownLoginInfo.Parameters[4].Value := sLoginName;
            SetDownLoginInfo.Parameters[5].Value := sNameMD5;
            SetDownLoginInfo.Parameters[6].Value := 'MAKEFILE';
            SetDownLoginInfo.Parameters[7].Value := 0;
            SetDownLoginInfo.ExecProc;
            New(EncryptSoftInfo);
            EncryptSoftInfo.SoftType := es_Login;
            EncryptSoftInfo.nUserID := UserInfo.nDBIndex;
            EncryptSoftInfo.sGUID := sLoginName;
            EncryptSoftInfo.sDownList := sUrlList;
            EncryptSoftInfo.sLoginMark := sPublicID;
            EncryptSoft.AddEncryptSoft(EncryptSoftInfo);
            //发送等待生成提示
            DefMsg := MakeDefaultMsg(SM_DOWNLOGINEXE_MAKEFILE, 0, 0, 0, 0);
            SendClientSocket(GateInfo, UserInfo, EncodeMessage(DefMsg) + EncodeString('正在生成文件，请稍候...'));
          Except
            on e: Exception do begin
              MainOutMessage('[Exception] SetDownLoginInfo -> ExecProc(3)');
              MainOutMessage(E.Message);
            end;
          End;
        end;
      Except
        on e: Exception do begin
          MainOutMessage('[Exception] SetDownLoginInfo -> ExecProc(1)');
          MainOutMessage(E.Message);
        end;
      End;
    end;
  end;
end;


procedure TFormMain.ClientDownM2Server_New(GateInfo: pTGateInfo; UserInfo: pTUserInfo; sData: string);
var
  sGUID, sFileName, sMD5, sFileMD5, sReadMD5: string;
  FileVersionInfo: TFileVersionInfo;
  EncryptSoftInfo: pTEncryptSoftInfo;
  //boMakeFile: Boolean;
  nListID: Integer;
begin
  sGUID := '';
  sReadMD5 := DecodeString(sData);
  if not g_boSQLConnect then begin
    DefMsg := MakeDefaultMsg(SM_DOWNM2SERVER_FAIL, 0, 0, 0, 0);
    SendClientSocket(GateInfo, UserInfo, EncodeMessage(DefMsg) + EncodeString('系统错误，请联系管理员...'));
    Exit;
  end;
  if FileExists('.\M2Server\M2Server.exe') then begin
    GetFileVersion('.\M2Server\M2Server.exe', @FileVersionInfo);
    Try
      SetDownM2ServerInfo.Parameters[0].Value := 0;
      SetDownM2ServerInfo.Parameters[1].Value := UserInfo.nDBIndex;
      SetDownM2ServerInfo.Parameters[2].Value := 1;
      SetDownM2ServerInfo.Parameters[3].Value := FileVersionInfo.sVersion;
      SetDownM2ServerInfo.Parameters[4].Value := '';
      SetDownM2ServerInfo.Parameters[5].Value := 0;
      SetDownM2ServerInfo.Parameters[6].Value := '';
      SetDownM2ServerInfo.ExecProc;
      if SetDownM2ServerInfo.Parameters[0].Value = 1 then begin
        sMD5 := SetDownM2ServerInfo.Parameters[4].Value;
        sGUID := SetDownM2ServerInfo.Parameters[6].Value;
        nListID := SetDownM2ServerInfo.Parameters[5].Value; 
        if not (CompareText(sMD5, 'MAKEFILE') = 0) then begin
          if (sReadMD5 <> '') and (sMD5 = sReadMD5) then begin
            DefMsg := MakeDefaultMsg(SM_DOWNM2SERVER_OK, 0, 0, 0, 0);
            SendClientSocket(GateInfo, UserInfo, EncodeMessage(DefMsg));
            Exit;
          end;
          sFileName := g_CurrentDir + M2FILESDIR + '\' + IntToStr(UserInfo.nDBIndex) + '\' + FileVersionInfo.sVersion + '.exe';
          if FileExists(sFileName) then begin
            sFileMD5 := FileToMD5Text(sFileName);
            if (sFileMD5 = sMD5) then begin
              //给用户下载
              SendFileData(GateInfo, UserInfo, sFileName, 'M2Server.exe', sFileMD5, SM_DOWNM2SERVER_DATA);
              Exit;
            end;
            if not DeleteFile(sFileName) then begin
              DefMsg := MakeDefaultMsg(SM_DOWNM2SERVER_FAIL, 0, 0, 0, 0);
              SendClientSocket(GateInfo, UserInfo, EncodeMessage(DefMsg) + EncodeString('生成文件失败，建议重新运行工具...'));
              Exit;
            end;
          end;
          Try
            SetDownM2ServerInfo.Parameters[0].Value := 0;
            SetDownM2ServerInfo.Parameters[1].Value := nListID;
            SetDownM2ServerInfo.Parameters[2].Value := 2;
            SetDownM2ServerInfo.Parameters[4].Value := 'MAKEFILE';
            SetDownM2ServerInfo.ExecProc;

            New(EncryptSoftInfo);
            EncryptSoftInfo.SoftType := es_M2;
            EncryptSoftInfo.nUserID := UserInfo.nDBIndex;
            EncryptSoftInfo.sGUID := sGUID;
            EncryptSoft.AddEncryptSoft(EncryptSoftInfo);
            //发送等待生成提示
            DefMsg := MakeDefaultMsg(SM_DOWNM2SERVER_MAKEFILE, 0, 0, 0, 0);
            SendClientSocket(GateInfo, UserInfo, EncodeMessage(DefMsg) + EncodeString('正在生成文件，请稍候...'));
          Except
            on e: Exception do begin
              MainOutMessage('[Exception] SetDownM2ServerInfo -> ExecProc(3)');
              MainOutMessage(E.Message);
            end;
          End;
        end else begin
          DefMsg := MakeDefaultMsg(SM_DOWNM2SERVER_MAKEFILE, 0, 0, 0, 0);
          SendClientSocket(GateInfo, UserInfo, EncodeMessage(DefMsg) + EncodeString('正在生成文件，请稍候...'));
        end;
      end else
      if SetDownM2ServerInfo.Parameters[0].Value = -2 then begin
        Try
          sGUID := SetDownM2ServerInfo.Parameters[6].Value;
          SetDownM2ServerInfo.Parameters[0].Value := 0;
          SetDownM2ServerInfo.Parameters[1].Value := UserInfo.nDBIndex;
          SetDownM2ServerInfo.Parameters[2].Value := 3;
          SetDownM2ServerInfo.Parameters[3].Value := FileVersionInfo.sVersion;
          SetDownM2ServerInfo.Parameters[4].Value := 'MAKEFILE';
          SetDownM2ServerInfo.Parameters[5].Value := 0;
          SetDownM2ServerInfo.Parameters[6].Value := '';
          SetDownM2ServerInfo.ExecProc;

          New(EncryptSoftInfo);
          EncryptSoftInfo.SoftType := es_M2;
          EncryptSoftInfo.nUserID := UserInfo.nDBIndex;
          EncryptSoftInfo.sGUID := sGUID;
          EncryptSoft.AddEncryptSoft(EncryptSoftInfo);
          //发送等待生成提示
          DefMsg := MakeDefaultMsg(SM_DOWNM2SERVER_MAKEFILE, 0, 0, 0, 0);
          SendClientSocket(GateInfo, UserInfo, EncodeMessage(DefMsg) + EncodeString('正在生成文件，请稍候...'));
        Except
          on e: Exception do begin
            MainOutMessage('[Exception] SetDownM2ServerInfo -> ExecProc(3)');
            MainOutMessage(E.Message);
          end;
        End;
      end;

    Except
      on e: Exception do begin
        MainOutMessage('[Exception] SetDownM2ServerInfo -> ExecProc(1)');
        MainOutMessage(E.Message);
      end;
    End;
  end;
end;
  {
procedure TFormMain.ClientDownM2Server(GateInfo: pTGateInfo; UserInfo: pTUserInfo; sData: string);
var
  sGUID, sFileName, sMD5, sFileMD5, sReadMD5: string;
  FileVersionInfo: TFileVersionInfo;
  EncryptSoftInfo: pTEncryptSoftInfo;
begin
  sGUID := '';
  sReadMD5 := DecodeString(sData);
  if FileExists('.\M2Server\M2Server.exe') then begin
    GetFileVersion('.\M2Server\M2Server.exe', @FileVersionInfo);
    g_Query.SQL.Clear;
    g_Query.SQL.Add('select GUID from users where ID = ' + IntToStr(UserInfo.nDBIndex) + ' and Active = true');
    g_Query.Open;
    try
      if g_Query.RecordCount > 0 then begin
        sGUID := g_Query.FieldByName('GUID').AsString;
      end;
    finally
      g_Query.Close;
    end;
    if sGUID <> '' then begin
      g_Query.SQL.Clear;
      g_Query.SQL.Add('select AccountID, MD5, Var from UseList where AccountID = ' + IntToStr(UserInfo.nDBIndex) + ' and Var = ''' + FileVersionInfo.sVersion + '''');
      g_Query.Open;
      try
        if g_Query.RecordCount > 0 then begin
          sMD5 := g_Query.FieldByName('MD5').AsString;
          if sMD5 = sReadMD5 then begin
            DefMsg := MakeDefaultMsg(SM_DOWNM2SERVER_OK, 0, 0, 0, 0);
            SendClientSocket(GateInfo, UserInfo, EncodeMessage(DefMsg));
          end else
          if sMD5 <> '' then begin
            sFileName := g_CurrentDir + M2FILESDIR + '\' + IntToStr(UserInfo.nDBIndex) + '\' + FileVersionInfo.sVersion + '.exe';
            if FileExists(sFileName) then begin
              sFileMD5 := FileToMD5Text(sFileName);
              if (sFileMD5 = sMD5) then begin
                //给用户下载
                SendFileData(GateInfo, UserInfo, sFileName, 'M2Server.exe', sFileMD5, SM_DOWNM2SERVER_DATA);
                Exit;
              end;
              DeleteFile(sFileName);
            end;
            g_Query.Edit;
            g_Query.FieldByName('MD5').AsString := '';
            g_Query.Post;
            New(EncryptSoftInfo);
            EncryptSoftInfo.SoftType := es_M2;
            EncryptSoftInfo.nUserID := UserInfo.nDBIndex;
            EncryptSoftInfo.sGUID := sGUID;
            EncryptSoft.AddEncryptSoft(EncryptSoftInfo);
            //发送等待生成提示
            DefMsg := MakeDefaultMsg(SM_DOWNM2SERVER_FAIL, 0, 0, 0, 0);
            SendClientSocket(GateInfo, UserInfo, EncodeMessage(DefMsg) + EncodeString('正在生成文件，请稍候...'));

          end else begin
            //发送等待生成提示
            DefMsg := MakeDefaultMsg(SM_DOWNM2SERVER_FAIL, 0, 0, 0, 0);
            SendClientSocket(GateInfo, UserInfo, EncodeMessage(DefMsg) + EncodeString('正在生成文件，请稍候...'));

          end;
        end else begin
          g_Query.Append;
          g_Query.FieldByName('AccountID').AsInteger := UserInfo.nDBIndex;
          g_Query.FieldByName('MD5').AsString := '';
          g_Query.FieldByName('Var').AsString := FileVersionInfo.sVersion;
          g_Query.Post;
          New(EncryptSoftInfo);
          EncryptSoftInfo.SoftType := es_M2;
          EncryptSoftInfo.nUserID := UserInfo.nDBIndex;
          EncryptSoftInfo.sGUID := sGUID;
          EncryptSoft.AddEncryptSoft(EncryptSoftInfo);
          //发送等待生成提示
          DefMsg := MakeDefaultMsg(SM_DOWNM2SERVER_FAIL, 0, 0, 0, 0);
          SendClientSocket(GateInfo, UserInfo, EncodeMessage(DefMsg) + EncodeString('正在生成文件，请稍候...'));
        end;
      finally
        g_Query.Close;
      end;
    end;
  end;
end;       }

procedure TFormMain.ClientGetMark(GateInfo: pTGateInfo; UserInfo: pTUserInfo; sData: string);
var
  sMark, sVar, sPort: string;
begin
  sData := CHECKRSA.DecryptStr(sData);
  sData := GetValidStr3(sData, sMark, ['/']);
  sData := GetValidStr3(sData, sVar, ['/']);
  sData := GetValidStr3(sData, sPort, ['/']);
  UserInfo.nCMark := StrToIntDef(sMark, -1);
  if UserInfo.nCMark > 0 then begin
    UserInfo.UserVar := StrToIntDef(sVar, 0);
    UserInfo.UserPort := StrToIntDef(sPort, 0);
    //MainOutMessage(sVar);
    //MainOutMessage(sPort);
    UserInfo.UserType := ut_CheckM2;
    UserInfo.nSMark := Random(9999) + 1000;
    DefMsg := MakeDefaultMsg(SM_GETMARK, 0, 0, 0, 0);
    SendClientSocket(GateInfo, UserInfo, EncodeMessage(DefMsg) + CHECKRSA.EncryptStr(IntToStr(UserInfo.nSMark) + '/' + sMark));

  end;
end;

procedure TFormMain.ClientGetShareUserName(GateInfo: pTGateInfo; UserInfo: pTUserInfo; sData: string);
var
  sMark: string;
begin
  sMark := ShareRSA.DecryptStr(sData);
  if (sMark <> '') and (UserInfo.sAccount <> '') then begin
    DefMsg := MakeDefaultMsg(SM_TOOLS_SENDUSRNAME, 0, 0, 0, 0);
    SendClientSocket(GateInfo, UserInfo, EncodeMessage(DefMsg) + ShareRSA.EncryptStr(sMark + '/' + IntToStr(Integer(UserInfo.boAdmin)) + '/' + UserInfo.sAccount));
  end;
end;

procedure TFormMain.ClientChangeBindInfo(GateInfo: pTGateInfo; UserInfo: pTUserInfo; nItemIdx: Integer);
var
  UserBindInfo: TUserBindInfo;
  sSENDMSG: string;
  ResetCount, BindCount: Integer;
begin
  if nItemIdx <= 0 then Exit;
  if not g_boSQLConnect then begin
    DefMsg := MakeDefaultMsg(SM_TOOLS_CHANGEBIND_FAIL, 0, 0, 0, 0);
    SendClientSocket(GateInfo, UserInfo, EncodeMessage(DefMsg) + EncodeString('系统错误，请联系管理员处理...'));
    Exit;
  end;
  sSendMsg := '';
  ChangeBindInfo.Parameters[0].Value := 0;
  ChangeBindInfo.Parameters[1].Value := nItemIdx;
  ChangeBindInfo.Parameters[2].Value := UserInfo.nAccountID;
  Try
    ChangeBindInfo.ExecProc;
    if ChangeBindInfo.Parameters[0].Value = 1 then begin
      BindCount := ChangeBindInfo.Parameters[1].Value;
      ResetCount := ChangeBindInfo.Parameters[2].Value;

      GetBindPCList.Parameters[0].Value := 0;
      GetBindPCList.Parameters[1].Value := UserInfo.nAccountID;
      Try
        Try
          GetBindPCList.Open;
          while not GetBindPCList.Eof do begin
            UserBindInfo.ID := GetBindPCList.FieldByName('ID').AsInteger;
            UserBindInfo.PCName := GetBindPCList.FieldByName('PCName').AsString;
            UserBindInfo.IPAddres := GetBindPCList.FieldByName('IPAddress').AsString;
            UserBindInfo.CreateTime := GetBindPCList.FieldByName('CreateTime').AsDateTime;
            sSendMsg := sSendMsg + EncodeBuffer(@UserBindInfo, SizeOf(UserBindInfo)) + '/';
            GetBindPCList.Next;
          end;
        Except
          on e: Exception do begin
            MainOutMessage('[Exception] GetBindPCList -> Open ');
            MainOutMessage(E.Message);
          end;
        End;
      Finally
        GetBindPCList.Close;
      End;

      DefMsg := MakeDefaultMsg(SM_TOOLS_CHANGEBIND_OK, 0, BindCount, ResetCount, 0);
      SendClientSocket(GateInfo, UserInfo, EncodeMessage(DefMsg) + sSendMsg);
      Exit;
    end else
    if ChangeBindInfo.Parameters[0].Value = -1 then begin
      sSENDMSG := '未找到对应绑定信息，更换失败！';
    end else

    if ChangeBindInfo.Parameters[0].Value = -2 then begin
      sSENDMSG := '剩余可更换次数不足，不能更换绑定状态！';
    end else
    if ChangeBindInfo.Parameters[0].Value = -3 then begin
      sSENDMSG := '系统错误，请联系管理员！';
    end else begin
      sSENDMSG := '未知错误，请联系管理员！';
    end;
    DefMsg := MakeDefaultMsg(SM_TOOLS_CHANGEBIND_FAIL, 0, 0, 0, 0);
    SendClientSocket(GateInfo, UserInfo, EncodeMessage(DefMsg) + EncodeString(sSendMsg));
  Except
    on e: Exception do begin
      MainOutMessage('[Exception] ChangeBindInfo -> ExecProc');
      MainOutMessage(E.Message);
    end;
  End;
end;

procedure TFormMain.ClientChangePassword(GateInfo: pTGateInfo; UserInfo: pTUserInfo; sData: string);
var
  sOldPass, sNewPassword: string;
begin
  sData := TOOLSRSA.DecryptStr(sData);
  sNewPassword := GetValidStr3(sData, sOldPass, ['/']);
  if (UserInfo.nAccountID > 0) and (sNewPassword <> '') and (sOldPass <> '') then begin
    if not g_boSQLConnect then begin
      DefMsg := MakeDefaultMsg(SM_TOOLS_CHANGEPASS_FAIL, 0, 0, 0, 0);
      SendClientSocket(GateInfo, UserInfo, EncodeMessage(DefMsg));
      Exit;
    end;
    ChangePassword.Parameters[0].Value := 0;
    ChangePassword.Parameters[1].Value := UserInfo.nAccountID;
    ChangePassword.Parameters[2].Value := '';
    Try
      ChangePassword.ExecProc;
      if ChangePassword.Parameters[0].Value = 1 then begin
        if GetMD5Text(ChangePassword.Parameters[2].Value) = sOldPass then begin
          ChangePassword.Parameters[0].Value := 0;
          ChangePassword.Parameters[1].Value := UserInfo.nAccountID;
          ChangePassword.Parameters[2].Value := sNewPassword;
          Try
            ChangePassword.ExecProc;
            if ChangePassword.Parameters[0].Value = 1 then begin
              DefMsg := MakeDefaultMsg(SM_TOOLS_CHANGEPASS_OK, 0, 0, 0, 0);
              SendClientSocket(GateInfo, UserInfo, EncodeMessage(DefMsg));
            end else begin
              DefMsg := MakeDefaultMsg(SM_TOOLS_CHANGEPASS_FAIL, 0, 0, 0, 0);
              SendClientSocket(GateInfo, UserInfo, EncodeMessage(DefMsg));
            end;
          Except
            on e: Exception do begin
              MainOutMessage('[Exception] ChangePassword -> ExecProc(Set)');
              MainOutMessage(E.Message);
            end;
          End;
        end else begin
          DefMsg := MakeDefaultMsg(SM_TOOLS_CHANGEPASS_FAIL, 0, 0, 0, 0);
          SendClientSocket(GateInfo, UserInfo, EncodeMessage(DefMsg));
        end;
      end else begin
        DefMsg := MakeDefaultMsg(SM_TOOLS_CHANGEPASS_FAIL, 0, 0, 0, 0);
        SendClientSocket(GateInfo, UserInfo, EncodeMessage(DefMsg));
      end;
    Except
      on e: Exception do begin
        MainOutMessage('[Exception] ChangePassword -> ExecProc(Get)');
        MainOutMessage(E.Message);
      end;
    End;
  end;
end;

procedure TFormMain.ClientAgentRegM2(GateInfo: pTGateInfo; UserInfo: pTUserInfo; Msg: pTDefaultMessage; sData: string);
var
  sAccount, sBackMsg: string;
  nCount: Integer;
begin
  sAccount := TOOLSRSA.DecryptStr(sData);
  sBackMsg := '帐号异常错误！';
  nCount := Msg.Recog;

  if not g_boSQLConnect then begin
    DefMsg := MakeDefaultMsg(SM_TOOLS_REGM2_FAIL, 0, 0, 0, 0);
    SendClientSocket(GateInfo, UserInfo, EncodeMessage(DefMsg) + EncodeString('系统错误，请联系管理员...'));
    Exit;
  end;

  if (UserInfo.nAccountID > 0) and CheckEMailRule(sAccount) and (nCount > 0) and (nCount < 100) then begin
    AgentRegM2.Parameters[0].Value := 0;
    AgentRegM2.Parameters[1].Value := UserInfo.nAccountID;
    AgentRegM2.Parameters[2].Value := sAccount;
    AgentRegM2.Parameters[3].Value := nCount;
    try
      AgentRegM2.ExecProc;
      if AgentRegM2.Parameters[0].Value >= 0 then begin
        Inc(FRegM2Count, nCount);
        MainOutMessage('[注册引擎] 代理：' + UserInfo.sAccount + ' 帐号：' + sAccount + ' 数量：' + IntToStr(nCount));
        DefMsg := MakeDefaultMsg(SM_TOOLS_REGM2_OK, AgentRegM2.Parameters[0].Value, 0, 0, 0);
        SendClientSocket(GateInfo, UserInfo, EncodeMessage(DefMsg));
        Exit;
      end else
      if AgentRegM2.Parameters[0].Value = -1 then begin
        sBackMsg := '该登录帐号不存在，请重新选择！';
      end else
      if AgentRegM2.Parameters[0].Value = -2 then begin
        sBackMsg := '帐户余额不足！';
      end else
      if AgentRegM2.Parameters[0].Value = -3 then begin
        sBackMsg := '系统错误，请联系管理员...';
      end else begin
        sBackMsg := '未知错误，请联系管理员...';
      end;
      DefMsg := MakeDefaultMsg(SM_TOOLS_REGM2_FAIL, 0, 0, 0, 0);
      SendClientSocket(GateInfo, UserInfo, EncodeMessage(DefMsg) + EncodeString(sBackMsg));
    Except
      on e: Exception do begin
        MainOutMessage('[Exception] AgentRegM2 -> ExecProc');
        MainOutMessage(E.Message);
      end;
    end;
  end;
end;

procedure TFormMain.ClientAgentRegLogin(GateInfo: pTGateInfo; UserInfo: pTUserInfo; Msg: pTDefaultMessage; sData: string);
var
  sAccount, sUrl, sBackMsg: string;
begin
  sData := TOOLSRSA.DecryptStr(sData);
  sUrl := GetValidStr3(sData, sAccount, ['/']);
  if not g_boSQLConnect then begin
    DefMsg := MakeDefaultMsg(SM_TOOLS_REGLOGIN_FAIL, 0, 0, 0, 0);
    SendClientSocket(GateInfo, UserInfo, EncodeMessage(DefMsg) + EncodeString('系统错误，请联系管理员...'));
    Exit;
  end;
  if (UserInfo.nAccountID > 0) and CheckEMailRule(sAccount) then begin
    AgentRegLogin.Parameters[0].Value := 0;
    AgentRegLogin.Parameters[1].Value := UserInfo.nAccountID;
    AgentRegLogin.Parameters[2].Value := sAccount;
    AgentRegLogin.Parameters[3].Value := sUrl;
    AgentRegLogin.Parameters[4].Value := Msg.Recog;
    AgentRegLogin.Parameters[5].Value := CreateClassID;
    AgentRegLogin.Parameters[6].Value := FormatDateTime('YYYYMMDDHHMMSS', Now) + IntToStr(Random(8000) + 1000);
    try
      AgentRegLogin.ExecProc;
      if AgentRegLogin.Parameters[0].Value >= 0 then begin
        Inc(FRegLoginCount);
        MainOutMessage('[注册登录器] 代理：' + UserInfo.sAccount + ' 新帐号：' + sAccount);
        DefMsg := MakeDefaultMsg(SM_TOOLS_REGLOGIN_OK, AgentRegLogin.Parameters[0].Value, 0, 0, 0);
        SendClientSocket(GateInfo, UserInfo, EncodeMessage(DefMsg));
        Exit;
      end else
      if AgentRegLogin.Parameters[0].Value = -1 then begin
        sBackMsg := '该登录帐号已经存在，请重新设置帐号！';
      end else
      if AgentRegLogin.Parameters[0].Value = -2 then begin
        sBackMsg := '帐户余额不足！';
      end else
      if AgentRegLogin.Parameters[0].Value = -3 then begin
        sBackMsg := '系统错误，请联系管理员...';
      end else begin
        sBackMsg := '未知错误，请联系管理员...';
      end;
      DefMsg := MakeDefaultMsg(SM_TOOLS_REGLOGIN_FAIL, 0, 0, 0, 0);
      SendClientSocket(GateInfo, UserInfo, EncodeMessage(DefMsg) + EncodeString(sBackMsg));
    Except
      on e: Exception do begin
        MainOutMessage('[Exception] AgentRegLogin -> ExecProc');
        MainOutMessage(E.Message);
      end;
    end;
  end;
end;

procedure TFormMain.ClientBindPC(GateInfo: pTGateInfo; UserInfo: pTUserInfo; sData: string);
var
  sMark, sPCMark, sPublicMark: string;
begin
  sData := CHECKRSA.DecryptStr(sData);
  sData := GetValidStr3(sData, sMark, ['/']);
  sData := GetValidStr3(sData, sPCMark, ['/']);
  sPublicMark := '';
  if not g_boSQLConnect then begin
    DefMsg := MakeDefaultMsg(SM_BINDPCCOUNT_FAIL, 0, 0, 0, 0);
    SendClientSocket(GateInfo, UserInfo, EncodeMessage(DefMsg) + CHECKRSA.EncryptStr(IntToStr(UserInfo.nSMark) + '/系统错误，请联系管理员！'));
    Exit;
  end;
  if UserInfo.nPassErrorCount >= 3 then begin
    CloseUser(GateInfo, UserInfo);
    Exit;
  end;

  if (StrToIntDef(sMark, -1) = UserInfo.nMD5Mark) and (UserInfo.nMD5Mark > 0) and (UserInfo.nAccountID > 0) and (sData <> '') then begin
    BindPC.Parameters[0].Value := 0;
    BindPC.Parameters[1].Value := UserInfo.nAccountID;
    BindPC.Parameters[2].Value := sData;
    BindPC.Parameters[3].Value := sPCMark;
    BindPC.Parameters[4].Value := GetRandomPassword(16);
    BindPC.Parameters[5].Value := UserInfo.sUserIPaddr;
    Try
      BindPC.ExecProc;
      if BindPC.Parameters[0].Value = 1 then begin
        SendCheckOK(GateInfo, UserInfo, sPublicMark);
      end else
      if BindPC.Parameters[0].Value = -1 then begin
        Inc(UserInfo.nPassErrorCount);
        DefMsg := MakeDefaultMsg(SM_BINDPCPASS_FAIL, 0, 0, 0, 0);
        SendClientSocket(GateInfo, UserInfo, EncodeMessage(DefMsg) + CHECKRSA.EncryptStr(IntToStr(UserInfo.nSMark) + '/密码错误，请重新输入！'));
      end else
      if BindPC.Parameters[0].Value = -2 then begin
        DefMsg := MakeDefaultMsg(SM_BINDPCCOUNT_FAIL, 0, 0, 0, 0);
        SendClientSocket(GateInfo, UserInfo, EncodeMessage(DefMsg) + CHECKRSA.EncryptStr(IntToStr(UserInfo.nSMark) + '/您的剩余绑定次数为0，请更换用户！'));
      end else begin
        DefMsg := MakeDefaultMsg(SM_BINDPCCOUNT_FAIL, 0, 0, 0, 0);
        SendClientSocket(GateInfo, UserInfo, EncodeMessage(DefMsg) + CHECKRSA.EncryptStr(IntToStr(UserInfo.nSMark) + '/系统错误，请联系管理员！'));
      end;
    Except
      on e: Exception do begin
        MainOutMessage('[Exception] BindPC -> ExecProc');
        MainOutMessage(E.Message);
      end;
    end;
  end;
   { boCheckOK := False;
    g_Query.SQL.Clear;
    g_Query.SQL.Add('select ID, IsAgent, Active, Password, BindCount from users where Active = true and IsAgent = false and ID = ' + IntToStr(UserInfo.nAccountID));
    g_Query.Open;
    try
      if g_Query.RecordCount > 0 then begin
        if sData = g_Query.FieldByName('Password').AsString then begin
          nCount := g_Query.FieldByName('BindCount').AsInteger;
          if nCount > 0 then begin
            g_Query.Edit;
            g_Query.FieldByName('BindCount').AsInteger := nCount - 1;
            g_Query.Post;
            boCheckOK := True;
          end
          else begin
            DefMsg := MakeDefaultMsg(SM_BINDPCCOUNT_FAIL, 0, 0, 0, 0);
            SendClientSocket(GateInfo, UserInfo, EncodeMessage(DefMsg) + CHECKRSA.EncryptStr(IntToStr(UserInfo.nSMark) +
              '/您的剩余绑定次数为0，请更换用户！'));
          end;
        end
        else begin
          Inc(UserInfo.nPassErrorCount);
          if UserInfo.nPassErrorCount < 3 then begin
            DefMsg := MakeDefaultMsg(SM_BINDPCPASS_FAIL, 0, 0, 0, 0);
            SendClientSocket(GateInfo, UserInfo, EncodeMessage(DefMsg) + CHECKRSA.EncryptStr(IntToStr(UserInfo.nSMark) +
              '/密码错误，请重新输入！'));
          end
          else
            CloseUser(GateInfo, UserInfo);
        end;
      end
      else
        CloseUser(GateInfo, UserInfo);
    finally
      g_Query.Close;
    end;
    if boCheckOK then begin
      sPublicMark := GetRandomPassword(16);
      g_Query.SQL.Clear;
      g_Query.SQL.Add('select Top 1 AccountID, PCMark, IPAddress, PublicMark from MarkList');
      g_Query.Open;
      try
        g_Query.Append;
        g_Query.FieldByName('AccountID').AsInteger := UserInfo.nAccountID;
        g_Query.FieldByName('PCMark').AsString := sPCMark;
        g_Query.FieldByName('IPAddress').AsString := UserInfo.sUserIPaddr;
        g_Query.FieldByName('PublicMark').AsString := sPublicMark;
        g_Query.Post;
      finally
        g_Query.Close;
      end;
      SendCheckOK(GateInfo, UserInfo, sPublicMark);
    end;
  end
  else
    CloseUser(GateInfo, UserInfo);  }
end;

procedure TFormMain.ClientCheckPC(GateInfo: pTGateInfo; UserInfo: pTUserInfo; sData: string);
var
  sMark, sPCMark, sPublicMark, sPCName: string;
//  I: Integer;
//  boCheckOK: Boolean;
begin
  sData := CHECKRSA.DecryptStr(sData);
  sData := GetValidStr3(sData, sMark, ['/']);
  sData := GetValidStr3(sData, sPCMark, ['/']);
  sData := GetValidStr3(sData, sPCName, ['/']);
  if not g_boSQLConnect then begin
    DefMsg := MakeDefaultMsg(SM_CHECKPC_FAIL, 0, 0, 0, 0);
    SendClientSocket(GateInfo, UserInfo, EncodeMessage(DefMsg) + CHECKRSA.EncryptStr(IntToStr(UserInfo.nSMark) + '/系统错误，请联系管理员！'));
    Exit;
  end;
  if (StrToIntDef(sMark, -1) = UserInfo.nMD5Mark) and (UserInfo.nMD5Mark > 0) and (UserInfo.nAccountID > 0) then begin
    CheckPC.Parameters[0].Value := 0;
    CheckPC.Parameters[1].Value := UserInfo.nAccountID;
    CheckPC.Parameters[2].Value := UserInfo.boBindPC;
    CheckPC.Parameters[3].Value := UserInfo.boBindIP;
    CheckPC.Parameters[4].Value := sPCMark;
    CheckPC.Parameters[5].Value := UserInfo.sUserIPaddr;
    CheckPC.Parameters[6].Value := sPCName;

    Try
      CheckPC.ExecProc;
      if CheckPC.Parameters[0].Value = 1 then begin
        SendCheckOK(GateInfo, UserInfo, sPublicMark);
      end else begin
        DefMsg := MakeDefaultMsg(SM_CHECKPC_FAIL, 0, 0, 0, 0);
        SendClientSocket(GateInfo, UserInfo, EncodeMessage(DefMsg) + CHECKRSA.EncryptStr(IntToStr(UserInfo.nSMark) + '/机器尚未绑定，是否现在绑定该机器？'));
      end;
    Except
      on e: Exception do begin
        MainOutMessage('[Exception] CheckPC -> ExecProc');
        MainOutMessage(E.Message);
      end;
    end;
  end;
   {
    boCheckOK := False;
    g_Query.SQL.Clear;
    g_Query.SQL.Add('select AccountID, PCMark, IPAddress, PCName, PublicMark, UseTime from MarkList where AccountID = ' + IntToStr(UserInfo.nAccountID));
    g_Query.Open;
    try
      for I := 0 to g_Query.RecordCount - 1 do begin
        if ((not UserInfo.boBindPC) or (sPCMark = g_Query.FieldByName('PCMark').AsString)) and
          ((not UserInfo.boBindIP) or (UserInfo.sUserIPaddr = g_Query.FieldByName('IPAddress').AsString)) then begin
          sPublicMark := GetRandomPassword(16);
          g_Query.Edit;
          g_Query.FieldByName('UseTime').AsDateTime := Now;
          g_Query.FieldByName('PublicMark').AsString := sPublicMark;
          g_Query.FieldByName('PCName').AsString := sPCName;
          if not UserInfo.boBindIP then
            g_Query.FieldByName('IPAddress').AsString := UserInfo.sUserIPaddr;
          g_Query.Post;
          boCheckOk := True;
          Break;
        end;
        g_Query.Next;
      end;
    finally
      g_Query.Close;
    end;
    if boCheckOk then begin
      SendCheckOK(GateInfo, UserInfo, sPublicMark);
    end
    else begin
      DefMsg := MakeDefaultMsg(SM_CHECKPC_FAIL, 0, 0, 0, 0);
      SendClientSocket(GateInfo, UserInfo, EncodeMessage(DefMsg) + CHECKRSA.EncryptStr(IntToStr(UserInfo.nSMark) +
        '/机器尚未绑定，是否现在绑定该机器？'));
    end;
  end
  else
    CloseUser(GateInfo, UserInfo);  }
end;

procedure TFormMain.ClientCheckMD5(GateInfo: pTGateInfo; UserInfo: pTUserInfo; sData: string);
var
  sMark, sMD5, sName: string;
//  nID: Integer;
//  boBindPC, boBindIP: Boolean;
begin
  sData := CHECKRSA.DecryptStr(sData);
  sData := GetValidStr3(sData, sMark, ['/']);
  sData := GetValidStr3(sData, sMD5, ['/']);
  sData := GetValidStr3(sData, sName, ['/']);
  //MainOutMessage(sMD5);
  if (StrToIntDef(sMark, -1) = UserInfo.nCMark) and (UserInfo.nCMark > 0) and (sMD5 <> '') and CheckMD5Rule(sMD5) and (length(sName) = 18) and (StrToInt64Def(sName, 0) > 0) then begin
    if not g_boSQLConnect then begin
      DefMsg := MakeDefaultMsg(SM_SETNAME_FAIL, 0, 0, 0, 0);
      SendClientSocket(GateInfo, UserInfo, EncodeMessage(DefMsg) + CHECKRSA.EncryptStr(IntToStr(UserInfo.nSMark) + '/系统错误，请联系管理员！'));
      Exit;
    end;
    CheckMD5.Parameters[0].Value := 0;
    CheckMD5.Parameters[1].Value := sName;
    CheckMD5.Parameters[2].Value := sMD5;
    CheckMD5.Parameters[3].Value := 0;
    CheckMD5.Parameters[4].Value := True;
    CheckMD5.Parameters[5].Value := True;
    Try
      CheckMD5.ExecProc;
      if CheckMD5.Parameters[0].Value = 1 then begin
        UserInfo.nMD5Mark := Random(8000) + 1000;
        UserInfo.nAccountID := CheckMD5.Parameters[3].Value;
        UserInfo.boBindPC := CheckMD5.Parameters[4].Value;
        UserInfo.boBindIP := CheckMD5.Parameters[5].Value;
        DefMsg := MakeDefaultMsg(SM_CHECKMD5_OK, 0, 0, 0, 0);
        SendClientSocket(GateInfo, UserInfo, EncodeMessage(DefMsg) + CHECKRSA.EncryptStr(IntToStr(UserInfo.nSMark) + '/' + IntToStr(UserInfo.nMD5Mark)));
      end else
      if CheckMD5.Parameters[0].Value = -1 then begin
        DefMsg := MakeDefaultMsg(SM_SETNAME_FAIL, 0, 0, 0, 0);
        SendClientSocket(GateInfo, UserInfo, EncodeMessage(DefMsg) + CHECKRSA.EncryptStr(IntToStr(UserInfo.nSMark) + '/用户信息不存在！'));
      end else
      if CheckMD5.Parameters[0].Value = -2 then begin
        DefMsg := MakeDefaultMsg(SM_SETNAME_FAIL, 0, 0, 0, 0);
        SendClientSocket(GateInfo, UserInfo, EncodeMessage(DefMsg) + CHECKRSA.EncryptStr(IntToStr(UserInfo.nSMark) + '/用户信息(VIP帐号)与M2文件信息不相同！'));
      end else
      if CheckMD5.Parameters[0].Value = -3 then begin
        DefMsg := MakeDefaultMsg(SM_SETNAME_FAIL, 0, 0, 0, 0);
        SendClientSocket(GateInfo, UserInfo, EncodeMessage(DefMsg) + CHECKRSA.EncryptStr(IntToStr(UserInfo.nSMark) + '/文件被病毒破坏或该版本已暂停使用！'));
      end else
      if CheckMD5.Parameters[0].Value = -4 then begin
        DefMsg := MakeDefaultMsg(SM_SETNAME_FAIL, 0, 0, 0, 0);
        SendClientSocket(GateInfo, UserInfo, EncodeMessage(DefMsg) + CHECKRSA.EncryptStr(IntToStr(UserInfo.nSMark) + '/免费版已暂停使用！'));
      end;
    Except
      on e: Exception do begin
        MainOutMessage('[Exception] CheckMD5 -> ExecProc');
        MainOutMessage(E.Message);
      end;
    end;
  end;
    {nID := 0;
    boBindPC := True;
    boBindIP := True;
    g_Query.SQL.Clear;
    g_Query.SQL.Add('select ID, IsAgent, PublicID, BindPC, BindIP from users where Active = true and IsAgent = false and PublicID = ''' + sName + '''');
    g_Query.Open;
    try
      if g_Query.RecordCount > 0 then begin
        nID := g_Query.FieldByName('ID').AsInteger;
        boBindPC := g_Query.FieldByName('BindPC').AsBoolean;
        boBindIP := g_Query.FieldByName('BindIP').AsBoolean;
      end;
    finally
      g_Query.Close;
    end;
    if nID > 0 then begin
      if T1.Checked then begin
        UserInfo.nMD5Mark := Random(8000) + 1000;
        UserInfo.nAccountID := nID;
        UserInfo.boBindPC := boBindPC;
        UserInfo.boBindIP := boBindIP;
        DefMsg := MakeDefaultMsg(SM_CHECKMD5_OK, 0, 0, 0, 0);
        SendClientSocket(GateInfo, UserInfo, EncodeMessage(DefMsg) + CHECKRSA.EncryptStr(IntToStr(UserInfo.nSMark) + '/' +
            IntToStr(UserInfo.nMD5Mark)));
        Exit;
      end;
      g_Query.SQL.Clear;
      g_Query.SQL.Add('select AccountID, MD5, UseTime from UseList where AccountID = ' + IntToStr(nID) + ' and MD5 = ''' + sMD5 + '''');
      g_Query.Open;
      try
        if g_Query.RecordCount > 0 then begin
          UserInfo.nMD5Mark := Random(8000) + 1000;
          UserInfo.nAccountID := nID;
          UserInfo.boBindPC := boBindPC;
          UserInfo.boBindIP := boBindIP;
          DefMsg := MakeDefaultMsg(SM_CHECKMD5_OK, 0, 0, 0, 0);
          SendClientSocket(GateInfo, UserInfo, EncodeMessage(DefMsg) + CHECKRSA.EncryptStr(IntToStr(UserInfo.nSMark) + '/' +
            IntToStr(UserInfo.nMD5Mark)));
          g_Query.Edit;
          g_Query.FieldByName('UseTime').AsDateTime := Now;
          g_Query.Post;
        end
        else begin
          DefMsg := MakeDefaultMsg(SM_SETNAME_FAIL, 0, 0, 0, 0);
          SendClientSocket(GateInfo, UserInfo, EncodeMessage(DefMsg) + CHECKRSA.EncryptStr(IntToStr(UserInfo.nSMark) +
            '/用户信息与M2版本不符，文件被病毒破坏或该版本已暂停使用！'));
        end;
      finally
        g_Query.Close;
      end;
    end
    else begin
      DefMsg := MakeDefaultMsg(SM_SETNAME_FAIL, 0, 0, 0, 0);
      SendClientSocket(GateInfo, UserInfo, EncodeMessage(DefMsg) + CHECKRSA.EncryptStr(IntToStr(UserInfo.nSMark) + '/用户信息不存在！'));

    end;
  end
  else
    CloseUser(GateInfo, UserInfo);  }
end;

procedure TFormMain.ClientSetName(GateInfo: pTGateInfo; UserInfo: pTUserInfo; sData: string);
var
  sMark, sName, PublicID: string;
begin
  sData := CHECKRSA.DecryptStr(sData);
  sData := GetValidStr3(sData, sMark, ['/']);
  sData := GetValidStr3(sData, sName, ['/']);
  if (StrToIntDef(sMark, -1) = UserInfo.nCMark) and (UserInfo.nCMark > 0) and CheckEMailRule(sName) then begin
    if not g_boSQLConnect then begin
      DefMsg := MakeDefaultMsg(SM_SETNAME_FAIL, 0, 0, 0, 0);
      SendClientSocket(GateInfo, UserInfo, EncodeMessage(DefMsg) + CHECKRSA.EncryptStr(IntToStr(UserInfo.nSMark) + '/系统错误，请联系管理员！'));
      Exit;
    end;
    SetName.Parameters[0].Value := 0;
    SetName.Parameters[1].Value := sName;
    SetName.Parameters[2].Value := '';
    Try
      SetName.ExecProc;
      if SetName.Parameters[0].Value = 1 then begin
        PublicID := SetName.Parameters[2].Value;
        DefMsg := MakeDefaultMsg(SM_SETNAME_OK, 0, 0, 0, 0);
        SendClientSocket(GateInfo, UserInfo, EncodeMessage(DefMsg) + CHECKRSA.EncryptStr(IntToStr(UserInfo.nSMark) + '/' + PublicID));
      end else
      if SetName.Parameters[0].Value = -1 then begin
        DefMsg := MakeDefaultMsg(SM_SETNAME_FAIL, 0, 0, 0, 0);
        SendClientSocket(GateInfo, UserInfo, EncodeMessage(DefMsg) + CHECKRSA.EncryptStr(IntToStr(UserInfo.nSMark) + '/用户信息不存在！'));
      end;
    Except
      on e: Exception do begin
        MainOutMessage('[Exception] CheckMD5 -> ExecProc');
        MainOutMessage(E.Message);
      end;
    end;
  end
  else
    CloseUser(GateInfo, UserInfo);
end;

procedure TFormMain.CloseUser(GateInfo: pTGateInfo; UserInfo: pTUserInfo);
begin
  SendUserSocket(GateInfo, MG_CodeHead + '+-' + UserInfo.sSockIndex + MG_CodeEnd);
end;

procedure TFormMain.D1Click(Sender: TObject);
{var
  EncryptSoftInfo: pTEncryptSoftInfo;     }
begin
{  New(EncryptSoftInfo);
  EncryptSoftInfo.SoftType := es_Login;
  EncryptSoftInfo.nUserID := 12;
  EncryptSoftInfo.sGUID := '测试传奇';
  EncryptSoftInfo.sDownList := 'http://www.361m2.com/';
  EncryptSoftInfo.sLoginMark := GetMD5TextOf16('201014141414');
  EncryptSoft.AddEncryptSoft(EncryptSoftInfo);     }
end;

procedure TFormMain.DecodeGateData(GateInfo: pTGateInfo);
var
  nCount: Integer;
  sMsg: string;
  sSockIndex: string;
  sArryIndex: string;
  sReadData: string;
  sData: string;
  Code: Char;
begin
  try
    nCount := 0;
    sReadData := GateInfo.sReadMsg;
    GateInfo.sReadMsg := '';
    while (true) do begin
      if pos(MG_CodeEnd, sReadData) <= 0 then
        break;
      sReadData := ArrestStringEx(sReadData, MG_CodeHead, MG_CodeEnd, sMsg);
      if sMsg <> '' then begin
        Code := sMsg[1];
        sMsg := Copy(sMsg, 2, length(sMsg) - 1);
        case Code of
          '-': begin
              GateInfo.dwKeepAliveTime := GetTickCount;
              SendKeepAlivePacket(GateInfo);
            end;
          MG_SendUser: begin
              sData := GetValidStr3(sMsg, sArryIndex, ['/']);
              sData := GetValidStr3(sData, sSockIndex, ['/']);
              if sSockIndex <> '' then
                ReceiveSendUser(GateInfo, sArryIndex, sSockIndex, sData);
            end;
          MG_OpenUser: begin
              sData := GetValidStr3(sMsg, sArryIndex, ['/']);
              sData := GetValidStr3(sData, sSockIndex, ['/']);
              if sSockIndex <> '' then
                ReceiveOpenUser(GateInfo, sArryIndex, sSockIndex, sData);
            end;
          MG_CloseUser: begin
              sSockIndex := GetValidStr3(sMsg, sArryIndex, ['/']);
              if sSockIndex <> '' then
                ReceiveCloseUser(GateInfo, sArryIndex, sSockIndex);
            end;
        end;
      end
      else begin
        if nCount >= 1 then
          sReadData := '';
        Inc(nCount);
      end;
    end;
    GateInfo.sReadMsg := sReadData;
  except
    on E:Exception do begin
      MainOutMessage('[Exception] TFormMain.DecodeGateData');
      MainOutMessage(E.Message);
    end;
  end;
end;

procedure TFormMain.DecodeTimerTimer(Sender: TObject);
var
  I: Integer;
  GateInfo: pTGateInfo;
  k: Integer;
begin
  if FGateRun then
    Exit;
  FGateRun := True;
  try
    if GetTickCount > FTestSQLConnectTick then begin
      FTestSQLConnectTick := GetTickCount + 30 * 1000;
      if g_boSQLConnect then begin
        TestConnect.Parameters[0].Value := 0;
        Try
          TestConnect.ExecProc;
          if TestConnect.Parameters[0].Value <> 1 then begin
            g_boSQLConnect := False;
            ADOConnection.Close;
          end;
        Except
          on E:Exception do begin
            MainOutMessage('[Exception] TestConnect -> ExecProc');
            MainOutMessage(E.Message);
            g_boSQLConnect := False;
            ADOConnection.Close;
          end;
        End;
      end else begin
        ADOConnection.Open();
      end;
    end;
    for I := Low(g_GateInfo) to High(g_GateInfo) do begin
      GateInfo := @g_GateInfo[I];
      if GateInfo.boDelete then begin
        GateInfo.Socket := nil;
        if GateInfo.UserList <> nil then begin
          for k := 0 to GateInfo.UserList.Count - 1 do begin
            Dispose(pTUserInfo(GateInfo.UserList[k]));
          end;
          GateInfo.UserList.Free;
          GateInfo.UserList := nil;
        end;
        GateInfo.boDelete := False;
      end
      else if (GateInfo.Socket <> nil) then begin

        DecodeGateData(GateInfo);

        //GateInfo.sSendMsg :=
        SocketStandardSend(GateInfo.sSendMsg, GateInfo);

        if (GetTickCount - GateInfo.dwKeepAliveTime) > 120 * 1000 then begin
          GateInfo.Socket.Close;
        end;
      end;
    end;
  finally
    FGateRun := False;
  end;
end;

procedure TFormMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := False;
  if Application.MessageBox('是否确定退出管理工具？', '提示信息', MB_OKCANCEL + MB_ICONQUESTION) = IDOK then begin
    EncryptSoft.Terminate;
    CanClose := True;
  end;
end;

procedure TFormMain.FormCreate(Sender: TObject);
begin
  Randomize;

  MemoLog.Lines.Clear;
  FGateCount := 0;
  FCheckCount := 0;
  FRegLoginCount := 0;
  FRegM2Count := 0;
  FGateRun := False;
  g_CurrentDir := GetCurrentDir;
  if RightStr(g_CurrentDir, 1) <> '\' then
    g_CurrentDir := g_CurrentDir + '\';
  CreateDir('.\' + M2FILESDIR + '\');
  CreateDir('.\' + LOGINFILESDIR + '\');
  //g_Query := ADOQuery;
  //g_Query.ConnectionString := 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=DB.MDB;Persist Security Info=False';
  //ADOQuery_Temp.ConnectionString := g_Query.ConnectionString;
  g_boSQLConnect := False;
  FTestSQLConnectTick := GetTickCount;
  with ADOConnection do begin
    Connected := false;
    Provider := 'SQLOLEDB.1';
    Properties['Data Source'].Value := 'MSSQLSERVER';
    Properties['Initial Catalog'].Value := '361M2';
    Properties['User ID'].Value := 'sa';
    Properties['password'].Value := 'kissmehs52769';
    LoginPrompt := false;
  end;
  //MainOutMessage(inttostr(sizeof(TNewLoginInfo)));
end;

procedure TFormMain.MainOutMessage(sMsg: string);
var
  I: Integer;
begin
  if MemoLog.Lines.Count > 200 then begin
    for I := 0 to 50 do
      MemoLog.Lines.Delete(0);
  end;
  MemoLog.Lines.Add(FormatDateTime('[MM-DD HH:MM:SS] ', Now) + sMsg);
end;

procedure TFormMain.MENU_ACCOUNT_MANAGEClick(Sender: TObject);
begin
  FormAccount.Open;
end;

procedure TFormMain.MyMessage(var MsgData: TWmCopyData);
var
  sData: string;
  wIdent: Word;
begin
  wIdent := HiWord(MsgData.From);
  sData := StrPas(MsgData.CopyDataStruct^.lpData);
  case wIdent of
    1000: SetFileMD5Info(sData);
    1001: SetLoginFileMD5Info(sData);
  end;
end;

procedure TFormMain.N201103111Click(Sender: TObject);
{var
  I, nCount: Integer;  }
begin
 { g_Query.SQL.Clear;
  g_Query.SQL.Add('select * from users');
  g_Query.Open;
  Try
    for I := 0 to g_Query.RecordCount - 1 do begin     }
      {ADOQuery_Temp.SQL.Clear;
      ADOQuery_Temp.SQL.Add('select Count(*) from MarkList where AccountID = ' + g_Query.FieldByName('ID').AsString);
      ADOQuery_Temp.Open;
      Try
        nCount := ADOQuery_Temp.Fields[0].AsInteger;
      Finally
        ADOQuery_Temp.Close;
      End;   }
    {  g_Query.Edit;
      g_Query.FieldByName('ShareID').AsInteger := 0;
      //g_Query.FieldByName('BindIP').AsBoolean := True;
      //g_Query.FieldByName('ResetCount').AsInteger := g_Query.FieldByName('BindCount').AsInteger + nCount;
      g_Query.Post;
      g_Query.Next;
    end;
    Application.MessageBox('更新完成！', '提示信息', MB_OK + MB_ICONINFORMATION);
  Finally
    g_Query.Close;
  End;   }
end;

procedure TFormMain.N2Click(Sender: TObject);
begin
  {if Application.MessageBox('是否确定清理未生成数据？', '提示信息', MB_OKCANCEL + MB_ICONINFORMATION) = IDOK then
  begin
    g_Query.SQL.Clear;
    g_Query.SQL.Add('Delete from UseList where MD5 = ''MAKEFILE''');
    g_Query.ExecSQL;
    g_Query.SQL.Clear;
    g_Query.SQL.Add('Delete from LoginList where MD5 = ''MAKEFILE''');
    g_Query.ExecSQL;
    Application.MessageBox('清理完成！', '提示信息', MB_OK + MB_ICONINFORMATION);
  end;  }
end;

procedure TFormMain.ProcessUserMsg(GateInfo: pTGateInfo; UserInfo: pTUserInfo; sMsg: string);
var
  sDefMsg: string;
  sData: string;
  DefMsg: TDefaultMessage;
begin
  try
    sDefMsg := Copy(sMsg, 1, DEFBLOCKSIZE);
    sData := Copy(sMsg, DEFBLOCKSIZE + 1, length(sMsg) - DEFBLOCKSIZE);
    DefMsg := DecodeMessage(sDefMsg);
    case UserInfo.UserType of
      ut_none: begin
          case DefMsg.Ident of
            CM_SENDMARK: ClientGetMark(GateInfo, UserInfo, sData);
            CM_DOWNLOGIN: CheckLogin(GateInfo, UserInfo, sData);
            CM_USERLISTLOGIN: CheckListLogin(GateInfo, UserInfo, sData);
            CM_NEWTOOLS_LOGIN: CheckToolsLogin(GateInfo, UserInfo, DefMsg.Recog, sData);
            CM_EXIT_EXIT: Application.Terminate;
            CM_DOWNDB: SendFileData(GateInfo, UserInfo, '.\DB.MDB', 'DB.MDB', '000', SM_DOWN_DB);
            CM_CHECKUPDATE: CheckToolsUpDate(GateInfo, UserInfo, DefMsg.Recog);
          end;
        end;
      ut_CheckM2: begin
          case DefMsg.Ident of
            CM_SENDSETNAME: ClientSetName(GateInfo, UserInfo, sData);
            CM_SENDMD5: ClientCheckMD5(GateInfo, UserInfo, sData);
            CM_SENDCHECKPC: ClientCheckPC(GateInfo, UserInfo, sData);
            CM_SENDBINDPC: ClientBindPC(GateInfo, UserInfo, sData);
          end;
        end;
      ut_down: begin
          case DefMsg.Ident of
            CM_GETDOWNLIST: ClientGetDownList(GateInfo, UserInfo);
            //CM_DOWNM2SERVER: ClientDownM2Server(GateInfo, UserInfo, sData);
            CM_DOWNLOGINEXE: ClientDownLogin(GateInfo, UserInfo, sData);
          end;
        end; 
      ut_List: begin
          case DefMsg.Ident of
            CM_USERGETENINFO: ClientGetENInfo(GateInfo, UserInfo, sData);
          end;
        end;
      ut_Tools_Agent: begin
          case DefMsg.Ident of
            CM_TOOLS_REGLOGIN: ClientAgentRegLogin(GateInfo, UserInfo, @DefMsg, sData);
            CM_TOOLS_REGM2:  ClientAgentRegM2(GateInfo, UserInfo, @DefMsg, sData);
            CM_TOOLS_CHANGEPASS: ClientChangePassword(GateInfo, UserInfo, sData);
          end;
        end;
      ut_Tools_User: begin
          case DefMsg.Ident of
            CM_TOOLS_CHANGEPASS: ClientChangePassword(GateInfo, UserInfo, sData);
            CM_GETDOWNLIST: ClientGetDownList(GateInfo, UserInfo);
            //CM_DOWNM2SERVER: ClientDownM2Server(GateInfo, UserInfo, sData);
            CM_DOWNLOGINEXE: ClientDownLogin(GateInfo, UserInfo, sData);
            CM_DOWNM2SERVER_NEW: ClientDownM2Server_New(GateInfo, UserInfo, sData);
            CM_GETDOWNDATA: ClientGetDownData(GateInfo, UserInfo, DefMsg.Recog);
            CM_USERGETENINFO: ClientGetENInfo(GateInfo, UserInfo, sData);
            CM_TOOLS_GETBINDLIST: ClientGetBindInfo(GateInfo, UserInfo);
            CM_TOOLS_CHANGEBINDINFO: ClientChangeBindInfo(GateInfo, UserInfo, DefMsg.Recog);
            CM_TOOLS_SENDMARK: ClientGetShareUserName(GateInfo, UserInfo, sData);
          end;
        end;
    end;
  except
    on E:Exception do begin
      MainOutMessage('[Exception] TFrmMain.ProcessUserMsg ' + 'wIdent: ' + IntToStr(DefMsg.Ident) + ' sData: ' + sData);
      MainOutMessage(E.Message);
    end;
  end;
end;

procedure TFormMain.ReceiveCloseUser(GateInfo: pTGateInfo; sArryIndex, sSockIndex: string);
var
  UserInfo: pTUserInfo;
  I: Integer;
begin
  for I := 0 to GateInfo.UserList.Count - 1 do begin
    UserInfo := GateInfo.UserList.Items[I];
    if UserInfo.sArryIndex = sArryIndex then begin
      if UserInfo.FileStream <> nil then
        UserInfo.FileStream.Free;
      Dispose(UserInfo);
      GateInfo.UserList.Delete(I);
      break;
    end;
  end;
end;

procedure TFormMain.ReceiveOpenUser(GateInfo: pTGateInfo; sArryIndex, sSockIndex, sIPaddr: string);
var
  UserInfo: pTUserInfo;
  I: Integer;
  sGateIPaddr: string;
  sUserIPaddr: string;
begin
  sGateIPaddr := GetValidStr3(sIPaddr, sUserIPaddr, ['/']);
  try
    for I := 0 to GateInfo.UserList.Count - 1 do begin
      UserInfo := GateInfo.UserList.Items[I];
      if (UserInfo.sArryIndex = sArryIndex) then begin
        UserInfo.sSockIndex := sSockIndex;
        UserInfo.sUserIPaddr := sUserIPaddr;
        UserInfo.sArryIndex := sArryIndex;
        UserInfo.boLogin := False;
        UserInfo.sAccount := '';
        UserInfo.nDBIndex := -1;
        UserInfo.nCMark := -1;
        UserInfo.nSMark := -1;
        UserInfo.nMD5Mark := -1;
        UserInfo.nAccountID := -1;
        UserInfo.boBindPC := True;
        UserInfo.boBindIP := True;
        UserInfo.nPassErrorCount := 0;
        UserInfo.UserType := ut_none;
        UserInfo.boAdmin := False;
        if UserInfo.FileStream <> nil then
          UserInfo.FileStream.Free;
        UserInfo.FileStream := nil;
        Exit;
      end;
    end;
    New(UserInfo);
    UserInfo.sSockIndex := sSockIndex;
    UserInfo.sUserIPaddr := sUserIPaddr;
    UserInfo.sArryIndex := sArryIndex;
    UserInfo.boLogin := False;
    UserInfo.sAccount := '';
    UserInfo.nDBIndex := -1;
    UserInfo.nCMark := -1;
    UserInfo.nSMark := -1;
    UserInfo.nMD5Mark := -1;
    UserInfo.nAccountID := -1;
    UserInfo.nPassErrorCount := 0;
    UserInfo.boBindPC := True;
    UserInfo.boBindIP := True;
    UserInfo.UserType := ut_none;
    UserInfo.FileStream := nil;
    UserInfo.boAdmin := False;
    GateInfo.UserList.Add(UserInfo);
  except
    MainOutMessage('TFrmMain.ReceiveOpenUser');
  end;
end;

procedure TFormMain.ReceiveSendUser(GateInfo: pTGateInfo; sArryIndex, sSockIndex, sData: string);
var
  UserInfo: pTUserInfo;
  I: Integer;
  sMsg: string;
begin
  try
    for I := GateInfo.UserList.Count - 1 downto 0 do begin
      UserInfo := GateInfo.UserList.Items[I];
      if UserInfo.sArryIndex = sArryIndex then begin
        ArrestStringEx(sData, g_CodeHead, g_CodeEnd, sMsg);
        if Length(sMsg) >= DEFBLOCKSIZE then
          ProcessUserMsg(GateInfo, UserInfo, sMsg);
      end;
    end;
  except
    MainOutMessage('TFrmMain.ReceiveSendUser');
  end;
end;

procedure TFormMain.SendCheckOK(GateInfo: pTGateInfo; UserInfo: pTUserInfo; sPublicMark: string);
var
  sPassword, sSendMsg, sTempStr: string;
  TempList: TStringList;
  Aintf: _Recordset;
  RecordsAffected: OleVariant;
begin
  sPassword := '';
  CheckOK.Parameters[0].Value := 0;
  CheckOK.Parameters[1].Value := UserInfo.nAccountID;
  Try
    Try
      CheckOK.Open;
      sPassword := '';
      while not CheckOK.Eof do begin
        sTempStr := LowerCase(GetMD5TextOf16(LowerCase(CheckOK.FieldByName('UrlList').AsString)));
        if sPassword = '' then sPassword := Copy(sTempStr, 5, 8)
        else sPassword := sPassword + '|' + Copy(sTempStr, 5, 8);
        CheckOK.Next;
      end;
      Aintf := CheckOK.Recordset;
      if Assigned(Aintf) then begin
        Aintf := Aintf.NextRecordset(RecordsAffected);
        if Assigned(Aintf) then begin
          CheckOK.Recordset := Aintf;
          while not CheckOK.Eof do begin
            sTempStr := LowerCase(GetMD5TextOf16(LowerCase(CheckOK.FieldByName('UrlList').AsString)));
            sPassword := sPassword + '|' + Copy(sTempStr, 5, 8);
            CheckOK.Next;
          end;
        end;
      end;
    Except
      on E:Exception do begin
        MainOutMessage('[Exception] CheckOK -> open');
        MainOutMessage(E.Message);
      end;
    End;
  Finally
    CheckOK.Close;
  End;
  if sPassword <> '' then begin
    Inc(FCheckCount);
    if UserInfo.UserVar > 0 then begin
      sSendMsg := '/';
      TempList := TStringList.Create;
      if FileExists(g_CurrentDir + 'AD\msg.txt') then begin
        TempList.LoadFromFile(g_CurrentDir + 'AD\msg.txt');
        sSendMsg := sSendMsg + ADRSA.EncryptStr(TempList.Text) + '/';
      end else
       sSendMsg := sSendMsg + '/';

      if FileExists(g_CurrentDir + 'AD\frame.txt') then begin
        TempList.LoadFromFile(g_CurrentDir + 'AD\frame.txt');
        sSendMsg := sSendMsg + ADRSA.EncryptStr(TempList.Text) + '/';
      end else
       sSendMsg := sSendMsg + '/';

      if FileExists(g_CurrentDir + 'AD\exit.txt') then begin
        TempList.LoadFromFile(g_CurrentDir + 'AD\exit.txt');
        sSendMsg := sSendMsg + ADRSA.EncryptStr(TempList.Text) + '/';
      end else
       sSendMsg := sSendMsg + '/';
       
      DefMsg := MakeDefaultMsg(SM_CHECKPC_NEW_OK, 0, 0, 0, 0);
      SendClientSocket(GateInfo, UserInfo, EncodeMessage(DefMsg) + CHECKRSA.EncryptStr(IntToStr(UserInfo.nSMark) + '/' + sPassword + '/' + sPublicMark) + sSendMsg);
      TempList.Free;
    end else begin
      DefMsg := MakeDefaultMsg(SM_CHECKPC_OK, 0, 0, 0, 0);
      SendClientSocket(GateInfo, UserInfo, EncodeMessage(DefMsg) + CHECKRSA.EncryptStr(IntToStr(UserInfo.nSMark) + '/' + sPassword + '/' + sPublicMark));
    end;
  end;
end;

procedure TFormMain.SendClientSocket(GateInfo: pTGateInfo; UserInfo: pTUserInfo; sMsg: string);
var
  sSendMsg: string;
begin
  sSendMsg := UserInfo.sArryIndex + '/' + UserInfo.sSockIndex + '/' + g_CodeHead + sMsg + g_CodeEnd;
  SendUserSocket(GateInfo, MG_CodeHead + sSendMsg + MG_CodeEnd);
end;

procedure TFormMain.ClientGetDownData(GateInfo: pTGateInfo; UserInfo: pTUserInfo; nIdent: Integer);
var
  FileSize: Int64;
  nReadLen, nOffset: Integer;
  Buffer: array[0..6100] of Char;
begin
  if UserInfo.FileStream <> nil then begin
    FileSize := UserInfo.FileStream.Size;
    nOffset := UserInfo.FileStream.Position;
    nReadLen := UserInfo.FileStream.Read(Buffer[0], SizeOf(Buffer));
    DefMsg := MakeDefaultMsg(nIdent, FileSize, nReadLen, LoWord(nOffset), HiWord(nOffset));
    SendClientSocket(GateInfo, UserInfo, EncodeMessage(DefMsg) + EncodeBuffer(@Buffer[0], nReadLen));
    if nReadLen < SizeOf(Buffer) then begin
      UserInfo.FileStream.Free;
      UserInfo.FileStream := nil;
    end;
  end;
end;

procedure TFormMain.SendFileData(GateInfo: pTGateInfo; UserInfo: pTUserInfo; sFileName, sWriteName, sMD5: string; nIdent: Integer);
//var
  //FileStream: TFileStream;
  //FileSize: Int64;
  //nReadLen, nOffset: Integer;
  //Buffer: array[0..9999] of Char;
begin
  if FileExists(sFileName) then begin
    DefMsg := MakeDefaultMsg(nIdent, -1, 0, 0, 0);
    SendClientSocket(GateInfo, UserInfo, EncodeMessage(DefMsg) + EncodeString(sMD5 + '/' + sWriteName));
    if UserInfo.FileStream <> nil then UserInfo.FileStream.Free;
    UserInfo.FileStream := TFileStream.Create(sFileName, fmOpenRead or fmShareDenyWrite);
    {Try
      FileSize := UserInfo.FileStream.Size;
      while True do begin
        nOffset := UserInfo.FileStream.Position;
        nReadLen := UserInfo.FileStream.Read(Buffer[0], SizeOf(Buffer));
        DefMsg := MakeDefaultMsg(nIdent, FileSize, nReadLen, LoWord(nOffset), HiWord(nOffset));
        SendClientSocket(GateInfo, UserInfo, EncodeMessage(DefMsg) + EncodeBuffer(@Buffer[0], nReadLen));
        if nReadLen < SizeOf(Buffer) then break;
      end;
    Finally
      UserInfo.FileStream.Free;
    End;  }
  end;
end;

procedure TFormMain.SendKeepAlivePacket(GateInfo: pTGateInfo);
begin
  SendUserSocket(GateInfo, MG_CodeHead + '++' + MG_CodeEnd);
end;

procedure TFormMain.SendUserSocket(GateInfo: pTGateInfo; sMsg: string);
begin
  GateInfo.sSendMsg := GateInfo.sSendMsg + sMsg;
end;

procedure TFormMain.SetLoginFileMD5Info(sData: string);
var
  sMD5, sVar, sID, sName, sNameMD5: string;
  nID: Integer;
begin
  sData := GetValidStr3(sData, sMD5, ['/']);
  sData := GetValidStr3(sData, sVar, ['/']);
  sData := GetValidStr3(sData, sID, ['/']);
  sData := GetValidStr3(sData, sName, ['/']);
  nID := StrToIntDef(sID, 0);
  if nID > 0 then begin
    sNameMD5 := GetMD5Text(sName);
    Try
      SetDownLoginInfo.Parameters[0].Value := 0;
      SetDownLoginInfo.Parameters[1].Value := nID;
      SetDownLoginInfo.Parameters[2].Value := 4;
      SetDownLoginInfo.Parameters[3].Value := sVar;
      SetDownLoginInfo.Parameters[4].Value := sName;
      SetDownLoginInfo.Parameters[5].Value := sNameMD5;
      SetDownLoginInfo.Parameters[6].Value := sMD5;
      SetDownLoginInfo.Parameters[7].Value := 0;
      SetDownLoginInfo.Parameters[8].Value := '';
      SetDownLoginInfo.Parameters[9].Value := '';
      SetDownLoginInfo.ExecProc;
    Except
      on e: Exception do begin
        MainOutMessage('[Exception] SetDownLoginInfo -> ExecProc(4)');
        MainOutMessage(E.Message);
      end;
    End;
  end;
end;

procedure TFormMain.SocketStandardSend(sSendMsg: string; GateInfo: pTGateInfo);
var
  sData, sSendData: string;
  nSendLen: Integer;
begin
  if GetTickCount < GateInfo.dwSuspendedTick then begin
    GateInfo.sSendMsg := sSendMsg;
  end else begin
    sSendData := sSendMsg;
    while (sSendData <> '') and (GateInfo.Socket.Connected) do begin
      nSendLen := Length(sSendData);
      if nSendLen > MAXSENDMSGLEN then begin
        sData := Copy(sSendData, 1, MAXSENDMSGLEN);
        if GateInfo.Socket.SendText(sData) <> -1 then begin
          sSendData := Copy(sSendData, MAXSENDMSGLEN + 1, nSendLen - MAXSENDMSGLEN);
          GateInfo.dwSuspendedCount := 0;
        end
        else begin
          Inc(GateInfo.dwSuspendedCount);
          GateInfo.dwSuspendedTick := GetTickCount + LongWord(200 * GateInfo.dwSuspendedCount);
          if GateInfo.dwSuspendedCount >= 1000 then begin
            GateInfo.Socket.Close;
            //GateInfo.Socket := nil;
            MainOutMessage('传输失败:  ' + GateInfo.sIPaddr);
            Exit;
          end;
          Break;
        end;
      end
      else begin
        if GateInfo.Socket.SendText(sSendData) <> -1 then begin
          sSendData := '';
          GateInfo.dwSuspendedCount := 0;
        end else begin
          Inc(GateInfo.dwSuspendedCount);
          GateInfo.dwSuspendedTick := GetTickCount + LongWord(200 * GateInfo.dwSuspendedCount);
          if GateInfo.dwSuspendedCount >= 1000 then begin
            GateInfo.Socket.Close;
            //GateInfo.Socket := nil;
            //GateInfo.SocketHandle := -1;
            MainOutMessage('传输失败:  ' + GateInfo.sIPaddr);
            Exit;
          end;
        end;
        break;
      end;
    end;
    GateInfo.sSendMsg := sSendData;
  end;
{var
  sData, sSendData: string;
  nSendLen: Integer;
begin
  sSendData := sSendMsg;
  while (sSendData <> '') and (Socket.Connected) do begin
    nSendLen := Length(sSendData);
    if nSendLen > MAXSENDMSGLEN then begin
      sData := Copy(sSendData, 1, MAXSENDMSGLEN);
      if Socket.SendText(sData) <> -1 then begin
        sSendData := Copy(sSendData, MAXSENDMSGLEN + 1, nSendLen - MAXSENDMSGLEN);
      end
      else
        break;
    end
    else begin
      if Socket.SendText(sSendData) <> -1 then begin
        sSendData := '';
      end;
      break;
    end;
  end;
  Result := sSendData;  }
end;

procedure TFormMain.SetFileMD5Info(sData: string);
var
  sMD5, sVar, sID: string;
  nID: Integer;
begin
  sData := GetValidStr3(sData, sMD5, ['/']);
  sData := GetValidStr3(sData, sVar, ['/']);
  sData := GetValidStr3(sData, sID, ['/']);
  nID := StrToIntDef(sID, 0);
  if nID > 0 then begin
    Try
      SetDownM2ServerInfo.Parameters[0].Value := 0;
      SetDownM2ServerInfo.Parameters[1].Value := nID;
      SetDownM2ServerInfo.Parameters[2].Value := 4;
      SetDownM2ServerInfo.Parameters[3].Value := sVar;
      SetDownM2ServerInfo.Parameters[4].Value := sMD5;
      SetDownM2ServerInfo.Parameters[5].Value := 0;
      SetDownM2ServerInfo.Parameters[6].Value := '';
      SetDownM2ServerInfo.ExecProc;
    Except
      on e: Exception do begin
        MainOutMessage('[Exception] SetDownM2ServerInfo -> ExecProc(4)');
        MainOutMessage(E.Message);
      end;
    End;
  end;
end;
{
function TFormMain.SocketStandardSend(Socket: TCustomWinSocket; sSendMsg: string): string;
var
  sData, sSendData: string;
  nSendLen: Integer;
begin
  sSendData := sSendMsg;
  while (sSendData <> '') and (Socket.Connected) do begin
    nSendLen := Length(sSendData);
    if nSendLen > MAXSENDMSGLEN then begin
      sData := Copy(sSendData, 1, MAXSENDMSGLEN);
      if Socket.SendText(sData) <> -1 then begin
        sSendData := Copy(sSendData, MAXSENDMSGLEN + 1, nSendLen - MAXSENDMSGLEN);
      end
      else
        break;
    end
    else begin
      if Socket.SendText(sSendData) <> -1 then begin
        sSendData := '';
      end;
      break;
    end;
  end;
  Result := sSendData;
end;      }

procedure TFormMain.SSocketClientConnect(Sender: TObject; Socket: TCustomWinSocket);
var
  I: Integer;
begin
  Socket.nIndex := -1;
  for I := Low(g_GateInfo) to High(g_GateInfo) do begin
    if (g_GateInfo[I].Socket = nil) and (not g_GateInfo[I].boDelete) then begin
      g_GateInfo[I].Socket := Socket;
      g_GateInfo[I].sIPaddr := Socket.RemoteAddress;
      g_GateInfo[I].sReadMsg := '';
      g_GateInfo[I].sSendMsg := '';
      g_GateInfo[I].UserList := TList.Create;
      g_GateInfo[I].boDelete := False;
      g_GateInfo[I].dwKeepAliveTime := GetTickCount;
      g_GateInfo[I].dwSuspendedCount := 0;
      g_GateInfo[I].dwSuspendedTick := 0;
      Inc(FGateCount);
      MainOutMessage('网关连接(' + Socket.RemoteAddress + ':' + IntToStr(Socket.RemotePort) + ')...');
      Socket.nIndex := I;
      Break;
    end;
  end;
end;

procedure TFormMain.SSocketClientDisconnect(Sender: TObject; Socket: TCustomWinSocket);
var
  nIdx: Integer;
begin
  nIdx := Socket.nIndex;
  if (nIdx in [Low(g_GateInfo)..High(g_GateInfo)]) then begin
    if not g_GateInfo[nIdx].boDelete then begin
      g_GateInfo[nIdx].boDelete := True;
      g_GateInfo[nIdx].Socket := nil;
      Dec(FGateCount);
      MainOutMessage('网关断开(' + Socket.RemoteAddress + ':' + IntToStr(Socket.RemotePort) + ')...');
    end;
    Socket.nIndex := -1;
  end;
end;

procedure TFormMain.SSocketClientError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
  Socket.Close;
  ErrorCode := 0;
end;

procedure TFormMain.SSocketClientRead(Sender: TObject; Socket: TCustomWinSocket);
var
  nIdx: Integer;
  sMsg: string;
begin
  nIdx := Socket.nIndex;
  sMsg := Socket.ReceiveText;
  if (nIdx in [Low(g_GateInfo)..High(g_GateInfo)]) then begin
    g_GateInfo[nIdx].sReadMsg := g_GateInfo[nIdx].sReadMsg + sMsg;
  end;
end;

procedure TFormMain.SSocketListen(Sender: TObject; Socket: TCustomWinSocket);
var
  I: Integer;
begin
  for I := Low(g_GateInfo) to High(g_GateInfo) do begin
    g_GateInfo[I].Socket := nil;
    g_GateInfo[I].sIPaddr := '';
    g_GateInfo[I].sReadMsg := '';
    g_GateInfo[I].sSendMsg := '';
    g_GateInfo[I].UserList := nil;
    g_GateInfo[I].boDelete := False;
    g_GateInfo[I].dwKeepAliveTime := GetTickCount;
  end;
  MainOutMessage('端口绑定(' + Socket.LocalAddress + ':' + IntToStr(Socket.LocalPort) + ')...');
end;

procedure TFormMain.StartTimerTimer(Sender: TObject);
var
  sReadStr, sStr: string;
  nPos1, nPos2: Integer;
begin
  StartTimer.Enabled := False;
  MainOutMessage('正在启动服务...');
  SSocket.Port := 7800;
  SSocket.Active := True;
  Timer1Timer(Timer1);
  Timer1.Enabled := True;
  DecodeTimer.Enabled := True;
  EncryptSoft := TEncryptSoft.Create(Handle, True);
  EncryptSoft.FreeOnTerminate := True;
  EncryptSoft.Resume;
  sReadStr := IdHTTP1.Get('http://hi.baidu.com/trayclock/home');
  nPos1 := Pos('$test', sReadStr);
  nPos2 := Pos('$add', sReadStr);
  if (nPos2 > nPos1) and (nPos1 > 0) and (nPos2 > 0) then begin
    sReadStr := Copy(sReadStr, nPos1 + 6, nPos2 - nPos1 - 6);
    if sReadStr <> '' then begin
      sReadStr := ArrestStringEx(sReadStr, '>', '<', sStr);
      CHECKRSA.PrivateKey := sStr;
      sReadStr := ArrestStringEx(sReadStr, '>', '<', sStr);
      LISTRSA.PrivateKey := sStr;
      sReadStr := ArrestStringEx(sReadStr, '>', '<', sStr);
      ADDRSRSA.PrivateKey := sStr;
      sReadStr := ArrestStringEx(sReadStr, '>', '<', sStr);
      TOOLSRSA.PrivateKey := sStr;
      sReadStr := ArrestStringEx(sReadStr, '>', '<', sStr);
      ADRSA.PrivateKey := sStr;
      {MainOutMessage(CHECKRSA.PrivateKey);
      MainOutMessage(LISTRSA.PrivateKey);
      MainOutMessage(ADDRSRSA.PrivateKey);
      MainOutMessage(TOOLSRSA.PrivateKey);
      MainOutMessage(ADRSA.PrivateKey);}
      ADOConnection.Open();

      MainOutMessage('服务启动完成...');
      Exit;
    end;
  end;
  MainOutMessage('服务启动失败...');

end;

procedure TFormMain.T1Click(Sender: TObject);
begin
  T1.Checked := not T1.Checked;
  ADOConnection.Close;
end;

procedure TFormMain.Timer1Timer(Sender: TObject);
begin
  StatusBar.Panels[0].Text := IntToStr(SSocket.Port);
  StatusBar.Panels[1].Text := '[' + IntToStr(FGateCount) + ']';
  StatusBar.Panels[2].Text := ' 验证：' + IntToStr(FCheckCount);
  StatusBar.Panels[3].Text := ' 登录器：' + IntToStr(FRegLoginCount);
  StatusBar.Panels[4].Text := ' 引擎：' + IntToStr(FRegM2Count);
end;

end.

