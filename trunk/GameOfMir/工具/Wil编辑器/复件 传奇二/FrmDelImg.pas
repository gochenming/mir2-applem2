unit FrmDelImg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls;

type
  TFormDelImg = class(TForm)
    GroupBox1: TGroupBox;
    edtIndexStart: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    edtIndexEnd: TEdit;
    GroupBox2: TGroupBox;
    rbQuiteDel: TRadioButton;
    RadioButton2: TRadioButton;
    ProgressBar: TProgressBar;
    btnGo: TButton;
    btnExit: TButton;
    procedure btnExitClick(Sender: TObject);
    procedure btnGoClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormDelImg: TFormDelImg;

implementation
uses
  Wil, Share, FrmMain, HUtil32;

{$R *.dfm}

procedure TFormDelImg.btnExitClick(Sender: TObject);
begin
  Close;
end;

procedure TFormDelImg.btnGoClick(Sender: TObject);
var
  StartInt, EndInt: Integer;
begin
  if not FormMain.WMImages.boInitialize then
    exit;

  StartInt := StrToIntDef(edtIndexStart.Text, -1);
  EndInt := StrToIntDef(edtIndexEnd.Text, -1);
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
  FormMain.WMImages.DelImages(StartInt, EndInt, rbQuiteDel.Checked);
  ProgressBar.Position := 100;
  FormMain.WMImages.SaveIndex();
  FormMain.DrawGrid.RowCount := FormMain.WMImages.ImageCount div 6 + 1;
  FormMain.DrawGrid.Repaint;
  FormMain.RefShowLabel(FormMain.DrawGrid.Col, FormMain.DrawGrid.Row * 6);
  Application.MessageBox('删除图片完成', '提示信息', MB_OK or
    MB_ICONASTERISK);
  Close;
end;

end.

