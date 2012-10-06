unit EdMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, wmM2Def, wmMyImage, ShellAPI, Clipbrd,  
  StdCtrls, Buttons, mpalett, Menus, ExtCtrls, HUtil32, WIL, DES;

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
  MAXWIL = 15;

  TITLEHEADER = 'Legend of mir';

  XORWORD = $AA38;
  NEWMAPTITLE = 'Map 2010 Ver 1.0';

type
  TMapPrjInfo = packed record
    Ident: string[15];
    ColCount: integer;
    RowCount: integer;
  end;

  TMapDrawMode = (mdTile, mdMiddle, {mdTileDetail, }mdObj, mdObjSet, mdLight, mdDoor);
  TMapBrush = (mbAuto, mbNormal, mbFill, mbFillAttrib, mbAttrib, mbEraser);

  TMapDataFmt = (BkImg, MidImg, FrImg, DoorIndex, DoorOffset, AniFrame, AniTick, Area, light, BkIndex, MidIndex, nInteger1, nInteger2, nInteger3, nWord4);


  TOldMapInfo = packed record
    BkImg: word;
    MidImg: word;
    FrImg: word;
    DoorIndex: byte; //$80 (¹®Â¦), ¹®ÀÇ ½Äº° ÀÎµ¦½º
    DoorOffset: byte; //´ÝÈù ¹®ÀÇ ±×¸²ÀÇ »ó´ë À§Ä¡, $80 (¿­¸²/´ÝÈû(±âº»))
    AniFrame: byte; //$80(Åõ¸í)  ÇÁ·¡ÀÓ ¼ö
    AniTick: byte; //¸î¹ø¿¡ Æ½¸¶´Ù ÇÑ ÇÁ·¡ÀÓ¾¿ ¿òÁ÷ÀÌ´Â°¡
    Area: byte; //Object.WIL ¹øÈ£
    light: byte; //0..1..4 ±¤¿ø È¿°ú
  end;
  pTOldMapInfo = ^TOldMapInfo;

  
  TENMapHeader = packed record
    Title: string[16];
    Reserved: LongWord;
    Width: Word;
    Not1: Word;
    Height: Word;
    Not2: Word;
    Reserved2: array[0..24] of char;
  end;

  TENMapInfo = packed record
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
  PTENMapInfo = ^TENMapInfo;


  TMapInfo = packed record
    case Integer of
      1:(
        BkImg: word;
        MidImg: word;
        FrImg: word;
        DoorIndex: byte; //$80 (¹®Â¦), ¹®ÀÇ ½Äº° ÀÎµ¦½º
        DoorOffset: byte; //´ÝÈù ¹®ÀÇ ±×¸²ÀÇ »ó´ë À§Ä¡, $80 (¿­¸²/´ÝÈû(±âº»))
        AniFrame: byte; //$80(Åõ¸í)  ÇÁ·¡ÀÓ ¼ö
        AniTick: byte; //¸î¹ø¿¡ Æ½¸¶´Ù ÇÑ ÇÁ·¡ÀÓ¾¿ ¿òÁ÷ÀÌ´Â°¡
        Area: byte; //Object.WIL ¹øÈ£
        light: byte; //0..1..4 ±¤¿ø È¿°ú
        BkIndex: Byte;
        MidIndex: Byte;
      );
      2:(
        nInteger1: Integer;
        nInteger2: Integer;
        nInteger3: Integer;
        nWord4: Word;
      );
  end;
  PTMapInfo = ^TMapInfo;

  TMapHeader = packed record
    Width: word;
    Height: word;
    Title: string[15];
    UpdateDate: TDateTime;
    Reserved: array[0..23] of char;
  end;

  ///pTUndoData = ^TUndoData;
  pTUndoMapInfo = ^TUndoMapInfo;
  TUndoMapInfo = packed record
    nX, nY: Word;
    MapInfo: TMapInfo;
  end;

  pTUndoMapData = ^TUndoMapData;
  TUndoMapData = packed record
    nX, nY: Word;
    DataFmt: TMapDataFmt;
    Data: Integer;
  end;

  pTUndoMapInfoArr = ^TUndoMapInfoArr;
  TUndoMapInfoArr = array[0..MAXX * MAXY * 20] of TUndoMapInfo;

  pTUndoMapDataArr = ^TUndoMapDataArr;
  TUndoMapDataArr = array[0..MAXX * MAXY * 20] of TUndoMapData;

  pTUndoInfo = ^TUndoInfo;
  TUndoInfo = packed record
    nMapInfoCount: Integer;
    nMapDataCount: Integer;
    MapInfo: pTUndoMapInfoArr;
    MapData: pTUndoMapDataArr;
  end;

  TMapData = array[0..MAXX + 10, 0..MAXY + 10] of TMapInfo;


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
    Label3: TLabel;
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
    procedure FormDestroy(Sender: TObject);
  private
    RecusionCount: integer;
    FillIndex: integer;
    //MapDataUndo: array[0..0] of TMapData;
    //MapDataUndoIndex: Integer;
    UndoList: TList;
    SetArr: array[0..MAXSET - 1] of TRect;
    StateX, StateY, StopX, StopY: Integer;
    boDown: Boolean;
    procedure ClearSetCursor;
    function DrawSetCursor(xx, yy: integer): Boolean;
    procedure DrawCursor(xx, yy: integer);
    function GetBk(x, y: integer): integer;
    function GetFrMask(x, y: integer): integer;
    function GetLightAddDoor(x, y: integer; var light, door, dooroffset: integer): Boolean;
    function GetAni(x, y: integer): integer;
    procedure SetLight(x, y, value: integer);
    function GetBkImg(x, y: integer): integer;
    function GetBkIndex(x, y: integer): integer;
    function GetMidImg(x, y: integer): integer;
    function GetMidIndex(x, y: integer): integer;
    function GetFrImg(x, y: integer): integer;
    procedure PutTileXY(x, y, idx, index: integer);
    procedure PutMiddleXY(x, y, idx, index: integer);
    function GetBkImgUnit(x, y: integer): integer;
    function GetBkUnit(x, y: integer): integer;
    procedure PutBigTileXY(x, y, idx: integer);
    procedure PutObjXY(x, y, idx: integer);
    function DrawFill(xx, yy: integer; Shift: TShiftState): Boolean;
    function DrawFillAttrib(xx, yy: integer; Shift: TShiftState): Boolean;
    procedure DrawTileDetail(x, y: integer; Shift: TShiftState);
    procedure DrawSmTileDetail(x, y: integer; Shift: TShiftState);
   // procedure DrawNormalTile(x, y: integer; Shift: TShiftState);
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
    procedure DrawOne(x, y, munit, idx, index: integer);
    procedure DrawOneDr(x, y, munit, idx, index: integer);
    procedure DrawObjDr(x, y, idx: integer);
    procedure DrawOrAttr(x, y, mark: integer);
    function GetPoint(idx: integer): integer;
    function VerifyWork: Boolean;
    procedure LoadSegment(col, row: integer; flname: string);
    procedure SaveSegment(col, row: integer; flname: string);
    function GetMapData(x, y: integer): TMapInfo;
    procedure SetMapData(x, y: integer; const Value: TMapInfo);
  public
    MArr: TMapData;
    MapWidth, MapHeight: integer;
    CurX, CurY: integer;
    MainBrush: TMapBrush;
    ImageIndex, ImageIndexIndex, ImageDetail, ImageDetailIndex: integer;
    MiddleIndex, MiddleIndexIndex: integer;
    TileAttrib: integer;
    DrawMode: TMapDrawMode;
    Zoom: Real;
    BoxVisible: Boolean;
    BoxX, BoxY, BoxWidth, BoxHeight: integer;
    CurrentMapName: string;
    Edited: Boolean;
    SegmentMode: Boolean;
    DefMainPalette: TRgbQuads;
    MouseX, MouseY: Integer;
    TempUndoInfo: pTUndoInfo;
    function ObjWil(idx: integer): TWMImages;
    function WilSmTile(idx: integer): TWMImages;
    function WilTile(idx: integer): TWMImages;
    procedure CopyTempBegin;
    procedure CopyTempEnd;
    procedure Undo;
    procedure DisposeUndoInfo(UndoInfo: pTUndoInfo);
    procedure ClearUndo;
    procedure NewMap;
    function LoadFromFile(flname: string): Boolean;
    function SaveToFile(flname: string): Boolean;
    procedure MakeSetCursor(plist: TList);
    procedure DoEditSegment;
    procedure DoSaveSegments;
    procedure SetMapDataEx(x, y: integer; DataFmt: TMapDataFmt; nValue: Integer);
    property MapData[x, y: integer]: TMapInfo read GetMapData write SetMapData;
  end;

var
  FrmMain: TFrmMain;
  BaseDir: string;
  WilTileArr: array[0..9] of TWMImages;
  WilSmTileArr: array[0..9] of TWMImages;
  WilArr: array[0..39] of TWMImages;
  WilCount: Integer;
implementation

uses FObj, ObjEdit, ObjSet, Tile, MapSize, segunit, SmTile, glight, DoorDlg,
  FScrlXY, MoveObj, about;

{$R *.DFM}
{$R ColorTable.RES}

procedure TFrmMain.FormCreate(Sender: TObject);
var
  i: integer;
  Res: TResourceStream;
  //UndoDataArr: pTUndoDataArr;
begin
  Res := TResourceStream.Create(Hinstance, '256RGB', 'RGB');
  try
    Res.Read(DefMainPalette, SizeOf(DefMainPalette));
  finally
    Res.Free;
  end;
  //GetMem(UndoDataArr);
  //ReallocMem(UndoDataArr, );
  TempUndoInfo := nil;
  boDown := False;
  StateX := -1;
  Zoom := 0.4;
  Label1.Caption := '100:' + IntToStr(Round(100 * Zoom));
  ImageIndex := 0;
  ImageDetail := 0;
  ImageDetailIndex := 0;
  BoxVisible := FALSE;
  UndoList := TList.Create;
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

  for i := 0 to 9 do begin
    case i of
      0: begin
          WilTileArr[0] := TWMM2DefImages.Create;
          WilTileArr[0].LibType := ltLoadBmp;
          WilTileArr[0].FileName := 'Tiles.wil';
          WilTileArr[0].m_DefMainPalette := DefMainPalette;
          WilTileArr[0].Initialize;
        end;
      1..5: begin
          WilTileArr[i] := TWMM2DefImages.Create;
          WilTileArr[i].LibType := ltLoadBmp;
          WilTileArr[i].FileName := 'Tiles' + Inttostr(i + 1) + '.wil';
          WilTileArr[i].m_DefMainPalette := DefMainPalette;
          WilTileArr[i].Initialize;
        end;
      6..9: begin
          WilTileArr[i] := TWMMyImageImages.Create;
          WilTileArr[i].LibType := ltLoadBmp;
          WilTileArr[i].FileName := '..\Resource\Data\Tiles' + Inttostr(i - 5) + '.pak';
          WilTileArr[i].Initialize;
        end;
    end;
  end;

  for i := 0 to 9 do begin
    case i of
      0: begin
          WilSmTileArr[0] := TWMM2DefImages.Create;
          WilSmTileArr[0].LibType := ltLoadBmp;
          WilSmTileArr[0].FileName := 'SmTiles.wil';
          WilSmTileArr[0].m_DefMainPalette := DefMainPalette;
          WilSmTileArr[0].Initialize;
        end;
      1..5: begin
          WilSmTileArr[i] := TWMM2DefImages.Create;
          WilSmTileArr[i].LibType := ltLoadBmp;
          WilSmTileArr[i].FileName := 'SmTiles' + Inttostr(i + 1) + '.wil';
          WilSmTileArr[i].m_DefMainPalette := DefMainPalette;
          WilSmTileArr[i].Initialize;
        end;
      6..9: begin
          WilSmTileArr[i] := TWMMyImageImages.Create;
          WilSmTileArr[i].LibType := ltLoadBmp;
          WilSmTileArr[i].FileName := '..\Resource\Data\SmTiles' + Inttostr(i - 5) + '.pak';
          WilSmTileArr[i].Initialize;
        end;
    end;
  end;

  WilCount := 0;
  for i := 0 to 39 do begin
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
  UndoList.Free;
end;

procedure TFrmMain.FormShow(Sender: TObject);
begin
  SpeedButton2Click(self);
  //¼ì²é
  //FrmMainPal.SetImageUnitCount((WilTile(0).ImageCount + UNITBLOCK - 1) div UNITBLOCK);
  //FrmSmTile.SetImageUnitCount((WilSmTiles.ImageCount + MIDDLEBLOCK - 1) div MIDDLEBLOCK);
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
  //FillChar(MapDataUndo, Sizeof(MapDataUndo), #0);
  //MapDataUndoIndex := 0;
  ClearUndo;
  MapPaint.Width := Round(MapWidth * UNITX * Zoom) + 1;
  MapPaint.Height := Round(MapHeight * UNITY * Zoom) + 1;
  CurX := 0;
  CurY := 0;
end;

function TFrmMain.LoadFromFile(flname: string): Boolean;
var
//  sFileName: string;
  aMapFile: TFileStream;
  ENMapHeader: TENMapHeader;
  boENMap, boNewMap: Boolean;
  ENMapData: array of array of TENMapInfo;
  I, j: Integer;
  header: TMapHeader;
  OldMapData: array of array of TOldMapInfo;
begin
  Result := False;
  if not FileExists(flname) then exit;
  aMapFile := TFileStream.Create(flname, fmOpenRead or fmShareDenyNone);
  try
    aMapFile.Read(ENMapHeader, Sizeof(TENMapHeader));
    boENMap := (ENMapHeader.Title = NEWMAPTITLE);
    boNewMap := False;
    if boENMap then begin
      header.Width := ENMapHeader.Width xor XORWORD;
      header.Height := ENMapHeader.Height xor XORWORD;
    end
    else begin
      Move(ENMapHeader, header, SizeOf(header));
      if (header.Title[14] = #$D) and (header.Title[15] = #$A) then
        boNewMap := True;
      aMapFile.Seek(SizeOf(header), 0);
    end;
    MapWidth := header.Width;
    MapHeight := header.Height;
    FillChar(MArr, SizeOf(MArr), #0);
    //FillChar(MapDataUndo, SizeOf(MapDataUndo), #0);
    //MapDataUndoIndex := 0;
    ClearUndo;
    if (MapWidth <= 1000) and (MapHeight <= 1000) then begin
      if boENMap then begin
        SetLength(ENMapData, MapWidth, MapHeight);
        for i := 0 to MapWidth - 1 do begin
          aMapFile.Read(ENMapData[i, 0], SizeOf(TENMapInfo) * MapHeight);
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
            MArr[i, j].BkIndex := 0;
            MArr[i, j].MidIndex := 0;
          end;
        end;
        ENMapData := nil;
      end
      else
      if boNewMap then begin
        for i := 0 to MapWidth - 1 do
          aMapFile.Read(MArr[i, 0], sizeof(TMapInfo) * MapHeight);
      end else begin
        SetLength(OldMapData, MapWidth, MapHeight);
        for i := 0 to MapWidth - 1 do begin
          aMapFile.Read(OldMapData[i, 0], sizeof(TOldMapInfo) * MapHeight);
          for j := 0 to MapHeight - 1 do begin
            Move(OldMapData[i, j], MArr[i, j], SizeOf(TOldMapInfo));
          end;

        end;
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
    0..39:
      Result := WilArr[(idx div 65535)];
  end;
end;

procedure TFrmMain.CopyTempBegin;
begin
  if TempUndoInfo <> nil then begin
    DisposeUndoInfo(TempUndoInfo);
    Dispose(TempUndoInfo);
    TempUndoInfo := nil;
  end;
  New(TempUndoInfo);
  TempUndoInfo.nMapInfoCount := 0;
  TempUndoInfo.nMapDataCount := 0;
  TempUndoInfo.MapInfo := nil;
  TempUndoInfo.MapData := nil;
end;

procedure TFrmMain.CopyTempEnd;
begin
  if (TempUndoInfo <> nil) then begin
    if (TempUndoInfo.nMapInfoCount > 0) or (TempUndoInfo.nMapDataCount > 0) then begin
      if UndoList.Count >= 30 then begin
        DisposeUndoInfo(pTUndoInfo(UndoList[0]));
        Dispose(pTUndoInfo(UndoList[0]));
        UndoList.Delete(0);
      end;
      UndoList.Add(TempUndoInfo);
    end else begin
      DisposeUndoInfo(TempUndoInfo);
      Dispose(TempUndoInfo);
    end;
    TempUndoInfo := nil;
  end;
end;

procedure TFrmMain.Undo;
var
  UndoInfo: pTUndoInfo;
  I: Integer;
begin
  CopyTempEnd;
  if UndoList.Count > 0 then begin
    UndoInfo := UndoList[UndoList.Count - 1];
    Try
      if (UndoInfo.nMapInfoCount > 0) and (UndoInfo.MapInfo <> nil) then begin
        for I := UndoInfo.nMapInfoCount - 1 downto 0 do begin
          MapData[UndoInfo.MapInfo[I].nX, UndoInfo.MapInfo[I].nY] := UndoInfo.MapInfo[I].MapInfo;
        end;
      end;
      if (UndoInfo.nMapDataCount > 0) and (UndoInfo.MapData <> nil) then begin
        for I := UndoInfo.nMapDataCount - 1 downto 0 do begin
          SetMapDataEx(UndoInfo.MapData[I].nX, UndoInfo.MapData[I].nY, UndoInfo.MapData[I].DataFmt, UndoInfo.MapData[I].Data);
        end;
      end;
      MapPaint.Refresh;
    Finally
      DisposeUndoInfo(UndoInfo);
      Dispose(UndoInfo);
      UndoList.Delete(UndoList.Count - 1);
    End; 
  end;
end;

function TFrmMain.SaveToFile(flname: string): Boolean;
var
  i, {j, }fhandle: integer;
  header: TMapHeader;
  {WriteBuffer, DataBuffer: PChar;
  nLength: Integer;  }
begin
  Result := False;
  FillChar(header, SizeOf(Header), #0);
  header.Width := MapWidth;
  header.Height := MapHeight;
  header.Title := TITLEHEADER + #13 + #10;
  header.UpdateDate := Now();
  header.Reserved[0] := #2;
  header.Reserved[1] := #1;
  if FileExists(flname) then
    fhandle := FileOpen(flname, fmOpenWrite or fmShareDenyNone)
  else
    fhandle := FileCreate(flname);
  if fhandle > 0 then begin
    FileWrite(fhandle, header, sizeof(TMapHeader));
    {nLength := (Sizeof(TMapInfo) * MapHeight) div 8 * 8 + 8;
    GetMem(DataBuffer, nLength);
    GetMem(WriteBuffer, nLength);
    Try  }
    for i := 0 to MapWidth - 1 do begin
      {for j := 0 to MapHeight - 1 do begin
        if MapData[i, j].Area = 7 then begin
          MapData[i, j].Area := 6;
          MapData[i, j].FrImg := (MapData[i, j].FrImg and $7FFF) + 9999;
        end;
      end; }
      //Move(MapData[i, 0], DataBuffer^, Sizeof(TMapInfo) * MapHeight);
      FileWrite(fhandle, MArr[i, 0], Sizeof(TMapInfo) * MapHeight);
    end;
    {Finally
      FreeMem(DataBuffer);
      FreeMem(WriteBuffer);
    End;  }
    Result := TRUE;
    FileClose(fhandle);
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

procedure TFrmMain.ClearUndo;
var
  I: Integer;
  UndoInfo: pTUndoInfo;
begin
  for I := 0 to UndoList.Count - 1 do begin
    UndoInfo := UndoList[I];
    DisposeUndoInfo(UndoInfo);
    Dispose(UndoInfo);
  end;
  UndoList.Clear;
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

procedure TFrmMain.SetMapData(x, y: integer; const Value: TMapInfo);
begin
  if (x >= 0) and (x < MAXX - 1) and (y >= 0) and (y < MAXY - 1) then begin
    if TempUndoInfo <> nil then begin
      if (TempUndoInfo.nMapInfoCount <= 0) or (TempUndoInfo.MapInfo = nil) then begin
        TempUndoInfo.nMapInfoCount := 1;
        GetMem(TempUndoInfo.MapInfo, SizeOf(TUndoMapInfo) * TempUndoInfo.nMapInfoCount);
      end else begin
        Inc(TempUndoInfo.nMapInfoCount);
        ReallocMem(TempUndoInfo.MapInfo, SizeOf(TUndoMapInfo) * TempUndoInfo.nMapInfoCount);
      end;
      TempUndoInfo.MapInfo[TempUndoInfo.nMapInfoCount - 1].nX := x;
      TempUndoInfo.MapInfo[TempUndoInfo.nMapInfoCount - 1].nY := y;
      TempUndoInfo.MapInfo[TempUndoInfo.nMapInfoCount - 1].MapInfo := MArr[x, y];
    end;
    MArr[x, y] := Value;
  end;
end;

procedure TFrmMain.SetMapDataEx(x, y: integer; DataFmt: TMapDataFmt; nValue: Integer);
begin
  if (x >= 0) and (x < MAXX - 1) and (y >= 0) and (y < MAXY - 1) then begin
    if TempUndoInfo <> nil then begin
      if (TempUndoInfo.nMapDataCount <= 0) or (TempUndoInfo.MapData = nil) then begin
        TempUndoInfo.nMapDataCount := 1;
        GetMem(TempUndoInfo.MapData, SizeOf(TUndoMapData) * TempUndoInfo.nMapDataCount);
      end else begin
        Inc(TempUndoInfo.nMapDataCount);
        ReallocMem(TempUndoInfo.MapData, SizeOf(TUndoMapData) * TempUndoInfo.nMapDataCount);
      end;
      TempUndoInfo.MapData[TempUndoInfo.nMapDataCount - 1].nX := x;
      TempUndoInfo.MapData[TempUndoInfo.nMapDataCount - 1].nY := y;
      TempUndoInfo.MapData[TempUndoInfo.nMapDataCount - 1].DataFmt := DataFmt;
      case DataFmt of
        BkImg: TempUndoInfo.MapData[TempUndoInfo.nMapDataCount - 1].Data := MArr[x, y].BkImg;
        MidImg: TempUndoInfo.MapData[TempUndoInfo.nMapDataCount - 1].Data := MArr[x, y].MidImg;
        FrImg: TempUndoInfo.MapData[TempUndoInfo.nMapDataCount - 1].Data := MArr[x, y].FrImg;
        DoorIndex: TempUndoInfo.MapData[TempUndoInfo.nMapDataCount - 1].Data := MArr[x, y].DoorIndex;
        DoorOffset: TempUndoInfo.MapData[TempUndoInfo.nMapDataCount - 1].Data := MArr[x, y].DoorOffset;
        AniFrame: TempUndoInfo.MapData[TempUndoInfo.nMapDataCount - 1].Data := MArr[x, y].AniFrame;
        AniTick: TempUndoInfo.MapData[TempUndoInfo.nMapDataCount - 1].Data := MArr[x, y].AniTick;
        Area: TempUndoInfo.MapData[TempUndoInfo.nMapDataCount - 1].Data := MArr[x, y].Area;
        light: TempUndoInfo.MapData[TempUndoInfo.nMapDataCount - 1].Data := MArr[x, y].light;
        BkIndex: TempUndoInfo.MapData[TempUndoInfo.nMapDataCount - 1].Data := MArr[x, y].BkIndex;
        MidIndex: TempUndoInfo.MapData[TempUndoInfo.nMapDataCount - 1].Data := MArr[x, y].MidIndex;
        nInteger1: TempUndoInfo.MapData[TempUndoInfo.nMapDataCount - 1].Data := MArr[x, y].nInteger1;
        nInteger2: TempUndoInfo.MapData[TempUndoInfo.nMapDataCount - 1].Data := MArr[x, y].nInteger2;
        nInteger3: TempUndoInfo.MapData[TempUndoInfo.nMapDataCount - 1].Data := MArr[x, y].nInteger3;
        nWord4: TempUndoInfo.MapData[TempUndoInfo.nMapDataCount - 1].Data := MArr[x, y].nWord4;
      end;
    end;
    case DataFmt of
      BkImg: MArr[x, y].BkImg := nValue;
      MidImg: MArr[x, y].MidImg := nValue;
      FrImg: MArr[x, y].FrImg := nValue;
      DoorIndex: MArr[x, y].DoorIndex := nValue;
      DoorOffset: MArr[x, y].DoorOffset := nValue;
      AniFrame: MArr[x, y].AniFrame := nValue;
      AniTick: MArr[x, y].AniTick := nValue;
      Area: MArr[x, y].Area := nValue;
      light: MArr[x, y].light := nValue;
      BkIndex: MArr[x, y].BkIndex := nValue;
      MidIndex: MArr[x, y].MidIndex := nValue;
      nInteger1: MArr[x, y].nInteger1 := nValue;
      nInteger2: MArr[x, y].nInteger2 := nValue;
      nInteger3: MArr[x, y].nInteger3 := nValue;
      nWord4: MArr[x, y].nWord4 := nValue;
    end;
  end;
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
  if (ssAlt in Shift) and (ssCtrl in Shift) then begin
    if StateX = -1 then begin

      StateX := xx;
      StateY := yy;
    end;
    //boDown := True;
    Exit;
  end;

  if MainBrush = mbEraser then begin
    CopyTempBegin;
    DrawEraser(xx, yy, Shift);
    CopyTempEnd;
    exit;
  end;

  //StateX, StateY, StopX, StopY: Integer;
  if MainBrush = mbAttrib then begin
    CopyTempBegin;
    DrawXorAttrib(xx, yy, Button, Shift);
    CopyTempEnd;
    exit;
  end;
  if (DrawMode = mdTile) and (MainBrush = mbFillAttrib) then begin
    RecusionCount := 0;
    CopyTempBegin;
    DrawFillAttrib(xx, yy, Shift);
    CopyTempEnd;
    Edited := TRUE;
  end;
  if mbLeft = Button then begin
    case DrawMode of
      mdTile:
        case MainBrush of
          mbAuto: begin
              xx := xx div 4 * 4;
              yy := yy div 4 * 4;
              CopyTempBegin;
              DrawAutoTile(xx, yy, Shift);
              CopyTempEnd;
              Edited := TRUE;
            end;
          mbNormal: begin
              CopyTempBegin;
              DrawTileDetail(xx, yy, Shift);
              CopyTempEnd;
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
              CopyTempBegin;
              DrawFill(xx, yy, Shift);
              CopyTempEnd;
              Edited := TRUE;
            end;
        end;
      mdMiddle:
        case MainBrush of
          mbAuto: begin
              CopyTempBegin;
              DrawAutoMiddleTile(xx, yy, Shift);
              CopyTempEnd;
              Edited := TRUE;
            end;
          mbNormal: begin
              CopyTempBegin;
              DrawSmTileDetail(xx, yy, Shift);
              CopyTempEnd;
              //DrawNormalTile (xx, yy, Shift);
              Edited := TRUE;
            end;
        end;
      //mdTileDetail: begin
          //CopyTemp;
          //DrawTileDetail (xx, yy, Shift);
          //Edited := TRUE;
       // end;
      mdObj: begin
          CopyTempBegin;
          DrawObject(xx, yy, Shift);
          CopyTempEnd;
          Edited := TRUE;
        end;
      mdObjSet: begin
          CopyTempBegin;
          DrawObjectSet(xx, yy, Shift);
          CopyTempEnd;
          Edited := TRUE;
        end;
      mdLight: begin
          CopyTempBegin;
          if ssAlt in Shift then
            UpdateLight(xx, yy)
          else
            AddLight(xx, yy);
          CopyTempEnd;
          Edited := TRUE;
        end;
      mdDoor: begin
          CopyTempBegin;
          UpdateDoor(xx, yy);
          CopyTempEnd;
          Edited := TRUE;
        end;
    end;
  end;
end;

procedure TFrmMain.MapPaintMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  xx, yy: integer;
  plist: TList;
  nx, ny: Integer;
  P: PTPieceInfo;
  boCreate: Boolean;
begin
  xx := Trunc(word(X) / UNITX / Zoom);
  yy := Trunc(word(Y) / UNITY / Zoom);
  if(ssAlt in Shift) and (ssCtrl in Shift) then begin
    StopX := xx div 2 * 2;
    StopY := yy div 2 * 2;
    StateX := StateX div 2 * 2;
    StateY := StateY div 2 * 2;
    if (StopX > StateX) and (StopY > StateY) then begin
      FrmObjSet.Execute;
      FrmObjSet.GetSet(FrmObjSet.SetGrid.RowCount - 1, plist);
      if plist = nil then begin
        boCreate := True;
        plist := TList.Create;
      end else begin
        boCreate := False;
        for nx := 0 to plist.Count - 1 do
          Dispose(PTPieceInfo(plist[nx]));
        plist.Clear;
      end;
      for ny := StateY to StopY do begin
        for nx := StateX to StopX do begin
          if (nX >= 0) and (nX < MAXX - 1) and (nY >= 0) and (nY < MAXY - 1) then begin
            New(P);
            FillChar(P^, SizeOf(TPieceInfo), #0);
            p.rx := nX - StateX;
            p.ry := nY - StateY;
            if (nX mod 2 = 0) and (nY mod 2 = 0) then begin
              p.bkimg := GetBkImg(nx, ny);
              p.bkindex := MapData[nx, ny].BkIndex;
            end else begin
              p.bkimg := -1;
            end;
            p.midimg := MapData[nx, ny].MidImg - 1;
            p.midindex := MapData[nx, ny].MidIndex;
            p.img := GetFrImg(nX, nY);
            DrawObjDr(xx + p.rx, yy + p.ry, p.img);
            if MapData[nx, ny].BkImg and $8000 > 0 then
              p.mark := p.mark or $01;
            if MapData[nx, ny].FrImg and $8000 > 0 then
              p.mark := p.mark or $02;
            p.AniFrame := MapData[nX, nY].AniFrame and $7F;
            p.Blend := ((MapData[nX, nY].AniFrame and $80) > 0);
            p.AniTick := MapData[nX, nY].AniTick;
            p.light := MapData[nX, nY].Light;
            p.DoorIndex := MapData[nX, nY].DoorIndex;
            p.DoorOffset := MapData[nX, nY].DoorOffset;
            plist.Add(P);
          end;
        end;
      end;
      FrmObjEdit.SetPieceList(plist);
      if boCreate then plist.Free;
      if FrmObjEdit.Execute then begin
        plist := TList.Create;
        FrmObjEdit.DuplicatePieceList(plist);
        FrmObjSet.UpdateSet(FrmObjSet.SetGrid.RowCount - 1, plist);
      end;

    end;
  end;
  StateX := -1;
end;
  {

  rx: integer;
    ry: integer;
    bkimg: integer; //-1:none
    img: integer; //-1:none
    aniframe: byte; //0ÀÌ»óÀÌ¸é ¿¡´Ï¸ÞÀÌ¼Ç µÊ
    anitick: byte; //
    blend: Boolean;
    light: byte; //ºûÀÇ ¹à±â
    doorindex: byte; //¹®À» ½Äº°ÇÏ±âÀ§ÇÔ 0º¸´Ù Å©¸é ¹®.  $80ÀÌ¸é ¹®À» ¿­¼ö ÀÖ´Â °÷
    dooroffset: byte; //´ÝÇôÁø ±×¸²À» ½Äº°ÇÏ±â À§ÇÔ
    mark: byte; //0: none, 1:Bk, 2:Fr, 3:Bk & Fr
    bkindex: byte;
    midimg: Integer;
    midindex: byte;
   if (p.rx + xx >= 0) and (p.ry + yy >= 0) then begin
          if p.bkimg >= 0 then begin
            ix := xx div 2 * 2;
            iy := yy div 2 * 2;
            MapData[p.rx + ix, p.ry + iy].BkImg := p.bkimg + 1;
            MapData[p.rx + ix, p.ry + iy].BkIndex := p.bkindex;
            DrawCellBk(p.rx + ix, p.ry + iy, 1, 1);
          end;
          if p.midimg >= 0 then begin
            MapData[p.rx + xx, p.ry + yy].MidImg := p.midimg + 1;
            MapData[p.rx + xx, p.ry + yy].MidIndex := p.midindex;
            DrawCellBk(p.rx + xx, p.ry + yy, 1, 1);
          end;
          if p.img >= 0 then
            DrawObjDr(xx + p.rx, yy + p.ry, p.img);
          if p.mark > 0 then
            DrawORAttr(xx + p.rx, yy + p.ry, p.mark);
          if p.Blend then
            MapData[xx + p.rx, yy + p.ry].AniFrame := $80 or p.AniFrame
          else
            MapData[xx + p.rx, yy + p.ry].AniFrame := p.AniFrame;
          MapData[xx + p.rx, yy + p.ry].AniTick := p.AniTick;
          if p.light > 0 then
            MapData[xx + p.rx, yy + p.ry].Light := p.light;
          if p.DoorIndex > 0 then begin
            MapData[xx + p.rx, yy + p.ry].DoorIndex := p.DoorIndex;
            MapData[xx + p.rx, yy + p.ry].DoorOffset := p.DoorOffset;
          end;
        end;
 if (MouseX >= 0) and (MouseX < MAXX - 1) and (MouseY >= 0) and (MouseY < MAXY - 1) then begin
          Clipboard := TClipboard.Create;
          Try
            AsText := Clipboard.AsText;
            if AsText <> '' then begin
              AsText := GetValidStr3(AsText, s1, ['/']);
              AsText := GetValidStr3(AsText, s2, ['/']);
              AsText := GetValidStr3(AsText, s3, ['/']);
              AsText := GetValidStr3(AsText, s4, ['/']);
              CopyTemp;
              MapData[MouseX, MouseY].nInteger1 := StrToIntDef(s1, 0);
              MapData[MouseX, MouseY].nInteger2 := StrToIntDef(s2, 0);
              MapData[MouseX, MouseY].nInteger3 := StrToIntDef(s3, 0);
              MapData[MouseX, MouseY].nWord4 := StrToIntDef(s4, 0);
              Edited := TRUE;
              MapPaint.Repaint;
            end;
          Finally
            Clipboard.Free;
          End;
        end;}

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
  MouseX := xx;
  MouseY := yy;

  if MainBrush = mbAttrib then begin
    button := mbMiddle;
    if ssLeft in Shift then
      button := mbLeft;
    if ssRight in Shift then
      button := mbRight;
    CopyTempBegin;
    DrawXorAttrib(xx, yy, Button, Shift);
    CopyTempEnd;
    exit;
  end;
  if MainBrush = mbEraser then begin
    if ssLeft in Shift then begin
      CopyTempBegin;
      DrawEraser(xx, yy, Shift);
      CopyTempEnd;
    end;
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
                CopyTempBegin;
                DrawAutoMiddleTile(xx, yy, Shift);
                CopyTempEnd;
                Edited := TRUE;
              end;
            end;
        end;
      {mdTileDetail:
        ;   }
      mdObjSet:
        ;
      mdObj:
        ;
    end;
  end;

  if Segmentmode then begin
    LbXY.Caption := IntToStr(xx + FrmSegment.Offsx) + ' : ' + IntToStr(yy + FrmSegment.OffsY);
    //    Label3.Caption:=inttostr(MapData[xx + FrmSegment.Offsx,yy + FrmSegment.OffsY].Area)+'('+inttostr(MapData[xx + FrmSegment.Offsx,yy + FrmSegment.OffsY].FrImg mod $7fff)+')';
  end
  else begin
    LbXY.Caption := IntToStr(xx) + ' : ' + IntToStr(yy);
    //    Label3.Caption:=inttostr(MapData[xx ,yy ].Area)+'('+inttostr(MapData[xx,yy ].FrImg mod $7fff)+')'+inttostr(MapData[xx ,yy ].Area)+'('+inttostr(MapData[xx,yy ].BkImg mod $7fff)+')'+inttostr(MapData[xx ,yy ].Area)+'('+inttostr(MapData[xx,yy ].MidImg )+')'+'Light:('+Inttostr(MapData[xx,yy ].light)+')'+'AniFrame:('+Inttostr(MapData[xx,yy ].AniFrame)+')'+'AniTick:('+Inttostr(MapData[xx,yy ].AniTick)+')';
    Label3.Caption := Format('Object:%d/%d, Title:%d/%d, SmTitle:%d/%d', [GetFrImg(xx, yy) div 65535, GetFrImg(xx, yy) mod 65535, GetBkImg(xx, yy), GetBkIndex(xx, yy), GetMidImg(xx, yy), GetMidIndex(xx, yy)]);
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
    Result := (MapData[x, y].FrImg and $8000);
  end;
end;

function TFrmMain.GetLightAddDoor(x, y: integer; var light, door, dooroffset: integer): Boolean;
begin
  Result := FALSE;
  if (x >= 0) and (x < MAXX - 1) and (y >= 0) and (y < MAXY - 1) then begin
    light := MapData[x, y].Light;
    door := MapData[x, y].DoorIndex;
    dooroffset := MapData[x, y].DoorOffset;
    Result := TRUE;
  end;
end;

function TFrmMain.GetAni(x, y: integer): integer;
begin
  Result := -1;
  if (x >= 0) and (x < MAXX - 1) and (y >= 0) and (y < MAXY - 1) then begin
    Result := ($7F and MapData[x, y].AniFrame);
  end;
end;

procedure TFrmMain.SetLight(x, y, value: integer);
begin
  if (x >= 0) and (x < MAXX - 1) and (y >= 0) and (y < MAXY - 1) then begin
    SetMapDataEx(x, y, Light, value);
  end;
end;

function TFrmMain.GetBk(x, y: integer): integer;
begin
  Result := -1;
  if (x >= 0) and (x < MAXX - 1) and (y >= 0) and (y < MAXY - 1) then begin
    Result := MapData[x, y].BkImg;
  end;
end;

function TFrmMain.GetFrImg(x, y: integer): integer;
begin
  Result := -1;
  if (x >= 0) and (x < MAXX - 1) and (y >= 0) and (y < MAXY - 1) then begin
    Result := MapData[x, y].Area * 65535 + (MapData[x, y].FrImg and $7FFF) - 1;
  end;
end;

function TFrmMain.GetBkImg(x, y: integer): integer;
begin
  Result := -1;
  if (x >= 0) and (x < MAXX - 1) and (y >= 0) and (y < MAXY - 1) then begin
    Result := (MapData[x, y].BkImg and $7FFF) - 1;
  end;
end;

function TFrmMain.GetBkIndex(x, y: integer): integer;
begin
  Result := 0;
  if (x >= 0) and (x < MAXX - 1) and (y >= 0) and (y < MAXY - 1) then begin
    Result := MapData[x, y].BkIndex;
  end;
end;

function TFrmMain.GetMapData(x, y: integer): TMapInfo;
begin
  Result := MArr[MAXX - 1, MAXY - 1];
  if (x >= 0) and (x < MAXX - 1) and (y >= 0) and (y < MAXY - 1) then begin
    Result := MArr[x, y];
  end;
end;

function TFrmMain.GetMidImg(x, y: integer): integer;
begin
  Result := -1;
  if (x >= 0) and (x < MAXX - 1) and (y >= 0) and (y < MAXY - 1) then begin
    Result := MapData[x, y].MidImg - 1;
  end;
end;

function TFrmMain.GetMidIndex(x, y: integer): integer;
begin
  Result := 0;
  if (x >= 0) and (x < MAXX - 1) and (y >= 0) and (y < MAXY - 1) then begin
    Result := MapData[x, y].MidIndex;
  end;
end;

procedure TFrmMain.PutTileXY(x, y, idx, index: integer);
var
  bimg: integer;
begin
  if (x >= 0) and (x < MAXX) and (y >= 0) and (y < MAXY) then begin
    bimg := (MapData[x, y].BkImg and $8000) + idx;
    SetMapDataEx(x, y, BkImg, bimg);
    SetMapDataEx(x, y, BkIndex, index);
  end;
end;

procedure TFrmMain.PutMiddleXY(x, y, idx, index: integer);
begin
  if (x >= 0) and (x < MAXX) and (y >= 0) and (y < MAXY) then begin
    SetMapDataEx(x, y, MidImg, idx);
    SetMapDataEx(x, y, MidIndex, index);
  end;
end;

function TFrmMain.GetBkImgUnit(x, y: integer): integer;
begin
  Result := -1;
  if (x >= 0) and (x < MAXX - 1) and (y >= 0) and (y < MAXY - 1) then begin
    Result := ((MapData[x, y].BkImg and $7FFF) - 1) mod UNITBLOCK;
  end;
end;

function TFrmMain.GetBkUnit(x, y: integer): integer;
begin
  Result := -1;
  if (x >= 0) and (x < MAXX - 1) and (y >= 0) and (y < MAXY - 1) then begin
    Result := ((MapData[x, y].BkImg and $7FFF) - 1) div UNITBLOCK;
  end;
end;

procedure TFrmMain.PutBigTileXY(x, y, idx: integer);
var
  bimg: integer;
begin
  if (x >= 0) and (x < MAXX - 1) and (y >= 0) and (y < MAXY - 1) then begin
    //if TileAttrib = 0 then bimg := idx
    //else bimg := $8000 or idx;
    bimg := (MapData[x, y].BkImg and $8000) + idx;
    SetMapDataEx(x, y, BkImg, bimg);
    bimg := (MapData[x + 1, y].BkImg and $8000) + idx;
    SetMapDataEx(x + 1, y, BkImg, bimg);
    bimg := (MapData[x, y + 1].BkImg and $8000) + idx;
    SetMapDataEx(x, y + 1, BkImg, bimg);
    bimg := (MapData[x + 1, y + 1].BkImg and $8000) + idx;
    SetMapDataEx(x + 1, y + 1, BkImg, bimg);
  end;
end;

procedure TFrmMain.PutObjXY(x, y, idx: integer);
var
  bimg: integer;
begin
  if (x >= 0) and (x < MAXX - 1) and (y >= 0) and (y < MAXY - 1) then begin
    bimg := (MapData[x, y].FrImg and $8000) + idx mod 65535;
    SetMapDataEx(x, y, FrImg,  bimg);
    SetMapDataEx(x, y, Area,  idx div 65535);
  end;
end;

function TFrmMain.DrawFill(xx, yy: integer; Shift: TShiftState): Boolean;
var
  img, idx, un{, drimg}: integer;
  x, y: Integer;
begin
  Result := False;
  for y := 0 to MapHeight - 1 do begin
    if (y mod 2) <> 0 then Continue;
    for x := 0 to MapWidth - 1 do begin
      if (x mod 2 <> 0) then Continue;
      img := GetBkImg(x, y);
      idx := img mod UNITBLOCK;
      if img >= 0 then
        un := img div UNITBLOCK
      else
        un := -1;
      if (un = FillIndex) and (((idx >= 0) and (idx < 5)) or (idx = 99) or (idx = -1)) then begin
        if un <> ImageIndex then begin
          DrawOneDr(x, y, ImageIndex, Random(5), ImageIndexIndex);
        end;
      end;
    end;
  end;
end;

function TFrmMain.DrawFillAttrib(xx, yy: integer; Shift: TShiftState): Boolean;
{var
  img, idx, un, drimg,  }
var
  attr, x, y, nSX, nSY, nEX, nEY: integer;
  sStr: string;
begin
  Result := False;
  sStr := InputBox('ÊäÈë¿ò', 'ÇëÊäÈë·¶Î§´óÐ¡(0..900)', '8');
  attr := StrToIntDef(sStr, 0);
  nSX := xx - attr;
  nEX := xx + attr;
  nSY := yy - attr;
  nEY := yy + attr;
  for x := nSX to nEX do begin
    if (x >= 0) and (x < MapWidth) then begin
      for Y := nSY to nEY do begin
        if (Y >= 0) and (Y < MapHeight) then begin
          attr := 0;
          if ssLeft in Shift then
            attr := MapData[x, y].BkImg and $8000;
          if ssRight in Shift then
            attr := MapData[x, y].FrImg and $8000;
          if (attr = 0) then begin
            if ssLeft in Shift then
              SetMapDataEx(x, y, BkImg, MapData[x, y].BkImg or $8000);
            if ssRight in Shift then
              SetMapDataEx(x, y, FrImg, MapData[x, y].FrImg or $8000);
          end;
        end;
      end;
    end;
  end;

  (*Result := False;
  if (RecusionCount < 32) and (xx >= 0) and (yy >= 0) and (xx < MapWidth) and (yy < MapHeight) then begin
    Inc(RecusionCount);
    attr := 0;
    if ssLeft in Shift then
      attr := MapData[xx, yy].BkImg and $8000;
    if ssRight in Shift then
      attr := MapData[xx, yy].FrImg and $8000;
    if (attr = 0) then begin
      if ssLeft in Shift then
        MapData[xx, yy].BkImg := MapData[xx, yy].BkImg or $8000;
      if ssRight in Shift then
        MapData[xx, yy].FrImg := MapData[xx, yy].FrImg or $8000;
      DrawFillAttrib(xx - 1, yy, Shift);
      DrawFillAttrib(xx, yy - 1, Shift);
      DrawFillAttrib(xx + 1, yy, Shift);
      DrawFillAttrib(xx, yy + 1, Shift);
    {end
    else begin
      Dec(RecusionCount);  }
      exit;
    end;
  {end
  else begin
    Dec(RecusionCount); }
    exit;
  end;     *)
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
        //MapData[i, j].BkImg := 0; //MapData[i, j].BkImg and $7FFF;
        if ssAlt in Shift then
          SetMapDataEx(i, j, MidImg, 0)
        else
          SetMapDataEx(i, j, FrImg, 0);
        if ssCtrl in Shift then
          SetMapDataEx(i, j, BkImg, MapData[i, j].BkImg and $7FFF);
        SetMapDataEx(i, j, AniFrame, 0);
        SetMapDataEx(i, j, AniTick, 0);
        SetMapDataEx(i, j, DoorIndex, 0);
        SetMapDataEx(i, j, DoorOffset, 0);
        DrawCellFr(i, j, 0, 0);
      end;
  end
  else begin
    //MapData[xx, yy].BkImg := 0; //MapData[xx, yy].BkImg and $7FFF;
    if ssAlt in Shift then
      SetMapDataEx(xx, yy, MidImg, 0)
    else
      SetMapDataEx(xx, yy, FrImg, 0);
    SetMapDataEx(xx, yy, AniFrame, 0);
    SetMapDataEx(xx, yy, AniTick, 0);
    SetMapDataEx(xx, yy, DoorIndex, 0);
    SetMapDataEx(xx, yy, DoorOffset, 0);
    DrawCellFr(xx, yy, 0, 0);
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
    n := MapData[xx, yy].FrImg and $7FFF;
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
      if p.bkimg >= 0 then begin
        xx := xx div 2 * 2;
        yy := yy div 2 * 2;
      end;
      if p.img >= 0 then begin
        if CheckCollision(xx + p.rx, yy + p.ry) then begin
          Application.MessageBox(PChar(Format('(%d/%d) ÓÐÕÏ°­Îï', [xx + p.rx, yy + p.ry])), 'ÌáÊ¾ÐÅÏ¢', MB_OK + MB_ICONINFORMATION);
          flag := FALSE;
          break;
        end;
      end;
    end;    
    if flag then begin
      for i := 0 to plist.Count - 1 do begin
        p := PTPieceInfo(plist[i]);
        if (p.rx + xx >= 0) and (p.ry + yy >= 0) then begin
          if p.bkimg >= 0 then begin
            ix := xx div 2 * 2;
            iy := yy div 2 * 2;
            SetMapDataEx(p.rx + ix, p.ry + iy, BkImg, p.bkimg + 1);
            SetMapDataEx(p.rx + ix, p.ry + iy, BkIndex, p.bkindex);
            DrawCellBk(p.rx + ix, p.ry + iy, 1, 1);
          end;
          if p.midimg >= 0 then begin
            SetMapDataEx(p.rx + xx, p.ry + yy, MidImg, p.midimg + 1);
            SetMapDataEx(p.rx + xx, p.ry + yy, MidIndex, p.midindex);
            DrawCellBk(p.rx + xx, p.ry + yy, 1, 1);
          end;
          if p.img >= 0 then
            DrawObjDr(xx + p.rx, yy + p.ry, p.img);
          if p.mark > 0 then
            DrawORAttr(xx + p.rx, yy + p.ry, p.mark);
          if p.Blend then
            SetMapDataEx(xx + p.rx, yy + p.ry, AniFrame, $80 or p.AniFrame)
          else
            SetMapDataEx(xx + p.rx, yy + p.ry, AniFrame, p.AniFrame);
          SetMapDataEx(xx + p.rx, yy + p.ry, AniTick, p.AniTick);
          if p.light > 0 then
            SetMapDataEx(xx + p.rx, yy + p.ry, Light, p.light);
          if p.DoorIndex > 0 then begin
            SetMapDataEx(xx + p.rx, yy + p.ry, DoorIndex, p.DoorIndex);
            SetMapDataEx(xx + p.rx, yy + p.ry, DoorOffset, p.DoorOffset);
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
    n := MapData[x, y].Light;
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
    n := MapData[x, y].Light;
    if n > 0 then begin
      n := FrmGetLight.GetValue(n);
      SetMapDataEx(x, y, Light, n);
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
    idx := MapData[x, y].DoorIndex;
    offs := MapData[x, y].DoorOffset;
    if FrmDoorDlg.UpdateEx(idx, offs) then begin
      SetMapDataEx(x, y, DoorIndex, idx);
      SetMapDataEx(x, y, DoorOffset, offs);
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
  idx{, uidx}: integer;
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

procedure TFrmMain.DrawOne(x, y, munit, idx, index: integer);
begin
  if not IsMyUnit(x, y, munit, idx) then begin
    PutTileXY(x, y, munit * UNITBLOCK + idx + 1, index);
    DrawCellBk(x, y, 1, 1);
  end;
end;

procedure TFrmMain.DrawOneDr(x, y, munit, idx, index: integer);
begin
  PutTileXY(x, y, munit * UNITBLOCK + idx + 1, index);
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
      SetMapDataEx(x, y, BkImg, MapData[x, y].BkImg or $8000);
    if (mark and $02) > 0 then
      SetMapDataEx(x, y, FrImg, MapData[x, y].FrImg or $8000);
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
            SetMapDataEx(x, y, BkImg, MapData[x, y].BkImg and $7FFF);
          end
          else
            SetMapDataEx(x, y, BkImg, MapData[x, y].BkImg or $8000);
        end;
        if Button = mbRight then begin // Fr Attrib
          if ssCtrl in Shift then begin
            SetMapDataEx(x, y, FrImg, MapData[x, y].FrImg and $7FFF);
          end
          else
            SetMapDataEx(x, y, FrImg, MapData[x, y].FrImg or $8000);
        end;
      end;
    end;
  end;
end;

procedure TFrmMain.DrawSmTileDetail(x, y: integer; Shift: TShiftState);
begin
  if ssAlt in Shift then begin
    PutMiddleXY(x, y, 0, 0);
    DrawCellBk(x, y, 1, 1);
  end
  else begin
    if MiddleIndex >= 0 then begin
      if not (ssCtrl in Shift) then begin
        PutMiddleXY(x, y, MiddleIndex + 1, MiddleIndexIndex);
        DrawCellBk(x, y, 1, 1);
      end
      else begin
        PutMiddleXY(x, y, (MiddleIndex + 1), MiddleIndexIndex); // xor $8000);
        DrawCellBk(x, y, 1, 1);
      end;
    end;
  end;
end;

procedure TFrmMain.DrawTileDetail(x, y: integer; Shift: TShiftState);
{var
  bimg: integer;    }
begin
  x := x div 2 * 2;
  y := y div 2 * 2;
  ImageDetail := FrmTile.GetCurrentImageIndex;
  ImageDetailIndex := FrmTile.GetCurrentFileIndex;
  if ssAlt in Shift then begin
    PutTileXY(x, y, 0, 0);
    DrawCellBk(x, y, 1, 1);
  end
  else begin
    if ImageDetail >= 0 then begin
      if not (ssCtrl in Shift) then begin
        PutTileXY(x, y, ImageDetail + 1, ImageDetailIndex);
        DrawCellBk(x, y, 1, 1);
      end
      else begin
        PutTileXY(x, y, (ImageDetail + 1), ImageDetailIndex); // xor $8000);
        DrawCellBk(x, y, 1, 1);
      end;
    end;
  end;
end;
 {
procedure TFrmMain.DrawNormalTile(x, y: integer; Shift: TShiftState);
var
  bimg: integer;
begin
  x := x div 2 * 2;
  y := y div 2 * 2;
  if (ssLeft in Shift) and not (ssAlt in Shift) then begin
    PutTileXY(x, y, ImageIndex * UNITBLOCK + Random(5) + 1, ImageIndexIndex);
    DrawCellBk(x, y, 1, 1);
  end;
  if ssAlt in Shift then begin
    PutTileXY(x, y, 0, 0);
    DrawCellBk(x, y, 1, 1);
  end;
end;    }

procedure TFrmMain.DrawAutoTile(x, y: integer; Shift: TShiftState);
  procedure DrawSide(x, y: integer);
  var
    {idx, }myunit: integer;
  begin
    //idx := GetBkImg (x, y);
    myunit := ImageIndex; //idx div UNITBLOCK;
    DrawOne(x - 2, y, myunit, 10, ImageIndexIndex);
    DrawOne(x, y - 2, myunit, 10, ImageIndexIndex);
    DrawOne(x + 2, y - 2, myunit, 11, ImageIndexIndex);
    DrawOne(x + 4, y, myunit, 11, ImageIndexIndex);
    DrawOne(x - 2, y + 2, myunit, 12, ImageIndexIndex);
    DrawOne(x, y + 4, myunit, 12, ImageIndexIndex);
    DrawOne(x + 4, y + 2, myunit, 13, ImageIndexIndex);
    DrawOne(x + 2, y + 4, myunit, 13, ImageIndexIndex);
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
              DrawOne(xx, yy - 2, myunit, 5, ImageIndexIndex);
              DrawOne(xx - 2, yy, myunit, 5, ImageIndexIndex);
            end;
          11: {//up '\'} begin
              DrawOne(xx, yy - 2, myunit, 6, ImageIndexIndex);
              DrawOne(xx + 2, yy, myunit, 6, ImageIndexIndex);
            end;
          12: {//dn '\'} begin
              DrawOne(xx, yy + 2, myunit, 7, ImageIndexIndex);
              DrawOne(xx - 2, yy, myunit, 7, ImageIndexIndex);
            end;
          13: {//dn '/'} begin
              DrawOne(xx, yy + 2, myunit, 8, ImageIndexIndex);
              DrawOne(xx + 2, yy, myunit, 8, ImageIndexIndex);
            end;
        end;
      end;
    end;
  end;

  procedure SolidBlock(xx, yy, myunit, idx, index: integer);
  var
    //p,
    p1, p2, p3, p4{, p12, p23, p34, p14}: integer;
  begin
//    p := GetPoint(idx);
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
      DrawOneDr(xx, yy, myunit, Random(5), index);
    end;
  end;

  procedure AssemblePuzzle(xx, yy, myunit, idx, index: integer);
  var
    d1, d2, d3, d4: integer;
  begin
    if (idx = 10) then begin
      d1 := GetBkImgUnit(xx, yy + 2);
      if (d1 = 12) or (d1 = 22) then
        DrawOneDr(xx, yy, myunit, 20, index);
      d2 := GetBkImgUnit(xx + 2, yy);
      if (d2 = 11) or (d2 = 16) then
        DrawOneDr(xx, yy, myunit, 15, index);
    end;
    if (idx = 12) then begin
      d1 := GetBkImgUnit(xx, yy - 2);
      if (d1 = 10) or (d1 = 20) then
        DrawOneDr(xx, yy, myunit, 22, index);
      d2 := GetBkImgUnit(xx + 2, yy);
      if (d2 = 13) or (d2 = 18) then
        DrawOneDr(xx, yy, myunit, 17, index);
    end;
    if (idx = 11) then begin
      d1 := GetBkImgUnit(xx, yy + 2);
      if (d1 = 13) or (d1 = 23) then
        DrawOneDr(xx, yy, myunit, 21, index);
      d2 := GetBkImgUnit(xx - 2, yy);
      if (d2 = 10) or (d2 = 15) then
        DrawOneDr(xx, yy, myunit, 16, index);
    end;
    if (idx = 13) then begin
      d1 := GetBkImgUnit(xx, yy - 2);
      if (d1 = 11) or (d1 = 21) then
        DrawOneDr(xx, yy, myunit, 23, index);
      d2 := GetBkImgUnit(xx - 2, yy);
      if (d2 = 12) or (d2 = 17) then
        DrawOneDr(xx, yy, myunit, 18, index);
    end;

    if (idx = 15) then begin
      d1 := GetBkImgUnit(xx + 2, yy);
      if (d1 <> 16) and (d1 <> 11) then
        DrawOneDr(xx, yy, myunit, 10, index);
    end;
    if (idx = 16) then begin
      d1 := GetBkImgUnit(xx - 2, yy);
      if (d1 <> 15) and (d1 <> 10) then
        DrawOneDr(xx, yy, myunit, 11, index);
    end;
    if (idx = 17) then begin
      d1 := GetBkImgUnit(xx + 2, yy);
      if (d1 <> 18) and (d1 <> 13) then
        DrawOneDr(xx, yy, myunit, 12, index);
    end;
    if (idx = 18) then begin
      d1 := GetBkImgUnit(xx - 2, yy);
      if (d1 <> 17) and (d1 <> 12) then
        DrawOneDr(xx, yy, myunit, 13, index);
    end;
    if (idx = 20) then begin
      d1 := GetBkImgUnit(xx, yy + 2);
      if (d1 <> 22) and (d1 <> 12) then
        DrawOneDr(xx, yy, myunit, 10, index);
    end;
    if (idx = 21) then begin
      d1 := GetBkImgUnit(xx, yy + 2);
      if (d1 <> 23) and (d1 <> 13) then
        DrawOneDr(xx, yy, myunit, 11, index);
    end;
    if (idx = 22) then begin
      d1 := GetBkImgUnit(xx, yy - 2);
      if (d1 <> 20) and (d1 <> 10) then
        DrawOneDr(xx, yy, myunit, 12, index);
    end;
    if (idx = 23) then begin
      d1 := GetBkImgUnit(xx, yy - 2);
      if (d1 <> 21) and (d1 <> 11) then
        DrawOneDr(xx, yy, myunit, 13, index);
    end;

    if (idx >= 0) and (idx <= 4) then begin
      d1 := GetBkImgUnit(xx - 2, yy);
      d2 := GetBkImgUnit(xx, yy - 2);
      d3 := GetBkImgUnit(xx + 2, yy);
      d4 := GetBkImgUnit(xx, yy + 2);
      if ((d1 = 11) or (d1 = 16)) and ((d2 = 12) or (d2 = 22)) then
        DrawOneDr(xx, yy, myunit, 10, index);
      if ((d2 = 13) or (d2 = 23)) and ((d3 = 10) or (d3 = 15)) then
        DrawOneDr(xx, yy, myunit, 11, index);
      if ((d3 = 12) or (d3 = 17)) and ((d4 = 11) or (d4 = 21)) then
        DrawOneDr(xx, yy, myunit, 13, index);
      if ((d1 = 13) or (d1 = 18)) and ((d4 = 10) or (d4 = 20)) then
        DrawOneDr(xx, yy, myunit, 12, index);
    end;
    if (GetBkUnit(xx, yy) <> myunit) or (idx = -1) or (idx = 99) then begin
      d1 := GetBkImgUnit(xx - 2, yy);
      d2 := GetBkImgUnit(xx, yy - 2);
      d3 := GetBkImgUnit(xx + 2, yy);
      d4 := GetBkImgUnit(xx, yy + 2);
      if (d4 = 20) and (d3 = 15) then
        DrawOneDr(xx, yy, myunit, 5, index);
      if (d1 = 16) and (d4 = 21) then
        DrawOneDr(xx, yy, myunit, 6, index);
      if (d2 = 23) and (d1 = 18) then
        DrawOneDr(xx, yy, myunit, 8, index);
      if (d3 = 17) and (d2 = 22) then
        DrawOneDr(xx, yy, myunit, 7, index);
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
        SolidBlock(xx, yy, myunit, idx, ImageIndexIndex);
      end;
    end;
    for i := 0 to 6 do begin
      for j := 0 to 6 do begin
        xx := x - 3 * 2 + i * 2;
        yy := y - 3 * 2 + j * 2;
        idx := GetBkImg(xx, yy);
        myunit := ImageIndex; //idx div UNITBLOCK;
        idx := idx mod UNITBLOCK;
        AssemblePuzzle(xx, yy, myunit, idx, ImageIndexIndex);
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
  {diu, di, }changecount, WW, HH: integer;
  rlist: TList;

  function IMG(idx: integer): integer;
  begin
    if idx >= 1 then
      Result := MiddleIndex * MIDDLEBLOCK + idx * 4 + Random(4) + 4 + 1
    else
      Result := MiddleIndex * MIDDLEBLOCK + Random(8) + 1;
  end;
  procedure PutTile(x, y, idx, index: integer);
  var
    i: integer;
    p: pointer;
  begin
    Inc(changecount);
    PutMiddleXY(x, y, idx, index);
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
  {var
    idx: integer;  }
  begin
    if UN(x, y - 1) < 0 then
      PutTile(x, y - 1, IMG(1), MiddleIndexIndex);
    if UN(x + 1, y - 1) < 0 then
      PutTile(x + 1, y - 1, IMG(2), MiddleIndexIndex);
    if UN(x + 1, y) < 0 then
      PutTile(x + 1, y, IMG(3), MiddleIndexIndex);
    if UN(x + 1, y + 1) < 0 then
      PutTile(x + 1, y + 1, IMG(4), MiddleIndexIndex);
    if UN(x, y + 1) < 0 then
      PutTile(x, y + 1, IMG(5), MiddleIndexIndex);
    if UN(x - 1, y + 1) < 0 then
      PutTile(x - 1, y + 1, IMG(6), MiddleIndexIndex);
    if UN(x - 1, y) < 0 then
      PutTile(x - 1, y, IMG(7), MiddleIndexIndex);
    if UN(x - 1, y - 1) < 0 then
      PutTile(x - 1, y - 1, IMG(8), MiddleIndexIndex);
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
                PutTile(i, j, IMG(11), MiddleIndexIndex);
              end;
            n1 := UN(i + 1, j);
            n2 := UN(i, j + 1);
            if UN(i, j) <> 12 then
              if ((n1 = 4) or (n1 = 5) or (n1 = 9)) and ((n2 = 4) or (n2 = 3) or (n2 = 11)) then begin
                PutTile(i, j, IMG(12), MiddleIndexIndex);
              end;
            n1 := UN(i - 1, j);
            n2 := UN(i, j + 1);
            if UN(i, j) <> 9 then
              if ((n1 = 6) or (n1 = 5) or (n1 = 12)) and ((n2 = 6) or (n2 = 7) or (n2 = 10)) then begin
                PutTile(i, j, IMG(9), MiddleIndexIndex);
              end;
            n1 := UN(i, j - 1);
            n2 := UN(i - 1, j);
            if UN(i, j) <> 10 then
              if ((n1 = 8) or (n1 = 7) or (n1 = 9)) and ((n2 = 8) or (n2 = 1) or (n2 = 11)) then begin
                PutTile(i, j, IMG(10), MiddleIndexIndex);
              end;
            // (¤¤)
            n1 := UN(i - 1, j);
            n2 := UN(i + 1, j);
            if UN(i, j) <> 1 then
              if ((n1 = 1) or (n1 = 8) or (n1 = 11)) and ((n2 = 2) or (n2 = 1) or (n2 = 10)) and (UN(i, j - 1) < 0) then begin
                PutTile(i, j, IMG(1), MiddleIndexIndex);
              end;
            n1 := UN(i, j - 1);
            n2 := UN(i, j + 1);
            if UN(i, j) <> 3 then
              if ((n1 = 3) or (n1 = 2) or (n1 = 12)) and ((n2 = 3) or (n2 = 4) or (n2 = 11)) and (UN(i + 1, j) < 0) then begin
                PutTile(i, j, IMG(3), MiddleIndexIndex);
              end;
            n1 := UN(i - 1, j);
            n2 := UN(i + 1, j);
            if UN(i, j) <> 5 then
              if ((n1 = 6) or (n1 = 5) or (n1 = 12)) and ((n2 = 5) or (n2 = 4) or (n2 = 9)) and (UN(i, j + 1) < 0) then begin
                PutTile(i, j, IMG(5), MiddleIndexIndex);
              end;
            n1 := UN(i, j - 1);
            n2 := UN(i, j + 1);
            if UN(i, j) <> 7 then
              if ((n1 = 7) or (n1 = 8) or (n1 = 9)) and ((n2 = 7) or (n2 = 6) or (n2 = 10)) and (UN(i - 1, j) < 0) then begin
                PutTile(i, j, IMG(7), MiddleIndexIndex);
              end;
            // (¤§)
            if UN(i, j) <> 1 then
              if {(UN(i,j-1)=-1) and (UN(i+1,j-1)=-1) and}(UN(i, j + 1) = 0) and (UN(i + 1, j + 1) = 0) then
                if (UN(i, j) = 2) and ((UN(i + 1, j) = 8) or (UN(i + 1, j) = 7)) then
                  PutTile(i, j, IMG(1), MiddleIndexIndex);
            if UN(i, j) <> 3 then
              if {(UN(i+1,j)=-1) and (UN(i+1,j+1)=-1) and}(UN(i - 1, j) = 0) and (UN(i - 1, j + 1) = 0) then
                if (UN(i, j) = 4) and ((UN(i, j + 1) = 2) or (UN(i, j + 1) = 1)) then
                  PutTile(i, j, IMG(3), MiddleIndexIndex);
            if UN(i, j) <> 5 then
              if {(UN(i,j+1)=-1) and (UN(i+1,j+1)=-1) and}(UN(i, j - 1) = 0) and (UN(i + 1, j - 1) = 0) then
                if (UN(i, j) = 4) and ((UN(i + 1, j) = 6) or (UN(i + 1, j) = 7)) then
                  PutTile(i, j, IMG(5), MiddleIndexIndex);
            if UN(i, j) <> 7 then
              if {(UN(i-1,j)=-1) and (UN(i-1,j+1)=-1) and}(UN(i + 1, j) = 0) and (UN(i + 1, j + 1) = 0) then
                if (UN(i, j) = 6) and ((UN(i, j + 1) = 8) or (UN(i, j + 1) = 7)) then
                  PutTile(i, j, IMG(7), MiddleIndexIndex);
            // (¤©)
            if (UN(i - 1, j) = 5) and (UN(i, j - 1) = 3) and (UN(i + 1, j) = 1) and (UN(i, j + 1) = 7) or
              (UN(i - 1, j) = 1) and (UN(i, j + 1) = 3) and (UN(i, j - 1) = 7) and (UN(i + 1, j) = 5) then begin
              PutTile(i, j, IMG(0), MiddleIndexIndex);
              DrawSide(i, j);
            end;
            // (¤±)
            if UN(i, j) = 2 then begin
              if (UN(i + 1, j) > -1) and (UN(i, j + 1) = 0) and (UN(i + 1, j + 1) >= 0) then
                PutTile(i, j, IMG(1), MiddleIndexIndex);
              if (UN(i, j - 1) > -1) and (UN(i - 1, j) = 0) and (UN(i - 1, j - 1) >= 0) then
                PutTile(i, j, IMG(3), MiddleIndexIndex);
            end;
            if UN(i, j) = 4 then begin
              if (UN(i + 1, j) > -1) and (UN(i, j - 1) = 0) and (UN(i + 1, j - 1) >= 0) then
                PutTile(i, j, IMG(5), MiddleIndexIndex);
              if (UN(i, j + 1) > -1) and (UN(i - 1, j) = 0) and (UN(i - 1, j + 1) >= 0) then
                PutTile(i, j, IMG(3), MiddleIndexIndex);
            end;
            if UN(i, j) = 6 then begin
              if (UN(i, j + 1) > -1) and (UN(i + 1, j) = 0) and (UN(i + 1, j + 1) >= 0) then
                PutTile(i, j, IMG(7), MiddleIndexIndex);
              if (UN(i - 1, j) > -1) and (UN(i - 1, j - 1) = 0) and (UN(i, j - 1) >= 0) then
                PutTile(i, j, IMG(5), MiddleIndexIndex);
            end;
            if UN(i, j) = 8 then begin
              if (UN(i, j - 1) > -1) and (UN(i + 1, j) = 0) and (UN(i + 1, j - 1) >= 0) then
                PutTile(i, j, IMG(7), MiddleIndexIndex);
              if (UN(i - 1, j) > -1) and (UN(i, j + 1) = 0) and (UN(i - 1, j + 1) >= 0) then
                PutTile(i, j, IMG(1), MiddleIndexIndex);
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
              PutTile(i, j, IMG(0), MiddleIndexIndex);

          end;
        end;
      end;
  end;
var
  i, k, n{, rx, ry}: integer;
begin
  rlist := TList.Create;
  PutTile(x, y, IMG(0), MiddleIndexIndex);

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
              WilTile(GetBkIndex(xx, yy)).DrawZoom(MapPaint.Canvas, dx, dy, idx, Zoom);
            end
            else
              WilTile(GetBkIndex(xx, yy)).DrawZoom(MapPaint.Canvas, dx, dy, 99, Zoom);
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
                WilSmTile(GetMidIndex(xx, yy)).DrawZoomEx(MapPaint.Canvas, dx, dy, idx, Zoom, TRUE)
              else
                WilSmTile(GetMidIndex(xx, yy)).DrawZoom(MapPaint.Canvas, dx, dy, idx, Zoom)
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
              WilSmTile(0).DrawZoomEx(MapPaint.Canvas, dx, dy, LIGHTSPOT, Zoom, TRUE);
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
  {i, j, }dx, dy, lcorner, tcorner, idx: integer;
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
            WilSmTile(0).DrawZoomEx(MapPaint.Canvas, dx, dy, BKMASK, Zoom, TRUE);
        idx := GetFrMask(x, y);
        if idx > 0 then
          WilSmTile(0).DrawZoomEx(MapPaint.Canvas, dx, dy, FRMASK, Zoom, TRUE);
      end;
    end;

end;

procedure TFrmMain.MapPaintPaint(Sender: TObject);
var
  i, j, xx, yy, dx, dy, lcorner, tcorner, idx, light, door, dooroffs, index: integer;
begin
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
            index := GetBKIndex(xx, yy);
            if (xx mod 2 = 0) and (yy mod 2 = 0) then begin
              xx := Trunc(xx * UNITX * Zoom);
              yy := Trunc(yy * UNITY * Zoom);
              if idx >= 0 then begin
                WilTile(index).DrawZoom(MapPaint.Canvas, xx, yy, idx, Zoom);
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
            index := GetMidIndex(xx, yy);
            xx := Trunc(xx * UNITX * Zoom);
            yy := Trunc(yy * UNITY * Zoom);
            if idx >= 0 then begin
              if MiddleTransparent1.Checked then
                WilSmTile(index).DrawZoomEx(MapPaint.Canvas, xx, yy, idx, Zoom, TRUE)
              else
                WilSmTile(index).DrawZoom(MapPaint.Canvas, xx, yy, idx, Zoom);
            end;
          end;
        end;
      end;

  if ShowObject1.Checked then
    for j := 0 to (Trunc(MapPaint.Height div UNITY / Zoom) + 10) do
      for i := 0 to (Trunc(MapPaint.Width div UNITX / Zoom) + 2) do begin
        xx := i;
        yy := j;
        if (xx >= lcorner - 1) and (yy >= tcorner - 1) and
          (xx <= lcorner + Round(Width div UNITX / Zoom)) and
          (yy <= tcorner + Round(Height div UNITY / Zoom)) then begin
          if (xx >= 0) and (xx < MAXX) and (yy >= 0) and (yy < MAXY) then begin

            if (MapData[xx, yy].Area = 5) and (MapData[xx, yy].FrImg = 12048) then
              idx := GetFrImg(xx, yy)
            else
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
                WilSmTile(0).DrawZoomEx(MapPaint.Canvas, dx, dy, BKMASK, Zoom, TRUE);
            idx := GetFrMask(xx, yy);
            if idx > 0 then
              WilSmTile(0).DrawZoomEx(MapPaint.Canvas, dx, dy, FRMASK, Zoom, TRUE);
            idx := GetAni(xx, yy);
            if idx > 0 then
              MapPaint.Canvas.TextOut(dx, dy, '*');
          end;
          light := 0;
          door := 0;
          dooroffs := 0;
          if GetLightAddDoor(xx, yy, light, door, dooroffs) then begin
            if light > 0 then
              WilSmTile(0).DrawZoomEx(MapPaint.Canvas, dx, dy, LIGHTSPOT, Zoom, TRUE);
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
  FrmTile.CBTitleChange(FrmTile.CBTitle);
  FrmSmTile.CBSmTitleChange(nil);
end;

procedure TFrmMain.SpeedButton2Click(Sender: TObject);
begin
  MainBrush := mbNormal;
  FrmTile.CBTitleChange(FrmTile.CBTitle);
  FrmSmTile.CBSmTitleChange(nil);
end;

procedure TFrmMain.SpeedButton3Click(Sender: TObject);
begin
  MainBrush := mbFill;
  FrmTile.CBTitleChange(FrmTile.CBTitle);
  FrmSmTile.CBSmTitleChange(nil);
end;

procedure TFrmMain.SpeedButton6Click(Sender: TObject);
begin
  MainBrush := mbFillAttrib;
  FrmTile.CBTitleChange(FrmTile.CBTitle);
  FrmSmTile.CBSmTitleChange(nil);
end;

procedure TFrmMain.SpeedButton4Click(Sender: TObject);
begin
  MainBrush := mbAttrib;
  FrmTile.CBTitleChange(FrmTile.CBTitle);
  FrmSmTile.CBSmTitleChange(nil);
end;

procedure TFrmMain.SpeedButton5Click(Sender: TObject);
begin
  MainBrush := mbEraser;
  FrmTile.CBTitleChange(FrmTile.CBTitle);
  FrmSmTile.CBSmTitleChange(nil);
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
var
  Clipboard: TClipboard;
  AsText, s1, s2, s3, s4: string;
begin
  case Key of
    VK_F5:
      MapPaint.Refresh;
    word('z'),
      word('Z'):
      if ssCtrl in Shift then begin
        Undo;
      end;
    word('c'),
      word('C'):
      if ssCtrl in Shift then begin
        if (MouseX >= 0) and (MouseX < MAXX - 1) and (MouseY >= 0) and (MouseY < MAXY - 1) then begin
          Clipboard := TClipboard.Create;
          Try
            Clipboard.AsText := Format('%d/%d/%d/%d', [MapData[MouseX, MouseY].nInteger1, MapData[MouseX, MouseY].nInteger2, MapData[MouseX, MouseY].nInteger3, MapData[MouseX, MouseY].nWord4]);
          Finally
            Clipboard.Free;
          End;
        end;
      end;
    word('v'),
      word('V'):
      if ssCtrl in Shift then begin
        if (MouseX >= 0) and (MouseX < MAXX - 1) and (MouseY >= 0) and (MouseY < MAXY - 1) then begin
          Clipboard := TClipboard.Create;
          Try
            AsText := Clipboard.AsText;
            if AsText <> '' then begin
              AsText := GetValidStr3(AsText, s1, ['/']);
              AsText := GetValidStr3(AsText, s2, ['/']);
              AsText := GetValidStr3(AsText, s3, ['/']);
              AsText := GetValidStr3(AsText, s4, ['/']);
              CopyTempBegin;
              SetMapDataEx(MouseX, MouseY, nInteger1, StrToIntDef(s1, 0));
              SetMapDataEx(MouseX, MouseY, nInteger2, StrToIntDef(s2, 0));
              SetMapDataEx(MouseX, MouseY, nInteger3, StrToIntDef(s3, 0));
              SetMapDataEx(MouseX, MouseY, nWord4, StrToIntDef(s4, 0));
              CopyTempEnd;
              Edited := TRUE;
              MapPaint.Repaint;
            end;
          Finally
            Clipboard.Free;
          End;
        end;
      end;
  end;
end;
 {
 nInteger1: LongWord;
        nInteger2: LongWord;
        nInteger3: LongWord;
        nWord4: Word;
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
    BkIndex: Byte;
    MidIndex: Byte;
  end;
if (x >= 0) and (x < MAXX - 1) and (y >= 0) and (y < MAXY - 1) then begin
    if MapData[x, y].Area = 8 then
      Result := MapData[x, y].Area * 65535 + (MapData[x, y].FrImg and $7FFF) - 1
    else
      Result := MapData[x, y].Area * 65535 + (MapData[x, y].FrImg and $7FFF) - 1;

  end;  }

procedure TFrmMain.Tile1Click(Sender: TObject);
begin
//  FrmMainPal.Show;
  FrmTile.Show;
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
  //FrmTile.Show;
  FrmSmTile.Show;
end;

function TFrmMain.VerifyWork: Boolean;
var
  r: integer;
begin
  Result := TRUE;
  if Edited then begin
    r := Application.MessageBox('ÎÄ¼þÒÑ±»¸üÐÂ£¬ÊÇ·ñ±£´æ£¿', 'ÌáÊ¾ÐÅÏ¢', MB_YESNOCANCEL + MB_ICONQUESTION);

    if r = mrYes then
      if not SegmentMode then
        SaveAs1Click(self)
      else
        DoSaveSegments;
    if r = mrCancel then
      Result := FALSE;
  end;
end;

function TFrmMain.WilSmTile(idx: integer): TWMImages;
begin
  Result := WilSmTileArr[0];
  if idx in [Low(WilSmTileArr)..High(WilSmTileArr)] then
    Result := WilSmTileArr[idx];
end;

function TFrmMain.WilTile(idx: integer): TWMImages;
begin
  Result := WilTileArr[0];
  if idx in [Low(WilTileArr)..High(WilTileArr)] then
    Result := WilTileArr[idx];
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
{var
  i, j, n: integer;    }
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

        {for j := 0 to MapHeight - 1 do
          for i := 0 to MapWidth - 1 do begin
            n := (MapData[i, j].FrImg and $7FFF);
            ///MapData[i, j].Area := n div 65535;
            MapData[i, j].FrImg := (MapData[i, j].FrImg and $8000) or (n mod 65535);
          end;    }

        MapPaint.Refresh;
      end;
    end;
  end;
end;

procedure TFrmMain.OpenOldFormatFile1Click(Sender: TObject);
{var
  i, j, n: integer;   }
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

      {  for j := 0 to MapHeight - 1 do
          for i := 0 to MapWidth - 1 do begin
            n := (MapData[i, j].FrImg and $7FFF);
            MapData[i, j].Area := n div 65535;
            MapData[i, j].FrImg := n mod 65535;
          end;   }

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
              n := (MapData[i, j].FrImg and $7FFF);
              SetMapDataEx(i, j, Area, n div 65535);
              SetMapDataEx(i, j, FrImg, n mod 65535);
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
{var
  r: integer; }
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
  //  FrmSegment.Show;
end;

// ---------------------------------------

//  Segment Editing

// ---------------------------------------

procedure TFrmMain.LoadSegment(col, row: integer; flname: string);
{var
  i, fhandle: integer;
  header: TMapHeader;   }
begin
 { if not FileExists(flname) then
    exit;
  fhandle := FileOpen(flname, fmOpenRead or fmShareDenyNone);
  if fhandle > 0 then begin
    FileRead(fhandle, header, sizeof(TMapHeader));
    //if header.Title = TITLEHEADER then begin
    if (header.Width > 0) and (header.Height > 0) then begin
      for i := 0 to header.Width - 1 do begin
        FileRead(fhandle, MapData[col + i, row], sizeof(TMapInfo) * SEGY);
      end;
    end;
    //end;
    FileClose(fhandle);
  end;  }
end;

procedure TFrmMain.SaveSegment(col, row: integer; flname: string);
{var
  i, fhandle: integer;
  header: TMapHeader; }
begin
{  header.Width := SEGX;
  header.Height := SEGY;
  header.Title := TITLEHEADER;
  if FileExists(flname) then
    fhandle := FileOpen(flname, fmOpenWrite or fmShareDenyNone)
  else
    fhandle := FileCreate(flname);
  if fhandle > 0 then begin
    FileWrite(fhandle, header, sizeof(TMapHeader));
    for i := col to col + SEGX - 1 do begin
      FileWrite(fhandle, MapData[i, row], sizeof(TMapInfo) * SEGY);
    end;
    FileClose(fhandle);
  end;  }
end;

procedure TFrmMain.DisposeUndoInfo(UndoInfo: pTUndoInfo);
begin
  if UndoInfo.MapInfo <> nil then
    FreeMem(UndoInfo.MapInfo);
  if UndoInfo.MapData <> nil then
    FreeMem(UndoInfo.MapData);
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
  //CopyTemp;
  ///FillChar(MArr, sizeof(MArr), #0);
  //MapPaint.Refresh;
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
  //  FrmSmTile.Show;
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
  i, j, xx, yy, idx, m: integer;
  bmp: TBitmap;
begin
  bmp := TBitmap.Create;
  bmp.PixelFormat := pf16bit;
  bmp.Canvas.Brush.Color := clBlack;
  m := TComponent(Sender).Tag;
  bmp.Width := MapWidth * UNITX div m;
  bmp.Height := MapHeight * UNITY div m;

  for j := 0 to MapHeight - 1 do
    for i := 0 to MapWidth - 1 do begin
      idx := GetBkImg(i, j);
      if (i mod 2 = 0) and (j mod 2 = 0) then begin
        xx := i * UNITX div m;
        yy := j * UNITY div m;
        if idx >= 0 then begin
          WilTile(GetBKIndex(i, j)).DrawZoom(bmp.Canvas, xx, yy, idx, 1 / m);
        end;
      end;
    end;
  for j := 0 to MapHeight - 1 do
    for i := 0 to MapWidth - 1 do begin
      idx := GetMidImg(i, j);
      xx := i * UNITX div m;
      yy := j * UNITY div m;
      if idx >= 0 then begin
        WilSmTile(GetMidIndex(i, j)).DrawZoomEx(bmp.Canvas, xx, yy, idx, 1 / m, TRUE);
      end;
    end;
  for j := 0 to MapHeight - 1 do
    for i := 0 to MapWidth - 1 do begin
      idx := GetFrImg(i, j);
      xx := i * UNITX div m;
      yy := (j + 1) * UNITY div m;
      if idx >= 0 then begin
        ObjWil(idx).DrawZoomEx(bmp.Canvas, xx, yy, idx mod 65535, 1 / m, FALSE);
      end;
    end;

  bmp.SaveToFile('map.bmp');
  bmp.Free;

  Application.MessageBox(PChar('±£´æ³É¹¦£¬ÎÄ¼þ´æ·ÅÔÚ' + GetCurrentDir + '\map.bmp'), 'ÌáÊ¾ÐÅÏ¢', MB_OK + MB_ICONINFORMATION);

end;

procedure TFrmMain.MapScroll1Click(Sender: TObject);
var
  xs, ys, i, k: integer;
  nilmap: TMapInfo;
begin
  CopyTempBegin;
  FrmScrollMap.Execute(xs, ys);
  FillChar(nilmap, sizeof(TMapInfo), #0);
  if (xs > 0) and (xs < MAXX) then begin
    for i := MAXX downto 0 do
      for k := 0 to MAXY - 1 do begin
        if i - xs > 0 then
          MapData[i, k] := MapData[i - xs, k]
        else
          MapData[i, k] := nilmap;
      end;
  end
  else begin
    for i := 0 to MAXX - 1 do
      for k := 0 to MAXY - 1 do begin
        if i - xs < MAXX - 1 then
          MapData[i, k] := MapData[i - xs, k]
        else
          MapData[i, k] := nilmap;
      end;
  end;
  if (ys > 0) and (ys < MAXY) then begin
    for i := MAXY downto 0 do
      for k := 0 to MAXX - 1 do begin
        if i - ys > 0 then
          MapData[k, i] := MapData[k, i - ys]
        else
          MapData[k, i] := nilmap;
      end;
  end
  else begin
    for i := 0 to MAXY - 1 do
      for k := 0 to MAXX - 1 do begin
        if i - ys < MAXY - 1 then
          MapData[k, i] := MapData[k, i - ys]
        else
          MapData[k, i] := nilmap;
      end;
  end;
  CopyTempEnd;
  MapPaint.Refresh;
end;

procedure TFrmMain.CellMove1Click(Sender: TObject);
begin
  FrmMoveObj.Execute;
end;

procedure TFrmMain.N10Click(Sender: TObject);
begin
  //form1.ShowModal;
  ShellAbout(0, 'µØÍ¼±à¼­Æ÷', 'Copyright (C) 2012', Application.Icon.Handle);
end;

procedure TFrmMain.Exit1Click(Sender: TObject);
begin
  Close();
end;

end.




