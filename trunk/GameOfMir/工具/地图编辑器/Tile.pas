unit Tile;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, StdCtrls, ExtCtrls;

type
  TFrmTile = class(TForm)
    TileGrid: TDrawGrid;
    Panel1: TPanel;
    CBTitle: TComboBox;
    procedure FormShow(Sender: TObject);
    procedure TileGridDrawCell(Sender: TObject; Col, Row: Longint; Rect: TRect; State: TGridDrawState);
    procedure TileGridClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CBTitleChange(Sender: TObject);
  public
    UnitMax: Integer;
    function CanDrawTile(): Boolean;
    function GetCurrentImageIndex: integer;
   // function GetCurrentIndex: integer;
    function GetCurrentFileIndex: Byte;
  end;

var
  FrmTile: TFrmTile;

implementation

uses edmain, ObjEdit;

{$R *.DFM}

function TFrmTile.CanDrawTile: Boolean;
begin
  Result := (not FrmObjEdit.Visible) and (FrmMain.SpeedButton1.Down or FrmMain.SpeedButton3.Down);
end;

procedure TFrmTile.CBTitleChange(Sender: TObject);
var
  n: integer;
begin
  if CanDrawTile then begin
    Width := 178;
    TileGrid.ColCount := 3;
    n := (FrmMain.WilTile(CBTitle.ItemIndex).ImageCount + UNITBLOCK - 1) div UNITBLOCK;
    UnitMax := n;
    TileGrid.RowCount := n + 1;
  end else begin
    Width := 274;
    TileGrid.ColCount := 5;
    n := FrmMain.WilTile(CBTitle.ItemIndex).ImageCount;
    n := n div 5;
    if n >= 1 then
      TileGrid.RowCount := n
    else
      TileGrid.RowCount := 1;
  end;
  if IsWindowVisible(Handle) then
    TileGrid.Repaint;
end;

procedure TFrmTile.FormCreate(Sender: TObject);
var
  I: Integer;
begin
  for I := Low(WilTileArr) to High(WilTileArr) do
    CBTitle.Items.Add(ExtractFileName(WilTileArr[I].FileName));
  CBTitle.ItemIndex := 0;
end;

procedure TFrmTile.FormShow(Sender: TObject);
begin
  CBTitleChange(CBTitle);
end;

function TFrmTile.GetCurrentFileIndex: Byte;
begin
  Result := CBTitle.ItemIndex;
end;

function TFrmTile.GetCurrentImageIndex: integer;
var
  max, idx: integer;
begin
  max := FrmMain.WilTile(CBTitle.ItemIndex).ImageCount;
  idx := TileGrid.Row * TileGrid.ColCount + TileGrid.Col;
  if max > idx then
    Result := idx
  else
    Result := -1;
end;
{
function TFrmTile.GetCurrentIndex: integer;
var
  max, idx: integer;
begin
  max := FrmMain.WilTile(CBTitle.ItemIndex).ImageCount;
  idx := TileGrid.Row * TileGrid.ColCount + TileGrid.Col;
  if max > idx then
    Result := idx
  else
    Result := -1;
end;     }

procedure TFrmTile.TileGridDrawCell(Sender: TObject; Col, Row: Longint;
  Rect: TRect; State: TGridDrawState);
var
  idx, max: integer;
begin
  if CanDrawTile then begin
    idx := Row; //Col + Row * MainPalGrid.ColCount;
    if (idx >= 0) and (idx < UnitMax) then begin
      with FrmMain.WilTile(CBTitle.ItemIndex) do begin
        if Col = 0 then begin
          DrawZoom(TileGrid.Canvas, Rect.Left, Rect.Top, idx * UNITBLOCK + 22, 0.5);
          {if idx <= AttrList.Count then
            if Integer(AttrList[idx]) = 1 then
              MainPalGrid.Canvas.TextOut(Rect.Left, Rect.Top + 4, '#'); }
        end;
        if Col = 1 then
          DrawZoom(TileGrid.Canvas, Rect.Left, Rect.Top, idx * UNITBLOCK, 0.5);
        if Col = 2 then
          DrawZoom(TileGrid.Canvas, Rect.Left, Rect.Top, idx * UNITBLOCK + 21, 0.5);
      end;
    end;
  end else begin
    idx := Col + Row * TileGrid.ColCount;
    max := FrmMain.WilTile(CBTitle.ItemIndex).ImageCount;
    if (idx >= 0) and (idx < max) then begin
      with FrmMain.WilTile(CBTitle.ItemIndex) do
        DrawZoom(TileGrid.Canvas, Rect.Left, Rect.Top, idx, 0.5);
    end;
  end;
end;

procedure TFrmTile.TileGridClick(Sender: TObject);
var
  idx: integer;
begin
  if CanDrawTile then begin
    FrmMain.DrawMode := mdTile;
    idx := TileGrid.Row; //MainPalGrid.Col + MainPalGrid.Row * MainPalGrid.ColCount;
    if (idx >= 0) and (idx < UnitMax) then begin
      FrmMain.ImageIndex := idx;
      FrmMain.ImageIndexIndex := CBTitle.ItemIndex;
      FrmMain.TileAttrib := 0;
    end;
  end else begin
    FrmMain.DrawMode := mdTile;
    FrmMain.ImageIndex := TileGrid.Row * TileGrid.ColCount + TileGrid.Col;
    FrmMain.ImageIndexIndex := CBTitle.ItemIndex;
    //FrmMain.MainBrush := mbNormal;
    //FrmMain.SpeedButton2.Down := TRUE;
    FrmObjEdit.BTile.Down := TRUE;
    FrmObjEdit.CanDrawSmTitle := False;
  end;
end;

end.

