program Project;

uses
  Forms,
  FrmMain in 'FrmMain.pas' {FormMain},
  FrmLogin in 'FrmLogin.pas' {FormLogin},
  Share in 'Share.pas',
  SwitchDB in 'SwitchDB.pas' {FormSwitch},
  Grobal2 in '..\..\Common\Grobal2.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
