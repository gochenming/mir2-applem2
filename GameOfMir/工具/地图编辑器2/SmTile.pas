unit SmTile;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids;

type
  TFrmSmTile = class(TForm)
    TileGrid: TDrawGrid;
    procedure FormShow(Sender: TObject);
    procedure TileGridDrawCell(Sender: TObject; Col, Row: Longint;
      Rect: TRect; State: TGridDrawState);
    procedure TileGridClick(Sender: TObject);
  private
    UnitMax: integer;
  public
    function  GetCurrentIndex: integer;
    procedure SetImageUnitCount (ucount: integer);
  end;

var
  FrmSmTile: TFrmSmTile;

implementation

uses edmain, ObjEdit;

{$R *.DFM}

procedure TFrmSmTile.FormShow(Sender: TObject);
var
   n: integer;
begin
   n :=  FrmMain.WilSmTiles[0].ImageCount div MIDDLEBLOCK;
   n :=  n div 3;
   if n >= 1 then TileGrid.RowCount := n
   else TileGrid.RowCount := 1;
end;

procedure TFrmSmTile.SetImageUnitCount (ucount: integer);
var
   i: integer;
begin
   UnitMax := ucount;
   TileGrid.ColCount := 3;
   TileGrid.RowCount := ucount + 1;
end;

function TFrmSmTile.GetCurrentIndex: integer;
var
   max, idx: integer;
begin
   max := FrmMain.WilSmTiles[0].ImageCount div MIDDLEBLOCK;
   idx := TileGrid.Row * TileGrid.ColCount + TileGrid.Col;
   if max > idx then Result := idx
   else Result := -1;
end;

procedure TFrmSmTile.TileGridDrawCell(Sender: TObject; Col, Row: Longint;
  Rect: TRect; State: TGridDrawState);
var
   idx: integer;
begin
   idx := Row; //Col + Row * MainPalGrid.ColCount;
   if (idx >= 0) and (idx < FrmMain.WilSmTiles[0].ImageCount) then begin
      with FrmMain.WilSmTiles[0] do begin
         if Col = 0 then begin
            DrawZoom (TileGrid.Canvas, Rect.Left, Rect.Top, idx * MIDDLEBLOCK+7*4+4+1, 1);
         end;
         if Col = 1 then
            DrawZoom (TileGrid.Canvas, Rect.Left, Rect.Top, idx * MIDDLEBLOCK, 1);
         if Col = 2 then
            DrawZoom (TileGrid.Canvas, Rect.Left, Rect.Top, idx * MIDDLEBLOCK+3*4+4+1, 1);
      end;
   end;
end;

procedure TFrmSmTile.TileGridClick(Sender: TObject);
var
   idx: integer;
begin
   FrmMain.DrawMode := mdMiddle;

   idx := TileGrid.Row; //Col + Row * MainPalGrid.ColCount;
   if (idx >= 0) and (idx < UnitMax) then begin
      FrmMain.MiddleIndex := idx;
   end;
end;

end.
