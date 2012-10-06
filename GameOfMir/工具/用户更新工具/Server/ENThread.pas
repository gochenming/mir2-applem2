unit ENThread;

interface

uses
  Windows, SysUtils, Messages, StrUtils, Classes, Share;

type
  TEncryptSoftType = (es_M2, es_Login);

  pTEncryptSoftInfo = ^TEncryptSoftInfo;
  TEncryptSoftInfo = packed record
    SoftType: TEncryptSoftType;
    nUserID: Integer;
    sGUID: string[50];
    sDownList: string[240];
    sLoginMark: string[16];
  end;

  TEncryptSoft = class(TThread)
  private
    FMainHandle: THandle;
    FCriticalSection: TRTLCriticalSection;
    FENFileList: TList;
    FTempENFileList: TList;
    procedure Run;
    procedure Lock();
    procedure UnLock();
    function EncryptM2Server(EncryptSoftInfo: pTEncryptSoftInfo): Boolean;
    function EncryptLogin(EncryptSoftInfo: pTEncryptSoftInfo): Boolean;
    function RunSoftAndWaitExit(sDir, sFileName, sParamStr: string): Boolean;
  protected
    procedure Execute; override;
  public
    constructor Create(Handle: THandle; CreateSuspended: Boolean);
    destructor Destroy; override;
    function AddEncryptSoft(EncryptSoftInfo: pTEncryptSoftInfo): Boolean;
  end;

var
  EncryptSoft: TEncryptSoft;

implementation

uses
 MyCommon, MD5Unit;
{ TEncryptSoft }

function TEncryptSoft.AddEncryptSoft(EncryptSoftInfo: pTEncryptSoftInfo): Boolean;
begin
  Lock();
  Try
    FENFileList.Add(EncryptSoftInfo);
    Result := True;
  Finally
    UnLock();
  End;
end;

constructor TEncryptSoft.Create(Handle: THandle; CreateSuspended: Boolean);
begin
  inherited Create(CreateSuspended);
  FMainHandle := Handle;
  InitializeCriticalSection(FCriticalSection);
  FENFileList := TList.Create;
  FTempENFileList := TList.Create;
end;

destructor TEncryptSoft.Destroy;
var
  I: Integer;
begin
  DeleteCriticalSection(FCriticalSection);
  for I := 0 to FENFileList.Count - 1 do
    Dispose(pTEncryptSoftInfo(FENFileList[I]));
  FENFileList.Free;
  for I := 0 to FTempENFileList.Count - 1 do
    Dispose(pTEncryptSoftInfo(FTempENFileList[I]));
  FTempENFileList.Free;
  inherited;
end;

function TEncryptSoft.EncryptLogin(EncryptSoftInfo: pTEncryptSoftInfo): Boolean;
var
  FileStream: TFileStream;
  PointList: TStringList;
  dwNamePoint, dwListPoint, dwMarkPoint: LongWord;
  FileVersionInfo: TFileVersionInfo;
  SendData: TCopyDataStruct;
  sSendStr: string;
  sName: string[12];
  nLen: Integer;
begin
  Result := True;
  if FileExists('.\Login\Login.exe') and FileExists('.\Login\Login.exe.txt') then begin
    FillChar(FileVersionInfo, SizeOf(FileVersionInfo), #0);
    if not GetFileVersion('.\Login\Login.exe', @FileVersionInfo) then Exit;
    PointList := TStringList.Create;
    Try
      PointList.LoadFromFile('.\Login\Login.exe.txt');
      if PointList.Count > 2 then begin
        dwNamePoint := StrToIntDef(PointList[0], 0);
        dwListPoint := StrToIntDef(PointList[1], 0);
        dwMarkPoint := StrToIntDef(PointList[2], 0);
      end else Exit;
    Finally
      PointList.Free;
    End;
    DeleteFile('.\Login\Login.bak.exe');
    CopyFile('.\Login\Login.exe', '.\Login\Login.bak.exe', False);
    sName := EncryptSoftInfo.sGUID;
    
    FileStream := TFileStream.Create('.\Login\Login.bak.exe', fmOpenWrite or fmShareDenyWrite);
    Try
      FileStream.Seek(dwNamePoint, soBeginning);
      nLen := Length(sName);
      FileStream.Write(nLen, SizeOf(nLen));
      FileStream.Write(sName[1], nLen);

      FileStream.Seek(dwListPoint, soBeginning);
      nLen := Length(EncryptSoftInfo.sDownList);
      FileStream.Write(nLen, SizeOf(nLen));
      FileStream.Write(EncryptSoftInfo.sDownList[1], nLen);

      FileStream.Seek(dwMarkPoint, soBeginning);
      nLen := Length(EncryptSoftInfo.sLoginMark);
      FileStream.Write(nLen, SizeOf(nLen));
      FileStream.Write(EncryptSoftInfo.sLoginMark[1], nLen);
    Finally
      FileStream.Free;
    End;
    RunSoftAndWaitExit(g_CurrentDir + 'UPX\', 'UPX.exe', g_CurrentDir + 'Login\Login.bak.exe');
    Sleep(1000);
    CreateDir(g_CurrentDir + LOGINFILESDIR + '\' + IntToStr(EncryptSoftInfo.nUserID) + '\');
    CreateDir(g_CurrentDir + LOGINFILESDIR + '\' + IntToStr(EncryptSoftInfo.nUserID) + '\' + sName + '\');
    CopyFile(PChar(g_CurrentDir + 'Login\Login.bak.exe'),
      PChar(g_CurrentDir + LOGINFILESDIR + '\' + IntToStr(EncryptSoftInfo.nUserID) + '\' + sName + '\' + FileVersionInfo.sVersion + '.exe'), False);
    DeleteFile(g_CurrentDir + 'Login\Login.bak.exe');

    sSendStr := FileToMD5Text(g_CurrentDir + LOGINFILESDIR + '\' + IntToStr(EncryptSoftInfo.nUserID) + '\' + sName + '\' + FileVersionInfo.sVersion + '.exe');
    sSendStr := sSendStr + '/' + FileVersionInfo.sVersion + '/' + IntToStr(EncryptSoftInfo.nUserID) + '/' + sName;
    SendData.cbData := Length(sSendStr) + 1;
    GetMem(SendData.lpData, SendData.cbData);
    Move(sSendStr[1], SendData.lpData^, SendData.cbData);
    SendMessage(FMainHandle, WM_COPYDATA, MakeLong(0, 1001), Cardinal(@SendData));
    FreeMem(SendData.lpData);
  end;
end;

function TEncryptSoft.EncryptM2Server(EncryptSoftInfo: pTEncryptSoftInfo): Boolean;
var
  FileStream: TFileStream;
  PointList: TStringList;
  dwPoint: LongWord;
  FileVersionInfo: TFileVersionInfo;
  SendData: TCopyDataStruct;
  sSendStr: string;
begin
  Result := True;
  if FileExists('.\M2Server\M2Server.exe') and FileExists('.\M2Server\M2Server.exe.txt') and FileExists('.\M2Server\M2Server.map') then begin
    FillChar(FileVersionInfo, SizeOf(FileVersionInfo), #0);
    if not GetFileVersion('.\M2Server\M2Server.exe', @FileVersionInfo) then Exit;
    PointList := TStringList.Create;
    Try
      PointList.LoadFromFile('.\M2Server\M2Server.exe.txt');
      if PointList.Count > 0 then begin
        dwPoint := StrToIntDef(PointList[0], 0);
      end else Exit;
    Finally
      PointList.Free;
    End;
    if dwPoint = 0 then Exit;
    FileStream := TFileStream.Create('.\M2Server\M2Server.exe', fmOpenWrite or fmShareDenyWrite);
    Try
      FileStream.Seek(dwPoint, soBeginning);
      FileStream.Write(EncryptSoftInfo.sGUID[1], Length(EncryptSoftInfo.sGUID));
    Finally
      FileStream.Free;
    End;
    DeleteFile(g_CurrentDir + 'M2Server\M2Server.exe.new');
    RunSoftAndWaitExit(g_CurrentDir + 'ASProtect\', 'ASProtect.exe', ' -process ' + g_CurrentDir + 'ASProtect\M2Server.exe.aspr2');

    RunSoftAndWaitExit(g_CurrentDir + 'ENProject\', 'ENProject.exe', g_CurrentDir + 'M2Server\M2Server.exe.new');
    Sleep(1000);
    CreateDir(g_CurrentDir + M2FILESDIR + '\' + IntToStr(EncryptSoftInfo.nUserID) + '\');
    CopyFile(PChar(g_CurrentDir + 'M2Server\M2Server.exe.new'),
      PChar(g_CurrentDir + M2FILESDIR + '\' + IntToStr(EncryptSoftInfo.nUserID) + '\' + FileVersionInfo.sVersion + '.exe'), False);
    DeleteFile(g_CurrentDir + 'M2Server\M2Server.exe.new');

    sSendStr := FileToMD5Text(g_CurrentDir + M2FILESDIR + '\' + IntToStr(EncryptSoftInfo.nUserID) + '\' + FileVersionInfo.sVersion + '.exe');
    sSendStr := sSendStr + '/' + FileVersionInfo.sVersion + '/' + IntToStr(EncryptSoftInfo.nUserID);
    SendData.cbData := Length(sSendStr) + 1;
    GetMem(SendData.lpData, SendData.cbData);
    Move(sSendStr[1], SendData.lpData^, SendData.cbData);
    SendMessage(FMainHandle, WM_COPYDATA, MakeLong(0, 1000), Cardinal(@SendData));
    FreeMem(SendData.lpData);
  end;
end;


procedure TEncryptSoft.Execute;
begin
  while not Terminated do begin
    Try
      Run;
      Sleep(10);
    Except
    End;
  end;
end;

procedure TEncryptSoft.Lock;
begin
  EnterCriticalSection(FCriticalSection);
end;

procedure TEncryptSoft.Run;
var
  TempList: TList;
  EncryptSoftInfo: pTEncryptSoftInfo;
  I: Integer;
begin
  Lock();
  Try
    TempList := FTempENFileList;
    FTempENFileList := FENFileList;
    FENFileList := TempList;
    FENFileList.Clear;
  Finally
    UnLock();
  End;
  for I := 0 to FTempENFileList.Count - 1 do begin
    EncryptSoftInfo := FTempENFileList[I];
    Try
      case EncryptSoftInfo.SoftType of
        es_M2: EncryptM2Server(EncryptSoftInfo);
        es_Login: EncryptLogin(EncryptSoftInfo);
      end;
    Except
    End;
    Dispose(EncryptSoftInfo);
  end;
  FTempENFileList.Clear;
end;

function TEncryptSoft.RunSoftAndWaitExit(sDir, sFileName, sParamStr: string): Boolean;
var
  StartupInfo: TStartupInfo;
  sCommandLine: string;
  ProcessInfo: TProcessInformation;
  ProcessHandle: THandle;
  dwExitCode: LongWord;
  nCount: Integer;
begin
  Result := False;
  FillChar(StartupInfo, SizeOf(TStartupInfo), #0);
  GetStartupInfo(StartupInfo);
  StartupInfo.wShowWindow := SW_HIDE;
  sCommandLine := sDir + sFileName + ' ' + sParamStr;
  if CreateProcess(nil, PChar(sCommandLine), nil, nil, True, 0, nil, PChar(sDir), StartupInfo, ProcessInfo) then begin
    ProcessHandle := OpenProcess(PROCESS_ALL_ACCESS, False, ProcessInfo.dwProcessId);
    GetExitCodeProcess(ProcessHandle, dwExitCode);
    nCount := 0;
    while dwExitCode = STILL_ACTIVE do begin
      Sleep(100);
      GetExitCodeProcess(ProcessHandle, dwExitCode);
      if nCount > 1000 then Exit;
      Inc(nCount);
    end;
    CloseHandle(ProcessHandle);
    Sleep(1000);
    Result := True;
  end;
end;

procedure TEncryptSoft.UnLock;
begin
  LeaveCriticalSection(FCriticalSection);
end;

end.
