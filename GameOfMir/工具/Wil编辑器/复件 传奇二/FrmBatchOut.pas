unit FrmBatchOut;

interface

uses
  Windows, Messages, SysUtils, StrUtils, Variants, Classes, Graphics, Controls,
  Forms,Dialogs, ComCtrls, StdCtrls, ImageHlp;

type
  TFormBatchOut = class(TForm)
    Label1: TLabel;
    edtSaveDir: TEdit;
    Button1: TButton;
    GroupBox1: TGroupBox;
    edtIndexStart: TEdit;
    Label2: TLabel;
    edtIndexEnd: TEdit;
    Label3: TLabel;
    ProgressBar: TProgressBar;
    btnGo: TButton;
    btnExit: TButton;
    procedure btnExitClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure btnGoClick(Sender: TObject);
  private

  public
    { Public declarations }
  end;

var
  FormBatchOut: TFormBatchOut;

implementation
uses
  Share, FrmMain, WIL, HUtil32,DIB;

{$R *.dfm}

procedure TFormBatchOut.btnExitClick(Sender: TObject);
begin
  close;
end;

procedure TFormBatchOut.btnGoClick(Sender: TObject);
var
  m_SaveDir: string;
  m_SaveXYDir: string;
  StartInt, EndInt, I: Integer;
  StringList: TStringList;
  position: Integer;
begin
  if not FormMain.WMImages.boInitialize then
    exit;
  if (Trim(edtSaveDir.Text) <> '') then begin
    m_SaveDir := Trim(edtSaveDir.Text);
    if RightStr(m_SaveDir, 1) <> '\' then
      m_SaveDir := m_SaveDir + '\';
    m_SaveXYDir := m_SaveDir + SaveXYDir;
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
    MakeSureDirectoryPathExists(PChar(m_SaveDir));
    MakeSureDirectoryPathExists(PChar(m_SaveXYDir));
    StringList := TStringList.Create;
    try
      for I := StartInt to EndInt do begin
        position := Integer(FormMain.WMImages.m_IndexList.Items[I]);
        FormMain.WMImages.MakeDIB(position);
        FormMain.WMImages.lsDib.SaveToFile(m_SaveDir + GetIndexToStr(I) +
          '.bmp');
        StringList.Clear;
        StringList.Add(IntToStr(FormMain.WMImages.imginfo.px));
        StringList.Add(IntToStr(FormMain.WMImages.imginfo.py));
        StringList.SaveToFile(m_SaveXYDir + GetIndexToStr(I) + '.txt');

        if (EndInt - StartInt) > 0 then
          ProgressBar.Position := _MAX(0, Trunc(i / (EndInt - StartInt) * 100))
        else
          ProgressBar.Position := 100;
        application.ProcessMessages;
      end;
    finally
      StringList.Free;
    end;

    Application.MessageBox('批量导出完成', '提示信息', MB_OK or
      MB_ICONASTERISK);
    Close
  end
  else
    Application.MessageBox('请先选择保存文件夹位置', '提示信息',
      MB_OK or MB_ICONASTERISK);
end;

procedure TFormBatchOut.Button1Click(Sender: TObject);
var
  sStr: string;
begin
  sStr := BrowseForFolder(Handle, '请选择保存文件夹');
  if sStr <> '' then begin
    edtSaveDir.Text := sStr;
  end;
end;

end.

