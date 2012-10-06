unit DoorDlg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, HUtil32;

type
  TFrmDoorDlg = class(TForm)
    CkDoor: TCheckBox;
    EdIndex: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    EdOffset: TEdit;
    BitBtn1: TBitBtn;
  private
  public
    function Update (var nDoorIndex, nDoorOffset: Integer): Boolean;
  end;

var
  FrmDoorDlg: TFrmDoorDlg;

implementation

{$R *.DFM}

function TFrmDoorDlg.Update (var nDoorIndex, nDoorOffset: Integer): Boolean;
begin
  if (nDoorIndex and $80) <> 0 then CkDoor.Checked := TRUE
  else CkDoor.Checked := FALSE;

  EdIndex.Text := IntToStr((nDoorIndex and $7F));
  EdOffset.Text := IntToStr(nDoorOffset);
  if mrOk = ShowModal then begin
    if CkDoor.Checked then nDoorIndex :=Str_Toint(EdIndex.Text, 0) or $80
    else nDoorIndex :=Str_Toint(EdIndex.Text, 0);
    nDoorOffset := Str_Toint(EdOffset.Text, 0);
    Result := TRUE;
  end else begin
    Result := FALSE;
  end;
end;

end.                           
