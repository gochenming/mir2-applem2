unit SqlMain;

interface

uses
  Windows, Messages, SysUtils, Classes, ADODB, DB;

const
  SQLDISPOSETEXT = '连接失败';
  //CHECKUSERLOGIN = 0;
  {GETMATRIXCARDNO = CHECKUSERLOGIN + 1;
  CHANGEGOLD = GETMATRIXCARDNO + 1;
  CREATENEWCHAR = CHANGEGOLD + 1;
  CREATEGUILD = CREATENEWCHAR + 1; }
  CCreateNewCDKey = 0;
  CUserLogin = 1;
  CGetMatrixCardNo = 2;
  CCreateNewChr = 3;
  CCreateNewGuild = 4;
  CGameGoldChange = 5;
  CCheckCDKey = 6;
  CGetCDKeyData = 7;
  CSetUserEmail = 8;
  CSetEmailCheckOK = 9;
  CChangePassWord = 10;
  CCheckLostPassword = 11;
  CSetLostPassword = 12;
  CGetLargessGold = 13;

  STOREDPROCCOUNT = 14;

type
  pTUserLoginInfo = ^TUserLoginInfo;
  TUserLoginInfo = packed record
    UserID: Integer;
    UserGold: Integer;
    sLoginAddrs: string[30];
    CheckEMail: Boolean;
  end;

  pTUserDataInfo = ^TUserDataInfo;
  TUserDataInfo = packed record
    ID: Integer;
    Account: string[16];
    PassWord: string[16];
    CardID: Integer;
    GameGold: Integer;
    UserName: string[12];
    BirthDay: string[20];
    Quiz1: string[20];
    Answer1: string[20];
    Quiz2: string[20];
    Answer2: string[20];
    EMail: string[30];
    Phone: string[14];
    MobilePhone: string[14];
    IdentityCard: string[18];
    RegDateTime: TDateTime;
    LoginDateTime: TDateTime;
    LoginAddrs: string[16];
    CheckEMail: Boolean;
  end;

  TSql = class(TObject)
    FboConnect: Boolean; //是否已连接
  private
    FConn: TADOConnection;
    FStoredProc: array[0..STOREDPROCCOUNT - 1] of TADOStoredProc;
    procedure InitializeStoredProc(StoredProcID: Integer);
  public
    constructor Create;
    destructor Destroy; override;

    function Conn: Boolean;
    function UnConn: Boolean;
    function CreateNewCDKey(sAccount, sPassWord, sUserName, sBirthDay, sQuiz1, sAnswer1, sQuiz2, sAnswer2,
      sEMail, sPhone, sMobilePhone, sIdentityCard: string; nIntroducer: Integer): Integer;
    function UserLogin(sAccount, sPassWord, sAddrs: string; UserLoginInfo: pTUserLoginInfo): Integer;
    function GetMatrixCard(CardID: Integer; CardN1, CardN2, CardN3: Char; out Card1, Card2, Card3: string): Boolean;
    function CreateNewChr(sChrName: string): Boolean;
    function CreateNewGuild(sGuildName: string): Boolean;
    function CheckCDKey(sAccount: string): Boolean;
    function GetCDKeyData(sAccount: string; nID: Integer; var UserDataInfo: TUserDataInfo): Boolean;
    function SetUserEmail(nAccountID: Integer; sEMail: string): Boolean;
    function SetEmailCheckOK(nAccountID: Integer): Boolean;
    function ChangePassWord(sAccount, sPassword, sNewPassword: string): Boolean;
    function CheckLostPassword(sAccount, sEMail, sKey: string; out UserID: Integer): Boolean;
    function SetLostPassword(nAccountID: Integer; sAccount, sPassword, sKey: string): Boolean;
    function GetLargessGold(sAccount, sChrName, sServerName: string): Integer;
    function GameGoldChange(nIDIndex, nCount: Integer; sLogIndex, sAccount, sChrName, sServerName: string;
      boAdd: Boolean; LargessGold: Integer; out GameGoldCount: Integer): Integer;
  end;

var
  SQL: TSQL;

implementation

uses
  Share;

{ TSql }

constructor TSql.Create;
var
  i: Integer;
begin
  inherited;
  FboConnect := False;
  FConn := TADOConnection.Create(nil);
  with FConn do begin
    Connected := false;
    Provider := 'SQLOLEDB.1';
{$IFDEF TESTDEBUG}
    Properties['Data Source'].Value := g_sSQLAddrs;
{$ELSE}
    Properties['Data Source'].Value := g_sSQLAddrs;
{$ENDIF}
    Properties['Initial Catalog'].Value := g_sSQLDBName;
    Properties['User ID'].Value := g_sSQLUserID;
    Properties['password'].Value := g_sSQLUserPass;
    LoginPrompt := false;
  end;
  for I := Low(FStoredProc) to High(FStoredProc) do begin
    FStoredProc[i] := TADOStoredProc.Create(nil);
    FStoredProc[i].Active := False;
    FStoredProc[i].Connection := FConn;
    InitializeStoredProc(i);
  end;
end;

function TSql.CreateNewCDKey(sAccount, sPassWord, sUserName, sBirthDay, sQuiz1, sAnswer1, sQuiz2, sAnswer2, sEMail, sPhone,
  sMobilePhone, sIdentityCard: string; nIntroducer: Integer): Integer;
var
  nCode: Integer;
begin
  Result := -1;
  if FboConnect then begin
    FStoredProc[CCreateNewCDKey].Parameters[0].Value := 0;
    FStoredProc[CCreateNewCDKey].Parameters[1].Value := sAccount;
    FStoredProc[CCreateNewCDKey].Parameters[2].Value := sPassWord;
    FStoredProc[CCreateNewCDKey].Parameters[3].Value := sEMail;
    FStoredProc[CCreateNewCDKey].Parameters[4].Value := sUserName;
    FStoredProc[CCreateNewCDKey].Parameters[5].Value := sBirthDay;
    FStoredProc[CCreateNewCDKey].Parameters[6].Value := sQuiz1;
    FStoredProc[CCreateNewCDKey].Parameters[7].Value := sAnswer1;
    FStoredProc[CCreateNewCDKey].Parameters[8].Value := sQuiz2;
    FStoredProc[CCreateNewCDKey].Parameters[9].Value := sAnswer2;
    FStoredProc[CCreateNewCDKey].Parameters[10].Value := sPhone;
    FStoredProc[CCreateNewCDKey].Parameters[11].Value := sMobilePhone;
    FStoredProc[CCreateNewCDKey].Parameters[12].Value := sIdentityCard;
    FStoredProc[CCreateNewCDKey].Parameters[13].Value := nIntroducer;
    try
      FStoredProc[CCreateNewCDKey].ExecProc;
      nCode := FStoredProc[CCreateNewCDKey].Parameters[0].Value;
      if nCode > 0 then Result := nCode
      else Result := -2;
      {if nCode = -1 then begin
        Result := -2;
      end
      else if nCode = 0 then begin
        Result := 1;
      end;  }
    except
      on e: Exception do begin
        MainOutMessage('[Exception] CreateNewCDKey -> ExecProc');
        MainOutMessage(E.Message);
        if E.Message = SQLDISPOSETEXT then begin
          try
            FboConnect := False;
            FConn.Connected := False;
          except
          end;
        end;
      end;
    end;
  end;
end;

function TSql.CreateNewChr(sChrName: string): Boolean;
begin
  Result := False;
  if FboConnect then begin
    FStoredProc[CCreateNewChr].Parameters[0].Value := 0;
    FStoredProc[CCreateNewChr].Parameters[1].Value := sChrName;
    try
      FStoredProc[CCreateNewChr].ExecProc;
      Result := FStoredProc[CCreateNewChr].Parameters[0].Value = 1;
    except
      on e: Exception do begin
        MainOutMessage('[Exception] CreateNewChr -> ExecProc');
        MainOutMessage(E.Message);
        if E.Message = SQLDISPOSETEXT then begin
          try
            FboConnect := False;
            FConn.Connected := False;
          except
          end;
        end;
      end;
    end;
  end;
end;

function TSql.CreateNewGuild(sGuildName: string): Boolean;
begin
  Result := False;
  if FboConnect then begin
    FStoredProc[CCreateNewGuild].Parameters[0].Value := 0;
    FStoredProc[CCreateNewGuild].Parameters[1].Value := sGuildName;
    try
      FStoredProc[CCreateNewGuild].ExecProc;
      Result := FStoredProc[CCreateNewGuild].Parameters[0].Value = 1;
    except
      on e: Exception do begin
        MainOutMessage('[Exception] CreateNewGuild -> ExecProc');
        MainOutMessage(E.Message);
        if E.Message = SQLDISPOSETEXT then begin
          try
            FboConnect := False;
            FConn.Connected := False;
          except
          end;
        end;
      end;
    end;
  end;
end;

destructor TSql.Destroy;
var
  i: Integer;
begin
  for I := Low(FStoredProc) to High(FStoredProc) do begin
    FStoredProc[i].Active := False;
    FStoredProc[i].Free;
  end;
  UnConn;
  FConn.Free;
  inherited;
end;

function TSql.GameGoldChange(nIDIndex, nCount: Integer; sLogIndex, sAccount, sChrName, sServerName: string;
  boAdd: Boolean; LargessGold: Integer; out GameGoldCount: Integer): Integer;
begin
  Result := -6;
  if FboConnect then begin
    FStoredProc[CGameGoldChange].Parameters[0].Value := 0;
    FStoredProc[CGameGoldChange].Parameters[1].Value := nCount;
    FStoredProc[CGameGoldChange].Parameters[2].Value := LargessGold;
    FStoredProc[CGameGoldChange].Parameters[3].Value := nIDIndex;
    FStoredProc[CGameGoldChange].Parameters[4].Value := sAccount;
    FStoredProc[CGameGoldChange].Parameters[5].Value := sChrName;
    FStoredProc[CGameGoldChange].Parameters[6].Value := sLogIndex;
    FStoredProc[CGameGoldChange].Parameters[7].Value := sServerName;
    FStoredProc[CGameGoldChange].Parameters[8].Value := boAdd;
    try
      FStoredProc[CGameGoldChange].ExecProc;
      Result := FStoredProc[CGameGoldChange].Parameters[0].Value;
      GameGoldCount := FStoredProc[CGameGoldChange].Parameters[1].Value;
    except
      on e: Exception do begin
        MainOutMessage('[Exception] GameGoldChange -> ExecProc');
        MainOutMessage(E.Message);
        if E.Message = SQLDISPOSETEXT then begin
          try
            FboConnect := False;
            FConn.Connected := False;
          except
          end;
        end;
      end;
    end;
  end;
end;

function TSql.GetCDKeyData(sAccount: string; nID: Integer; var UserDataInfo: TUserDataInfo): Boolean;
begin
  Result := False;
  if FboConnect then begin
    FStoredProc[CGetCDKeyData].Parameters[1].Value := sAccount;
    FStoredProc[CGetCDKeyData].Parameters[2].Value := nID;
    try
      Try
        FStoredProc[CGetCDKeyData].Open;
        if not FStoredProc[CGetCDKeyData].Eof then begin
          Result := True;
          UserDataInfo.ID := FStoredProc[CGetCDKeyData].FieldByName('ID').AsInteger;
          UserDataInfo.Account := FStoredProc[CGetCDKeyData].FieldByName('Account').AsString;
          UserDataInfo.PassWord := FStoredProc[CGetCDKeyData].FieldByName('PassWord').AsString;
          UserDataInfo.CardID := FStoredProc[CGetCDKeyData].FieldByName('CardID').AsInteger;
          UserDataInfo.GameGold := FStoredProc[CGetCDKeyData].FieldByName('GameGold').AsInteger;
          UserDataInfo.UserName := FStoredProc[CGetCDKeyData].FieldByName('UserName').AsString;
          UserDataInfo.BirthDay := FStoredProc[CGetCDKeyData].FieldByName('BirthDay').AsString;
          UserDataInfo.Quiz1 := FStoredProc[CGetCDKeyData].FieldByName('Quiz1').AsString;
          UserDataInfo.Answer1 := FStoredProc[CGetCDKeyData].FieldByName('Answer1').AsString;
          UserDataInfo.Quiz2 := FStoredProc[CGetCDKeyData].FieldByName('Quiz2').AsString;
          UserDataInfo.Answer2 := FStoredProc[CGetCDKeyData].FieldByName('Answer2').AsString;
          UserDataInfo.EMail := FStoredProc[CGetCDKeyData].FieldByName('EMail').AsString;
          UserDataInfo.Phone := FStoredProc[CGetCDKeyData].FieldByName('Phone').AsString;
          UserDataInfo.MobilePhone := FStoredProc[CGetCDKeyData].FieldByName('MobilePhone').AsString;
          UserDataInfo.IdentityCard := FStoredProc[CGetCDKeyData].FieldByName('IdentityCard').AsString;
          UserDataInfo.RegDateTime := FStoredProc[CGetCDKeyData].FieldByName('RegDateTime').AsDateTime;
          UserDataInfo.LoginDateTime := FStoredProc[CGetCDKeyData].FieldByName('LoginDateTime').AsDateTime;
          UserDataInfo.LoginAddrs := FStoredProc[CGetCDKeyData].FieldByName('LoginAddrs').AsString;
          UserDataInfo.CheckEMail := FStoredProc[CGetCDKeyData].FieldByName('CheckEMail').AsBoolean;
        end;
      Except
        on e: Exception do begin
          MainOutMessage('[Exception] GetCDKeyData -> Open');
          MainOutMessage(E.Message);
          if E.Message = SQLDISPOSETEXT then begin
            try
              FboConnect := False;
              FConn.Connected := False;
            except
            end;
          end;
        end;
      End;
    finally
      FStoredProc[CGetCDKeyData].Close;
    end;
  end;
end;

function TSql.GetMatrixCard(CardID: Integer; CardN1, CardN2, CardN3: Char; out Card1, Card2, Card3: string): Boolean;
begin
  Result := False;
  if FboConnect then begin
    FStoredProc[CGetMatrixCardNo].Parameters[1].Value := CardID;
    FStoredProc[CGetMatrixCardNo].Parameters[2].Value := CardN1;
    FStoredProc[CGetMatrixCardNo].Parameters[3].Value := CardN2;
    FStoredProc[CGetMatrixCardNo].Parameters[4].Value := CardN3;
    try
      Try
        FStoredProc[CGetMatrixCardNo].Open;
        if not FStoredProc[CGetMatrixCardNo].Eof then begin
          Result := True;
          Card1 := FStoredProc[CGetMatrixCardNo].FieldByName('No1').AsString;
          Card2 := FStoredProc[CGetMatrixCardNo].FieldByName('No2').AsString;
          Card3 := FStoredProc[CGetMatrixCardNo].FieldByName('No3').AsString;
        end;
      Except
        on e: Exception do begin
          MainOutMessage('[Exception] GetMatrixCard -> Open');
          MainOutMessage(E.Message);
          if E.Message = SQLDISPOSETEXT then begin
            try
              FboConnect := False;
              FConn.Connected := False;
            except
            end;
          end;
        end;
      End;
    finally
      FStoredProc[CGetMatrixCardNo].Close;
    end;
  end;
end;

procedure TSql.InitializeStoredProc(StoredProcID: Integer);
begin
  case StoredProcID of
    CCreateNewCDKey: begin
        FStoredProc[StoredProcID].ProcedureName := 'CreateNewCDKey';
        FStoredProc[StoredProcID].Parameters.Clear;
        FStoredProc[StoredProcID].Parameters.CreateParameter('@Return_Value', ftInteger, pdReturnValue, 10, 0);
        FStoredProc[StoredProcID].Parameters.CreateParameter('@sAccount', ftString, pdInput, 16, '');
        FStoredProc[StoredProcID].Parameters.CreateParameter('@sPassWord', ftString, pdInput, 16, '');
        FStoredProc[StoredProcID].Parameters.CreateParameter('@sEMail', ftString, pdInput, 30, '');
        FStoredProc[StoredProcID].Parameters.CreateParameter('@sUserName', ftString, pdInput, 12, '');
        FStoredProc[StoredProcID].Parameters.CreateParameter('@sBirthDay', ftString, pdInput, 8, '');
        FStoredProc[StoredProcID].Parameters.CreateParameter('@sQuiz1', ftString, pdInput, 20, '');
        FStoredProc[StoredProcID].Parameters.CreateParameter('@sAnswer1', ftString, pdInput, 20, '');
        FStoredProc[StoredProcID].Parameters.CreateParameter('@sQuiz2', ftString, pdInput, 20, '');
        FStoredProc[StoredProcID].Parameters.CreateParameter('@sAnswer2', ftString, pdInput, 20, '');
        FStoredProc[StoredProcID].Parameters.CreateParameter('@sPhone', ftString, pdInput, 14, '');
        FStoredProc[StoredProcID].Parameters.CreateParameter('@sMobilePhone', ftString, pdInput, 14, '');
        FStoredProc[StoredProcID].Parameters.CreateParameter('@sIdentityCard', ftString, pdInput, 18, '');
        FStoredProc[StoredProcID].Parameters.CreateParameter('@IntroducerID', ftInteger, pdInput, 10, 0);
      end;
    CUserLogin: begin
        FStoredProc[StoredProcID].ProcedureName := 'CheckUserLogin';
        FStoredProc[StoredProcID].Parameters.Clear;
        FStoredProc[StoredProcID].Parameters.CreateParameter('@Return_Value', ftInteger, pdReturnValue, 10, 0);
        FStoredProc[StoredProcID].Parameters.CreateParameter('@UserAccount', ftString, pdInput, 16, '');
        FStoredProc[StoredProcID].Parameters.CreateParameter('@UserPassWord', ftString, pdInput, 16, '');
        FStoredProc[StoredProcID].Parameters.CreateParameter('@UserLoginAddrs', ftString, pdInput, 16, '');
        FStoredProc[StoredProcID].Parameters.CreateParameter('@UserID', ftInteger, pdOutput, 10, 0);
        FStoredProc[StoredProcID].Parameters.CreateParameter('@UserGold', ftInteger, pdOutput, 10, 0);
        FStoredProc[StoredProcID].Parameters.CreateParameter('@CheckEMail', ftBoolean, pdOutput, 1, 0);
        FStoredProc[StoredProcID].Parameters.CreateParameter('@LoginAddrs', ftString, pdOutput, 16, 0);
      end;
    CGetMatrixCardNo: begin
        FStoredProc[StoredProcID].ProcedureName := 'GetMatrixCardNo';
        FStoredProc[StoredProcID].Parameters.Clear;
        FStoredProc[StoredProcID].Parameters.CreateParameter('@Return_Value', ftInteger, pdReturnValue, 10, 0);
        FStoredProc[StoredProcID].Parameters.CreateParameter('@CardID', ftInteger, pdInput, 10, 0);
        FStoredProc[StoredProcID].Parameters.CreateParameter('@CardNo1', ftString, pdInput, 1, 0);
        FStoredProc[StoredProcID].Parameters.CreateParameter('@CardNo2', ftString, pdInput, 1, 0);
        FStoredProc[StoredProcID].Parameters.CreateParameter('@CardNo3', ftString, pdInput, 1, 0);
      end;
    CCreateNewChr: begin
        FStoredProc[StoredProcID].ProcedureName := 'CreateNewChr';
        FStoredProc[StoredProcID].Parameters.Clear;
        FStoredProc[StoredProcID].Parameters.CreateParameter('@Return_Value', ftInteger, pdReturnValue, 10, 0);
        FStoredProc[StoredProcID].Parameters.CreateParameter('@sChrName', ftString, pdInput, 14, 0);
      end;
    CCreateNewGuild: begin
        FStoredProc[StoredProcID].ProcedureName := 'CreateNewGuild';
        FStoredProc[StoredProcID].Parameters.Clear;
        FStoredProc[StoredProcID].Parameters.CreateParameter('@Return_Value', ftInteger, pdReturnValue, 10, 0);
        FStoredProc[StoredProcID].Parameters.CreateParameter('@sGuildName', ftString, pdInput, 14, 0);
      end;
    CGameGoldChange: begin
        FStoredProc[StoredProcID].ProcedureName := 'GameGoldChange';
        FStoredProc[StoredProcID].Parameters.Clear;
        FStoredProc[StoredProcID].Parameters.CreateParameter('@Return_Value', ftInteger, pdReturnValue, 10, 0);
        FStoredProc[StoredProcID].Parameters.CreateParameter('@GoldCount', ftInteger, pdInputOutput, 10, 0);
        FStoredProc[StoredProcID].Parameters.CreateParameter('@LargessGold', ftInteger, pdInput, 10, 0);
        FStoredProc[StoredProcID].Parameters.CreateParameter('@AccountID', ftInteger, pdInput, 10, 0);
        FStoredProc[StoredProcID].Parameters.CreateParameter('@Account', ftString, pdInput, 20, 0);
        FStoredProc[StoredProcID].Parameters.CreateParameter('@ChrName', ftString, pdInput, 16, 0);
        FStoredProc[StoredProcID].Parameters.CreateParameter('@LogIndex', ftString, pdInput, 50, 0);
        FStoredProc[StoredProcID].Parameters.CreateParameter('@ServerName', ftString, pdInput, 20, 0);
        FStoredProc[StoredProcID].Parameters.CreateParameter('@IsAdd', ftBoolean, pdInput, 1, 0);
      end;
    CCheckCDKey: begin
        FStoredProc[StoredProcID].ProcedureName := 'CheckCDKey';
        FStoredProc[StoredProcID].Parameters.Clear;
        FStoredProc[StoredProcID].Parameters.CreateParameter('@Return_Value', ftInteger, pdReturnValue, 10, 0);
        FStoredProc[StoredProcID].Parameters.CreateParameter('@UserAccount', ftString, pdInput, 16, 0);
      end;
    CGetCDKeyData: begin
        FStoredProc[StoredProcID].ProcedureName := 'GetCDKeyData';
        FStoredProc[StoredProcID].Parameters.Clear;
        FStoredProc[StoredProcID].Parameters.CreateParameter('@Return_Value', ftInteger, pdReturnValue, 10, 0);
        FStoredProc[StoredProcID].Parameters.CreateParameter('@sAccount', ftString, pdInput, 16, 0);
        FStoredProc[StoredProcID].Parameters.CreateParameter('@UserID', ftInteger, pdInput, 10, 0);
      end;
    CSetUserEmail: begin
        FStoredProc[StoredProcID].ProcedureName := 'SetUserEmail';
        FStoredProc[StoredProcID].Parameters.Clear;
        FStoredProc[StoredProcID].Parameters.CreateParameter('@Return_Value', ftInteger, pdReturnValue, 10, 0);
        FStoredProc[StoredProcID].Parameters.CreateParameter('@AccountID', ftInteger, pdInput, 10, 0);
        FStoredProc[StoredProcID].Parameters.CreateParameter('@sEMail', ftString, pdInput, 30, 0);
      end;
    CSetEmailCheckOK: begin
        FStoredProc[StoredProcID].ProcedureName := 'SetEmailCheckOK';
        FStoredProc[StoredProcID].Parameters.Clear;
        FStoredProc[StoredProcID].Parameters.CreateParameter('@Return_Value', ftInteger, pdReturnValue, 10, 0);
        FStoredProc[StoredProcID].Parameters.CreateParameter('@AccountID', ftInteger, pdInput, 10, 0);
      end;
    CChangePassWord: begin
        FStoredProc[StoredProcID].ProcedureName := 'ChangePassWord';
        FStoredProc[StoredProcID].Parameters.Clear;
        FStoredProc[StoredProcID].Parameters.CreateParameter('@Return_Value', ftInteger, pdReturnValue, 10, 0);
        FStoredProc[StoredProcID].Parameters.CreateParameter('@Account', ftString, pdInput, 16, 0);
        FStoredProc[StoredProcID].Parameters.CreateParameter('@PassWord', ftString, pdInput, 16, 0);
        FStoredProc[StoredProcID].Parameters.CreateParameter('@NewPassWord', ftString, pdInput, 16, 0);
      end;
    CCheckLostPassword: begin
        FStoredProc[StoredProcID].ProcedureName := 'CheckLostPassword';
        FStoredProc[StoredProcID].Parameters.Clear;
        FStoredProc[StoredProcID].Parameters.CreateParameter('@Return_Value', ftInteger, pdReturnValue, 10, 0);
        FStoredProc[StoredProcID].Parameters.CreateParameter('@Account', ftString, pdInput, 16, 0);
        FStoredProc[StoredProcID].Parameters.CreateParameter('@EMail', ftString, pdInput, 30, 0);
        FStoredProc[StoredProcID].Parameters.CreateParameter('@SessionKey', ftString, pdInput, 32, 0);
        FStoredProc[StoredProcID].Parameters.CreateParameter('@UserID', ftInteger, pdOutput, 10, 0);
      end;
    CSetLostPassword: begin
        FStoredProc[StoredProcID].ProcedureName := 'SetLostPassword';
        FStoredProc[StoredProcID].Parameters.Clear;
        FStoredProc[StoredProcID].Parameters.CreateParameter('@Return_Value', ftInteger, pdReturnValue, 10, 0);
        FStoredProc[StoredProcID].Parameters.CreateParameter('@UserID', ftInteger, pdInput, 10, 0);
        FStoredProc[StoredProcID].Parameters.CreateParameter('@Account', ftString, pdInput, 16, 0);
        FStoredProc[StoredProcID].Parameters.CreateParameter('@Password', ftString, pdInput, 16, 0);
        FStoredProc[StoredProcID].Parameters.CreateParameter('@SessionKey', ftString, pdInput, 32, 0);
      end;
    CGetLargessGold: begin
        FStoredProc[StoredProcID].ProcedureName := 'GetLargessGold';
        FStoredProc[StoredProcID].Parameters.Clear;
        FStoredProc[StoredProcID].Parameters.CreateParameter('@Return_Value', ftInteger, pdReturnValue, 10, 0);
        FStoredProc[StoredProcID].Parameters.CreateParameter('@Account', ftString, pdInput, 16, 0);
        FStoredProc[StoredProcID].Parameters.CreateParameter('@ChrName', ftString, pdInput, 16, 0);
        FStoredProc[StoredProcID].Parameters.CreateParameter('@ServerName', ftString, pdInput, 20, 0);
      end;
  end;
end;

function TSql.ChangePassWord(sAccount, sPassword, sNewPassword: string): Boolean;
begin
  Result := False;
  if FboConnect then begin
    FStoredProc[CChangePassWord].Parameters[0].Value := 0;
    FStoredProc[CChangePassWord].Parameters[1].Value := sAccount;
    FStoredProc[CChangePassWord].Parameters[2].Value := sPassword;
    FStoredProc[CChangePassWord].Parameters[3].Value := sNewPassword;
    try
      FStoredProc[CChangePassWord].ExecProc;
      Result := FStoredProc[CChangePassWord].Parameters[0].Value = 0;
    except
      on e: Exception do begin
        MainOutMessage('[Exception] ChangePassWord -> ExecProc');
        MainOutMessage(E.Message);
        if E.Message = SQLDISPOSETEXT then begin
          try
            FboConnect := False;
            FConn.Connected := False;
          except
          end;
        end;
      end;
    end;
  end;
end;

function TSql.SetEmailCheckOK(nAccountID: Integer): Boolean;
begin
  Result := False;
  if FboConnect then begin
    FStoredProc[CSetEmailCheckOK].Parameters[0].Value := 0;
    FStoredProc[CSetEmailCheckOK].Parameters[1].Value := nAccountID;
    try
      FStoredProc[CSetEmailCheckOK].ExecProc;
      Result := FStoredProc[CSetEmailCheckOK].Parameters[0].Value = 0;
    except
      on e: Exception do begin
        MainOutMessage('[Exception] SetEmailCheckOK -> ExecProc');
        MainOutMessage(E.Message);
        if E.Message = SQLDISPOSETEXT then begin
          try
            FboConnect := False;
            FConn.Connected := False;
          except
          end;
        end;
      end;
    end;
  end;
end;

function TSql.GetLargessGold(sAccount, sChrName, sServerName: string): Integer;
begin
  Result := 0;
  if FboConnect then begin
    FStoredProc[CGetLargessGold].Parameters[0].Value := 0;
    FStoredProc[CGetLargessGold].Parameters[1].Value := sAccount;
    FStoredProc[CGetLargessGold].Parameters[2].Value := sChrName;
    FStoredProc[CGetLargessGold].Parameters[3].Value := sServerName;
    try
      FStoredProc[CGetLargessGold].ExecProc;
      Result := FStoredProc[CGetLargessGold].Parameters[0].Value;
    except
      on e: Exception do begin
        MainOutMessage('[Exception] GetLargessGold -> ExecProc');
        MainOutMessage(E.Message);
        if E.Message = SQLDISPOSETEXT then begin
          try
            FboConnect := False;
            FConn.Connected := False;
          except
          end;
        end;
      end;
    end;
  end;
end;

function TSql.SetLostPassword(nAccountID: Integer; sAccount, sPassword, sKey: string): Boolean;
begin
  Result := False;
  if FboConnect then begin
    FStoredProc[CSetLostPassword].Parameters[0].Value := 0;
    FStoredProc[CSetLostPassword].Parameters[1].Value := nAccountID;
    FStoredProc[CSetLostPassword].Parameters[2].Value := sAccount;
    FStoredProc[CSetLostPassword].Parameters[3].Value := sPassword;
    FStoredProc[CSetLostPassword].Parameters[4].Value := sKey;
    try
      FStoredProc[CSetLostPassword].ExecProc;
      Result := FStoredProc[CSetLostPassword].Parameters[0].Value = 0;
    except
      on e: Exception do begin
        MainOutMessage('[Exception] SetLostPassword -> ExecProc');
        MainOutMessage(E.Message);
        if E.Message = SQLDISPOSETEXT then begin
          try
            FboConnect := False;
            FConn.Connected := False;
          except
          end;
        end;
      end;
    end;
  end;
end;

function TSql.SetUserEmail(nAccountID: Integer; sEMail: string): Boolean;
begin
  Result := False;
  if FboConnect then begin
    FStoredProc[CSetUserEmail].Parameters[0].Value := 0;
    FStoredProc[CSetUserEmail].Parameters[1].Value := nAccountID;
    FStoredProc[CSetUserEmail].Parameters[2].Value := sEMail;
    try
      FStoredProc[CSetUserEmail].ExecProc;
      Result := FStoredProc[CSetUserEmail].Parameters[0].Value = 0;
    except
      on e: Exception do begin
        MainOutMessage('[Exception] SetUserEmail -> ExecProc');
        MainOutMessage(E.Message);
        if E.Message = SQLDISPOSETEXT then begin
          try
            FboConnect := False;
            FConn.Connected := False;
          except
          end;
        end;
      end;
    end;
  end;
end;

function TSql.CheckCDKey(sAccount: string): Boolean;
begin
  Result := False;
  if FboConnect then begin
    FStoredProc[CCheckCDKey].Parameters[0].Value := 0;
    FStoredProc[CCheckCDKey].Parameters[1].Value := sAccount;
    try
      FStoredProc[CCheckCDKey].ExecProc;
      Result := FStoredProc[CCheckCDKey].Parameters[0].Value = 1;
    except
      on e: Exception do begin
        MainOutMessage('[Exception] CheckCDKey -> ExecProc');
        MainOutMessage(E.Message);
        if E.Message = SQLDISPOSETEXT then begin
          try
            FboConnect := False;
            FConn.Connected := False;
          except
          end;
        end;
      end;
    end;
  end;
end;

function TSql.CheckLostPassword(sAccount, sEMail, sKey: string; out UserID: Integer): Boolean;
begin
  Result := False;
  UserID := 0;
  if FboConnect then begin
    FStoredProc[CCheckLostPassword].Parameters[0].Value := 0;
    FStoredProc[CCheckLostPassword].Parameters[1].Value := sAccount;
    FStoredProc[CCheckLostPassword].Parameters[2].Value := sEMail;
    FStoredProc[CCheckLostPassword].Parameters[3].Value := sKey;
    FStoredProc[CCheckLostPassword].Parameters[4].Value := 0;
    try
      FStoredProc[CCheckLostPassword].ExecProc;
      Result := FStoredProc[CCheckLostPassword].Parameters[0].Value = 0;
      if Result then UserID := FStoredProc[CCheckLostPassword].Parameters[4].Value;
    except
      on e: Exception do begin
        MainOutMessage('[Exception] CheckLostPassword -> ExecProc');
        MainOutMessage(E.Message);
        if E.Message = SQLDISPOSETEXT then begin
          try
            FboConnect := False;
            FConn.Connected := False;
          except
          end;
        end;
      end;
    end;
  end;
end;

function TSql.Conn: Boolean;
begin
  Result := False;
  try
    FConn.Open;
    FboConnect := True;
    Result := True;
  except

  end;
end;

function TSql.UnConn: Boolean;
begin
  Result := True;
  FConn.Close;
  FboConnect := False;
end;

function TSql.UserLogin(sAccount, sPassWord, sAddrs: string; UserLoginInfo: pTUserLoginInfo): Integer;
begin
  UserLoginInfo.UserID := 0;
  UserLoginInfo.UserGold := 0;
  Result := -1;
  if FboConnect then begin
    FStoredProc[CUserLogin].Parameters[0].Value := 0;
    FStoredProc[CUserLogin].Parameters[1].Value := sAccount;
    FStoredProc[CUserLogin].Parameters[2].Value := sPassWord;
    FStoredProc[CUserLogin].Parameters[3].Value := sAddrs;
    FStoredProc[CUserLogin].Parameters[4].Value := 0;
    FStoredProc[CUserLogin].Parameters[5].Value := 0;
    FStoredProc[CUserLogin].Parameters[6].Value := 0;
    FStoredProc[CUserLogin].Parameters[7].Value := sAddrs;
    try
      FStoredProc[CUserLogin].ExecProc;
      Result := FStoredProc[CUserLogin].Parameters[0].Value;
      UserLoginInfo.UserID := FStoredProc[CUserLogin].Parameters[4].Value;
      UserLoginInfo.UserGold := FStoredProc[CUserLogin].Parameters[5].Value;
      UserLoginInfo.CheckEMail := FStoredProc[CUserLogin].Parameters[6].Value;
      UserLoginInfo.sLoginAddrs := FStoredProc[CUserLogin].Parameters[7].Value;
      if UserLoginInfo.sLoginAddrs = '' then UserLoginInfo.sLoginAddrs := sAddrs;
      
    except
      on e: Exception do begin
        MainOutMessage('[Exception] UserLogin -> ExecProc');
        MainOutMessage(E.Message);
        if E.Message = SQLDISPOSETEXT then begin
          try
            FboConnect := False;
            FConn.Connected := False;
          except
          end;
        end;
      end;
    end;
  end;
end;

initialization

finalization

end.


