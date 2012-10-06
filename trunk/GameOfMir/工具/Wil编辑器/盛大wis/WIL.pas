unit WIL;

interface

uses
  Windows, Classes, Graphics, SysUtils, DXDraws,
  DirectX, DIB, wmUtil, HUtil32;

const
  VERFLAG = 88;

type
  TLibType = (ltLoadBmp, ltUseCache);

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
    //FBitType: TDxBitType;
    FInitialize: Boolean;
    FBitCount: Byte;
//    btVersion: Byte;
    FAppr: Word;
    procedure LoadPalette;
    procedure LoadIndex(idxfile: string);
    procedure LoadDxImage(position: integer; pdximg: PTDxImage);
    procedure FreeOldMemorys;
    function FGetImageSurface(index: integer): TDirectDrawSurface;
    function Decode(LineBuffer: PChar; width, height, nSize: Integer): Boolean;

    procedure FSetDxDraw(fdd: TDxDraw);
    function GetCachedSurface(index: integer): TDirectDrawSurface;

  protected
    m_dwMemChecktTick: LongWord;
  public
    m_ImgArr: pTDxImageArr;
    m_IndexList: TList;
    m_ImageSizeList: TList;
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
    function MakeDIB(index: integer; nSize: Integer): Boolean;

    function GetCachedImage(index: integer; var px, py: integer): TDirectDrawSurface;
    function GetBitmap(index: integer; var Bitmap: TBitmap): Boolean; overload;
    function GetBitmap(index: integer; var px, py: integer; var Bitmap: TBitmap): Boolean; overload;

    property Images[index: integer]: TDirectDrawSurface read FGetImageSurface;
    property DDraw: TDirectDraw read FDDraw write FDDraw;
    property ImageCount: integer read FImageCount;
    property boInitialize: Boolean read FInitialize;
    //property Version: Byte read btVersion;
    property BitCount: Byte read FBitCount;

  published
    property FileName: string read FFileName write FFileName;
    property DxDraw: TDxDraw read FDxDraw write FSetDxDraw;
    property LibType: TLibType read FLibType write FLibType;
    property Appr: Word read FAppr write FAppr;
    //property BitType: TDxBitType read FBitType write FBitType;
    property AutoFreeMemorys: Boolean read FAutoFreeMemorys write FAutoFreeMemorys;
    property AutoFreeMemorysTick: LongWord read FAutoFreeMemorysTick write FAutoFreeMemorysTick;
    property FreeSurfaceTick: LongWord read FFreeSurfaceTick write FFreeSurfaceTick;
  end;

function TDXDrawRGBQuadsToPaletteEntries(const RGBQuads: TRGBQuads; AllowPalette256: Boolean): TPaletteEntries;

function DecodeRLE(const Source, Target: Pointer; Count, ColorDepth: Cardinal): Integer;

implementation

constructor TWMImages.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FFileName := '';
  FImageCount := 0;
  //BitType := dbtAuto;
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
  //lsDib := nil;
  lsDib := TDib.Create;
  lsDib.BitCount := 8;
  FBitCount := 8;
  m_dwMemChecktTick := GetTickCount;
  m_ImageSizeList := TList.Create;
end;

destructor TWMImages.Destroy;
begin
  m_IndexList.Free;
  if m_FileStream <> nil then
    m_FileStream.Free;
  lsDib.Free;
  m_ImageSizeList.Free;
  inherited Destroy;
end;

procedure TWMImages.Initialize;
begin
  if not (csDesigning in ComponentState) then begin
    if FFileName = '' then begin
      //raise Exception.Create('FileName not assigned..');
      exit;
    end;
    //lsDib.Clear;
    if FileExists(FFileName) then begin
      FillChar(FHeader, SizeOf(FHeader), #0);
      if m_FileStream = nil then

      m_FileStream := TFileStream.Create(FFileName, fmOpenRead or fmShareDenyNone);
      m_FileStream.Read(FHeader, SizeOf(TWMImageHeader));
      if FHeader.Title <> 'WISA' then begin
        raise Exception.Create('不支持的文件格式..');
        exit;
      end;
      lsDib.PixelFormat.RBitMask := $FF0000;
      lsDib.PixelFormat.GBitMask := $00FF00;
      lsDib.PixelFormat.BBitMask := $0000FF;
      lsDib.BitCount := 8;
      lsDib.ColorTable := MainPalette;
      lsDib.UpdatePalette;
      LoadIndex('');
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
  lsDib.ColorTable := MainPalette;
  lsDib.UpdatePalette;
end;

procedure TWMImages.LoadIndex(idxfile: string);
var
  fhandle, i: integer;
  WMIndexInfo: TWMIndexInfo;
begin
  m_IndexList.Clear;
  m_ImageSizeList.Clear;
  FImageCount := 0;
  m_FileStream.Seek(-SizeOf(WMIndexInfo), soFromEnd);
  if m_FileStream.Read(WMIndexInfo, SizeOf(WMIndexInfo)) = SizeOf(WMIndexInfo) then begin
    m_FileStream.Seek(WMIndexInfo.nIndex + WMIndexInfo.nSize, soFromBeginning);
    while True do begin
      if m_FileStream.Read(WMIndexInfo, SizeOf(WMIndexInfo)) = SizeOf(WMIndexInfo) then begin
        m_IndexList.Add(pointer(WMIndexInfo.nIndex));
        m_ImageSizeList.Add(Pointer(WMIndexInfo.nSize));
        Inc(FImageCount);
      end else
        break;
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
  {if MakeDIB(position) then begin
    pdximg.nPx := imginfo.px;
    pdximg.nPy := imginfo.py;
    pdximg.surface := TDirectDrawSurface.Create(FDDraw);
    pdximg.surface.SystemMemory := TRUE;
    pdximg.surface.SetSize(imginfo.nWidth, imginfo.nHeight);
    pdximg.surface.Canvas.Draw(0, 0, lsDib);
    pdximg.surface.Canvas.Release;
    pdximg.surface.TransparentColor := 0;
  end;    }
end;

function GetPixel(P: PByte; BPP: Byte): Cardinal;
begin
  Result := P^;
  Inc(P);
  Dec(BPP);
  while BPP > 0 do begin
    Result := Result shl 8;
    Result := Result or P^;
    Inc(P);
    Dec(BPP);
  end;
end;

function CountDiffPixels(P: PByte; BPP: Byte; Count: Integer): Integer;

// counts pixels in buffer until two identical adjacent ones found

var
  N: Integer;
  Pixel,
    NextPixel: Cardinal;

begin
  N := 0;
  NextPixel := 0; // shut up compiler
  if Count = 1 then
    Result := Count
  else begin
    Pixel := GetPixel(P, BPP);
    while Count > 1 do begin
      Inc(P, BPP);
      NextPixel := GetPixel(P, BPP);
      if NextPixel = Pixel then Break;
      Pixel := NextPixel;
      Inc(N);
      Dec(Count);
    end;
    if NextPixel = Pixel then
      Result := N
    else
      Result := N + 1;
  end;
end;
//----------------------------------------------------------------------------------------------------------------------

function CountSamePixels(P: PByte; BPP: Byte; Count: Integer): Integer;

var
  Pixel,
    NextPixel: Cardinal;

begin
  Result := 1;
  Pixel := GetPixel(P, BPP);
  Dec(Count);
  while Count > 0 do begin
    Inc(P, BPP);
    NextPixel := GetPixel(P, BPP);
    if NextPixel <> Pixel then Break;
    Inc(Result);
    Dec(Count);
  end;
end;

function WidthBytes(w: Integer): Integer;
begin
  Result := (((w * 8) + 31) div 32) * 4;
end;

function DecodeRLE(const Source, Target: Pointer; Count, ColorDepth: Cardinal): Integer;
type
  PCardinalArray = ^TCardinalArray;
  TCardinalArray = array[0..MaxInt div 4 - 1] of Cardinal;
var
  I: Integer;
  SourcePtr,
    TargetPtr: PByte;
  RunLength: Cardinal;
  Counter: Cardinal;
  nCount: Integer;
  //  SourceCardinal: Cardinal;

begin
  Result := 0;
  Counter := 0;
  TargetPtr := Target;
  SourcePtr := Source;
  nCount := 0;
  while Counter < Count do begin
    //if Result >= ColorDepth then break;

    

    RunLength := SourcePtr^;
    //if (Counter + RunLength) > Count then break;
    if RunLength = 0 then begin
      Inc(SourcePtr);
      //Inc(TargetPtr);
      //Inc(Counter);
      RunLength := SourcePtr^;
      Inc(nCount, RunLength);
      //if (Counter + RunLength) > Count then break;
      Inc(SourcePtr);
      Move(SourcePtr^, TargetPtr^, RunLength);
      Inc(SourcePtr, RunLength);
      Inc(TargetPtr, RunLength);
      Inc(Result, RunLength + 2);
      Inc(Counter, RunLength);
    end else begin
      Inc(nCount, RunLength);
      Inc(SourcePtr);
      FillChar(TargetPtr^, RunLength, SourcePtr^);
      Inc(TargetPtr, RunLength);
      Inc(SourcePtr);
      Inc(Result, 2);
      Inc(Counter, RunLength);
    end;
  end;
  if nCount <> Count then
    Result := nCount;
end;

function TWMImages.Decode(LineBuffer: PChar; width, height, nSize: Integer): Boolean;
{var
  RLEBuffer, Buffer: Pointer;
  LineSize: Integer;
  i, ReadLength: Integer;
begin
  //  Result := False;
  LineSize := Width;
  RLEBuffer := AllocMem(2 * LineSize);
  for I := 0 to Height - 1 do begin
    Buffer := @LineBuffer[LineSize * i];
    ReadLength := m_FileStream.Read(RLEBuffer^, 2 * LineSize);
    m_FileStream.Position := m_FileStream.Position - ReadLength +
      DecodeRLE(RLEBuffer, Buffer, LineSize, 8);
  end;
  FreeMem(RLEBuffer);
  Result := True; }
var
  RLEBuffer: Pointer;
begin
  GetMem(RLEBuffer, nSize);
  m_FileStream.Read(RLEBuffer^, nSize);
  DecodeRLE(RLEBuffer, LineBuffer, width * height, nSize);
  FreeMem(RLEBuffer);
  Result := True;
end;

function TWMImages.MakeDIB(index: integer; nSize: Integer): Boolean;
var
  nLeng, I, ii, x, y: Integer;
  Buff: PChar;
  sptr, dptr: PChar;
  SBits, DBits: PByte;
begin
  Result := False;
  //FillChar(imginfo, SizeOf(imginfo), #0);
  if index <= 0 then Exit;
  m_FileStream.Seek(index, 0);
  m_FileStream.Read(imginfo, SizeOf(TWMImageInfo));

  if (imginfo.nWidth > 2048) or (imgInfo.nHeight > 1536) or (imginfo.nWidth < 2) or (imgInfo.nHeight < 2) then
    Exit;

  //lsDib.Width := WidthBytes(imginfo.nWidth);
  lsDib.Width := imginfo.nWidth;
  lsDib.Height := imginfo.nHeight;
  nLeng := lsDib.Width * lsDib.Height;
  lsdib.Fill($F1);
  GetMem(Buff, nLeng);
  //Setlength(Buff, imginfo.nHeight, imginfo.nWidth);
  //FillChar(Buff, 480000, $F1);

  if imginfo.nEncrypt <> 0 then begin
    Result := Decode(Buff, imginfo.nWidth, imginfo.nHeight, nSize - SizeOf(TWMImageInfo));
    SBits := PByte(Buff);

    for y := 0 to imginfo.nHeight - 1 do begin
      DBits := PByte(lsdib.ScanLine[y]);
      {for x := 0 to imginfo.nWidth - 1 do begin
        lsdib.Pixels[x, y] := SBits^;
        inc(SBits);
      end;  }
      Move(SBits^, DBits^, imginfo.nWidth);
      Inc(SBits, imginfo.nWidth);
    end;
      //Inc(SBits, imginfo.nWidth);
      //Move(SBits^, DBits^, imginfo.nWidth);
      //Inc (integer(DBits), imginfo.nWidth);
      {for ii := 0 to imginfo.nWidth - 1 do begin
        DBits^ := SBits^;
        Inc(Dbits);
        Dec(SBits);
      end;    }

      {Move(SBits^, DBits^, imginfo.nWidth);
      Inc (integer(DBits), imginfo.nWidth);   }
      {sptr := PChar(Integer(Buff) + (lsDib.Height - 1 - i) * lsDib.Width);
      dptr := PChar(Integer(lsDib.PBits) + i * lsDib.Width);
      Move(sptr^, dptr^, lsDib.Width);  }
    //end;
  end
  else begin
    if m_FileStream.Read(Buff^, nLeng) = nLeng then Result := True;
    for i := lsDib.Height - 1 downto 0 do begin
      sptr := PChar(Integer(Buff) + (lsDib.Height - 1 - i) * lsDib.Width);
      dptr := PChar(Integer(lsDib.PBits) + i * lsDib.Width);
      Move(sptr^, dptr^, lsDib.Width);
    end;
  end;
  if Result then begin

  end;
  //BUff := nil;
  FreeMem(Buff);
  {lsDib.Fill(0);
  if imginfo.nEncrypt <> 0 then begin
    Result := Decode(lsDib.PBits, lsDib.Width, lsDib.Height);
  end
  else begin

    if m_FileStream.Read(lsDib.PBits^, nLeng) = nLeng then Result := True;
  end; }

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
  for i := 0 to FImageCount - 1 do begin
    if m_ImgArr[i].Surface <> nil then begin
      if ((GetTickCount - m_ImgArr[i].dwLatestTime) > FFreeSurfaceTick) then begin
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
  if (index < 0) or (index >= FImageCount) then exit;
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

function TWMImages.GetCachedImage(index: integer; var px, py: integer):
  TDirectDrawSurface;
var
  position: integer;
begin
  Result := nil;
  if (index < 0) or (index >= FImageCount) or (FLibType <> ltUseCache) then
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
  nPosition, nSize: Integer;
begin
  Result := False;
  if (index >= 0) and (index < FImageCount) and (index < m_IndexList.Count) then begin
    nPosition := Integer(m_IndexList[index]);
    nSize := Integer(m_ImageSizeList[index]);
    if MakeDIB(nPosition, nSize) then begin
      Bitmap.Width := lsDib.Width;
      Bitmap.Height := lsDib.Height;
      Bitmap.Canvas.Draw(0, 0, lsDib);
      Result := True;
    end;
  end;
end;

function TWMImages.GetBitmap(index: integer; var px, py: integer; var Bitmap: TBitmap): Boolean;
var
  nPosition, nSize: Integer;
begin
  Result := False;
  if (index >= 0) and (index < FImageCount) and (index < m_IndexList.Count) then begin
    nPosition := Integer(m_IndexList[index]);
    nSize := Integer(m_ImageSizeList[index]);
    if MakeDIB(nPosition, nSize) then begin
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



end.

