unit Share;

interface
uses
ComCtrls, Classes;

const
  TABNAMECOMBOX = 'TABNAMECOMBOX';
  DBGRID        = 'DBGRID';

var
  DBNAME  : String = '';
  TabSheets: array[0..20] of TTabSheet;
  DBList: TStringList;

implementation

initialization
begin
  DBList := TStringList.Create;
end;

finalization
begin
  DBList.Free;
end;



end.
