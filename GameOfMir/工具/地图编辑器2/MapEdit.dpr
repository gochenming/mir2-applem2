program MapEdit;

uses
  Forms,
  EdMain in 'EdMain.pas' {FrmMain},
  mpalett in 'mpalett.pas' {FrmMainPal},
  FObj in 'FObj.pas' {FrmObj},
  ObjEdit in 'ObjEdit.pas' {FrmObjEdit},
  ObjSet in 'ObjSet.pas' {FrmObjSet},
  Tile in 'Tile.pas' {FrmTile},
  MapSize in 'MapSize.pas' {FrmMapSize},
  segunit in 'segunit.pas' {FrmSegment},
  SmTile in 'SmTile.pas',
  glight in 'glight.pas' {FrmGetLight},
  DoorDlg in 'DoorDlg.pas' {FrmDoorDlg},
  hutil32 in 'hutil32.pas',
  FScrlXY in 'FScrlXY.pas' {FrmScrollMap},
  MoveObj in 'MoveObj.pas' {FrmMoveObj},
  about in 'about.pas' {Form1},
  WIL in '..\..\WIL\WIL.pas',
  wmM2Def in '..\..\WIL\wmM2Def.pas',
  wmMyImage in '..\..\WIL\wmMyImage.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'µØÍ¼±à¼­Æ÷';
  Application.CreateForm(TFrmMain, FrmMain);
  Application.CreateForm(TFrmMainPal, FrmMainPal);
  Application.CreateForm(TFrmObj, FrmObj);
  Application.CreateForm(TFrmObjEdit, FrmObjEdit);
  Application.CreateForm(TFrmObjSet, FrmObjSet);
  Application.CreateForm(TFrmTile, FrmTile);
  Application.CreateForm(TFrmMapSize, FrmMapSize);
  Application.CreateForm(TFrmSegment, FrmSegment);
  Application.CreateForm(TFrmSmTile, FrmSmTile);
  Application.CreateForm(TFrmGetLight, FrmGetLight);
  Application.CreateForm(TFrmDoorDlg, FrmDoorDlg);
  Application.CreateForm(TFrmScrollMap, FrmScrollMap);
  Application.CreateForm(TFrmMoveObj, FrmMoveObj);
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
