unit FShare;

interface
uses
  Windows, Classes, SysUtils, StrUtils, HUtil32, INIFiles, Graphics, WIL, TDX9Textures, pngImage, Registry, ShellAPI;

type

  PRGBQuads = ^TRGBQuads;
  TRGBQuads = array[0..255] of TRGBQuad;

const
  DOWNDIRNAME = 'ÏÂÔØÄ¿Â¼';

  //FILEVARINDEX = 20110403;

var
  g_WMImages: TWMBaseImages;
  g_SelectImageIndex: Integer;
  g_DefMainPalette: TRgbQuads;
  g_CurrentDir: string;
  g_RunFileName: string;
  g_PackPassword: string;
  g_boLogin: Boolean = False;
  g_boOfflineLogin: Boolean = False;
  g_boCanOfflineLogin: Boolean = False;
  g_boConnect: Boolean = False;
  g_boToolConnect: Boolean = False;
  g_nLoginMark: Integer;
  g_nAgentLogin: Integer;
  g_nAgentM2: Integer;
  g_Config: TINIFile;
  g_DefDatImage: TBitmap;
  g_DefWavImage: TBitmap;
  g_DefMp3Image: TBitmap;
  

function CheckEMailRule(sEMail: string): Boolean;
function AppendData(FileName: string; Offset, FSize: Int64): Boolean;
function RemoveData(FileName: string; Offset, Size: Int64): Boolean;
function LoadPNGtoBMP(Stream: TStream; Dest: TBitmap): Boolean;
function DisplaceRB(Color: Cardinal): Cardinal;
function CountDiffPixels(P: PByte; BPP: Byte; Count: Integer): Integer;
function CountSamePixels(P: PByte; BPP: Byte; Count: Integer): Integer;
function GetPixel(P: PByte; BPP: Byte): Cardinal;
function GetFileIconIndex(sName: string): TIcon;

implementation


function GetFileIconIndex(sName: string): TIcon;
  function ExtractIconIndex(const FileName: string): Integer;
  var
    I: Integer;
  begin
    I := LastDelimiter(',' + PathDelim + DriveDelim, FileName);
    if (I > 0) and (FileName[I] = ',') then
      Result := StrToIntDef(Copy(FileName, I + 1, MaxInt), -1) else
      Result := -1;
  end;

  function ExtractIconFileName(const FileName: string): string;
  var
    I: Integer;
  begin
    I := LastDelimiter(',' + PathDelim + DriveDelim, FileName);
    if (I > 0) and (FileName[I] = ',') then
      Result := Copy(FileName, 0, I - 1) else
      Result := '';
  end;

  function FormatFileName(sFileName: string): string;
  var
    TempStr, s10, s18: string;
  begin
    Result := sFileName;
    if (sFileName <> '') and (sFileName[1] = '"') then
      ArrestStringEx(sFileName, '"', '"', sFileName);
    TempStr := sFileName;
    while (True) do begin
      if pos('%', TempStr) <= 0 then break;
      TempStr := ArrestStringEx(TempStr, '%', '%', s10);
      if s10 <> '' then begin
        s18 := GetEnvironmentVariable(s10);
        if s18 <> '' then begin
          sFileName := AnsiReplaceText(sFileName, '%' + s10 + '%', s18);
        end;
      end;
    end;
    Result := sFileName;
  end;
var
  sExt, sExtName, sIconFile, sFileName: string;
  nIndex: Integer;
  Reg: TRegistry;
  Large, Small: HICON;
  Icon: TIcon;
begin
  Result := nil;
  //sExt := ExtractFileExt(sName);
  sExt := sName;
  Reg := TRegistry.Create;
  Try
    sExtName := '';
    Reg.RootKey := HKEY_CLASSES_ROOT;
    if Reg.OpenKey(sExt, False) then begin
      sExtName := Reg.ReadString('');
    end;
    Reg.CloseKey;
    sIconFile := '';
    if (sExtName <> '') and Reg.OpenKey(sExtName + '\DefaultIcon', False) then begin
      sIconFile := Reg.ReadString('');
    end;
    Reg.CloseKey;
    if sIconFile <> '' then begin
      sFileName := FormatFileName(ExtractIconFileName(sIconFile));
      nIndex := ExtractIconIndex(sIconFile);
      if (nIndex <> -1) {and FileExists(sFileName)} then begin
        Small := 0;
        ExtractIconEx(PChar(sFileName), nIndex, Large, Small, 1);
        if Small <> 0 then begin
          Icon := TIcon.Create;
          Icon.Handle := Small;
          Result := Icon;
        end;
      end;
    end;
  Finally
    Reg.Free;
  End;
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
      if NextPixel = Pixel then
        Break;
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
    if NextPixel <> Pixel then
      Break;
    Inc(Result);
    Dec(Count);
  end;
end;

function DisplaceRB(Color: Cardinal): Cardinal;
asm
 mov eax, Color
 mov ecx, eax
 mov edx, eax
 and eax, 0FF00FF00h
 and edx, 0000000FFh
 shl edx, 16
 or eax, edx
 mov edx, ecx
 shr edx, 16
 and edx, 0000000FFh
 or eax, edx
 mov Result, eax
end;

function LoadPNGtoBMP(Stream: TStream; Dest: TBitmap): Boolean;
var
  Image: TPngObject;
  ScanIndex, i: Integer;
  PxScan: PLongword;
  PxAlpha: PByte;
begin
  Result := True;

  Image := TPngObject.Create();
  try
    Image.LoadFromStream(Stream);
  except
    Result := False;
  end;

  if (Result) then
  begin
    Image.AssignTo(Dest);

    if (Image.Header.ColorType = COLOR_RGBALPHA) or (Image.Header.ColorType = COLOR_GRAYSCALEALPHA) then
    begin
      Dest.PixelFormat := pf32bit;

      for ScanIndex := 0 to Dest.Height - 1 do
      begin
        PxScan := Dest.Scanline[ScanIndex];
        PxAlpha := @Image.AlphaScanline[ScanIndex][0];
        for i := 0 to Dest.Width - 1 do
        begin
          PxScan^ := (PxScan^ and $FFFFFF) or (Longword(Byte(PxAlpha^)) shl 24);
          Inc(PxScan);
          Inc(PxAlpha);
        end;
      end;
    end;
  end;

  Image.Free();
end;

function RemoveData(FileName: string; Offset, Size: Int64): Boolean;
var
  FData: PByte;
  FHandle, FMapHandle: THandle;
  FFileSize: Integer;
  FSize, FOffset: Int64;
begin
  Result := True;
  FHandle := FileOpen(FileName, fmOpenReadWrite or fmShareDenyNone);
  FFileSize := GetFileSize(FHandle, nil);
  FMapHandle := CreateFileMapping(FHandle, nil, PAGE_READWRITE, 0, FFileSize, PChar('RPG_PAK_' + IntToStr(Random(9999) + 1000)));
  FData := MapViewOfFile(FMapHandle, FILE_MAP_ALL_ACCESS, 0, 0, 0);
  if Size > (FFileSize - Offset) then
    FSize := FFileSize - Offset
  else
    FSize := Size;
  if Offset > FFileSize then
    FOffset := FFileSize
  else
    FOffset := Offset;
  CopyMemory(Pointer(LongInt(FData) + FOffset), Pointer(LongInt(FData) + FOffset + FSize), FFileSize - FOffset - FSize);
  if FData <> nil then
    UnMapViewOfFile(FData);
  if FMapHandle <> 0 then
    CloseHandle(FMapHandle);
  Fileseek(Fhandle, -FSize, 2);
  SetEndOfFile(FHandle);
  if FHandle <> 0 then
    CloseHandle(FHandle);
end;

function AppendData(FileName: string; Offset, FSize: Int64): Boolean;
var
  FData: PByte;
  FHandle, FMapHandle: THandle;
  FFileSize: Integer;
  FOffset: Int64;
begin
  Result := True;
  FHandle := FileOpen(FileName, fmOpenReadWrite or fmShareDenyNone);
  FFileSize := GetFileSize(FHandle, nil);
  if Offset > FFileSize then
    FOffset := FFileSize
  else
    FOffset := Offset;
  FMapHandle := CreateFileMapping(FHandle, nil, PAGE_READWRITE, 0, FFileSize + FSize, PChar('RPG_PAK_' + IntToStr(Random(9999) + 1000)));
  FData := MapViewOfFile(FMapHandle, FILE_MAP_ALL_ACCESS, 0, 0, 0);
  CopyMemory(Pointer(LongInt(FData) + FOffset + FSize), Pointer(LongInt(FData) + FOffset), FFileSize - FOffset);
  if FData <> nil then
    UnMapViewOfFile(FData);
  if FMapHandle <> 0 then
    CloseHandle(FMapHandle);
  if FHandle <> 0 then
    CloseHandle(FHandle);
end;

function CheckEMailRule(sEMail: string): Boolean;
var
  Chr: Char;
  str1, str2: string;
begin
  Result := False;
  str2 := GetValidStr3(sEMail, str1, ['@']);
  if Pos('.', str2) <= 0 then
    exit;
  Result := True;
  for Chr in str1 do
  begin
    if not (Chr in ['a'..'z', '0'..'9', '_', '-']) then
    begin
      Result := False;
      Exit;
    end;
  end;
  for Chr in str2 do
  begin
    if not (Chr in ['a'..'z', '0'..'9', '_', '.', '-']) then
    begin
      Result := False;
      Exit;
    end;
  end;
end;

end.

