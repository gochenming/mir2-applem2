unit FrmDownLogin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, bsSkinCtrls, StdCtrls, bsSkinData, Mask, bsSkinBoxCtrls;

type
  TFrameDownLogin = class(TFrame)
    DSkinData: TbsSkinData;
    GroupBoxBg: TbsSkinGroupBox;
    LabelUpLog: TbsSkinTextLabel;
    GroupBoxMD5: TbsSkinGroupBox;
    bsSkinStdLabel10: TbsSkinStdLabel;
    bsSkinStdLabel4: TbsSkinStdLabel;
    bsSkinStdLabel5: TbsSkinStdLabel;
    LabelName: TbsSkinStdLabel;
    LabelUpVar: TbsSkinStdLabel;
    LabelUpTime: TbsSkinStdLabel;
    EditName: TbsSkinEdit;
    bsSkinStdLabel1: TbsSkinStdLabel;
    bsSkinStdLabel2: TbsSkinStdLabel;
    EditSkinFile: TbsSkinEdit;
    ButtonAdd: TbsSkinButton;
    procedure EditSkinFileButtonClick(Sender: TObject);
    procedure ButtonAddClick(Sender: TObject);
    procedure EditNameChange(Sender: TObject);
    procedure EditSkinFileChange(Sender: TObject);
  private
    { Private declarations }
  public
    procedure Open();
  end;

implementation

uses
  FrmMain, FShare, SCShare, EDCode, MD5Unit;

{$R *.dfm}

{ TFrameDownLogin }

procedure TFrameDownLogin.ButtonAddClick(Sender: TObject);
var
  sFileMD5: string;
  DefMsg: TDefaultMessage;
begin
  if not g_boConnect then begin
    FormMain.DMsg.MessageDlg('与远程服务器连接断开中，正在重试连接，请稍候！', mtError, [mbYes], 0);
    Exit;
  end;
  FormMain.m_GameName := Trim(EditName.Text);
  if FormMain.m_GameName = '' then begin
    FormMain.DMsg.MessageDlg('游戏名称不能为空！', mtError, [mbYes], 0);
    Exit;
  end;
  if not FileExists(EditSkinFile.Text) then begin
    FormMain.DMsg.MessageDlg('皮肤文件不存在！', mtError, [mbYes], 0);
    Exit;
  end;

  FormMain.m_SkinName := Trim(EditSkinFile.Text);
  FormMain.Lock(True);
  ButtonAdd.Enabled := False;
  EditName.Enabled := False;
  EditSkinFile.Enabled := False;
  FormMain.ShowHint('正在准备下载' + FormMain.m_GameName + '.exe，请稍候...');
  sFileMD5 := FileToMD5Text(g_CurrentDir + DOWNDIRNAME + '\' + FormMain.m_GameName);
  DefMsg := MakeDefaultMsg(CM_DOWNLOGINEXE, 0, 0, 0, 0);
  FormMain.SendSocket(EncodeMessage(DefMsg) + EncodeString(FormMain.m_GameName + '/' + sFileMD5));
end;

procedure TFrameDownLogin.EditNameChange(Sender: TObject);
begin
  g_Config.WriteString('Down', 'ServerName', EditName.Text);
end;

procedure TFrameDownLogin.EditSkinFileButtonClick(Sender: TObject);
begin
  FormMain.OpenDialog.Filter := '361M2专用皮肤文件 (*.361Skin)|*.361Skin';
  if FormMain.OpenDialog.Execute then begin
    EditSkinFile.Text := FormMain.OpenDialog.FileName;
  end;
end;

procedure TFrameDownLogin.EditSkinFileChange(Sender: TObject);
begin
  g_Config.WriteString('Down', 'SkinFile', EditSkinFile.Text);
end;

procedure TFrameDownLogin.Open;
begin
  //
end;

end.
