unit EdMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, ShlObj, ShellAPI, 
  StdCtrls, Buttons, mpalett, Menus, ExtCtrls, HUtil32, WIL, wmM2Def, wmMyImage;

const
  MAXX = 1000;
  MAXY = 1000;
  UNITX = 48;
  UNITY = 32;
  HALFX = 24;
  HALFY = 16;
  UNITBLOCK = 50;
  MIDDLEBLOCK = 60;
  SEGX = 40;
  SEGY = 40;

  LIGHTSPOT = 57;
  BKMASK = 58;
  FRMASK = 59;

  MAXSET = 300;
  MAXWIL = 40;

  TITLEHEADER = 'Legend of mir';

  XORWORD = $AA38;
  NEWMAPTITLE = 'Map 2010 Ver 1.0';

type
  TMapPrjInfo = packed record
    Ident: string[15];
    ColCount: integer;
    RowCount: integer;
  end;

  TMapDrawMode = (mdTile, mdMiddle, mdTileDetail, mdObj, mdObjSet, mdLight, mdDoor);
  TMapBrush = (mbAuto, mbNormal, mbFill, mbFillAttrib, mbAttrib, mbEraser);
  TMapInfo = record
    BkImg: word;
    MidImg: word;
    FrImg: word;
    DoorIndex: byte; //$80 (¹®Â¦), ¹®ÀÇ ½Äº° ÀÎµ¦½º
    DoorOffset: byte; //´ÝÈù ¹®ÀÇ ±×¸²ÀÇ »ó´ë À§Ä¡, $80 (¿­¸²/´ÝÈû(±âº»))
    AniFrame: byte; //$80(Åõ¸í)  ÇÁ·¡ÀÓ ¼ö
    AniTick: byte; //¸î¹ø¿¡ Æ½¸¶´Ù ÇÑ ÇÁ·¡ÀÓ¾¿ ¿òÁ÷ÀÌ´Â°¡
    Area: byte; //Object.WIL ¹øÈ£
    light: byte; //0..1..4 ±¤¿ø È¿°ú
    BKIndex: Byte;
    SMIndex: Byte;
  end;
  PTMapInfo = ^TMapInfo;

  TNewMapInfo = packed record
    BkImg: Word;
    BkImgNot: word;
    MidImg: word;
    FrImg: word;
    DoorIndex: byte;
    DoorOffset: byte;
    AniFrame: byte;
    AniTick: byte;
    Area: byte;
    light: byte;
    btNot: byte;
  end;
  PTNewMapInfo = ^TNewMapInfo;

  TMapHeader = packed record
    Width: word;
    Height: word;
    Title: string[15];
    UpdateDate: TDateTime;
    Reserved: array[0..23] of char;
  end;

  TNewMapHeader = packed record
    Title: string[16];
    Reserved: LongWord;
    Width: Word;
    Not1: Word;
    Height: Word;
    Not2: Word;
    Reserved2: array[0..24] of char;
  end;

  TFrmMain = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    New1: TMenuItem;
    Save1: TMenuItem;
    SaveAs1: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    Open1: TMenuItem;
    Palette1: TMenuItem;
    Tile1: TMenuItem;
    Object1: TMenuItem;
    Panel1: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    Label1: TLabel;
    ZoomIn: TSpeedButton;
    ZoomOut: TSpeedButton;
    LbXY: TLabel;
    ObjEdit1: TMenuItem;
    RunObjEditer1: TMenuItem;
    ObjectSet1: TMenuItem;
    LbMapName: TLabel;
    TileDetail1: TMenuItem;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    Timer1: TTimer;
    NewSegmentMap1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    ClearEditSegments1: TMenuItem;
    BtnLeftSeg: TSpeedButton;
    BtnUpSeg: TSpeedButton;
    BtnDownSeg: TSpeedButton;
    BtnRightSeg: TSpeedButton;
    SpeedButton4: TSpeedButton;
    MainScroll: TScrollBox;
    MapPaint: TPaintBox;
    Option1: TMenuItem;
    ObjectViewNormalSize1: TMenuItem;
    SpeedButton5: TSpeedButton;
    SmallTile1: TMenuItem;
    View1: TMenuItem;
    ShowBackgroundTile1: TMenuItem;
    ShowMiddleTile1: TMenuItem;
    ShowObject1: TMenuItem;
    ShowAttribMarks1: TMenuItem;
    N4: TMenuItem;
    MiddleTransparent1: TMenuItem;
    Tool1: TMenuItem;
    DrawBigTile1: TMenuItem;
    DrawObject1: TMenuItem;
    DrawObjectTileSet1: TMenuItem;
    DrawSmTile1: TMenuItem;
    SetLightEffect1: TMenuItem;
    UpdateDoor1: TMenuItem;
    Resize1: TMenuItem;
    N5: TMenuItem;
    SaveToBitmap1: TMenuItem;
    N6: TMenuItem;
    MapScroll1: TMenuItem;
    SpeedButton6: TSpeedButton;
    N7: TMenuItem;
    CellMove1: TMenuItem;
    OpenOldFormatFile1: TMenuItem;
    N8: TMenuItem;
    OldFromatBatchConvert1: TMenuItem;
    Label2: TLabel;
    N9: TMenuItem;
    N10: TMenuItem;
    ext1: TMenuItem;
    N11: TMenuItem;
    cbb1: TComboBox;
    lbl1: TLabel;
    BMP1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure Tile1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MapPaintMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MapPaintMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MapPaintMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure MapPaintPaint(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure ZoomInClick(Sender: TObject);
    procedure ZoomOutClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Object1Click(Sender: TObject);
    procedure RunObjEditer1Click(Sender: TObject);
    procedure ObjectSet1Click(Sender: TObject);
    procedure TileDetail1Click(Sender: TObject);
    procedure New1Click(Sender: TObject);
    procedure Open1Click(Sender: TObject);
    procedure SaveAs1Click(Sender: TObject);
    procedure Save1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure BtnMarkClick(Sender: TObject);
    procedure NewSegmentMap1Click(Sender: TObject);
    procedure ClearEditSegments1Click(Sender: TObject);
    procedure BtnLeftSegClick(Sender: TObject);
    procedure BtnRightSegClick(Sender: TObject);
    procedure BtnUpSegClick(Sender: TObject);
    procedure BtnDownSegClick(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure ObjectViewNormalSize1Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SmallTile1Click(Sender: TObject);
    procedure ShowBackgroundTile1Click(Sender: TObject);
    procedure DrawObject1Click(Sender: TObject);
    procedure Resize1Click(Sender: TObject);
    procedure SaveToBitmap1Click(Sender: TObject);
    procedure MapScroll1Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure CellMove1Click(Sender: TObject);
    procedure OpenOldFormatFile1Click(Sender: TObject);
    procedure OldFromatBatchConvert1Click(Sender: TObject);
    procedure N10Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure ext1Click(Sender: TObject);
    procedure N11Click(Sender: TObject);
    procedure cbb1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure BMP1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    RecusionCount: integer;
    FillIndex: integer;
    MArrUndo: array[0..MAXX + 10, 0..MAXY + 10] of TMapInfo;
    SetArr: array[0..MAXSET - 1] of TRect;
    SaveAllMap: Boolean;
    procedure ClearSetCursor;
    function DrawSetCursor(xx, yy: integer): Boolean;
    procedure DrawCursor(xx, yy: integer);
    function GetBk(x, y: integer): integer;
    function GetFrMask(x, y: integer): integer;
    function GetLightAddDoor(x, y: integer; var light, door, dooroffset: integer): Boolean;
    function GetAni(x, y: integer): integer;
    procedure SetLight(x, y, value: integer);
    function GetBkImg(x, y: integer): integer;
    function GetBkIndex(x, y: Integer): Integer;
    function GetSMIndex(x, y: Integer): Integer;
    function GetMidImg(x, y: integer): integer;
    function GetFrImg(x, y: integer): integer;
    function GetArea(x, y: Integer): Integer;
    procedure PutTileXY(x, y, idx: integer);
    procedure PutMiddleXY(x, y, idx: integer);
    function GetBkImgUnit(x, y: integer): integer;
    function GetBkUnit(x, y: integer): integer;
    procedure PutBigTileXY(x, y, idx: integer);
    procedure PutObjXY(x, y, idx: integer);
    function DrawFill(xx, yy: integer; Shift: TShiftState): Boolean;
    function DrawFillAttrib(xx, yy: integer; Shift: TShiftState): Boolean;
    procedure DrawTileDetail(x, y: integer; Shift: TShiftState);
    procedure DrawNormalTile(x, y: integer; Shift: TShiftState);
    procedure DrawAutoTile(x, y: integer; Shift: TShiftState);
    procedure DrawAutoMiddleTile(x, y: integer; Shift: TShiftState);
    procedure DrawEraser(xx, yy: integer; Shift: TShiftState);
    function CheckCollision(xx, yy: integer): Boolean;
    procedure DrawObject(xx, yy: integer; Shift: TShiftState);
    procedure DrawObjectSet(xx, yy: integer; Shift: TShiftState);
    procedure AddLight(x, y: integer);
    procedure UpdateLight(x, y: integer);
    procedure UpdateDoor(x, y: integer);
    procedure DrawCellBk(x, y, w, h: integer);
    procedure DrawCellFr(x, y, w, h: integer);
    procedure DrawXorAttrib(x, y: integer; button: TMouseButton; Shift: TShiftState);
    function IsMyUnit(x, y, munit, newidx: integer): Boolean;
    procedure DrawOne(x, y, munit, idx: integer);
    procedure DrawOneDr(x, y, munit, idx: integer);
    procedure DrawObjDr(x, y, idx: integer);
    procedure DrawOrAttr(x, y, mark: integer);
    function GetPoint(idx: integer): integer;
    function VerifyWork: Boolean;
    procedure LoadSegment(col, row: integer; flname: string);
    procedure SaveSegment(col, row: integer; flname: string);
    procedure WMDropFiles(var Msg: TWMDropFiles); message WM_DROPFILES;
  public
    MArr: array[0..MAXX + 10, 0..MAXY + 10] of TMapInfo;
    NMArr: array[0..MAXX + 10, 0..MAXY + 10] of TNewMapInfo;
    MapWidth, MapHeight: integer;
    CurX, CurY: integer;
    MainBrush: TMapBrush;
    ImageIndex, ImageDetail: integer;
    MiddleIndex: integer;
    TileAttrib: integer;
    DrawMode: TMapDrawMode;
    Zoom: Real;
    BoxVisible: Boolean;
    BoxX, BoxY, BoxWidth, BoxHeight: integer;
    CurrentMapName: string;
    Edited: Boolean;
    SegmentMode: Boolean;
    WilTiles: array[0..1] of TWMImages;
    WilSmTiles: array[0..1] of TWMImages;
    DefMainPalette: TRgbQuads;
    function ObjWil(idx: integer): TWMImages;
    procedure CopyTemp;
    procedure Undo;
    procedure NewMap;
    function LoadFromFile(flname: string): Boolean;
    function LoadFromFileByNew(flname: string): Boolean;
    function SaveToFile(flname: string): Boolean;
    procedure MakeSetCursor(plist: TList);
    procedure DoEditSegment;
    procedure DoSaveSegments;
  end;

var
  FrmMain: TFrmMain;
  BaseDir: string;

  WilArr: array[0..39] of TWMImages;
  WilCount: Integer;
implementation

uses FObj, ObjEdit, ObjSet, Tile, MapSize, segunit, SmTile, glight, DoorDlg,
  FScrlXY, MoveObj, jpeg, about;

{$R *.DFM}
{$R ColorTable.RES}

procedure TFrmMain.FormCreate(Sender: TObject);
var
  i: integer;
  Res: TResourceStream;
begin
  DragAcceptFiles(Handle, True);
  Res := TResourceStream.Create(Hinstance, '256RGB', 'RGB');
  try
    Res.Read(DefMainPalette, SizeOf(DefMainPalette));
  finally
    Res.Free;
  end;
  SaveAllMap := False;
  Zoom := 0.4;
  Label1.Caption := '100:' + IntToStr(Round(100 * Zoom));
  ImageIndex := 0;
  ImageDetail := 0;
  BoxVisible := FALSE;
  BoxX := 0;
  BoxY := 0;
  BoxWidth := 1;
  BoxHeight := 1;
  DrawMode := mdTile;
  CurrentMapName := '';
  Edited := FALSE;
  SegmentMode := FALSE;
  MapWidth := 200;
  MapHeight := 200;
  BaseDir := GetCurrentDir;

  ShowBackgroundTile1.Checked := TRUE;
  ShowMiddleTile1.Checked := TRUE;
  ShowObject1.Checked := TRUE;
  ShowAttribMarks1.Checked := FALSE;
  MiddleTransparent1.Checked := TRUE;

  {WilTiles.Initialize;
  WilSmTiles.Initialize;
  WilObjects1.Initialize;
  WilObjects2.Initialize;
  WilObjects3.Initialize;
  WilObjects4.Initialize;
  WilObjects5.Initialize;
  WilObjects6.Initialize;
  WilObjects7.Initialize;
  WilObjects8.Initialize;  }

  WilTiles[0] := TWMM2DefImages.Create;
  WilTiles[0].LibType := ltLoadBmp;
  WilTiles[0].FileName := 'Tiles.wil';
  WilTiles[0].m_DefMainPalette := DefMainPalette;
  WilTiles[0].Initialize;

  WilTiles[1] := TWMM2DefImages.Create;
  WilTiles[1].LibType := ltLoadBmp;
  WilTiles[1].FileName := 'Tiles2.wil';
  WilTiles[1].m_DefMainPalette := DefMainPalette;
  WilTiles[1].Initialize;

  WilSmTiles[0] := TWMM2DefImages.Create;
  WilSmTiles[0].LibType := ltLoadBmp;
  WilSmTiles[0].FileName := 'SmTiles2.wil';
  WilSmTiles[0].m_DefMainPalette := DefMainPalette;
  WilSmTiles[0].Initialize;

  WilSmTiles[1] := TWMM2DefImages.Create;
  WilSmTiles[1].LibType := ltLoadBmp;
  WilSmTiles[1].FileName := 'SmTiles2.wil';
  WilSmTiles[1].m_DefMainPalette := DefMainPalette;
  WilSmTiles[1].Initialize;
  {  WilObjects9.Initialize;
    WilObjects10.Initialize;
    WilObjects11.Initialize;
    WilObjects12.Initialize;
    WilObjects13.Initialize;
    WilObjects14.Initialize;
    WilObjects15.Initialize;
   }
  WilCount := 0;
  for i := 0 to 39 do begin
    {if FileExists('objects'+Inttostr(i+1)+'.wil') then
    Begin  }
    case i of
      0: begin
          WilArr[i] := TWMM2DefImages.Create;
          WilArr[i].LibType := ltLoadBmp;
          WilArr[i].FileName := 'Objects.wil';
          WilArr[i].m_DefMainPalette := DefMainPalette;
          WilArr[i].Initialize;
          inc(WilCount);
        end;
      1..29: begin
          WilArr[i] := TWMM2DefImages.Create;
          WilArr[i].LibType := ltLoadBmp;
          WilArr[i].FileName := 'Objects' + Inttostr(i + 1) + '.wil';
          WilArr[i].m_DefMainPalette := DefMainPalette;
          WilArr[i].Initialize;
          inc(WilCount);
        end;
      30..39: begin
          WilArr[i] := TWMMyImageImages.Create;
          WilArr[i].LibType := ltLoadBmp;
          WilArr[i].FileName := '..\Resource\Data\Objects' + Inttostr(i - 29) + '.pak';
          WilArr[i].Initialize;
          inc(WilCount);
        end;
    end;
  end;
  NewMap;
end;

procedure TFrmMain.FormDestroy(Sender: TObject);
begin
  DragFinish(Handle);
end;

procedure TFrmMain.FormShow(Sender: TObject);
begin
  SpeedButton2Click(self);
  FrmMainPal.SetImageUnitCount((WilTiles[0].ImageCount + UNITBLOCK - 1) div UNITBLOCK);
  FrmSmTile.SetImageUnitCount((WilSmTiles[0].ImageCount + MIDDLEBLOCK - 1) div MIDDLEBLOCK);
  FrmObjSet.InitializeObjSet;
  //   FrmMainPal.Show;
  //   FrmObjSet.Execute;
end;

procedure TFrmMain.NewMap;
begin
  LbMapName.Caption := 'Untitled.map';
  if MapWidth < 0 then
    MapWidth := 1;
  if MapHeight < 0 then
    MapHeight := 1;
  FillChar(MArr, sizeof(MArr), #0);
  FillChar(MArrUndo, sizeof(MArrUndo), #0);
  MapPaint.Width := Round(MapWidth * UNITX * Zoom) + 1;
  MapPaint.Height := Round(MapHeight * UNITY * Zoom) + 1;
  CurX := 0;
  CurY := 0;
end;

function TFrmMain.LoadFromFileByNew(flname: string): Boolean;
var
  i, j, fhandle: integer;
  header: TMapHeader;
  Nheader: TNewMapHeader;
  NewMapInfo: TNewMapInfo;

  //TNewMapInfo:TNewMapInfo
  //str: string;
begin
  Result := FALSE;
  if not FileExists(flname) then
    exit;
  fhandle := FileOpen(flname, fmOpenReadWrite or fmShareDenyNone);
  if fhandle > 0 then begin
    FillChar(MArr, sizeof(MArr), #0);
    FillChar(NMArr, sizeof(NMArr), #0);
    FillChar(MArrUndo, sizeof(MArrUndo), #0);
    FileRead(fhandle, Nheader, sizeof(TNewMapHeader));

    //str := Datetimetostr(Header.UpdateDate);
    //if header.Title = TITLEHEADER then begin
    //ShowMessage(NHeader.Title);
    //exit;
    if (Nheader.Width > 0) and (Nheader.Height > 0) then begin
      header.Width := Nheader.Width xor $AA38;
      header.Height := Nheader.Height xor $AA38;
      //ShowMessage(Format('%d/%d', [header.Width, header.Height]));
      //exit;
      MapWidth := header.Width;
      MapHeight := header.Height;
      for i := 0 to MapWidth - 1 do
        FileRead(fhandle, NMArr[i, 0], sizeof(TNewMapInfo) * MapHeight);

      for j := 0 to MapHeight - 1 do
        for i := 0 to MapWidth - 1 do begin
          MArr[i, j].BkImg := NMArr[i, j].BkImg xor $AA38;
          //MArr[i, j].BkImg := MArr[i, j].BkImg or (NMArr[i, j].BkImgNot xor $AA38);
          if (NMArr[i, j].BkImgNot xor $AA38) = $2000 then
            MArr[i, j].BkImg := MArr[i, j].BkImg or $8000;

          MArr[i, j].MidImg := NMArr[i, j].MidImg xor $AA38;

          MArr[i, j].FrImg := NMArr[i, j].FrImg xor $AA38;
          MArr[i, j].DoorIndex := NMArr[i, j].DoorIndex;
          MArr[i, j].DoorOffset := NMArr[i, j].DoorOffset;
          MArr[i, j].AniFrame := NMArr[i, j].AniFrame;
          MArr[i, j].AniTick := NMArr[i, j].AniTick;
          MArr[i, j].Area := NMArr[i, j].Area;
          MArr[i, j].light := NMArr[i, j].light;
        end;
      Result := TRUE;
    end;
    //end;
    FileClose(fhandle);
  end;
end;

function TFrmMain.LoadFromFile(flname: string): Boolean;
{var
  i, fhandle: integer;
  header: TMapHeader;
  str: string;  }
var
  sFileName: string;
  aMapFile: TFileStream;
  ENMapHeader: TNewMapHeader;
  boENMap: Boolean;
  ENMapData: array of array of TNewMapInfo;
  I, j: Integer;
  header: TMapHeader;
begin
  Result := False;
  if not FileExists(flname) then exit;
  aMapFile := TFileStream.Create(flname, fmOpenRead or fmShareDenyNone);
  try
    aMapFile.Read(ENMapHeader, Sizeof(TNewMapHeader));
    boENMap := (ENMapHeader.Title = NEWMAPTITLE);
    if boENMap then begin
      header.Width := ENMapHeader.Width xor XORWORD;
      header.Height := ENMapHeader.Height xor XORWORD;
    end
    else begin
      Move(ENMapHeader, header, SizeOf(header));
      aMapFile.Seek(SizeOf(header), 0);
    end;
    MapWidth := header.Width;
    MapHeight := header.Height;
    if (MapWidth <= 1000) and (MapHeight <= 1000) then begin
      FillChar(MArr, sizeof(MArr), #0);
      FillChar(MArrUndo, sizeof(MArrUndo), #0);
      if boENMap then begin
        SetLength(ENMapData, MapWidth, MapHeight);
        for i := 0 to MapWidth - 1 do begin
          aMapFile.Read(ENMapData[i, 0], SizeOf(TNewMapInfo) * MapHeight);
          for j := 0 to MapHeight - 1 do begin
            MArr[i, j].BkImg := ENMapData[i, j].BkImg xor XORWORD;
            if (ENMapData[i, j].BkImgNot xor $AA38) = $2000 then
              MArr[i, j].BkImg := MArr[i, j].BkImg or $8000;
            MArr[i, j].MidImg := ENMapData[i, j].MidImg xor XORWORD;
            MArr[i, j].FrImg := ENMapData[i, j].FrImg xor XORWORD;
            MArr[i, j].DoorIndex := ENMapData[i, j].DoorIndex;
            MArr[i, j].DoorOffset := ENMapData[i, j].DoorOffset;
            MArr[i, j].AniFrame := ENMapData[i, j].AniFrame;
            MArr[i, j].AniTick := ENMapData[i, j].AniTick;
            MArr[i, j].Area := ENMapData[i, j].Area;
            MArr[i, j].light := ENMapData[i, j].light;
          end;
        end;
        ENMapData := nil;
      end
      else begin
        for i := 0 to MapWidth - 1 do
          aMapFile.Read(MArr[i, 0], sizeof(TMapInfo) * MapHeight);
      end;
      Result := True;
    end;
  finally
    aMapFile.Free;
  end;
end;

function TFrmMain.ObjWil(idx: integer): TWMImages;
begin
  Result := WilArr[0];
  case (idx div 65535) of
    {0: Result := WilObjects1;
    1: Result := WilObjects2;
    2: Result := WilObjects3;
    3: Result := WilObjects4;
    4: Result := WilObjects5;
    5: Result := WilObjects6;
    6: Result := WilObjects7;
    7: Result := WilObjects8;  }
    0..39:
      Result := WilArr[(idx div 65535)];

  end;
end;

procedure TFrmMain.CopyTemp;
begin
  Move(MArr, MArrUndo, sizeof(MArr));
end;

procedure TFrmMain.Undo;
begin
  Move(MArrUndo, MArr, sizeof(MArr));
  MapPaint.Refresh;
end;

function TFrmMain.SaveToFile(flname: string): Boolean;
var
  FileStream: TFileStream;
  ENMapHeader: TNewMapHeader;
  ENMapData: array of array of TNewMapInfo;
  I, j: Integer;
  btDoorOffset: Byte;
begin
  Result := True;
  if not FileExists(flname) then
    FileStream := TFileStream.Create(flname, fmCreate)
  else
    FileStream := TFileStream.Create(flname, fmOpenWrite or fmShareDenyNone);
  try
    ENMapHeader.Title := NEWMAPTITLE;
    ENMapHeader.Width := MapWidth xor XORWORD;
    ENMapHeader.Height := MapHeight xor XORWORD;
    FileStream.Write(ENMapHeader, SizeOf(ENMapHeader));
    SetLength(ENMapData, MapWidth, MapHeight);
    FillChar(ENMapData[0, 0], MapWidth * MapHeight * SizeOf(TNewMapInfo), #0);
    for i := 0 to MapWidth - 1 do begin
      for j := 0 to MapHeight - 1 do begin
        if (MArr[i, j].BkImg and $8000) <> 0 then begin
          ENMapData[i, j].BkImgNot := $2000 xor XORWORD;
        end;
        ENMapData[i, j].BkImg := (MArr[i, j].BkImg and $7FFF) xor XORWORD;
        ENMapData[i, j].MidImg := MArr[i, j].MidImg xor XORWORD;
        ENMapData[i, j].FrImg := MArr[i, j].FrImg xor XORWORD;
        ENMapData[i, j].DoorIndex := MArr[i, j].DoorIndex;
        ENMapData[i, j].DoorOffset := MArr[i, j].DoorOffset;
        ENMapData[i, j].AniFrame := MArr[i, j].AniFrame;
        ENMapData[i, j].AniTick := MArr[i, j].AniTick;
        ENMapData[i, j].Area := MArr[i, j].Area;
        ENMapData[i, j].light := MArr[i, j].light;
      end;
      FileStream.Write(ENMapData[i, 0], SizeOf(TNewMapInfo) * MapHeight);
    end;
    ENMapData := nil;
  finally
    FileStream.Free;
  end;
end;

procedure TFrmMain.ClearSetCursor;
var
  i: integer;
begin
  for i := 0 to MAXSET - 1 do begin
    SetArr[i].Left := 0;
    SetArr[i].Top := 0;
    SetArr[i].Right := 0;
    SetArr[i].Bottom := 0;
  end;
end;

procedure TFrmMain.MakeSetCursor(plist: TList);
var
  i, n: integer;
  p: PTPieceInfo;
begin
  ClearSetCursor;
  if plist <> nil then begin
    n := 0;
    for i := 0 to plist.Count - 1 do begin
      p := PTPieceInfo(plist[i]);
      if p.Img >= 0 then begin
        SetArr[n].Left := p.rx;
        SetArr[n].Top := p.ry;
        SetArr[n].Right := p.rx + 1;
        SetArr[n].Bottom := p.ry + 1;
        Inc(n);
      end;
    end;
  end;
end;

function TFrmMain.DrawSetCursor(xx, yy: integer): Boolean;
var
  i: integer;
begin
  if SetArr[0].Left <> SetArr[0].Right then begin
    for i := 0 to MAXSET - 1 do begin
      if SetArr[i].Left <> SetArr[i].Right then begin
        MapPaint.Canvas.DrawFocusRect(
          Rect(xx + SetArr[i].Left * Round(UNITX * Zoom),
          yy + SetArr[i].Top * Round(UNITY * Zoom),
          xx + SetArr[i].Left * Round(UNITX * Zoom) + Round(BoxWidth * UNITX * Zoom),
          yy + SetArr[i].Top * Round(UNITY * Zoom) + Round(BoxHeight * UNITY * Zoom)));
      end
      else
        break;
    end;
    Result := TRUE;
  end
  else
    Result := FALSE;
end;

procedure TFrmMain.DrawCursor(xx, yy: integer);
begin
  xx := Trunc(xx * UNITX * Zoom);
  yy := Trunc(yy * UNITY * Zoom);
  if MainBrush <> mbEraser then begin
    if DrawMode = mdObjSet then begin
      if DrawSetCursor(xx, yy) then
        exit;
    end;
  end;
  MapPaint.Canvas.DrawFocusRect(
    Rect(xx,
    yy,
    xx + Round(UNITX * Zoom),
    yy + Round(UNITY * Zoom)));
end;

procedure TFrmMain.MapPaintMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  xx, yy, n: integer;
begin
  if BoxVisible then begin
    DrawCursor(BoxX, BoxY);
    BoxVisible := FALSE;
  end;
  xx := Trunc(word(X) / UNITX / Zoom);
  yy := Trunc(word(Y) / UNITY / Zoom);
  //MArr[xx, yy].FrImg := 0;
  //lbl1.Caption := Format('B:%d  M:%d  F:%d  B:%d  BN:%d M:%d  F:%d', [MArr[xx, yy].BkImg, MArr[xx, yy].MidImg, MArr[xx, yy].FrImg, NMArr[xx, yy].BkImg, NMArr[xx, yy].BkImgNot, NMArr[xx, yy].MidImg, NMArr[xx, yy].FrImg]);
  //exit;
  if MainBrush = mbEraser then begin
    DrawEraser(xx, yy, Shift);
    exit;
  end;
  if MainBrush = mbAttrib then begin
    DrawXorAttrib(xx, yy, Button, Shift);
    exit;
  end;
  if (DrawMode = mdTile) and (MainBrush = mbFillAttrib) then begin
    RecusionCount := 0;
    CopyTemp;
    DrawFillAttrib(xx, yy, Shift);
    Edited := TRUE;
  end;
  if mbLeft = Button then begin
    case DrawMode of
      mdTile:
        case MainBrush of
          mbAuto: begin
              xx := xx div 4 * 4;
              yy := yy div 4 * 4;
              CopyTemp;
              DrawAutoTile(xx, yy, Shift);
              Edited := TRUE;
            end;
          mbNormal: begin
              CopyTemp;
              DrawTileDetail(xx, yy, Shift);
              //DrawNormalTile (xx, yy, Shift);
              Edited := TRUE;
            end;
          mbFill: begin
              xx := xx div 2 * 2;
              yy := yy div 2 * 2;
              RecusionCount := 0;
              n := GetBkImg(xx, yy);
              if n >= 0 then
                FillIndex := n div UNITBLOCK
              else
                FillIndex := -1;
              CopyTemp;
              DrawFill(xx, yy, Shift);
              Edited := TRUE;
            end;
        end;
      mdMiddle:
        case MainBrush of
          mbAuto: begin
              CopyTemp;
              DrawAutoMiddleTile(xx, yy, Shift);
              Edited := TRUE;
            end;
        end;
      mdTileDetail: begin
          //CopyTemp;
          //DrawTileDetail (xx, yy, Shift);
          //Edited := TRUE;
        end;
      mdObj: begin
          CopyTemp;
          DrawObject(xx, yy, Shift);
          Edited := TRUE;
        end;
      mdObjSet: begin
          CopyTemp;
          DrawObjectSet(xx, yy, Shift);
          Edited := TRUE;
        end;
      mdLight: begin
          CopyTemp;
          if ssAlt in Shift then
            UpdateLight(xx, yy)
          else
            AddLight(xx, yy);
          Edited := TRUE;
        end;
      mdDoor: begin
          CopyTemp;
          UpdateDoor(xx, yy);
          Edited := TRUE;
        end;
    end;
  end;
end;

procedure TFrmMain.MapPaintMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  ;
end;

procedure TFrmMain.MapPaintMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  xx, yy: integer;
  button: TMouseButton;
begin
  if BoxVisible then begin
    DrawCursor(BoxX, BoxY);
    BoxVisible := FALSE;
  end;
  xx := Trunc(word(X) / UNITX / Zoom);
  yy := Trunc(word(Y) / UNITY / Zoom);

  if MainBrush = mbAttrib then begin
    button := mbMiddle;
    if ssLeft in Shift then
      button := mbLeft;
    if ssRight in Shift then
      button := mbRight;
    DrawXorAttrib(xx, yy, Button, Shift);
    exit;
  end;
  if MainBrush = mbEraser then begin
    if ssLeft in Shift then
      DrawEraser(xx, yy, Shift);
  end
  else begin
    case DrawMode of
      mdTile:
        case MainBrush of
          mbAuto: begin
              xx := xx div 4 * 4;
              yy := yy div 4 * 4;
              if (ssLeft in Shift) and (ssCtrl in Shift) then
                MapPaintMouseDown(self, mbLeft, Shift, X, Y);
            end;
          mbNormal: begin
              if (ssLeft in Shift) and ((ssCtrl in Shift) or (ssAlt in Shift)) then
                MapPaintMouseDown(self, mbLeft, Shift, X, Y);
            end;
          mbFill: begin

            end;
        end;
      mdMiddle:
        case MainBrush of
          mbAuto: begin
              if (ssLeft in Shift) and (ssCtrl in Shift) then begin
                CopyTemp;
                DrawAutoMiddleTile(xx, yy, Shift);
                Edited := TRUE;
              end;
            end;
        end;
      mdTileDetail:
        ;
      mdObjSet:
        ;
      mdObj:
        ;
    end;
  end;

  if Segmentmode then begin
    LbXY.Caption := IntToStr(xx + FrmSegment.Offsx) + ' : ' + IntToStr(yy + FrmSegment.OffsY);
    lbl1.Caption := Format('%d/%d', [MArr[xx + FrmSegment.Offsx,yy + FrmSegment.OffsY].BKIndex, MArr[xx + FrmSegment.Offsx,yy + FrmSegment.OffsY].SMIndex]);
    //Label3.Caption:=inttostr(MArr[xx + FrmSegment.Offsx,yy + FrmSegment.OffsY].Area)+'('+inttostr(MArr[xx + FrmSegment.Offsx,yy + FrmSegment.OffsY].FrImg mod $7fff)+')';
  end
  else begin
    LbXY.Caption := IntToStr(xx) + ' : ' + IntToStr(yy);
    //Label3.Caption:=inttostr(MArr[xx ,yy ].Area)+'('+inttostr(MArr[xx,yy ].FrImg mod $7fff)+')'+inttostr(MArr[xx ,yy ].Area)+'('+inttostr(MArr[xx,yy ].BkImg mod $7fff)+')'+inttostr(MArr[xx ,yy ].Area)+'('+inttostr(MArr[xx,yy ].MidImg )+')'+'Light:('+Inttostr(MArr[xx,yy ].light)+')'+'AniFrame:('+Inttostr(MArr[xx,yy ].AniFrame)+')'+'AniTick:('+Inttostr(MArr[xx,yy ].AniTick)+')';
    lbl1.Caption := Format('%d/%d', [MArr[xx + FrmSegment.Offsx,yy + FrmSegment.OffsY].BKIndex, MArr[xx + FrmSegment.Offsx,yy + FrmSegment.OffsY].SMIndex]);
  end;
  if not BoxVisible then begin
    BoxX := xx;
    BoxY := yy;
    DrawCursor(BoxX, BoxY);
    BoxVisible := TRUE;
  end;
end;

function TFrmMain.GetFrMask(x, y: integer): integer;
begin
  Result := 0;
  if (x >= 0) and (x < MAXX - 1) and (y >= 0) and (y < MAXY - 1) then begin
    Result := (MArr[x, y].FrImg and $8000);
  end;
end;

function TFrmMain.GetLightAddDoor(x, y: integer; var light, door, dooroffset: integer): Boolean;
begin
  Result := FALSE;
  if (x >= 0) and (x < MAXX - 1) and (y >= 0) and (y < MAXY - 1) then begin
    light := MArr[x, y].Light;
    door := MArr[x, y].DoorIndex;
    dooroffset := MArr[x, y].DoorOffset;
    Result := TRUE;
  end;
end;

function TFrmMain.GetAni(x, y: integer): integer;
begin
  if (x >= 0) and (x < MAXX - 1) and (y >= 0) and (y < MAXY - 1) then begin
    Result := ($7F and MArr[x, y].AniFrame);
  end;
end;

function TFrmMain.GetArea(x, y: Integer): Integer;
begin
  if (x >= 0) and (x < MAXX - 1) and (y >= 0) and (y < MAXY - 1) then begin
    Result := MArr[x, y].Area;
  end;
end;

procedure TFrmMain.SetLight(x, y, value: integer);
begin

  if (x >= 0) and (x < MAXX - 1) and (y >= 0) and (y < MAXY - 1) then begin
    MArr[x, y].Light := value;
  end;
end;

function TFrmMain.GetBk(x, y: integer): integer;
begin
  if (x >= 0) and (x < MAXX - 1) and (y >= 0) and (y < MAXY - 1) then begin
    Result := MArr[x, y].BkImg;
  end;
end;

function TFrmMain.GetFrImg(x, y: integer): integer;
begin
  if (x >= 0) and (x < MAXX - 1) and (y >= 0) and (y < MAXY - 1) then begin
    Result := MArr[x, y].Area * 65535 + (MArr[x, y].FrImg and $7FFF) - 1;
    //Result := (MArr[x, y].FrImg and $7FFF) - 1;
      {if MArr[x, y].Area = 8 then
        Result := MArr[x, y].Area * 65535 + (MArr[x, y].FrImg and $7FFF) - 1
      else
        Result := MArr[x, y].Area * 65535 + (MArr[x, y].FrImg and $7FFF) - 1; }

  end;
end;

function TFrmMain.GetSMIndex(x, y: Integer): Integer;
begin
  Result := 0;
  if (x >= 0) and (x < MAXX - 1) and (y >= 0) and (y < MAXY - 1) then begin
    if (MArr[x, y].SMIndex in [Low(WilSmTiles)..High(WilSmTiles)]) then Result := MArr[x, y].SMIndex
    else Result := 0;
  end;
end;

function TFrmMain.GetBkIndex(x, y: Integer): Integer;
begin
  Result := 0;
  if (x >= 0) and (x < MAXX - 1) and (y >= 0) and (y < MAXY - 1) then begin
    if (MArr[x, y].BKIndex in [Low(WilTiles)..High(WilTiles)]) then Result := MArr[x, y].BKIndex
    else Result := 0;
  end;
end;

function TFrmMain.GetBkImg(x, y: integer): integer;
begin
  if (x >= 0) and (x < MAXX - 1) and (y >= 0) and (y < MAXY - 1) then begin
    Result := (MArr[x, y].BkImg and $7FFF) - 1;
  end;
end;

function TFrmMain.GetMidImg(x, y: integer): integer;
begin
  if (x >= 0) and (x < MAXX - 1) and (y >= 0) and (y < MAXY - 1) then begin
    Result := MArr[x, y].MidImg - 1;
  end;
end;

procedure TFrmMain.PutTileXY(x, y, idx: integer);
var
  bimg: integer;
begin
  if (x >= 0) and (x < MAXX) and (y >= 0) and (y < MAXY) then begin
    //if TileAttrib = 0 then bimg := idx
    //else bimg := $8000 or idx;
    bimg := (MArr[x, y].BkImg and $8000) + idx;
    MArr[x, y].BkImg := bimg;
  end;
end;

procedure TFrmMain.PutMiddleXY(x, y, idx: integer);
begin
  if (x >= 0) and (x < MAXX) and (y >= 0) and (y < MAXY) then begin
    MArr[x, y].MidImg := idx;
  end;
end;

function TFrmMain.GetBkImgUnit(x, y: integer): integer;
begin
  if (x >= 0) and (x < MAXX - 1) and (y >= 0) and (y < MAXY - 1) then begin
    Result := ((MArr[x, y].BkImg and $7FFF) - 1) mod UNITBLOCK;
  end;
end;

function TFrmMain.GetBkUnit(x, y: integer): integer;
begin
  if (x >= 0) and (x < MAXX - 1) and (y >= 0) and (y < MAXY - 1) then begin
    Result := ((MArr[x, y].BkImg and $7FFF) - 1) div UNITBLOCK;
  end;
end;

procedure TFrmMain.PutBigTileXY(x, y, idx: integer);
var
  bimg: integer;
begin
  if (x >= 0) and (x < MAXX - 1) and (y >= 0) and (y < MAXY - 1) then begin
    //if TileAttrib = 0 then bimg := idx
    //else bimg := $8000 or idx;
    bimg := (MArr[x, y].BkImg and $8000) + idx;
    MArr[x, y].BkImg := bimg;
    bimg := (MArr[x + 1, y].BkImg and $8000) + idx;
    MArr[x + 1, y].BkImg := bimg;
    bimg := (MArr[x, y + 1].BkImg and $8000) + idx;
    MArr[x, y + 1].BkImg := bimg;
    bimg := (MArr[x + 1, y + 1].BkImg and $8000) + idx;
    MArr[x + 1, y + 1].BkImg := bimg;
  end;
end;

procedure TFrmMain.PutObjXY(x, y, idx: integer);
var
  bimg: integer;
begin
  if (x >= 0) and (x < MAXX - 1) and (y >= 0) and (y < MAXY - 1) then begin
    bimg := (MArr[x, y].FrImg and $8000) + idx mod 65535;
    MArr[x, y].FrImg := bimg;
    MArr[x, y].Area := idx div 65535;
  end;
end;

function TFrmMain.DrawFill(xx, yy: integer; Shift: TShiftState): Boolean;
var
  img, idx, un, drimg: integer;
begin
  Result := False;
  if {(RecusionCount < 200000) and }(xx >= 0) and (yy >= 0) and (xx < MapWidth) and (yy < MapHeight) then begin
    Inc(RecusionCount);
    img := GetBkImg(xx, yy);
    idx := img mod UNITBLOCK;
    if img >= 0 then
      un := img div UNITBLOCK
    else
      un := -1;
    if (un = FillIndex) and (((idx >= 0) and (idx < 5)) or (idx = 99) or (idx = -1)) then begin
      if un <> ImageIndex then begin
        DrawOneDr(xx, yy, ImageIndex, Random(5));
        DrawFill(xx - 2, yy, Shift);
        DrawFill(xx, yy - 2, Shift);
        DrawFill(xx + 2, yy, Shift);
        DrawFill(xx, yy + 2, Shift);
      end
      else begin
        Dec(RecusionCount);
        exit;
      end;
    end;
  end
  else begin
    Dec(RecusionCount);
    exit;
  end;
end;

function TFrmMain.DrawFillAttrib(xx, yy: integer; Shift: TShiftState): Boolean;
var
  img, idx, un, drimg, attr: integer;
begin
  attr := 0;
  if (RecusionCount < 65535) and (xx >= 0) and (yy >= 0) and (xx < MapWidth) and (yy < MapHeight) then begin
    Inc(RecusionCount);
    if ssLeft in Shift then
      attr := MArr[xx, yy].BkImg and $8000;
    if ssRight in Shift then
      attr := MArr[xx, yy].FrImg and $8000;
    if (attr = 0) then begin
      if ssLeft in Shift then
        MArr[xx, yy].BkImg := MArr[xx, yy].BkImg or $8000;
      if ssRight in Shift then
        MArr[xx, yy].FrImg := MArr[xx, yy].FrImg or $8000;
      DrawFillAttrib(xx - 1, yy, Shift);
      DrawFillAttrib(xx, yy - 1, Shift);
      DrawFillAttrib(xx + 1, yy, Shift);
      DrawFillAttrib(xx, yy + 1, Shift);
    end
    else begin
      Dec(RecusionCount);
      exit;
    end;
  end
  else begin
    Dec(RecusionCount);
    exit;
  end;
end;

procedure TFrmMain.DrawEraser(xx, yy: integer; Shift: TShiftState);
var
  i, j, n: integer;
begin
  n := 0;
  if ssCtrl in Shift then
    n := 1;
  if ssShift in Shift then
    n := 10;
  if n > 0 then begin
    for i := xx - n to xx + n do
      for j := yy - n to yy + n do begin
        //MArr[i, j].BkImg := 0; //MArr[i, j].BkImg and $7FFF;
        if ssAlt in Shift then
          MArr[i, j].MidImg := 0
        else
          MArr[i, j].FrImg := 0;
        if ssCtrl in Shift then
          MArr[i, j].BkImg := MArr[i, j].BkImg and $7FFF;
        MArr[i, j].AniFrame := 0;
        MArr[i, j].AniTick := 0;
        MArr[i, j].DoorIndex := 0;
        MArr[i, j].DoorOffset := 0;
      end;
  end
  else begin
    //MArr[xx, yy].BkImg := 0; //MArr[xx, yy].BkImg and $7FFF;
    if ssAlt in Shift then
      MArr[xx, yy].MidImg := 0
    else
      MArr[xx, yy].FrImg := 0;
    MArr[xx, yy].AniFrame := 0;
    MArr[xx, yy].AniTick := 0;
    MArr[xx, yy].DoorIndex := 0;
    MArr[xx, yy].DoorOffset := 0;
  end;
end;

procedure TFrmMain.DrawObject(xx, yy: integer; Shift: TShiftState);
var
  idx: integer;
begin
  if ssAlt in Shift then begin
    DrawObjDr(xx, yy, -1);
  end
  else begin
    idx := FrmObj.GetCurrentIndex;
    if idx >= 0 then begin
      if ssCtrl in Shift then begin
        DrawObjDr(xx, yy, idx xor $8000);
      end
      else begin
        DrawObjDr(xx, yy, idx);
      end;
    end;
  end;
end;

function TFrmMain.CheckCollision(xx, yy: integer): Boolean;
var
  n: integer;
begin
  if (xx >= 0) and (xx < MAXX - 1) and (yy >= 0) and (yy < MAXY - 1) then begin
    n := MArr[xx, yy].FrImg and $7FFF;
    if n > 0 then
      Result := TRUE
    else
      Result := FALSE;
  end
  else
    Result := FALSE;
end;

procedure TFrmMain.DrawObjectSet(xx, yy: integer; Shift: TShiftState);
var
  i, ix, iy: integer;
  plist: TList;
  p: PTPieceInfo;
  flag: Boolean;
begin
  flag := TRUE;
  plist := FrmObjSet.GetCurrentSet;
  if plist <> nil then begin
    for i := 0 to plist.Count - 1 do begin
      p := PTPieceInfo(plist[i]);
      if p.img >= 0 then
        if CheckCollision(xx + p.rx, yy + p.ry) then begin
          flag := FALSE;
          break;
        end;
    end;
    if flag then begin
      for i := 0 to plist.Count - 1 do begin
        p := PTPieceInfo(plist[i]);
        if (p.rx + xx >= 0) and (p.ry + yy >= 0) then begin
          if p.bkimg >= 0 then begin
            ix := xx div 2 * 2;
            iy := yy div 2 * 2;
            MArr[p.rx + ix, p.ry + iy].BkImg := p.bkimg + 1;
            DrawCellBk(p.rx + ix, p.ry + iy, 1, 1);
          end;
          if p.img >= 0 then
            DrawObjDr(xx + p.rx, yy + p.ry, p.img);
          if p.mark > 0 then
            DrawORAttr(xx + p.rx, yy + p.ry, p.mark);
          if p.Blend then
            MArr[xx + p.rx, yy + p.ry].AniFrame := $80 or p.AniFrame
          else
            MArr[xx + p.rx, yy + p.ry].AniFrame := p.AniFrame;
          MArr[xx + p.rx, yy + p.ry].AniTick := p.AniTick;
          if p.light > 0 then
            MArr[xx + p.rx, yy + p.ry].Light := p.light;
          if p.DoorIndex > 0 then begin
            MArr[xx + p.rx, yy + p.ry].DoorIndex := p.DoorIndex;
            MArr[xx + p.rx, yy + p.ry].DoorOffset := p.DoorOffset;
          end;
        end;
      end;
    end
    else
      Beep;
  end;
end;

procedure TFrmMain.AddLight(x, y: integer);
var
  n: integer;
begin
  if (x >= 0) and (x < MAXX - 1) and (y >= 0) and (y < MAXY - 1) then begin
    n := MArr[x, y].Light;
    n := FrmGetLight.GetValue(n);
    SetLight(x, y, n);
    DrawCellBk(x - 1, y - 1, 1, 1);
  end;
end;

procedure TFrmMain.UpdateLight(x, y: integer);
var
  n: integer;
begin
  if (x >= 0) and (x < MAXX - 1) and (y >= 0) and (y < MAXY - 1) then begin
    n := MArr[x, y].Light;
    if n > 0 then begin
      n := FrmGetLight.GetValue(n);
      MArr[x, y].Light := n;
      DrawCellBk(x - 1, y - 1, 1, 1);
    end
    else
      Beep;
  end;
end;

procedure TFrmMain.UpdateDoor(x, y: integer);
var
  idx, offs: integer;
begin
  if (x >= 0) and (x < MAXX - 1) and (y >= 0) and (y < MAXY - 1) then begin
    idx := MArr[x, y].DoorIndex;
    offs := MArr[x, y].DoorOffset;
    if FrmDoorDlg.UpdateT(idx, offs) then begin
      MArr[x, y].DoorIndex := idx;
      MArr[x, y].DoorOffset := offs;
    end;
  end;
end;

function TFrmMain.GetPoint(idx: integer): integer;
begin
  Result := 0;
  if idx < 0 then
    exit;
  if idx <= 4 then begin
    Result := 6;
    exit;
  end;
  if idx <= 8 then begin
    Result := 1;
    exit;
  end;
  if idx <= 13 then begin
    Result := 5;
    exit;
  end;
  if idx <= 23 then begin
    Result := 4;
    exit;
  end;
  if idx <= 28 then
    Result := 2;
end;

function TFrmMain.IsMyUnit(x, y, munit, newidx: integer): Boolean;
var
  idx, uidx: integer;
begin
  Result := FALSE;
  idx := GetBkImg(x, y);
  if (idx <> 99) and (idx <> -1) then begin
    if munit = idx div UNITBLOCK then begin
      if GetPoint(idx mod UNITBLOCK) >= GetPoint(newidx) then
        Result := TRUE;
    end;
  end;
end;

procedure TFrmMain.DrawOne(x, y, munit, idx: integer);
begin
  if not IsMyUnit(x, y, munit, idx) then begin
    PutTileXY(x, y, munit * UNITBLOCK + idx + 1);
    DrawCellBk(x, y, 1, 1);
  end;
end;

procedure TFrmMain.DrawOneDr(x, y, munit, idx: integer);
begin
  PutTileXY(x, y, munit * UNITBLOCK + idx + 1);
  DrawCellBk(x, y, 1, 1);
end;

procedure TFrmMain.DrawObjDr(x, y, idx: integer);
begin
  PutObjXY(x, y, idx + 1);
  DrawCellFr(x, y, 0, 0);
end;

procedure TFrmMain.DrawORAttr(x, y, mark: integer);
begin
  if (x >= 0) and (x < MAXX - 1) and (y >= 0) and (y < MAXY - 1) then begin
    if (mark and $01) > 0 then
      MArr[x, y].BkImg := MArr[x, y].BkImg or $8000;
    if (mark and $02) > 0 then
      MArr[x, y].FrImg := MArr[x, y].FrImg or $8000;
  end;
end;

procedure TFrmMain.DrawXorAttrib(x, y: integer; button: TMouseButton; Shift: TShiftState);
var
  i, j, n1, n2, xx, yy: integer;
begin
  xx := x;
  yy := y;
  if ssShift in Shift then begin
    n1 := -2;
    n2 := 2
  end
  else begin
    n1 := 0;
    n2 := 0;
  end;
  for i := n1 to n2 do begin
    for j := n1 to n2 do begin
      x := xx + i;
      y := yy + j;
      if (x >= 0) and (x < MAXX - 1) and (y >= 0) and (y < MAXY - 1) then begin
        if Button = mbLeft then begin //Bk Attrib
          if ssCtrl in Shift then begin
            MArr[x, y].BkImg := MArr[x, y].BkImg and $7FFF;
          end
          else
            MArr[x, y].BkImg := MArr[x, y].BkImg or $8000;
        end;
        if Button = mbRight then begin // Fr Attrib
          if ssCtrl in Shift then begin
            MArr[x, y].FrImg := MArr[x, y].FrImg and $7FFF;
          end
          else
            MArr[x, y].FrImg := MArr[x, y].FrImg or $8000;
        end;
      end;
    end;
  end;
end;

procedure TFrmMain.DrawTileDetail(x, y: integer; Shift: TShiftState);
var
  bimg: integer;
begin
  x := x div 2 * 2;
  y := y div 2 * 2;
  ImageDetail := FrmTile.GetCurrentIndex;
  if ssAlt in Shift then begin
    PutTileXY(x, y, 0);
    DrawCellBk(x, y, 1, 1);
  end
  else begin
    if ImageDetail >= 0 then begin
      if not (ssCtrl in Shift) then begin
        PutTileXY(x, y, ImageDetail + 1);
        DrawCellBk(x, y, 1, 1);
      end
      else begin
        PutTileXY(x, y, (ImageDetail + 1)); // xor $8000);
        DrawCellBk(x, y, 1, 1);
      end;
    end;
  end;
end;

procedure TFrmMain.DrawNormalTile(x, y: integer; Shift: TShiftState);
var
  bimg: integer;
begin
  x := x div 2 * 2;
  y := y div 2 * 2;
  if (ssLeft in Shift) and not (ssAlt in Shift) then begin
    PutTileXY(x, y, ImageIndex * UNITBLOCK + Random(5) + 1);
    DrawCellBk(x, y, 1, 1);
  end;
  if ssAlt in Shift then begin
    PutTileXY(x, y, 0);
    DrawCellBk(x, y, 1, 1);
  end;
end;

procedure TFrmMain.DrawAutoTile(x, y: integer; Shift: TShiftState);
  procedure DrawSide(x, y: integer);
  var
    idx, myunit: integer;
  begin
    //idx := GetBkImg (x, y);
    myunit := ImageIndex; //idx div UNITBLOCK;
    DrawOne(x - 2, y, myunit, 10);
    DrawOne(x, y - 2, myunit, 10);
    DrawOne(x + 2, y - 2, myunit, 11);
    DrawOne(x + 4, y, myunit, 11);
    DrawOne(x - 2, y + 2, myunit, 12);
    DrawOne(x, y + 4, myunit, 12);
    DrawOne(x + 4, y + 2, myunit, 13);
    DrawOne(x + 2, y + 4, myunit, 13);
  end;

  procedure DrawWing(x, y: integer);
  var
    i, j, xx, yy, idx, myunit: integer;
  begin
    for i := 0 to 3 do begin
      for j := 0 to 3 do begin
        xx := x - 2 + i * 2;
        yy := y - 2 + j * 2;
        idx := GetBkImg(xx, yy);
        myunit := ImageIndex; //idx div UNITBLOCK;
        idx := idx mod UNITBLOCK;
        case idx of
          10: {//up '/'} begin
              DrawOne(xx, yy - 2, myunit, 5);
              DrawOne(xx - 2, yy, myunit, 5);
            end;
          11: {//up '\'} begin
              DrawOne(xx, yy - 2, myunit, 6);
              DrawOne(xx + 2, yy, myunit, 6);
            end;
          12: {//dn '\'} begin
              DrawOne(xx, yy + 2, myunit, 7);
              DrawOne(xx - 2, yy, myunit, 7);
            end;
          13: {//dn '/'} begin
              DrawOne(xx, yy + 2, myunit, 8);
              DrawOne(xx + 2, yy, myunit, 8);
            end;
        end;
      end;
    end;
  end;

  procedure SolidBlock(xx, yy, myunit, idx: integer);
  var
    p, p1, p2, p3, p4, p12, p23, p34, p14: integer;
  begin
    p := GetPoint(idx);
    if GetBkUnit(xx - 2, yy) = myunit then
      p1 := GetPoint(GetBkImgUnit(xx - 2, yy))
    else
      p1 := 0;
    if GetBkUnit(xx, yy - 2) = myunit then
      p2 := GetPoint(GetBkImgUnit(xx, yy - 2))
    else
      p2 := 0;
    if GetBkUnit(xx + 2, yy) = myunit then
      p3 := GetPoint(GetBkImgUnit(xx + 2, yy))
    else
      p3 := 0;
    if GetBkUnit(xx, yy + 2) = myunit then
      p4 := GetPoint(GetBkImgUnit(xx, yy + 2))
    else
      p4 := 0;
    {p12 := GetPoint (GetBkImgUnit (xx-2, yy-2));
    p23 := GetPoint (GetBkImgUnit (xx+2, yy-2));
    p34 := GetPoint (GetBkImgUnit (xx+2, yy+2));
    p14 := GetPoint (GetBkImgUnit (xx-2, yy+2));}
    if (p1 >= 4) and (p2 >= 4) and (p3 >= 4) and (p4 >= 4) then begin
      DrawOneDr(xx, yy, myunit, Random(5));
    end;
  end;

  procedure AssemblePuzzle(xx, yy, myunit, idx: integer);
  var
    d1, d2, d3, d4: integer;
  begin
    if (idx = 10) then begin
      d1 := GetBkImgUnit(xx, yy + 2);
      if (d1 = 12) or (d1 = 22) then
        DrawOneDr(xx, yy, myunit, 20);
      d2 := GetBkImgUnit(xx + 2, yy);
      if (d2 = 11) or (d2 = 16) then
        DrawOneDr(xx, yy, myunit, 15);
    end;
    if (idx = 12) then begin
      d1 := GetBkImgUnit(xx, yy - 2);
      if (d1 = 10) or (d1 = 20) then
        DrawOneDr(xx, yy, myunit, 22);
      d2 := GetBkImgUnit(xx + 2, yy);
      if (d2 = 13) or (d2 = 18) then
        DrawOneDr(xx, yy, myunit, 17);
    end;
    if (idx = 11) then begin
      d1 := GetBkImgUnit(xx, yy + 2);
      if (d1 = 13) or (d1 = 23) then
        DrawOneDr(xx, yy, myunit, 21);
      d2 := GetBkImgUnit(xx - 2, yy);
      if (d2 = 10) or (d2 = 15) then
        DrawOneDr(xx, yy, myunit, 16);
    end;
    if (idx = 13) then begin
      d1 := GetBkImgUnit(xx, yy - 2);
      if (d1 = 11) or (d1 = 21) then
        DrawOneDr(xx, yy, myunit, 23);
      d2 := GetBkImgUnit(xx - 2, yy);
      if (d2 = 12) or (d2 = 17) then
        DrawOneDr(xx, yy, myunit, 18);
    end;

    if (idx = 15) then begin
      d1 := GetBkImgUnit(xx + 2, yy);
      if (d1 <> 16) and (d1 <> 11) then
        DrawOneDr(xx, yy, myunit, 10);
    end;
    if (idx = 16) then begin
      d1 := GetBkImgUnit(xx - 2, yy);
      if (d1 <> 15) and (d1 <> 10) then
        DrawOneDr(xx, yy, myunit, 11);
    end;
    if (idx = 17) then begin
      d1 := GetBkImgUnit(xx + 2, yy);
      if (d1 <> 18) and (d1 <> 13) then
        DrawOneDr(xx, yy, myunit, 12);
    end;
    if (idx = 18) then begin
      d1 := GetBkImgUnit(xx - 2, yy);
      if (d1 <> 17) and (d1 <> 12) then
        DrawOneDr(xx, yy, myunit, 13);
    end;
    if (idx = 20) then begin
      d1 := GetBkImgUnit(xx, yy + 2);
      if (d1 <> 22) and (d1 <> 12) then
        DrawOneDr(xx, yy, myunit, 10);
    end;
    if (idx = 21) then begin
      d1 := GetBkImgUnit(xx, yy + 2);
      if (d1 <> 23) and (d1 <> 13) then
        DrawOneDr(xx, yy, myunit, 11);
    end;
    if (idx = 22) then begin
      d1 := GetBkImgUnit(xx, yy - 2);
      if (d1 <> 20) and (d1 <> 10) then
        DrawOneDr(xx, yy, myunit, 12);
    end;
    if (idx = 23) then begin
      d1 := GetBkImgUnit(xx, yy - 2);
      if (d1 <> 21) and (d1 <> 11) then
        DrawOneDr(xx, yy, myunit, 13);
    end;

    if (idx >= 0) and (idx <= 4) then begin
      d1 := GetBkImgUnit(xx - 2, yy);
      d2 := GetBkImgUnit(xx, yy - 2);
      d3 := GetBkImgUnit(xx + 2, yy);
      d4 := GetBkImgUnit(xx, yy + 2);
      if ((d1 = 11) or (d1 = 16)) and ((d2 = 12) or (d2 = 22)) then
        DrawOneDr(xx, yy, myunit, 10);
      if ((d2 = 13) or (d2 = 23)) and ((d3 = 10) or (d3 = 15)) then
        DrawOneDr(xx, yy, myunit, 11);
      if ((d3 = 12) or (d3 = 17)) and ((d4 = 11) or (d4 = 21)) then
        DrawOneDr(xx, yy, myunit, 13);
      if ((d1 = 13) or (d1 = 18)) and ((d4 = 10) or (d4 = 20)) then
        DrawOneDr(xx, yy, myunit, 12);
    end;
    if (GetBkUnit(xx, yy) <> myunit) or (idx = -1) or (idx = 99) then begin
      d1 := GetBkImgUnit(xx - 2, yy);
      d2 := GetBkImgUnit(xx, yy - 2);
      d3 := GetBkImgUnit(xx + 2, yy);
      d4 := GetBkImgUnit(xx, yy + 2);
      if (d4 = 20) and (d3 = 15) then
        DrawOneDr(xx, yy, myunit, 5);
      if (d1 = 16) and (d4 = 21) then
        DrawOneDr(xx, yy, myunit, 6);
      if (d2 = 23) and (d1 = 18) then
        DrawOneDr(xx, yy, myunit, 8);
      if (d3 = 17) and (d2 = 22) then
        DrawOneDr(xx, yy, myunit, 7);
    end;
  end;

  procedure DrawRemainBlock(x, y: integer);
  var
    i, j, xx, yy, idx, myunit: integer;
  begin
    for i := 0 to 6 do begin
      for j := 0 to 6 do begin
        xx := x - 3 * 2 + i * 2;
        yy := y - 3 * 2 + j * 2;
        idx := GetBkImg(xx, yy);
        myunit := ImageIndex; //idx div UNITBLOCK;
        idx := idx mod UNITBLOCK;
        SolidBlock(xx, yy, myunit, idx);
      end;
    end;
    for i := 0 to 6 do begin
      for j := 0 to 6 do begin
        xx := x - 3 * 2 + i * 2;
        yy := y - 3 * 2 + j * 2;
        idx := GetBkImg(xx, yy);
        myunit := ImageIndex; //idx div UNITBLOCK;
        idx := idx mod UNITBLOCK;
        AssemblePuzzle(xx, yy, myunit, idx);
      end;
    end;
  end;

var
  i, j: integer;
begin
  x := x div 2 * 2;
  y := y div 2 * 2;

  for i := 0 to 1 do
    for j := 0 to 1 do begin
      PutBigTileXY(x + i * 2, y + j * 2, ImageIndex * UNITBLOCK + Random(5) + 1);
      DrawCellBk(x + i * 2, y + j * 2, 1, 1);
    end;

  DrawSide(x, y);
  DrawRemainBlock(x, y);
  DrawRemainBlock(x, y);
  DrawWing(x, y);
end;

procedure TFrmMain.DrawAutoMiddleTile(x, y: integer; Shift: TShiftState);
var
  diu, di, changecount, WW, HH: integer;
  rlist: TList;

  function IMG(idx: integer): integer;
  begin
    if idx >= 1 then
      Result := MiddleIndex * MIDDLEBLOCK + idx * 4 + Random(4) + 4 + 1
    else
      Result := MiddleIndex * MIDDLEBLOCK + Random(8) + 1;
  end;
  procedure PutTile(x, y, idx: integer);
  var
    i: integer;
    p: pointer;
  begin
    Inc(changecount);
    PutMiddleXY(x, y, idx);
    p := pointer(MakeLong(word(x), word(y)));
    for i := 0 to rlist.Count - 1 do
      if rlist[i] = p then
        exit;
    rlist.Add(p);
  end;
  function UN(x, y: integer): integer;
  var
    idx: integer;
  begin
    idx := GetMidImg(x, y);
    if (idx >= MiddleIndex * MIDDLEBLOCK) and (idx < (MiddleIndex + 1) * MIDDLEBLOCK) then begin
      idx := idx - MiddleIndex * MIDDLEBLOCK;
      if idx < 8 then
        Result := 0
      else
        Result := (idx - 8) div 4 + 1;
    end
    else
      Result := -1;
  end;

  procedure DrawSide(x, y: integer);
  var
    idx: integer;
  begin
    if UN(x, y - 1) < 0 then
      PutTile(x, y - 1, IMG(1));
    if UN(x + 1, y - 1) < 0 then
      PutTile(x + 1, y - 1, IMG(2));
    if UN(x + 1, y) < 0 then
      PutTile(x + 1, y, IMG(3));
    if UN(x + 1, y + 1) < 0 then
      PutTile(x + 1, y + 1, IMG(4));
    if UN(x, y + 1) < 0 then
      PutTile(x, y + 1, IMG(5));
    if UN(x - 1, y + 1) < 0 then
      PutTile(x - 1, y + 1, IMG(6));
    if UN(x - 1, y) < 0 then
      PutTile(x - 1, y, IMG(7));
    if UN(x - 1, y - 1) < 0 then
      PutTile(x - 1, y - 1, IMG(8));
  end;
  procedure DrawAutoPattern(x, y: integer);
  var
    i, j, c, n1, n2: integer;
  begin
    for i := x - WW to x + WW do
      for j := y - HH to y + HH do begin
        if (i > 0) and (j > 0) then begin
          if UN(i, j) > 0 then begin
            // (¤¡)
            n1 := UN(i, j - 1);
            n2 := UN(i + 1, j);
            if UN(i, j) <> 11 then
              if ((n1 = 2) or (n1 = 3) or (n1 = 12)) and ((n2 = 2) or (n2 = 1) or (n2 = 10)) then begin
                PutTile(i, j, IMG(11));
              end;
            n1 := UN(i + 1, j);
            n2 := UN(i, j + 1);
            if UN(i, j) <> 12 then
              if ((n1 = 4) or (n1 = 5) or (n1 = 9)) and ((n2 = 4) or (n2 = 3) or (n2 = 11)) then begin
                PutTile(i, j, IMG(12));
              end;
            n1 := UN(i - 1, j);
            n2 := UN(i, j + 1);
            if UN(i, j) <> 9 then
              if ((n1 = 6) or (n1 = 5) or (n1 = 12)) and ((n2 = 6) or (n2 = 7) or (n2 = 10)) then begin
                PutTile(i, j, IMG(9));
              end;
            n1 := UN(i, j - 1);
            n2 := UN(i - 1, j);
            if UN(i, j) <> 10 then
              if ((n1 = 8) or (n1 = 7) or (n1 = 9)) and ((n2 = 8) or (n2 = 1) or (n2 = 11)) then begin
                PutTile(i, j, IMG(10));
              end;
            // (¤¤)
            n1 := UN(i - 1, j);
            n2 := UN(i + 1, j);
            if UN(i, j) <> 1 then
              if ((n1 = 1) or (n1 = 8) or (n1 = 11)) and ((n2 = 2) or (n2 = 1) or (n2 = 10)) and (UN(i, j - 1) < 0) then begin
                PutTile(i, j, IMG(1));
              end;
            n1 := UN(i, j - 1);
            n2 := UN(i, j + 1);
            if UN(i, j) <> 3 then
              if ((n1 = 3) or (n1 = 2) or (n1 = 12)) and ((n2 = 3) or (n2 = 4) or (n2 = 11)) and (UN(i + 1, j) < 0) then begin
                PutTile(i, j, IMG(3));
              end;
            n1 := UN(i - 1, j);
            n2 := UN(i + 1, j);
            if UN(i, j) <> 5 then
              if ((n1 = 6) or (n1 = 5) or (n1 = 12)) and ((n2 = 5) or (n2 = 4) or (n2 = 9)) and (UN(i, j + 1) < 0) then begin
                PutTile(i, j, IMG(5));
              end;
            n1 := UN(i, j - 1);
            n2 := UN(i, j + 1);
            if UN(i, j) <> 7 then
              if ((n1 = 7) or (n1 = 8) or (n1 = 9)) and ((n2 = 7) or (n2 = 6) or (n2 = 10)) and (UN(i - 1, j) < 0) then begin
                PutTile(i, j, IMG(7));
              end;
            // (¤§)
            if UN(i, j) <> 1 then
              if {(UN(i,j-1)=-1) and (UN(i+1,j-1)=-1) and}(UN(i, j + 1) = 0) and (UN(i + 1, j + 1) = 0) then
                if (UN(i, j) = 2) and ((UN(i + 1, j) = 8) or (UN(i + 1, j) = 7)) then
                  PutTile(i, j, IMG(1));
            if UN(i, j) <> 3 then
              if {(UN(i+1,j)=-1) and (UN(i+1,j+1)=-1) and}(UN(i - 1, j) = 0) and (UN(i - 1, j + 1) = 0) then
                if (UN(i, j) = 4) and ((UN(i, j + 1) = 2) or (UN(i, j + 1) = 1)) then
                  PutTile(i, j, IMG(3));
            if UN(i, j) <> 5 then
              if {(UN(i,j+1)=-1) and (UN(i+1,j+1)=-1) and}(UN(i, j - 1) = 0) and (UN(i + 1, j - 1) = 0) then
                if (UN(i, j) = 4) and ((UN(i + 1, j) = 6) or (UN(i + 1, j) = 7)) then
                  PutTile(i, j, IMG(5));
            if UN(i, j) <> 7 then
              if {(UN(i-1,j)=-1) and (UN(i-1,j+1)=-1) and}(UN(i + 1, j) = 0) and (UN(i + 1, j + 1) = 0) then
                if (UN(i, j) = 6) and ((UN(i, j + 1) = 8) or (UN(i, j + 1) = 7)) then
                  PutTile(i, j, IMG(7));
            // (¤©)
            if (UN(i - 1, j) = 5) and (UN(i, j - 1) = 3) and (UN(i + 1, j) = 1) and (UN(i, j + 1) = 7) or
              (UN(i - 1, j) = 1) and (UN(i, j + 1) = 3) and (UN(i, j - 1) = 7) and (UN(i + 1, j) = 5) then begin
              PutTile(i, j, IMG(0));
              DrawSide(i, j);
            end;
            // (¤±)
            if UN(i, j) = 2 then begin
              if (UN(i + 1, j) > -1) and (UN(i, j + 1) = 0) and (UN(i + 1, j + 1) >= 0) then
                PutTile(i, j, IMG(1));
              if (UN(i, j - 1) > -1) and (UN(i - 1, j) = 0) and (UN(i - 1, j - 1) >= 0) then
                PutTile(i, j, IMG(3));
            end;
            if UN(i, j) = 4 then begin
              if (UN(i + 1, j) > -1) and (UN(i, j - 1) = 0) and (UN(i + 1, j - 1) >= 0) then
                PutTile(i, j, IMG(5));
              if (UN(i, j + 1) > -1) and (UN(i - 1, j) = 0) and (UN(i - 1, j + 1) >= 0) then
                PutTile(i, j, IMG(3));
            end;
            if UN(i, j) = 6 then begin
              if (UN(i, j + 1) > -1) and (UN(i + 1, j) = 0) and (UN(i + 1, j + 1) >= 0) then
                PutTile(i, j, IMG(7));
              if (UN(i - 1, j) > -1) and (UN(i - 1, j - 1) = 0) and (UN(i, j - 1) >= 0) then
                PutTile(i, j, IMG(5));
            end;
            if UN(i, j) = 8 then begin
              if (UN(i, j - 1) > -1) and (UN(i + 1, j) = 0) and (UN(i + 1, j - 1) >= 0) then
                PutTile(i, j, IMG(7));
              if (UN(i - 1, j) > -1) and (UN(i, j + 1) = 0) and (UN(i - 1, j + 1) >= 0) then
                PutTile(i, j, IMG(1));
            end;
            // else
            c := 0;
            if UN(i, j - 1) >= 0 then
              Inc(c);
            if UN(i + 1, j - 1) >= 0 then
              Inc(c);
            if UN(i + 1, j) >= 0 then
              Inc(c);
            if UN(i + 1, j + 1) >= 0 then
              Inc(c);
            if UN(i, j + 1) >= 0 then
              Inc(c);
            if UN(i - 1, j + 1) >= 0 then
              Inc(c);
            if UN(i - 1, j) >= 0 then
              Inc(c);
            if UN(i - 1, j - 1) >= 0 then
              Inc(c);
            if c >= 8 then
              PutTile(i, j, IMG(0));

          end;
        end;
      end;
  end;
var
  i, k, n, rx, ry: integer;
begin
  rlist := TList.Create;
  PutTile(x, y, IMG(0));

  DrawSide(x, y);
  WW := 1;
  HH := 1;
  for k := 0 to 30 do begin
    changecount := 0;
    DrawAutoPattern(x, y);
    if changecount = 0 then
      break;
    Inc(WW);
    Inc(HH);
  end;

  for i := 0 to rlist.Count - 1 do begin
    n := Integer(rlist[i]);
    DrawCellBk(Loword(n), Hiword(n), 0, 0);
  end;
  rlist.Free;
end;

procedure TFrmMain.DrawCellBk(x, y, w, h: integer);
var
  i, j, dx, dy, xx, yy, lcorner, tcorner, idx, light, door, dooroffs: integer;
begin
  lcorner := Trunc(MainScroll.HorzScrollBar.Position div UNITX / Zoom);
  tcorner := Trunc(MainScroll.VertScrollBar.Position div UNITY / Zoom);

  if ShowBackgroundTile1.Checked then
    for j := y to y + h do
      for i := x to x + w do begin
        xx := i;
        yy := j;
        if (xx >= 0) and (xx < MAXX) and (yy >= 0) and (yy < MAXY) then begin
          if (xx >= lcorner - 1) and (yy >= tcorner - 1) and
            (xx <= lcorner + Round(Width div UNITX / Zoom)) and
            (yy <= tcorner + Round(Height div UNITY / Zoom)) then begin
            idx := GetBkImg(xx, yy);
            dx := Trunc(xx * UNITX * Zoom);
            dy := Trunc(yy * UNITY * Zoom);
            if (xx mod 2 = 0) and (yy mod 2 = 0) then begin
              WilTiles[GetBkIndex(xx, yy)].DrawZoom(MapPaint.Canvas, dx, dy, idx, Zoom);
            end
            else
              WilTiles[GetBkIndex(xx, yy)].DrawZoom(MapPaint.Canvas, dx, dy, 99, Zoom);
          end;
        end;
      end;
  if ShowMiddleTile1.Checked then
    for j := y to y + h do
      for i := x to x + w do begin
        xx := i;
        yy := j;
        if (xx >= 0) and (xx < MAXX) and (yy >= 0) and (yy < MAXY) then begin
          if (xx >= lcorner - 1) and (yy >= tcorner - 1) and
            (xx <= lcorner + Round(Width div UNITX / Zoom)) and
            (yy <= tcorner + Round(Height div UNITY / Zoom)) then begin
            idx := GetMidImg(xx, yy);
            dx := Trunc(xx * UNITX * Zoom);
            dy := Trunc(yy * UNITY * Zoom);
            if idx >= 0 then
              if MiddleTransparent1.Checked then
                WilSmTiles[GetSMIndex(xx, yy)].DrawZoomEx(MapPaint.Canvas, dx, dy, idx, Zoom, TRUE)
              else
                WilSmTiles[GetSMIndex(xx, yy)].DrawZoom(MapPaint.Canvas, dx, dy, idx, Zoom)
          end;
        end;
      end;
  for j := y to y + h do
    for i := x to x + w do begin
      xx := i;
      yy := j;
      if (xx >= 0) and (xx < MAXX) and (yy >= 0) and (yy < MAXY) then begin
        if (xx >= lcorner - 1) and (yy >= tcorner - 1) and
          (xx <= lcorner + Round(Width div UNITX / Zoom)) and
          (yy <= tcorner + Round(Height div UNITY / Zoom)) then begin
          dx := Trunc(xx * UNITX * Zoom);
          dy := Trunc(yy * UNITY * Zoom);
          light := 0;
          door := 0;
          dooroffs := 0;
          if GetLightAddDoor(xx, yy, light, door, dooroffs) then begin
            if light > 0 then
              WilSmTiles[0].DrawZoomEx(MapPaint.Canvas, dx, dy, LIGHTSPOT, Zoom, TRUE);
            if (Zoom >= 0.8) and (door > 0) then begin
              if (door and $80) > 0 then
                MapPaint.Canvas.TextOut(dx + 16, dy - 26, 'Dx')
              else
                MapPaint.Canvas.TextOut(dx + 16, dy - 26, 'D');
            end;
          end;
        end;
      end;
    end;
end;

procedure TFrmMain.DrawCellFr(x, y, w, h: integer);
var
  i, j, dx, dy, lcorner, tcorner, idx: integer;
begin
  lcorner := Trunc(MainScroll.HorzScrollBar.Position div UNITX / Zoom);
  tcorner := Trunc(MainScroll.VertScrollBar.Position div UNITY / Zoom);

  if ShowObject1.Checked then
    if (x >= 0) and (x < MAXX) and (y >= 0) and (y < MAXY) then begin
      if (x >= lcorner - 1) and (y >= tcorner - 1) and
        (x <= lcorner + Round(Width div UNITX / Zoom)) and
        (y <= tcorner + Round(Height div UNITY / Zoom)) then begin
        idx := GetFrImg(x, y);
        dx := Trunc(x * UNITX * Zoom);
        dy := Trunc((y + 1) * UNITY * Zoom);
        if (idx >= 0) then
          ObjWil(idx).DrawZoomEx(MapPaint.Canvas, dx, dy, idx mod 65535, Zoom, FALSE);
      end;
    end;
  if ShowAttribMarks1.Checked then
    if (x >= lcorner - 1) and (y >= tcorner - 1) and
      (x <= lcorner + Round(Width div UNITX / Zoom)) and
      (y <= tcorner + Round(Height div UNITY / Zoom)) then begin
      if (x >= 0) and (x < MAXX) and (y >= 0) and (y < MAXY) then begin
        dx := Trunc(x * UNITX * Zoom);
        dy := Trunc(y * UNITY * Zoom);
        idx := GetBk(x, y);
        if idx >= 0 then
          if (idx and $8000) > 0 then
            WilSmTiles[0].DrawZoomEx(MapPaint.Canvas, dx, dy, BKMASK, Zoom, TRUE);
        idx := GetFrMask(x, y);
        if idx > 0 then
          WilSmTiles[0].DrawZoomEx(MapPaint.Canvas, dx, dy, FRMASK, Zoom, TRUE);
      end;
    end;

end;

procedure TFrmMain.MapPaintPaint(Sender: TObject);
var
  i, j, xx, yy, dx, dy, lcorner, tcorner, idx, light, door, dooroffs, nIdx: integer;
begin
  if SaveAllMap then Exit;
  
  lcorner := Trunc(MainScroll.HorzScrollBar.Position div UNITX / Zoom);
  tcorner := Trunc(MainScroll.VertScrollBar.Position div UNITY / Zoom);

  if ShowBackgroundTile1.Checked then
    for j := 0 to (Trunc(MapPaint.Height div UNITY / Zoom) + 2) do
      for i := 0 to (Trunc(MapPaint.Width div UNITX / Zoom) + 2) do begin
        xx := i;
        yy := j;
        if (xx >= lcorner - 1) and (yy >= tcorner - 1) and
          (xx <= lcorner + Round(Width div UNITX / Zoom)) and
          (yy <= tcorner + Round(Height div UNITY / Zoom)) then begin
          if (xx >= 0) and (xx < MAXX) and (yy >= 0) and (yy < MAXY) then begin
            idx := GetBkImg(xx, yy);
            nIdx := GetBkIndex(xx, yy);
            if (xx mod 2 = 0) and (yy mod 2 = 0) then begin
              xx := Trunc(xx * UNITX * Zoom);
              yy := Trunc(yy * UNITY * Zoom);
              if idx >= 0 then begin
                WilTiles[nIdx].DrawZoom(MapPaint.Canvas, xx, yy, idx, Zoom);
              end;
            end;
          end;
        end;
      end;

  if ShowMiddleTile1.Checked then
    for j := 0 to (Trunc(MapPaint.Height div UNITY / Zoom) + 2) do
      for i := 0 to (Trunc(MapPaint.Width div UNITX / Zoom) + 2) do begin
        xx := i;
        yy := j;
        if (xx >= lcorner - 1) and (yy >= tcorner - 1) and
          (xx <= lcorner + Round(Width div UNITX / Zoom)) and
          (yy <= tcorner + Round(Height div UNITY / Zoom)) then begin
          if (xx >= 0) and (xx < MAXX) and (yy >= 0) and (yy < MAXY) then begin
            idx := GetMidImg(xx, yy);
            nIdx := GetSMIndex(xx, yy);
            xx := Trunc(xx * UNITX * Zoom);
            yy := Trunc(yy * UNITY * Zoom);
            if idx >= 0 then begin
              if MiddleTransparent1.Checked then
                WilSmTiles[nIdx].DrawZoomEx(MapPaint.Canvas, xx, yy, idx, Zoom, TRUE)
              else
                WilSmTiles[nIdx].DrawZoom(MapPaint.Canvas, xx, yy, idx, Zoom);
            end;
          end;
        end;
      end;

  if ShowObject1.Checked then
    for j := 0 to (Trunc(MapPaint.Height div UNITY / Zoom) + 50) do
      for i := 0 to (Trunc(MapPaint.Width div UNITX / Zoom) + 2) do begin
        xx := i;
        yy := j;
        if (xx >= lcorner - 1) and (yy >= tcorner - 1) and
          (xx <= lcorner + Round(Width div UNITX / Zoom)) and
          (yy <= tcorner + Round(Height div UNITY / Zoom)) then begin
          if (xx >= 0) and (xx < MAXX) and (yy >= 0) and (yy < MAXY) then begin

            { if (Marr[xx,yy].Area=5) and (Marr[xx,yy].FrImg=12048) then
               idx := GetFrImg (xx, yy)
             else   }
            idx := GetFrImg(xx, yy);
            xx := Trunc(xx * UNITX * Zoom);
            yy := Trunc((yy + 1) * UNITY * Zoom);
            if (idx >= 0) then
              ObjWil(idx).DrawZoomEx(MapPaint.Canvas, xx, yy, idx mod 65535, Zoom, FALSE);

          end;
        end;
      end;

  for j := 0 to (Trunc(MapPaint.Height div UNITY / Zoom) + 2) do
    for i := 0 to (Trunc(MapPaint.Width div UNITX / Zoom) + 2) do begin
      xx := i;
      yy := j;
      if (xx >= lcorner - 1) and (yy >= tcorner - 1) and
        (xx <= lcorner + Round(Width div UNITX / Zoom)) and
        (yy <= tcorner + Round(Height div UNITY / Zoom)) then begin
        if (xx >= 0) and (xx < MAXX) and (yy >= 0) and (yy < MAXY) then begin
          dx := Trunc(xx * UNITX * Zoom);
          dy := Trunc(yy * UNITY * Zoom);
          if ShowAttribMarks1.Checked then begin
            idx := GetBk(xx, yy);
            if idx >= 0 then
              if (idx and $8000) > 0 then
                WilSmTiles[0].DrawZoomEx(MapPaint.Canvas, dx, dy, BKMASK, Zoom, TRUE);
            idx := GetFrMask(xx, yy);
            if idx > 0 then
              WilSmTiles[0].DrawZoomEx(MapPaint.Canvas, dx, dy, FRMASK, Zoom, TRUE);
            idx := GetAni(xx, yy);
            if idx > 0 then
              MapPaint.Canvas.TextOut(dx, dy, '*');
          end;
          light := 0;
          door := 0;
          dooroffs := 0;
          if GetLightAddDoor(xx, yy, light, door, dooroffs) then begin
            if light > 0 then
              WilSmTiles[0].DrawZoomEx(MapPaint.Canvas, dx, dy, LIGHTSPOT, Zoom, TRUE);
            if (Zoom >= 0.9) and (door > 0) then begin
              if (door and $80) > 0 then
                MapPaint.Canvas.TextOut(dx, dy, 'Dx' + intToStr(door and $7F) + '/' + IntToStr(doorOffs))
              else
                MapPaint.Canvas.TextOut(dx, dy, 'D' + intToStr(door and $7F) + '/' + IntToStr(doorOffs));
            end;
          end;
        end;
      end;
    end;

  with MapPaint.Canvas do begin
    Pen.Color := clBlack;
    MoveTo(0, MapPaint.Height - 1);
    LineTo(MapPaint.Width - 1, MapPaint.Height - 1);
    LineTo(MapPaint.Width - 1, 0);
  end;
  if BoxVisible then begin
    BoxVisible := FALSE;
  end;
end;

procedure TFrmMain.SpeedButton1Click(Sender: TObject);
begin
  MainBrush := mbAuto;
end;

procedure TFrmMain.SpeedButton2Click(Sender: TObject);
begin
  MainBrush := mbNormal;
end;

procedure TFrmMain.SpeedButton3Click(Sender: TObject);
begin
  MainBrush := mbFill;
end;

procedure TFrmMain.SpeedButton6Click(Sender: TObject);
begin
  MainBrush := mbFillAttrib;
end;

procedure TFrmMain.SpeedButton4Click(Sender: TObject);
begin
  MainBrush := mbAttrib;
end;

procedure TFrmMain.SpeedButton5Click(Sender: TObject);
begin
  MainBrush := mbEraser;
end;

procedure TFrmMain.ZoomInClick(Sender: TObject);
begin
  if Zoom <= 0.21 then begin
    Zoom := Zoom - 0.05;
    if Zoom < 0.05 then
      Zoom := 0.05;
  end
  else begin
    Zoom := Zoom - 0.2;
    if Zoom < 0.2 then
      Zoom := 0.2;
  end;
  Label1.Caption := '100:' + IntToStr(Round(100 * Zoom));
  MapPaint.Width := Round(MapWidth * UNITX * Zoom) + 1;
  MapPaint.Height := Round(MapHeight * UNITY * Zoom) + 1;
  MainScroll.HorzScrollBar.Increment := Round(UNITX * 4 * Zoom);
  MainScroll.VertScrollBar.Increment := Round(UNITY * 4 * Zoom);
  MapPaint.Update; //Refresh;
end;

procedure TFrmMain.ZoomOutClick(Sender: TObject);
begin
  if Zoom < 0.2 then begin
    Zoom := Zoom + 0.05;
  end
  else begin
    Zoom := Zoom + 0.2;
    if (Zoom > 1.0) and (Zoom < 1.2) then
      Zoom := 1.0;
    if Zoom > 2.0 then
      Zoom := 2.0;
  end;
  Label1.Caption := '100:' + IntToStr(Round(100 * Zoom));
  MapPaint.Width := Round(MapWidth * UNITX * Zoom) + 1;
  MapPaint.Height := Round(MapHeight * UNITY * Zoom) + 1;
  MainScroll.HorzScrollBar.Increment := Round(UNITX * 4 * Zoom);
  MainScroll.VertScrollBar.Increment := Round(UNITY * 4 * Zoom);
  MapPaint.Refresh;
end;

procedure TFrmMain.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_F5:
      MapPaint.Refresh;
    word('z'),
      word('Z'):
      if ssCtrl in Shift then begin
        Undo;
      end;
  end;
end;

procedure TFrmMain.Tile1Click(Sender: TObject);
begin
  FrmMainPal.Show;
end;

procedure TFrmMain.Object1Click(Sender: TObject);
begin
  FrmObj.Show;
end;

procedure TFrmMain.RunObjEditer1Click(Sender: TObject);
begin
  FrmObjEdit.Execute;
end;

procedure TFrmMain.ObjectSet1Click(Sender: TObject);
begin
  FrmObjSet.Execute;
end;

procedure TFrmMain.TileDetail1Click(Sender: TObject);
begin
  FrmTile.Show;
end;

function TFrmMain.VerifyWork: Boolean;
var
  r: integer;
begin
  Result := TRUE;
  if Edited then begin
    r := MessageDlg('ÎÄ¼þÒÔ±»¸üÐÂ£¬ÊÇ·ñ±£´æ?',
      mtWarning,
      mbYesNoCancel,
      0);
    if r = mrYes then
      if not SegmentMode then
        SaveAs1Click(self)
      else
        DoSaveSegments;
    if r = mrCancel then
      Result := FALSE;
  end;
end;

procedure TFrmMain.WMDropFiles(var Msg: TWMDropFiles);
var
  AFileName: array[0..MAX_PATH] of Char;
  nFiles, I: Integer;
begin
  nFiles := DragQueryFile(Msg.Drop, $FFFFFFFF, nil, 0);
  for I := 0 to nFiles - 1 do begin
    if DragQueryFile(Msg.Drop, I, AFileName, MAX_PATH) > 0 then begin
      //FDropFileList.Add(AFileName);
      if LoadFromFile(AFileName) then begin
        CurrentMapName := AFileName;
        LbMapName.Caption := ExtractFileNameOnly(AFileName);
        MapPaint.Width := Round(MapWidth * UNITX * Zoom) + 1;
        MapPaint.Height := Round(MapHeight * UNITY * Zoom) + 1;
        CurX := 0;
        CurY := 0;
        MapPaint.Refresh;
      end;
      Break;
    end;
  end;
end;

procedure TFrmMain.New1Click(Sender: TObject);
begin
  if not VerifyWork then
    exit;
  if SegmentMode then begin
    ShowMessage('Use Segment Tool');
    exit;
  end;
  if FrmMapSize.Execute then begin
    MapWidth := FrmMapSize.MapX;
    MapHeight := FrmMapSize.MapY;
    NewMap;
    MapPaint.Refresh;
  end;
end;

procedure TFrmMain.Open1Click(Sender: TObject);
var
  i, j, n: integer;
begin
  if not VerifyWork then exit;
  if SegmentMode then begin
    ShowMessage('Use Segment Tool');
    exit;
  end;
  with OpenDialog1 do begin
    if Execute then begin
      if LoadFromFile(FileName) then begin
        CurrentMapName := FileName;
        LbMapName.Caption := ExtractFileNameOnly(FileName);
        MapPaint.Width := Round(MapWidth * UNITX * Zoom) + 1;
        MapPaint.Height := Round(MapHeight * UNITY * Zoom) + 1;
        CurX := 0;
        CurY := 0;
        MapPaint.Refresh;
      end;
    end;
  end;
end;

procedure TFrmMain.OpenOldFormatFile1Click(Sender: TObject);
var
  i, j, n: integer;
begin
  if not VerifyWork then
    exit;
  if SegmentMode then begin
    ShowMessage('Use Segment Tool');
    exit;
  end;
  with OpenDialog1 do begin
    if Execute then begin
      if LoadFromFile(FileName) then begin
        CurrentMapName := FileName;
        LbMapName.Caption := ExtractFileNameOnly(FileName);
        MapPaint.Width := Round(MapWidth * UNITX * Zoom) + 1;
        MapPaint.Height := Round(MapHeight * UNITY * Zoom) + 1;
        CurX := 0;
        CurY := 0;

        for j := 0 to MapHeight - 1 do
          for i := 0 to MapWidth - 1 do begin
            n := (MArr[i, j].FrImg and $7FFF);
            MArr[i, j].Area := n div 65535;
            MArr[i, j].FrImg := n mod 65535;
          end;

        MapPaint.Refresh;
      end;
    end;
  end;
end;

procedure TFrmMain.OldFromatBatchConvert1Click(Sender: TObject);
var
  i, j, k, n: integer;
  flname: string;
begin
  with OpenDialog1 do begin
    if Execute then begin
      for k := 0 to Files.Count - 1 do begin
        flname := Files[k];
        if LoadFromFile(flname) then begin
          for j := 0 to MapHeight - 1 do
            for i := 0 to MapWidth - 1 do begin
              n := (MArr[i, j].FrImg and $7FFF);
              MArr[i, j].Area := n div 65535;
              MArr[i, j].FrImg := n mod 65535;
            end;
          SaveToFile(flname);
        end;
      end;
      ShowMessage('×ª»»Íê³É!!');
    end;
  end;
end;

procedure TFrmMain.SaveAs1Click(Sender: TObject);
begin
  with SaveDialog1 do begin
    if Execute then begin
      if SaveToFile(FileName) then begin
        CurrentMapName := FileName;
        LbMapName.Caption := ExtractFileNameOnly(FileName);
        Edited := FALSE;
      end;
    end;
  end;
end;

procedure TFrmMain.Save1Click(Sender: TObject);
begin
  if SegmentMode then begin
    ShowMessage('Use Segment Tool');
    exit;
  end;
  //if CurrentMapName <> '' then begin
  //   SaveToFile (CurrentMapName);
  //   Edited := FALSE;
  //end else
  SaveAs1Click(self);
end;

procedure TFrmMain.Timer1Timer(Sender: TObject);
begin
  if not SegmentMode then begin
    if Edited then
      LbMapName.Caption := 'Î´±£´æ' + ExtractFileNameOnly(CurrentMapName)
    else begin
      if CurrentMapName = '' then
        LbMapName.Caption := 'Î´ÃüÃû'
      else
        LbMapName.Caption := ExtractFileNameOnly(CurrentMapName);
    end;
  end
  else begin
    if Edited then
      LbMapName.Caption := 'Î´±£´æ' + FrmSegment.CurSegs[0, 0]
    else
      LbMapName.Caption := FrmSegment.CurSegs[0, 0];
  end;
end;

procedure TFrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  r: integer;
begin
  if VerifyWork then begin
    CanClose := TRUE
  end
  else
    CanClose := FALSE;
end;

procedure TFrmMain.BtnMarkClick(Sender: TObject);
begin
  MapPaint.Refresh;
end;

procedure TFrmMain.NewSegmentMap1Click(Sender: TObject);
begin
  FrmSegment.Show;
end;

// ---------------------------------------

//  Segment Editing

// ---------------------------------------

procedure TFrmMain.LoadSegment(col, row: integer; flname: string);
var
  i, fhandle: integer;
  header: TMapHeader;
begin
  if not FileExists(flname) then
    exit;
  fhandle := FileOpen(flname, fmOpenRead or fmShareDenyNone);
  if fhandle > 0 then begin
    FileRead(fhandle, header, sizeof(TMapHeader));
    //if header.Title = TITLEHEADER then begin
    if (header.Width > 0) and (header.Height > 0) then begin
      for i := 0 to header.Width - 1 do begin
        FileRead(fhandle, MArr[col + i, row], sizeof(TMapInfo) * SEGY);
      end;
    end;
    //end;
    FileClose(fhandle);
  end;
end;

procedure TFrmMain.SaveSegment(col, row: integer; flname: string);
var
  i, fhandle: integer;
  header: TMapHeader;
begin
  header.Width := SEGX;
  header.Height := SEGY;
  header.Title := TITLEHEADER;
  if FileExists(flname) then
    fhandle := FileOpen(flname, fmOpenWrite or fmShareDenyNone)
  else
    fhandle := FileCreate(flname);
  if fhandle > 0 then begin
    FileWrite(fhandle, header, sizeof(TMapHeader));
    for i := col to col + SEGX - 1 do begin
      FileWrite(fhandle, MArr[i, row], sizeof(TMapInfo) * SEGY);
    end;
    FileClose(fhandle);
  end;
end;

procedure TFrmMain.DoEditSegment;
var
  i, j: integer;
  map: string;
begin
  if FrmSegment.SegPath = '' then begin
    ShowMessage('¸ÕÀú Segment Project¸¦ ÀúÀåÇÏ½Ê½Ã¿À');
    //FrmSegment.BtnSaveClick (self);
    if FrmSegment.SegPath = '' then
      exit;
  end;
  SegmentMode := TRUE;
  FillChar(MArr, sizeof(MArr), #0);
  //FillChar (MArrUndo, sizeof(MArrUndo), #0);
  CurX := 0;
  CurY := 0;
  for i := 0 to 2 do
    for j := 0 to 2 do begin
      map := FrmSegment.CurSegs[i, j];
      if map <> '' then
        LoadSegment(i * SEGX, j * SEGY, FrmSegment.SegPath + '\' + map + '.sem');
    end;
  MapWidth := SEGX * 3;
  MapHeight := SEGY * 3;
  MapPaint.Width := Round(MapWidth * UNITX * Zoom) + 1;
  MapPaint.Height := Round(MapHeight * UNITY * Zoom) + 1;
  Edited := FALSE;
  MapPaint.Refresh;
end;

procedure TFrmMain.DoSaveSegments;
var
  i, j: integer;
  map: string;
begin
  for i := 0 to 2 do
    for j := 0 to 2 do begin
      map := FrmSegment.CurSegs[i, j];
      if map <> '' then
        SaveSegment(i * SEGX, j * SEGY, FrmSegment.SegPath + '\' + map + '.sem');
    end;
  Edited := FALSE;
end;

procedure TFrmMain.ClearEditSegments1Click(Sender: TObject);
begin
  FillChar(MArr, sizeof(MArr), #0);
  MapPaint.Refresh;
end;

procedure TFrmMain.BtnLeftSegClick(Sender: TObject);
begin
  if SegmentMode then
    FrmSegment.ShiftLeftSegment;
end;

procedure TFrmMain.BtnRightSegClick(Sender: TObject);
begin
  if SegmentMode then
    FrmSegment.ShiftRightSegment;
end;

procedure TFrmMain.BtnUpSegClick(Sender: TObject);
begin
  if SegmentMode then
    FrmSegment.ShiftUpSegment;
end;

procedure TFrmMain.cbb1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = 13 then begin
    cbb1.Items.Add(cbb1.Text);
  end
  else if Key = 27 then begin
    if cbb1.ItemIndex > -1 then
      cbb1.Items.Delete(cbb1.ItemIndex);
  end;
end;

function BrowseForFolder(hd: HWND; sTitle: string): string;
var
  BrowseInfo: TBrowseInfo;
  sBuf: array[0..511] of Char;
begin
  FillChar(BrowseInfo, SizeOf(TBrowseInfo), #0);
  BrowseInfo.hwndOwner := hd;
  BrowseInfo.lpszTitle := PChar(sTitle);
  BrowseInfo.ulFlags := 64;
  SHGetPathFromIDList(SHBrowseForFolder(BrowseInfo), @sBuf);
  Result := Trim(sBuf);
end;

procedure TFrmMain.BMP1Click(Sender: TObject);
var
  NewDir, SaveDir: string;
  sr: TSearchRec;
  n: Integer;
begin
  NewDir := BrowseForFolder(Handle, 'ÇëÑ¡ÔñÊý¾ÝÄ¿Â¼');
  if NewDir <> '' then begin
    SaveAllMap := True;
    n := FindFirst(NewDir + '\*.map', faAnyFile, sr);
    SaveDir := NewDir + '\MapImages\';
    CreateDir(SaveDir);
    while n = 0 do begin
      if (not FileExists(SaveDir + sr.Name + '.bmp')) and LoadFromFile(NewDir + '\' + sr.Name) then begin
        CurrentMapName := SaveDir + sr.Name;
        LbMapName.Caption := sr.Name;
        Try
          SaveToBitmap1Click(nil);
        Except
          Application.MessageBox(PChar('±£´æÎÄ¼þ[' + sr.Name + ']·¢Éú´íÎó£¡'), 'ÌáÊ¾ÐÅÏ¢', MB_OK + MB_ICONINFORMATION);
        End;
      end;
      n := FindNext(sr);
      Application.ProcessMessages;
    end;
    FindClose(sr);
    Application.MessageBox('È«²¿±£´æÍê³É£¡', 'ÌáÊ¾ÐÅÏ¢', MB_OK + MB_ICONINFORMATION);
    SaveAllMap := False;
  end;
end;

procedure TFrmMain.BtnDownSegClick(Sender: TObject);
begin
  if SegmentMode then
    FrmSegment.ShiftDownSegment;
end;

procedure TFrmMain.ObjectViewNormalSize1Click(Sender: TObject);
begin
  ObjectViewNormalSize1.Checked := not ObjectViewNormalSize1.Checked;
  if ObjectViewNormalSize1.Checked then
    FrmObj.ViewNormal := TRUE
  else
    FrmObj.ViewNormal := FALSE;
end;

procedure TFrmMain.SmallTile1Click(Sender: TObject);
begin
  FrmSmTile.Show;
end;

procedure TFrmMain.ShowBackgroundTile1Click(Sender: TObject);
begin
  if Sender is TMenuItem then begin
    TMenuItem(Sender).Checked := not TMenuItem(Sender).Checked;
    MapPaint.Refresh;
  end;
end;

procedure TFrmMain.DrawObject1Click(Sender: TObject);
begin
  if Sender is TMenuItem then begin
    TMenuItem(Sender).Checked := not TMenuItem(Sender).Checked;
    if Sender = DrawBigTile1 then
      DrawMode := mdTile;
    if Sender = DrawObject1 then
      DrawMode := mdObj;
    if Sender = DrawObjectTileSet1 then
      DrawMode := mdObjSet;
    if Sender = DrawSmTile1 then
      DrawMode := mdMiddle;
    if Sender = SetLightEffect1 then
      DrawMode := mdLight;
    if Sender = UpdateDoor1 then
      DrawMode := mdDoor;
  end;
end;

procedure TFrmMain.Resize1Click(Sender: TObject);
begin
  if FrmMapSize.Execute then begin
    MapWidth := FrmMapSize.MapX;
    MapHeight := FrmMapSize.MapY;
    if MapWidth < 0 then
      MapWidth := 1;
    if MapHeight < 0 then
      MapHeight := 1;
    MapPaint.Width := Round(MapWidth * UNITX * Zoom) + 1;
    MapPaint.Height := Round(MapHeight * UNITY * Zoom) + 1;
    CurX := 0;
    CurY := 0;
    MapPaint.Refresh;
  end;

end;

procedure TFrmMain.SaveToBitmap1Click(Sender: TObject);
var
  i, j, xx, yy, idx, m, nIdx: integer;
  bmp: TBitmap;
  JPG: TJPEGImage;
begin
  bmp := TBitmap.Create;
  m := 8;
  bmp.Width := MapWidth * UNITX div m;
  bmp.Height := MapHeight * UNITY div m;

  for j := 0 to MapHeight - 1 do
    for i := 0 to MapWidth - 1 do begin
      idx := GetBkImg(i, j);
      nIdx := GetBkIndex(i, j);
      if (i mod 2 = 0) and (j mod 2 = 0) then begin
        xx := i * UNITX div m;
        yy := j * UNITY div m;
        if idx >= 0 then begin
          try
            WilTiles[nIdx].DrawZoom(bmp.Canvas, xx, yy, idx, 1 / m);
          except
            ShowMessage(Format('Tiles[%d] = X:%d, Y:%D', [GetBkIndex(i, j), i, j]));
            Exit;
          end;
        end;
      end;
    end;

  for j := 0 to MapHeight - 1 do
    for i := 0 to MapWidth - 1 do begin
      idx := GetMidImg(i, j);
      nIdx := GetSMIndex(i, j);
      xx := i * UNITX div m;
      yy := j * UNITY div m;
      if idx >= 0 then begin
        try
          WilSmTiles[nIdx].DrawZoomEx(bmp.Canvas, xx, yy, idx, 1 / m, TRUE);
        except
          ShowMessage(Format('SmTiles[%d] = X:%d, Y:%D', [nIdx, i, j]));
          Exit;
        end;
      end;
    end;
  for j := 0 to MapHeight - 1 do
    for i := 0 to MapWidth - 1 do begin
      idx := GetFrImg(i, j);
      xx := i * UNITX div m;
      yy := (j + 1) * UNITY div m;
      if idx >= 0 then begin
        try
          ObjWil(idx).DrawZoomEx(bmp.Canvas, xx, yy, idx mod 65535, 1 / m, FALSE);
        except
          ShowMessage(Format('ObjWil(%d) = X:%d, Y:%D', [idx, i, j]));
          Exit;
        end;
      end;
    end;
  if Sender = nil then begin
    JPG := TJPEGImage.Create;
    JPG.Assign(bmp);
    Jpg.CompressionQuality := 80;
    Jpg.SaveToFile(CurrentMapName + '.bmp');
    JPg.Free;
  end else
    bmp.SaveToFile(CurrentMapName + '.bmp');
  bmp.Free;
end;

procedure TFrmMain.MapScroll1Click(Sender: TObject);
var
  xs, ys, i, k: integer;
  nilmap: TMapInfo;
begin
  CopyTemp;
  FrmScrollMap.Execute(xs, ys);
  FillChar(nilmap, sizeof(TMapInfo), #0);
  if (xs > 0) and (xs < MAXX) then begin
    for i := MAXX downto 0 do
      for k := 0 to MAXY - 1 do begin
        if i - xs > 0 then
          MArr[i, k] := MArr[i - xs, k]
        else
          MArr[i, k] := nilmap;
      end;
  end
  else begin
    for i := 0 to MAXX - 1 do
      for k := 0 to MAXY - 1 do begin
        if i - xs < MAXX - 1 then
          MArr[i, k] := MArr[i - xs, k]
        else
          MArr[i, k] := nilmap;
      end;
  end;
  if (ys > 0) and (ys < MAXY) then begin
    for i := MAXY downto 0 do
      for k := 0 to MAXX - 1 do begin
        if i - ys > 0 then
          MArr[k, i] := MArr[k, i - ys]
        else
          MArr[k, i] := nilmap;
      end;
  end
  else begin
    for i := 0 to MAXY - 1 do
      for k := 0 to MAXX - 1 do begin
        if i - ys < MAXY - 1 then
          MArr[k, i] := MArr[k, i - ys]
        else
          MArr[k, i] := nilmap;
      end;
  end;

  MapPaint.Refresh;
end;

procedure TFrmMain.CellMove1Click(Sender: TObject);
begin
  FrmMoveObj.Execute;
end;

procedure TFrmMain.N10Click(Sender: TObject);
begin
  form1.ShowModal;
end;

type
  TWriteType = packed record
    nX, nY, nWidth, nHeight: Word;
  end;

  TWriteHead = packed record
    nWidth, nHeight: Word;
    nCount: Byte;
  end;

procedure TFrmMain.N11Click(Sender: TObject);
var
  i, j, fhandle: integer;
  header: TMapHeader;
  sStr, sX, sY, sWidth, sHeight: string;
  WriteType: array of TWriteType;
  nX, nY, nWidth, nHeight: Integer;
  WriteHead: TWriteHead;
begin
  if cbb1.Items.Count <= 0 then
    exit;
  with SaveDialog1 do begin
    FileName := '';
    if Execute and (FileName <> '') then begin
      SetLength(WriteType, cbb1.Items.Count);
      for I := 0 to cbb1.Items.Count - 1 do begin
        sStr := cbb1.Items[I];
        sStr := GetValidStr3(sStr, sX, [',']);
        sStr := GetValidStr3(sStr, sY, [',']);
        sStr := GetValidStr3(sStr, sWidth, [',']);
        sStr := GetValidStr3(sStr, sHeight, [',']);
        nX := StrToIntDef(sX, 0);
        nY := StrToIntDef(sY, 0);
        nWidth := StrToIntDef(sWidth, 0);
        nHeight := StrToIntDef(sHeight, 0);
        if (nX > 0) and (nY > 0) and (nWidth > 0) and (nHeight > 0) and ((nX + nWidth) < MapWidth) and ((nY + nHeight) < MapHeight) then begin
          WriteType[I].nX := nX;
          WriteType[I].nY := nY;
          WriteType[I].nWidth := nWidth;
          WriteType[I].nHeight := nHeight;
        end
        else begin
          Application.MessageBox('Êä³öÊý¾ÝÓÐ´íÎó£¡', 'ÌáÊ¾ÐÅÏ¢', MB_OK + MB_ICONSTOP);
          Exit;
        end;

      end;
      WriteHead.nWidth := MapWidth;
      WriteHead.nHeight := MapHeight;
      WriteHead.nCount := Length(WriteType);
      if FileExists(FileName) then
        DeleteFile(FileName);
      fhandle := FileCreate(FileName);
      if fhandle > 0 then begin
        FileWrite(fhandle, WriteHead, sizeof(TWriteHead));
        for I := Low(WriteType) to High(WriteType) do begin
          FileWrite(fhandle, WriteType[I], sizeof(TWriteType));
          for j := WriteType[I].nX to WriteType[I].nX + WriteType[I].nWidth do begin
            FileWrite(fhandle, MArr[j, WriteType[I].nY], Sizeof(TMapInfo) * WriteType[I].nHeight);
          end;
        end;

        //FileWrite (fhandle, WriteHead, sizeof(TWriteHead));
        FileClose(fhandle);
      end;
      {if SaveToFile (FileName) then begin
         CurrentMapName := FileName;
         LbMapName.Caption := ExtractFileNameOnly (FileName);
         Edited := FALSE;
      end;  }
    end;
  end;
  (*header.Width := MapWidth;
  header.Height := MapHeight;
  header.Title := TITLEHEADER;
  if FileExists (flname) then
     fhandle := FileOpen (flname, fmOpenWrite or fmShareDenyNone)
  else fhandle := FileCreate (flname);
  if fhandle > 0 then begin
     FileWrite (fhandle, header, sizeof(TMapHeader));
     for i:=0 to MapWidth-1 do begin
        {for j:=0 to MapHeight-1 do Begin
          if MArr[i,j].Area=7 then Begin
            MArr[i,j].Area:=6;
            MArr[i,j].FrImg:=(MArr[i,j].FrImg and $7fff) + 9999;
          End;
        End;  }
        FileWrite (fhandle, MArr[i,0], sizeof(TMapInfo) * MapHeight);
     end;
     Result := TRUE;
     FileClose (fhandle);
  end; *)

end;

{
procedure TFrmMain.N12Click(Sender: TObject);
var
 i, j, n: integer;
begin
 if not VerifyWork then
   exit;
 if SegmentMode then begin
   ShowMessage('Use Segment Tool');
   exit;
 end;
 with OpenDialog1 do begin
   if Execute then begin
     if LoadFromFileByNew(FileName) then begin
       CurrentMapName := FileName;
       LbMapName.Caption := ExtractFileNameOnly(FileName);
       MapPaint.Width := Round(MapWidth * UNITX * Zoom) + 1;
       MapPaint.Height := Round(MapHeight * UNITY * Zoom) + 1;
       CurX := 0;
       CurY := 0;
       MapPaint.Refresh;
     end;
   end;
 end;
end;    }

procedure TFrmMain.Exit1Click(Sender: TObject);
begin
  Close();
end;

procedure TFrmMain.ext1Click(Sender: TObject);
begin
  MArr[203, 18].FrImg := MArr[203, 18].FrImg and $7FFF;
  MArr[203, 19].FrImg := MArr[203, 19].FrImg and $7FFF;
  MArr[204, 18].FrImg := MArr[204, 18].FrImg and $7FFF;
  MArr[204, 19].FrImg := MArr[204, 19].FrImg and $7FFF;
  MArr[205, 19].FrImg := MArr[205, 19].FrImg and $7FFF;
  MArr[205, 20].FrImg := MArr[205, 20].FrImg and $7FFF;
  MArr[206, 20].FrImg := MArr[206, 20].FrImg and $7FFF;
  MArr[206, 21].FrImg := MArr[206, 21].FrImg and $7FFF;
  MArr[207, 21].FrImg := MArr[207, 21].FrImg and $7FFF;
  MArr[207, 22].FrImg := MArr[207, 22].FrImg and $7FFF;
  MArr[208, 22].FrImg := MArr[208, 22].FrImg and $7FFF;
  MArr[208, 23].FrImg := MArr[208, 23].FrImg and $7FFF;
  MArr[206, 22].FrImg := MArr[206, 22].FrImg and $7FFF;
  {MArr[203,20].FrImg := 0;
  MArr[204,20].FrImg := 0;
  MArr[204,21].FrImg := 0;
  MArr[205,21].FrImg := 0;
  MArr[205,22].FrImg := 0;
  MArr[206,23].FrImg := 0;
  MArr[207,23].FrImg := 0;
  MArr[208,24].FrImg := 0;
  MArr[202,19].FrImg := 0;  }
end;

end.

