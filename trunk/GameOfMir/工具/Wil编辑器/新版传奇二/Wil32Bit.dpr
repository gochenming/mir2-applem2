program Wil32Bit;

uses
  Forms,
  FrmMain in 'FrmMain.pas' {FormMain},
  HUtil32 in 'HUtil32.pas',
  Share in 'Share.pas',
  FrmBatchOut in 'FrmBatchOut.pas' {FormBatchOut},
  FrmDelImg in 'FrmDelImg.pas' {FormDelImg},
  FrmAddNew in 'FrmAddNew.pas' {FormAddNew},
  FrmBatchInput in 'FrmBatchInput.pas' {FormBatchInput},
  FrmCreateWil in 'FrmCreateWil.pas' {FormCreateWil},
  FrmSetXY in 'FrmSetXY.pas' {FormSetXY},
  wmUtil in '..\..\..\MirClient\wmUtil.pas',
  WIL in '..\..\..\MirClient\WIL.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
