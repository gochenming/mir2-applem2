unit JSDevices;

interface

uses
  Windows, SysUtils, Classes;

Type
  TInitializeEvent = procedure(Sender: TObject; var Success: Boolean; var ErrorMsg: string) of object;
  TDeviceNotifyEvent = procedure(Sender: TObject; Msg: Cardinal) of object;

  TBitDepth = (bdLow, bdHigh);
  
  TDXDevice = class(TComponent)
  private
    procedure SetState(const Index: Integer; const Value: Boolean);
    procedure SetWindowHandle(const Value: THandle);
    procedure SetBitDepth(const Value: TBitDepth);
    procedure SetDepthBuffer(const Value: Boolean);
    procedure SetSize(const Index, Value: Integer);
    procedure SetRefresh(const Value: Integer);
  protected
    FScreenWidth: Integer;
    FScreenHeight: Integer;
    FBitDepth: TBitDepth; //表面深度
    FRefresh: Integer; //更新速度

    FWindowed: Boolean; //是否窗口化
    FWindowHandle: THandle; //屏幕窗口句柄, 0为父窗口
    FInitialized: Boolean; //是否已初始化
    FVSync: Boolean; //垂直同步
    FHardwareTL: Boolean; //是否开启硬件加速
    FDepthBuffer: Boolean; //是否打开深度缓冲
    FLockBackBuffer: Boolean; //允许锁定后备缓冲区
    FErrorMsg: string;
    FAvailableTextureMem: LongWord;

    FOnFinalize: TNotifyEvent;
    FOnInitialize: TInitializeEvent;
    FOnRender: TNotifyEvent;
    FOnNotifyEvent: TDeviceNotifyEvent;
    //procedure RefreshPresentParams(); virtual; abstract;
    //procedure UpdatePresentParams(); virtual; abstract;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy(); override;

    function Reset(): Boolean;

    function Initialize(): Boolean; virtual;
    function Finalize(): Boolean; virtual;

    property LastError: string read FErrorMsg;
    property AvailableTextureMem: LongWord read FAvailableTextureMem;
  published

    property ScreenWidth: Integer index 0 read FScreenWidth write SetSize;
    property ScreenHeight: Integer index 1 read FScreenHeight write SetSize;
    property BitDepth: TBitDepth read FBitDepth write SetBitDepth;
    property Refresh: Integer read FRefresh write SetRefresh;

    property Windowed: Boolean index 0 read FWindowed write SetState;
    property VSync: Boolean index 1 read FVSync write SetState;
    property HardwareTL: Boolean index 2 read FHardwareTL write SetState;
    property LockBackBuffer: Boolean read FLockBackBuffer write FLockBackBuffer;

    property DepthBuffer: Boolean read FDepthBuffer write SetDepthBuffer;
    property WindowHandle: THandle read FWindowHandle write SetWindowHandle;

    property OnInitialize: TInitializeEvent read FOnInitialize write FOnInitialize;
    property OnFinalize: TNotifyEvent read FOnFinalize write FOnFinalize;
    property OnRender: TNotifyEvent read FOnRender write FOnRender;
    property OnNotifyEvent: TDeviceNotifyEvent read FOnNotifyEvent write FOnNotifyEvent;
  end;

procedure Register;

implementation

uses
  JSDX9Device, JSDX8Device;

{ TDXDevice }

procedure Register;
begin
  RegisterComponents('JSD3D', [TDX8Device]);
end;

constructor TDXDevice.Create(AOwner: TComponent);
begin
  inherited;
  FInitialized := False;
  FWindowed := True;
  FWindowHandle := 0;
  FVSync := True;
  FHardwareTL := False;
  FOnInitialize := nil;

  FScreenWidth := 800;
  FScreenHeight := 600;
  FBitDepth := bdLow;

  FDepthBuffer := True;
  FLockBackBuffer := False;

  FOnFinalize := nil;
  FOnInitialize := nil;
  FOnRender := nil;
  FOnNotifyEvent := nil;

  FErrorMsg := '';
  FAvailableTextureMem := 0;
end;

destructor TDXDevice.Destroy;
begin

  inherited;
end;


function TDXDevice.Finalize: Boolean;
begin
  Result := False;
end;

function TDXDevice.Initialize: Boolean;
begin
  Result := False;
end;

function TDXDevice.Reset: Boolean;
begin
  Result := False;
end;

procedure TDXDevice.SetBitDepth(const Value: TBitDepth);
begin
  FBitDepth := Value;
end;

procedure TDXDevice.SetDepthBuffer(const Value: Boolean);
begin
  if (not FInitialized) then
    FDepthBuffer := Value;
end;

procedure TDXDevice.SetRefresh(const Value: Integer);
begin
  if (not FInitialized) then
    FRefresh := Value;
end;

procedure TDXDevice.SetSize(const Index, Value: Integer);
begin
  case Index of
    0: FScreenWidth := Value;
    1: FScreenHeight := Value;
  end;
  if (FInitialized) then
    Reset();
end;

procedure TDXDevice.SetState(const Index: Integer; const Value: Boolean);
begin
  case Index of
    0: FWindowed := Value;
    1: FVSync := Value;
    2: FHardwareTL := Value;
  end;
  if (FInitialized) then
    Reset();
end;

procedure TDXDevice.SetWindowHandle(const Value: THandle);
begin
  if (not FInitialized) then
    FWindowHandle := Value;
end;

end.
