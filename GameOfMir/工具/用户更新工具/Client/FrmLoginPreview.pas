unit FrmLoginPreview;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Share,
  Dialogs, ExtCtrls, EzRgnBtn, RzStatus, StdCtrls, RzLabel, OleCtrls, SHDocVw, WebBrowserWithUI, ComCtrls;

type
  TFormPreview = class(TForm)
    imgBg: TImage;
    tvServer: TTreeView;
    WebBrowser: TWebBrowserWithUI;
    LabelLog: TRzLabel;
    ProgressNow: TRzProgressStatus;
    ProgressAll: TRzProgressStatus;
    LabelNow: TRzLabel;
    LabelAll: TRzLabel;
    BtnPlay: TEzRgnBtn;
    BtnUpdating: TEzRgnBtn;
    EzRgnBtn1: TEzRgnBtn;
    EzRgnBtn2: TEzRgnBtn;
    BtnExit: TEzRgnBtn;
    EzRgnBtn4: TEzRgnBtn;
    EzRgnBtn3: TEzRgnBtn;
    BtnSetup: TEzRgnBtn;
    BtnMin: TEzRgnBtn;
    BtnClose: TEzRgnBtn;
    RzLabel1: TRzLabel;
    procedure BtnCloseClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure imgBgMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure tvServerCustomDrawItem(Sender: TCustomTreeView; Node: TTreeNode; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure WebBrowserDownloadBegin(Sender: TObject);
    procedure WebBrowserNavigateComplete2(ASender: TObject; const pDisp: IDispatch; var URL: OleVariant);
    procedure BtnMinClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    procedure Open();
  end;

var
  FormPreview: TFormPreview;

implementation

uses FrmMain;

{$R *.dfm}

{ TFormPreview }

procedure TFormPreview.BtnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFormPreview.BtnMinClick(Sender: TObject);
begin
  SendMessage(Application.Handle, WM_SYSCOMMAND, SC_MINIMIZE, 0);
end;

procedure TFormPreview.FormCreate(Sender: TObject);
begin
  imgBG.Picture.Assign(FormMain.FrmMakeLogin.imgBG.Picture);
  ClientHeight := imgBG.Picture.Height;
  ClientWidth := imgBG.Picture.Width;
  TransparentColor := FormMain.FrmMakeLogin.BGTransparent.Checked;
  TransparentColorValue := FormMain.FrmMakeLogin.BGTransparentColor.ColorValue;
end;

procedure TFormPreview.FormShow(Sender: TObject);
begin
  tvServer.Left := Trunc(FormMain.FrmMakeLogin.EditServerListLeft.Value);
  tvServer.Top := Trunc(FormMain.FrmMakeLogin.EditServerListTop.Value);
  tvServer.Height := Trunc(FormMain.FrmMakeLogin.EditServerListHeight.Value);
  tvServer.Width := Trunc(FormMain.FrmMakeLogin.EditServerListWidth.Value);

  WebBrowser.Left := Trunc(FormMain.FrmMakeLogin.EditIELeft.Value);
  WebBrowser.Top := Trunc(FormMain.FrmMakeLogin.EditIETop.Value);
  WebBrowser.Height := Trunc(FormMain.FrmMakeLogin.EditIEHeight.Value);
  WebBrowser.Width := Trunc(FormMain.FrmMakeLogin.EditIEWidth.Value);

  RzLabel1.Visible := FormMain.FrmMakeLogin.VarShow.Checked;
  RzLabel1.Left := Trunc(FormMain.FrmMakeLogin.VarLeft.Value);
  RzLabel1.Top := Trunc(FormMain.FrmMakeLogin.VarTop.Value);
  RzLabel1.Font.Color := FormMain.FrmMakeLogin.ColorVar.ColorValue;

  LabelLog.Left := Trunc(FormMain.FrmMakeLogin.EditHintLeft.Value);
  LabelLog.Top := Trunc(FormMain.FrmMakeLogin.EditHintTop.Value);

  ProgressNow.Left := Trunc(FormMain.FrmMakeLogin.EditPressLeft.Value);
  ProgressNow.Top := Trunc(FormMain.FrmMakeLogin.EditPressTop.Value);
  ProgressNow.Width := Trunc(FormMain.FrmMakeLogin.EditPressWidth.Value);
  ProgressNow.Height := Trunc(FormMain.FrmMakeLogin.EditPressHeight.Value);
  ProgressNow.BarColor := FormMain.FrmMakeLogin.ColorPress1.ColorValue;
  ProgressNow.BarColorStop := FormMain.FrmMakeLogin.ColorPress2.ColorValue;

  ProgressAll.Left := Trunc(FormMain.FrmMakeLogin.EditPressAllLeft.Value);
  ProgressAll.Top := Trunc(FormMain.FrmMakeLogin.EditPressAllTop.Value);
  ProgressAll.Width := Trunc(FormMain.FrmMakeLogin.EditPressAllWidth.Value);
  ProgressAll.Height := Trunc(FormMain.FrmMakeLogin.EditPressAllHeight.Value);
  ProgressAll.BarColor := FormMain.FrmMakeLogin.ColorPressAll1.ColorValue;
  ProgressAll.BarColorStop := FormMain.FrmMakeLogin.ColorPressAll2.ColorValue;


  LabelNow.Left := Trunc(FormMain.FrmMakeLogin.EditPressHintLeft.Value);
  LabelNow.Top := Trunc(FormMain.FrmMakeLogin.EditPressHintTop.Value);
  LabelNow.Font.Color := FormMain.FrmMakeLogin.ColorPressNow.ColorValue;

  LabelAll.Left := Trunc(FormMain.FrmMakeLogin.EditPressAllHintLeft.Value);
  LabelAll.Top := Trunc(FormMain.FrmMakeLogin.EditPressAllHintTop.Value);
  LabelAll.Font.Color := FormMain.FrmMakeLogin.ColorPressAll.ColorValue;

  btnPlay.Left := Trunc(FormMain.FrmMakeLogin.EditStartLeft.Value);
  btnPlay.Top := Trunc(FormMain.FrmMakeLogin.EditStartTop.Value);
  btnPlay.PicIdle.Assign(FormMain.FrmMakeLogin.BtnPlay.PicIdle);
  btnPlay.PicUp.Assign(FormMain.FrmMakeLogin.BtnPlay.PicUp);
  btnPlay.PicDown.Assign(FormMain.FrmMakeLogin.BtnPlay.PicDown);
  btnPlay.PicDsbld.Assign(FormMain.FrmMakeLogin.BtnPlay.PicDsbld);

  btnUpdating.Visible := FormMain.FrmMakeLogin.CheckBoxReg.Checked;
  btnUpdating.Left := Trunc(FormMain.FrmMakeLogin.EditRegLeft.Value);
  btnUpdating.Top := Trunc(FormMain.FrmMakeLogin.EditRegTop.Value);
  btnUpdating.PicIdle.Assign(FormMain.FrmMakeLogin.btnUpdating.PicIdle);
  btnUpdating.PicUp.Assign(FormMain.FrmMakeLogin.btnUpdating.PicUp);
  btnUpdating.PicDown.Assign(FormMain.FrmMakeLogin.btnUpdating.PicDown);
  btnUpdating.PicDsbld.Assign(FormMain.FrmMakeLogin.btnUpdating.PicDsbld);

  EzRgnbtn1.Visible := FormMain.FrmMakeLogin.CheckBoxChangePass.Checked;
  EzRgnbtn1.Left := Trunc(FormMain.FrmMakeLogin.EditChangePassLeft.Value);
  EzRgnbtn1.Top := Trunc(FormMain.FrmMakeLogin.EditChangePassTop.Value);
  EzRgnbtn1.PicIdle.Assign(FormMain.FrmMakeLogin.EzRgnbtn1.PicIdle);
  EzRgnbtn1.PicUp.Assign(FormMain.FrmMakeLogin.EzRgnbtn1.PicUp);
  EzRgnbtn1.PicDown.Assign(FormMain.FrmMakeLogin.EzRgnbtn1.PicDown);
  EzRgnbtn1.PicDsbld.Assign(FormMain.FrmMakeLogin.EzRgnbtn1.PicDsbld);

  EzRgnbtn2.Visible := FormMain.FrmMakeLogin.CheckBoxLostPass.Checked;
  EzRgnbtn2.Left := Trunc(FormMain.FrmMakeLogin.EditLostPassLeft.Value);
  EzRgnbtn2.Top := Trunc(FormMain.FrmMakeLogin.EditLostPassTop.Value);
  EzRgnbtn2.PicIdle.Assign(FormMain.FrmMakeLogin.EzRgnbtn2.PicIdle);
  EzRgnbtn2.PicUp.Assign(FormMain.FrmMakeLogin.EzRgnbtn2.PicUp);
  EzRgnbtn2.PicDown.Assign(FormMain.FrmMakeLogin.EzRgnbtn2.PicDown);
  EzRgnbtn2.PicDsbld.Assign(FormMain.FrmMakeLogin.EzRgnbtn2.PicDsbld);

  btnSetup.Visible := FormMain.FrmMakeLogin.CheckBoxSetup.Checked;
  btnSetup.Left := Trunc(FormMain.FrmMakeLogin.EditSetupLeft.Value);
  btnSetup.Top := Trunc(FormMain.FrmMakeLogin.EditSetupTop.Value);
  btnSetup.PicIdle.Assign(FormMain.FrmMakeLogin.btnSetup.PicIdle);
  btnSetup.PicUp.Assign(FormMain.FrmMakeLogin.btnSetup.PicUp);
  btnSetup.PicDown.Assign(FormMain.FrmMakeLogin.btnSetup.PicDown);

  EzRgnbtn3.Visible := FormMain.FrmMakeLogin.CheckBoxHome.Checked;
  EzRgnbtn3.Left := Trunc(FormMain.FrmMakeLogin.EditHomeLeft.Value);
  EzRgnbtn3.Top := Trunc(FormMain.FrmMakeLogin.EditHomeTop.Value);
  EzRgnbtn3.PicIdle.Assign(FormMain.FrmMakeLogin.EzRgnbtn3.PicIdle);
  EzRgnbtn3.PicUp.Assign(FormMain.FrmMakeLogin.EzRgnbtn3.PicUp);
  EzRgnbtn3.PicDown.Assign(FormMain.FrmMakeLogin.EzRgnbtn3.PicDown);

  EzRgnbtn4.Visible := FormMain.FrmMakeLogin.CheckBoxPay.Checked;
  EzRgnbtn4.Left := Trunc(FormMain.FrmMakeLogin.EditPayLeft.Value);
  EzRgnbtn4.Top := Trunc(FormMain.FrmMakeLogin.EditPayTop.Value);
  EzRgnbtn4.PicIdle.Assign(FormMain.FrmMakeLogin.EzRgnbtn4.PicIdle);
  EzRgnbtn4.PicUp.Assign(FormMain.FrmMakeLogin.EzRgnbtn4.PicUp);
  EzRgnbtn4.PicDown.Assign(FormMain.FrmMakeLogin.EzRgnbtn4.PicDown);

  btnExit.Visible := FormMain.FrmMakeLogin.CheckBoxExit.Checked;
  btnExit.Left := Trunc(FormMain.FrmMakeLogin.EditExitLeft.Value);
  btnExit.Top := Trunc(FormMain.FrmMakeLogin.EditExitTop.Value);
  btnExit.PicIdle.Assign(FormMain.FrmMakeLogin.btnExit.PicIdle);
  btnExit.PicUp.Assign(FormMain.FrmMakeLogin.btnExit.PicUp);
  btnExit.PicDown.Assign(FormMain.FrmMakeLogin.btnExit.PicDown);

  btnMin.Visible := FormMain.FrmMakeLogin.CheckBoxMin.Checked;
  btnMin.Left := Trunc(FormMain.FrmMakeLogin.EditMinLeft.Value);
  btnMin.Top := Trunc(FormMain.FrmMakeLogin.EditMinTop.Value);
  btnMin.PicIdle.Assign(FormMain.FrmMakeLogin.btnMin.PicIdle);
  btnMin.PicUp.Assign(FormMain.FrmMakeLogin.btnMin.PicUp);
  btnMin.PicDown.Assign(FormMain.FrmMakeLogin.btnMin.PicDown);

  btnClose.Visible := FormMain.FrmMakeLogin.CheckBoxClose.Checked;
  btnClose.Left := Trunc(FormMain.FrmMakeLogin.EditCloseLeft.Value);
  btnClose.Top := Trunc(FormMain.FrmMakeLogin.EditCloseTop.Value);
  btnClose.PicIdle.Assign(FormMain.FrmMakeLogin.btnClose.PicIdle);
  btnClose.PicUp.Assign(FormMain.FrmMakeLogin.btnClose.PicUp);
  btnClose.PicDown.Assign(FormMain.FrmMakeLogin.btnClose.PicDown);

  WebBrowser.Navigate('http://www.361m2.com');
end;

procedure TFormPreview.imgBgMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ReleaseCapture; //释放鼠标的捕获状态；
  Perform(wm_SysCommand, {sc_DragMove} $F012, 0); //向窗体发送移动消息
end;

procedure TFormPreview.Open();
begin
  ShowModal;
end;

procedure TFormPreview.tvServerCustomDrawItem(Sender: TCustomTreeView; Node: TTreeNode; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  if Node.Level = 0 then begin
    Sender.Canvas.Font.Color := clLime;
  end;
end;

procedure TFormPreview.WebBrowserDownloadBegin(Sender: TObject);
begin
  WebBrowser.Silent := True;
end;

procedure TFormPreview.WebBrowserNavigateComplete2(ASender: TObject; const pDisp: IDispatch; var URL: OleVariant);
begin
  WebBrowser.Silent := True;
end;

end.
