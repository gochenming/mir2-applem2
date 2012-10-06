program NeedLevel;

uses
  Forms,
  uMain in 'uMain.pas' {MainForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'NeedLevel';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
