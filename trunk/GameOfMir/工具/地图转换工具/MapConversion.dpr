program MapConversion;

uses
  Forms,
  FrmMain in 'FrmMain.pas' {FormMain},
  MapShare in 'MapShare.pas',
  HUtil32 in '..\..\Common\HUtil32.pas',
  FrmEdit in 'FrmEdit.pas' {FormEdit};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'MapConversion';
  Application.CreateForm(TFormMain, FormMain);
  //Application.CreateForm(TFormEdit, FormEdit);
  Application.Run;
end.
