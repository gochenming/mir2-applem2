unit FrmCreateWil;

interface

uses
  Windows, Messages, SysUtils, StrUtils, Variants, Classes, Graphics, Controls,
  Forms,
  Dialogs, StdCtrls;

type
  TFormCreateWil = class(TForm)
    btn1: TButton;
    edtSaveDir: TEdit;
    lbl1: TLabel;
    grp1: TGroupBox;
    rb1: TRadioButton;
    rbNewEncrypt: TRadioButton;
    btnExit: TButton;
    btnGo: TButton;
    procedure btn1Click(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
    procedure btnGoClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormCreateWil: TFormCreateWil;

implementation
uses
  FrmMain, Share, Wil, wmUtil;

{$R *.dfm}

procedure TFormCreateWil.btn1Click(Sender: TObject);
begin
  if FormMain.SaveDialog.Execute(Handle) then begin
    edtSaveDir.Text := FormMain.SaveDialog.FileName;
    if RightStr(edtSaveDir.Text, 4) <> '.wil' then
      edtSaveDir.Text := edtSaveDir.Text + '.wil';
  end;

end;

procedure TFormCreateWil.btnExitClick(Sender: TObject);
begin
  Close;
end;

procedure TFormCreateWil.btnGoClick(Sender: TObject);
var
  sFileName, sIdxFile: string;
  fhandle: THandle;
  WMImageHeader: TWMImageHeader;
  WMIndexHeader: TWMIndexHeader;
begin
  sFileName := Trim(edtSaveDir.Text);
  if FileExists(sFileName) then
    fhandle := FileOpen(sFileName, fmOpenWrite)
  else
    fhandle := FileCreate(sFileName, fmOpenWrite);
  if fhandle > 0 then begin
    try
      FillChar(WMImageHeader, SizeOf(WMImageHeader), #0);
      if rbNewEncrypt.Checked then begin
        WMImageHeader.Title := C_Title2;
        WMImageHeader.nFlag := VERFLAG;
      end
      else
        WMImageHeader.Title := C_Title;
      WMImageHeader.ColorCount := 8;
      WMImageHeader.PaletteSize := SizeOf(DefMainPalette);
      if rbNewEncrypt.Checked then
        FileWrite(fhandle, WMImageHeader, SizeOf(WMImageHeader))
      else
        FileWrite(fhandle, WMImageHeader, SizeOf(WMImageHeader) - 4);
      FileWrite(fhandle, DefMainPalette, SizeOf(DefMainPalette));
    finally
      FileClose(fhandle);
    end;
  end;
  sIdxFile := ExtractFilePath(sFileName) + ExtractFileNameOnly(sFileName) +
    '.WIX';
  if FileExists(sIdxFile) then
    fhandle := FileOpen(sIdxFile, fmOpenWrite)
  else
    fhandle := FileCreate(sIdxFile, fmOpenWrite);
  if fhandle > 0 then begin
    try
      FillChar(WMIndexHeader, SizeOf(WMIndexHeader), #0);
      if rbNewEncrypt.Checked then
        WMIndexHeader.Title := C_Title2
      else
        WMIndexHeader.Title := C_Title;
      FileWrite(fhandle, WMIndexHeader, SizeOf(WMIndexHeader))
    finally
      FileClose(fhandle);
    end;
  end;
  Application.MessageBox('创建新文件成功', '提示信息', MB_OK or
    MB_ICONASTERISK);
  if Application.MessageBox('是否打开新创建的文件？', '提示信息',
    MB_YESNO + MB_ICONQUESTION) = IDYES then begin
    with FormMain do begin
      edtFileName.Text := sFileName;
      if WMImages.boInitialize then
        WMImages.Finalize;
      WMImages.BitType := dbtAuto;
      ComboBoxBitType.ItemIndex := 0;
      WMImages.FileName := Trim(edtFileName.Text);
      WMImages.Initialize;
      DrawGrid.RowCount := WMImages.ImageCount div 6 + 1;
      DrawGrid.Repaint;
    end;
  end;
  Close;
end;

end.

