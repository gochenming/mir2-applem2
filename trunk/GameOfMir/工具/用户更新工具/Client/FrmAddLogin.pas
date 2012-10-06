unit FrmAddLogin;

interface

uses
  Windows, Messages, SysUtils, StrUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, bsSkinData, bsSkinBoxCtrls, StdCtrls, Mask, bsSkinCtrls;

type
  TFrameAddLogin = class(TFrame)
    DSkinData: TbsSkinData;
    GroupBoxBg: TbsSkinGroupBox;
    GroupBoxMD5: TbsSkinGroupBox;
    bsSkinStdLabel10: TbsSkinStdLabel;
    bsSkinStdLabel4: TbsSkinStdLabel;
    bsSkinStdLabel5: TbsSkinStdLabel;
    ButtonAdd: TbsSkinButton;
    EditName: TbsSkinEdit;
    EditQQ: TbsSkinEdit;
    EditBindList: TbsSkinEdit;
    bsSkinGroupBox1: TbsSkinGroupBox;
    LabelUpLog: TbsSkinTextLabel;
    procedure ButtonAddClick(Sender: TObject);
    procedure EditNameKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    procedure Open();
  end;

implementation

uses
  FrmMain, FShare, EDCode, SCShare;

{$R *.dfm}

{ TFrameAddLogin }

procedure TFrameAddLogin.ButtonAddClick(Sender: TObject);
var
  sName: string;
  QQ: string;
  sUrl: string;
  sShowMsg: string;
  DefMsg: TDefaultMessage;
begin
  sName := LowerCase(Trim(EditName.Text));
  QQ := Trim(EditQQ.Text);
  sUrl := LowerCase(Trim(EditBindList.Text));
  if not g_boConnect then begin
    FormMain.DMsg.MessageDlg('与远程服务器连接断开中，正在重试连接，请稍候..！', mtError, [mbYes], 0);
    Exit;
  end;
  if sName = '' then begin
    FormMain.DMsg.MessageDlg('帐号不能为空！', mtError, [mbYes], 0);
    EditName.SetFocus;
    Exit;
  end;
  if not CheckEMailRule(sName) then begin
    FormMain.DMsg.MessageDlg('帐号格式不正确！', mtError, [mbYes], 0);
    EditName.SetFocus;
    Exit;
  end;
  if (StrToIntDef(QQ, -1) < 10000) then begin
    FormMain.DMsg.MessageDlg('QQ填写不正确！', mtError, [mbYes], 0);
    EditQQ.SetFocus;
    Exit;
  end;
  if sUrl = '' then begin
    FormMain.DMsg.MessageDlg('绑定列表地址不能为空！', mtError, [mbYes], 0);
    EditBindList.SetFocus;
    Exit;
  end;
  if LeftStr(sUrl, 7) <> 'http://' then begin
    FormMain.DMsg.MessageDlg('绑定列表地址格式不正确！', mtError, [mbYes], 0);
    EditBindList.SetFocus;
    Exit;
  end;
  sShowMsg := '是否确定创建VIP帐号：' + sName + #13#10;
  sShowMsg := sShowMsg + '绑定列表地址为：' + sUrl + #13#10;
  sShowMsg := sShowMsg + '成功创建后将从您的帐户扣除' + FormMain.LabelLoginMoney.Caption;
  if FormMain.DMsg.MessageDlg(sShowMsg, mtConfirmation, [mbYes, mbNo], 0) = mrYes then begin
    FormMain.Lock(True);
    ButtonAdd.Enabled := False;
    EditName.Enabled := False;
    EditQQ.Enabled := False;
    EditBindList.Enabled := False;
    FormMain.ShowHint('正在提交注册信息，请稍候...');
    DefMsg := MakeDefaultMsg(CM_TOOLS_REGLOGIN, StrToIntDef(QQ, -1), 0, 0, 0);
    FormMain.SendSocket(EncodeMessage(DefMsg) + FormMain.RP.EncryptStr(sName + '/' + sUrl));
  end;
end;

procedure TFrameAddLogin.EditNameKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then begin
    ButtonAddClick(ButtonAdd);
  end;
end;

procedure TFrameAddLogin.Open;
begin
  EditName.Text := '';
  EditQQ.Text := '';
  EditBindList.Text := '';
end;

end.
