program UPServerDB;

uses
  Forms,
  FrmMain in 'FrmMain.pas' {FormMain},
  FrmAccount in 'FrmAccount.pas' {FormAccount},
  Share in 'Share.pas',
  HUtil32 in '..\Common\HUtil32.pas',
  GeneralCommon in '..\..\..\Common\GeneralCommon.pas',
  EDcode in '..\Common\EDcode.pas',
  SCShare in '..\Common\SCShare.pas',
  MD5Unit in '..\..\..\Common\MD5Unit.pas',
  ENThread in 'ENThread.pas',
  MyCommon in '..\..\..\MyCommon\MyCommon.pas',
  DES in '..\..\..\Common\DES.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormMain, FormMain);
  Application.CreateForm(TFormAccount, FormAccount);
  Application.Run;
end.
