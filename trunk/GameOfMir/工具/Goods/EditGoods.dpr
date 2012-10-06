program EditGoods;

uses
  Forms,
  FrmMain in 'FrmMain.pas' {FormMain},
  FrmLogin in 'FrmLogin.pas' {FormLogin},
  Grobal2 in '..\..\Common\Grobal2.pas',
  Share in 'Share.pas',
  HUtil32 in '..\..\Common\HUtil32.pas',
  EDcode in '..\..\Common\EDcode.pas',
  FrmDesc in 'FrmDesc.pas' {FormDesc};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormMain, FormMain);
  Application.CreateForm(TFormDesc, FormDesc);
  Application.Run;
end.
