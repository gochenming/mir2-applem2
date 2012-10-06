program Client;

uses
  Forms,
  FrmMain in 'FrmMain.pas' {FormMain},
  FrmHeQu in 'FrmHeQu.pas' {FrameHeQu: TFrame},
  FShare in 'FShare.pas',
  Grobal2 in '..\..\..\Common\Grobal2.pas',
  HUtil32 in '..\..\..\Common\HUtil32.pas',
  MudUtil in '..\..\..\Common\MudUtil.pas',
  HumDB in '..\..\..\DBServer\HumDB.pas',
  IDDB in '..\..\..\LoginSrv\IDDB.pas',
  FrmGoods in 'FrmGoods.pas' {FrameGoods: TFrame},
  FrmLSetup in 'FrmLSetup.pas' {FrameLSetup: TFrame},
  FrmMakeLogin in 'FrmMakeLogin.pas' {FrameMakeLogin: TFrame},
  DIB in 'DIB.pas',
  FrmLoginPreview in 'FrmLoginPreview.pas' {FormPreview},
  FrmTools in 'FrmTools.pas' {FrameTools: TFrame},
  FrmEditServer in 'FrmEditServer.pas' {FormEditServer},
  FrmEditUpData in 'FrmEditUpData.pas' {FormEditUpData},
  Share in '..\..\Login\Share.pas',
  SCShare in '..\Common\SCShare.pas',
  EDcode in '..\Common\EDcode.pas',
  FrmAddLogin in 'FrmAddLogin.pas' {FrameAddLogin: TFrame},
  FrmAddM2 in 'FrmAddM2.pas' {FrameAddM2: TFrame},
  FrmChangePass in 'FrmChangePass.pas' {FrameChangePass: TFrame},
  FrmDownM2 in 'FrmDownM2.pas' {FrameDownM2: TFrame},
  FrmDownLogin in 'FrmDownLogin.pas' {FrameDownLogin: TFrame},
  FrmBindTool in 'FrmBindTool.pas' {FrameBindTool: TFrame},
  FrmUpdate in 'FrmUpdate.pas' {FormUpdate},
  FrmRPGView in 'FrmRPGView.pas' {FrameRPGView: TFrame},
  FrmRPGDelete in 'FrmRPGDelete.pas' {FormRPGDelete},
  FrmRPGOut in 'FrmRPGOut.pas' {FormRPGOut},
  FrmRPGAppend in 'FrmRPGAppend.pas' {FormRPGAppend},
  MyCommon in '..\..\..\MyCommon\MyCommon.pas',
  MD5Unit in '..\..\..\Common\MD5Unit.pas',
  FrmShare in 'FrmShare.pas' {FrameShare: TFrame},
  wmMyImage in '..\..\..\¿Ø¼þ\WIL\wmMyImage.pas',
  WIL in '..\..\..\¿Ø¼þ\WIL\WIL.pas',
  TDX9Textures in '..\..\..\¿Ø¼þ\MyDirect9\TDX9Textures.pas',
  DES in '..\..\..\Common\DES.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := False;
  Application.CreateForm(TFormMain, FormMain);
  Application.CreateForm(TFormEditServer, FormEditServer);
  Application.CreateForm(TFormEditUpData, FormEditUpData);
  Application.CreateForm(TFormUpdate, FormUpdate);
  Application.CreateForm(TFormRPGDelete, FormRPGDelete);
  Application.CreateForm(TFormRPGOut, FormRPGOut);
  Application.CreateForm(TFormRPGAppend, FormRPGAppend);
  Application.Run;
end.
