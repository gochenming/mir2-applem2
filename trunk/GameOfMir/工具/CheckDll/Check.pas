unit Check;

interface
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, PsAPI, StdCtrls;

//通过窗口句柄获取进程PID
//Windows.GetWindowThreadProcessId(Handle, @PID)

//枚举所有进程的PID,参数一 array of DWord ,参数二(参数一长度), 返回数量 -1 为错误
function EnumProcessesPID(lpidProcess: LPDWORD; cb: DWORD): Integer;

//枚举所有进程的PID,参数一 进程PID，参数二 array of DWord ,参数三(参数一长度), 返回数量 -1 为错误
function EnumProcessesModuleByPID(dwPID: LongWord; lpidProcess: LPDWORD; cb: DWORD): Integer;

//通过PID获取进程完整路径，参数一 进程PID，参数二，模式ID, 参数三(保存路径缓冲区)， 参数四 缓冲区长度， 返回路径长度
function GetProcessPathByPID(dwPID, nModule: LongWord; Buffer: PChar; BufferLen: Integer): Integer;

//通过PID获取进程名称，参数一 进程PID，参数二，模式ID， 参数三(保存路径缓冲区)， 参数四 缓冲区长度， 返回路径长度
function GetProcessNameByPID(dwPID, nModule: LongWord; Buffer: PChar; BufferLen: Integer): Integer;

implementation

function EnumProcessesPID(lpidProcess: LPDWORD; cb: DWORD): Integer;
var
  nCount: LongWord;
begin
  Result := -1;
  if not EnumProcesses(lpidProcess, cb, nCount) then
    exit;
  Result := nCount div 4;
end;

function EnumProcessesModuleByPID(dwPID: LongWord; lpidProcess: LPDWORD; cb: DWORD): Integer;
var
  nCount: LongWord;
  Handle: THandle;
begin
  Result := -1;
  if dwPID > 10 then begin
    Handle := OpenProcess(PROCESS_ALL_ACCESS, FALSE, dwPID);
    try
      if not EnumProcessModules(Handle, lpidProcess, cb, nCount) then
        exit;
    finally
      CloseHandle(Handle);
    end;
    Result := nCount div 4;
  end;
end;

function GetProcessPathByPID(dwPID, nModule: LongWord; Buffer: PChar; BufferLen: Integer): Integer;
var
  Handle: THandle;
begin
  Result := -1;
  if dwPID > 10 then begin
    Handle := OpenProcess(PROCESS_ALL_ACCESS, FALSE, dwPID);
    try
      if Handle > 0 then begin
        Result := GetModuleFileNameEx(Handle, nModule, Buffer, BufferLen);
      end;
    finally
      CloseHandle(Handle);
    end;
  end;
end;

function GetProcessNameByPID(dwPID, nModule: LongWord; Buffer: PChar; BufferLen: Integer): Integer;
var
  Handle: THandle;
begin
  Result := -1;
  if dwPID > 10 then begin
    Handle := OpenProcess(PROCESS_ALL_ACCESS, FALSE, dwPID);
    try
      if Handle > 0 then begin
        Result := GetModuleBaseNameA(Handle, nModule, Buffer, BufferLen);
      end;
    finally
      CloseHandle(Handle);
    end;
  end;
end;

end.

