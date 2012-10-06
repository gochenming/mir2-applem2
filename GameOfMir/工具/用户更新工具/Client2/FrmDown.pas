unit FrmDown;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, Buttons, RzPrgres;

type
  TFormDown = class(TForm)
    Animate1: TAnimate;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    RzProgressBar1: TRzProgressBar;
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormDown: TFormDown;

implementation

{$R *.dfm}

procedure TFormDown.BitBtn1Click(Sender: TObject);
begin
  Animate1.Active := True;
end;

end.

