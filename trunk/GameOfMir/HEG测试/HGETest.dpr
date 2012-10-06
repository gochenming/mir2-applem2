program HGETest;

uses
  Forms,
  FormMain in 'FormMain.pas' {FrmMain},
  HGECanvas in '..\HGEDelphi\Source\HGECanvas.pas',
  HGETextures in '..\HGEDelphi\Source\HGETextures.pas',
  HGEBase in '..\HGEDelphi\Source\HGEBase.pas',
  HGE in '..\HGEDelphi\Source\HGE.pas',
  HGEFonts in '..\HGEDelphi\Source\HGEFonts.pas',
  HGEGUI in '..\HGEDelphi\Source\HGEGUI.pas',
  WIL in '..\WIL\WIL.pas',
  HUtil32 in '..\Common\HUtil32.pas',
  wmM2Def in '..\WIL\wmM2Def.pas',
  wmMyImage in '..\WIL\wmMyImage.pas',
  wmM2Wis in '..\WIL\wmM2Wis.pas',
  D3DX81mobb in '..\HGEDelphi\Source\DirectX\D3DX81mobb.pas',
  JEDIFile in '..\HGEDelphi\Source\DirectX\JEDIFile.pas',
  DLLLoader in '..\HGEDelphi\Source\DirectX\DLLLoader.pas',
  Unit1 in 'Unit1.pas' {Form1},
  DXCommon in '..\UnDirectX\DXCommon.pas',
  DirectX in '..\UnDirectX\DirectX.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmMain, FrmMain);
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
