unit D3DDevices;

interface
uses
  Windows, SysUtils, Classes;

type
  TCustomDevice = class(TComponent)
  private
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy(); override;
  published
  end;

implementation

{ TCustomDevice }

constructor TCustomDevice.Create(AOwner: TComponent);
begin
  inherited;

end;

destructor TCustomDevice.Destroy;
begin

  inherited;
end;

end.

