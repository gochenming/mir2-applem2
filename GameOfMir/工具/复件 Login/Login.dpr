program Login;

uses
  Forms,
  FrmMain in 'FrmMain.pas' {FormMain},
  Share in 'Share.pas',
  FrmSetup in 'FrmSetup.pas' {FormSetup},
  LShare in '..\..\MirClient\LShare.pas',
  HUtil32 in '..\..\Common\HUtil32.pas',
  UpThread in 'UpThread.pas',
  LAShare in 'LAShare.pas',
  MD5Unit in '..\..\Common\MD5Unit.pas',
  FrmFindClient in 'FrmFindClient.pas' {FormFindClient},
  FrmRegID in 'FrmRegID.pas' {FormReg},
  DLLLoader in '..\..\Common\DLLLoader.pas',
  Common in '..\..\Common\Common.pas',
  Grobal2 in '..\..\Common\Grobal2.pas',
  EDcode in '..\..\Common\EDcode.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := False;
  Application.Title := 'ÐÂÈÈÑª´«Ææ';
  Application.CreateForm(TFormMain, FormMain);
  //Application.CreateForm(TFormReg, FormReg);
  //Application.CreateForm(TFormFindClient, FormFindClient);
  //Application.CreateForm(TFormSetup, FormSetup);
  Application.Run;
end.
