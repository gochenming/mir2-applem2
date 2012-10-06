unit Share;

interface
uses
  Windows, SysUtils, Classes, JSocket;

const
  GATEMAXSESSION = 100; //最大用户连接数
  MAXREADSIZE = 1024 * 1024;

  WEB_MSGCODE_CREATEKEY_OK = '1'; //创建账号成功
  WEB_MSGCODE_CDKEY_NOTEXIST = '2'; //账号不存在

  WEB_MSGCODE_SYSERROR = '-1'; //系统错误
  WEB_MSGCODE_CREATEKEY1 = '-2'; //创建账号参数不正确
  WEB_MSGCODE_CREATEKEY2 = '-3'; //创建账号失败,账号已存在
  WEB_MSGCODE_CDKEY_EXIST = '-4'; //账号已存在

  CHECKEMAILOK_PASS = 'C7F0C72E-DD48-4FCD-9A89-71F2FE035D54';

type
  pTUserSession = ^TUserSession;
  TUserSession = packed record
    Socket: TCustomWinSocket; //0x00
    SocketHandle: Integer; //0x28
    sRemoteIPaddr: string; //0x04
    ReadString: string;
    SendString: string;
    ServerName: string;
    ServerCount: string;
//    boKeepAlive: Boolean;
    dwKeepAliveTick: LongWord;
    dwConnectTick: LongWord;
  end;

  pTWEBSession = ^TWEBSession;
  TWEBSession = packed record
    sRemoteIPaddr: string;
    ReadString: string;
    SendString: string;
  end;

function CheckCDKeyRule(sCDKey: string): Boolean;
function CheckMD5Rule(sMD5: string): Boolean;
function CheckIntStrRule(sIntStr: string): Boolean;
function CheckEMailRule(sEMail: string): Boolean;
//function CheckSQLCMDFiltr(sStr: string): Boolean;
procedure MainOutMessage(sMsg: string);
function HTTPDecode(const AStr: String): String;
function HTTPEncode(const AStr: String): String;

var
  g_SessionArray: array[0..GATEMAXSESSION - 1] of TUserSession;
  g_nSessionCount: Integer = 0;
  g_dwCheckSessionTick: LongWord = 0;
  g_sSQLAddrs: string = '127.0.0.1';
  g_sSQLDBName: string = 'GameDB';
  g_sSQLUserID: string = 'sa';
  g_sSQLUserPass: string = '';
  g_boSendEMail: Boolean = False;
  g_sServerName: string = '飞鸿网络';
  g_sEMailNameList: TStringList;
  g_sEMailPassword: string;
  g_sEMailSmtpHost: string;
  g_sEMailSmtpPort: Word;

implementation
uses
  FrmMain;

function CheckCDKeyRule(sCDKey: string): Boolean;
var
  Chr: Char;
begin
  Result := True;
  for Chr in sCDKey do begin
    if not (Chr in ['a'..'z', '0'..'9', '_']) then begin
      Result := False;
      break;
    end;
  end;
end;

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

function CheckIntStrRule(sIntStr: string): Boolean;
var
  Chr: Char;
begin
  Result := True;
  for Chr in sIntStr do begin
    if not (Chr in ['0'..'9']) then begin
      Result := False;
      break;
    end;
  end;
end;

function CheckEMailRule(sEMail: string): Boolean;
var
  Chr: Char;
begin
  Result := False;
  if Pos('@', sEMail) <= 0 then exit;
  if Pos('.', sEMail) <= 0 then exit;
  Result := True;
  for Chr in sEMail do begin
    if not (Chr in ['a'..'z', '0'..'9', '_', '.', '-', '@']) then begin
      Result := False;
      break;
    end;
  end;

end;
     {
function CheckSQLCMDFiltr(sStr: string): Boolean;
var
  Chr: Char;
begin
  Result := True;
  for Chr in sStr do begin
    if (Chr in ['<', '>', '?', '=', '+', '-', '%', '/']) then begin
      Result := False;
      break;
    end;
  end;
end;   }

procedure MainOutMessage(sMsg: string);
begin
  if sMsg = '' then exit;
  if FormMain.mmoLog.Lines.Count > 200 then
    FormMain.mmoLog.Lines.Delete(0);
  FormMain.mmoLog.Lines.Add(FormatDateTime('[DD HH:MM:SS] ', Now) + sMsg);
end;

function HTTPDecode(const AStr: String): String;
var
  Sp, Rp, Cp: PChar;
  S: String;
begin
  SetLength(Result, Length(AStr));
  Sp := PChar(AStr);
  Rp := PChar(Result);
//  Cp := Sp;
  try
    while Sp^ <> #0 do
    begin
      case Sp^ of
        '+': Rp^ := ' ';
        '%': begin
               // Look for an escaped % (%%) or %<hex> encoded character
               Inc(Sp);
               if Sp^ = '%' then
                 Rp^ := '%'
               else
               begin
                 Cp := Sp;
                 Inc(Sp);
                 if (Cp^ <> #0) and (Sp^ <> #0) then
                 begin
                   S := '$' + Cp^ + Sp^;
                   Rp^ := Chr(StrToInt(S));
                 end
                 else
                   raise Exception.CreateFmt('Error decoding URL style (%%XX) encoded string at position %d', [Cp - PChar(AStr)]);
               end;
             end;
      else
        Rp^ := Sp^;
      end;
      Inc(Rp);
      Inc(Sp);
    end;
  except
  end;
  SetLength(Result, Rp - PChar(Result));
end;

function HTTPEncode(const AStr: String): String;
// The NoConversion set contains characters as specificed in RFC 1738 and
// should not be modified unless the standard changes.
const
  NoConversion = ['A'..'Z','a'..'z','*','@','.','_','-',
                  '0'..'9','$','!','''','(',')'];
var
  Sp, Rp: PChar;
begin
  SetLength(Result, Length(AStr) * 3);
  Sp := PChar(AStr);
  Rp := PChar(Result);
  while Sp^ <> #0 do
  begin
    if Sp^ in NoConversion then
      Rp^ := Sp^
    else
      if Sp^ = ' ' then
        Rp^ := '+'
      else
      begin
        FormatBuf(Rp^, 3, '%%%.2x', 6, [Ord(Sp^)]);
        Inc(Rp,2);
      end;
    Inc(Rp);
    Inc(Sp);
  end;
  SetLength(Result, Rp - PChar(Result));
end;

end.

