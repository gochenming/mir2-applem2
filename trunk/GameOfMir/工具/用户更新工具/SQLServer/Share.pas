unit Share;

interface

uses
  Classes, ADODB, HUtil32, JSocket;

const
  MAXSENDMSGLEN = 8192;
  M2FILESDIR = 'M2Files';
  LOGINFILESDIR = 'LoginFiles';

  AGENTLOG_REGLOGIN = 1;
  AGENTLOG_REGM2 = 2;
  AGENTLOG_CHANGEBIND = 3;
type

  TUserType = (ut_none, ut_CheckM2, ut_down, ut_List, ut_Tools_user, ut_Tools_Agent);

  pTUserInfo = ^TUserInfo;
  TUserInfo = record
    sAccount: string;
    nDBIndex: Integer;
    sUserIPaddr: string;
    sSockIndex: string;
    sArryIndex: string;
    sUserList: string;
    nCMark: Integer;
    nSMark: Integer;
    nMD5Mark: Integer;
    nAccountID: Integer;
    nPassErrorCount: Byte;
    UserType: TUserType;
    UserVar: Integer;
    UserPort: Word;
    boLogin: Boolean;
    boBindPC: Boolean;
    boBindIP: Boolean;
    boAdmin: Boolean;
    FileStream: TFileStream;
  end;

  pTGateInfo = ^TGateInfo;
  TGateInfo = record
    Socket: TCustomWinSocket;
    sIPaddr: string;
    sReadMsg: string;
    sSendMsg: string;
    UserList: TList;
    boDelete: Boolean;
    dwKeepAliveTime: LongWord;
    dwSuspendedTick: LongWord;
    dwSuspendedCount: Integer;
  end;


var
  g_CurrentDir: string;
  //g_Query: TADOQuery;
  g_boSQLConnect: Boolean;
  g_GateInfo: array[0..10] of TGateInfo;

procedure MainOutMessage(sMsg: string);
function GetRandomPassword(nMaxLen: Integer): string;
function CheckEMailRule(sEMail: string): Boolean;
function CheckMD5Rule(sMD5: string): Boolean;

implementation

uses
  FrmMain;

function CheckMD5Rule(sMD5: string): Boolean;
var
  Chr: Char;
begin
  Result := True;
  for Chr in sMD5 do begin
    if not (Chr in ['a'..'f', '0'..'9']) then begin
      Result := False;
      break;
    end;
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

function GetRandomPassword(nMaxLen: Integer): string;
const
  PasswordChar: array[0..63] of Char = ('a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'm', 'n', 'p',
    'q', 'r', 's', 't', 'u', 'w', 'x', 'y', 'z', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C',
    'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'M', 'N', 'P', 'Q', 'R', 'S', 'T', 'U', 'W', 'X', 'Y', 'Z', '1',
    '2', '3', '4', '5', '6', '7', '8', '9');

var
  I: Integer;
begin
  Result := '';
  if nMaxLen <= 0 then
    Exit;
  for I := 1 to nMaxLen do
    Result := Result + PasswordChar[Random(Length(PasswordChar))];
end;

procedure MainOutMessage(sMsg: string);
var
  I: Integer;
begin
  if FormMain.MemoLog.Lines.Count > 200 then begin
    for I := 0 to 9 do
      FormMain.MemoLog.Lines.Delete(FormMain.MemoLog.Lines.Count - 1);
  end;
  FormMain.MemoLog.Lines.Add(sMsg);
end;

end.

