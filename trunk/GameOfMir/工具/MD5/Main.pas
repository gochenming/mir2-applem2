unit Main;

interface

uses
  SysUtils, Classes, Controls, Forms,
  StdCtrls;

type
  TFormMain = class(TForm)
    Edit1: TEdit;
    Edit2: TEdit;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    procedure Edit1Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;

implementation

uses
MD5Unit;

{$R *.dfm}

procedure TFormMain.Edit1Change(Sender: TObject);
var
  str: string;
begin
  if CheckBox2.Checked then str := GetMD5TextOf16(Edit1.Text)
  else str := GetMD5Text(Edit1.Text);
  
  if CheckBox1.Checked then Edit2.Text := UpperCase(str)
  else Edit2.Text := str;

end;

end.
