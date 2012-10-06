unit FrmSetXY;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls;

type
  TFormSetXY = class(TForm)
    GroupBox1: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    edtIndexStart: TEdit;
    edtIndexEnd: TEdit;
    ProgressBar: TProgressBar;
    btnGo: TButton;
    btnExit: TButton;
    GroupBox2: TGroupBox;
    EditX: TEdit;
    EditY: TEdit;
    Label1: TLabel;
    Label4: TLabel;
    procedure btnGoClick(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormSetXY: TFormSetXY;

implementation
uses
FrmMain, wmUtil;

{$R *.dfm}

procedure TFormSetXY.btnExitClick(Sender: TObject);
begin
  Close;
end;

procedure TFormSetXY.btnGoClick(Sender: TObject);
var
  StartInt, EndInt, AddX, AddY: Integer;
  i: Integer;
  pimginfo: TWMImageInfo;
begin
  if not FormMain.WMImages.boInitialize then
    exit;

  StartInt := StrToIntDef(edtIndexStart.Text, -1);
  EndInt := StrToIntDef(edtIndexEnd.Text, -1);
  AddX := StrToIntDef(EditX.Text, 0);
  AddY := StrToIntDef(EditY.Text, 0);
  if (StartInt < 0) then begin
    Application.MessageBox('图片起始编号设置错误', '提示信息',
      MB_OK or MB_ICONASTERISK);
    exit;
  end;
  if (EndInt < 0) then begin
    Application.MessageBox('图片结束编号设置错误', '提示信息',
      MB_OK or MB_ICONASTERISK);
    exit;
  end;
  if (EndInt > FormMain.WMImages.ImageCount) then begin
    Application.MessageBox('图片结束编号设置错误，不能大于总图片数量', '提示信息', MB_OK or MB_ICONASTERISK);
    exit;
  end;
  if (StartInt > EndInt) then begin
    Application.MessageBox('图片起始编号设置错误，不能大于结号编号', '提示信息', MB_OK or MB_ICONASTERISK);
    exit;
  end;
  for I := StartInt to EndInt do begin
    FormMain.WMImages.GetImageInfo(I, @pimginfo);
    pimginfo.px := pimginfo.px + AddX;
    pimginfo.py := pimginfo.py + AddY;
    FormMain.WMImages.SetImageInfo(I, @pimginfo);
    ProgressBar.Position := Trunc((I - StartInt) / (EndInt - StartInt) *
      100);
  end;
  Application.MessageBox('设置完成完成', '提示信息', MB_OK or
      MB_ICONASTERISK);
    Close;
end;

end.
