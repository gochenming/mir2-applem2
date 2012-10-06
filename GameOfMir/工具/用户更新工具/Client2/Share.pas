unit Share;

interface

uses
  Classes, HUtil32;

function CheckEMailRule(sEMail: string): Boolean;

implementation

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

end.
