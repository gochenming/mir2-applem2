program GMTool;

uses
  Forms,
  FrmMain in 'FrmMain.pas' {FormMain},
  MyCommon in '..\..\MyCommon\MyCommon.pas',
  ZShare in 'ZShare.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
