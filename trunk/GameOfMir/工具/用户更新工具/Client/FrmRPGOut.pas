unit FrmRPGOut;

interface

uses
  Windows, Messages, SysUtils, StrUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BusinessSkinForm, bsSkinData, bsSkinCtrls, bsSkinBoxCtrls, StdCtrls, Mask, ImageHlp;

type
  TFormRPGOut = class(TForm)
    DSkinData: TbsSkinData;
    DForm: TbsBusinessSkinForm;
    bsSkinGroupBox3: TbsSkinGroupBox;
    bsSkinStdLabel10: TbsSkinStdLabel;
    bsSkinStdLabel1: TbsSkinStdLabel;
    edtIndexStart: TbsSkinSpinEdit;
    edtIndexEnd: TbsSkinSpinEdit;
    bsSkinGroupBox1: TbsSkinGroupBox;
    btnGo: TbsSkinButton;
    btnExit: TbsSkinButton;
    Out_Alpha: TbsSkinCheckRadioBox;
    Out_Offset: TbsSkinCheckRadioBox;
    Out_Format: TbsSkinCheckRadioBox;
    bsSkinGroupBox2: TbsSkinGroupBox;
    bsSkinStdLabel2: TbsSkinStdLabel;
    EditSaveDir: TbsSkinEdit;
    GaugeMain: TbsSkinGauge;
    procedure FormCreate(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
    procedure EditSaveDirButtonClick(Sender: TObject);
    procedure btnGoClick(Sender: TObject);
    procedure Out_OffsetClick(Sender: TObject);
    procedure Out_FormatClick(Sender: TObject);
  private
    { Private declarations }
  public
    procedure Open();
  end;

var
  FormRPGOut: TFormRPGOut;

implementation

uses FrmMain, FrmRPGView, FShare,
  WIL,
  TDX9Textures,
  wmMyImage,
  Hutil32;

{$R *.dfm}

procedure TFormRPGOut.btnGoClick(Sender: TObject);
var
  StartInt, EndInt, I: Integer;
  m_SaveDir: string;
  m_SaveXYDir: string;
  StringList: TStringList;
  Bitmap, EmptyBitmap: TBitmap;
  Y, nX, nY: Integer;
  Access: TDXAccessInfo;
  WriteBuffer, ReadBuffer: PChar;
  btType: Byte;
  MemoryStream: TMemoryStream;
begin
  if (g_WMImages = nil) or (not g_WMImages.boInitialize) then
    exit;
  EditSaveDir.Enabled := False;
  edtIndexStart.Enabled := False;
  edtIndexEnd.Enabled := False;
  Out_Alpha.Enabled := False;
  Out_Offset.Enabled := False;
  Out_Format.Enabled := False;
  btnGo.Enabled := False;
  btnExit.Enabled := False;
  GaugeMain.Value := 0;
  try
    StartInt := StrToIntDef(edtIndexStart.Text, -1);
    EndInt := StrToIntDef(edtIndexEnd.Text, -1);

    m_SaveDir := Trim(EditSaveDir.Text);
    if RightStr(m_SaveDir, 1) <> '\' then
      m_SaveDir := m_SaveDir + '\';
    m_SaveXYDir := m_SaveDir + IMAGEOFFSETDIR;

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
    if Out_Offset.Checked then MakeSureDirectoryPathExists(PChar(m_SaveXYDir))
    else MakeSureDirectoryPathExists(PChar(m_SaveDir));
    StringList := TStringList.Create;
    EmptyBitmap := TBitmap.Create;
    EmptyBitmap.Width := 1;
    EmptyBitmap.Height := 1;
    EmptyBitmap.PixelFormat := pf32bit;
    Bitmap := nil;
    for I := StartInt to EndInt do begin
       nX := 0;
       nY := 0;
      case g_WMImages.GetDataType(I) of
        FILETYPE_IMAGE: begin
            if Out_Alpha.Checked then begin
              if g_WMImages.CopyDataToTexture(I, g_Texture[1]) then begin
                nX := g_WMImages.LastImageInfo.px;
                nY := g_WMImages.LastImageInfo.py;
                Bitmap := TBitmap.Create;
                Bitmap.PixelFormat := pf16bit;
                Bitmap.Width := g_Texture[1].Width;
                Bitmap.Height := g_Texture[1].Height;
                if g_Texture[1].Lock(lfReadOnly, Access) then begin
                  try
                    for Y := 0 to Bitmap.Height - 1 do begin
                      ReadBuffer := Pointer(Integer(Access.Bits) + (Access.Pitch * Y));
                      WriteBuffer := Bitmap.ScanLine[y];
                      Move(ReadBuffer^, WriteBuffer^, Bitmap.Width * 2);
                    end;
                  finally
                    g_Texture[1].Unlock;
                  end;
                end;
              end;
            end else begin
              BitMap := g_WMImages.Bitmap[I, btType];
              if Bitmap <> nil then begin
                nX := g_WMImages.LastImageInfo.px;
                nY := g_WMImages.LastImageInfo.py;
                if Bitmap.PixelFormat = pf8bit then
                  SetDIBColorTable(Bitmap.Canvas.Handle, 0, 256, g_DefMainPalette);
              end;
            end;
            if Bitmap <> nil then Bitmap.SaveToFile(Format('%s%.6d.bmp', [m_SaveDir, I]))
            else EmptyBitmap.SaveToFile(Format('%s%.6d.bmp', [m_SaveDir, I]));
            if Out_Offset.Checked then begin
              StringList.Clear;
              StringList.Add(IntToStr(nX));
              StringList.Add(IntToStr(nY));
              if Out_Format.Checked and (g_WMImages is TWMMyImageImages) then begin
                StringList.Add(IntToStr(Integer(g_WMImages.LastColorFormat)));
              end;
              StringList.SaveToFile(Format('%s%.6d.txt', [m_SaveXYDir, I]));
            end;
            if Bitmap <> nil then
              Bitmap.Free;
            Bitmap := nil;
          end;
        FILETYPE_DATA: begin
            MemoryStream := g_WMImages.GetDataStream(I, dtData);
            if MemoryStream <> nil then begin
              Try
                MemoryStream.SaveToFile(Format('%s%.6d.dat', [m_SaveDir, I]));
              Finally
                MemoryStream.Free;
              End;
            end else
              EmptyBitmap.SaveToFile(Format('%s%.6d.bmp', [m_SaveDir, I]));
          end;
        FILETYPE_WAVA: begin
            MemoryStream := g_WMImages.GetDataStream(I, dtMusic);
            if MemoryStream <> nil then begin
              Try
                MemoryStream.SaveToFile(Format('%s%.6d.wav', [m_SaveDir, I]));
              Finally
                MemoryStream.Free;
              End;
            end else
              EmptyBitmap.SaveToFile(Format('%s%.6d.bmp', [m_SaveDir, I]));
          end;
        FILETYPE_MP3: begin
            MemoryStream := g_WMImages.GetDataStream(I, dtMusic);
            if MemoryStream <> nil then begin
              Try
                MemoryStream.SaveToFile(Format('%s%.6d.mp3', [m_SaveDir, I]));
              Finally
                MemoryStream.Free;
              End;
            end else
              EmptyBitmap.SaveToFile(Format('%s%.6d.bmp', [m_SaveDir, I]));
          end;
        else begin
            EmptyBitmap.SaveToFile(Format('%s%.6d.bmp', [m_SaveDir, I]));
          end;
      end;
      if (EndInt - StartInt) > 0 then
        GaugeMain.Value := _MAX(0, Trunc(i / (EndInt - StartInt) * 100))
      else
        GaugeMain.Value := 100;
      Application.ProcessMessages;
    end;
    StringList.Free;
    FormMain.DMsg.MessageDlg('导出数据完成！', mtConfirmation, [mbYes], 0);
    Close
  finally
    EditSaveDir.Enabled := True;
    edtIndexStart.Enabled := True;
    edtIndexEnd.Enabled := True;
    Out_Alpha.Enabled := True;
    Out_Offset.Enabled := True;
    Out_Format.Enabled := True;
    btnGo.Enabled := True;
    btnExit.Enabled := True;
  end;
end;

procedure TFormRPGOut.btnExitClick(Sender: TObject);
begin
  Close;
end;

procedure TFormRPGOut.EditSaveDirButtonClick(Sender: TObject);
begin
  if FormMain.SelectDirectory.Execute then begin
    EditSaveDir.Text := FormMain.SelectDirectory.Directory;
  end;
end;

procedure TFormRPGOut.FormCreate(Sender: TObject);
begin
  DSkinData.SkinList := FormMain.CompressedSkinList;
end;

procedure TFormRPGOut.Open;
begin
  ClientHeight := 203;
  ClientWidth := 291;
  edtIndexStart.MaxValue := g_WMImages.ImageCount - 1;
  edtIndexEnd.MaxValue := g_WMImages.ImageCount - 1;
  edtIndexStart.Value := g_SelectImageIndex;
  edtIndexEnd.Value := g_SelectImageIndex;
  GaugeMain.Value := 0;
  ShowModal;
end;

procedure TFormRPGOut.Out_FormatClick(Sender: TObject);
begin
  if Out_Format.Checked then
    Out_Offset.Checked := True;
end;

procedure TFormRPGOut.Out_OffsetClick(Sender: TObject);
begin
  if not Out_Offset.Checked then
    Out_Format.Checked := False;
end;

end.
