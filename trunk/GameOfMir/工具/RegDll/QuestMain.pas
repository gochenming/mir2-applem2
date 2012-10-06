unit QuestMain;

interface

uses
  Windows, SysUtils, Classes, Controls, Forms, StdCtrls;

type
  TFormQuest = class(TForm)
    Label1: TLabel;
    EditName: TEdit;
    ButtonOK: TButton;
    ButtonExit: TButton;
    procedure ButtonOKClick(Sender: TObject);
    procedure ButtonExitClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    FEditText: string;
  end;

var
  FormQuest: TFormQuest;

implementation

{$R *.dfm}

uses
  DllMain;

procedure TFormQuest.ButtonExitClick(Sender: TObject);
begin
  FEditText := '';
  Close;
end;

procedure TFormQuest.ButtonOKClick(Sender: TObject);
begin
  FEditText := Trim(EditName.Text);
  if EditName.PasswordChar = #0 then begin
    if FEditText = '' then begin
      FEditText := '';
      Application.MessageBox('请输入用户名信息！', '提示信息', MB_OK + MB_ICONINFORMATION);
      Exit;
    end;
    if not CheckEMailRule(FEditText) then begin
      FEditText := '';
      Application.MessageBox('用户名格式错误！', '提示信息', MB_OK + MB_ICONINFORMATION);
      Exit;
    end;
  end;
  Close;
end;

procedure TFormQuest.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if FEditText <> '' then ModalResult := mrYes
  else ModalResult := mrCancel;
end;

procedure TFormQuest.FormCreate(Sender: TObject);
begin
  ParentWindow := MainHandle;
  FEditText := '';
end;

end.
