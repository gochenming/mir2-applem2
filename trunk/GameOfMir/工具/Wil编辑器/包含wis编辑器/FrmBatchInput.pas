unit FrmBatchInput;

interface

uses
  Windows, Messages, SysUtils, StrUtils, Variants, Classes, Graphics, Controls,
  Forms,
  Dialogs, ComCtrls, StdCtrls;

type
  TFormBatchInput = class(TForm)
    GroupBox1: TGroupBox;
    rbImageAndXY: TRadioButton;
    rbImage: TRadioButton;
    rbXY: TRadioButton;
    Button1: TButton;
    edtSaveDir: TEdit;
    Label1: TLabel;
    GroupBox2: TGroupBox;
    edtIndexStart: TEdit;
    edtIndexEnd: TEdit;
    Label3: TLabel;
    Label2: TLabel;
    GroupBox3: TGroupBox;
    rbRumpAdd: TRadioButton;
    rbIndexInsert: TRadioButton;
    rbIndexBestrow: TRadioButton;
    GroupBox4: TGroupBox;
    rbXYFile: TRadioButton;
    rbSetXY: TRadioButton;
    edtXY: TEdit;
    btnExit: TButton;
    btnGo: TButton;
    ProgressBar: TProgressBar;
    CheckBox1: TCheckBox;
    procedure btnExitClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure rbRumpAddClick(Sender: TObject);
    procedure rbImageAndXYClick(Sender: TObject);
    procedure btnGoClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    procedure GetImageXY(sFileName: string; var X, Y: Integer);
  public
    { Public declarations }
  end;

var
  FormBatchInput: TFormBatchInput;
  XYList: TStringList;
  FIleList: TStringList;
  ShadowList: TStringList;

implementation

uses
  Share, FrmMain, Wil, DIB, HUtil32, wmUtil;

{$R *.dfm}

procedure TFormBatchInput.btnExitClick(Sender: TObject);
begin
  Close;
end;

procedure TFormBatchInput.btnGoClick(Sender: TObject);
var
  m_SaveDir, TempStr: string;
  m_SaveXYDir, sX, sY: string;
  StartInt, EndInt: Integer;
  X, Y, II, position, nSize, nextposition, nX, nY: Integer;
//  ImageInfo: TWMImageInfo;
  lsDIb, ShadowDIB, TempDIB: TDIB;
  nMaxSize, nNowSize, nLen, nWhiteSize, nLong: Integer;
  pimginfo: TWMImageInfo;

  procedure GetXYFileList(SaveDir: string);
  var
    sr: TSearchRec;
    I: Integer;
  begin
    XYList.Clear;
    I := FindFirst(SaveDir + '*.txt', faAnyFile, sr);
    while i = 0 do begin
      if (Sr.Attr and faDirectory) = 0 then begin
        if sr.Name[1] <> '.' then begin
          XYList.Add(SaveDir + sr.Name);
        end;
      end;
      i := FindNext(sr);
    end;
    FindClose(sr);
  end;

  procedure GetImagesFileList(SaveDir: string);
  var
    sr: TSearchRec;
    I: Integer;
  begin
    FIleList.Clear;
    ShadowList.Clear;
    I := FindFirst(SaveDir + '*.bmp', faAnyFile, sr);
    while i = 0 do begin
      if (Sr.Attr and faDirectory) = 0 then begin
        if sr.Name[1] <> '.' then begin
          if CheckBox1.Checked then
            ShadowList.Add(SaveDir + 'Shadow\' + sr.Name);
          FIleList.Add(SaveDir + sr.Name);
        end;
      end;
      i := FindNext(sr);
    end;
    FindClose(sr);
  end;

  procedure GetImageFileXY(Filename: string; var x, Y: Integer);
  var
    FIdxFile: string;
  begin
    FIdxFile := ExtractFilePath(Filename) + SaveXYDir + ExtractFileNameOnly(Filename) + '.txt';
    GetImageXY(FIdxFile, x, Y);
  end;

  procedure UniteShadow(ImgDib, ShadowDIB: TDIB; nx, ny: Integer; var x, y: Integer);
  var
    addx, addy, maxwidth, maxheight, ax, ay, nColor: integer;
  begin
    if (ImgDIb.Width > 1) and (ImgDIB.Height > 1) and (ShadowDIB.Width > 1) and (ShadowDIB.Height > 1) then begin
      ImgDIb.PixelFormat.RBitMask := $FF0000;
      ImgDIb.PixelFormat.GBitMask := $00FF00;
      ImgDIb.PixelFormat.BBitMask := $0000FF;
      ImgDIb.BitCount := 24;
      ShadowDIB.PixelFormat.RBitMask := $FF0000;
      ShadowDIB.PixelFormat.GBitMask := $00FF00;
      ShadowDIB.PixelFormat.BBitMask := $0000FF;
      ShadowDIB.BitCount := 24;
      if nx < 0 then begin
        addx := -nx;
      end else
        addx := 0;
      if ny < 0 then
        addy := -ny
      else addy := 0;

      nx := addx + abs(nx);
      ny := addy + abs(ny);
      maxwidth := shadowdib.Width + nx;
      if maxwidth mod 2 <> 0 then
        Inc(maxwidth);
      maxheight := shadowdib.Height + ny;
      x := x - addx;
      y := y - addy;

      tempdib.DrawTransparent(ShadowDIB, nX, nY, ShadowDIB.Width, ShadowDIB.Height, 0, 0, 0);

      for aX := nX to ShadowDIB.Width + nX do
        for ay := nY to ShadowDIB.Height + nY do begin
          nColor := tempdib.Pixels[ax, ay];
          if nColor <> 0 then begin
            if (Odd(ax + x) and Odd(ay + y)) or (not Odd(ax + x) and not Odd(ay + y)) then
              tempdib.Pixels[ax, ay] := $080810
            else
              tempdib.Pixels[ax, ay] := 0;
          end;
        end;
      tempdib.DrawTransparent(ImgDIB, addx, addy, ImgDIB.Width, ImgDIB.Height, 0, 0, 0);
      //ImgDIB.Fill($FFFF);
      if ImgDIB.Width < maxwidth then
        ImgDIB.Width := maxwidth;
      if ImgDIB.Height < maxheight then
        ImgDIB.Height := maxheight;
      ImgDIB.Canvas.Draw(0, 0, tempdib);
    end;

  end;
begin
  if not FormMain.WMImages.boInitialize then
    exit;
  if (Trim(edtSaveDir.Text) <> '') or (rbXY.Checked and rbIndexBestrow.Checked and rbSetXY.Checked) then begin
    m_SaveDir := Trim(edtSaveDir.Text);
    if RightStr(m_SaveDir, 1) <> '\' then
      m_SaveDir := m_SaveDir + '\';
    m_SaveXYDir := m_SaveDir + SaveXYDir;
    StartInt := StrToIntDef(edtIndexStart.Text, -1);
    EndInt := StrToIntDef(edtIndexEnd.Text, -1);
    TempStr := edtXY.Text;
    TempStr := GetValidStr3(TempStr, sX, [' ', ',']);
    TempStr := GetValidStr3(TempStr, sY, [' ', ',']);
    X := StrToIntDef(sX, 0);
    Y := StrToIntDef(sY, 0);
    if (not rbImageAndXY.Checked) or rbIndexInsert.Checked or
      rbIndexBestrow.Checked then begin
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
      if (not rbIndexInsert.Checked) or rbIndexBestrow.Checked then begin
        if (StartInt > EndInt) then begin
          Application.MessageBox('图片起始编号设置错误，不能大于结速编号', '提示信息', MB_OK or MB_ICONASTERISK);
          exit;
        end;
      end;
    end;
    if rbXY.Checked and rbIndexBestrow.Checked then begin //写坐标
      if rbXYFile.Checked then begin
        GetXYFileList(m_SaveDir);
        if (EndInt - StartInt) >= XYList.Count then begin
          Application.MessageBox('坐标文件数量不够', '提示信息',
            MB_OK or
            MB_ICONASTERISK);
          exit;
        end;
      end;
      for II := StartInt to EndInt do begin
        if rbXYFile.Checked then begin
          GetImageXY(XYList[II - StartInt], X, Y);
        end;
        FormMain.WMImages.GetImageInfo(II, @pimginfo);
        pimginfo.px := x;
        pimginfo.py := y;
        FormMain.WMImages.SetImageInfo(II, @pimginfo);
        ProgressBar.Position := Trunc((II - StartInt) / (EndInt - StartInt) *
          100);
      end;
    end
    else if rbImageAndXY.Checked and rbRumpAdd.Checked then begin
      GetImagesFileList(m_SaveDir); //图片尾部增加
      lsDIb := TDIB.Create;
      ShadowDIB := TDIB.Create;
      TempDIB := TDIB.Create;
      tempdib.PixelFormat.RBitMask := $FF0000;
      tempdib.PixelFormat.GBitMask := $00FF00;
      tempdib.PixelFormat.BBitMask := $0000FF;
      tempdib.BitCount := 24;
      tempdib.Width := 400;
      tempdib.Height := 600;
      try
        for II := 0 to FileList.Count - 1 do begin
          lsDIb.Clear;
          lsDIb.LoadFromFile(FIleList[II]);
          lsDib := FormatDIB(lsDIB);
          if rbXYFile.Checked then begin
            GetImageFileXY(FIleList[II], x, y);
          end;
          if CheckBox1.Checked then begin
            ShadowDIB.Clear;
            TempDIB.Fill(0);
            ShadowDIB.LoadFromFile(ShadowList[II]);
            GetImageFileXY(ShadowList[II], nX, ny);
            UniteShadow(lsDIB, ShadowDIB, nx - x, ny - y, x, y);
          end;
          FormMain.WMImages.AddImages(x, y, lsDib);
          ProgressBar.Position := Trunc(II / (FileList.Count - 1) * 100);
        end;
      finally
        lsDIb.Free;
        ShadowDIB.Free;
        TempDIB.Free;
      end;
    end
    else if rbImageAndXY.Checked and rbIndexBestrow.Checked then begin
      GetImagesFileList(m_SaveDir); //图片坐标覆盖
      if (EndInt - StartInt) >= FIleList.Count then begin
        Application.MessageBox('图片文件数量不够', '提示信息', MB_OK
          or MB_ICONASTERISK);
        exit;
      end;
      lsDIb := TDIB.Create;
      try
        nMaxSize := 0;
        for II := StartInt to EndInt do begin
          lsDIb.LoadFromFile(FIleList[II - StartInt]);
          lsDib := FormatDIB(lsDIB);
          nSize := FormMain.WMImages.GetDibSize(lsDib);
          Inc(nMaxSize, nSize);
        end;
        position := FormMain.WMImages.Getposition(StartInt);
        nextposition := FormMain.WMImages.GetNextposition(EndInt + 1);
        if (position > 0) and (nextposition > 0) and
           (nextposition >= position) then begin
          nNowSize := nextposition - position;
          if nNowSize < nMaxSize then begin
            AppendData(FormMain.WMImages.FileName, nextposition,
              nMaxSize - nNowSize); //申请空间
          end else begin
            nMaxSize := nNowSize;
          end;
          nWhiteSize := 0;
          for II := StartInt to EndInt do begin
            lsDIb.LoadFromFile(FIleList[II - StartInt]);
            lsDib := FormatDIB(lsDIB);
            if rbXYFile.Checked then begin
              GetImageFileXY(FIleList[II - StartInt], x, y);
            end;
            nSize := FormMain.WMImages.GetDibSize(lsDib);
            if nSize > 0 then begin
              nLen := FormMain.WMImages.ReplaceImages(position + nWhiteSize, ii, x, y,
                lsDib);
              Inc(nWhiteSize, nLen);
            end else begin
              FormMain.WMImages.m_IndexList.Items[ii] := nil;
            end;
            ProgressBar.Position := Trunc((II - StartInt) / (EndInt - StartInt)
              * 100);
          end;
          if nWhiteSize < nMaxSize then begin
            RemoveData(FormMain.WMImages.FileName, position + nWhiteSize,
              nMaxSize - nWhiteSize);
          end;
          nNowSize := nWhiteSize - nNowSize;
          FormMain.WMImages.UpdateIndex(EndInt, nNowSize);
          if FormMain.WMImages.Version = 2 then
            FormMain.WMImages.FHeader.IndexOffset :=
              FormMain.WMImages.FHeader.IndexOffset + nNowSize;
        end;
      finally
        lsDIb.Free;
      end;
    end
    else if rbImageAndXY.Checked and rbIndexInsert.Checked then begin
      GetImagesFileList(m_SaveDir); //图片坐标插入
      lsDIb := TDIB.Create;
      try
        nMaxSize := 0;
        for II := 0 to FIleList.Count - 1 do begin
          lsDIb.LoadFromFile(FIleList[II]);
          lsDib := FormatDIB(lsDIB);
          nSize := FormMain.WMImages.GetDibSize(lsDib);
          Inc(nMaxSize, nSize);
        end;
        position := FormMain.WMImages.Getposition(StartInt);
        if position > 0 then begin  //申请空间
          AppendData(FormMain.WMImages.FileName, position, nMaxSize);
          nWhiteSize := 0;
          for II := 0 to FIleList.Count - 1 do begin
            lsDIb.LoadFromFile(FIleList[II]);
            lsDib := FormatDIB(lsDIB);
            if rbXYFile.Checked then begin
              GetImageFileXY(FIleList[II], x, y);
            end;
            nSize := FormMain.WMImages.GetDibSize(lsDib);
            if nSize > 0 then begin
              FormMain.WMImages.m_IndexList.Insert(StartInt + ii, nil);
              nLen := FormMain.WMImages.ReplaceImages(position + nWhiteSize,
                StartInt + ii, x, y, lsDib);
              Inc(nWhiteSize, nLen);
            end else begin
              FormMain.WMImages.m_IndexList.Insert(StartInt + ii, nil);
            end;
            ProgressBar.Position := Trunc((II) / (FIleList.Count - 1) * 100);
          end;
          if nWhiteSize < nMaxSize then begin
            RemoveData(FormMain.WMImages.FileName, position + nWhiteSize,
              nMaxSize - nWhiteSize);
          end;
          FormMain.WMImages.UpdateIndex(StartInt + FIleList.Count - 1,
            nWhiteSize);
          if FormMain.WMImages.Version = 2 then
            FormMain.WMImages.FHeader.IndexOffset :=
              FormMain.WMImages.FHeader.IndexOffset + nWhiteSize;
        end;
      finally
        lsDIb.Free;
      end;
    end
    else if rbImage.Checked and rbIndexBestrow.Checked then begin
      GetImagesFileList(m_SaveDir); //图片覆盖
      if (EndInt - StartInt) >= FIleList.Count then begin
        Application.MessageBox('图片文件数量不够', '提示信息', MB_OK
          or MB_ICONASTERISK);
        exit;
      end;
      lsDIb := TDIB.Create;
      try
        nMaxSize := 0;
        for II := StartInt to EndInt do begin
          lsDIb.LoadFromFile(FIleList[II - StartInt]);
          lsDib := FormatDIB(lsDIB);
          nSize := FormMain.WMImages.GetDibSize(lsDib);
          Inc(nMaxSize, nSize);
          FormMain.WMImages.GetImageInfo(II, @pimginfo);
          FIleList.Objects[II - StartInt] :=
            TObject(MakeLong(pimginfo.px, pimginfo.py));
        end;
        position := FormMain.WMImages.Getposition(StartInt);
        nextposition := FormMain.WMImages.GetNextposition(EndInt + 1);
        if (position > 0) and (nextposition > 0) and
           (nextposition >= position) then begin
          nNowSize := nextposition - position;
          if nNowSize < nMaxSize then begin
            AppendData(FormMain.WMImages.FileName, nextposition,
              nMaxSize - nNowSize); //申请空间
          end else begin
            nMaxSize := nNowSize;
          end;
          nWhiteSize := 0;
          for II := StartInt to EndInt do begin
            lsDIb.LoadFromFile(FIleList[II - StartInt]);
            lsDib := FormatDIB(lsDIB);
            nLong := Integer(FIleList.Objects[II - StartInt]);
            x := LoWord(nLong);
            y := HiWord(nLong);
            nSize := FormMain.WMImages.GetDibSize(lsDib);
            if nSize > 0 then begin
              nLen := FormMain.WMImages.ReplaceImages(position + nWhiteSize, ii, x, y,
                lsDib);
              Inc(nWhiteSize, nLen);
            end else begin
              FormMain.WMImages.m_IndexList.Items[ii] := nil;
            end;
            ProgressBar.Position := Trunc((II - StartInt) / (EndInt - StartInt)
              * 100);
          end;
          if nWhiteSize < nMaxSize then begin
            RemoveData(FormMain.WMImages.FileName, position + nWhiteSize,
              nMaxSize - nWhiteSize);
          end;
          nNowSize := nWhiteSize - nNowSize;
          FormMain.WMImages.UpdateIndex(EndInt, nNowSize);
          if FormMain.WMImages.Version = 2 then
            FormMain.WMImages.FHeader.IndexOffset :=
              FormMain.WMImages.FHeader.IndexOffset + nNowSize;
        end;
      finally
        lsDIb.Free;
      end;
    end;
    FormMain.WMImages.SaveIndex();
    FormMain.DrawGrid.RowCount := FormMain.WMImages.ImageCount div 6 + 1;
    FormMain.DrawGrid.Repaint;
    Application.MessageBox('批量导入完成', '提示信息', MB_OK or
      MB_ICONASTERISK);
    Close;

  end
  else
    Application.MessageBox('请先选择图片文件夹位置', '提示信息',
      MB_OK or MB_ICONASTERISK);
end;

procedure TFormBatchInput.GetImageXY(sFileName: string; var X, Y: Integer);
var
  StringList: TStringList;
begin
  X := 0;
  Y := 0;
  StringList := TStringList.Create;
  try
    if FileExists(sFileName) then begin
      StringList.LoadFromFile(sFileName);
      if StringList.Count > 0 then
        X := StrToIntDef(StringList[0], 0);
      if StringList.Count > 1 then
        Y := StrToIntDef(StringList[1], 0);
    end;
  finally
    StringList.Free;
  end;
end;

procedure TFormBatchInput.Button1Click(Sender: TObject);
var
  sStr: string;
begin
  sStr := BrowseForFolder(Handle, '请选择图片文件夹');
  if sStr <> '' then begin
    edtSaveDir.Text := sStr;
  end;
end;

procedure TFormBatchInput.FormCreate(Sender: TObject);
begin
  XYList := TStringList.Create;
  FIleList := TStringList.Create;
  ShadowList := TStringList.Create;
end;

procedure TFormBatchInput.FormDestroy(Sender: TObject);
begin
  XYList.Free;
  FIleList.Free;
  ShadowList.Free;
end;

procedure TFormBatchInput.rbImageAndXYClick(Sender: TObject);
begin
  if rbImageAndXY.Checked then begin
    rbRumpAdd.Enabled := true;
    rbIndexInsert.Enabled := true;
    rbXYFile.Enabled := True;
    rbSetXY.Enabled := true;
  end
  else if rbImage.Checked then begin
    rbRumpAdd.Enabled := False;
    rbIndexInsert.Enabled := False;
    rbXYFile.Enabled := False;
    rbSetXY.Enabled := False;
    rbIndexBestrow.Checked := True;
  end
  else begin
    rbRumpAdd.Enabled := False;
    rbIndexInsert.Enabled := False;
    rbXYFile.Enabled := True;
    rbSetXY.Enabled := True;
    rbIndexBestrow.Checked := True;
  end;
  rbRumpAddClick(nil);
end;

procedure TFormBatchInput.rbRumpAddClick(Sender: TObject);
begin
  if rbRumpAdd.Checked then begin
    Label2.Enabled := False;
    Label3.Enabled := False;
    edtIndexStart.Enabled := False;
    edtIndexEnd.Enabled := False;
  end
  else if rbIndexInsert.Checked then begin
    Label2.Enabled := True;
    Label3.Enabled := False;
    edtIndexStart.Enabled := True;
    edtIndexEnd.Enabled := False;
  end
  else begin
    Label2.Enabled := True;
    Label3.Enabled := True;
    edtIndexStart.Enabled := True;
    edtIndexEnd.Enabled := True;
  end;
end;

end.

