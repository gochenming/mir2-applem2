unit WIL;

interface

uses
  Windows, Classes, Graphics, SysUtils, DXDraws, DXClass, Dialogs,
  DirectX, DIB, wmUtil, HUtil32;

const
   UseDIBSurface : Boolean = FALSE;
   BoWilNoCache : Boolean = FALSE;
      
type
   TLibType = (ltLoadBmp, ltLoadMemory, ltLoadMunual, ltUseCache);

   TBmpImage = packed record
      bmp: TBitmap;
      LatestTime: integer;
   end;
   PTBmpImage = ^TBmpImage;

   TBmpImageArr = array[0..MaxListSize div 4] of TBmpImage;
   TDxImageArr = array[0..MaxListSize div 4] of TDxImage;
   PTBmpImageArr = ^TBmpImageArr;
   PTDxImageArr = ^TDxImageArr;

   TWMImages = class (TComponent)
   private
      FFileName: string;
      FImageCount: integer;
      FLibType: TLibType;
      FDxDraw: TDxDraw;
      FDDraw: TDirectDraw;
      FMaxMemorySize: integer;
      procedure LoadAllData;
      procedure LoadAllDataBmp;
      procedure LoadIndex (idxfile: string);
      procedure LoadDxImage (position: integer; pdximg: PTDxImage);
      procedure LoadBmpImage (position: integer; pbmpimg: PTBmpImage);
      procedure FreeOldMemorys;
      function  FGetImageSurface (index: integer): TDirectDrawSurface;
      procedure FSetDxDraw (fdd: TDxDraw);
      procedure FreeOldBmps;
      function  FGetImageBitmap (index: integer): TBitmap;
   protected
      //MemorySize: integer;
      lsDib: TDib;
      memchecktime: longword;
   public
      ImgArr: PTDxImageArr;
      BmpArr: PTBmpImageArr;
      IndexList: TList;
      //BmpList: TList;
      Stream: TFileStream;
      //MainSurfacePalette: TDirectDrawPalette;
      MainPalette: TRgbQuads;
      constructor Create (AOwner: TComponent); override;
      destructor Destroy; override;

      procedure Initialize;
      procedure Finalize;
      procedure ClearCache;
      procedure LoadPalette;
      procedure FreeBitmap (index: integer);
      function  GetImage (index: integer; var px, py: integer): TDirectDrawSurface;
      function  GetCachedImage (index: integer; var px, py: integer): TDirectDrawSurface;
      function  GetCachedSurface (index: integer): TDirectDrawSurface;
      function  GetCachedBitmap (index: integer): TBitmap;
      procedure DrawZoom (paper: TCanvas; x, y, index: integer; zoom: Real);
      procedure DrawZoomEx (paper: TCanvas; x, y, index: integer; zoom: Real; leftzero: Boolean);
      property Images[index: integer]: TDirectDrawSurface read FGetImageSurface;
      property Bitmaps[Index: Integer]: TBitmap read FGetImageBitmap;
      property DDraw: TDirectDraw read FDDraw write FDDraw;
   published
      property FileName: string read FFileName write FFileName;
      property ImageCount: integer read FImageCount;
      property DxDraw: TDxDraw read FDxDraw write FSetDxDraw;
      property LibType: TLibType read FLibType write FLibType;
      property MaxMemorySize: integer read FMaxMemorySize write FMaxMemorySize;
   end;

function TDXDrawRGBQuadsToPaletteEntries(const RGBQuads: TRGBQuads; AllowPalette256: Boolean): TPaletteEntries;

procedure Register;


implementation

//uses
//   ClMain;  //나중에 지울 것.

procedure Register;
begin
   RegisterComponents('Zura', [TWmImages]);
end;

constructor TWMImages.Create (AOwner: TComponent);
begin
   inherited Create (AOwner);
   FFileName := '';
   FLibType := ltLoadBmp;
   FImageCount := 0;
   //MemorySize := 0;
   FMaxMemorySize := 1024*1000; //1M

   FDDraw := nil;
   FDxDraw := nil;
   Stream := nil;
   ImgArr := nil;
   BmpArr := nil;
   IndexList := TList.Create;
   lsDib := TDib.Create;
   lsDib.BitCount := 8;
   //BmpList := TList.Create;  //Bmp용으로 사용할 때문 사용

   memchecktime := GetTickCount;
end;

destructor TWMImages.Destroy;
begin
   IndexList.Free;
//   BmpList.Free;
   if Stream <> nil then Stream.Free;
   lsDib.Free;
   inherited Destroy;
end;

procedure TWMImages.Initialize;
var
   idxfile: string;
   header: TWMImageHeader;
begin
   if not (csDesigning in ComponentState) then begin
      if FFileName = '' then begin
         raise Exception.Create ('FileName not assigned..');
         exit;
      end;
      if (LibType <> ltLoadBmp) and (FDDraw = nil) then begin
         raise Exception.Create ('DDraw not assigned..');
         exit;
      end;
      if FileExists (FFileName) then begin
         if Stream = nil then
            Stream := TFileStream.Create (FFileName, fmOpenRead or fmShareDenyNone);
         Stream.Read (header, sizeof(TWMImageHeader));
         FImageCount := header.ImageCount;

         if LibType = ltLoadBmp then begin
            BmpArr := AllocMem (sizeof(TBmpImage) * FImageCount);
            if BmpArr = nil then
               raise Exception.Create (self.Name + ' BmpArr = nil');
         end else begin
            ImgArr := AllocMem (sizeof(TDxImage) * FImageCount);
            if ImgArr = nil then

               raise Exception.Create (self.Name + ' ImgArr = nil');
         end;

         idxfile := ExtractFilePath(FFileName) + ExtractFileNameOnly(FFileName) + '.WIX';
         LoadPalette;
         if LibType = ltLoadMemory then
            LoadAllData
         else begin
            LoadIndex (idxfile);
         end;
      end else begin
         MessageDlg (FFileName + ' 커쩌코청唐侶몸匡숭.', mtWarning, [mbOk], 0);
      end;
   end;
end;

procedure TWMImages.Finalize;
var
   i: integer;
begin
   for i:=0 to FImageCount-1 do begin
      if ImgArr[i].Surface <> nil then begin
         ImgArr[i].Surface.Free;
         ImgArr[i].Surface := nil;
      end;
   end;
   if Stream <> nil then begin
      Stream.Free;
      Stream := nil;
   end;
end;

function TDXDrawRGBQuadsToPaletteEntries(const RGBQuads: TRGBQuads;
  AllowPalette256: Boolean): TPaletteEntries;
var
  Entries: TPaletteEntries;
  dc: THandle;
  i: Integer;
begin
  Result := RGBQuadsToPaletteEntries(RGBQuads);

  if not AllowPalette256 then
  begin
    dc := GetDC(0);
    GetSystemPaletteEntries(dc, 0, 256, Entries);
    ReleaseDC(0, dc);

    for i:=0 to 9 do
      Result[i] := Entries[i];

    for i:=256-10 to 255 do
      Result[i] := Entries[i];
  end;

  for i:=0 to 255 do
    Result[i].peFlags := D3DPAL_READONLY;
end;

//Cache없이 한꺼번에 로딩함.
procedure TWMImages.LoadAllData;
var
   i: integer;
   imgi: TWMImageInfo;
   dib: TDIB;
   dximg: TDxImage;
begin
   dib := TDIB.Create;
   for i:=0 to FImageCount-1 do begin
      Stream.Read (imgi, sizeof(TWMImageInfo) - 4);

      dib.Width := imgi.Width;
      dib.Height := imgi.Height;
      dib.ColorTable := MainPalette;
      dib.UpdatePalette;
      Stream.Read (dib.PBits^, imgi.Width * imgi.Height);

      dximg.px := imgi.px;
      dximg.py := imgi.py;
      dximg.surface := TDirectDrawSurface.Create (FDDraw);
      dximg.surface.SystemMemory := TRUE;
      dximg.surface.SetSize (imgi.Width, imgi.Height);
      dximg.surface.Canvas.Draw (0, 0, dib);
      dximg.surface.Canvas.Release;
      dib.Clear; //FreeImage;

      dximg.surface.TransparentColor := 0;
      ImgArr[i] := dximg;
   end;
   dib.Free;
end;

procedure TWMImages.LoadPalette;
var
   Entries: TPaletteEntries;
begin
   Stream.Seek (sizeof(TWMImageHeader), 0);
   Stream.Read (MainPalette, sizeof(TRgbQuad) * 256); //팔래트

   //Entries := TDXDrawRGBQuadsToPaletteEntries (MainPalette, TRUE);
   //MainSurfacePalette := TDirectDrawPalette.Create (FDDraw);
   ////MainSurfacePalette.SetEntries(0, 256, Entries);
   //MainSurfacePalette.CreatePalette(DDPCAPS_8BIT, Entries);
end;

//Cache없이 한꺼번에 Bmp로 로딩함.
procedure TWMImages.LoadAllDataBmp;
var
   i: integer;
   pbuf: PByte;
   imgi: TWMImageInfo;
   bmp: TBitmap;
begin
{   GetMem (pbuf, 1024*768);  //공용 버퍼생성, 특별한 이유가 있음
   Stream.Seek (sizeof(TWMImageHeader), 0);
   Stream.Read (MainPalette, sizeof(TRgbQuad) * 256); //팔래트
   for i:=0 to ImageCount-1 do begin
      Stream.Read (imgi, sizeof(TWMImageInfo)-4);
      Stream.Read (pbuf^, imgi.Width * imgi.Height);
      bmp := MakeBmp (imgi.Width, imgi.Height, pbuf, MainPalette);
      BmpList.Add (bmp);     //BMP리스트를 동시에 관리.. (그리드에 그리기용)
   end;
   FreeMem (pbuf); }
end;

procedure TWMImages.LoadIndex (idxfile: string);
var
   fhandle, i, value: integer;
   header: TWMIndexHeader;
   pidx: PTWMIndexInfo;
   pvalue: PInteger;
begin
   indexlist.Clear;
   if FileExists (idxfile) then begin
      fhandle := FileOpen (idxfile, fmOpenRead or fmShareDenyNone);
      if fhandle > 0 then begin
         FileRead (fhandle, header, sizeof(TWMIndexHeader));
         GetMem (pvalue, 4*header.IndexCount);
         FileRead (fhandle, pvalue^, 4*header.IndexCount);
         for i:=0 to header.IndexCount-1 do begin
            new (pidx);
            value := PInteger(integer(pvalue) + 4*i)^;
            IndexList.Add (pointer(value));
         end;
         FreeMem (pvalue);
         FileClose (fhandle);
      end;
   end;
end;

{----------------- Private Variables ---------------------}

function  TWMImages.FGetImageSurface (index: integer): TDirectDrawSurface;
begin
   Result := nil;
   if LibType = ltUseCache then begin
      Result := GetCachedSurface (index);
   end else
      if LibType = ltLoadMemory then begin
         if (index >= 0) and (index < ImageCount) then
            Result := ImgArr[index].Surface;
      end;
         
end;

function  TWMImages.FGetImageBitmap (index: integer): TBitmap;
begin
   if LibType <> ltLoadBmp then exit;
   Result := GetCachedBitmap (index);
   {if index in [0..BmpList.Count-1] then begin
      Result := TBitmap (BmpList[index]);
   end else
      Result := nil;}
end;

procedure TWMImages.FSetDxDraw (fdd: TDxDraw);
begin
   FDxDraw := fdd;
end;

// *** DirectDrawSurface Functions

procedure TWMImages.LoadDxImage (position: integer; pdximg: PTDxImage);
var
   imginfo: TWMImageInfo;
   ddsd: DDSURFACEDESC;
   SBits, PSrc, DBits: PByte;
   n, slen, dlen: integer;
begin
   Stream.Seek (position, 0);
   Stream.Read (imginfo, sizeof(TWMImageInfo)-4);
   if UseDIBSurface then begin //DIB사용 버그 있음
      try
      lsDib.Clear;
      lsDib.Width := imginfo.Width;
      lsDib.Height := imginfo.Height;
      except
      end;
      lsDib.ColorTable := MainPalette;
      lsDib.UpdatePalette;
      DBits := lsDib.PBits;
      Stream.Read (DBits^, imginfo.Width * imgInfo.Height);

      pdximg.px := imginfo.px;
      pdximg.py := imginfo.py;
      pdximg.surface := TDirectDrawSurface.Create (FDDraw);
      pdximg.surface.SystemMemory := TRUE;
      pdximg.surface.SetSize (imginfo.Width, imginfo.Height);
      pdximg.surface.Canvas.Draw (0, 0, lsDib);
      pdximg.surface.Canvas.Release;

      pdximg.surface.TransparentColor := 0;

   end else begin //풀 스크린에서만 사용

      slen  := WidthBytes(imginfo.Width);
      GetMem (PSrc, slen * imgInfo.Height);
      SBits := PSrc;
      Stream.Read (PSrc^, slen * imgInfo.Height);
      try
         pdximg.surface := TDirectDrawSurface.Create (FDDraw);
         pdximg.surface.SystemMemory := TRUE;
         pdximg.surface.SetSize (slen, imginfo.Height);
         //pdximg.surface.Palette := MainSurfacePalette;

         pdximg.px := imginfo.px;
         pdximg.py := imginfo.py;

         ddsd.dwSize := SizeOf(ddsd);
         pdximg.surface.Lock (TRect(nil^), ddsd);
         DBits := ddsd.lpSurface;
         for n:=imginfo.Height-1 downto 0 do begin
            SBits := PByte (Integer(PSrc) + slen * n);
            Move(SBits^, DBits^, slen);
            Inc (integer(DBits), ddsd.lPitch);
         end;
         pdximg.surface.TransparentColor := 0;
      finally
         pdximg.surface.UnLock; //(ddsd.lpSurface);
         FreeMem (PSrc);
      end;
   end;
end;

procedure TWMImages.LoadBmpImage (position: integer; pbmpimg: PTBmpImage);
var
   imginfo: TWMImageInfo;
   ddsd: DDSURFACEDESC;
   DBits: PByte;
   n, slen, dlen: integer;
begin
   Stream.Seek (position, 0);
   Stream.Read (imginfo, sizeof(TWMImageInfo)-4);

   lsDib.Width := imginfo.Width;
   lsDib.Height := imginfo.Height;
   lsDib.ColorTable := MainPalette;
   lsDib.UpdatePalette;
   DBits := lsDib.PBits;
   Stream.Read (DBits^, imginfo.Width * imgInfo.Height);

   pbmpimg.bmp := TBitmap.Create;
   pbmpimg.bmp.Width := lsDib.Width;
   pbmpimg.bmp.Height := lsDib.Height;
   pbmpimg.bmp.Canvas.Draw (0, 0, lsDib);
   lsDib.Clear;
end;

procedure TWMImages.ClearCache;
var
   i: integer;
begin
   for i:=0 to ImageCount-1 do begin
      if ImgArr[i].Surface <> nil then begin
         ImgArr[i].Surface.Free;
         ImgArr[i].Surface := nil;
      end;
   end;
   //MemorySize := 0;
end;

function  TWMImages.GetImage (index: integer; var px, py: integer): TDirectDrawSurface;
begin
   if (index >= 0) and (index < ImageCount) then begin
      px := ImgArr[index].px;
      py := ImgArr[index].py;
      Result := ImgArr[index].surface;
   end else
      Result := nil;
end;

{--------------- BMP functions ----------------}

//오래된 캐시 지움
procedure TWMImages.FreeOldBmps;
var
   i, n, ntime, curtime, limit: integer;
begin
   n := -1;
   ntime := 0;
   //limit := FMaxMemorySize * 9 div 10;
   for i:=0 to ImageCount-1 do begin
      curtime := GetTickCount;
      if BmpArr[i].Bmp <> nil then begin
         if curtime - BmpArr[i].LatestTime > 5 * 1000 then begin
            //MemorySize := MemorySize - BmpArr[i].Bmp.Width * BmpArr[i].Bmp.Height;
            BmpArr[i].Bmp.Free;
            BmpArr[i].Bmp := nil;
         end else begin
            if curtime - BmpArr[i].LatestTime > ntime then begin
               ntime := curtime - BmpArr[i].LatestTime;
               n := i;
            end;
         end;
      end;
      //if MemorySize < limit then begin
      //   n := -1;
      //   break;
      //end;
   end;
   //if n >= 0 then begin
   //   MemorySize := MemorySize - BmpArr[n].Bmp.Width * BmpArr[n].Bmp.Height;
   //   BmpArr[n].Bmp.FreeImage;
   //   BmpArr[n].Bmp.Free;
   //   BmpArr[n].Bmp := nil;
   //end;
end;

procedure TWMImages.FreeBitmap (index: integer);
begin
   if (index >= 0) and (index < ImageCount) then begin
      if BmpArr[index].Bmp <> nil then begin
         //MemorySize  := MemorySize - BmpArr[index].Bmp.Width * BmpArr[index].Bmp.Height;
         //if MemorySize < 0 then MemorySize := 0;
         BmpArr[index].Bmp.FreeImage;
         BmpArr[index].Bmp.Free;
         BmpArr[index].Bmp := nil;
      end;
   end;
end;


//오래된 캐시 지움
procedure TWMImages.FreeOldMemorys;
var
   i, n, ntime, curtime, limit: integer;
begin
   n := -1;
   ntime := 0;
   //limit := FMaxMemorySize * 9 div 10;
   curtime := GetTickCount;
   for i:=0 to ImageCount-1 do begin
      if ImgArr[i].Surface <> nil then begin
         if curtime - ImgArr[i].LatestTime > 5 * 60 * 1000 then begin
            //MemorySize := MemorySize - ImgArr[i].Surface.Width * ImgArr[i].Surface.Height;
            ImgArr[i].Surface.Free;
            ImgArr[i].Surface := nil;
         end;
      end;
      //if MemorySize < limit then begin
      //   n := -1;
      //   break;
      //end;
   end;
end;

//Cache를 이용함
function  TWMImages.GetCachedSurface (index: integer): TDirectDrawSurface;
var
   position: integer;
begin
   Result := nil;  
   try
   if (index < 0) or (index >= ImageCount) then exit;
   if GetTickCount - memchecktime > 65535 then  begin
      memchecktime := GetTickCount;
      //if MemorySize > FMaxMemorySize then begin
      FreeOldMemorys;
      //end;
   end;
   if ImgArr[index].Surface = nil then begin //cache되어 있지 않음. 새로 읽어야함.
      if index < IndexList.Count then begin
         position := Integer(IndexList[index]);
         LoadDxImage (position, @ImgArr[index]);
         ImgArr[index].LatestTime := GetTickCount;
         Result := ImgArr[index].Surface;
         //MemorySize := MemorySize + ImgArr[index].Surface.Width * ImgArr[index].Surface.Height;
      end;
   end else begin
      ImgArr[index].LatestTime := GetTickCount;
      Result := ImgArr[index].Surface;
   end;
   except
      //////DebugOutStr ('GetCachedSurface 3');
   end;
end;

function  TWMImages.GetCachedImage (index: integer; var px, py: integer): TDirectDrawSurface;
var
   position: integer;
begin
   Result := nil;  
   try
   if (index < 0) or (index >= ImageCount) then exit;
   if GetTickCount - memchecktime > 65535 then  begin
      memchecktime := GetTickCount;
      //if MemorySize > FMaxMemorySize then begin
      FreeOldMemorys;
      //end;
   end;
   if ImgArr[index].Surface = nil then begin //cache되어 있지 않음. 새로 읽어야함.
      if index < IndexList.Count then begin
         position := Integer(IndexList[index]);
         LoadDxImage (position, @ImgArr[index]);
         ImgArr[index].LatestTime := GetTickCount;
         px := ImgArr[index].px;
         py := ImgArr[index].py;
         Result := ImgArr[index].Surface;
         //MemorySize := MemorySize + ImgArr[index].Surface.Width * ImgArr[index].Surface.Height;
      end;
   end else begin
      ImgArr[index].LatestTime := GetTickCount;
      px := ImgArr[index].px;
      py := ImgArr[index].py;
      Result := ImgArr[index].Surface;
   end;
   except
      /////DebugOutStr ('GetCachedImage 3');
   end;
end;

function  TWMImages.GetCachedBitmap (index: integer): TBitmap;
var
   position: integer;
begin
   Result := nil;
   if (index < 0) or (index >= ImageCount) then exit;
   if BmpArr[index].Bmp = nil then begin //cache되어 있지 않음. 새로 읽어야함.
      if index < IndexList.Count then begin
         position := Integer(IndexList[index]);
         LoadBmpImage (position, @BmpArr[index]);
         BmpArr[index].LatestTime := GetTickCount;
         Result := BmpArr[index].Bmp;
         //MemorySize := MemorySize + BmpArr[index].Bmp.Width * BmpArr[index].Bmp.Height;
         //if (MemorySize > FMaxMemorySize) then begin
         FreeOldBmps;
         //end;
      end;
   end else begin
      BmpArr[index].LatestTime := GetTickCount;
      Result := BmpArr[index].Bmp;
   end;
end;

procedure TWMImages.DrawZoom (paper: TCanvas; x, y, index: integer; zoom: Real);
var
   rc: TRect;
   bmp: TBitmap;
begin
   if LibType <> ltLoadBmp then exit;
   //if index > BmpList.Count-1 then exit;
   bmp := Bitmaps[index];
   if bmp <> nil then begin
      rc.Left := x;
      rc.Top  := y;
      rc.Right := x + Round (bmp.Width * zoom);
      rc.Bottom := y + Round (bmp.Height * zoom);
      if (rc.Right > rc.Left) and (rc.Bottom > rc.Top) then begin
         paper.StretchDraw (rc, Bmp);
         FreeBitmap (index);
      end;
   end;
end;

procedure TWMImages.DrawZoomEx (paper: TCanvas; x, y, index: integer; zoom: Real; leftzero: Boolean);
var
   rc: TRect;
   bmp, bmp2: TBitmap;
begin
   if LibType <> ltLoadBmp then exit;
   //if index > BmpList.Count-1 then exit;
   bmp := Bitmaps[index];
   if bmp <> nil then begin
      Bmp2 := TBitmap.Create;
      Bmp2.Width := Round (Bmp.Width * zoom);
      Bmp2.Height := Round (Bmp.Height * zoom);
      rc.Left := x;
      rc.Top  := y;
      rc.Right := x + Round (bmp.Width * zoom);
      rc.Bottom := y + Round (bmp.Height * zoom);
      if (rc.Right > rc.Left) and (rc.Bottom > rc.Top) then begin
         Bmp2.Canvas.StretchDraw (Rect(0, 0, Bmp2.Width, Bmp2.Height), Bmp);
         if leftzero then begin
            SpliteBitmap (paper.Handle, X, Y, Bmp2, $0)
         end else begin
            SpliteBitmap (paper.Handle, X, Y-Bmp2.Height, Bmp2, $0);
         end;
      end;
      FreeBitmap (index);
      bmp2.Free;
   end;
end;




end.
