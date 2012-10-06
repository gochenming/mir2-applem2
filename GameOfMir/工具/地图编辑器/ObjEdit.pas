unit ObjEdit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, ExtCtrls, Buttons, StdCtrls, Spin, HUtil32;

type
  TPieceInfo = packed record
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
  end;
  PTPieceInfo = ^TPieceInfo;

  TFrmObjEdit = class(TForm)
    Pbox: TPaintBox;
    DetailGrid: TDrawGrid;
    Panel1: TPanel;
    BtnView: TSpeedButton;
    Panel2: TPanel;
    BtnOk: TBitBtn;
    BtnClear: TBitBtn;
    BitBtn1: TBitBtn;
    BtnMark1: TSpeedButton;
    BtnMark2: TSpeedButton;
    BtnTile: TSpeedButton;
    BObj: TSpeedButton;
    BTile: TSpeedButton;
    Panel3: TPanel;
    Label2: TLabel;
    SeAniFrame: TSpinEdit;
    Label3: TLabel;
    SeAniTick: TSpinEdit;
    CkAlpha: TCheckBox;
    Panel4: TPanel;
    CkViewMark: TCheckBox;
    BDoor: TSpeedButton;
    BLight: TSpeedButton;
    Label4: TLabel;
    SeLight: TSpinEdit;
    Label5: TLabel;
    SeDoor: TSpinEdit;
    Label1: TLabel;
    Label6: TLabel;
    SeDoorOffset: TSpinEdit;
    CkViewLineNumber: TCheckBox;
    BDoorCore: TSpeedButton;
    CbWilIndexList: TComboBox;
    Label7: TLabel;
    LabelIndex: TLabel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    Panel5: TPanel;
    BtnDoorTest: TSpeedButton;
    Panel6: TPanel;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    CheckBox7: TCheckBox;
    Button1: TButton;
    CheckBox8: TCheckBox;
    CheckBox9: TCheckBox;
    CheckBox10: TCheckBox;
    CheckBox11: TCheckBox;
    procedure DetailGridDrawCell(Sender: TObject; Col, Row: Longint;
      Rect: TRect; State: TGridDrawState);
    procedure PboxPaint(Sender: TObject);
    procedure PboxMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PboxMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure PboxMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BtnClearClick(Sender: TObject);
    procedure BtnLeftClick(Sender: TObject);
    procedure BtnUpClick(Sender: TObject);
    procedure BtnDownClick(Sender: TObject);
    procedure BtnRightClick(Sender: TObject);
    procedure BtnTileClick(Sender: TObject);
    procedure DetailGridClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CkViewMarkClick(Sender: TObject);
    procedure BtnDoorTestClick(Sender: TObject);
    procedure CbWilIndexListChange(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    BoxVisible: Boolean;
    BoxX, BoxY{, BoxWidth, BoxHeight}: integer;
    PieceList: TList;
    UndoPieceList: TStringList;
    starttime: integer;
    ObjWilIndex: integer;
    procedure AddPiece(x, y, bkimg, img, mark, bkindex, midimg, midindex: integer);
    procedure AddLight(x, y, light: integer);
    procedure AddDoor(x, y, doorindex, dooroffset: integer; core: Boolean);
   // function GetPiece(x, y: integer): PTPieceInfo;
    procedure DelPiece(x, y: integer);
    procedure ShiftPieces(dir, tag: integer);
    procedure ClearPiece;
    procedure DrawPiece(paper: TCanvas; x, y: integer);
    procedure GetRelPos(x, y: integer; var rx, ry: integer);
    procedure DrawCursor(xx, yy: integer);
    function GetCurrentIndex: integer;
    procedure InitAniFrame;
    procedure AddAnimationUtitily;
    procedure CopyPiece(P: PTPieceInfo; boNew: Boolean);
    procedure UnPiece();
  public
    CanDrawSmTitle: Boolean;
    function Execute: Boolean;
    procedure SetPieceList(plist: TList);
    procedure DuplicatePieceList(plist: TList);
  end;

var
  FrmObjEdit: TFrmObjEdit;

implementation

uses edmain, SmTile, Tile;

{$R *.DFM}

procedure TFrmObjEdit.FormCreate(Sender: TObject);
var
  i: integer;
begin
  starttime := GetCurrentTime;
  BoxVisible := FALSE;
  BoxX := 0;
  BoxY := 0;
  PieceList := TList.Create;
  UndoPieceList := TStringList.Create;
  CbWilIndexList.ItemIndex := 0;
  ObjWilIndex := 0;
  CbWilIndexList.Items.Clear;
  for I := Low(WilArr) to High(WilArr) do
    CbWilIndexList.Items.Add(ExtractFileName(WilArr[I].FileName));
  CbWilIndexList.ItemIndex := 0;
  //for i := 0 to WIlcount - 1 do begin
   // CbWilIndexList.Items.Add(format('objects%d.wil', [i + 9]));
  //end;
end;

procedure TFrmObjEdit.FormDestroy(Sender: TObject);
begin
  PieceList.Free;
  UndoPieceList.Free;
end;

procedure TFrmObjEdit.FormShow(Sender: TObject);
var
  n: integer;
begin
  n := _MIN(65535, FrmMain.ObjWil(ObjWilIndex * 65535).ImageCount);
  //   n := FrmMain.ObjWil(ObjWilIndex*65535).ImageCount;
  if n >= 1 then
    DetailGrid.ColCount := n
  else
    DetailGrid.ColCount := 1;
  FrmTile.Show;

  FrmTile.Parent := self;
  FrmTile.Left := 120;
  FrmTile.Top := 30;
  FrmTile.CBTitleChange(nil);

  FrmSmTile.Show;
  FrmSmTile.Parent := self;
  FrmSmTile.Left := 120;
  FrmSmTile.Top := 335;
  FrmSmTile.CBSmTitleChange(nil);
end;

procedure TFrmObjEdit.CbWilIndexListChange(Sender: TObject);
var
  n: integer;
begin
  n := CbWilIndexList.ItemIndex;
  if n in [Low(WilArr)..High(WilArr)] then begin
    ObjWilIndex := n;
    FormShow(self);
  end;
end;

function TFrmObjEdit.Execute: Boolean;
begin
  starttime := GetCurrentTime;
  InitAniFrame;
  if mrOk = ShowModal then begin
    AddAnimationUtitily; //¿¡´Ï¸ÞÀÌ¼Ç ½ÃÄÑ¾ß ÇÏ´Â °Í Àû¿ë
    Result := TRUE;
  end
  else
    Result := FALSE;
  FrmTile.Parent := nil;
  FrmSmTile.Parent := nil;
end;

procedure TFrmObjEdit.SetPieceList(plist: TList);
var
  i: integer;
  p: PTPieceInfo;
begin
  ClearPiece;
  if plist <> nil then begin
    for i := 0 to plist.Count - 1 do begin
      new(p);
      p^ := PTPieceInfo(plist[i])^;
      PieceList.Add(p);
    end;
  end;
end;

procedure TFrmObjEdit.InitAniFrame;
var
  aniframe, anitick: integer;
  blend: Boolean;
begin
  if PieceList.Count > 0 then begin
    aniframe := PTPieceInfo(PieceList[0]).aniframe;
    anitick := PTPieceInfo(PieceList[0]).anitick;
    blend := PTPieceInfo(PieceList[0]).blend;
  end
  else begin
    aniframe := 0;
    anitick := 0;
    blend := FALSE;
  end;
  SeAniFrame.Value := aniframe;
  SeAniTick.Value := anitick;
  CkAlpha.Checked := blend;
end;

procedure TFrmObjEdit.AddAnimationUtitily;
var
  i, aniframe, anitick: integer;
  blend: Boolean;
  p: PTPieceInfo;
begin
  try
    aniframe := SeAniFrame.Value;
    anitick := SeAniTick.Value;
    if aniframe > 0 then
      blend := CkAlpha.Checked
    else
      blend := FALSE;
  except
    aniframe := 0;
    anitick := 0;
    blend := FALSE;
  end;
  if aniframe >= 0 then begin
    for i := 0 to PieceList.Count - 1 do begin
      p := PTPieceInfo(PieceList[i]);
      p.aniframe := aniframe;
      p.anitick := anitick;
      p.blend := blend;
    end;

  end;
end;

procedure TFrmObjEdit.DuplicatePieceList(plist: TList);
var
  i: integer;
  p: PTPieceInfo;
begin
  for i := 0 to PieceList.Count - 1 do begin
    new(p);
    p^ := PTPieceInfo(PieceList[i])^;
    plist.Add(p);
  end;
end;

{ PieceList }

{img : -2 (not apply), mark -2 (not apply)}

procedure TFrmObjEdit.AddPiece(x, y, bkimg, img, mark, bkindex, midimg, midindex: integer);
var
  i, n{, m}: integer;
  p: PTPieceInfo;
begin
  if (img = -1) or (bkimg = -1) then
    exit;
  n := -1;
  for i := 0 to PieceList.Count - 1 do begin
    p := PTPieceInfo(PieceList[i]);
    if (p.rx = x) and (p.ry = y) then begin
      CopyPiece(P, False);
      if img <> -2 then
        p.img := img;
      if bkimg <> -2 then
        p.bkimg := bkimg;
      if mark <> -2 then
        p.mark := p.mark xor mark;
      if bkindex <> -2 then
        p.bkindex := bkindex;
      if midimg <> -2 then
        p.midimg := midimg;
      if midindex <> -2 then
        p.midindex := midindex;

      exit;
    end;
    if p.ry > y then begin
      n := i;
      break;
    end;
  end;
  new(p);
  CopyPiece(P, True);
  FillChar(p^, sizeof(TPieceInfo), 0);
  p.bkimg := -1;
  p.midimg := -1;
  p.img := -1;
  p.rx := x;
  p.ry := y;
  if bkimg <> -2 then
    p.bkimg := bkimg
  else
    p.bkimg := -1;
  if img <> -2 then
    p.img := img
  else
    p.img := -1;
  if mark <> -2 then
    p.mark := mark
  else
    p.mark := 0;
  if bkindex <> -2 then
    p.bkindex := bkindex;

  if midimg <> -2 then
    p.midimg := midimg;
    
  if midindex <> -2 then
    p.midindex := midindex;

  if n = -1 then
    PieceList.Add(p)
  else
    PieceList.Insert(n, p);
end;

procedure TFrmObjEdit.AddLight(x, y, light: integer);
var
  i, n{, m}: integer;
  p: PTPieceInfo;
begin
  if (light = -1) then
    exit;
  n := -1;
  for i := 0 to PieceList.Count - 1 do begin
    p := PTPieceInfo(PieceList[i]);
    if (p.rx = x) and (p.ry = y) then begin
      CopyPiece(P, False);
      p.light := light;

      exit;
    end;
    if p.ry > y then begin
      n := i;
      break;
    end;
  end;
  new(p);
  CopyPiece(P, True);
  FillChar(p^, sizeof(TPieceInfo), 0);
  p.bkimg := -1;
  p.midimg := -1;
  p.img := -1;
  p.rx := x;
  p.ry := y;
  p.light := light;

  if n = -1 then
    PieceList.Add(p)
  else
    PieceList.Insert(n, p);
end;

procedure TFrmObjEdit.AddDoor(x, y, doorindex, dooroffset: integer; core: Boolean);
var
  i, n{, m}: integer;
  p: PTPieceInfo;
begin
  if (doorindex = -1) or (dooroffset = -1) then
    exit;
  n := -1;
  for i := 0 to PieceList.Count - 1 do begin
    p := PTPieceInfo(PieceList[i]);
    if (p.rx = x) and (p.ry = y) then begin
      CopyPiece(P, False);
      if core then
        p.doorindex := $80 or p.doorindex //¹®À» ¿©´Â °÷
      else
        p.doorindex := (p.doorindex and $80) or doorindex;
      p.dooroffset := dooroffset;

      exit;
    end;
    if p.ry > y then begin
      n := i;
      break;
    end;
  end;
  new(p);
  CopyPiece(P, True);
  FillChar(p^, sizeof(TPieceInfo), 0);
  p.bkimg := -1;
  p.midimg := -1;
  p.img := -1;
  p.rx := x;
  p.ry := y;
  if core then
    p.doorindex := $80 or doorindex
  else
    p.doorindex := doorindex;
  p.dooroffset := dooroffset;

  if n = -1 then
    PieceList.Add(p)
  else
    PieceList.Insert(n, p);
end;
  {
function TFrmObjEdit.GetPiece(x, y: integer): PTPieceInfo;
var
  i: integer;
  p: PTPieceInfo;
begin
  Result := nil;
  for i := 0 to PieceList.Count - 1 do begin
    p := PTPieceInfo(PieceList[i]);
    if (p.rx = x) and (p.ry = y) then begin
      Result := p;
    end;
  end;
end;    }

procedure TFrmObjEdit.DelPiece(x, y: integer);
var
  i: integer;
  p: PTPieceInfo;
begin
  for I := PieceList.Count - 1 downto 0 do begin
    p := PTPieceInfo(PieceList[i]);
    if ((p.rx = x) and (p.ry = y)) or CheckBox8.Checked then begin
      CopyPiece(P, False);
      if CheckBox1.Checked then
        P.bkimg := -1;
      if CheckBox2.Checked then
        P.midimg := -1;
      if CheckBox3.Checked then
        p.img := -1;
      if CheckBox4.Checked then
        p.mark := 0;
      if CheckBox5.Checked then
        p.light := 0;
      if CheckBox6.Checked then begin
        p.doorindex := 0;
        p.dooroffset := 0;
      end;
      if CheckBox7.Checked then begin
        p.aniframe := 0;
        p.blend := False;
        p.anitick := 0;
      end;
    end
  end;
  CheckBox8.Checked := False;
end;

procedure TFrmObjEdit.ShiftPieces(dir, tag: integer);
var
  i: integer;
  p: PTPieceInfo;
begin
  for i := 0 to PieceList.Count - 1 do begin
    p := PTPieceInfo(PieceList[i]);
    if (tag = 0) then begin
      case dir of
        0: {//left} begin
            p.rx := p.rx - 1;
          end;
        1: {//right} begin
            p.rx := p.rx + 1;
          end;
        2: {//up} begin
            p.ry := p.ry - 1;
          end;
        3: {//down} begin
            p.ry := p.ry + 1;
          end;
      end;
    end else begin
      case dir of
        0:  begin
            p.rx := (p.rx - 2);
          end;
        1: begin
            p.rx := (p.rx + 2);
          end;
        2:  begin
            p.ry := (p.ry - 2);
          end;
        3:  begin
            p.ry := (p.ry + 2);
          end;
      end;
    end;
  end;
end;

procedure TFrmObjEdit.UnPiece;
var
  I: Integer;
  P2, P1, P3: PTPieceInfo;
begin
  if UndoPieceList.Count > 0 then begin
    P2 := PTPieceInfo(UndoPieceList.Objects[UndoPieceList.Count - 1]);
    P1 := PTPieceInfo(StrToIntDef(UndoPieceList[UndoPieceList.Count - 1], 0));
    for i := 0 to PieceList.Count - 1 do begin
      P3 := PTPieceInfo(PieceList[i]);
      if P3 = P1 then begin
        if P2 = nil then begin
          Dispose(P3);
          PieceList.Delete(I);
        end else begin
          P3^ := P2^;
        end;
        break;
      end;
    end;
    if P2 <> nil then
      Dispose(P2);
    UndoPieceList.Delete(UndoPieceList.Count - 1);
    PBox.Repaint;
  end;
end;

procedure TFrmObjEdit.ClearPiece;
var
  i: integer;
//  p: PTPieceInfo;
begin
  for i := 0 to PieceList.Count - 1 do
    Dispose(PTPieceInfo(PieceList[i]));
  for i := 0 to UndoPieceList.Count - 1 do
    if UndoPieceList.Objects[i] <> nil then
      Dispose(PTPieceInfo(UndoPieceList.Objects[i]));
  PieceList.Clear;
  UndoPieceList.Clear;
end;

procedure TFrmObjEdit.CopyPiece(P: PTPieceInfo; boNew: Boolean);
var
  P2: PTPieceInfo;
begin
  if UndoPieceList.Count > 19 then begin
    if UndoPieceList.Objects[0] <> nil then
      Dispose(PTPieceInfo(UndoPieceList.Objects[0]));
    UndoPieceList.Delete(0);
  end;
  if boNew then UndoPieceList.AddObject(IntToStr(Integer(P)), nil)
  else begin
    New(P2);
    P2^ := P^;
    UndoPieceList.AddObject(IntToStr(Integer(P)), TObject(P2));
  end;
end;

procedure TFrmObjEdit.DrawPiece(paper: TCanvas; x, y: integer);
{var
  nx, ny, nby, img, mode, mark: integer;
  p: PTPieceInfo; }
begin
  {nx := PBox.Width div 2 - UNITX;
  ny := PBox.Height div 2 + UNITY;
  nby := ny + y * UNITY - UNITY;
  nx := nx + x * UNITX;
  ny := ny + y * UNITY;
  p := GetPiece(x, y);
  if p <> nil then begin
    with FrmMain.WilTile(p.bkindex) do begin
      if p.bkimg >= 0 then
        DrawZoom(paper, nx, nby, p.bkimg, 1);
    end;
    with FrmMain.WilSmTile(p.midindex) do begin
      if p.midimg >= 0 then
        DrawZoom(paper, nx, nby, p.midimg, 1);
    end;
    with FrmMain.ObjWil(p.img) do begin
      if p.img >= 0 then
        DrawZoomEx(paper, nx, ny, p.img mod 65535, 1, FALSE);
    end;
    with FrmMain.WilSmTile(0) do begin
      if (p.mark and $01) > 0 then
        DrawZoomEx(paper, nx, ny, BKMASK, 1, FALSE);
      if (p.mark and $02) > 0 then
        DrawZoomEx(paper, nx, ny, FRMASK, 1, FALSE);
    end;
  end;   }
  Pbox.Repaint;
end;

{}

procedure TFrmObjEdit.GetRelPos(x, y: integer; var rx, ry: integer);
var
  nx, ny: integer;
begin
  nx := PBox.Width div 2 - UNITX;
  ny := PBox.Height div 2;
  if x - nx < 0 then
    x := x - (UNITX - 1);
  if y - ny < 0 then
    y := y - (UNITY - 1);
  rx := (x - nx) div UNITX;
  ry := (y - ny) div UNITY;
end;

procedure TFrmObjEdit.DrawCursor(xx, yy: integer);
var
  cx, cy, nx, ny: integer;
begin
  GetRelPos(xx, yy, nx, ny);
  Label1.Caption := IntToStr(nx) + ' : ' + IntToStr(ny);

  cx := PBox.Width div 2 - UNITX;
  cy := PBox.Height div 2;

  xx := cx + nx * UNITX;
  yy := cy + ny * UNITY;
  PBox.Canvas.DrawFocusRect(Rect(xx, yy, xx + UNITX, yy + UNITY));
end;

procedure TFrmObjEdit.DetailGridDrawCell(Sender: TObject; Col,
  Row: Longint; Rect: TRect; State: TGridDrawState);
var
  idx, max, wid: integer;
begin
  idx := Col;
  max := FrmMain.ObjWil(ObjWilIndex * 65535).ImageCount;
  if (idx >= 0) and (idx < max) then begin
    with FrmMain.ObjWil(ObjWilIndex * 65535) do
      DrawZoom(DetailGrid.Canvas, Rect.Left, Rect.Top, idx, 0.5);
    if {CkViewLineNumber.Checked or} (State <> []) then begin
      LabelIndex.Caption := Inttostr(idx);
      wid := DetailGrid.Canvas.TextWidth(IntToStr(idx));
      if wid > DetailGrid.DefaultColWidth then
        DetailGrid.Canvas.TextOut(Rect.Left - (wid - DetailGrid.DefaultColWidth), Rect.Bottom - 16, IntToStr(idx))
      else
        DetailGrid.Canvas.TextOut(Rect.Left, Rect.Bottom - 16, IntToStr(idx));
    end;
  end;
end;

procedure TFrmObjEdit.PboxPaint(Sender: TObject);
var
  i, k, idx: integer;
  nx, ny, {nbx, nby, }dx, dy: integer;
  p, p2: PTPieceInfo;
begin
  if BoxVisible then begin
    DrawCursor(BoxX, BoxY);
    BoxVisible := FALSE;
  end;

  nx := PBox.Width div 2 - UNITX;
  ny := PBox.Height div 2 + UNITY;
  if CkViewLineNumber.Checked then begin
    for i := 0 to PieceList.Count - 1 do begin
      p := PTPieceInfo(PieceList[i]);
      dx := nx + p.rx * UNITX;
      dy := ny + (p.ry - 1) * UNITY;
      PBox.Canvas.DrawFocusRect(
        Rect(dx,
        dy,
        dx + UNITX,
        dy + UNITY ));
    end;
  {MapPaint.Canvas.DrawFocusRect(
    Rect(xx,
    yy,
    xx + Round(UNITX * Zoom),
    yy + Round(UNITY * Zoom)));   }
  end;
  if CheckBox9.Checked then begin
    for i := 0 to PieceList.Count - 1 do begin
      p := PTPieceInfo(PieceList[i]);
      dx := nx + p.rx * UNITX;
      dy := ny + (p.ry - 1) * UNITY;
      if p.bkimg >= 0 then
        with FrmMain.WilTile(p.bkindex) do
          DrawZoom(PBox.Canvas, dx, dy, p.bkimg, 1);
    end;
  end;
  if CheckBox10.Checked then begin
    for i := 0 to PieceList.Count - 1 do begin
      p := PTPieceInfo(PieceList[i]);
      dx := nx + p.rx * UNITX;
      dy := ny + (p.ry - 1) * UNITY;
      if p.midimg >= 0 then
        with FrmMain.WilSmTile(p.midindex) do
          DrawZoomEx(PBox.Canvas, dx, dy, p.midimg, 1, True);
    end;
  end;
  if CheckBox11.Checked then begin
    for i := 0 to PieceList.Count - 1 do begin
      p := PTPieceInfo(PieceList[i]);
      dx := nx + p.rx * UNITX;
      dy := ny + p.ry * UNITY;
      idx := p.img;
      if BtnDoorTest.Down then begin
        for k := 0 to PieceList.Count - 1 do begin
          p2 := PTPieceInfo(PieceList[k]);
          if (p.rx = p2.rx) and (p.ry = p2.ry) and (p2.DoorIndex > 0) then begin
            if (p2.DoorIndex and $7F) > 0 then
              idx := idx + p2.DoorOffset;
          end;
        end;
      end;
      with FrmMain.ObjWil(idx) do
        if idx >= 0 then
          DrawZoomEx(PBox.Canvas, dx, dy, idx mod 65535, 1, FALSE);
    end;
  end;
  if CkViewMark.Checked then
    for i := 0 to PieceList.Count - 1 do begin
      p := PTPieceInfo(PieceList[i]);
      dx := nx + p.rx * UNITX;
      dy := ny + p.ry * UNITY;
      if p.mark > 0 then begin
        with FrmMain.WilSmTile(0) do begin
          if (p.mark and $02) > 0 then
            DrawZoomEx(PBox.Canvas, dx, dy, FRMASK, 1, FALSE);
          if (p.mark and $01) > 0 then
            DrawZoomEx(PBox.Canvas, dx, dy, BKMASK, 1, FALSE);
        end;
      end;
      if p.light > 0 then
        with FrmMain.WilSmTile(0) do
          DrawZoomEx(PBox.Canvas, dx, dy, LIGHTSPOT, 1, FALSE);

      if p.DoorIndex > 0 then begin
        if p.DoorIndex and $80 = 0 then
          PBox.Canvas.TextOut(dx + 10, dy - 28, 'D' + intToStr(p.DoorIndex and $7F) + '/' + IntToStr(p.DoorOffset))
        else
          PBox.Canvas.TextOut(dx + 10, dy - 28, 'Dx' + intToStr(p.DoorIndex and $7F) + '/' + IntToStr(p.DoorOffset));
      end;
    end;

  with PBox.Canvas do begin
    Pen.Color := clGray;
    MoveTo(0, PBox.Height div 2);
    LineTo(PBox.Width, PBox.Height div 2);
    MoveTo(PBox.Width div 2, 0);
    LineTo(PBox.Width div 2, Height);
  end;
end;

procedure TFrmObjEdit.PboxMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  xx, yy, l, offs: integer;
begin
  if GetCurrentTime - LongWord(starttime) < 1000 then
    exit;
  if BoxVisible then begin
    DrawCursor(BoxX, BoxY);
    BoxVisible := FALSE;
  end;
  GetRelPos(X, Y, xx, yy);
  if ssCtrl in Shift then begin
    DelPiece(xx, yy);
    PBox.Refresh;
  end
  else begin
    if (BtnMark1.Down) and (BtnMark2.Down) then begin //
      AddPiece(xx, yy, -2, -2, 3, -2, -2, -2);
      DrawPiece(PBox.Canvas, xx, yy);
      exit;
    end;
    if BtnMark1.Down then begin //
      AddPiece(xx, yy, -2, -2, 2, -2, -2, -2);
      DrawPiece(PBox.Canvas, xx, yy);
      exit;
    end;
    if BtnMark2.Down then begin //
      AddPiece(xx, yy, -2, -2, 1, -2, -2, -2);
      DrawPiece(PBox.Canvas, xx, yy);
      exit;
    end;
    if BTile.Down then begin //Tile
      if CanDrawSmTitle then begin
          AddPiece(xx, yy, -2, -2, -2, -2, FrmSmTile.GetCurrentImageIndex, FrmSmTile.GetCurrentFileIndex);
          DrawPiece(PBox.Canvas, xx, yy);
      end else begin
        if (xx mod 2 = 0) and (yy mod 2 = 0) then begin
          AddPiece(xx, yy, FrmTile.GetCurrentImageIndex, -2, -2, FrmTile.GetCurrentFileIndex, -2, -2);
          DrawPiece(PBox.Canvas, xx, yy);
        end
        else
          Beep;
      end;
      exit;
    end;
    if BObj.Down then begin //Object
      AddPiece(xx, yy, -2, GetCurrentIndex, -2, -2, -2, -2);
      DrawPiece(PBox.Canvas, xx, yy);
      exit;
    end;
    if BLight.Down then begin
      try
        l := SeLight.Value;
      except
        l := 0;
      end;
      AddLight(xx, yy, l);
    end;
    if BDoor.Down then begin
      try
        l := SeDoor.Value;
        offs := SeDoorOffset.Value;
      except
        l := 0;
        offs := 0;
      end;
      AddDoor(xx, yy, l, offs, FALSE);
    end;
    if BDoorCore.Down then begin
      try
        l := SeDoor.Value;
        offs := SeDoorOffset.Value;
      except
        l := 0;
        offs := 0;
      end;
      AddDoor(xx, yy, l, offs, TRUE);
    end;
  end;
end;

function TFrmObjEdit.GetCurrentIndex: integer;
begin
  Result := -1;
  with DetailGrid do
    if (Col >= 0) and (Col < FrmMain.ObjWil(ObjWilIndex * 65535).ImageCount) then
      Result := ObjWilIndex * 65535 + Col;
end;

procedure TFrmObjEdit.PboxMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if BoxVisible then begin
    DrawCursor(BoxX, BoxY);
    BoxVisible := FALSE;
  end;

  if ssLeft in Shift then begin
    //PboxMouseDown (self, mbLeft, Shift, X, Y);
  end;

  if not BoxVisible then begin
    BoxX := X;
    BoxY := Y;
    DrawCursor(BoxX, BoxY);
    BoxVisible := TRUE;
  end;
end;

procedure TFrmObjEdit.PboxMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  ;
end;

procedure TFrmObjEdit.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_F1: BtnTile.Down := not BTile.Down;
    VK_F2: BObj.Down := not BObj.Down;
    VK_F3: BtnMark1.Down := not BtnMark1.Down;
    VK_F4: BtnMark2.Down := not BtnMark2.Down;
    VK_F7: BtnMark1.Down := not BtnMark1.Down;
    VK_F8: BtnMark2.Down := not BtnMark2.Down;
    VK_F5: PBox.Refresh;
    word('z'),
      word('Z'):begin
        if ssCtrl in Shift then begin
          UnPiece();
        end;
      end;
  end;
end;

procedure TFrmObjEdit.BtnClearClick(Sender: TObject);
begin
  ClearPiece;
  PBox.Refresh;
end;

procedure TFrmObjEdit.BtnLeftClick(Sender: TObject);
begin
  ShiftPieces(0, TSpeedButton(Sender).Tag);
  PBox.Refresh;
end;

procedure TFrmObjEdit.BtnRightClick(Sender: TObject);
begin
  ShiftPieces(1, TSpeedButton(Sender).Tag);
  PBox.Refresh;
end;

procedure TFrmObjEdit.BtnUpClick(Sender: TObject);
begin
  ShiftPieces(2, TSpeedButton(Sender).Tag);
  PBox.Refresh;
end;

procedure TFrmObjEdit.Button1Click(Sender: TObject);
var
  i, n: integer;
  p: PTPieceInfo;
begin
  n := 0;
  if Application.MessageBox('ÊÇ·ñÉ¾³ýÎÞÐ§Í¼Æ¬ÏîÄ¿µã£¿', 'ÌáÊ¾ÐÅÏ¢', MB_OKCANCEL + MB_ICONQUESTION) = IDOK then
  begin
    for I := PieceList.Count - 1 downto 0 do begin
      p := PTPieceInfo(PieceList[i]);
      if (p.bkimg >= 0) and (not FrmMain.WilTile(p.bkindex).CanDrawData(p.bkimg)) then
        p.bkimg := -1;
      if (p.midimg >= 0) and (not FrmMain.WilSmTile(p.midindex).CanDrawData(p.midimg)) then
        p.midimg := -1;
      if (p.img >= 0) and (not FrmMain.ObjWil(p.img).CanDrawData(p.img mod 65535)) then
        p.img := -1;
    end;
  end;

  for I := PieceList.Count - 1 downto 0 do begin
    p := PTPieceInfo(PieceList[i]);
    if (p.bkimg < 0) and (p.midimg < 0) and (p.img < 0) and (p.mark <= 0) and (p.doorindex <= 0) and (p.aniframe <= 0) then begin
      Dispose(P);
      PieceList.Delete(I);
      Inc(n);
    end;
  end;
  Pbox.Repaint;
  Application.MessageBox(PChar('ÇåÀíÍê³É£¬¹²Çå³ý' + IntToStr(n) + '¸öÎÞÐ§µãÊý¾Ý£¡'), 'ÌáÊ¾ÐÅÏ¢', MB_OK + MB_ICONINFORMATION);
end;

procedure TFrmObjEdit.BtnDownClick(Sender: TObject);
begin
  ShiftPieces(3, TSpeedButton(Sender).Tag);
  PBox.Refresh;
end;

procedure TFrmObjEdit.BtnTileClick(Sender: TObject);
begin
  FrmTile.Show;
  FrmTile.Parent := self;
  FrmSmTile.Show;
  FrmSmTile.Parent := Self;
end;

procedure TFrmObjEdit.DetailGridClick(Sender: TObject);
begin
  BObj.Down := TRUE;

end;

procedure TFrmObjEdit.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FrmTile.Parent := FrmMain;
  FrmTile.Close;
  FrmSmTile.Parent := FrmMain;
  FrmSmTile.Close;
end;

procedure TFrmObjEdit.CkViewMarkClick(Sender: TObject);
begin
  PBox.Refresh;
end;

procedure TFrmObjEdit.BtnDoorTestClick(Sender: TObject);
begin
  PBox.Refresh;
end;

end.

