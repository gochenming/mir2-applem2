unit WIL;

interface

uses
  Windows, Classes, Graphics, SysUtils, DXDraws, DXClass, Dialogs,
  DirectX, DIB, wmUtil, HUtil32;

const
  VERFLAG = 88;

  VERREAD = 0; //当前单元只读操作
  VERREADWRITE = 1; //当前单元读写操作
  WERWORD = VERREADWRITE;

var
  g_boUseDIBSurface: Boolean = True;

type
  TLibType = (ltLoadBmp, ltUseCache);
  TDxBitType = (dbtAuto, dbt8Bit, dbt16Bit, dbt16Bit_555, dbt16Bit_565,
    dbt24Bit,
    dbt32Bit);

{$IF WERWORD = VERREADWRITE}
{$IFEND}

  TDxImageArr = array[0..MaxListSize div 4] of TDxImage;
  PTDxImageArr = ^TDxImageArr;

  TWMImages = class(TComponent)
  private
    FFileName: string;
    FImageCount: integer;
    FLibType: TLibType;
    FDxDraw: TDxDraw;
    FDDraw: TDirectDraw;
    FAutoFreeMemorys: Boolean;
    FAutoFreeMemorysTick: LongWord;
    FFreeSurfaceTick: LongWord;
    FBitType: TDxBitType;
    FInitialize: Boolean;
    btVersion: Byte;
    FAppr: Word;
    procedure LoadPalette;
    procedure LoadIndex(idxfile: string);
    procedure LoadDxImage(position: integer; pdximg: PTDxImage);
    procedure FreeOldMemorys;
    function FGetImageSurface(index: integer): TDirectDrawSurface;

    procedure FSetDxDraw(fdd: TDxDraw);
    function GetCachedSurface(index: integer): TDirectDrawSurface;
{$IF WERWORD = VERREADWRITE}

{$IFEND}
  protected
    m_dwMemChecktTick: LongWord;
  public
    m_ImgArr: pTDxImageArr;
    m_IndexList: TList;
    m_FileStream: TFileStream;
    MainPalette: TRgbQuads;
    imginfo: TWMImageInfo;
    lsDib: TDib;

    FIdxFile: string;
    FHeader: TWMImageHeader;
    FIdxHeader: TWMIndexHeader;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Initialize;
    procedure Finalize;
    procedure ClearCache;
    function MakeDIB(index: integer; boHeader: Boolean = False): Boolean;

    function GetCachedImage(index: integer; var px, py: Integer):
      TDirectDrawSurface;
    function GetBitmap(index: integer; var Bitmap: TBitmap): Boolean; overload;
    function GetBitmap(index: integer; var px, py: Integer; var Bitmap:
      TBitmap): Boolean; overload;

    property Images[index: integer]: TDirectDrawSurface read FGetImageSurface;
    property DDraw: TDirectDraw read FDDraw write FDDraw;
    property ImageCount: integer read FImageCount;
    property boInitialize: Boolean read FInitialize;
    property Version: Byte read btVersion;
{$IF WERWORD = VERREADWRITE}
    function MakeAddDIB(): Integer;
    procedure SaveIndex();
    function GetImageSize(StartIndex, StopIndex: Integer): Integer;
    function DelImages(StartIndex, StopIndex: Integer; boFlag: Boolean):
      Boolean;
    procedure UpdateIndex(StartIdx, nCount: Integer);
    function InsertImagesGetRoom(Index, nSize: Integer; SizeInfoList: TList):
      Boolean;
    function ReplaceImagesGetRoom(Index, endindex, nSize: Integer; SizeInfoList:
      TList):
      Boolean;
    procedure InsertImages(Index, px, py: Integer; TempDib: TDIB);
    procedure AddImages(px, py: Integer; TempDib: TDIB);
    function GetDibSize(TempDib: TDIB): Integer;
    function GetImageHeaderSize(): Integer;
    procedure CheckBitCount();
    procedure SetImageInfo(index: integer; pimginfo: pTWMImageInfo);
{$IFEND}
  published
    property FileName: string read FFileName write FFileName;
    property DxDraw: TDxDraw read FDxDraw write FSetDxDraw;
    property LibType: TLibType read FLibType write FLibType;
    property Appr: Word read FAppr write FAppr;
    property BitType: TDxBitType read FBitType write FBitType;
    property AutoFreeMemorys: Boolean read FAutoFreeMemorys write
      FAutoFreeMemorys;
    property AutoFreeMemorysTick: LongWord read FAutoFreeMemorysTick write
      FAutoFreeMemorysTick;
    property FreeSurfaceTick: LongWord read FFreeSurfaceTick write
      FFreeSurfaceTick;
{$IF WERWORD = VERREADWRITE}
{$IFEND}
  end;

function TDXDrawRGBQuadsToPaletteEntries(const RGBQuads: TRGBQuads;
  AllowPalette256: Boolean): TPaletteEntries;

{$IF WERWORD = VERREADWRITE}

{$IFEND}

procedure Register;

implementation

{$IF WERWORD = VERREADWRITE}
uses
  Share;
{$IFEND}

procedure Register;
begin
  RegisterComponents('MirGame', [TWmImages]);
end;

constructor TWMImages.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FFileName := '';
  FImageCount := 0;
  BitType := dbtAuto;
  FInitialize := False;
  FAutoFreeMemorys := False;
  FAutoFreeMemorysTick := 1000;
  FFreeSurfaceTick := 5 * 60 * 1000;
  FLibType := ltLoadBmp;
  FIdxFile := '';
  FDDraw := nil;
  FDxDraw := nil;
  m_FileStream := nil;
  m_ImgArr := nil;
  m_IndexList := TList.Create;
  lsDib := TDib.Create;
  lsDib.BitCount := 8;

  m_dwMemChecktTick := GetTickCount;
  btVersion := 0;
end;

destructor TWMImages.Destroy;
begin
  m_IndexList.Free;
  if m_FileStream <> nil then
    m_FileStream.Free;
  lsDib.Free;
  inherited Destroy;
end;

procedure TWMImages.Initialize;
begin
  if not (csDesigning in ComponentState) then begin
    if FFileName = '' then begin
      raise Exception.Create('FileName not assigned..');
      exit;
    end;
    if FileExists(FFileName) then begin
      FillChar(FHeader, SizeOf(FHeader), #0);
      if m_FileStream = nil then
{$IF WERWORD = VERREADWRITE}
        m_FileStream := TFileStream.Create(FFileName, fmOpenReadWrite or
          fmShareDenyNone);
{$ELSE}
      m_FileStream := TFileStream.Create(FFileName, fmOpenRead or
        fmShareDenyNone);
{$IFEND}
      m_FileStream.Read(FHeader, SizeOf(TWMImageHeader));

      if FHeader.nFlag = VERFLAG then begin //真彩版本
        btVersion := 2;
      end //原老新格式
      else if FHeader.VerFlag <> 0 then begin
        btVersion := 1;
      end
      else begin //原老格式
        btVersion := 0;
        m_FileStream.Seek(-4, soFromCurrent);
      end;

      FImageCount := FHeader.ImageCount;
      if FLibType <> ltLoadBmp then begin
        m_ImgArr := AllocMem(SizeOf(TDxImage) * FImageCount);
        if m_ImgArr = nil then
          raise Exception.Create(self.Name + ' ImgArr = nil');
      end;
      FIdxFile := ExtractFilePath(FFileName) + ExtractFileNameOnly(FFileName) +
        '.WIX';
      LoadPalette;
      LoadIndex(FIdxFile);
      FInitialize := True;
    end;
  end;
end;

procedure TWMImages.Finalize;
begin
  ClearCache();
  if m_FileStream <> nil then begin
    m_FileStream.Free;
    m_FileStream := nil;
  end;
  FInitialize := False;
end;

function TDXDrawRGBQuadsToPaletteEntries(const RGBQuads: TRGBQuads;
  AllowPalette256: Boolean): TPaletteEntries;
var
  Entries: TPaletteEntries;
  dc: THandle;
  i: Integer;
begin
  Result := RGBQuadsToPaletteEntries(RGBQuads);

  if not AllowPalette256 then begin
    dc := GetDC(0);
    GetSystemPaletteEntries(dc, 0, 256, Entries);
    ReleaseDC(0, dc);

    for i := 0 to 9 do
      Result[i] := Entries[i];

    for i := 256 - 10 to 255 do
      Result[i] := Entries[i];
  end;

  for i := 0 to 255 do
    Result[i].peFlags := D3DPAL_READONLY;
end;

procedure TWMImages.LoadPalette;
begin
  if btVersion = 0 then
    m_FileStream.Seek(sizeof(TWMImageHeader) - 4, 0)
  else
    m_FileStream.Seek(sizeof(TWMImageHeader), 0);

  m_FileStream.Read(MainPalette, sizeof(TRgbQuad) * 256);
end;

procedure TWMImages.LoadIndex(idxfile: string);
var
  fhandle, i, value: integer;
  pvalue: PInteger;
begin
  m_IndexList.Clear;
  if FileExists(idxfile) then begin
    fhandle := FileOpen(idxfile, fmOpenRead or fmShareDenyNone);
    if fhandle > 0 then begin
      if btVersion = 0 then
        FileRead(fhandle, FIdxHeader, sizeof(TWMIndexHeader) - 4)
      else
        FileRead(fhandle, FIdxHeader, sizeof(TWMIndexHeader));

      GetMem(pvalue, 4 * FIdxHeader.IndexCount);
      FileRead(fhandle, pvalue^, 4 * FIdxHeader.IndexCount);
      for i := 0 to FIdxHeader.IndexCount - 1 do begin
        value := PInteger(integer(pvalue) + 4 * i)^;
        m_IndexList.Add(pointer(value));
      end;
      FreeMem(pvalue);
      FileClose(fhandle);
    end;
  end;
end;

function TWMImages.FGetImageSurface(index: integer): TDirectDrawSurface;
begin
  Result := nil;
  if FLibType = ltUseCache then begin
    Result := GetCachedSurface(index);
  end;
end;

procedure TWMImages.FSetDxDraw(fdd: TDxDraw);
begin
  FDxDraw := fdd;
end;

procedure TWMImages.LoadDxImage(position: integer; pdximg: PTDxImage);
begin
  if MakeDIB(position) then begin
    pdximg.nPx := imginfo.px;
    pdximg.nPy := imginfo.py;
    pdximg.surface := TDirectDrawSurface.Create(FDDraw);
    pdximg.surface.SystemMemory := TRUE;
    pdximg.surface.SetSize(imginfo.nWidth, imginfo.nHeight);
    pdximg.surface.Canvas.Draw(0, 0, lsDib);
    pdximg.surface.Canvas.Release;
    pdximg.surface.TransparentColor := 0;
  end;
end;

function TWMImages.MakeDIB(index: integer; boHeader: Boolean = False): Boolean;
var
  nLeng: Integer;
begin
  Result := False;
  nLeng := 0;
  m_FileStream.Seek(index, 0);
  if btVersion = 0 then
    m_FileStream.Read(imginfo, SizeOf(TWMImageInfo) - 4)
  else
    m_FileStream.Read(imginfo, SizeOf(TWMImageInfo));

  if (imginfo.nWidth > 4024) or (imgInfo.nHeight > 4768) or (imginfo.nWidth < 1)
    or (imgInfo.nHeight < 1) or boHeader then
    Exit;

  lsDib.Clear;
  lsDib.Width := imginfo.nWidth;
  lsDib.Height := imginfo.nHeight;
  lsDib.PixelFormat.RBitMask := $FF0000;
  lsDib.PixelFormat.GBitMask := $00FF00;
  lsDib.PixelFormat.BBitMask := $0000FF;
  lsDib.BitmapInfo.bmiHeader.biCompression := BI_RGB;
  lsDib.Fill(0);
  case FBitType of
    dbtAuto: begin
        if btVersion > 1 then begin
          case imginfo.bitCount of
            16: begin
                lsDib.PixelFormat.RBitMask := $7C00;
                lsDib.PixelFormat.GBitMask := $03E0;
                lsDib.PixelFormat.BBitMask := $001F;
                if imginfo.biCompression = 1 then begin //555格式
                  lsDib.BitmapInfo.bmiHeader.biCompression := BI_BITFIELDS;
                end
                else if imginfo.biCompression = 2 then begin //565格式
                  lsDib.BitmapInfo.bmiHeader.biCompression := BI_BITFIELDS;
                  lsDib.PixelFormat.RBitMask := $F800;
                  lsDib.PixelFormat.GBitMask := $07E0;
                  lsDib.PixelFormat.BBitMask := $001F;
                end; //否则为普通格式
                lsDib.BitCount := 16;
                nLeng := imginfo.nWidth * imgInfo.nHeight * 2;
              end;
            24: begin
                nLeng := imginfo.nWidth * imgInfo.nHeight * 3;
                lsDib.BitCount := 24;
              end;
            32: begin
                nLeng := imginfo.nWidth * imgInfo.nHeight * 4;
                lsDib.BitCount := 32;
              end;
          else begin
              nLeng := imginfo.nWidth * imgInfo.nHeight;
              lsDib.BitCount := 8;

              lsDib.ColorTable := MainPalette;
              lsDib.UpdatePalette;
            end;
          end;
        end
        else begin
          nLeng := imginfo.nWidth * imgInfo.nHeight;
          lsDib.BitCount := 8;

          lsDib.ColorTable := MainPalette;
          lsDib.UpdatePalette;
        end;
      end;
    dbt8Bit: begin
        nLeng := imginfo.nWidth * imgInfo.nHeight;
        lsDib.BitCount := 8;

        lsDib.ColorTable := MainPalette;
        lsDib.UpdatePalette;
      end;
    dbt16Bit,
      dbt16Bit_555,
      dbt16Bit_565: begin
        lsDib.PixelFormat.RBitMask := $7C00;
        lsDib.PixelFormat.GBitMask := $03E0;
        lsDib.PixelFormat.BBitMask := $001F;
        if FBitType = dbt16Bit_555 then begin
          lsDib.BitmapInfo.bmiHeader.biCompression := BI_BITFIELDS;
        end
        else if FBitType = dbt16Bit_565 then begin
          lsDib.BitmapInfo.bmiHeader.biCompression := BI_BITFIELDS;
          lsDib.PixelFormat.RBitMask := $F800;
          lsDib.PixelFormat.GBitMask := $07E0;
          lsDib.PixelFormat.BBitMask := $001F;
        end;
        lsDib.BitCount := 16;
        nLeng := imginfo.nWidth * imgInfo.nHeight * 2;
      end;
    dbt24Bit: begin
        nLeng := imginfo.nWidth * imgInfo.nHeight * 3;
        lsDib.BitCount := 24;
      end;
    dbt32Bit: begin
        nLeng := imginfo.nWidth * imgInfo.nHeight * 4;
        lsDib.BitCount := 32;
      end;
  end;

  if m_FileStream.Read(lsDib.PBits^, nLeng) = nLeng then
    Result := True;
end;

procedure TWMImages.ClearCache;
var
  i: integer;
begin
  if FLibType <> ltLoadBmp then begin
    for i := 0 to FImageCount - 1 do begin
      if m_ImgArr[i].Surface <> nil then begin
        m_ImgArr[i].Surface.Free;
        m_ImgArr[i].Surface := nil;
      end;
    end;
  end;
end;

procedure TWMImages.FreeOldMemorys;
var
  i: integer;
begin
  for i := 0 to ImageCount - 1 do begin
    if m_ImgArr[i].Surface <> nil then begin
      if ((GetTickCount - m_ImgArr[i].dwLatestTime) > FFreeSurfaceTick) then
        begin
        m_ImgArr[i].Surface.Free;
        m_ImgArr[i].Surface := nil;
      end;
    end;
  end;
end;

function TWMImages.GetCachedSurface(index: integer): TDirectDrawSurface;
var
  nPosition: Integer;
begin
  Result := nil;
  if (index < 0) or (index >= ImageCount) then
    exit;
  if FAutoFreeMemorys and ((GetTickCount - m_dwMemChecktTick) >
    FAutoFreeMemorysTick) then begin
    m_dwMemChecktTick := GetTickCount;
    FreeOldMemorys;
  end;
  if m_ImgArr[index].Surface = nil then begin
    if index < m_IndexList.Count then begin
      nPosition := Integer(m_IndexList[index]);
      LoadDxImage(nPosition, @m_ImgArr[index]);
      m_ImgArr[index].dwLatestTime := GetTickCount;
      Result := m_ImgArr[index].Surface;
    end;
  end
  else begin
    m_ImgArr[index].dwLatestTime := GetTickCount;
    Result := m_ImgArr[index].Surface;
  end;
end;

function TWMImages.GetCachedImage(index: integer; var px, py: Integer):
  TDirectDrawSurface;
var
  position: integer;
begin
  Result := nil;
  if (index < 0) or (index >= ImageCount) or (FLibType <> ltUseCache) then
    exit;

  if FAutoFreeMemorys and ((GetTickCount - m_dwMemChecktTick) >
    FAutoFreeMemorysTick) then begin
    m_dwMemChecktTick := GetTickCount;
    FreeOldMemorys;
  end;
  if m_ImgArr[index].Surface = nil then begin
    if index < m_IndexList.Count then begin
      position := Integer(m_IndexList[index]);
      LoadDxImage(position, @m_ImgArr[index]);
      m_ImgArr[index].dwLatestTime := GetTickCount;
      px := m_ImgArr[index].nPx;
      py := m_ImgArr[index].nPy;
      Result := m_ImgArr[index].Surface;
    end;
  end
  else begin
    m_ImgArr[index].dwLatestTime := GetTickCount;
    px := m_ImgArr[index].nPx;
    py := m_ImgArr[index].nPy;
    Result := m_ImgArr[index].Surface;
  end;
end;

function TWMImages.GetBitmap(index: integer; var Bitmap: TBitmap): Boolean;
var
  nPosition: Integer;
begin
  Result := False;
  if (index >= 0) and (index < ImageCount) and (index < m_IndexList.Count) then
    begin
    nPosition := Integer(m_IndexList[index]);
    if MakeDIB(nPosition) then begin
      Bitmap.Width := lsDib.Width;
      Bitmap.Height := lsDib.Height;
      Bitmap.Canvas.Draw(0, 0, lsDib);
      Result := True;
    end;
  end;
end;

function TWMImages.GetBitmap(index: integer; var px, py: Integer;
  var Bitmap: TBitmap): Boolean;
var
  nPosition: Integer;
begin
  Result := False;
  if (index >= 0) and (index < ImageCount) and (index < m_IndexList.Count) then
    begin
    nPosition := Integer(m_IndexList[index]);
    if MakeDIB(nPosition) then begin
      Bitmap.Width := lsDib.Width;
      Bitmap.Height := lsDib.Height;
      Bitmap.Canvas.Draw(0, 0, lsDib);
      px := imginfo.px;
      py := imginfo.py;
      Result := True;
    end;
  end;
end;

{-----------------------------修改工作区---------------------------------------}

{$IF WERWORD = VERREADWRITE}

procedure TWMImages.SaveIndex();
var
  fhandle, i: integer;
  pvalue: PInteger;
begin
  if FileExists(FIdxFile) then begin
    fhandle := FileOpen(FIdxFile, fmOpenWrite or fmShareDenyNone);
    if fhandle > 0 then begin
      RemoveData(FIdxFile, 0, m_FileStream.Size); //删除原数据
      FIdxHeader.IndexCount := m_IndexList.Count;
      if btVersion = 0 then
        FileWrite(fhandle, FIdxHeader, Sizeof(TWMIndexHeader) - 4)
      else
        FileWrite(fhandle, FIdxHeader, Sizeof(TWMIndexHeader));

      GetMem(pvalue, 4 * FIdxHeader.IndexCount);
      for i := 0 to m_IndexList.Count - 1 do begin
        PInteger(integer(pvalue) + 4 * i)^ := Integer(m_IndexList.Items[I]);
      end;
      FileWrite(fhandle, pvalue^, 4 * FIdxHeader.IndexCount);
      FreeMem(pvalue);
      FileClose(fhandle);
    end;
  end;
end;

function TWMImages.GetImageSize(StartIndex, StopIndex: Integer): Integer;
begin
  Result := -1;
  if (StartIndex < m_IndexList.Count) and (StopIndex < m_IndexList.Count) and
    (StartIndex > -1) and (StopIndex > -1) then begin
    //判断是否最后一张图片
    if (StopIndex = (m_IndexList.Count - 1)) then begin
      Result := m_FileStream.Size - Integer(m_IndexList[StartIndex]);
    end
    else begin
      Result := Integer(m_IndexList[StartIndex]) - Integer(m_IndexList[StopIndex
        + 1]);
    end;
  end;
end;

function TWMImages.DelImages(StartIndex, StopIndex: Integer; boFlag: Boolean):
  Boolean;
var
  Imagesinfo: TWMImageInfo;
  WriteSize, I, nImagesCount, WriteSizeAll: Integer;
  position, positionend: integer;
  DBits: PChar;
  boBottom: Boolean;
begin
  Result := False;
  if (StartIndex < m_IndexList.Count) and (StopIndex < m_IndexList.Count) and
    (StartIndex > -1) and (StopIndex > -1) then begin

    position := Integer(m_IndexList[StartIndex]);
    nImagesCount := 0;
    boBottom := False;
    if StopIndex = (m_IndexList.Count - 1) then begin
      boBottom := True; //判断是否最后一张图片
    end
    else begin
      positionend := Integer(m_IndexList[StopIndex + 1]);
      //取下一张图片的位置
      nImagesCount := positionend - position;
    end;

    if not boFlag then begin //空图片替代
      FillChar(Imagesinfo, SizeOf(Imagesinfo), #0);
      Imagesinfo.nWidth := 1;
      Imagesinfo.nHeight := 1;
      Imagesinfo.px := 0;
      Imagesinfo.py := 0;
      if btVersion = 0 then begin
        WriteSize := SizeOf(TWMImageInfo) - 4 + 1;
        GetMem(DBits, WriteSize);
        FillChar(DBits^, WriteSize, 0);
        Move(Imagesinfo, DBits^, SizeOf(TWMImageInfo) - 4);
      end
      else begin
        WriteSize := SizeOf(TWMImageInfo) + 1;
        GetMem(DBits, WriteSize);
        FillChar(DBits^, WriteSize, 0);
        Move(Imagesinfo, DBits^, SizeOf(TWMImageInfo));
      end;
      try
        WriteSizeAll := WriteSize * (StopIndex - StartIndex + 1) - nImagesCount;
        if not boBottom then begin
          if WriteSizeAll > 0 then
            AppendData(FFileName, position, WriteSizeAll) //增加数据
          else if WriteSizeAll < 0 then
            RemoveData(FFileName, position, Abs(WriteSizeAll)); //删除数据

          UpdateIndex(StopIndex, WriteSizeAll);
        end;
        m_FileStream.Seek(position, 0);

        for I := 0 to (StopIndex - StartIndex) do begin
          m_IndexList.Items[StartIndex + I] := Pointer(position + WriteSize *
            I);
          m_FileStream.Write(DBits^, WriteSize);
        end;
      finally
        FreeMem(DBits);
      end;
      Result := True;
    end
    else begin
      if not boBottom then begin
        RemoveData(FFileName, position, nImagesCount); //删除原数据
        UpdateIndex(StopIndex, -nImagesCount);
      end
      else begin
        RemoveData(FFileName, position, m_FileStream.Size); //删除原数据
      end;
      for I := StartIndex to StopIndex do
        m_IndexList.Delete(StartIndex);

      FHeader.ImageCount := m_IndexList.Count;
      FImageCount := FHeader.ImageCount;
      FIdxHeader.IndexCount := m_IndexList.Count;
      m_FileStream.Seek(0, soFromBeginning);
      if btVersion = 0 then
        m_FileStream.Write(FHeader, SizeOf(TWMImageHeader) - 4)
      else
        m_FileStream.Write(FHeader, SizeOf(TWMImageHeader));
      Result := True;
    end;
  end;
end;

procedure TWMImages.UpdateIndex(StartIdx, nCount: Integer);
var
  I: Integer;
begin
  if (nCount <> 0) and ((StartIdx + 1) < m_IndexList.Count) then begin
    for I := (StartIdx + 1) to (m_IndexList.Count - 1) do begin
      m_IndexList.Items[I] := Pointer(Integer(m_IndexList.Items[I]) + nCount)
    end;

  end;
end;

function TWMImages.InsertImagesGetRoom(Index, nSize: Integer; SizeInfoList:
  TList):
  Boolean;
var
  position, I, Newposition: integer;
begin
  Result := False;
  if (Index < m_IndexList.Count) and (Index > -1) and (SizeInfoList <> nil) then
    begin
    position := Integer(m_IndexList[Index]);
    AppendData(FFileName, position, nSize); //申请空间
    UpdateIndex(Index - 1, nSize); //更新索引表
    Newposition := position;
    for I := 0 to SizeInfoList.Count - 1 do begin
      position := Integer(SizeInfoList.Items[i]);
      m_IndexList.Insert(Index + I, Pointer(Newposition));
      SizeInfoList.Items[i] := Pointer(Index + I);
      Inc(Newposition, position);
    end;

    FHeader.ImageCount := m_IndexList.Count;
    FImageCount := FHeader.ImageCount;
    FIdxHeader.IndexCount := m_IndexList.Count;
    m_FileStream.Seek(0, soFromBeginning);
    if btVersion = 0 then
      m_FileStream.Write(FHeader, SizeOf(TWMImageHeader) - 4)
    else
      m_FileStream.Write(FHeader, SizeOf(TWMImageHeader));
    Result := True;
  end;
end;

function TWMImages.ReplaceImagesGetRoom(Index, endindex, nSize: Integer;
  SizeInfoList: TList): Boolean;
var
  position, I, absposition, Newposition, positionend: integer;
begin
  Result := True;
  if (Index < m_IndexList.Count) and (Index > -1) and (SizeInfoList <> nil)
    and (endindex < m_IndexList.Count) and (endindex > -1) then begin
    position := Integer(m_IndexList[Index]);
    if endindex = (m_IndexList.Count - 1) then
      positionend := m_FileStream.Seek(0, soFromEnd)
    else
      positionend := Integer(m_IndexList[endindex + 1]);
    absposition := positionend - position;
    if absposition < nSize then
      AppendData(FFileName, position, nSize - absposition) //申请空间
    else if absposition > nSize then
      RemoveData(FFileName, position, absposition - nSize); //删除数据

    UpdateIndex(endindex, nSize - absposition); //更新索引表

    Newposition := position;
    for I := Index to endindex do begin
      position := Integer(SizeInfoList.Items[i - Index]);
      m_IndexList.Items[I] := Pointer(Newposition);
      SizeInfoList.Items[i - Index] := Pointer(I);
      Inc(Newposition, position);
    end;
    Result := True;
  end;
end;

function TWMImages.MakeAddDIB(): Integer;
begin
  Result := -1;
  FillChar(imginfo, SizeOf(imginfo), #0);
  imginfo.nWidth := lsDib.Width;
  imginfo.nHeight := lsDib.Height;
  imginfo.biCompression := 0;
  case FBitType of
    dbtAuto: begin
        if btVersion > 1 then begin
          case lsDib.bitCount of
            16: begin
                with lsDib.PixelFormat do begin
                  if (RBitMask = $7C00) and (GBitMask = $03E0) and (BBitMask =
                    $001F) then begin
                    imginfo.biCompression := 1;
                  end
                  else if (RBitMask = $F800) and (GBitMask = $07E0) and (BBitMask
                    = $001F) then begin
                    imginfo.biCompression := 2;
                  end;
                end;
                Result := lsDib.Width * lsDib.Height * 2;
              end;
            24: begin
                Result := lsDib.Width * lsDib.Height * 3;
              end;
            32: begin
                Result := lsDib.Width * lsDib.Height * 4;
              end;
          else begin
              CheckBitCount();
              Result := lsDib.Width * lsDib.Height;
            end;
          end;
        end
        else begin
          CheckBitCount();
          Result := lsDib.Width * lsDib.Height;
        end;
      end;
    dbt8Bit: begin
        CheckBitCount();
        Result := lsDib.Width * lsDib.Height;
      end;
    dbt16Bit,
      dbt16Bit_555,
      dbt16Bit_565: begin
        lsDib.PixelFormat.RBitMask := $7C00;
        lsDib.PixelFormat.GBitMask := $03E0;
        lsDib.PixelFormat.BBitMask := $001F;
        if FBitType = dbt16Bit_555 then begin
          lsDib.BitmapInfo.bmiHeader.biCompression := BI_BITFIELDS;
          imginfo.biCompression := 1;
        end
        else if FBitType = dbt16Bit_565 then begin
          lsDib.BitmapInfo.bmiHeader.biCompression := BI_BITFIELDS;
          lsDib.PixelFormat.RBitMask := $F800;
          lsDib.PixelFormat.GBitMask := $07E0;
          lsDib.PixelFormat.BBitMask := $001F;
          imginfo.biCompression := 2;
        end;
        lsDib.BitCount := 16;
        Result := lsDib.Width * lsDib.Height * 2;
      end;
    dbt24Bit: begin
        lsDib.PixelFormat.RBitMask := $FF0000;
        lsDib.PixelFormat.GBitMask := $00FF00;
        lsDib.PixelFormat.BBitMask := $0000FF;
        Result := lsDib.Width * lsDib.Height * 3;
      end;
    dbt32Bit: begin
        lsDib.PixelFormat.RBitMask := $FF0000;
        lsDib.PixelFormat.GBitMask := $00FF00;
        lsDib.PixelFormat.BBitMask := $0000FF;
        lsDib.BitCount := 32;
        Result := lsDib.Width * lsDib.Height * 4;
      end;
  end;
  imginfo.bitCount := lsDib.BitCount;
end;

procedure TWMImages.InsertImages(Index, px, py: Integer; TempDib: TDIB);
var
  position: Integer;
  nSize: Integer;
  tempimginfo: TWMImageInfo;
begin
  if (Index < m_IndexList.Count) and (Index > -1) then begin
    position := Integer(m_IndexList[Index]);
    if (px = -9999) then begin
      m_FileStream.Seek(position, 0);
      if btVersion = 0 then
        m_FileStream.Read(tempimginfo, SizeOf(TWMImageInfo) - 4)
      else
        m_FileStream.Read(tempimginfo, SizeOf(TWMImageInfo));
    end;
    lsDib.Assign(TempDIB);
    nSize := MakeAddDIB();
    if (px = -9999) then begin
      imginfo.px := tempimginfo.px;
      imginfo.py := tempimginfo.py;
    end
    else begin
      imginfo.px := px;
      imginfo.py := py;
    end;
    m_FileStream.Seek(position, 0);
    if btVersion = 0 then
      m_FileStream.Write(imginfo, SizeOf(TWMImageInfo) - 4)
    else
      m_FileStream.Write(imginfo, SizeOf(TWMImageInfo));
    m_FileStream.Write(lsDib.PBits^, nSize);
  end;
end;

procedure TWMImages.AddImages(px, py: Integer; TempDib: TDIB);
var
  position: Integer;
  nSize: Integer;
begin
  lsDib.Assign(TempDIB);
  nSize := MakeAddDIB();
  imginfo.px := px;
  imginfo.py := py;
  position := m_FileStream.Seek(0, soFromEnd);
  if btVersion = 0 then
    m_FileStream.Write(imginfo, SizeOf(TWMImageInfo) - 4)
  else
    m_FileStream.Write(imginfo, SizeOf(TWMImageInfo));
  m_FileStream.Write(lsDib.PBits^, nSize);

  m_IndexList.Add(Pointer(position));
  FHeader.ImageCount := m_IndexList.Count;
  FImageCount := FHeader.ImageCount;
  FIdxHeader.IndexCount := m_IndexList.Count;
  m_FileStream.Seek(0, soFromBeginning);
  if btVersion = 0 then
    m_FileStream.Write(FHeader, SizeOf(TWMImageHeader) - 4)
  else
    m_FileStream.Write(FHeader, SizeOf(TWMImageHeader));
end;

function TWMImages.GetImageHeaderSize(): Integer;
begin
  if btVersion = 0 then
    Result := SizeOf(TWMImageInfo) - 4
  else
    Result := SizeOf(TWMImageInfo);
end;

procedure TWMImages.SetImageInfo(index: integer; pimginfo: pTWMImageInfo);
var
  position: Integer;
begin
  if index < m_IndexList.Count then begin
    position := Integer(m_IndexList[index]);
    m_FileStream.Seek(position, 0);
    if btVersion = 0 then
      m_FileStream.Write(pimginfo^, SizeOf(TWMImageInfo) - 4)
    else
      m_FileStream.Write(pimginfo^, SizeOf(TWMImageInfo));
  end;
end;

function TWMImages.GetDibSize(TempDib: TDIB): Integer;
var
  nLeng: Integer;
begin
  nLeng := TempDib.Width * TempDib.Height;
  case FBitType of
    dbtAuto: begin
        if btVersion > 1 then begin
          case TempDib.bitCount of
            16: begin
                nLeng := TempDib.Width * TempDib.Height * 2;
              end;
            24: begin
                nLeng := TempDib.Width * TempDib.Height * 3;
              end;
            32: begin
                nLeng := TempDib.Width * TempDib.Height * 4;
              end;
          end;
        end;
      end;
    dbt8Bit: begin
      end;
    dbt16Bit,
      dbt16Bit_555,
      dbt16Bit_565: begin
        nLeng := TempDib.Width * TempDib.Height * 2;
      end;
    dbt24Bit: begin
        nLeng := TempDib.Width * TempDib.Height * 3;
      end;
    dbt32Bit: begin
        nLeng := TempDib.Width * TempDib.Height * 4;
      end;
  end;
  Result := nLeng;
end;

procedure TWMImages.CheckBitCount();
var
  x, y: Integer;
  pal1, pal2: TRGBQuad;
  btColor: Byte;
  nColor: Integer;
  j, MinDif, ColDif: integer;
  MatchColor: byte;
  lsDibTemp: TDIB;
begin
  lsDibTemp := TDIB.Create;
  try
    lsDibTemp.BitCount := 8;
    lsDibTemp.ColorTable := DefMainPalette;
    lsDibTemp.UpdatePalette;
    lsDibTemp.Width := lsDib.Width;
    lsDibTemp.Height := lsDib.Height;
    for x := 0 to lsDib.Width - 1 do
      for Y := 0 to lsDib.Height - 1 do begin
        case lsDib.BitCount of
          8: begin
              btColor := lsDib.Pixels[x, y];
              pal1 := lsDib.ColorTable[btColor];
              pal2 := DefMainPalette[btColor];
              if (pal1.rgbBlue = pal2.rgbBlue) and
                (pal1.rgbGreen = pal2.rgbGreen) and
                (pal1.rgbRed = pal2.rgbRed) then begin
                lsDibTemp.Pixels[x, y] := btColor;
                Continue;
              end
              else if (pal1.rgbBlue = 0) and
                (pal1.rgbGreen = 0) and
                (pal1.rgbRed = 0) then begin
                lsDibTemp.Pixels[x, y] := 0;
                Continue;
              end;
            end;
          24: begin
              nColor := lsDib.Pixels[x, y];
              pal1.rgbRed := GetRValue(nColor);
              pal1.rgbGreen := GetGValue(nColor);
              pal1.rgbBlue := GetBValue(nColor);
              if (pal1.rgbBlue = 0) and
                (pal1.rgbGreen = 0) and
                (pal1.rgbRed = 0) then begin
                lsDibTemp.Pixels[x, y] := 0;
                Continue;
              end;
            end;
          32: begin
              nColor := lsDib.Pixels[x, y];
              pal1.rgbRed := GetBValue(nColor);
              pal1.rgbGreen := GetGValue(nColor);
              pal1.rgbBlue := GetRValue(nColor);
              if (pal1.rgbBlue = 0) and
                (pal1.rgbGreen = 0) and
                (pal1.rgbRed = 0) then begin
                lsDibTemp.Pixels[x, y] := 0;
                Continue;
              end;
            end;
        end;
        MinDif := 768;
        MatchColor := 0;
        for j := 1 to 255 do begin
          pal2 := DefMainPalette[j];
          ColDif := Abs(pal2.rgbRed - pal1.rgbRed) +
            Abs(pal2.rgbGreen - pal1.rgbGreen) +
            Abs(pal2.rgbBlue - pal1.rgbBlue);
          if ColDif < MinDif then begin
            MinDif := ColDif;
            MatchColor := j;
          end;
        end;
        lsDibTemp.Pixels[x, y] := MatchColor;
      end;
    lsDib.Assign(lsDibTemp);
  finally
    lsDibTemp.Free;
  end;
end;

{$IFEND}

end.

