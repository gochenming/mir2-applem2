unit JSDX8Device;

interface

uses
  Windows, SysUtils, Classes, JSD3DX81mo, JSDirect8, JSDevices, Forms, JSDXBase;

Type
  TDX8Device = class(TDXDevice)
  private
    FDI8: TD3DAdapter_Identifier8;
    FMatView: TD3DXMatrix;
    FMatProj: TD3DXMatrix;
    function FormatId(const Fmt: TD3DFormat): Integer;
    procedure SetProjectionMatrix(const Width, Height: Integer);
  protected

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy(); override;

    function Initialize(): Boolean; override;
    function Finalize(): Boolean; override;
  end;

var
  Direct3D8: IDirect3D8 = nil;
  Direct3D8Device: IDirect3DDevice8 = nil;
  Direct3D8PresentParams: TD3DPresentParameters;
  Device3D8Caps: TD3DCaps8;
  //Direct3D8Compatible: Boolean = False;
  
implementation

{ TDX8Device }

constructor TDX8Device.Create(AOwner: TComponent);
begin
  inherited;
  
end;

destructor TDX8Device.Destroy;
begin

  inherited;
end;

function TDX8Device.Finalize: Boolean;
begin
  Result := False;
end;

function TDX8Device.Initialize: Boolean;
var
  Mode: TD3DDisplayMode;
  WindowHandle: THandle;
  Format: TD3DFormat;
  NModes, I: Longword;
  Res: Integer;
begin
  Result := False;
  FErrorMsg := 'Has been initialized';
  if (FInitialized) or (Direct3D8 <> nil) or (Direct3D8Device <> nil) then Exit;

  FErrorMsg := 'Can''t Create Direct3D';
  Direct3D8 := Direct3DCreate8(D3D_SDK_VERSION);
  if (Direct3D8 = nil) then Exit;

  FillChar(FDI8, SizeOf(FDI8), #0);
  Direct3D8.GetAdapterIdentifier(D3DADAPTER_DEFAULT, D3DENUM_NO_WHQL_LEVEL, FDI8);

  FillChar(Direct3D8PresentParams, SizeOf(TD3DPresentParameters), 0);

  if (FWindowHandle = 0) then begin
    if (Assigned(Owner)) and (Owner is TCustomForm) then begin
      WindowHandle := TCustomForm(Owner).Handle;
    end else begin
      FErrorMsg := 'WindowHandle is null';
      Exit;
    end;
  end
  else
    WindowHandle := FWindowHandle;

  if FWindowed then begin
  
    if (Failed(Direct3D8.GetAdapterDisplayMode(D3DADAPTER_DEFAULT, Mode))) or (Mode.Format = D3DFMT_UNKNOWN) then begin
      FErrorMsg := 'Can''t determine desktop video mode';
      Exit;
    end;

    Direct3D8PresentParams.BackBufferWidth  := FScreenWidth;
    Direct3D8PresentParams.BackBufferHeight := FScreenHeight;
    Direct3D8PresentParams.BackBufferFormat := Mode.Format;
    Direct3D8PresentParams.BackBufferCount  := 1;
    Direct3D8PresentParams.MultiSampleType  := D3DMULTISAMPLE_NONE;
    Direct3D8PresentParams.hDeviceWindow    := WindowHandle;
    Direct3D8PresentParams.Windowed         := True;

    if FVSync then Direct3D8PresentParams.SwapEffect := D3DSWAPEFFECT_COPY_VSYNC
    else Direct3D8PresentParams.SwapEffect := D3DSWAPEFFECT_COPY;

    if (FDepthBuffer) then begin
      Direct3D8PresentParams.EnableAutoDepthStencil := True;
      Direct3D8PresentParams.AutoDepthStencilFormat := D3DFMT_D16;
    end;
  end else begin
    Format := D3DFMT_UNKNOWN;
    
    NModes := Direct3D8.GetAdapterModeCount(D3DADAPTER_DEFAULT);
    for I := 0 to NModes - 1 do begin
      Direct3D8.EnumAdapterModes(D3DADAPTER_DEFAULT, I, Mode);
      if (Integer(Mode.Width) <> FScreenWidth) or (Integer(Mode.Height) <> FScreenHeight) then Continue;
      if (FBitDepth = bdLow) and (FormatId(Mode.Format) > FormatId(D3DFMT_A1R5G5B5)) then Continue;
      if (FormatId(Mode.Format) > FormatId(Format)) then Format := Mode.Format;
    end;
    if (Format = D3DFMT_UNKNOWN) then begin
      FErrorMsg := 'Can''t find appropriate full screen video mode';
      Exit;
    end;

    Direct3D8PresentParams.BackBufferWidth  := FScreenWidth;
    Direct3D8PresentParams.BackBufferHeight := FScreenHeight;
    Direct3D8PresentParams.BackBufferFormat := Format;
    Direct3D8PresentParams.BackBufferCount  := 1;
    Direct3D8PresentParams.MultiSampleType  := D3DMULTISAMPLE_NONE;
    Direct3D8PresentParams.hDeviceWindow    := WindowHandle;
    Direct3D8PresentParams.Windowed         := False;

    Direct3D8PresentParams.SwapEffect       := D3DSWAPEFFECT_FLIP;
    Direct3D8PresentParams.FullScreen_RefreshRateInHz := D3DPRESENT_RATE_DEFAULT;

    if FVSync then
      Direct3D8PresentParams.FullScreen_PresentationInterval := D3DPRESENT_INTERVAL_ONE
    else
      Direct3D8PresentParams.FullScreen_PresentationInterval := D3DPRESENT_INTERVAL_IMMEDIATE;

     if FDepthBuffer then begin
      Direct3D8PresentParams.EnableAutoDepthStencil := True;
      Direct3D8PresentParams.AutoDepthStencilFormat := D3DFMT_D16;
    end;
  end;

  if FLockBackBuffer then
    Direct3D8PresentParams.Flags := D3DPRESENTFLAG_LOCKABLE_BACKBUFFER;

  if (FormatId(Direct3D8PresentParams.BackBufferFormat) < 4) then FBitDepth := bdLow
  else FBitDepth := bdHigh;

  FErrorMsg := 'Can''t create D3D device';
  if (FHardwareTL) then begin
    Res := Direct3D8.CreateDevice(D3DADAPTER_DEFAULT, D3DDEVTYPE_HAL, WindowHandle, D3DCREATE_HARDWARE_VERTEXPROCESSING, Direct3D8PresentParams, Direct3D8Device)
  end else Res := D3D_OK;

  if Failed(Res) or (not FHardwareTL) then begin
    Res := Direct3D8.CreateDevice(D3DADAPTER_DEFAULT, D3DDEVTYPE_HAL, WindowHandle, D3DCREATE_SOFTWARE_VERTEXPROCESSING, Direct3D8PresentParams, Direct3D8Device);
  end;

  if Failed(Res) then Exit;

  FErrorMsg := 'Can''t GetDeviceCaps';
  FAvailableTextureMem := Direct3D8Device.GetAvailableTextureMem;
  Result := Succeeded(Direct3D8Device.GetDeviceCaps(Device3D8Caps));

  if Result then begin
    FErrorMsg := 'Computer configuration to run the game not meet the minimum requirements';
    Result := (Device3D8Caps.MaxTextureWidth > 2000) and (Device3D8Caps.MaxTextureHeight > 2000) and (FAvailableTextureMem > 7 * 1024 * 1024);
  end;

  FInitialized := Result;
  if (Result) then begin

    //Direct3D8Device.SetDialogBoxMode(TRUE);

    SetProjectionMatrix(FScreenWidth, FScreenHeight);
    D3DXMatrixIdentity(FMatView);

    if Assigned(FOnNotifyEvent) then
      FOnNotifyEvent(Self, msgDeviceInitialize);
      
    if (not Result) then Finalize();
    
    if (Assigned(FOnInitialize)) then begin
      FOnInitialize(Self, Result, FErrorMsg);
      if (not Result) then Finalize();
    end;
  end;
end;

procedure TDX8Device.SetProjectionMatrix(const Width, Height: Integer);
var
  Tmp: TD3DXMatrix;
begin
  D3DXMatrixScaling(FMatProj, 1.0, -1.0, 1.0);
  D3DXMatrixTranslation(Tmp,-0.5, Height + 0.5, 0.0);
  D3DXMatrixMultiply(FMatProj, FMatProj, Tmp);
  D3DXMatrixOrthoOffCenterLH(Tmp, 0, Width, 0, Height, 0.0, 1.0);
  D3DXMatrixMultiply(FMatProj, FMatProj, Tmp);
end;

function TDX8Device.FormatId(const Fmt: TD3DFormat): Integer;
begin
  case Fmt of
    D3DFMT_R5G6B5:
      Result := 1;
    D3DFMT_X1R5G5B5:
      Result := 2;
    D3DFMT_A1R5G5B5:
      Result := 3;
    D3DFMT_X8R8G8B8:
      Result := 4;
    D3DFMT_A8R8G8B8:
      Result := 5;
  else
    Result := 0;
  end;
end;
(*
procedure TDX8Device.RefreshPresentParams(Mode: PD3DDisplayMode);
begin

  with Direct3D8PresentParams do begin
    Windowed := Self.FWindowed;

    if (FWindowHandle = 0) then begin
      if (Assigned(Owner)) and (Owner is TCustomForm) then
        hDeviceWindow := TCustomForm(Owner).Handle;
    end
    else
      hDeviceWindow := FWindowHandle;

    BackBufferWidth := FScreenWidth;
    BackBufferHeight := FScreenHeight;
    SwapEffect := D3DSWAPEFFECT_DISCARD;
    MultiSampleType := D3DMULTISAMPLE_NONE;
    BackBufferCount := 1;

    if (not FWindowed) then
      BackBufferFormat := DXBestBackFormat(FBitDepth = bdHigh, FScreenWidth, FScreenHeight, FRefresh)
    else
      BackBufferFormat := DXGetDisplayFormat();

    FullScreen_RefreshRateInHz := FRefresh;
    FullScreen_PresentationInterval := D3DPRESENT_INTERVAL_IMMEDIATE;
    if (FVSync) then
      FullScreen_PresentationInterval := D3DPRESENT_INTERVAL_ONE;

    if FLockBackBuffer {and FWindowed} then
      Flags := D3DPRESENTFLAG_LOCKABLE_BACKBUFFER;

    if (FDepthBuffer) then begin
      EnableAutoDepthStencil := True;
      //Flags := D3DPRESENTFLAG_DISCARD_DEPTHSTENCIL or Flags;

      AutoDepthStencilFormat := D3DFMT_D16;
    end;
  end;
end;

procedure TDX8Device.UpdatePresentParams;
begin
  {with Direct3D8PresentParams do begin
    BackBufferWidth := FWidth;
    BackBufferHeight := FHeight;
    Windowed := FWindowed;

    if (not FWindowed) then
      BackBufferFormat := DXBestBackFormat(FBitDepth = bdHigh, FWidth, FHeight, FRefresh)
    else
      BackBufferFormat := DXGetDisplayFormat();

    FullScreen_PresentationInterval := D3DPRESENT_INTERVAL_IMMEDIATE;
    if (VSync) then
      FullScreen_PresentationInterval := D3DPRESENT_INTERVAL_ONE;

  end; }
end;     *)

end.
