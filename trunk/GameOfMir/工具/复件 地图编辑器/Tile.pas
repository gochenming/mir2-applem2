unit Tile;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids;

type
  TFrmTile = class(TForm)
    TileGrid: TDrawGrid;
    procedure FormShow(Sender: TObject);
    procedure TileGridDrawCell(Sender: TObject; Col, Row: Longint;
      Rect: TRect; State: TGridDrawState);
    procedure TileGridClick(Sender: TObject);
  private
  public
    function GetCurrentIndex: integer;
  end;

var
  FrmTile: TFrmTile;

implementation

uses edmain, ObjEdit;

{$R *.DFM}

procedure TFrmTile.FormShow(Sender: TObject);
var
   n: integer;
begin
   n :=  FrmMain.WilTiles.ImageCount;
   n :=  n div 5;
   if n >= 1 then TileGrid.RowCount := n
   else TileGrid.RowCount := 1;
end;

function TFrmTile.GetCurrentIndex: integer;
var
   max, idx: integer;
begin
   max := FrmMain.WilTiles.ImageCount;
   idx := TileGrid.Row * TileGrid.ColCount + TileGrid.Col;
   if max > idx then Result := idx
   else Result := -1;
end;

procedure TFrmTile.TileGridDrawCell(Sender: TObject; Col, Row: Longint;
  Rect: TRect; State: TGridDrawState);
var
   idx, max: integer;
begin
   idx := Col + Row * TileGrid.ColCount;
   max := FrmMain.WilTiles.ImageCount;
   if (idx >= 0) and (idx < max) then begin
      with FrmMain.WilTiles do
         DrawZoom (TileGrid.Canvas, Rect.Left, Rect.Top, idx, 0.5);
   end;
end;

procedure TFrmTile.TileGridClick(Sender: TObject);
begin
   FrmMain.DrawMode := mdTile;
   FrmMain.MainBrush := mbNormal;
   FrmMain.SpeedButton2.Down := TRUE;
   FrmObjEdit.BTile.Down := TRUE;
end;


end.
