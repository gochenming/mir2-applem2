program RPGViewer;

uses
  Forms,
  FrmMain in 'FrmMain.pas' {FormMain},
  WIL in '..\..\..\WIL\WIL.pas',
  ZShare in 'ZShare.pas',
  wmM2Def in '..\..\..\WIL\wmM2Def.pas',
  wmM2Wis in '..\..\..\WIL\wmM2Wis.pas',
  wmMyImage in '..\..\..\WIL\wmMyImage.pas',
  wmM3Def in '..\..\..\WIL\wmM3Def.pas',
  wmWoool in '..\..\..\WIL\wmWoool.pas',
  FrmAdd in 'FrmAdd.pas' {FormAdd},
  FrmDel in 'FrmDel.pas' {FormDel},
  FrmOut in 'FrmOut.pas' {FormOut},
  FrmAlpha in 'FrmAlpha.pas' {FormAlpha},
  wm521g in '..\..\..\WIL\wm521g.pas',
  MyCommon in '..\..\..\MyCommon\MyCommon.pas',
  HUtil32 in '..\..\..\Common\HUtil32.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormMain, FormMain);
  Application.CreateForm(TFormAdd, FormAdd);
  Application.CreateForm(TFormDel, FormDel);
  Application.CreateForm(TFormOut, FormOut);
  Application.CreateForm(TFormAlpha, FormAlpha);
  Application.Run;
end.
