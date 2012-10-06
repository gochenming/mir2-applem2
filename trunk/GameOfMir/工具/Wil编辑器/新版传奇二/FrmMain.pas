unit FrmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtDlgs, ExtCtrls, {WinSkinData, }Grids, StdCtrls, WIL;

type
  TFormMain = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    edtFileName: TEdit;
    btnOpenDig: TButton;
    btnFront: TButton;
    btnNext: TButton;
    btnGoto: TButton;
    btnDel: TButton;
    btnAutoPlay: TButton;
    btnStop: TButton;
    btnOut: TButton;
    btnInput: TButton;
    btnBatchOut: TButton;
    btnAddBitmap: TButton;
    btnCreateWil: TButton;
    btnBatchInput: TButton;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    lblClass: TLabel;
    lblSize: TLabel;
    lblX: TLabel;
    lblY: TLabel;
    lblIndex: TLabel;
    btnChangeX: TButton;
    btnChangeY: TButton;
    GroupBox2: TGroupBox;
    Label7: TLabel;
    rbZoom50: TRadioButton;
    rbZoom100: TRadioButton;
    rbZoom200: TRadioButton;
    rbZoomAuto: TRadioButton;
    rbZoom800: TRadioButton;
    rbZoom400: TRadioButton;
    chkJmpNilBitmap: TCheckBox;
    chkEncrypt: TCheckBox;
    chkLineShow: TCheckBox;
    chkShowLine: TCheckBox;
    Panel2: TPanel;
    Splitter1: TSplitter;
    ScrollBox: TScrollBox;
    Image1: TImage;
    DrawGrid: TDrawGrid;
    OpenDialog: TOpenDialog;
    Timer: TTimer;
    SaveDialog: TSaveDialog;
    OpenPictureDialog: TOpenPictureDialog;
    SavePictureDialog: TSavePictureDialog;
    CKSetTransparentColor: TCheckBox;
    CKAutoCutOut: TCheckBox;
    EdTransparentColor: TEdit;
    Button1: TButton;
    ComboBox1: TComboBox;
    Label8: TLabel;
    procedure btnOpenDigClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure DrawGridDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure DrawGridSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure rbZoom100Click(Sender: TObject);
    procedure ScrollBoxResize(Sender: TObject);
    procedure chkJmpNilBitmapClick(Sender: TObject);
    procedure ComboBoxBitTypeChange(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure btnGotoClick(Sender: TObject);
    procedure btnAutoPlayClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure btnOutClick(Sender: TObject);
    procedure btnBatchOutClick(Sender: TObject);
    procedure btnDelClick(Sender: TObject);
    procedure btnInputClick(Sender: TObject);
    procedure btnAddBitmapClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnBatchInputClick(Sender: TObject);
    procedure btnChangeXClick(Sender: TObject);
    procedure btnChangeYClick(Sender: TObject);
    procedure btnCreateWilClick(Sender: TObject);
    procedure CKAutoCutOutClick(Sender: TObject);
    procedure CKSetTransparentColorClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
  private

  public
    procedure RefShowLabel(ACol, ARow: Integer);
    function SetDrawGridIndex(Index: Integer): Boolean;
  end;

var
  FormMain: TFormMain;

implementation
uses
  Share, HUtil32, wmUtil, FrmBatchOut, FrmDelImg, FrmAddNew, DIB, FrmBatchInput,
  FrmCreateWil, FrmSetXY;

var
  ImageInfo: TWMImageInfo;

{$R *.dfm}
{$R ColorTable.RES}

procedure TFormMain.btnAddBitmapClick(Sender: TObject);
begin
  if WMImages.boInitialize then begin
    FormAddNew := TFormAddNew.Create(Self);
    FormAddNew.ShowModal;
    FormAddNew.Free;
  end;
end;

procedure TFormMain.btnAutoPlayClick(Sender: TObject);
begin
  if WMImages.boInitialize then begin
    Timer.Enabled := True;
  end;
end;

procedure TFormMain.btnBatchInputClick(Sender: TObject);
begin
  if WMImages.boInitialize then begin
    FormBatchInput := TFormBatchInput.Create(Self);
    FormBatchInput.edtIndexStart.Text := '0';
    FormBatchInput.edtIndexEnd.Text := IntToStr(WMImages.ImageCount - 1);
    FormBatchInput.ShowModal;
    FormBatchInput.Free;
  end;
end;

procedure TFormMain.btnBatchOutClick(Sender: TObject);
begin
  if WMImages.boInitialize then begin
    FormBatchOut := TFormBatchOut.Create(Self);
    FormBatchOut.edtIndexStart.Text := '0';
    FormBatchOut.edtIndexEnd.Text := IntToStr(WMImages.ImageCount - 1);
    FormBatchOut.ShowModal;
    FormBatchOut.Free;
  end;
end;

procedure TFormMain.btnChangeXClick(Sender: TObject);
var
  sSTr: string;
begin
  if WMImages.boInitialize then begin
    FormMain.WMImages.GetImageInfo(DrawGrid.Row * 6 + DrawGrid.Col, @ImageInfo);
    sStr := InputBox('更改坐标', '请输入图片横坐标',
      IntToStr(ImageInfo.px));
    ImageInfo.px := StrToIntDef(sStr, ImageInfo.px);
    FormMain.WMImages.SetImageInfo(DrawGrid.Row * 6 + DrawGrid.Col, @ImageInfo);
    //WMImages.SetImageInfo(DrawGrid.Row * 6 + DrawGrid.Col, @ImageInfo);
    FormMain.DrawGrid.Repaint;
    RefShowLabel(FormMain.DrawGrid.Col, FormMain.DrawGrid.Row * 6);
  end;
end;

procedure TFormMain.btnChangeYClick(Sender: TObject);
var
  sStr: string;
begin
  if WMImages.boInitialize then begin
    FormMain.WMImages.GetImageInfo(DrawGrid.Row * 6 + DrawGrid.Col, @ImageInfo);
    sStr := InputBox('更改坐标', '请输入图片纵坐标',
      IntToStr(ImageInfo.py));
    ImageInfo.py := StrToIntDef(sStr, ImageInfo.py);
    FormMain.WMImages.SetImageInfo(DrawGrid.Row * 6 + DrawGrid.Col, @ImageInfo);
    //WMImages.SetImageInfo(DrawGrid.Row * 6 + DrawGrid.Col, @ImageInfo);
    FormMain.DrawGrid.Repaint;
    RefShowLabel(FormMain.DrawGrid.Col, FormMain.DrawGrid.Row * 6);
  end;
end;

procedure TFormMain.btnCreateWilClick(Sender: TObject);
begin
  FormCreateWil := TFormCreateWil.Create(Self);
  FormCreateWil.ShowModal;
  FormCreateWil.Free;
end;

procedure TFormMain.btnDelClick(Sender: TObject);
begin
  if WMImages.boInitialize then begin
    FormDelImg := TFormDelImg.Create(Self);
    FormDelImg.edtIndexStart.Text := IntToStr(DrawGrid.Row * 6 + DrawGrid.Col);
    FormDelImg.edtIndexEnd.Text := IntToStr(DrawGrid.Row * 6 + DrawGrid.Col);
    FormDelImg.ShowModal;
    FormDelImg.Free;
  end;
end;

procedure TFormMain.btnGotoClick(Sender: TObject);
begin
  if WMImages.boInitialize then begin
    SetDrawGridIndex(StrToIntDef(InputBox('跳转', '请输入图片索引号',
      '1'), 1));
  end;
end;

procedure TFormMain.btnInputClick(Sender: TObject);
var
  lsDib: TDIB;
  nSize, nIndex, position, nextposition: Integer;
  nNowSize, nLen, nDibSize: Integer;
begin
  if WMImages.boInitialize then begin
    if OpenPictureDialog.Execute(Handle) then begin
      if OpenPictureDialog.FileName <> '' then begin
        lsDib := TDIB.Create;
        try
          lsDib.LoadFromFile(OpenPictureDialog.FileName);
          lsDib := FormatDIB(lsDIB);
          nIndex := DrawGrid.Row * 6 + DrawGrid.Col;
          nSize := FormMain.WMImages.GetDibSize(lsDib);
          nDibSize := nSize;
          position := FormMain.WMImages.Getposition(nIndex);
          nextposition := FormMain.WMImages.GetNextposition(nIndex + 1);
          if (position > 0) and (nextposition > 0) and
           (nextposition >= position) then begin
              nNowSize := nextposition - position;
            if nNowSize < nSize then begin
              AppendData(FormMain.WMImages.FileName, nextposition,
                nSize - nNowSize); //申请空间
            end else begin
              nSize := nNowSize;
            end;
            if nDibSize > 0 then begin
              nLen := FormMain.WMImages.ReplaceImages(position, nIndex, 0, 0,
                lsDib)
            end else begin
              nLen := 0;
              FormMain.WMImages.m_IndexList.Items[nIndex] := nil;
            end;
            if nLen < nSize then begin
              RemoveData(FormMain.WMImages.FileName, position + nLen,
                nSize - nLen);
            end;
            nNowSize := nLen - nNowSize;
            FormMain.WMImages.UpdateIndex(nIndex, nNowSize);
            if FormMain.WMImages.Version = 2 then
              FormMain.WMImages.FHeader.IndexOffset :=
                FormMain.WMImages.FHeader.IndexOffset + nNowSize;

            WMImages.SaveIndex();
            FormMain.DrawGrid.Repaint;
            Application.MessageBox('导入图片成功', '提示信息', MB_OK or
              MB_ICONASTERISK);
          end else
            Application.MessageBox('导入图片失败', '提示信息', MB_OK or
              MB_ICONASTERISK);
        finally
          lsDib.Free;
        end;
      end
      else
        Application.MessageBox('导入图片失败', '提示信息', MB_OK or
          MB_ICONASTERISK);
    end
    else
      Application.MessageBox('导入图片失败', '提示信息', MB_OK or
        MB_ICONASTERISK);
  end;
end;

procedure TFormMain.btnNextClick(Sender: TObject);
begin
  if WMImages.boInitialize then begin
    if Sender = btnNext then
      SetDrawGridIndex(DrawGrid.Row * 6 + DrawGrid.Col + 1)
    else
      SetDrawGridIndex(DrawGrid.Row * 6 + DrawGrid.Col - 1);
  end;
end;

function TFormMain.SetDrawGridIndex(Index: Integer): Boolean;
begin
  Result := False;
  if WMImages.boInitialize then begin
    if (Index >= 0) and (Index <= (WMImages.ImageCount - 1)) then begin
      DrawGrid.Row := Index div 6;
      DrawGrid.Col := Index mod 6;
      Result := True;
    end;
  end;
end;

procedure TFormMain.TimerTimer(Sender: TObject);
begin
  if not SetDrawGridIndex(DrawGrid.Row * 6 + DrawGrid.Col + 1) then
    Timer.Enabled := False;
end;

procedure TFormMain.btnOpenDigClick(Sender: TObject);
begin
  if OpenDialog.Execute(Handle) then begin
    if OpenDialog.FileName <> '' then begin
      edtFileName.Text := OpenDialog.FileName;
      if WMImages.boInitialize then
        WMImages.Finalize;
      //WMImages.BitType := dbtAuto;
      //ComboBoxBitType.ItemIndex := 0;
      WMImages.FileName := Trim(edtFileName.Text);
      WMImages.Initialize;
      CKAutoCutOut.Checked := False;
      CKSetTransparentColor.Checked := False;
      ComboBox1.ItemIndex := 0;
      CKAutoCutOut.Enabled := (WMImages.Version = 2) and (WMImages.BitCount = 16);
      CKSetTransparentColor.Enabled := (WMImages.Version = 2) and (WMImages.BitCount = 16);
      EdTransparentColor.Enabled := (WMImages.Version = 2) and (WMImages.BitCount = 16);
      DrawGrid.RowCount := WMImages.ImageCount div 6 + 1;
      DrawGrid.Repaint;
      OpenDialog.FileName := '';
    end;
  end;
end;

procedure TFormMain.btnOutClick(Sender: TObject);
var
  position: Integer;
begin
  if WMImages.boInitialize then begin
    SavePictureDialog.FileName := GetIndexToStr(DrawGrid.Row * 6 + DrawGrid.Col)
      + '.bmp';
    if SavePictureDialog.Execute(Handle) then begin
      if SavePictureDialog.FileName <> '' then begin
        position := Integer(WMImages.m_IndexList.Items[DrawGrid.Row * 6 +
          DrawGrid.Col]);
        if not WMImages.MakeDIB(position) then begin
          WMImages.lsDib.Width := 1;
          WMImages.lsDib.Height := 1;
        end;
        WMImages.lsDib.SaveToFile(SavePictureDialog.FileName);
        Application.MessageBox('导出图片成功', '提示信息', MB_OK or
          MB_ICONASTERISK);
      end
      else
        Application.MessageBox('导出图片失败', '提示信息', MB_OK or
          MB_ICONASTERISK);
    end;
  end;
end;

procedure TFormMain.btnStopClick(Sender: TObject);
begin
  Timer.Enabled := False;
end;

procedure TFormMain.Button1Click(Sender: TObject);
begin
  if WMImages.boInitialize then begin
    FormSetXY := TFormSetXY.Create(Self);
    FormSetXY.edtIndexStart.Text := IntToStr(DrawGrid.Row * 6 + DrawGrid.Col);
    FormSetXY.edtIndexEnd.Text := IntToStr(DrawGrid.Row * 6 + DrawGrid.Col);
    FormSetXY.EditX.Text := '0';
    FormSetXY.EditY.Text := '0';
    FormSetXY.ShowModal;
    FormSetXY.Free;
  end;
end;

procedure TFormMain.chkJmpNilBitmapClick(Sender: TObject);
begin
  if chkJmpNilBitmap.Checked then begin
    Image1.Transparent := True;
  end
  else begin
    Image1.Transparent := False;
  end;
end;

procedure TFormMain.CKAutoCutOutClick(Sender: TObject);
begin
  if WMImages.boInitialize then begin
    WMImages.boAutoCutOut := CKAutoCutOut.Checked;
  end;
end;

procedure TFormMain.CKSetTransparentColorClick(Sender: TObject);
begin
  if WMImages.boInitialize then begin
    WMImages.boSetTransparentColor := CKSetTransparentColor.Checked;
    WMImages.TransparentColor := StrToIntDef(EdTransparentColor.Text, 0);
  end;
  EdTransparentColor.Enabled := not CKSetTransparentColor.Checked;
end;

procedure TFormMain.ComboBox1Change(Sender: TObject);
begin
  if WMImages.boInitialize then begin
    WMImages.ColorEffect := TColorEffect(ComboBox1.ItemIndex);
  end;
end;

procedure TFormMain.ComboBoxBitTypeChange(Sender: TObject);
begin
  {if WMImages.boInitialize then begin
    case ComboBoxBitType.ItemIndex of
      0: WMImages.BitType := dbtAuto;
      1: WMImages.BitType := dbt8Bit;
      2: WMImages.BitType := dbt16Bit;
      3: WMImages.BitType := dbt16Bit_555;
      4: WMImages.BitType := dbt16Bit_565;
      5: WMImages.BitType := dbt24Bit;
      6: WMImages.BitType := dbt32Bit;
    end;
    DrawGrid.Repaint;
  end;   }
end;

procedure TFormMain.DrawGridDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
  OldColor: TColor;
  BitMap, BitMap2: TBitmap;
  nRect, iRect: TRect;
  X, Y: Integer;
  Str: string;
  boStr: Boolean;
begin
  if WMImages.boInitialize then begin
    OldColor := 0;
    with DrawGrid.Canvas do begin
      if gdSelected in State then begin
        DrawGrid.Canvas.Brush.Color := clMenuHighlight;
        FillRect(Rect);
      end;
      BitMap := TBitmap.Create;
      BitMap2 := TBitmap.Create;
      WMImages.GetBitmap(ACol + ARow * 6, Bitmap);
      boStr := False;
      if (BitMap.Width > 1) then begin
        BitMap2.Width := _MIN(BitMap.Width, DrawGrid.DefaultColWidth);
        BitMap2.Height := _MIN(BitMap.Height, DrawGrid.DefaultRowHeight);
        if BitMap2.Height > (DrawGrid.DefaultRowHeight - 12) then
          boStr := True;
        BitMap2.Canvas.StretchDraw(BitMap2.Canvas.ClipRect, BitMap);
        BitMap2.TransparentColor := 0;
        BitMap2.Transparent := True;
        nRect.Left := 0;
        nRect.Top := 0;
        nRect.Right := Bitmap2.Width;
        nRect.Bottom := Bitmap2.Height;
        iRect := Rect;
        iRect.Right := iRect.Left + _MIN(BitMap2.Width, DrawGrid.DefaultColWidth);
        iRect.Bottom := iRect.Top + _MIN(BitMap2.Height,
          DrawGrid.DefaultRowHeight);

        DrawGrid.Canvas.BrushCopy(iRect, Bitmap2, nRect, 0);
      end;

      BitMap.Free;
      Bitmap2.Free;
      if (ACol + ARow * 6) <= (WMImages.ImageCount - 1) then begin
        SetBkMode(Handle, TRANSPARENT);
        Str := GetIndexToStr(ACol + ARow * 6);
        X := Rect.Right - DrawGrid.Canvas.TextWidth(Str);
        Y := Rect.Bottom - DrawGrid.Canvas.TextHeight(Str);
        if boStr then begin
          Font.Color := clBlack;
          DrawGrid.Canvas.TextOut(X - 1, Y, Str);
          DrawGrid.Canvas.TextOut(X + 1, Y, Str);
          DrawGrid.Canvas.TextOut(X, Y - 1, Str);
          DrawGrid.Canvas.TextOut(X, Y + 1, Str);
        end;
        if boStr then Font.Color := clWhite
        else Font.Color := clBlack;
        DrawGrid.Canvas.TextOut(X, Y, Str);
        if gdSelected in State then begin
          Font.Color := OldColor;
        end;
      end;
    end;
  end;
end;

procedure TFormMain.DrawGridSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
var
  BitMap: TBitmap;
begin
  if WMImages.boInitialize then begin
    BitMap := TBitmap.Create;
    WMImages.GetBitmap(ACol + ARow * 6, Bitmap);
    if (BitMap.Width > 1) then ImageInfo := WMImages.imginfo
    else FillChar(ImageInfo, SizeOf(ImageInfo), #0);
    Image1.Picture.Bitmap := Bitmap;
    Image1.Picture.Bitmap.TransparentColor := 0;
    BitMap.Free;
    RefShowLabel(ACol, ARow);
    rbZoom100Click(nil);
  end;
end;

procedure TFormMain.FormCreate(Sender: TObject);
var
  Res: TResourceStream;
begin
  Res := TResourceStream.Create(Hinstance, '256RGB', 'RGB');
  try
    Res.Read(DefMainPalette, SizeOf(DefMainPalette));
  finally
    Res.Free;
  end;
end;

procedure TFormMain.FormDestroy(Sender: TObject);
begin
  if WMImages.boInitialize then
    WMImages.Finalize;
end;

procedure TFormMain.rbZoom100Click(Sender: TObject);
var
  boTop: Boolean;
begin
  boTop := False;
  if rbZoom50.Checked then begin
    Image1.AutoSize := False;
    Image1.Stretch := True;
    Image1.Width := Image1.Picture.Width div 2;
    Image1.Height := Image1.Picture.Height div 2;
  end
  else if rbZoom200.Checked then begin
    Image1.AutoSize := False;
    Image1.Stretch := True;
    Image1.Width := Image1.Picture.Width * 2;
    Image1.Height := Image1.Picture.Height * 2;
  end
  else if rbZoom400.Checked then begin
    Image1.AutoSize := False;
    Image1.Stretch := True;
    Image1.Width := Image1.Picture.Width * 4;
    Image1.Height := Image1.Picture.Height * 4;
  end
  else if rbZoom800.Checked then begin
    Image1.AutoSize := False;
    Image1.Stretch := True;
    Image1.Width := Image1.Picture.Width * 8;
    Image1.Height := Image1.Picture.Height * 8;
  end
  else if rbZoomAuto.Checked then begin
    if (Image1.Picture.Width > ScrollBox.Width) or (Image1.Picture.Height >
      ScrollBox.Height) then begin
      boTop := True;
      Image1.AutoSize := False;
      Image1.Stretch := True;
      if Image1.Picture.Width > ScrollBox.Width then
        Image1.Width := ScrollBox.Width - 10
      else
        Image1.Width := Image1.Picture.Width;
      if Image1.Picture.Width > ScrollBox.Height then
        Image1.Height := ScrollBox.Height - 10
      else
        Image1.Height := Image1.Picture.Height;
    end
    else begin
      Image1.AutoSize := True;
    end;
  end
  else
    Image1.AutoSize := True;

  if not boTop then begin
    if chkLineShow.Checked then begin
      Image1.Left := _MAX(ScrollBox.Width div 2 + ImageInfo.px, 0);
      Image1.Top := _MAX(ScrollBox.Height div 2 + ImageInfo.py, 0);
    end
    else begin
      Image1.Left := _MAX(ScrollBox.Width div 2 - Image1.Width div 2, 0);
      Image1.Top := _MAX(ScrollBox.Height div 2 - Image1.Height div 2, 0);
    end;
  end
  else begin
    Image1.Left := 0;
    Image1.Top := 0;
  end;
end;

procedure TFormMain.RefShowLabel(ACol, ARow: Integer);
begin
  if not WMImages.boInitialize then
    Exit;
  if WMImages.Version > 1 then begin
    if WmImages.BitCount = 16 then lblClass.Caption := 'MIR2  新格式(16位真彩)'
    else lblClass.Caption := 'MIR2  新格式(256色)';
  end
  else if WMImages.Version = 1 then begin
    lblClass.Caption := 'MIR2  通用数据格式(2)';
  end
  else
    lblClass.Caption := 'MIR2  通用数据格式(1)';
  lblSize.Caption := Format('%d*%d', [ImageInfo.nWidth, ImageInfo.nHeight]);
  lblX.Caption := IntToStr(ImageInfo.px);
  lblY.Caption := IntToStr(ImageInfo.py);
  lblIndex.Caption := Format('%d/%d', [ARow * 6 + ACol, (WMImages.ImageCount -
      1)]);
end;

procedure TFormMain.ScrollBoxResize(Sender: TObject);
begin
  rbZoom100Click(nil);
end;

end.

