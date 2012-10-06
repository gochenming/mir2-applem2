unit FrmRPGDelete;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BusinessSkinForm, bsSkinData, bsSkinBoxCtrls, StdCtrls, bsSkinCtrls;

type
  TFormRPGDelete = class(TForm)
    DSkinData: TbsSkinData;
    DForm: TbsBusinessSkinForm;
    bsSkinGroupBox3: TbsSkinGroupBox;
    bsSkinStdLabel10: TbsSkinStdLabel;
    edtIndexStart: TbsSkinSpinEdit;
    edtIndexEnd: TbsSkinSpinEdit;
    bsSkinStdLabel1: TbsSkinStdLabel;
    bsSkinGroupBox1: TbsSkinGroupBox;
    rbQuiteDel: TbsSkinCheckRadioBox;
    SkinCheckRadioBox: TbsSkinCheckRadioBox;
    ButtonExec: TbsSkinButton;
    ButtonExit: TbsSkinButton;
    procedure FormCreate(Sender: TObject);
    procedure ButtonExitClick(Sender: TObject);
    procedure ButtonExecClick(Sender: TObject);
  private
    { Private declarations }
  public
    procedure Open();
  end;

var
  FormRPGDelete: TFormRPGDelete;

implementation

uses FrmMain, FShare, wmMyImage, FrmRPGView;

{$R *.dfm}

procedure TFormRPGDelete.ButtonExecClick(Sender: TObject);
var
  StartInt, EndInt, StartPos, EndPos, ChangePos: Integer;
  WMImages: wmMyImage.TWMMyImageImages;
begin
  if (g_WMImages = nil) or (not g_WMImages.boInitialize) then
    exit;
  edtIndexStart.Enabled := False;
  edtIndexEnd.Enabled := False;
  rbQuiteDel.Enabled := False;
  SkinCheckRadioBox.Enabled := False;
  ButtonExec.Enabled := False;
  ButtonExit.Enabled := False;
  Try
    WMImages := TWMMyImageImages(g_WMImages);
    StartInt := StrToIntDef(edtIndexStart.Text, -1);
    EndInt := StrToIntDef(edtIndexEnd.Text, -1);
    if (StartInt < 0) then begin
      FormMain.DMsg.MessageDlg('数据起始编号设置错误！', mtError, [mbYes], 0);
      exit;
    end;
    if (EndInt < 0) then begin
      FormMain.DMsg.MessageDlg('数据结束编号设置错误！', mtError, [mbYes], 0);
      exit;
    end;
    if (EndInt >= g_WMImages.ImageCount) then begin
      FormMain.DMsg.MessageDlg('数据结束编号设置错误，不能大于总数据数量！', mtError, [mbYes], 0);
      exit;
    end;
    if (StartInt > EndInt) then begin
      FormMain.DMsg.MessageDlg('数据起始编号设置错误，不能大于结号编号！', mtError, [mbYes], 0);
      exit;
    end;
    StartPos := WMImages.GetDataOffset(StartInt, False);
    EndPos := WMImages.GetDataOffset(EndInt + 1, False);
    if (StartPos > 0) and (EndPos > 0) and (EndPos >= StartPos) then begin
      ChangePos := EndPos - StartPos;
      if ChangePos > 0 then begin
        RemoveData(WMImages.FileName, StartPos, ChangePos); //删除空间
      end;
      WMImages.ChangeOffsetToList(StartInt, EndInt, ChangePos, rbQuiteDel.Checked);
      g_WMImages.SaveIndexList;
      FormMain.FrmRPGView.DrawGrid.RowCount := WMImages.ImageCount div 5 + 1;
      FormMain.FrmRPGView.DrawGrid.Repaint;
      FormMain.DMsg.MessageDlg('删除数据完成！', mtConfirmation, [mbYes], 0);
      Close;
    end;
  Finally
    edtIndexStart.Enabled := True;
    edtIndexEnd.Enabled := True;
    rbQuiteDel.Enabled := True;
    SkinCheckRadioBox.Enabled := True;
    ButtonExec.Enabled := True;
    ButtonExit.Enabled := True;
  End;
end;

procedure TFormRPGDelete.ButtonExitClick(Sender: TObject);
begin
  Close;
end;

procedure TFormRPGDelete.FormCreate(Sender: TObject);
begin
  DSkinData.SkinList := FormMain.CompressedSkinList;
end;

procedure TFormRPGDelete.Open;
begin
  ClientHeight := 129;
  ClientWidth := 328;
  edtIndexStart.MaxValue := g_WMImages.ImageCount - 1;
  edtIndexEnd.MaxValue := g_WMImages.ImageCount - 1;
  edtIndexStart.Value := g_SelectImageIndex;
  edtIndexEnd.Value := g_SelectImageIndex;
  ShowModal;
end;

end.
