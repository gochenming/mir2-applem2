program GeneralGate;

uses
  Forms,
  Main in 'Main.pas' {FrmMain},
  GateShare in 'GateShare.pas',
  GeneralConfig in 'GeneralConfig.pas' {frmGeneralConfig},
  IPaddrFilter in 'IPaddrFilter.pas' {frmIPaddrFilter},
  GeneralCommon in '..\..\Common\GeneralCommon.pas',
  HUtil32 in '..\..\Common\HUtil32.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrmMain, FrmMain);
  Application.CreateForm(TfrmGeneralConfig, frmGeneralConfig);
  Application.CreateForm(TfrmIPaddrFilter, frmIPaddrFilter);
  Application.Run;
end.

