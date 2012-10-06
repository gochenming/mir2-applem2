program SendCheck;


uses
  SysUtils, Classes, Msxml;
var
  List: TStringList;
  Xmlhttp: IXMLHTTPREQUEST;

begin
  List := TStringList.Create;
  xmlhttp := CoXMLHTTPREQUEST.Create;
  try
    xmlhttp.open('GET', ParamStr(1), false, '', '');
    xmlHttp.send('');
    List.Add(xmlHttp.responseText);
    list.savetofile('d:\test.txt');
  finally
    xmlhttp := nil;
  end;
end.
