unit FObj;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, StdCtrls, ExtCtrls, HUtil32;

type
  TFrmObj = class(TForm)
    ObjGrid: TDrawGrid;
    Panel1: TPanel;
    CbWilIndexList: TComboBox;
    procedure ObjGridDrawCell(Sender: TObject; Col, Row: Longint;
      Rect: TRect; State: TGridDrawState);
    procedure FormShow(Sender: TObject);
    procedure ObjGridClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure CbWilIndexListChange(Sender: TObject);
  private
  public
    ViewNormal: Boolean;
    WilIndex: integer;
    function GetCurrentIndex: integer;
  end;

var
  FrmObj: TFrmObj;

implementation

uses
   edmain;

{$R *.DFM}


procedure TFrmObj.FormCreate(Sender: TObject);
var
  i: integer;
begin
   ViewNormal := FALSE;
   CbWilIndexList.ItemIndex := 0;
   WilIndex := 0;
   CbWilIndexList.Items.Clear;
   for i:=0 to WIlcount-1 do
   Begin

    case i of
      0: CbWilIndexList.Items.Add('objects.wil');
      1..19: CbWilIndexList.Items.Add(format('objects%d.wil',[i+1]));
      20..41: CbWilIndexList.Items.Add(format('objects%d.wil',[i - 19]));
    end;


   end;
end;

procedure TFrmObj.FormShow(Sender: TObject);
var
   n: integer;
begin
   if ViewNormal then ObjGrid.DefaultColWidth := 48
   else ObjGrid.DefaultColWidth := 24;
   n :=  _MIN(65535, FrmMain.ObjWil(WilIndex*65535).ImageCount);
   if n >= 1 then ObjGrid.ColCount := n
   else ObjGrid.ColCount := 1;
end;

procedure TFrmObj.CbWilIndexListChange(Sender: TObject);
var
   n: integer;
begin
   n := CbWilIndexList.ItemIndex;
   if n in [0..MAXWIL-1] then begin
      WilIndex := n;
      FormShow (self);
   end;
end;

procedure TFrmObj.ObjGridDrawCell(Sender: TObject; Col, Row: Longint;
  Rect: TRect; State: TGridDrawState);
var
   idx, max: integer;
begin
   idx := Col + Row * ObjGrid.ColCount;
   max := FrmMain.ObjWil(WilIndex*65535 + idx).ImageCount;
   if (idx >= 0) and (idx < max) then begin
      with FrmMain.ObjWil(WilIndex*65535 + idx) do
         if ViewNormal then
            DrawZoom (ObjGrid.Canvas, Rect.Left, Rect.Top, idx, 1)
         else
            DrawZoom (ObjGrid.Canvas, Rect.Left, Rect.Top, idx, 0.5);
   end;
end;

procedure TFrmObj.ObjGridClick(Sender: TObject);
begin
   FrmMain.DrawMode := mdObj;
end;

function TFrmObj.GetCurrentIndex: integer;
var
   max: integer;
begin
   max := FrmMain.ObjWil(WilIndex*65535).ImageCount;
   if max > ObjGrid.Col then Result := ObjGrid.Col + WilIndex * 65535
   else Result := -1;
end;

procedure TFrmObj.FormResize(Sender: TObject);
begin
   ObjGrid.DefaultRowHeight := ObjGrid.Height - 4;
end;

end.
