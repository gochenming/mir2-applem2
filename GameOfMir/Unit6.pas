unit Unit6;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm6 = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    Edit1: TEdit;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form6: TForm6;

implementation

{$R *.dfm}
uses
  Des;

procedure TForm6.Button1Click(Sender: TObject);
var
  Str: string;
begin
  Str := EncryStrHex(Edit1.Text, '123456'); 
  Memo1.Lines.SetText(PChar(Str));
  Caption := IntToStr(Length(Str) div 2);
end;

end.
