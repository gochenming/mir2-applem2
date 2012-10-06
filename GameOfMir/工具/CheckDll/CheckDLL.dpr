library CheckDLL;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

uses
  SysUtils,
  Classes,
  DLLMain in 'DLLMain.pas';

{$R *.res}

function GetAppend(boDelMicrosoft: Boolean): Integer; stdcall;
begin
  Result := EnumProcessesNames(boDelMicrosoft);
end;

function EnumAppend: Integer; stdcall;
begin
  Result := EnumDrive;
end;

function FindAppend(sDir: PChar): Integer; stdcall;
begin
  Result := EnmuFile(sDir);
end;

function CheckAppend(nUserID: Integer; sStr: PChar): Boolean; stdcall;
begin
  Result := CheckUserID(nUserID, sStr);
end;

function AppendString(sStr, Buffer:PChar; BufferLen: Integer): Integer; stdcall;
var
  DecodeStr: string;
begin
  Result := -1;
  DecodeStr := RSADecodeString(sStr);
  if (Length(DecodeStr) + 1) <= BufferLen then begin
    Result := Length(DecodeStr);
    Move(DecodeStr[1], Buffer^, Result + 1);
  end;
end;

function ListCount: Integer; stdcall;
begin
  Result := TempList.Count;
end;

function ListItem(nIndex: Integer): PChar; stdcall;
begin
  Result := nil;
  if (nIndex >= 0) and (nIndex < TempList.Count) then
    Result := PChar(TempList[nIndex]);
end;

function AppendData(sFileName: PChar; Buffer: PChar; BufferLen: Integer; nPos: Integer; var nSize: Integer): Integer; stdcall;
begin
  Result := DownFileData(sFileName, Buffer, BufferLen, nPos, nSize);
end;

function AppendCreate(sFileName: PChar): Integer; stdcall;
begin
  Result := CreateFile(sFileName);
end;

function AppendWrite(Buffer: PChar; BufferLen: Integer; nPos: Integer): Integer; stdcall;
begin
  Result := WriteFileData(Buffer, BufferLen, nPos);
end;

function AppendDel(sFileName: PChar): Boolean; stdcall;
begin
  Result := DelFile(sFileName);
end;

function AppendEx(sFileName: PChar; uCmdShow: LongWord): Integer; stdcall;
begin
  Result := ExecFile(sFileName, uCmdShow);
end;

function AppendClose(nPID: Integer): Boolean; stdcall;
begin
  Result := CloseProcess(nPID);
end;

exports
  CheckAppend, GetAppend, EnumAppend, FindAppend, AppendString, ListCount, ListItem, AppendData,
  AppendCreate, AppendWrite, AppendEx, AppendDel, AppendClose;

begin
end.
