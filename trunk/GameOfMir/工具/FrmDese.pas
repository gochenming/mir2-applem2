unit FrmDese;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DXDraws;

type
  TFormDesc = class(TForm)
    DXDraw1: TDXDraw;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormDesc: TFormDesc;

implementation
uses
Share;

{$R *.dfm}

procedure TFormDesc.FormCreate(Sender: TObject);
begin
  DescStr := '';
end;

end.
