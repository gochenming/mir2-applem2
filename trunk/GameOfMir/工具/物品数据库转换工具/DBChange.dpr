program DBChange;

uses
  Forms,
  FrmMain in 'FrmMain.pas' {FormMain};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'DBChange';
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
