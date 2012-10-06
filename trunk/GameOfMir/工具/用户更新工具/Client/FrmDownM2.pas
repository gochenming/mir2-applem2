unit FrmDownM2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, bsSkinData, bsSkinCtrls, StdCtrls;

type
  TFrameDownM2 = class(TFrame)
    DSkinData: TbsSkinData;
    GroupBoxBg: TbsSkinGroupBox;
    GroupBoxMD5: TbsSkinGroupBox;
    bsSkinStdLabel10: TbsSkinStdLabel;
    bsSkinStdLabel4: TbsSkinStdLabel;
    bsSkinStdLabel5: TbsSkinStdLabel;
    LabelName: TbsSkinStdLabel;
    LabelUpVar: TbsSkinStdLabel;
    LabelUpTime: TbsSkinStdLabel;
    ButtonAdd: TbsSkinButton;
    LabelUpLog: TbsSkinTextLabel;
    procedure ButtonAddClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

uses
  FrmMain, FShare, SCShare, EDCode, MD5Unit;

{$R *.dfm}

procedure TFrameDownM2.ButtonAddClick(Sender: TObject);
var
  sFileMD5: string;
  DefMsg: TDefaultMessage;
begin
  if not g_boConnect then begin
    FormMain.DMsg.MessageDlg('与远程服务器连接断开中，正在重试连接，请稍候...', mtError, [mbYes], 0);
    Exit;
  end;
  FormMain.Lock(True);
  ButtonAdd.Enabled := False;
  FormMain.ShowHint('正在准备下载M2Server.exe，请稍候...');
  sFileMD5 := FileToMD5Text(g_CurrentDir + DOWNDIRNAME + '\M2Server.exe');
  DefMsg := MakeDefaultMsg(CM_DOWNM2SERVER_NEW, 0, 0, 0, 0);
  FormMain.SendSocket(EncodeMessage(DefMsg) + EncodeString(sFileMD5));
end;

end.
