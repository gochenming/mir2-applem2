unit FrmChangePass;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, bsSkinCtrls, StdCtrls, Mask, bsSkinBoxCtrls, bsSkinData;

type
  TFrameChangePass = class(TFrame)
    DSkinData: TbsSkinData;
    GroupBoxBg: TbsSkinGroupBox;
    GroupBoxMD5: TbsSkinGroupBox;
    bsSkinStdLabel10: TbsSkinStdLabel;
    bsSkinStdLabel4: TbsSkinStdLabel;
    bsSkinStdLabel5: TbsSkinStdLabel;
    EditName: TbsSkinEdit;
    EditQQ: TbsSkinEdit;
    EditBindList: TbsSkinEdit;
    EditOldPassword: TEdit;
    EditPassword: TEdit;
    EditPassword2: TEdit;
    ButtonOK: TbsSkinButton;
    procedure ButtonOKClick(Sender: TObject);
    procedure EditOldPasswordKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    procedure Open();
  end;

implementation

uses
  FrmMain, MD5Unit, EDCode, SCShare, FShare;

{$R *.dfm}

{ TFrameChangePass }

procedure TFrameChangePass.ButtonOKClick(Sender: TObject);
var
  sPassword1, sPassword2: string;
  DefMsg: TDefaultMessage;
begin
  sPassword1 := EditOldPassword.Text;
  sPassword2 := EditPassword.Text;
  if not g_boConnect then begin
    FormMain.DMsg.MessageDlg('与远程服务器连接断开中，正在重试连接，请稍候..！', mtError, [mbYes], 0);
    Exit;
  end;
  if sPassword1 = '' then begin
    FormMain.DMsg.MessageDlg('旧密码不能为空！', mtError, [mbYes], 0);
    EditOldPassword.SetFocus;
    Exit;
  end;
  if sPassword2 = sPassword1 then begin
    FormMain.DMsg.MessageDlg('新密码不能与旧密码相同！', mtError, [mbYes], 0);
    EditPassword2.SetFocus;
    Exit;
  end;
  if sPassword2 = '' then begin
    FormMain.DMsg.MessageDlg('新密码不能为空！', mtError, [mbYes], 0);
    EditPassword.SetFocus;
    Exit;
  end;
  if sPassword2 <> EditPassword2.Text then begin
    FormMain.DMsg.MessageDlg('确认新密码不正常！', mtError, [mbYes], 0);
    EditPassword2.SetFocus;
    Exit;
  end;
  FormMain.Lock(True);
  ButtonOK.Enabled := False;
  EditOldPassword.Enabled := False;
  EditPassword.Enabled := False;
  EditPassword2.Enabled := False;
  FormMain.ShowHint('正在提交密码信息，请稍候...');
  DefMsg := MakeDefaultMsg(CM_TOOLS_CHANGEPASS, 0, 0, 0, 0);
  FormMain.SendSocket(EncodeMessage(DefMsg) + FormMain.RP.EncryptStr(GetMD5Text(sPassword1) + '/' + sPassword2));
end;

procedure TFrameChangePass.EditOldPasswordKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then begin
    ButtonOKClick(ButtonOK);
  end;
end;

procedure TFrameChangePass.Open;
begin
  EditOldPassword.Text := '';
  EditPassword.Text := '';
  EditPassword2.Text := '';
end;

end.
