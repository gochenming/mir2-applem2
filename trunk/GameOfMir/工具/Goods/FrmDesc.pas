unit FrmDesc;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Spin;

type
  TClickPoint = record
    rc: TRect;
    rstr: string;
  end;
  pTClickPoint = ^TClickPoint;

  TFormDesc = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
    Button2: TButton;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private

  public
  end;

var
  FormDesc: TFormDesc;
  ChrBuff: PChar;

implementation
uses
  HUtil32, Share;

{$R *.dfm}

procedure TFormDesc.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  DescStr := Memo1.Lines.GetText;
end;

end.

