program WEBProtect;

uses
  Forms,
  FrmMain in 'FrmMain.pas' {FormMain},
  HUtil32 in '..\..\Common\HUtil32.pas',
  MyCommon in '..\..\MyCommon\MyCommon.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
