program UPClient;

uses
  Forms,
  FrmMain in 'FrmMain.pas' {FormMain},
  FrmLogin in 'FrmLogin.pas' {FormLogin},
  FrmDown in 'FrmDown.pas' {FormDown},
  SCShare in '..\Common\SCShare.pas',
  EDcode in '..\Common\EDcode.pas',
  HUtil32 in '..\Common\HUtil32.pas',
  GeneralCommon in '..\..\..\Common\GeneralCommon.pas',
  Share in 'Share.pas',
  MD5Unit in '..\..\..\Common\MD5Unit.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormMain, FormMain);
  Application.CreateForm(TFormDown, FormDown);
  Application.CreateForm(TFormLogin, FormLogin);
  Application.Run;
end.
