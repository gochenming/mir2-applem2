program ToolServer;

uses
  Forms,
  FrmMain in 'FrmMain.pas' {FormMain},
  SCShare in '..\Common\SCShare.pas',
  HUtil32 in '..\Common\HUtil32.pas',
  EDcode in '..\Common\EDcode.pas',
  GeneralCommon in '..\..\..\Common\GeneralCommon.pas',
  MD5Unit in '..\..\..\Common\MD5Unit.pas',
  FrmUploadList in 'FrmUploadList.pas' {FormUploadList},
  MyCommon in '..\..\..\MyCommon\MyCommon.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormMain, FormMain);
  Application.CreateForm(TFormUploadList, FormUploadList);
  Application.Run;
end.
