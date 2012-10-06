unit DLLMain;

interface
uses
  SysUtils, Classes, Graphics, Windows, ExtCtrls, ShellAPI, RSA;

Type

  TEncrypt = class(TObject)
  private
    FTimer: TTimer;
    FFileName: string;
    FRSA: TRSA;
    function CheckIconFail(): Boolean;
    function CheckFileFail(): Boolean;
  public
    constructor Create;
    destructor Destroy; override;
    procedure OnTimer(Sender: TObject);
  end;

var
  Encrypt: TEncrypt;

implementation

uses
  MD5Unit, Share;

function TEncrypt.CheckFileFail: Boolean;
var
  FileStream: TFileStream;
  sFileMD5: string;
  sFileRSA: string;
  ENProjectInfo: TENProjectInfo;
  ChrBuffer: array[Low(TENProjectInfo)..High(TENProjectInfo)] of Char;
  I: Integer;
begin
  Result := True;
  Try
    if FileExists(FFileName) then begin
      sFileMD5 := MD5Print(GetMD5OfFile(FFileName, nil, - SizeOf(ENProjectInfo)));
      FileStream := TFileStream.Create(FFileName, fmOpenRead or fmShareDenyNone);
      Try
        sFileMD5 := GetMD5Text(sFileMD5 + IntToStr(FileStream.Size - SizeOf(ENProjectInfo)));
        FileStream.Seek(-SizeOf(TENProjectInfo), soEnd);
        if FileStream.Read(ENProjectInfo[0], SizeOf(ENProjectInfo)) = SizeOf(ENProjectInfo) then begin
          FillChar(ChrBuffer, SizeOf(ChrBuffer), #0);
          for I := Low(ENProjectInfo) to High(ENProjectInfo) do begin
            ChrBuffer[I] := Char(ENProjectInfo[I] XOR XORPARAM);
          end;
          sFileRSA := ChrBuffer;
          sFileRSA := Trim(sFileRSA);
          sFileRSA := FRSA.DecryptStr(sFileRSA);
          if sFileMD5 = sFileRSA then
            Result := False;
        end;
      Finally
        FileStream.Free;
      End;
    end;
  Except
    Result := True;
  End;
end;

function TEncrypt.CheckIconFail: Boolean;
var
  nCount: Integer;
  I: Integer;
  ico: TIcon;
  MemoryStream: TMemoryStream;
  MD5Str: string;
begin
  Result := True;
  Try
    if FileExists(FFileName) then begin
      nCount := ExtractIcon(HInstance, PChar(FFileName), HICON(-1));
      ico := TIcon.Create;
      MemoryStream := TMemoryStream.Create;
      for I := 0 to nCount - 1 do begin
        ico.Handle := ExtractIcon(HInstance, PChar(FFileName), i);
        ico.SaveToStream(MemoryStream);

      end;
      //MessageBox(0, PChar(GetMD5TextByBuffer(MemoryStream.Memory, MemoryStream.Size)), 'aa', 0);
      if MemoryStream.Size > 0 then begin
        MD5Str := GetMD5TextByBuffer(MemoryStream.Memory, MemoryStream.Size);
        if (MD5Str = '2034328fe48ba803aedc5f33d7577a9f') or (MD5Str = '4914777b7669146856a98d4ef154e15b') or
          (MD5Str = '31acace80eaccc5a7c3babcc777ad4c1') then
          Result := False;
        {MemoryStream.Clear;
        MemoryStream.Write(MD5Str[1], Length(MD5Str));
        MemoryStream.SaveToFile('D:\md5.txt');  }
        //2034328fe48ba803aedc5f33d7577a9f   etm2 ico
        //4914777b7669146856a98d4ef154e15b   mir2k ico
      end;
      MemoryStream.Free;
      ico.Free;
    end;
  Except
    Result := True;
  End;
end;

constructor TEncrypt.Create;
var
  Buffer: array[0..MAX_PATH] of Char;
begin
  inherited;
  Randomize;
  FRSA := TRSA.Create(nil);
  FRSA.CommonalityKey := '1036635523419446130773';
  FRSA.CommonalityMode := '177737455755753069016434453859';
  FRSA.Server := False;
  FTimer := TTimer.Create(nil);
  FTimer.Interval := 3000 + Random(10000);
  FTimer.OnTimer := OnTimer;
  FillChar(Buffer, SizeOf(Buffer), #0);
  GetModuleFileName(0, @Buffer[0], MAX_PATH);
  FFileName := Buffer;
  FTimer.Enabled := CheckIconFail or CheckFileFail;
  //MessageBox(0, PChar(FFileName), 'aa', 0);
end;

destructor TEncrypt.Destroy;
begin
  FRSA.Free;
  FTimer.Free;
  inherited;
end;

procedure TEncrypt.OnTimer(Sender: TObject);
begin
  Windows.ExitProcess(0);
end;

initialization
  Encrypt := TEncrypt.Create;

finalization
  Encrypt.Free;


end.
