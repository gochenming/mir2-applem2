library RegDll;

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
  DllMain in 'DllMain.pas',
  MD5Unit in '..\..\Common\MD5Unit.pas',
  EDcode in '..\用户更新工具\Common\EDcode.pas',
  SCShare in '..\用户更新工具\Common\SCShare.pas',
  GeneralCommon in '..\..\Common\GeneralCommon.pas',
  HUtil32 in '..\用户更新工具\Common\HUtil32.pas',
  QuestMain in 'QuestMain.pas' {FormQuest},
  MyCommon in '..\..\MyCommon\MyCommon.pas',
  DES in '..\..\Common\DES.pas';

{$R *.res}

procedure LoadList(AppHandle, Handle: THandle; nProt: Integer; MsgProc: TMsgProc; CheckOK: TCheckOKProc; boFreeVar: Boolean); stdcall;
begin
  ApplicationHandle := AppHandle;
  MainHandle := Handle;
  OutMessage := MsgProc;
  CheckOKProc := CheckOK;
  RunGateProt := nProt;
  FreeVar := boFreeVar;
  if boFreeVar then REGClass.SetPublicID('201106291220018053');
  REGClass.BeginCheck;
end;

function Common(): PChar; stdcall;
begin
  Result := REGClass.GetDEFPassword;
end;

function Quest(): PChar; stdcall;
begin
  Result := REGClass.GetServerMark;
end;

function Address():PChar; stdcall;
begin
  Result := REGClass.GetExitUrl;
end;

function TextList:PChar; stdcall;
begin
  Result := REGClass.GetGameMsgList;
end;

function LogoList:PChar; stdcall;
begin
  Result := REGClass.GetFrameUrl;
end;

procedure GetText(InBuffer: PChar; OutBuffer: PChar; OutLength: Integer); stdcall;
begin
  DESDecryText(InBuffer, OutBuffer, OutLength);
end;

exports
  LoadList, Common, Quest, Address, TextList, LogoList, GetText;
begin
end.
