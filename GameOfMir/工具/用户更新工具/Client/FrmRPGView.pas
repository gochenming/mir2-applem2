unit FrmRPGView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, TDX9Textures, MyDXBase, Bass, wmMyImage, Wil, MyDirect3D9, DES, 
  Dialogs, bsSkinCtrls, bsSkinData, ImgList, bsSkinExCtrls, bsColorCtrls, bsSkinBoxCtrls, StdCtrls, Mask, bsSkinGrids, ExtCtrls, TDX9Devices;


const
  MAXWIDTH = 800;
  MAXHEIGHT = 600;
  WINLEFT = 60;
  WINTOP = 60;
  WINRIGHT = MAXWIDTH - 60;
  BOTTOMEDGE = MAXHEIGHT - 60;

  IMAGEOFFSETDIR = 'Placements\';


type
  TFrameRPGView = class(TFrame)
    GroupBoxBg: TbsSkinGroupBox;
    DSkinData: TbsSkinData;
    GroupBoxDrawList: TbsSkinGroupBox;
    DrawGrid: TbsSkinDrawGrid;
    ScrollBarDrawListRight: TbsSkinScrollBar;
    ScrollBarDrawListBottom: TbsSkinScrollBar;
    ToolBarButton: TbsSkinToolBar;
    Tool_New: TbsSkinSpeedButton;
    Tool_AUTOIMAGE: TbsSkinSpeedButton;
    bsSkinDivider1: TbsSkinDivider;
    CloseButton: TbsSkinSpeedButton;
    OpenButton: TbsSkinSpeedButton;
    Tool_Image_Add: TbsSkinSpeedButton;
    bsSkinDivider2: TbsSkinDivider;
    Tool_Image_Del: TbsSkinSpeedButton;
    bsSkinDivider3: TbsSkinDivider;
    Tool_Position: TbsSkinSpeedButton;
    Tool_Image_Goto: TbsSkinSpeedButton;
    Tool_Front: TbsSkinSpeedButton;
    bsSkinDivider4: TbsSkinDivider;
    Tool_Next: TbsSkinSpeedButton;
    Tool_Middle: TbsSkinSpeedButton;
    Tool_Random: TbsSkinSpeedButton;
    bsSkinDivider5: TbsSkinDivider;
    BlendColor: TbsSkinColorButton;
    BGColor: TbsSkinColorButton;
    Tool_Zoom: TbsSkinComboBox;
    Tool_BlendMode: TbsSkinComboBox;
    Tool_Alpha: TbsSkinTrackEdit;
    ToolBarLabel: TbsSkinToolBar;
    Panel2: TbsSkinStatusPanel;
    Panel1: TbsSkinStatusPanel;
    Panel3: TbsSkinStatusPanel;
    Panel4: TbsSkinStatusPanel;
    Panel6: TbsSkinStatusPanel;
    Panel7: TbsSkinStatusPanel;
    GroupBoxRight: TbsSkinGroupBox;
    GroupBoxMusic: TbsSkinGroupBox;
    ScrollBar1: TbsSkinTrackBar;
    GroupBoxDrawImage: TbsSkinGroupBox;
    BoxScrollBarRight: TbsSkinScrollBar;
    BoxSkinScrollBarBottom: TbsSkinScrollBar;
    ScrollBoxDraw: TbsSkinScrollBox;
    PanelDraw: TPanel;
    bt_Music_Play: TbsSkinButton;
    bt_Music_Stop: TbsSkinButton;
    bt_Music_Pause: TbsSkinButton;
    MyDevice: TDX9Device;
    Tool_Image_Put: TbsSkinSpeedButton;
    Panel5: TbsSkinStatusPanel;
    TimerMusic: TTimer;
    PaintBox: TPaintBox;
    Timer: TTimer;
    ToolbarImages: TImageList;
    ButtonChangePackFormat: TbsSkinSpeedButton;
    procedure PaintBoxPanelPaint(Cnvs: TCanvas; R: TRect);
    procedure Tool_NewClick(Sender: TObject);
    procedure OpenButtonClick(Sender: TObject);
    procedure BGColorChangeColor(Sender: TObject);
    procedure DrawGridDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure bt_Music_PlayClick(Sender: TObject);
    procedure bt_Music_StopClick(Sender: TObject);
    procedure bt_Music_PauseClick(Sender: TObject);
    procedure DrawGridSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
    procedure TimerMusicTimer(Sender: TObject);
    procedure ScrollBar1Change(Sender: TObject);
    procedure PaintBoxPaint(Sender: TObject);
    procedure MyDeviceInitialize(Sender: TObject; var Success: Boolean; var ErrorMsg: string);
    procedure TimerTimer(Sender: TObject);
    procedure MyDeviceFinalize(Sender: TObject);
    procedure MyDeviceNotifyEvent(Sender: TObject; Msg: Cardinal);
    procedure MyDeviceRender(Sender: TObject);
    procedure Tool_BlendModeChange(Sender: TObject);
    procedure Tool_ZoomChange(Sender: TObject);
    procedure Tool_AUTOIMAGEClick(Sender: TObject);
    procedure Tool_FrontClick(Sender: TObject);
    procedure PanelDrawMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure PanelDrawMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure PanelDrawMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure CloseButtonClick(Sender: TObject);
    procedure Tool_Image_GotoClick(Sender: TObject);
    procedure Tool_Image_DelClick(Sender: TObject);
    procedure Tool_Image_PutClick(Sender: TObject);
    procedure Tool_Image_AddClick(Sender: TObject);
    procedure ButtonChangePackFormatClick(Sender: TObject);
  private
    FboState: Boolean;
    FCanMusic: Boolean;
    FCanDraw: Boolean;
    procedure OpenWMFile(sFileName: string);
    procedure InitializeForm();
    procedure InitializeGrid();
    procedure RefStatusBar();
    function SetDrawGridIndex(Index: Integer): Boolean;
  public
    procedure Open();
    procedure Close();
    procedure Init();
    procedure UnInit();
    procedure Finalize;
    procedure Initialize;
    procedure DrawRender(Sender: TObject);

  end;

var
  g_Texture: array[0..1] of TDXImageTexture;

implementation

uses FrmMain, FShare, Hutil32, FrmRPGDelete, FrmRPGOut, FrmRPGAppend;

{$R *.dfm}

var
  BltBitmap: TBitmap;
  hs: HSTREAM;  {流句柄}
  BackColor: TColor = $808080;
  AlphaColor: TColor = clWhite;
  FFTData: array[0..2048] of Single;
  FFTPeacks  : array [0..2048] of Integer;
  FFTFallOff : array [0..2048] of Integer;
  DataStream: TMemoryStream;
  boStop: Boolean;
  time: Double; {乐曲总时间}
  boScrollChange: Boolean;
  TextureInfo: TDXTextureInfo;
  WILColorFormat: SmallInt;
  FImageX: Integer;
  FImageY: Integer;
  FShowX: Integer;
  FShowY: Integer;
  FRenderSurface: TDXRenderTargetTexture;
  FZoomSize: Extended;
  FRight: Integer;
  FBottom: Integer;
  FBlend: Cardinal;
  FAutoTick: LongWord;
  FSpotX: Integer;
  FSpotY: Integer;
  FDown: Boolean;


{ TFrameRPGView }

procedure FormCenter(MoveForm: TForm);
begin
  MoveForm.Left := FormMain.Left + (FormMain.Width div 2 - MoveForm.Width div 2);
  MoveForm.Top := FormMain.Top + (FormMain.Height div 2 - MoveForm.Height div 2);
end;

procedure TFrameRPGView.PaintBoxPaint(Sender: TObject);
begin
  PaintBox.Canvas.StretchDraw(Bounds(0, 0, PaintBox.Width, PaintBox.Height), BltBitmap);
end;

procedure TFrameRPGView.PaintBoxPanelPaint(Cnvs: TCanvas; R: TRect);
begin
  Cnvs.StretchDraw(R, BltBitmap);
end;

procedure TFrameRPGView.PanelDrawMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FSpotX := X;
  FSpotY := Y;
  FDown := Tool_Random.Down;
end;

procedure TFrameRPGView.PanelDrawMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  al, at: integer;
begin
  if not FDown then exit;
  with PanelDraw do begin
    if (FSpotX <> X) or (FSpotY <> Y) then begin
      al := FShowX + (X - FSpotX);
      at := FShowY + (Y - FSpotY);
      if al + Width < WINLEFT then
        al := WINLEFT - Width;
      if al > WINRIGHT then
        al := WINRIGHT;
      if at + Height < WINTOP then
        at := WINTOP - Height;
      if at > BOTTOMEDGE then
        at := BOTTOMEDGE;
      FShowX := al;
      FShowY := at;
      FSpotX := X;
      FSpotY := Y;
      RefStatusBar();
    end;
  end;
end;

procedure TFrameRPGView.PanelDrawMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FDown := False;
end;

procedure TFrameRPGView.RefStatusBar;
begin
  if g_WMImages <> nil then begin
    Panel1.Caption := Format('编号: %d/%d', [g_SelectImageIndex, g_WMImages.ImageCount - 1]);
    if g_WMImages is TWMMyImageImages then begin
      Panel2.Caption := '格式: 361专用图像格式'
    end;
  end
  else begin
    Panel1.Caption := '编号: 0/0';
    Panel2.Caption := '格式: 未知';
  end;
  Panel3.Caption := Format('规格: %d * %d', [TextureInfo.nWidth, TextureInfo.nHeight]);
  Panel4.Caption := Format('座标X: %d', [TextureInfo.px]);
  Panel5.Caption := Format('座标Y: %d', [TextureInfo.py]);
  case WILColorFormat of
    -1: Panel6.Caption := '格式: 默认';
    0: Panel6.Caption := '格式: A4R4G4B4';
    1: Panel6.Caption := '格式: A1R5G5B5';
    2: Panel6.Caption := '格式: R5G6B5';
    else Panel6.Caption := '格式: 未知';
  end;
  //StatusBar.Panels[6].Text := Format('透明度: %d', [Tool_Alpha.]);
  Panel7.Caption := Format('偏移: (%d,%d) (按住屏幕中图像可托动)', [FShowX, FShowY]);
end;

procedure TFrameRPGView.ScrollBar1Change(Sender: TObject);
var
  Position: Int64;
  //IsStop: Boolean;
begin
  if boScrollChange then begin
    {IsStop := False;
    if BASS_ChannelIsActive(hs) <> BASS_ACTIVE_PLAYING then begin
      IsStop := True;
    end;}
    bt_Music_PauseClick(nil);
    Position := BASS_ChannelSeconds2Bytes(hs, ScrollBar1.Value / 1000);
    BASS_ChannelSetPosition(hs, Position, BASS_POS_BYTE);
    //if not IsStop then bt_Music_PlayClick(nil);
    
  end;
end;

function TFrameRPGView.SetDrawGridIndex(Index: Integer): Boolean;
begin
  Result := False;
  if (g_WMImages <> nil) and g_WMImages.boInitialize then begin
    if (Index >= 0) and (Index <= (g_WMImages.ImageCount - 1)) then begin
      DrawGrid.Row := Index div 5;
      DrawGrid.Col := Index mod 5;
      Result := True;
    end;
  end;
end;

procedure TFrameRPGView.TimerTimer(Sender: TObject);
const
  boRun: Boolean = False;
  WriteIndex: Byte = 0;
begin
  if boRun then
    exit;
  boRun := True;
  if Tool_AUTOIMAGE.Down and (GetTickCount > FAutoTick) then begin
    FAutoTick := GetTickCount + 200;
    if not SetDrawGridIndex(DrawGrid.Row * 5 + DrawGrid.Col + 1) then begin
      Tool_AUTOIMAGE.Down := False;
      Tool_AUTOIMAGEClick(nil);
    end;
  end;
  try
    MyDevice.RenderOn(FRenderSurface, DrawRender, BackColor, True);
    MyDevice.Render(BackColor, True);
    MyDevice.Flip;
  finally
    boRun := False;
  end;
end;

procedure TFrameRPGView.TimerMusicTimer(Sender: TObject);
const
  w = 3;
var
  i,di: Integer;
  s: Double; {当前秒数}
begin

  if BASS_ChannelIsActive(hs) <> BASS_ACTIVE_PLAYING then begin
    bt_Music_StopClick(nil);
    Exit;
  end;

  s := BASS_ChannelBytes2Seconds(hs, BASS_ChannelGetPosition(hs, BASS_POS_BYTE));
  boScrollChange := False;
  Try
    ScrollBar1.Value := Trunc(s * 1000);
  Finally
    boScrollChange := True;
  End;

  BASS_ChannelGetData(hs, @FFTData, BASS_DATA_FFT4096);

  BltBitmap.Width := PaintBox.Width;
  BltBitmap.Height := PaintBox.Height;
  BltBitmap.Canvas.Brush.Color := clBlack;
  BltBitmap.Canvas.FillRect(Rect(0, 0, BltBitmap.Width, BltBitmap.Height));

  BltBitmap.Canvas.Pen.Color := clLime;

  for i := 0 to Length(FFTData) - 1 do
  begin
    di := Trunc(Abs(FFTData[i]) * 500);

    if di > BltBitmap.Height then di := BltBitmap.Height;
    if di >= FFTPeacks[i] then FFTPeacks[i] := di else FFTPeacks[i] := FFTPeacks[i] - 1;
    if di >= FFTFallOff[i] then FFTFallOff[i] := di else FFTFallOff[i] := FFTFallOff[i] - 3;
    if (BltBitmap.Height - FFTPeacks[i]) > BltBitmap.Height then FFTPeacks[i] := 0;
    if (BltBitmap.Height - FFTFallOff[i]) > BltBitmap.Height then FFTFallOff[i] := 0;

    BltBitmap.Canvas.Pen.Color := BltBitmap.Canvas.Pen.Color;
    BltBitmap.Canvas.MoveTo(i * (w + 1), BltBitmap.Height - FFTPeacks[i]);
    BltBitmap.Canvas.LineTo(i * (w + 1) + w, BltBitmap.Height - FFTPeacks[i]);

    BltBitmap.Canvas.Pen.Color := BltBitmap.Canvas.Pen.Color;
    BltBitmap.Canvas.Brush.Color := BltBitmap.Canvas.Pen.Color;
    BltBitmap.Canvas.Rectangle(i * (w + 1), BltBitmap.Height - FFTFallOff[i], i * (w + 1) + w, BltBitmap.Height);
  end;
  
  BitBlt(PaintBox.Canvas.Handle, 0, 0, PaintBox.Width, PaintBox.Height, BltBitmap.Canvas.Handle, 0, 0, SRCCOPY);
end;

procedure TFrameRPGView.Tool_AUTOIMAGEClick(Sender: TObject);
var
  Bitmap: TBitmap;
begin
  FAutoTick := GetTickCount;
  Bitmap := TBitmap.Create;
  if Tool_AUTOIMAGE.Down then begin
    Tool_AUTOIMAGE.Hint := '停止播放';
    ToolbarImages.GetBitmap(1, Bitmap);
    Tool_AUTOIMAGE.Glyph.Assign(Bitmap);
    Tool_AUTOIMAGE.Paint;
  end else begin
    Tool_AUTOIMAGE.Hint := '自动播放';
    ToolbarImages.GetBitmap(0, Bitmap);
    Tool_AUTOIMAGE.Glyph.Assign(Bitmap);
    Tool_AUTOIMAGE.Paint;
  end;
  Bitmap.Free;
end;

procedure TFrameRPGView.Tool_BlendModeChange(Sender: TObject);
begin
  if (Tool_BlendMode.ItemIndex <> -1) and (Tool_BlendMode.ItemIndex < Tool_BlendMode.Items.Count) then
    FBlend := Cardinal(Tool_BlendMode.Items.Objects[Tool_BlendMode.ItemIndex]);
end;

procedure TFrameRPGView.Tool_FrontClick(Sender: TObject);
begin
  if (g_WMImages <> nil) and g_WMImages.boInitialize then begin
    if (Sender = Tool_Next) then
      SetDrawGridIndex(DrawGrid.Row * 5 + DrawGrid.Col + 1)
    else
      SetDrawGridIndex(DrawGrid.Row * 5 + DrawGrid.Col - 1);
  end;
end;

procedure TFrameRPGView.Tool_Image_AddClick(Sender: TObject);
begin
  if (g_WMImages <> nil) and (g_WMImages.boInitialize) then begin
    FormCenter(FormRPGAppend);
    FormRPGAppend.Open;
  end;
end;

procedure TFrameRPGView.Tool_Image_DelClick(Sender: TObject);
begin
  if (g_WMImages <> nil) and (g_WMImages.boInitialize) then begin
    FormCenter(FormRPGDelete);
    FormRPGDelete.Open;
  end;
end;

procedure TFrameRPGView.Tool_Image_GotoClick(Sender: TObject);
var
  sInput: string;
begin
  if (g_WMImages <> nil) and g_WMImages.boInitialize then begin
    if not FormMain.InputDialog.InputQuery('跳转', '请输入图片索引号', sInput) then
      exit;
    SetDrawGridIndex(StrToIntDef(sInput, 1));
  end;
end;

procedure TFrameRPGView.Tool_Image_PutClick(Sender: TObject);
begin
  if (g_WMImages <> nil) and (g_WMImages.boInitialize) then begin
    FormCenter(FormRPGOut);
    FormRPGOut.Open;
  end;
end;

procedure TFrameRPGView.Tool_NewClick(Sender: TObject);
var
  fhandle: THandle;
  WMImageHeader: wmMyImage.TWMImageHeader;
  sStr: string;
begin
  FormMain.SaveDialog.Filter := '361专用补丁文件 (*.pak)|*.pak';
  if FormMain.SaveDialog.Execute then begin
    if FileExists(FormMain.SaveDialog.FileName) then begin
      if FormMain.DMsg.MessageDlg('该文件已经存在，是否替换该文件？', mtConfirmation, [mbYes, mbNo], 0) <> mrYes then begin
        Exit;
      end;
      if not DeleteFile(FormMain.SaveDialog.FileName) then begin
        FormMain.DMsg.MessageDlg('替换文件失败！', mtError, [mbYes], 0);
        Exit;
      end;
    end;
    fhandle := FileCreate(FormMain.SaveDialog.FileName, fmOpenWrite);
    if fhandle > 0 then begin
      FillChar(WMImageHeader, SizeOf(WMImageHeader), #0);
      WMImageHeader.Title := HEADERNAME;
      WMImageHeader.CopyRight := COPYRIGHTNAME;
      WMImageHeader.UpDateTime := Now();
      if g_PackPassword <> '' then begin
        if FormMain.DMsg.MessageDlg('是否创建加密版本？', mtConfirmation, [mbYes, mbNo], 0) = mrYes then begin
          WMImageHeader.nVer := 1;
          sStr := EncryStr(CHECKENSTR, g_PackPassword);
          Move(sStr[1], WMImageHeader.sEnStr[0], 8);
        end;
      end;
      FileWrite(fhandle, WMImageHeader, SizeOf(WMImageHeader));
      FileClose(fhandle);
      if FormMain.DMsg.MessageDlg('是否现在就打开新创建的文件？', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
        OpenWMFile(FormMain.SaveDialog.FileName);
    end;
    {SaveStream := TMemoryStream.Create;
    Try
      if MakeSaveInfo(SaveStream) then begin
        SaveStream.SaveToFile(FormMain.SaveDialog.FileName);
        FormMain.DMsg.MessageDlg('保存皮肤信息成功！', mtInformation, [mbYes], 0);
      end else
        FormMain.DMsg.MessageDlg('保存皮肤信息失败！', mtError, [mbYes], 0);
    Finally
      SaveStream.Free;
    End; }
  end;
end;

procedure TFrameRPGView.Tool_ZoomChange(Sender: TObject);
var
  sInput: string;
  nInput: Integer;
begin
  case Tool_Zoom.ItemIndex of
    0: FZoomSize := 0.5;
    1: FZoomSize := 1;
    2: FZoomSize := 2;
    3: FZoomSize := 4;
    4: FZoomSize := 8;
    5: begin
      if not FormMain.InputDialog.InputQuery('设置缩放比例', '例如：10 代表 10%', sInput) then
        exit;
      nInput := StrToIntDef(sInput, 100);
      FZoomSize := nInput / 100;
    end;
  end;
end;

procedure TFrameRPGView.UnInit;
begin
  if g_WMImages <> nil then begin
    g_WMImages.Free;
    g_WMImages := nil;
  end;
  MyDevice.Finalize;
  BltBitmap.Free;
  BASS_StreamFree(hs);
  BASS_Free;
end;

procedure TFrameRPGView.BGColorChangeColor(Sender: TObject);
begin
  BackColor := BGColor.ColorValue;
  AlphaColor := BlendColor.ColorValue;
end;

procedure TFrameRPGView.bt_Music_PauseClick(Sender: TObject);
begin
  boStop := False;
  TimerMusic.Enabled := False;
  BASS_ChannelPause(hs);
  bt_Music_Play.Enabled := True;
  bt_Music_Pause.Enabled := False;
  bt_Music_Stop.Enabled := True;
end;

procedure TFrameRPGView.bt_Music_PlayClick(Sender: TObject);
begin
  TimerMusic.Enabled := True;
  BASS_ChannelPlay(hs, boStop);
  time := BASS_ChannelBytes2Seconds(hs, BASS_ChannelGetLength(hs, BASS_POS_BYTE)); {总秒数}
  ScrollBar1.MaxValue := Trunc(time * 1000);
  ScrollBar1.Enabled := True;
  bt_Music_Play.Enabled := False;
  bt_Music_Pause.Enabled := True;
  bt_Music_Stop.Enabled := True;
end;

procedure TFrameRPGView.bt_Music_StopClick(Sender: TObject);
begin
  boStop := True;
  TimerMusic.Enabled := False;
  BASS_ChannelStop(hs);
  bt_Music_Play.Enabled := True;
  bt_Music_Pause.Enabled := False;
  bt_Music_Stop.Enabled := False;
  ScrollBar1.Enabled := False;
  ScrollBar1.Value := 0;
end;

procedure TFrameRPGView.ButtonChangePackFormatClick(Sender: TObject);
var
  I, nPosition: Integer;
  Header: wmMyImage.TWMImageHeader;
  ImgInfo: wmMyImage.TWMImageInfo;
  Images: wmMyImage.TWMMyImageImages;
  Buffer: PChar;
  BufferLen: Integer;
  //sStr,
  sFileName: string;
  sEnStr: array[0..7] of Char;
begin
  if g_WMImages = nil then Exit;
  if g_boOfflineLogin then begin
    FormMain.DMsg.MessageDlg('要使用该功能，必需使用VIP帐号登录！', mtError, [mbYes], 0);
    exit;
  end;
  if g_PackPassword = '' then begin
    FormMain.DMsg.MessageDlg('对不起，您无法使用该功能，请联系技术！', mtError, [mbYes], 0);
    exit;
  end;
  Images := wmMyImage.TWMMyImageImages(g_WMImages);
  if Images.EncryVer then begin
    if FormMain.DMsg.MessageDlg('是否确定将版本切换为普通版？', mtConfirmation, [mbYes, mbNo], 0) = mrNo then begin
      Exit;
    end;
    FormMain.Lock(True);
    FormMain.FrmRPGView.Enabled := False;
    FormMain.ShowHint('正在将PAK文件切换成普通版本...');
    FormMain.ShowProgress(0);
    FCanDraw := False;
    Try
      Images.FileStream.Seek(0, 0);
      Images.FileStream.Read(Header, SizeOf(Header));
      DecryBuffer(g_PackPassword, @Header.sEnStr[0], @sEnStr[0], 8, 8);
      if sEnStr <> CHECKENSTR then begin
        FormMain.DMsg.MessageDlg('切换失败，加密文件不属于当前VIP帐号！', mtError, [mbYes], 0);
        Exit;
      end;
      Header.CopyRight := COPYRIGHTNAME;
      Header.sEnStr := '';
      Header.nVer := 0;
      Header.ImageCount := Header.ImageCount2;
      Header.ImageCount2 := 0;
      Images.FileStream.Seek(0, 0);
      Images.FileStream.Write(Header, SizeOf(Header));
      for I := 0 to Images.FIndexList.Count - 1 do begin
        nPosition := Integer(Images.FIndexList[I]);
        if nPosition = 0 then Continue;
        if Images.FileStream.Seek(nPosition, 0) <> nPosition then Continue;
        Images.FileStream.Read(ImgInfo, SizeOf(TWMImageInfo));
        Images.FCanEncry := True;
        Images.FormatImageInfo(@ImgInfo, False);
        Images.FileStream.Seek(-SizeOf(TWMImageInfo), soFromCurrent);
        Images.FCanEncry := False;
        Images.FormatImageInfo(@ImgInfo, True);
        Images.FileStream.Write(ImgInfo, SizeOf(TWMImageInfo));
        BufferLen := ImgInfo.nDataSize;
        GetMem(Buffer, BufferLen);
        Try
          Images.FileStream.Read(Buffer^, BufferLen);
          Images.FCanEncry := True;
          Images.FormatDataBuffer(Buffer, BufferLen, False);
          Images.FileStream.Seek(-BufferLen, soFromCurrent);
          Images.FileStream.Write(Buffer^, BufferLen);
        Finally
          FreeMem(Buffer);
        End;
        FormMain.ShowProgress(Round((I + 1) / Images.FIndexList.Count * 100));
      end;
      FormMain.DMsg.MessageDlg('切换成功！', mtInformation, [mbYes], 0);
      sFileName := Images.FileName;
      CloseButtonClick(nil);
      FCanDraw := True;
      OpenWMFile(sFileName);
      FormMain.ShowHint('切换完成...');
      FormMain.ShowProgress(100);
    Finally
      FormMain.Lock(False);
      FormMain.FrmRPGView.Enabled := True;
      FCanDraw := True;
    End;
  end else begin
    if FormMain.DMsg.MessageDlg('是否确定将版本切换为加密版？', mtConfirmation, [mbYes, mbNo], 0) = mrNo then begin
      Exit;
    end;
    FormMain.Lock(True);
    FormMain.FrmRPGView.Enabled := False;
    FormMain.ShowHint('正在将PAK文件切换成加密版本...');
    FormMain.ShowProgress(0);
    FCanDraw := False;
    Try
      Images.FileStream.Seek(0, 0);
      Images.FileStream.Read(Header, SizeOf(Header));
      Header.CopyRight := COPYRIGHTNAME;
      Header.nVer := 1;
      EncryBuffer(g_PackPassword, @CHECKENSTR[1], @sEnStr[0], 8, 8);
      Move(sEnStr[0], Header.sEnStr[0], 8);
      Header.ImageCount2 := Header.ImageCount;
      Header.ImageCount := 0;
      Images.FileStream.Seek(0, 0);
      Images.FileStream.Write(Header, SizeOf(Header));
      for I := 0 to Images.FIndexList.Count - 1 do begin
        nPosition := Integer(Images.FIndexList[I]);
        if nPosition = 0 then Continue;
        if Images.FileStream.Seek(nPosition, 0) <> nPosition then Continue;
        Images.FileStream.Read(ImgInfo, SizeOf(TWMImageInfo));
        Images.FCanEncry := False;
        Images.FormatImageInfo(@ImgInfo, False);
        Images.FileStream.Seek(-SizeOf(TWMImageInfo), soFromCurrent);
        Images.FCanEncry := True;
        Images.FormatImageInfo(@ImgInfo, True);
        Images.FileStream.Write(ImgInfo, SizeOf(TWMImageInfo));
        BufferLen := ImgInfo.nDataSize;
        GetMem(Buffer, BufferLen);
        Try
          Images.FileStream.Read(Buffer^, BufferLen);
          Images.FormatDataBuffer(Buffer, BufferLen, True);
          Images.FileStream.Seek(-BufferLen, soFromCurrent);
          Images.FileStream.Write(Buffer^, BufferLen);
        Finally
          FreeMem(Buffer);
        End;
        FormMain.ShowProgress(Round((I + 1) / Images.FIndexList.Count * 100));
      end;
      FormMain.DMsg.MessageDlg('切换成功！', mtInformation, [mbYes], 0);
      sFileName := Images.FileName;
      CloseButtonClick(nil);
      FCanDraw := True;
      OpenWMFile(sFileName);
      FormMain.ShowHint('切换完成...');
      FormMain.ShowProgress(100);
    Finally
      FormMain.Lock(False);
      FormMain.FrmRPGView.Enabled := True;
      FCanDraw := True;
    End;
  end;
end;

procedure TFrameRPGView.Close;
begin
  Timer.Enabled := False;
  Tool_AUTOIMAGE.Down := False;
  Tool_AUTOIMAGEClick(nil);
end;

procedure TFrameRPGView.CloseButtonClick(Sender: TObject);
begin
  if g_WMImages <> nil then begin
    FreeAndNil(g_WMImages);
    GroupBoxBG.Caption := 'PAK制作工具  []';
  end;
  InitializeForm;
end;

procedure TFrameRPGView.DrawGridDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  OldColor: TColor;
  BitMap, BitMap2: TBitmap;
  nRect, iRect: TRect;
  X, Y: Integer;
  Str: string;
  boStr: Boolean;
  btType: Byte;
begin
  if (g_WMImages <> nil) and g_WMImages.boInitialize and FCanDraw then begin
    OldColor := 0;
    with DrawGrid.Canvas do begin
      if gdSelected in State then begin
        DrawGrid.Canvas.Brush.Color := clMenuHighlight;
        FillRect(Rect);
      end;
      BitMap2 := TBitmap.Create;
      BitMap := g_WMImages.Bitmap[ACol + ARow * 5, btType];
      case btType of
        FILETYPE_IMAGE: ;
        FILETYPE_DATA: begin
            if Bitmap = nil then
              BitMap := TBitmap.Create;
            Bitmap.Assign(g_DefDatImage);
          end;
        FILETYPE_WAVA: begin
            if Bitmap = nil then
              BitMap := TBitmap.Create;
            Bitmap.Assign(g_DefWavImage);
          end;
        FILETYPE_MP3: begin
            if Bitmap = nil then
              BitMap := TBitmap.Create;
            Bitmap.Assign(g_DefMp3Image);
          end;
      else begin
          if Bitmap <> nil then
            FreeAndNil(Bitmap);
        end;
      end;
      boStr := False;
      if (BitMap <> nil) then begin
        if Bitmap.PixelFormat = pf8bit then
          SetDIBColorTable(Bitmap.Canvas.Handle, 0, 256, g_DefMainPalette);
        BitMap2.Width := _MIN(BitMap.Width, DrawGrid.DefaultColWidth);
        BitMap2.Height := _MIN(BitMap.Height, DrawGrid.DefaultRowHeight);
        if BitMap2.Height > (DrawGrid.DefaultRowHeight - 12) then
          boStr := True;
        BitMap2.Canvas.StretchDraw(BitMap2.Canvas.ClipRect, BitMap);
        BitMap2.TransparentColor := 0;
        BitMap2.Transparent := True;
        nRect.Left := 0;
        nRect.Top := 0;
        nRect.Right := Bitmap2.Width;
        nRect.Bottom := Bitmap2.Height;
        iRect := Rect;
        iRect.Right := iRect.Left + _MIN(BitMap2.Width, DrawGrid.DefaultColWidth);
        iRect.Bottom := iRect.Top + _MIN(BitMap2.Height, DrawGrid.DefaultRowHeight);
        DrawGrid.Canvas.BrushCopy(iRect, Bitmap2, nRect, 0);
        BitMap.Free;
      end;
      if gdSelected in State then begin
        DrawGrid.Canvas.Brush.Color := clRed;
        FrameRect(Rect);
      end;

      Bitmap2.Free;
      if (ACol + ARow * 5) <= (g_WMImages.ImageCount - 1) then begin
        SetBkMode(Handle, TRANSPARENT);
        Str := Format('%.6d', [ACol + ARow * 5]);
        X := Rect.Right - DrawGrid.Canvas.TextWidth(Str);
        Y := Rect.Bottom - DrawGrid.Canvas.TextHeight(Str);
        if boStr then begin
          Font.Color := clBlack;
          DrawGrid.Canvas.TextOut(X - 1, Y, Str);
          DrawGrid.Canvas.TextOut(X + 1, Y, Str);
          DrawGrid.Canvas.TextOut(X, Y - 1, Str);
          DrawGrid.Canvas.TextOut(X, Y + 1, Str);
        end;
        if boStr then
          Font.Color := clWhite
        else
          Font.Color := clBlack;
        DrawGrid.Canvas.TextOut(X, Y, Str);
        if gdSelected in State then begin
          Font.Color := OldColor;
        end;
      end;
    end;
  end;
end;

procedure TFrameRPGView.DrawGridSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
begin
  bt_Music_StopClick(nil);
  BASS_StreamFree(hs);
  if DataStream <> nil then begin
    DataStream.Free;
    DataStream := nil;
  end;
  if (g_WMImages <> nil) and g_WMImages.boInitialize then begin
    g_SelectImageIndex := ACol + ARow * 5;
    FillChar(TextureInfo, SizeOf(TextureInfo), #0);
    WILColorFormat := -1;
    g_Texture[1].PatternSize := Point(1, 1);
    g_Texture[1].Clear;
    case g_WMImages.GetDataType(g_SelectImageIndex) of
      FILETYPE_IMAGE: begin
          GroupBoxMusic.Visible := False;
          if g_WMImages.CopyDataToTexture(g_SelectImageIndex, g_Texture[1]) then begin
            FImageX := g_WMImages.LastImageInfo.px;
            FImageY := g_WMImages.LastImageInfo.py;
            TextureInfo := g_WMImages.LastImageInfo;
            WILColorFormat := Integer(g_WMImages.LastColorFormat);
          end;
        end;
      FILETYPE_WAVA,
        FILETYPE_MP3: begin
          if FCanMusic then begin
            GroupBoxMusic.Visible := True;
            DataStream := g_WMImages.GetDataStream(g_SelectImageIndex, dtAll);
            if DataStream <> nil then begin
              hs := BASS_StreamCreateFile(True, DataStream.Memory, 0, DataStream.Size, 0);
            end;
          end else
            GroupBoxMusic.Visible := False;
        end;
      FILETYPE_DATA: begin
          GroupBoxMusic.Visible := False;
        end;
    end;
    RefStatusBar();
  end;
end;

procedure TFrameRPGView.DrawRender(Sender: TObject);
var
  Color4: TColor4;
  Rect: TRect;
  //nX, nY: Integer;
//  nZoom: Real;
begin
  Color4 := cColor4(Tool_Alpha.Value and $FF shl 24 or (AlphaColor and $FFFFFF));
  MyDevice.Canvas.Draw(0, 0, g_Texture[0].ClientRect, g_Texture[0], fxNone);
  Rect := g_Texture[1].ClientRect;
  Rect.Right := Round(Rect.Right * FZoomSize);
  Rect.Bottom := Round(Rect.Bottom * FZoomSize);

 { nZoom := 0.15;
  FZoomSize := 2;
  Rect.Right := Round(Rect.Right * 0.9);
  Rect.Bottom := Round(Rect.Bottom * 0.9);  }
  //nX := 0;
  //nY := 0;
  if Tool_Middle.Down then begin
    if Tool_Position.Down then begin
      Rect.Left := MAXWIDTH div 3 + FImageX;
      Rect.Top := MAXHEIGHT div 3 + FImageY;
    end
    else begin
      Rect.Left := (MAXWIDTH - Rect.Right) div 2;
      Rect.Top := (MAXHEIGHT - Rect.Bottom) div 2;
    end;
  end
  else if Tool_Random.Down then begin
    if Tool_Position.Down then begin
      Rect.Left := FImageX + FShowX;
      Rect.Top := FImageY + FShowY;
    end
    else begin
      Rect.Left := FShowX;
      Rect.Top := FShowY;
    end;
  end;
  Rect.Right := Rect.Right + Rect.Left;
  Rect.Bottom := Rect.Bottom + Rect.Top;
  FRight := Rect.Right - Rect.Left;
  FBottom := Rect.Bottom - Rect.Top;
  if FZoomSize <> 1 then
    MyDevice.Canvas.StretchDraw(Rect, g_Texture[1].ClientRect, g_Texture[1], FBlend, Color4)
  else
    MyDevice.Canvas.Draw(Rect.Left, Rect.Top, g_Texture[1].ClientRect, g_Texture[1], FBlend, Color4);
end;

procedure TFrameRPGView.Finalize;
begin
  MyDevice.Finalize;
end;

procedure TFrameRPGView.Init;
begin
  Tool_BlendMode.Items.Clear;
  Tool_BlendMode.Items.AddObject('None', TObject($00000001));
  Tool_BlendMode.Items.AddObject('Default', TObject($00000504));
  Tool_BlendMode.Items.AddObject('Anti', TObject($00000109));
  Tool_BlendMode.Items.AddObject('AlphaAdd', TObject($00000104)); //alphaadd
  Tool_BlendMode.Items.AddObject('AlphaAdd2', TObject($00000101)); //alphaadd2
  Tool_BlendMode.Items.AddObject('AlphaAdd3', TObject($00000302)); //alphaadd3
  Tool_BlendMode.Items.AddObject('AlphaAdd4', TObject($7FFFFFF0));
  Tool_BlendMode.Items.AddObject('ColorAdd', TObject($00000102));
  Tool_BlendMode.Items.AddObject('Shadow', TObject($00000500));
  Tool_BlendMode.Items.AddObject('Bright', TObject($00000201));
  Tool_BlendMode.Items.AddObject('IgnoreColor', TObject($7FFFFFF6));
  Tool_BlendMode.ItemIndex := 0;
  FBlend := $00000001;
  BltBitmap := TBitmap.Create;
  BackColor := BGColor.ColorValue;
  AlphaColor := BlendColor.ColorValue;
  FboState := False;

  g_SelectImageIndex := -1;
  DataStream := nil;
  FZoomSize := 1;
  FShowX := 0;
  FShowY := 0;
  FRight := 0;
  FBottom := 0;
  FSpotX := 0;
  FSpotY := 0;
  FDown := False;
  boStop := False;
  boScrollChange := True;
  FCanMusic := BASS_Init(-1, 44100, 0, 0, nil);
  //if not BASS_Init(-1, 44100, 0, 0, nil) then
    //FormMain.DMsg.MessageDlg('音频设备初始化错误！', mtError, [mbYes], 0);
end;

procedure TFrameRPGView.Initialize;
begin
  if FboState then begin
    PanelDraw.Left := 0;
    PanelDraw.Top := 0;
    PanelDraw.Width := MyDevice.Width;
    PanelDraw.Height := MyDevice.Height;
    MyDevice.WindowHandle := PanelDraw.Handle;
    if not MyDevice.Initialize then begin
      FormMain.DMsg.MessageDlg('初始化设备失败, error ' + MyDevice.InitError, mtError, [mbYes], 0);
      exit;
    end;
    Timer.Enabled := Visible;
  end;
end;

procedure TFrameRPGView.InitializeForm;
begin
  Tool_AUTOIMAGE.Down := False;
  Tool_AUTOIMAGE.Enabled := g_WMImages <> nil;
  CloseButton.Enabled := g_WMImages <> nil;
  ButtonChangePackFormat.Enabled := g_WMImages <> nil;

  Tool_Image_Goto.Enabled := g_WMImages <> nil;
  Tool_Front.Enabled := g_WMImages <> nil;
  Tool_Next.Enabled := g_WMImages <> nil;

  Tool_Image_Add.Enabled := (g_WMImages <> nil);
  Tool_Image_Put.Enabled := g_WMImages <> nil;
  Tool_Image_Del.Enabled := (g_WMImages <> nil);

  DrawGrid.RowCount := 1;
  RefStatusBar;
end;

procedure TFrameRPGView.InitializeGrid;
begin
  if g_WMImages <> nil then begin
    DrawGrid.RowCount := g_WMImages.ImageCount div 5 + 1;
    DrawGrid.Repaint;
  end;
end;

procedure TFrameRPGView.MyDeviceFinalize(Sender: TObject);
begin
  Timer.Enabled := False;
  g_Texture[0].Free;
  g_Texture[0] := nil;
  g_Texture[1].Free;
  g_Texture[1] := nil;
  FRenderSurface.Free;
  FRenderSurface := nil;
end;

procedure TFrameRPGView.MyDeviceInitialize(Sender: TObject; var Success: Boolean; var ErrorMsg: string);
begin

  g_Texture[0] := TDXImageTexture.Create;
  with g_Texture[0] do begin
    Size := Point(1024, 1024);
    PatternSize := Point(1, 1);
    Format := D3DFMT_A8R8G8B8;
    Active := True;
  end;
  g_Texture[1] := TDXImageTexture.Create;
  with g_Texture[1] do begin
    Size := Point(1024, 1024);
    PatternSize := Point(1, 1);
    //Format := D3DFMT_R5G6B5;
    //Active := True;
  end;
  FRenderSurface := TDXRenderTargetTexture.Create(nil);
  FRenderSurface.Size := Point(PresentParams.BackBufferWidth, PresentParams.BackBufferHeight);
  FRenderSurface.Format := D3DFMT_A4R4G4B4;
  FRenderSurface.MipMapping := False;
  FRenderSurface.Behavior := tbRTarget;
  FRenderSurface.Active := True;
end;

procedure TFrameRPGView.MyDeviceNotifyEvent(Sender: TObject; Msg: Cardinal);
begin
  case Msg of
    msgDeviceLost: begin
      FRenderSurface.Lost;
    end;
    msgDeviceRecovered: begin
      FRenderSurface.Recovered;
    end;
  end;
end;

procedure TFrameRPGView.MyDeviceRender(Sender: TObject);
begin
  MyDevice.Canvas.Draw(0, 0, FRenderSurface.ClientRect, FRenderSurface, fxBlend, clWhite4);
end;

procedure TFrameRPGView.Open;
begin
  FCanDraw := True;
  if not FboState then begin
    FboState := True;
    PanelDraw.Left := 0;
    PanelDraw.Top := 0;
    PanelDraw.Width := MyDevice.Width;
    PanelDraw.Height := MyDevice.Height;
    MyDevice.WindowHandle := PanelDraw.Handle;
    if not MyDevice.Initialize then begin
      FormMain.DMsg.MessageDlg('初始化设备失败, error ' + MyDevice.InitError, mtError, [mbYes], 0);
      exit;
    end;
  end;
  DrawGrid.DefaultCellHeight := 64;
  DrawGrid.DefaultRowHeight := 64;
  BltBitmap.Width := PaintBox.Width;
  BltBitmap.Height := PaintBox.Height;
  BltBitmap.Canvas.Brush.Color := clBlack;
  BltBitmap.Canvas.FillRect(Rect(0, 0, BltBitmap.Width, BltBitmap.Height));
  Timer.Enabled := True;
end;

procedure TFrameRPGView.OpenButtonClick(Sender: TObject);
begin
  FormMain.OpenDialog.Filter := '361专用补丁文件 (*.pak)|*.pak';
  if FormMain.OpenDialog.Execute then begin
    if FileExists(FormMain.OpenDialog.FileName) then begin
      OpenWMFile(FormMain.OpenDialog.FileName);
    end;
  end;
end;

procedure TFrameRPGView.OpenWMFile(sFileName: string);
begin
  if FileExists(sFileName) then begin
    GroupBoxBG.Caption := 'PAK制作工具 [' + sFileName + ']';
    if g_WMImages <> nil then begin
      g_WMImages.Free;
      g_WMImages := nil;
    end;
    g_SelectImageIndex := -1;
    g_WMImages := CreateWMImages(t_wmMyImage);
    if g_WMImages <> nil then begin
      g_WMImages.FileName := sFileName;
      g_WMImages.LibType := ltLoadBmp;
      g_WMImages.Password := g_PackPassword;
      //g_WMImages.Password := '12345678';
      //g_WMImages.ChangeAlpha := True;
      g_WMImages.Initialize;
      DrawGrid.RowCount := g_WMImages.ImageCount div 5 + 1;
      DrawGrid.Repaint;
      if (g_WMImages <> nil) and (g_WMImages.boInitialize) then
        if g_WMImages.EncryVer then GroupBoxBG.Caption := 'PAK制作工具  [' + sFileName + '][加密版]'
        else GroupBoxBG.Caption := 'PAK制作工具  [' + sFileName + '][普通版]';
        //GroupBoxBG.Caption := 'PAK制作工具  [' + sFileName + '] ' + DateTimeToStr(TWMMyImageImages(g_WMImages).UpDateTime);
    end;
    InitializeForm;
    InitializeGrid;
  end;
end;

end.

