unit glight;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, HUtil32, Buttons, Spin;

type
  TFrmGetLight = class(TForm)
    Label1: TLabel;
    BitBtn1: TBitBtn;
    Edit1: TSpinEdit;
    procedure FormShow(Sender: TObject);
  private
  public
    function GetValue(oldvalue: integer): integer;
  end;

var
  FrmGetLight: TFrmGetLight;

implementation

{$R *.DFM}

function TFrmGetLight.GetValue(oldvalue: integer): integer;
begin
  Edit1.Text := IntToStr(oldvalue);
  ShowModal;
  Result := StrToIntDef(Edit1.Text, 0);
end;

procedure TFrmGetLight.FormShow(Sender: TObject);
begin
  Edit1.SetFocus;
  Edit1.SelStart := 0;
  Edit1.SelLength := 100;
end;

end.

