unit TestMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, MyCommon;

type
  TForm12 = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TCheckOKProc = procedure(); stdcall;
  TGetInfo = function(): PChar; stdcall;
  TMsgProc = procedure(Msg: PChar; nMode: Integer); stdcall;
  TLoadList = procedure(AppHandle, Handle: THandle; nProt: Integer; MsgProc: TMsgProc; CheckOK: TCheckOKProc); stdcall;


var
  Form12: TForm12;
  DLLHandle: THandle;
  LoadList: TLoadList;
  GCommon: TGetInfo;
  GQuest: TGetInfo;

procedure MainOutMessage(Msg: PChar; nMode: Integer); stdcall;

implementation

{$R *.dfm}

procedure CheckOKProc(); stdcall;
begin
  ShowMessage('[注册成功]：DEF=' + GCommon + '，Mark=' + GQuest);
end;

procedure MainOutMessage(Msg: PChar; nMode: Integer); stdcall;
begin
  Form12.Memo1.Lines.Add(DateTimeToStr(Now) + ' ' + Msg);
end;

procedure TForm12.Button1Click(Sender: TObject);
begin

  LoadList := GetProcAddress(DLLHandle, 'LoadList');
  GCommon := GetProcAddress(DLLHandle, 'Common');
  GQuest := GetProcAddress(DLLHandle, 'Quest');
  LoadList(Application.Handle, Handle, 7000, MainOutMessage, CheckOKProc);
end;

//取CPU序号

function kbGetCpuID(): string;
type
  TCPUID = array[1..4] of Longint;
var
  CPUIDinfo: TCPUID;
  function IsCPUID_Available: Boolean;
  asm
      PUSHFD       {direct access to flags no possible, only via stack}
      POP     EAX     {flags to EAX}
      MOV     EDX,EAX   {save current flags}
      XOR     EAX,$200000; {not ID bit}
      PUSH    EAX     {onto stack}
      POPFD        {from stack to flags, with not ID bit}
      PUSHFD       {back to stack}
      POP     EAX     {get back to EAX}
      XOR     EAX,EDX   {check if ID bit affected}
      JZ      @exit    {no, CPUID not availavle}
      MOV     AL,True   {Result=True}
      @exit:
  end;
  function GetCPUIDSN: TCPUID; assembler;
  asm
      PUSH    EBX         {Save affected register}
      PUSH    EDI
      MOV     EDI,EAX     {@Resukt}
      MOV     EAX,1
      DW      $A20F       {CPUID Command}
      STOSD             {CPUID[1]}
      MOV     EAX,EBX
      STOSD               {CPUID[2]}
      MOV     EAX,ECX
      STOSD               {CPUID[3]}
      MOV     EAX,EDX
      STOSD               {CPUID[4]}
      POP     EDI     {Restore registers}
      POP     EBX
  end;
begin
  if IsCPUID_Available then begin
    CPUIDinfo := GetCPUIDSN;
  end
  else begin //早期cpu无ID
    CPUIDinfo[1] := 0136;
    CPUIDinfo[4] := 66263155;
    Result := '';
  end;
  result := IntToHex((CPUIDinfo[1] + CPUIDinfo[2] + CPUIDinfo[3] + CPUIDinfo[4]), 8);
end;

procedure TForm12.Button2Click(Sender: TObject);
var
  nSize: DWORD;
  NameBuffer: array[0..MAX_PATH - 1] of Char;
begin
  //Memo1.Lines.Add(kbGetCpuID());
  //Memo1.Lines.Add(GetIdeSerialNumber);
  nSize := MAX_PATH - 1;
  GetComputerName(@NameBuffer, nSize);
  NameBuffer[nSize] := #0;
  Memo1.Lines.Add(Strpas(NameBuffer));
end;

procedure TForm12.FormCreate(Sender: TObject);
begin
  DLLHandle := LoadLibrary('Regdll.dll');
end;

procedure TForm12.FormDestroy(Sender: TObject);
begin
  FreeLibrary(DllHandle);
end;

end.

