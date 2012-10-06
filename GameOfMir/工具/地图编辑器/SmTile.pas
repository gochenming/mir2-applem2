unit SmTile;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, ExtCtrls, StdCtrls;

type
  TFrmSmTile = class(TForm)
    TileGrid: TDrawGrid;
    Panel1: TPanel;
    CBSmTitle: TComboBox;
    procedure FormShow(Sender: TObject);
    procedure TileGridDrawCell(Sender: TObject; Col, Row: Longint; Rect: TRect; State: TGridDrawState);
    procedure TileGridClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CBSmTitleChange(Sender: TObject);
  private
    UnitMax: integer;
  public
    function CanDrawSmTile(): Boolean;
    procedure SetImageUnitCount(ucount: integer);
    function GetCurrentImageIndex: integer;
    function GetCurrentFileIndex: Byte;
  end;

var
  FrmSmTile: TFrmSmTile;

implementation

uses edmain, ObjEdit;

{$R *.DFM}

function TFrmSmTile.CanDrawSmTile: Boolean;
begin
  Result := (not FrmObjEdit.Visible) and FrmMain.SpeedButton1.Down;
end;

procedure TFrmSmTile.CBSmTitleChange(Sender: TObject);
var
  n: integer;
begin
  if CanDrawSmTile then begin
    Width := 178;
    TileGrid.ColCount := 3;
    n := (FrmMain.WilSmTile(CBSmTitle.ItemIndex).ImageCount + MIDDLEBLOCK - 1) div MIDDLEBLOCK;
    UnitMax := n;
    TileGrid.RowCount := n + 1;
  end else begin
    Width := 274;
    TileGrid.ColCount := 5;
    n := FrmMain.WilSmTile(CBSmTitle.ItemIndex).ImageCount;
    n := n div 5;
    if n >= 1 then
      TileGrid.RowCount := n
    else
      TileGrid.RowCount := 1;
  end;
  if IsWindowVisible(Handle) then
    TileGrid.Repaint;
end;

procedure TFrmSmTile.FormCreate(Sender: TObject);
var
  I: Integer;
begin
  for I := Low(WilSmTileArr) to High(WilSmTileArr) do
    CBSmTitle.Items.Add(ExtractFileName(WilSmTileArr[I].FileName));
  CBSmTitle.ItemIndex := 0;
end;

procedure TFrmSmTile.FormShow(Sender: TObject);
begin
  CBSmTitleChange(CBSmTitle);
end;

function TFrmSmTile.GetCurrentFileIndex: Byte;
begin
  Result := CBSmTitle.ItemIndex;
end;

function TFrmSmTile.GetCurrentImageIndex: integer;
var
  max, idx: integer;
begin
  max := FrmMain.WilSmTile(CBSmTitle.ItemIndex).ImageCount;
  idx := TileGrid.Row * TileGrid.ColCount + TileGrid.Col;
  if max > idx then
    Result := idx
  else
    Result := -1;
end;

procedure TFrmSmTile.SetImageUnitCount(ucount: integer);
{var
  i: integer;    }
begin
  UnitMax := ucount;
  TileGrid.ColCount := 3;
  TileGrid.RowCount := ucount + 1;
end;

procedure TFrmSmTile.TileGridDrawCell(Sender: TObject; Col, Row: Longint; Rect: TRect; State: TGridDrawState);
var
  idx, max: integer;
begin
  if CanDrawSmTile then begin
    idx := Row; //Col + Row * MainPalGrid.ColCount;
    if (idx >= 0) and (idx < FrmMain.WilSmTile(CBSmTitle.ItemIndex).ImageCount) then begin
      with FrmMain.WilSmTile(CBSmTitle.ItemIndex) do begin
        if Col = 0 then begin
          DrawZoom(TileGrid.Canvas, Rect.Left, Rect.Top, idx * MIDDLEBLOCK + 7 * 4 + 4 + 1, 1);
        end;
        if Col = 1 then
          DrawZoom(TileGrid.Canvas, Rect.Left, Rect.Top, idx * MIDDLEBLOCK, 1);
        if Col = 2 then
          DrawZoom(TileGrid.Canvas, Rect.Left, Rect.Top, idx * MIDDLEBLOCK + 3 * 4 + 4 + 1, 1);
      end;
    end;
  end else begin
    idx := Col + Row * TileGrid.ColCount;
    max := FrmMain.WilSmTile(CBSmTitle.ItemIndex).ImageCount;
    if (idx >= 0) and (idx < max) then begin
      with FrmMain.WilSmTile(CBSmTitle.ItemIndex) do
        DrawZoom(TileGrid.Canvas, Rect.Left, Rect.Top, idx, 1);
    end;
  end;
end;

procedure TFrmSmTile.TileGridClick(Sender: TObject);
var
  idx: integer;
begin
  if CanDrawSmTile then begin
    FrmMain.DrawMode := mdMiddle;
    idx := TileGrid.Row; //Col + Row * MainPalGrid.ColCount;
    if (idx >= 0) and (idx < UnitMax) then begin
      FrmMain.MiddleIndex := idx;
      FrmMain.MiddleIndexIndex := CBSmTitle.ItemIndex;
    end;
  end else begin
    FrmMain.DrawMode := mdMiddle;
    FrmMain.MiddleIndex := TileGrid.Row * TileGrid.ColCount + TileGrid.Col;
    FrmMain.MiddleIndexIndex := CBSmTitle.ItemIndex;

    FrmObjEdit.BTile.Down := TRUE;
    FrmObjEdit.CanDrawSmTitle := True;
  end;
end;

end.

