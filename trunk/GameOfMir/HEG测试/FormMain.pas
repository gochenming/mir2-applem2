unit FormMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, ActiveX, DirectX,  
  Dialogs, HGE, ExtCtrls, HGECanvas, HGETextures, HGEBase, HGEFonts, WIL, StdCtrls, OleCtrls, SHDocVw;

type
  TFrmMain = class(TForm)
    Timer1: TTimer;
    Button1: TButton;
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    function FrameFunc: Boolean;
    function RenderFunc: Boolean;
    procedure HGEInitialize(Sender: TObject; var Success: Boolean; var ErrorMsg: string);
    procedure HGEFinalize(Sender: TObject);
    procedure HGENotifyEvent(Sender: TObject; Msg: Cardinal);
    procedure GetScreen(var bmp: TBitMap);
  end;

Type
  TDirectDrawCreate = function(lpGUID: PGUID; out lplpDD: IDirectDraw; pUnkOuter: IUnknown): HRESULT; stdcall;

var
  FrmMain: TFrmMain;
  HGE: IHGE = nil;
  HGECanvas: TDXDrawCanvas;
  //HGETexture: TDXTexture;
  //HGEFont: TDXFont;
  ImageTexture: TDXImageTexture;
  Images: TWMBaseImages;
  Target: ITarget;
  //Canvas: THGECanvas;
  P: array[0..4] of TPoint;
  n12: Integer;
  dTick: LongWord;
  g_boFullScreen: boolean = False;
  OldWidth, OldHeight: Integer;
  h: THandle;
  FIDDraw: IDirectDraw;


implementation

uses Unit1;

{$R *.dfm}

procedure TFrmMain.Button1Click(Sender: TObject);
var
  DDSurfaceDesc: TDDSurfaceDesc;
begin
{  //
  Form1.WebBrowser1.Navigate('http://money.163.com/hkstock/');
  Form1.Show;  }
  h := LoadLibrary('DDraw.dll');
  if DD_OK = TDirectDrawCreate(GetProcAddress(h, 'DirectDrawCreate'))(nil, FIDDraw, nil) then begin
    DDSurfaceDesc.dwSize := SizeOf(TDDSurfaceDesc);
    FIDDraw.GetDisplayMode(DDSurfaceDesc);
    FIDDraw.SetDisplayMode(800, 600, 16);
  end;
end;

procedure TFrmMain.Button2Click(Sender: TObject);
//var
  //DC: HDC;
  //Bitmap: TBitmap;
begin
  FIDDraw := nil;
  FreeLibrary(h);
{  //DC := GetDC(WebBrowser1.Handle);
  Bitmap := TBitmap.Create;
  GetScreen(Bitmap);
  //Bitmap.Canvas.Handle := DC;
  Bitmap.SaveToFile('d:\ccc.bmp');
  Bitmap.Free; }
end;

procedure TFrmMain.GetScreen(var bmp: TBitMap); //截取全屏
var
  DC: HDC;
  MyCanvas: TCanvas;
  MyRect: TRect;
  ViewObject2: IViewObject2;
  rc: TRect;
begin
  //DC := GetWindowDC(0);
  Form1.WebBrowser1.Document.QueryInterface(IViewObject2, ViewObject2);


  //DC := GetDC(Form1.WebBrowser1.Handle);
  //Form1.WebBrowser1.PaintTo(DC, 0, 0);
  Form1.Width := 800;
  Form1.Height := 600;
  rc.Top := 0;
  rc.Left := 0;
  rc.Right := Form1.WebBrowser1.Width;
  rc.Bottom := Form1.WebBrowser1.Height;
  MyCanvas := TCanvas.Create;
  try

    MyRect := Rect(0, 0, Form1.WebBrowser1.Width, Form1.WebBrowser1.Height);
    bmp := TBitMap.Create;
    bmp.PixelFormat := pf24bit;
    bmp.Width := MyRect.Right;
    bmp.Height := MyRect.Bottom;
    //bmp.Canvas.CopyRect(MyRect, MyCanvas, MyRect);
    ViewObject2.Draw(DVASPECT_CONTENT, -1, nil, nil, 0, bmp.Canvas.Handle, @rc, nil, nil, 0);
  finally
    MyCanvas.Handle := 0;
    MyCanvas.Free;
    //releaseDC(0, DC);
  end;
  ViewObject2 := nil;
end;

procedure TFrmMain.FormCreate(Sender: TObject);
begin
  Left := 0;
  Top := 0;
  ClientHeight := 600;
  ClientWidth := 800;
  OldWidth := Screen.Width;
  OldHeight := Screen.Height;

  HGE := HGECreate(HGE_VERSION);
  HGE.System_SetState(HGE_FRAMEFUNC, FrameFunc);
  HGE.System_SetState(HGE_RENDERFUNC, RenderFunc);
  //HGE.System_SetState(HGE_USESOUND, False);
  HGE.System_SetState(HGE_INITIALIZE, HGEInitialize);
  HGE.System_SetState(HGE_FINALIZE, HGEFinalize);
  HGE.System_SetState(HGE_NOTIFYEVENT, HGENotifyEvent);

  HGE.System_SetState(HGE_WINDOWED, True);
  HGE.System_SetState(HGE_SCREENWIDTH, ClientWidth);
  HGE.System_SetState(HGE_SCREENHEIGHT, ClientHeight);
  HGE.System_SetState(HGE_SCREENBPP, 16);
  HGE.System_SetState(HGE_HIDEMOUSE, False);
  HGE.System_SetState(HGE_HWNDPARENT, Handle);
  HGE.System_SetState(HGE_SHOWSPLASH, False);
  HGE.System_SetState(HGE_HARDWARE, True);

  HGE.System_SetState(HGE_TEXTUREFILTER, True);
  HGE.System_SetState(HGE_FPS, HGEFPS_VSYNC);
  //Canvas := THGeCanvas.Create;
  //Images := THGEImages.Create;

  if (HGE.System_Initiate) then begin
    //Images.LoadFromFile('bg2.png');
    HGETextures.InitializeTexturesInfo;
    {HGEFont := TDXFont.Create;
    HGEFont.CreateTexture;
    HGEFont.Initialize('宋体', 9);     }
    HGECanvas := TDXDrawCanvas.Create(nil);
    //HGETexture := TDXTexture.Create;
    ImageTexture := TDXImageTexture.Create(HGECanvas);
    //HGETexture.LoadFromFile('Images00.jpg');
    ImageTexture.LoadFromFile('01.bmp');
    Images := CreateWMImages(t_wmMyImage);
    Images.FileName := 'E:\网络游戏\热血传奇2\Resource\Data\Prguse.pak';
    Images.LibType := ltUseCache;
    Images.Initialize;
    n12 := 0;
    dTick := GetTickCount + 1000;
    //Target := HGE.Target_Create(800, 600, False);
    HGE.System_Start;

    Timer1.Enabled := True;
  end
  else
    MessageBox(0, PChar(HGE.System_GetErrorMessage), 'Error', MB_OK or MB_ICONERROR or MB_SYSTEMMODAL);

end;

procedure TFrmMain.FormDestroy(Sender: TObject);
begin
  Images.Finalize;
  Images.Free;
  Target := nil;
  //HGEFont.Free;
  //ImageTexture.Free;
  //HGETexture.Free;
  HGECanvas.Free;
  HGE := nil;
end;

procedure TFrmMain.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  lpDevMode: TDeviceMode;
  //  ENUM_CURRENT_SETTINGS:DWORD;
begin

  if (ssAlt in Shift) and (Key = VK_RETURN) then begin
    g_boFullScreen := not g_boFullScreen;
    if g_boFullScreen then begin
      BorderStyle := bsNone;
      BorderIcons := [];

      ClientWidth := 800;
      ClientHeight := 600;
      WindowState := wsMaximized;

      if EnumDisplaySettings(nil, $FFFFFFFF, lpDevMode) then begin
        lpDevMode.dmFields := DM_PELSWIDTH or DM_PELSHEIGHT;
        lpDevMode.dmPelsWidth := 800;
        lpDevMode.dmPelsHeight := 600;
        ChangeDisplaySettings(lpDevMode, 0);
      end;
    end
    else begin
      if EnumDisplaySettings(nil, 0, lpDevMode) then begin
        lpDevMode.dmFields := DM_PELSWIDTH or DM_PELSHEIGHT or DM_DISPLAYFREQUENCY;
        lpDevMode.dmPelsWidth := OldWidth;
        lpDevMode.dmPelsHeight := OldHeight;
        lpDevMode.dmDisplayFrequency := 75;
        ChangeDisplaySettings(lpDevMode, 0);
      end;
      BorderStyle := bsSingle;
      FormStyle := fsNormal;
      WindowState := wsNormal;
      ClientWidth := HGE.System_GetState(HGE_SCREENWIDTH);
      ClientHeight := HGE.System_GetState(HGE_SCREENHEIGHT);
      BorderIcons := [biSystemMenu, biMinimize];
      Left := (Screen.width - ClientWidth) div 2;
      Top := (Screen.Height - ClientHeight) div 2 - 40;
      SetWindowPos(handle, HWND_NOTOPMOST, left, top, width, height, SWP_SHOWWINDOW);
    end;
    //HGE.System_SetState(HGE_WINDOWED, not HGE.System_GetState(HGE_WINDOWED));
  end;

end;

procedure TFrmMain.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  showmessage('123123');
end;

function TFrmMain.FrameFunc: Boolean;
begin
  {case HGE.Input_GetKey of
    HGEK_ESCAPE: begin
        // FreeAndNil(Canvas);
        // FreeAndNil(Images);
        Result := True;
        HGE.System_Shutdown;
        Exit;
      end;
  end;            }
  Result := False;
end;

procedure TFrmMain.HGEFinalize(Sender: TObject);
begin

end;

procedure TFrmMain.HGEInitialize(Sender: TObject; var Success: Boolean; var ErrorMsg: string);
begin

end;

procedure TFrmMain.HGENotifyEvent(Sender: TObject; Msg: Cardinal);
begin

end;

function TFrmMain.RenderFunc: Boolean;
begin
  {HGE.Gfx_BeginScene(Target);
  HGE.Gfx_Clear(0);
  HGE.Gfx_BeginScene;

  //HGECanvas.Draw(HGETexture.Image, 0, 0, fxNone);
  HGECanvas.Draw(HGETexture.Image, 0, 0, fxNone);

  HGE.Gfx_EndScene; }

  HGE.Gfx_BeginScene;
  HGE.Gfx_Clear(2131232);
  HGE.RenderBatch;
  //HGECanvas.DrawStretch(HGETexture, 0, 0, 600, 420, Rect(400, 200, 0, 0), fxNone);
  HGECanvas.Draw(ImageTexture, 0, 0, fxNone);
  //HGECanvas.Draw(Images.Images[1], 100, 100, fxBlend);
  HGECanvas.Draw(Images.Images[252], 200, 200, fxNone);
  //ImageTexture.Image.
  //HGECanvas.StretchDraw(Images.Images[252].ClientRect, Rect(100, 100, 100, Images.Images[268].Height), Images.Images[268], False);
 // HGECanvas.Quadrangle4Color(50, 400, 300, 400, 200, 550, 50, 550, ARGB(255, 255, 0, 0), ARGB(255, 0, 255, 0), ARGB(255, 0, 0, 255), ARGB(255, 255, 255, 0), True);

  //HGECanvas.TextOut(150, 50, '测试中文abcd1234234234中文〓Ⅻβㄉ', clWhite{, [tfRight]});
  {HGECanvas.FillHexagon(Point(100, 100), Point(260, 100), Point(260, 260), Point(420, 200),
    Point(420, 420), Point(100, 420), $800000FF or clWhite, fxBlend);         }
  {if GetTickCount > dTick then begin
    Inc(n12);
    if n12 > 100 then n12 := 0;
    dTick := GetTickCount + 500;
  end;  }
  ///HGECanvas.DrawTriangle(n12, 100, 100, Images.Images[252], $FFFFFFFF, fxBlend);
 // HGECanvas.DrawSquareSchedule(n12, 100, 100, Images.Images[252].ClientRect, Images.Images[252], $FFFFFFFF, fxBlend);
  //HGECanvas.Triangle(350, 50, 350, 150, 450, 150, ARGB(255, 0, 0, 255), True);
  //HGECanvas.FillSquareSchedule(n12, Rect(100, 100, 500, 500), $800000FF, fxBlend);
                 //n12 := 0;
   // dTick := GetTickCount + 5000;
  //HGECanvas.Triangle(400, 50, 350, 150, 450, 150, ARGB(255, 0, 0, 255), True);
  //ImageTexture.StretchDraw(Rect(0, 0, 400, 400), Rect(100, 100, 400, 400), ImageTexture, fxNone);
  //HGECanvas.DrawRect(HGEFont.DXTexture, 280, 100, 0, 0, 300, 300, fxBlend, $FFFF00FF);
  //HGECanvas.Draw(ImageTexture.Image, 280, 100, fxNone);
  //HGECanvas.Draw(ImageTexture.Image, 280, 300, fxAnti);
  //HGECanvas.Circle(100, 100, 60, ARGB(255, 255, 0, 0), True);
  //HGECanvas.Circle(250, 100, 60, 4, ARGB(255, 0, 255, 0), False);
 {HGECanvas.Triangle(400, 50, 350, 150, 450, 150, ARGB(255, 0, 0, 255), True);
  HGECanvas.Ellipse(550, 100, 80, 50, ARGB(255, 255, 255, 0), True);
  HGECanvas.Ellipse(710, 100, 50, 80, ARGB(255, 255, 0, 255), False);
  HGECanvas.Arc(100, 250, 60, 50, 300, ARGB(255, 0, 255, 0), True, TRue);
  HGECanvas.Line2Color(200, 200, 300, 300, ARGB(255, 255, 0, 0), ARGB(255, 0, 0, 255), Blend_Default);
  HGECanvas.Line2Color(200, 300, 300, 200, ARGB(255, 255, 255, 0), ARGB(255, 0, 255, 255), Blend_Default); }
  //HGECanvas.Rectangle(330, 200, 150, 150, ARGB(255, 255, 0, 255), True);
  //HGECanvas.FillRect(Rect(330, 200, 330 + 150, 200 + 150), cColor4($FF000000 or clRed), fxNone);
  //HGECanvas.RoundRect(330, 200, 330 + 150, 200 + 150, clWhite);
  //HGECanvas.Rectangle(510, 200, 150, 150, ARGB(255, 0, 255, 255), False);
  //HGECanvas.Rectangle(330, 200, 150, 150, ARGB(255, 255, 0, 255), True);
  //HGECanvas.Quadrangle4Color(50, 400, 200, 400, 200, 550, 50, 550, ARGB(255, 255, 0, 0), ARGB(255, 0, 255, 0), ARGB(255, 0, 0, 255), ARGB(255, 255, 255, 0), True);
  //HGECanvas.Quadrangle4Color(250, 400, 400, 400, 400, 550, 250, 550, ARGB(255, 255, 0, 0), ARGB(255, 0, 255, 0), ARGB(255, 0, 0, 255), ARGB(255, 255, 255, 0), False);
  //MyDevice.Canvas.FillPentagon(Point2(10, 10), Point2(110, 10), Point2(60, 60), Point2(60, 110), Point2(10, 110), clWhite, fxNone);
  //HGECanvas.RoundRect(330, 200, 330 + 150, 200 + 150, 0, 0, clWhite);
  {P[0] := Point(10, 10);
  P[1] := Point(110, 10);
  P[2] := Point(60, 60);
  P[3] := Point(40, 110);
  P[4] := point(10, 110);
  HGECanvas.FillPentagon(Point(10, 10), Point(110, 10), Point(60, 60), Point(60, 110), Point(10, 110), clWhite, fxBlend);
  HGECanvas.Polygon(P, ARGB(255, 55, 255, 150), True);    }
  //HGECanvas.FillPentagon(Point(10, 10), Point(110, 10), Point(60, 60), Point(60, 110), Point(10, 110), clWhite, fxBlend);
  //HGECanvas.Triangle(400, 50, 350, 150, 450, 150, ARGB(255, 0, 0, 255), True);
  //HGECanvas.FillTriangle(Point(100, 100), Point(260, 100), Point(260, 260), clWhite, fxNone);
  //HGECanvas.Quadrangle4Color(50, 400, 200, 400, 200, 550, 50, 550, ARGB(255, 255, 0, 0), ARGB(255, 0, 255, 0), ARGB(255, 0, 0, 255), ARGB(255, 255, 255, 0), True);
  //HGECanvas.FillQuadrangle(Point(100, 100), Point(260, 100), Point(260, 260), Point(100, 220), clWhite, fxNone);
  //HGECanvas.FillHexagon(Point(100, 100), Point(260, 100), Point(260, 260), Point(420, 200),
    //Point(420, 420), Point(100, 420), clWhite, fxBlend);
    //HGECanvas.FillPentagon(Point(10, 10), Point(110, 10), Point(60, 60), Point(60, 110), Point(10, 110), $FF000000 or clWhite, fxBlend);
  HGE.Gfx_EndScene;
  Result := False;
end;

procedure TFrmMain.Timer1Timer(Sender: TObject);
begin
  HGE.System_Start;
  {if FrameFunc then begin
    HGE.System_Shutdown;
    Exit;
  end;
  RenderFunc;
  HGE.ClearQueue;    }
end;

end.

