program NPCDesign;

uses
  Forms,
  FrmMain in 'FrmMain.pas' {FormMain},
  WMFile in '..\..\MirClient\WMFile.pas',
  HUtil32 in '..\..\Common\HUtil32.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
