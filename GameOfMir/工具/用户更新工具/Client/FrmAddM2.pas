unit FrmAddM2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, bsSkinData, bsSkinCtrls, StdCtrls, Mask, bsSkinBoxCtrls;

type
  TFrameAddM2 = class(TFrame)
    DSkinData: TbsSkinData;
    GroupBoxBg: TbsSkinGroupBox;
    GroupBoxMD5: TbsSkinGroupBox;
    bsSkinStdLabel10: TbsSkinStdLabel;
    bsSkinStdLabel4: TbsSkinStdLabel;
    EditName: TbsSkinEdit;
    bsSkinGroupBox1: TbsSkinGroupBox;
    LabelUpLog: TbsSkinTextLabel;
    EditBindCount: TbsSkinSpinEdit;
    ButtonAdd: TbsSkinButton;
    procedure ButtonAddClick(Sender: TObject);
    procedure EditNameKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    procedure Open();
  end;

implementation

uses
  FrmMain, EDCode, SCShare, FShare;
  
{$R *.dfm}

{ TFrameAddM2 }

procedure TFrameAddM2.ButtonAddClick(Sender: TObject);
var
  sName: string;
  sShowMsg: string;
  DefMsg: TDefaultMessage;
begin
  sName := LowerCase(Trim(EditName.Text));
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
  sShowMsg := '是否确定增加帐号：' + sName + ' 绑定次数：' + IntToStr(Trunc(EditBindCount.Value)) + #13#10;
  sShowMsg := sShowMsg + '成功增加后将从您的帐户扣除￥' + IntToStr(g_nAgentM2 * Trunc(EditBindCount.Value));
  if FormMain.DMsg.MessageDlg(sShowMsg, mtConfirmation, [mbYes, mbNo], 0) = mrYes then begin
    FormMain.Lock(True);
    EditName.Enabled := False;
    EditBindCount.Enabled := False;
    ButtonAdd.Enabled := False;
    FormMain.ShowHint('正在提交注册信息，请稍候...');
    DefMsg := MakeDefaultMsg(CM_TOOLS_REGM2, Trunc(EditBindCount.Value), 0, 0, 0);
    FormMain.SendSocket(EncodeMessage(DefMsg) + FormMain.RP.EncryptStr(sName));
  end;
end;

procedure TFrameAddM2.EditNameKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then begin
    ButtonAddClick(ButtonAdd);
  end;
end;

procedure TFrameAddM2.Open;
begin
  EditName.Text := '';
  EditBindCount.Value := 1;
end;

end.
