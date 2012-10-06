program baiduAlbum;

uses
  SysUtils, Classes, Windows, Math, StrUtils;

const
  BMP_PART_SIZE = $7CCF0;
  BMP_MAX_SIZE = $7CD2E;

type
  TBmpPartBuffer = array [0 .. BMP_PART_SIZE - 1] of Char;

  TBmpPartInfo = packed record
    BitmapFileHeader: TBitmapFileHeader;
    BitmapInfoHeader: TBitmapInfoHeader;
    nFileSize: Integer;
    nDataSize: Integer;
  end;

function ProcessFile(const AFileName: string): Boolean;
var
  FileStream, WriteStream: TFileStream;
  sPath, sName, sSaveName: string;
  Buffer: TBmpPartBuffer;
  nCount{, nMaxCount}, nRate: Integer;
  BmpPartInfo: TBmpPartInfo;
  AppendBuffer: PChar;
  AppendLen: Integer;
  nReadSize: DWord;
begin
  Result := False;
  if not FileExists(AFileName) then
    exit;
  if FileExists(AFileName) then
  begin
    ZeroMemory(@BmpPartInfo, SizeOf(TBmpPartInfo));
    BmpPartInfo.BitmapFileHeader.bfType := $4D42;
    BmpPartInfo.BitmapFileHeader.bfSize := $7CD2E;
    BmpPartInfo.BitmapFileHeader.bfOffBits := $36;
    BmpPartInfo.BitmapInfoHeader.biSize := SizeOf(BmpPartInfo.BitmapInfoHeader);
    BmpPartInfo.BitmapInfoHeader.biWidth := 357;
    BmpPartInfo.BitmapInfoHeader.biHeight := 358;
    BmpPartInfo.BitmapInfoHeader.biPlanes := 1;
    BmpPartInfo.BitmapInfoHeader.biBitCount := $20;
    BmpPartInfo.BitmapInfoHeader.biSizeImage := $7CCF8;
    FileStream := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyWrite);
    try
      Result := True;
      if FileStream.Size > 0 then
      begin
        BmpPartInfo.nFileSize := FileStream.Size;
        sPath := ExtractFilePath(AFileName);
        sName := ExtractFileName(AFileName);
        sPath := sPath + sName + '.part\';
        ForceDirectories(sPath);
        nCount := 1;
        //nMaxCount := FileStream.Size div BMP_PART_SIZE + 1;
        while True do
        begin
          AppendBuffer := nil;
          AppendLen := 0;
          nReadSize := FileStream.Read(Buffer, BMP_PART_SIZE);
          if nReadSize > 0 then
          begin
            BmpPartInfo.nDataSize := nReadSize;
            if nReadSize < BMP_PART_SIZE then
            begin
              nRate := Round(Power(nReadSize div 4, 1 / 2));
              BmpPartInfo.BitmapInfoHeader.biWidth := nRate;
              while True do
              begin
                if DWord(BmpPartInfo.BitmapInfoHeader.biWidth * nRate * 4) > nReadSize then
                  Break;
                Inc(nRate);
              end;
              if (BmpPartInfo.BitmapInfoHeader.biWidth * nRate * 4) < BMP_PART_SIZE then
              begin
                BmpPartInfo.BitmapInfoHeader.biHeight := nRate;
                BmpPartInfo.BitmapInfoHeader.biSizeImage := BmpPartInfo.BitmapInfoHeader.biWidth * nRate * 4;
                BmpPartInfo.BitmapFileHeader.bfSize := BmpPartInfo.BitmapInfoHeader.biSizeImage + $36;
                if BmpPartInfo.BitmapInfoHeader.biSizeImage > nReadSize then
                begin
                  AppendLen := BmpPartInfo.BitmapInfoHeader.biSizeImage - nReadSize;
                  AppendBuffer := AllocMem(AppendLen);
                end
                else
                begin
                  Result := False;
                  Break;
                end;
              end;
            end;
            sSaveName := AnsiReplaceText(sName, '_', '-') + Format('_%.3d.bmp', [nCount]);
            Inc(nCount);
            if FileExists(sPath + sSaveName) then
              WriteStream := TFileStream.Create(sPath + sSaveName, fmOpenWrite or fmShareDenyWrite)
            else
              WriteStream := TFileStream.Create(sPath + sSaveName, fmCreate);
            WriteStream.Write(BmpPartInfo, SizeOf(TBmpPartInfo));
            WriteStream.Write(Buffer, nReadSize);
            if AppendBuffer <> nil then
            begin
              WriteStream.Write(AppendBuffer^, AppendLen);
              FreeMem(AppendBuffer);
            end;
            WriteStream.Free;
          end;
          if (nReadSize <= 0) or (nReadSize < BMP_PART_SIZE) then
            Break;
        end;
      end;
    finally
      FileStream.Free;
    end;
  end;
end;

begin
  try
    ProcessFile(ParamStr(1));
  except
    on E: Exception do
      Writeln(E.Classname, ': ', E.Message);
  end;

end.
