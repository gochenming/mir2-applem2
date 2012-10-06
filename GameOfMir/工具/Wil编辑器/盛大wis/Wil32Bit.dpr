program Wil32Bit;

uses
  Forms,
  FrmMain in 'FrmMain.pas' {FormMain},
  HUtil32 in 'HUtil32.pas',
  Share in 'Share.pas',
  FrmBatchOut in 'FrmBatchOut.pas' {FormBatchOut},
  WIL in 'WIL.pas',
  wmUtil in 'wmUtil.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
