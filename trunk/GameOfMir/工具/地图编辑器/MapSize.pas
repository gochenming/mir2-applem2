unit MapSize;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, HUtil32, Spin;

type
  TFrmMapSize = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    EdWidth: TSpinEdit;
    EdHeight: TSpinEdit;
    procedure FormShow(Sender: TObject);
  private
  public
    MapX, MapY: integer;
    function Execute: Boolean;
  end;

var
  FrmMapSize: TFrmMapSize;

implementation

{$R *.DFM}

function TFrmMapSize.Execute: Boolean;
begin
  MapX := 20;
  MapY := 20;
  EdWidth.Text := IntToStr(MapX);
  EdHeight.Text := IntToStr(MapY);
  if mrOk = ShowModal then begin
    MapX := StrToIntDef(EdWidth.Text, 1);
    MapY := StrToIntDef(EdHeight.Text, 1);
    Result := TRUE;
  end
  else
    Result := FALSE;
end;

procedure TFrmMapSize.FormShow(Sender: TObject);
begin
  EdWidth.SetFocus;
end;

end.

