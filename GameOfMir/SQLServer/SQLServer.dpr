program SQLServer;

uses
  Forms,
  FrmMain in 'FrmMain.pas' {FormMain},
  Share in 'Share.pas',
  Common in '..\Common\Common.pas',
  EDcode in '..\Common\EDcode.pas',
  HUtil32 in '..\Common\HUtil32.pas',
  Grobal2 in '..\Common\Grobal2.pas',
  SqlMain in 'SqlMain.pas',
  MyCommon in '..\MyCommon\MyCommon.pas',
  SendEmail in 'SendEmail.pas',
  MD5Unit in '..\Common\MD5Unit.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
