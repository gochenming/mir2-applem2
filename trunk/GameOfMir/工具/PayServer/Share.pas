unit Share;

interface
uses
  Windows, SysUtils, Classes;

type
  pTPayDBInfo = ^TPayDBInfo;
  TPayDBInfo = packed record
    ID: Integer;
    billno: string[50];
    price: Integer;
    custom1: string[20];
    custom2: string[30];
    payvia: string[10];
    paycardno: string[30];
    paycardpass: string[30];
    orderdate: TDateTime;
  end;


function HTTPDecode(const AStr: String): String;
function HTTPEncode(const AStr: String): String;

var
  g_MainHandle: THandle;
  g_PayUserID: string;
  g_PayUserPass: string;
  g_PayBackUrl: string;
  g_HTTPEncodeBackUrl: string;

implementation

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
