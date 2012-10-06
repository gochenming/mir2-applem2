program PayServer;

uses
  Forms,
  FrmMain in 'FrmMain.pas' {FormMain},
  HUtil32 in '..\..\Common\HUtil32.pas',
  MD5Unit in '..\..\Common\MD5Unit.pas',
  MyCommon in '..\..\MyCommon\MyCommon.pas',
  PayThread in 'PayThread.pas',
  Share in 'Share.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
