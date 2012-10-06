program Consolidation;

uses
  Forms,
  FrmMain in 'FrmMain.pas' {FormMain},
  MudUtil in '..\..\Common\MudUtil.pas',
  HUtil32 in '..\..\Common\HUtil32.pas',
  Grobal2 in '..\..\Common\Grobal2.pas',
  HumDB in '..\..\DBServer\HumDB.pas',
  IDDB in '..\..\LoginSrv\IDDB.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
