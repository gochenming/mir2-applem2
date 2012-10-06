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
  X, Y, II, posinect, nSize: Integer;
  ImageInfo: TWMImageInfo;
  lsDIb: TDIB;
  List: TList;
  nMaxSize: Integer;

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
    I := FindFirst(SaveDir + '*.bmp', faAnyFile, sr);
    while i = 0 do begin
      if (Sr.Attr and faDirectory) = 0 then begin
        if sr.Name[1] <> '.' then begin
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
    FIdxFile := ExtractFilePath(Filename) + SaveXYDir +
      ExtractFileNameOnly(Filename) +
      '.txt';
    GetImageXY(FIdxFile, x, Y);
  end;
begin
  if not FormMain.WMImages.boInitialize then
    exit;
  if (Trim(edtSaveDir.Text) <> '') or (rbXY.Checked and rbIndexBestrow.Checked
    and rbSetXY.Checked) then begin
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
        posinect := Integer(FormMain.WMImages.m_IndexList.Items[II]);
        FormMain.WMImages.MakeDIB(posinect, True);
        if rbXYFile.Checked then begin
          GetImageXY(XYList[II - StartInt], X, Y);
        end;
        FormMain.WMImages.imginfo.px := x;
        FormMain.WMImages.imginfo.py := y;
        FormMain.WMImages.SetImageInfo(II, @FormMain.WMImages.imginfo);
        ProgressBar.Position := Trunc((II - StartInt) / (EndInt - StartInt) *
          100);
      end;
    end
    else if rbImageAndXY.Checked and rbRumpAdd.Checked then begin
      GetImagesFileList(m_SaveDir); //图片尾部增加
      lsDIb := TDIB.Create;
      try
        for II := 0 to FileList.Count - 1 do begin
          lsDIb.LoadFromFile(FIleList[II]);
          if rbXYFile.Checked then begin
            GetImageFileXY(FIleList[II], x, y);
          end;
          FormMain.WMImages.AddImages(x, y, lsDib);
          ProgressBar.Position := Trunc(II / (FileList.Count - 1) * 100);
        end;
      finally
        lsDIb.Free;
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
      List := TList.Create;
      try
        nMaxSize := 0;
        for II := StartInt to EndInt do begin
          lsDIb.Clear;
          lsDIb.LoadFromFile(FIleList[II - StartInt]);
          nSize := FormMain.WMImages.GetDibSize(lsDib) +
            FormMain.WMImages.GetImageHeaderSize;
          List.Add(Pointer(nSize));
          Inc(nMaxSize, nSize);
        end;
        //提前一次性申请空间，免除重复申请浪费时间
        FormMain.WMImages.ReplaceImagesGetRoom(StartInt, EndInt, nMaxSize,
          List);
        for II := StartInt to EndInt do begin
          lsDIb.Clear;
          lsDIb.LoadFromFile(FIleList[II - StartInt]);
          if rbXYFile.Checked then begin
            GetImageFileXY(FIleList[II - StartInt], x, y);
          end;
          FormMain.WMImages.InsertImages(Integer(List.Items[II - StartInt]),
            x, y, lsDib);

          ProgressBar.Position := Trunc((II - StartInt) / (EndInt - StartInt) *
            100);
        end;
      finally
        lsDIb.Free;
        List.Free;
      end;
    end
    else if rbImageAndXY.Checked and rbIndexInsert.Checked then begin
      GetImagesFileList(m_SaveDir); //图片坐标插入
      lsDIb := TDIB.Create;
      List := TList.Create;
      try
        nMaxSize := 0;
        for II := 0 to FIleList.Count - 1 do begin
          lsDIb.Clear;
          lsDIb.LoadFromFile(FIleList[II]);
          nSize := FormMain.WMImages.GetDibSize(lsDib) +
            FormMain.WMImages.GetImageHeaderSize;
          List.Add(Pointer(nSize));
          Inc(nMaxSize, nSize);
        end;
        //提前一次性申请空间，免除重复申请浪费时间
        FormMain.WMImages.InsertImagesGetRoom(StartInt, nMaxSize, List);
        for II := 0 to FIleList.Count - 1 do begin
          lsDIb.Clear;
          lsDIb.LoadFromFile(FIleList[II]);
          if rbXYFile.Checked then begin
            GetImageFileXY(FIleList[II], x, y);
          end;
          FormMain.WMImages.InsertImages(Integer(List.Items[II]),
            x, y, lsDib);

          ProgressBar.Position := Trunc((II) / (FIleList.Count - 1) *
            100);
        end;
      finally
        lsDIb.Free;
        List.Free;
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
      List := TList.Create;
      try
        nMaxSize := 0;
        for II := StartInt to EndInt do begin
          lsDIb.Clear;
          lsDIb.LoadFromFile(FIleList[II - StartInt]);
          nSize := FormMain.WMImages.GetDibSize(lsDib) +
            FormMain.WMImages.GetImageHeaderSize;
          List.Add(Pointer(nSize));
          Inc(nMaxSize, nSize);
        end;
        //提前一次性申请空间，免除重复申请浪费时间
        FormMain.WMImages.ReplaceImagesGetRoom(StartInt, EndInt, nMaxSize,
          List);
        for II := StartInt to EndInt do begin
          lsDIb.Clear;
          lsDIb.LoadFromFile(FIleList[II - StartInt]);
          FormMain.WMImages.InsertImages(Integer(List.Items[II - StartInt]),
            -9999, 0, lsDib);

          ProgressBar.Position := Trunc((II - StartInt) / (EndInt - StartInt) *
            100);
        end;
      finally
        lsDIb.Free;
        List.Free;
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
end;

procedure TFormBatchInput.FormDestroy(Sender: TObject);
begin
  XYList.Free;
  FIleList.Free;
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

