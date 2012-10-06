unit HGECanvas;

interface

uses
  Windows, HGE, DirectXGraphics;

type
  THGECanvas = class
  private
    D3DDevice: IDirect3DDevice8;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Circle(X, Y, Radius: Single; Color: Cardinal; Filled: Boolean; BlendMode: Integer = BLEND_Default); overload;
  end;

implementation

{ THGECanvas }

const
  TwoPI = 2 * 3.14159265358;

var
  FHGE: IHGE = nil;

procedure THGECanvas.Circle(X, Y, Radius: Single; Color: Cardinal; Filled: Boolean; BlendMode: Integer);
var
  Max, I: Integer;
  Ic, IInc: Single;
  Vertices: PHGEVertexArray;
begin
  if D3DDevice = nil then Exit;
  
  if Radius > 1000 then Radius := 1000;
  Max := Round(Radius);
  IInc := 1 / Max;
  Ic := 0;
  Vertices := FHGE.GetVertArray;
  Vertices^[0].X := x;
  Vertices^[0].Y := y;
  Vertices^[0].col := Color;
  for I := 1 to Max + 1 do
  begin
    Vertices^[I].X := X + Radius * Cos(Ic * TwoPI);
    Vertices^[I].Y := Y + Radius * Sin(Ic * TwoPI);
    Vertices^[I].col := Color;
    Ic := Ic + IInc;
  end;

  FHGE.RenderBatch;
  FHGE.SetCurPrimType(HGEPRIM_LINES);
  FHGE.SetBlendMode(BlendMode);
  if (FHGE.GetCurTexture <> nil) then
  begin
    D3DDevice.SetTexture(0,nil);
    FHGE.SetCurTexture(nil);
  end;
  if not Filled then
  begin
    Vertices^[0].X := Vertices^[Max + 1].X;
    Vertices^[0].Y := Vertices^[Max + 1].Y;
    FHGE.CopyVertices(@Vertices^, Max + 2);
    D3DDevice.DrawPrimitive(D3DPT_LINESTRIP, 0, Max + 1);
  end
  else
  begin
    FHGE.CopyVertices(@Vertices^, Max + 2);
    D3DDevice.DrawPrimitive(D3DPT_TRIANGLEFAN, 0, Max);
  end;
end;

constructor THGECanvas.Create;
begin
  inherited;
  FHGE := HGECreate(HGE_VERSION);
  D3DDevice := FHGE.GetD3DDevice;
end;

destructor THGECanvas.Destroy;
begin
  FHGE := nil;
  inherited;
end;

initialization
  FHGE := nil;

finalization
  FHGE := nil;


end.
