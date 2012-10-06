unit Share;

interface
uses
  Windows, Classes, SysUtils, StrUtils, ShlObj, DIB;

const
  SaveXYDir = 'Placements\';
  C_Title   = 'ILIB v1.0-WEMADE Entertainment inc.';
  C_Title2  = 'ILIB v10.0-WEMADE Entertainment inc.';

function ExtractFileNameOnly(const fname: string): string;
function BrowseForFolder(hd: HWND; sTitle: string): string;
function GetIndexToStr(Index: Integer): string;
function RemoveData(FfileName: string; Offset, Size: Int64): Boolean;
function AppendData(FfileName: string; Offset, FSize: Int64): Boolean;
function FormatDIB(var OldDIB: TDIB): TDIB;

var
  DefMainPalette: TRgbQuads;

implementation

function FormatDIB(var OldDIB: TDIB): TDIB;
begin
  Result := OldDIB;
  if OldDIB.Width mod 2 <> 0 then begin
    Result := TDIB.Create;
    Result.PixelFormat.RBitMask := OldDIB.PixelFormat.RBitMask;
    Result.PixelFormat.GBitMask := OldDIB.PixelFormat.GBitMask;
    Result.PixelFormat.BBitMask := OldDIB.PixelFormat.BBitMask;
    Result.BitCount := OldDIB.BitCount;
    Result.Width := OldDIB.Width + 1;
    Result.Height := OldDIB.Height;
    Result.Fill(0);
    Result.Canvas.Draw(0, 0, OldDIB);
    OldDIB.Free;
  end;
end;

function RemoveData(FfileName: string; Offset, Size: Int64): Boolean;
var
  FData: PByte;
  FHandle, FMapHandle: THandle;
  FFileSize: Integer;
  FSize, FOffset: Int64;
begin
  Result := True;
  FHandle := FileOpen(FfileName, fmOpenReadWrite or fmShareDenyNone);
  FFileSize := GetFileSize(FHandle, nil);
  FMapHandle := CreateFileMapping(FHandle, nil, PAGE_READWRITE, 0, FFileSize,
    nil);
  FData := MapViewOfFile(FMapHandle, FILE_MAP_ALL_ACCESS, 0, 0, 0);
  if Size > (FFileSize - Offset) then
    FSize := FFileSize - Offset
  else
    FSize := Size;
  if Offset > FFileSize then
    FOffset := FFileSize
  else
    FOffset := Offset;
  CopyMemory(Pointer(LongInt(FData) + FOffset), Pointer(LongInt(FData) + FOffset
    + FSize), FFileSize - FOffset - FSize);
  if FData <> nil then
    UnMapViewOfFile(FData);
  if FMapHandle <> 0 then
    CloseHandle(FMapHandle);
  Fileseek(Fhandle, -FSize, 2);
  SetEndOfFile(FHandle);
  if FHandle <> 0 then
    CloseHandle(FHandle);
end;

function AppendData(FfileName: string; Offset, FSize: Int64): Boolean;
var
  FData: PByte;
  FHandle, FMapHandle: THandle;
  FFileSize: Integer;
  FOffset: Int64;
begin
  Result := True;
  FHandle := FileOpen(FfileName, fmOpenReadWrite or fmShareDenyNone);
  FFileSize := GetFileSize(FHandle, nil);
  if Offset > FFileSize then
    FOffset := FFileSize
  else
    FOffset := Offset;
  FMapHandle := CreateFileMapping(FHandle, nil, PAGE_READWRITE, 0, FFileSize +
    FSize, nil);
  FData := MapViewOfFile(FMapHandle, FILE_MAP_ALL_ACCESS, 0, 0, 0);
  CopyMemory(Pointer(LongInt(FData) + FOffset + FSize), Pointer(LongInt(FData) +
    FOffset), FFileSize - FOffset);
  if FData <> nil then
    UnMapViewOfFile(FData);
  if FMapHandle <> 0 then
    CloseHandle(FMapHandle);
  if FHandle <> 0 then
    CloseHandle(FHandle);
end;

function ExtractFileNameOnly(const fname: string): string;
var
  extpos: integer;
  ext, fn: string;
begin
  ext := ExtractFileExt(fname);
  fn := ExtractFileName(fname);
  if ext <> '' then begin
    extpos := pos(ext, fn);
    Result := Copy(fn, 1, extpos - 1);
  end
  else
    Result := fn;
end;

function BrowseForFolder(hd: HWND; sTitle: string): string;
var
  BrowseInfo: TBrowseInfo;
  sBuf: array[0..511] of Char;
begin
  FillChar(BrowseInfo, SizeOf(TBrowseInfo), #0);
  BrowseInfo.hwndOwner := hd;
  BrowseInfo.lpszTitle := PChar(sTitle);
  BrowseInfo.ulFlags := 64;
  SHGetPathFromIDList(SHBrowseForFolder(BrowseInfo), @sBuf);
  Result := Trim(sBuf);
end;

function GetIndexToStr(Index: Integer): string;
begin
  Result := IntToStr(Index);
  while True do begin
    if Length(Result) < 6 then begin
      Result := '0' + Result;
    end
    else
      break;
  end;
end;

end.

