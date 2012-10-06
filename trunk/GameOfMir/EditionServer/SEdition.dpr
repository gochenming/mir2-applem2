program SEdition;

uses
  Forms,
  FrmMain in 'FrmMain.pas' {FormMain},
  MD5Unit in '..\Common\MD5Unit.pas',
  Share in 'Share.pas',
  SEShare in '..\Common\SEShare.pas',
  MyCommon in '..\MyCommon\MyCommon.pas',
  HUtil32 in '..\Common\HUtil32.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
