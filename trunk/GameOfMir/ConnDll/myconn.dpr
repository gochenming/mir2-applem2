library myconn;

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
  Windows,
  MD5Unit in '..\Common\MD5Unit.pas';

{$R *.res}

function GetConnectPassword(lpFilename: PChar; nSize: Integer): Boolean; stdcall;
var
  ModuleName : String;
begin
  Result := False;
  Try
    if nSize > 32 then begin
      SetLength(ModuleName, 200);
      GetModuleFileName(HInstance, PChar(ModuleName), Length(ModuleName));
      ModuleName := FileToMD5Text(PChar(ModuleName));
      Move(ModuleName[1], lpFilename^, Length(ModuleName) + 1);
      Result := True;
    end;
  Except
  End;
end;

function GetConnectPort(): Integer; stdcall;
begin
  Result := 17000;
end;

exports
  GetConnectPort, GetConnectPassword;
begin
end.
