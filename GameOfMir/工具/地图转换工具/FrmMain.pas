unit FrmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, WIL, wmMyImage, ShlObj,
  Dialogs, StdCtrls, DropGroupPas, ComCtrls, MapShare, RzTreeVw, wmM2Def, IniFiles;

type
  TFormMain = class(TForm)
    DropFile: TDropFileGroupBox;
    lbl1: TLabel;
    edtFileName: TEdit;
    btnOpenFile: TButton;
    grp1: TGroupBox;
    pbOpenFile: TProgressBar;
    lblOpenFileHint: TLabel;
    lbl3: TLabel;
    tvFileInfo: TRzCheckTree;
    grp2: TGroupBox;
    grp3: TGroupBox;
    lbl2: TLabel;
    edtOutData: TEdit;
    btnOutData: TButton;
    edtInData: TEdit;
    btnInObjects: TButton;
    lbl6: TLabel;
    lbl4: TLabel;
    lblOutCount: TLabel;
    lblInCount: TLabel;
    lbl8: TLabel;
    btn1: TButton;
    pb1: TProgressBar;
    lbl5: TLabel;
    lbl7: TLabel;
    cbbInFileName: TComboBox;
    lbl9: TLabel;
    lbl10: TLabel;
    btnLoad: TButton;
    dlgOpen: TOpenDialog;
    procedure DropFileDropFile(Sender: TObject);
    procedure btnOpenFileClick(Sender: TObject);
    procedure btnInObjectsClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure tvFileInfoStateChange(Sender: TObject; Node: TTreeNode; NewState: TRzCheckState);
    procedure btnOutDataClick(Sender: TObject);
    procedure cbbInFileNameChange(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure btnLoadClick(Sender: TObject);
  private
    procedure AnalyseMapInfo();
    procedure AnalyseImagesInfo();
    procedure WriteLog(sMsg: string);
    function LoadWriteImageInfo(sFileName: string): Boolean;
    procedure SaveWriteImageInfo(sFileName: string);
    function WriteImageToNewFile(sFileName: string; const ImagesList: TList; nIdx, nInIdx, nMaxCount: Integer; var nCount: Integer): Boolean;
    function WriteNewMapInfo(sFileName: string): Boolean;
    function FormatBitmap(const Bitmap: TBitmap; var Data: PChar): Integer;
    function EncodeRLE(const Source, Target: Pointer; Count: Integer; BPP: Integer = 2): Integer;
    procedure OpenInData();
  public
    FWMImages: TWMMyImageImages;
    FOutCount: Integer;
    FInCount: Integer;
    FInIndex: Integer;
    FSetupINI: TINIFile;
    procedure LoadFileLock(boLock: Boolean);
    procedure ChangeFileLock(boLock: Boolean);
  end;

var
  FormMain: TFormMain;

implementation

uses FrmEdit;

{$R *.dfm}
{$R ColorTable.RES}

procedure TFormMain.AnalyseImagesInfo;
  procedure AddImageToNode(ImageTag: pTImageTag; sTitle: string; nIndex: Integer);
  var
    MNode, UpNode: TTreeNode;
    I, nCount, nUpIndex, nSubCount: Integer;
  begin
    MNode := tvFileInfo.Items.Add(nil, sTitle);
    nCount := 0;
    UpNode := nil;
    nUpIndex := -10;
    nSubCount := 0;
    for I := Low(TImageTag) to High(TImageTag) do begin
      if ImageTag[I] then begin
        if UpNode <> nil then begin
          if (I - 1) = nUpIndex then begin
            tvFileInfo.Items.AddChild(UpNode, Format('%.6d', [I - 1])).Data := Pointer(nIndex);
            UpNode.Data := nil;
            nSubCount := 1;
          end;
          tvFileInfo.Items.AddChild(UpNode, Format('%.6d', [I])).Data := Pointer(nIndex);
          Inc(nSubCount);
        end
        else begin
          UpNode := tvFileInfo.Items.AddChild(MNode, Format('%.6d', [I]));
          UpNode.Data := Pointer(nIndex);
          nUpIndex := I;
        end;
        Inc(nCount);
      end
      else begin
        if (UpNode <> nil) and ((I - 1) <> nUpIndex) then begin
          UpNode.Text := UpNode.Text + ' - ' + Format('%.6d (%d)', [I - 1, nSubCount]);
        end;
        UpNode := nil;
        nSubCount := 0;
      end;
    end;
    MNode.Text := sTitle + ' (' + IntToStr(nCount) + ')';
  end;
var
  I: Integer;
begin
  if boUseTile then begin
    AddImageToNode(@Tiles, 'Tiles.wil', 0);
  end;   {
  if boUseSmTile then begin
    AddImageToNode(@SmTiles, 'SmTiles.wil');
  end;   }
  for I := Low(UseImages) to High(UseImages) do begin
    if UseObject[I] then
      AddImageToNode(@UseImages[I], GetObjectsName(I), I + 1);
  end;
  FillChar(UseImages[0][0], SizeOf(UseImages), False);
  FOutCount := 0;
  lblOutCount.Caption := '0';
end;

procedure TFormMain.AnalyseMapInfo;
var
  nX, nY, I, nSize, nImgNumber,  nProgress, fridx, ani, wunit, nAddFridx: Integer;
  dwShowProgressTick: LongWord;
  MapInfo: pTMapInfo;
begin
  nSize := MapHeader.wWidth * MapHeader.wHeight;
  dwShowProgressTick := GetTickCount;
  nProgress := 1;
  for nX := 0 to MapHeader.wWidth - 1 do begin
    for nY := 0 to MapHeader.wHeight - 1 do begin
      MapInfo := @MapData[MapHeader.wHeight * nX + nY];

      nImgNumber := (MapInfo.wBkImg and $7FFF);
      if nImgNumber > 0 then begin
        if (nX mod 2 = 0) and (nY mod 2 = 0) then begin
          nImgNumber := nImgNumber - 1;
          if (nImgNumber >= 0) and (nImgNumber < 65536) then begin
            Tiles[nImgNumber] := True;
            boUseTile := True;
          end;
        end;
      end;    {

      nImgNumber := MapInfo.wMidImg;
      if nImgNumber > 0 then begin
        nImgNumber := nImgNumber - 1;
        if (nImgNumber >= 0) and (nImgNumber < 65536) then begin
          SmTiles[nImgNumber] := True;
          boUseSmTile := True;
        end;
      end;
                   }
      fridx := (MapInfo.wFrImg) and $7FFF;
      if fridx > 0 then begin
        ani := MapInfo.btAniFrame;
        wunit := MapInfo.btArea;
        if (ani and $80) > 0 then begin
          ani := ani and $7F;
        end;

        if (MapInfo.btDoorIndex and $80) <> 0 then begin
          for I := 1 to $7F  do begin
            nAddFridx := fridx + I -1;
            if wunit in [Low(UseObject)..High(UseObject)] then begin
              if (nAddFridx >= 0) and (nAddFridx <= $7FFF) then begin
                UseObject[wunit] := True;
                UseImages[wunit][nAddFridx] := True;
              end;
            end;
          end;

        end;
        for I := 0 to ani do begin
          nAddFridx := fridx + I;

          nAddFridx := nAddFridx - 1;
          if wunit in [Low(UseObject)..High(UseObject)] then begin
            if (nAddFridx >= 0) and (nAddFridx <= $7FFF) then begin
              UseObject[wunit] := True;
              UseImages[wunit][nAddFridx] := True;
            end;
          end;
        end;
      end;

      if GetTickCount > dwShowProgressTick then begin
        dwShowProgressTick := GetTickCount + 500;
        pbOpenFile.Position := Trunc(nProgress / nSize * 100);
      end;
      Inc(nProgress);
      Application.ProcessMessages;
    end;
  end;
  pbOpenFile.Position := 100;
  lblOpenFileHint.Caption := '正在分析调用图像数据信息...';
  AnalyseImagesInfo();
end;

function BrowseForFolder(hd: HWND; sTitle: string): string;
var
  BrowseInfo: TBrowseInfo;
  sBuf: array[0..511] of Char;
begin
  FillChar(BrowseInfo, SizeOf(TBrowseInfo), #0);
  BrowseInfo.hwndOwner := hd;
  BrowseInfo.lpszTitle := PChar(sTitle);
  BrowseInfo.ulFlags := 64;
  SHGetPathFromIDList(SHBrowseForFolder(BrowseInfo), @sBuf);
  Result := Trim(sBuf);
end;

procedure TFormMain.btn1Click(Sender: TObject);
var
  I, nIdx, nImage, nMaxCount, nNowCount: Integer;
  LoadList:array[Low(UseObject)..High(UseObject)] of TList;
  Node: TTreeNode;
begin
  ChangeFileLock(True);
  LoadFileLock(True);
  Try
    WriteLog('正在验证数据填写完整度...');
    nMaxCount := 0;
    nNowCount := 0;
    pb1.Position := 0;
    if FOutCount <= 0 then begin
      Application.MessageBox('需要导出数量必需大于 0 ！', '提示信息', MB_OK + MB_ICONINFORMATION);
      Exit;
    end;
    if FInCount < FOutCount then begin
      Application.MessageBox('可以导入数量必需大于需要导出数量！', '提示信息', MB_OK + MB_ICONINFORMATION);
      Exit;
    end;
    if (FWMImages = nil) or (not FWMImages.boInitialize) then begin
      Application.MessageBox('打开要导入的文件失败！', '提示信息', MB_OK + MB_ICONINFORMATION);
      Exit;
    end;
    for I := Low(LoadList) to High(LoadList) do LoadList[I] := nil;
    Try
      for I := 0 to tvFileInfo.Items.Count - 1 do begin
        Node := tvFileInfo.Items[I];
        if (Node.Data <> nil) and (Node.StateIndex = 2) then begin
          nIdx := Integer(Node.Data) - 1;
          nImage := StrToIntDef(Node.Text, -1);
          if nIdx in [Low(UseObject)..High(UseObject)] then begin
            if (nImage >= 0) and (nImage <= $7FFF) then begin
              if LoadList[nIdx] = nil then begin
                if FileExists(edtOutData.Text + '\' + GetObjectsName(nIdx)) then begin
                  LoadList[nIdx] := TList.Create;
                end else begin
                  Application.MessageBox(PChar('打开要导出的文件[' + GetObjectsName(nIdx) + ']失败！'), '提示信息', MB_OK + MB_ICONINFORMATION);
                  Exit;
                end;
              end;
              LoadList[nIdx].Add(Pointer(nImage));
              Inc(nMaxCount);
            end;
          end;
        end;
      end;
      WriteLog('正在加载已导入数据信息...');
      LoadWriteImageInfo(edtOutData.Text + '\' + WRITEIMAGEFILENAME);

      for I := Low(LoadList) to High(LoadList) do begin
        if LoadList[I] <> nil then begin
          WriteLog('正在导入' + GetObjectsName(I) + '数据至新文件...');
          if not WriteImageToNewFile(edtOutData.Text + '\' + GetObjectsName(I), LoadList[I], I, FInIndex, nMaxCount, nNowCount) then begin
            Application.MessageBox(PChar('导出文件[' + GetObjectsName(I) + ']数据失败！'), '提示信息', MB_OK + MB_ICONINFORMATION);
            Exit;
          end;
        end;
      end;
      pb1.Position := 100;
      WriteLog('正在输出新的地图文件...');
      WriteNewMapInfo('.\' + ExtractFileName(edtFileName.Text));

      WriteLog('正在保存已导入数据信息...');
      SaveWriteImageInfo(edtOutData.Text + '\' + WRITEIMAGEFILENAME);
      FInCount := $7FFF - FWMImages.ImageCount - 1;
      lblInCount.Caption := IntToStr(FInCount);
      Application.MessageBox(PChar('成功转换地图文件！'), '提示信息', MB_OK + MB_ICONINFORMATION);
    Finally
      for I := Low(LoadList) to High(LoadList) do begin
        if LoadList[I] <> nil then LoadList[I].Free;
      end;
    End;

  Finally
    ChangeFileLock(False);
    LoadFileLock(False);
  End;
end;

procedure TFormMain.btnInObjectsClick(Sender: TObject);
var
  NewDir: string;
begin
  NewDir := BrowseForFolder(Handle,'请选择数据目录');
  if NewDir <> '' then begin
    edtInData.Text := NewDir;
    FSetupINI.WriteString('Setup', 'InData', edtInData.Text);
    OpenInData();
  end;
end;

procedure TFormMain.btnLoadClick(Sender: TObject);
begin
  dlgOpen.FileName := '';
  if dlgOpen.Execute(Handle) and (dlgOpen.FileName <> '') then begin
    FormEdit := TFormEdit.Create(Self);
    FormEdit.Open(dlgOpen.FileName);
    FormEdit.Free;
  end;
end;

procedure TFormMain.btnOpenFileClick(Sender: TObject);
var
  sFileName: string;
  aMapFile: TFileStream;
  ENMapHeader: TENMapHeader;
  boENMap: Boolean;
  ENMapData: array of TENMapInfo;
  MapWidth, MapHeight: Word;
  I: Integer;
begin
  sFileName := Trim(edtFileName.Text);
  if FileExists(sFileName) then begin
    LoadFileLock(True);
    aMapFile := TFileStream.Create(sFileName, fmOpenRead or fmShareDenyNone);
    try
      lblOpenFileHint.Caption := '正在读取地图信息...';
      pbOpenFile.Position := 0;
      tvFileInfo.Items.Clear;
      FillChar(UseImages[0][0], SizeOf(UseImages), False);
      FillChar(UseObject[0], SizeOf(UseObject), False);
      //FillChar(Tiles[0], SizeOf(Tiles), False);
      //FillChar(SmTiles[0], SizeOf(SmTiles), False);
      FOutCount := 0;
      //boUseTile := False;
      //boUseSmTile := False;

      aMapFile.Read(ENMapHeader, Sizeof(TENMapHeader));
      boENMap := (ENMapHeader.Title = NEWMAPTITLE);
      if boENMap then begin
        MapHeader.wWidth := ENMapHeader.Width xor XORWORD;
        MapHeader.wHeight := ENMapHeader.Height xor XORWORD;
      end
      else begin
        Move(ENMapHeader, MapHeader, SizeOf(MapHeader));
        aMapFile.Seek(SizeOf(MapHeader), 0);
      end;
      MapWidth := MapHeader.wWidth;
      MapHeight := MapHeader.wHeight;
      if (MapWidth <= 1000) and (MapHeight <= 1000) then begin
        if boENMap then begin
          SetLength(ENMapData, MapWidth * MapHeight);
          aMapFile.Read(ENMapData[0], Length(ENMapData) * SizeOf(TENMapInfo));
          for I := Low(ENMapData) to High(ENMapData) do begin
            MapData[i].wBkImg := ENMapData[i].BkImg xor XORWORD;
            if (ENMapData[i].BkImgNot xor $AA38) = $2000 then
              MapData[i].wBkImg := MapData[i].wBkImg or $8000;
            MapData[i].wMidImg := ENMapData[i].MidImg xor XORWORD;
            MapData[i].wFrImg := ENMapData[i].FrImg xor XORWORD;
            MapData[i].btDoorIndex := ENMapData[i].DoorIndex;
            MapData[i].btDoorOffset := ENMapData[i].DoorOffset;
            MapData[i].btAniFrame := ENMapData[i].AniFrame;
            MapData[i].btAniTick := ENMapData[i].AniTick;
            MapData[i].btArea := ENMapData[i].Area;
            MapData[i].btlight := ENMapData[i].light;
          end;
          ENMapData := nil;
        end
        else begin
          aMapFile.Read(MapData[0], MapWidth * SizeOf(TMapInfo) * MapHeight);
        end;
        lblOpenFileHint.Caption := '正在分析地图文件信息...';
        AnalyseMapInfo;
        lblOpenFileHint.Caption := '已分析完成...';
      end
      else begin
        lblOpenFileHint.Caption := '读取地图信息失败！！！';
      end;
    finally
      aMapFile.Free;
      LoadFileLock(False);
    end;
  end
  else
    Application.MessageBox('打开文件失败！', '提示信息', MB_OK + MB_ICONINFORMATION);
end;

procedure TFormMain.btnOutDataClick(Sender: TObject);
var
  NewDir: string;
begin
  NewDir := BrowseForFolder(Handle,'请选择数据目录');
  if NewDir <> '' then begin
    edtOutData.Text := NewDir;
    FSetupINI.WriteString('Setup', 'OutData', edtOutData.Text);
  end;
end;

procedure TFormMain.cbbInFileNameChange(Sender: TObject);
var
  sFileName: string;
begin
  sFileName := edtInData.Text + '\' + cbbInFileName.Text;
  if FileExists(sFileName) then begin
    if FWMImages <> nil then begin
      FWMImages.Free;
      FWMImages := nil;
    end;
    FWMImages := TWMMyImageImages.Create;
    FWMImages.FileName := sFileName;
    FWMImages.LibType := ltLoadBmp;
    FWMImages.Initialize;
    FInCount := $7FFF - FWMImages.ImageCount - 1;
    FInIndex := cbbInFileName.ItemIndex;
    lblInCount.Caption := IntToStr(FInCount);
    lbl10.Caption := cbbInFileName.Text;
  end else begin
    Application.MessageBox('打开文件失败，文件不存在！', '提示信息', MB_OK + MB_ICONWARNING);
  end;
end;

procedure TFormMain.ChangeFileLock(boLock: Boolean);
begin
  btn1.Enabled := not boLock;
  cbbInFileName.Enabled := not boLock;
  btnOutData.Enabled := not boLock;
  btnInObjects.Enabled := not boLock;
end;

procedure TFormMain.DropFileDropFile(Sender: TObject);
begin
  if edtFileName.Enabled then
    edtFileName.Text := DropFile.Files[0];
end;


function GetPixel(P: PByte; BPP: Byte): Cardinal;
begin
  Result := P^;
  Inc(P);
  Dec(BPP);
  while BPP > 0 do begin
    Result := Result shl 8;
    Result := Result or P^;
    Inc(P);
    Dec(BPP);
  end;
end;

function CountDiffPixels(P: PByte; BPP: Byte; Count: Integer): Integer;
var
  N: Integer;
  Pixel,
    NextPixel: Cardinal;

begin
  N := 0;
  NextPixel := 0; // shut up compiler
  if Count = 1 then
    Result := Count
  else begin
    Pixel := GetPixel(P, BPP);
    while Count > 1 do begin
      Inc(P, BPP);
      NextPixel := GetPixel(P, BPP);
      if NextPixel = Pixel then
        Break;
      Pixel := NextPixel;
      Inc(N);
      Dec(Count);
    end;
    if NextPixel = Pixel then
      Result := N
    else
      Result := N + 1;
  end;
end;
//----------------------------------------------------------------------------------------------------------------------

function CountSamePixels(P: PByte; BPP: Byte; Count: Integer): Integer;

var
  Pixel,
    NextPixel: Cardinal;

begin
  Result := 1;
  Pixel := GetPixel(P, BPP);
  Dec(Count);
  while Count > 0 do begin
    Inc(P, BPP);
    NextPixel := GetPixel(P, BPP);
    if NextPixel <> Pixel then
      Break;
    Inc(Result);
    Dec(Count);
  end;
end;


function TFormMain.EncodeRLE(const Source, Target: Pointer; Count, BPP: Integer): Integer;
var
  DiffCount, // pixel count until two identical
  SameCount: Integer; // number of identical adjacent pixels
  SourcePtr,
    TargetPtr: PByte;

begin
  Result := 0;
  SourcePtr := Source;
  TargetPtr := Target;
  while Count > 0 do begin
    DiffCount := CountDiffPixels(SourcePtr, BPP, Count);
    SameCount := CountSamePixels(SourcePtr, BPP, Count);
    if DiffCount > 128 then
      DiffCount := 128;
    if SameCount > 128 then
      SameCount := 128;
    if DiffCount > 0 then begin
      TargetPtr^ := DiffCount - 1;
      Inc(TargetPtr);
      Dec(Count, DiffCount);
      Inc(Result, (DiffCount * BPP) + 1);
      while DiffCount > 0 do begin
        TargetPtr^ := SourcePtr^;
        Inc(SourcePtr);
        Inc(TargetPtr);
        if BPP > 1 then begin
          TargetPtr^ := SourcePtr^;
          Inc(SourcePtr);
          Inc(TargetPtr);
        end;
        Dec(DiffCount);
      end;
    end;
    if SameCount > 1 then begin
      TargetPtr^ := (SameCount - 1) or $80;
      Inc(TargetPtr);
      Dec(Count, SameCount);
      Inc(Result, BPP + 1);
      Inc(SourcePtr, (SameCount - 1) * BPP);
      TargetPtr^ := SourcePtr^;
      Inc(SourcePtr);
      Inc(TargetPtr);
      if BPP > 1 then begin
        TargetPtr^ := SourcePtr^;
        Inc(SourcePtr);
        Inc(TargetPtr);
      end;
    end;
  end;
end;

procedure TFormMain.FormCreate(Sender: TObject);
var
  Res: TResourceStream;

begin
  FWMImages := nil;
  Res := TResourceStream.Create(Hinstance, '256RGB', 'RGB');
  try
    Res.Read(DefMainPalette, SizeOf(DefMainPalette));
  finally
    Res.Free;
  end;
  FSetupINI := TINIFile.Create('.\Setup.ini');
  edtInData.Text := FSetupINI.ReadString('Setup', 'InData', '');
  edtOutData.Text := FSetupINI.ReadString('Setup', 'OutData', '');
  OpenInData();
end;

procedure TFormMain.FormDestroy(Sender: TObject);
begin
  if FWMImages <> nil then
    FWMImages.Free;
  FWMImages := nil;
  FSetupINI.Free;
end;

procedure TFormMain.LoadFileLock(boLock: Boolean);
begin
  edtFileName.Enabled := not boLock;
  tvFileInfo.Enabled := not boLock;
  btnOpenFile.Enabled := not boLock;
end;

function TFormMain.LoadWriteImageInfo(sFileName: string): Boolean;
var
  FileStream: TFileStream;
begin
  Result := False;
  FillChar(WriteImages[0, 0], SizeOf(WriteImages), #0);
  if FileExists(sFileName) then begin
    FileStream := TFileStream.Create(sFileName, fmOpenRead or fmShareDenyNone);
    Try
      if FileStream.Read(WriteImages[0, 0], SizeOf(WriteImages)) <> SizeOf(WriteImages) then
        FillChar(WriteImages[0, 0], SizeOf(WriteImages), #0)
      else Result := True;
    Finally
      FileStream.Free;
    End;
  end;
end;

procedure TFormMain.OpenInData();
var
  I: Integer;
begin
  if DirectoryExists(edtInData.Text) then begin
    cbbInFileName.Items.Clear;
    for I := 1 to 10 do begin
      //if FileExists(edtinData.Text + '\' + 'Objects' + IntToStr(I) + '.pak') then
      cbbInFileName.Items.Add('Objects' + IntToStr(I) + '.pak');
    end;
    FInCount := 0;
    lbl10.Caption := '';
    lblInCount.Caption := '0';
    if FWMImages <> nil then begin
      FWMImages.Free;
      FWMImages := nil;
    end;
  end;
end;

procedure TFormMain.SaveWriteImageInfo(sFileName: string);
var
  FileStream: TFileStream;
begin
  if not FileExists(sFileName) then FileStream := TFileStream.Create(sFileName, fmCreate)
  else FileStream := TFileStream.Create(sFileName, fmOpenWrite or fmShareDenyNone);
  Try
    FileStream.Write(WriteImages[0, 0], SizeOf(WriteImages))
  Finally
    FileStream.Free;
  End;
end;

procedure TFormMain.tvFileInfoStateChange(Sender: TObject; Node: TTreeNode; NewState: TRzCheckState);
var
  nIdx, nImage: Integer;
begin
  if Node.Data <> nil then begin

    nIdx := Integer(Node.Data) - 1;
    nImage := StrToIntDef(Node.Text, -1);
    if nIdx in [Low(UseObject)..High(UseObject)] then begin
      if (nImage >= 0) and (nImage <= $7FFF) then begin
        if NewState = csChecked then begin
          if not UseImages[nIdx][nImage] then begin
            UseImages[nIdx][nImage] := True;
            Inc(FOutCount);
          end;
        end
        else begin
          if UseImages[nIdx][nImage] then begin
            UseImages[nIdx][nImage] := False;
            Dec(FOutCount);
          end;
        end;
        lblOutCount.Caption := IntToStr(FOutCount);
      end;
    end;

  end;
  {if Node.Data <> nil then begin
    if TRzCheckState(Node.SelectedIndex) <> NewState then begin
      case NewState of
        csUnchecked: Dec(FOutCount);
        csChecked: Inc(FOutCount);
      end;
      lblOutCount.Caption := IntToStr(FOutCount);
    end;
  end;     }
 { case NewState of
    csUnknown: ShowMessage(Node.Text + ' ' + 'csUnknown' + ' ' + IntToStr(Node.SelectedIndex));
    csUnchecked: ShowMessage(Node.Text + ' ' + 'csUnchecked' + ' ' + IntToStr(Ord(NewState)));
    csChecked: ShowMessage(Node.Text + ' ' + 'csChecked' + ' ' + IntToStr(Ord(NewState)));
    csPartiallyChecked: ShowMessage(Node.Text + ' ' + 'csPartiallyChecked' + ' ' + IntToStr(Node.SelectedIndex));
  end;   }
  //    TRzCheckState = ( csUnknown, csUnchecked, csChecked, csPartiallyChecked );
end;

function TFormMain.FormatBitmap(const Bitmap: TBitmap; var Data: PChar): Integer;
var
  nBuffLen: Integer;
  Buffer: PChar;
  nY, nX: Integer;
  PDWord: PWord;
  P32RGB: PRGBQuad;
  CheckColor: Integer;
  //testindex, testindex1: Word;
begin
  Data := nil;
  //testindex := StrToInt(FormMain.edt1.Text);
  //testindex1 := StrToInt(FormMain.edt2.Text);
  Result := 0;
  nBuffLen := Bitmap.Width * Bitmap.Height * 2;
  Buffer := AllocMem(nBuffLen);
  CheckColor := 0;
  try

    Bitmap.PixelFormat := pf32bit;
    for nY := 0 to Bitmap.Height - 1 do begin
      {if boCut then
        P32RGB := PRGBQuad(Bitmap.ScanLine[Bitmap.Height - 1 - nY])
      else  }
      P32RGB := PRGBQuad(Bitmap.ScanLine[nY]);
      PDWord := PWord(@Buffer[Bitmap.Width * 2 * nY]);
      for nX := 0 to Bitmap.Width - 1 do begin
        if (PInteger(P32RGB)^ and $FFFFFF) = CheckColor then begin
          PDWord^ := 0;
        end
        else begin
          PDWord^ := $8000 + ((WORD(P32RGB.rgbRed) and $F8) shl 7) + ((WORD(P32RGB.rgbGreen) and $F8) shl 2) + ((WORD(P32RGB.rgbBlue)) shr 3);
        end;
        Inc(P32RGB);
        Inc(PDWord);
      end;
    end;


    Data := AllocMem(nBuffLen * 2);
    Result := EncodeRLE(Buffer, Data, Bitmap.Width * Bitmap.Height);
    FreeMem(Buffer);

  except
    FreeMem(Buffer);
  end;
end;

function TFormMain.WriteImageToNewFile(sFileName: string; const ImagesList: TList; nIdx, nInIdx, nMaxCount: Integer; var nCount: Integer): Boolean;
var
  GETImages: TWMM2DefImages;
  I: Integer;
  nImage: Integer;
  ImageInfo: pTWriteImageInfo;
  BitMap: TBitmap;
  btType: Byte;
  dwShowProgressTick: LongWord;
  ImgInfo: TDXTextureInfo;
  DataBufferLen: Integer;
  DataBuffer: PChar;
  AddImageInfo: wmMyImage.TWMImageInfo;
begin
  Result := False;
  dwShowProgressTick := GetTickCount;
  if FileExists(sFileName) then begin
    GETImages := TWMM2DefImages.Create;
    GETImages.FileName := sFileName;
    GETImages.LibType := ltLoadBmp;
    GETImages.Initialize;
    Try
      for I := 0 to ImagesList.Count - 1 do begin
        nImage := Integer(ImagesList[I]);
        ImageInfo := @WriteImages[nIdx, nImage];
        if (ImageInfo.Objects = 0) and (ImageInfo.Images = 0) then begin
          BitMap := GETImages.Bitmap[nImage, btType];
          if BitMap <> nil then begin
            Try
              ImgInfo := GETImages.LastImageInfo;
              if Bitmap.PixelFormat = pf8bit then
                SetDIBColorTable(Bitmap.Canvas.Handle, 0, 256, DefMainPalette);
              DataBufferLen := FormatBitmap(BitMap, DataBuffer);

              FillChar(AddImageInfo, SizeOf(AddImageInfo), #0);
              AddImageInfo.DXInfo.px := ImgInfo.px;
              AddImageInfo.DXInfo.py := ImgInfo.py;
              AddImageInfo.DXInfo.nWidth := Bitmap.Width;
              AddImageInfo.DXInfo.nHeight := Bitmap.Height;
              AddImageInfo.btFileType := FILETYPE_IMAGE;
              AddImageInfo.boEncrypt := True;
              AddImageInfo.nDataSize := DataBufferLen;
              AddImageInfo.nDrawBlend := 0;
              AddImageInfo.btImageFormat := WILFMT_A1R5G5B5;
              FWMImages.AddDataToFile(@AddImageInfo, DataBuffer, DataBufferLen);
            Finally
              BitMap.Free;
            End;
          end else begin
            FWMImages.AddIndex(-1, 0);
          end;
          ImageInfo.Objects := 30 + nInIdx;
          ImageInfo.Images := FWMimages.ImageCount - 1;
        end;
        nCount := nCount + 1;
        if GetTickCount > dwShowProgressTick then begin
          dwShowProgressTick := GetTickCount + 500;
          pb1.Position := Trunc(nCount / nMaxCount * 100);
        end;
        Application.ProcessMessages;
      end;
      Result := True;
    Finally
      FWMImages.SaveIndexList;
      GETImages.Free;
    End;
  end;
end;

procedure TFormMain.WriteLog(sMsg: string);
begin
  lbl5.Caption := sMsg;
end;

function TFormMain.WriteNewMapInfo(sFileName: string): Boolean;
var
  FileStream: TFileStream;
  ENMapHeader: TENMapHeader;
  ENMapData: array of TENMapInfo;
  I, nIdx, nImage{, nAddFridx}: Integer;
  ImageInfo{, ImageInfoDoor}: pTWriteImageInfo;
  btDoorOffset: Byte;
begin
  Result := True;
  if not FileExists(sFileName) then FileStream := TFileStream.Create(sFileName, fmCreate)
  else FileStream := TFileStream.Create(sFileName, fmOpenWrite or fmShareDenyNone);
  Try
    ENMapHeader.Title := NEWMAPTITLE;
    ENMapHeader.Width := MapHeader.wWidth xor XORWORD;
    ENMapHeader.Height := MapHeader.wHeight xor XORWORD;
    FileStream.Write(ENMapHeader, SizeOf(ENMapHeader));
    SetLength(ENMapData, MapHeader.wWidth * MapHeader.wHeight);
    FillChar(ENMapData[0], Length(ENMapData) * SizeOf(TENMapInfo), #0);
    for I := Low(ENMapData) to High(ENMapData) do begin
      nIdx := MapData[i].btArea;
      nImage := (MapData[i].wFrImg) and $7FFF;
      btDoorOffset := MapData[i].btDoorOffset;
      if nImage > 0 then begin
        Dec(nImage);
        if nIdx in [Low(UseObject)..High(UseObject)] then begin
          if (nImage >= 0) and (nImage <= $7FFF) then begin
            ImageInfo := @WriteImages[nIdx, nImage];
            if (ImageInfo.Objects = 0) and (ImageInfo.Images = 0) then begin
              nImage := MapData[i].wFrImg;
            end else begin
{              nAddFridx := -1;
              if (MapData[i].btDoorIndex and $80) <> 0 then begin
                nAddFridx := nImage + (btDoorOffset and $7F);
     
                if nIdx in [Low(UseObject)..High(UseObject)] then begin
                  if (nAddFridx >= 0) and (nAddFridx <= $7FFF) then begin
                    ImageInfoDoor := @WriteImages[nIdx, nAddFridx];
                    if ImageInfoDoor.Images > ImageInfo.Images then begin
                      if btDoorOffset and $80 = 0 then btDoorOffset := ImageInfoDoor.Images - ImageInfo.Images
                      else btDoorOffset := (ImageInfoDoor.Images - ImageInfo.Images) or $80;
                    end;
                  end;
                end;
              end;    }

              nIdx := ImageInfo.Objects;
              nImage := ImageInfo.Images + 1;
              if MapData[i].wFrImg and $8000 <> 0 then
                nImage := nImage or $8000;
            end;
          end;
        end;
      end else begin
        nImage := MapData[i].wFrImg;
      end;
      if (MapData[i].wBkImg and $8000) <> 0 then begin
        ENMapData[i].BkImgNot := $2000  xor XORWORD;;
      end;
      ENMapData[i].BkImg := (MapData[i].wBkImg and $7FFF) xor XORWORD;
      ENMapData[i].MidImg := MapData[i].wMidImg xor XORWORD;
      ENMapData[i].FrImg := nImage xor XORWORD;
      ENMapData[i].DoorIndex := MapData[i].btDoorIndex;
      ENMapData[i].DoorOffset := btDoorOffset;
      ENMapData[i].AniFrame := MapData[i].btAniFrame;
      ENMapData[i].AniTick := MapData[i].btAniTick;
      ENMapData[i].Area := nIdx;
      ENMapData[i].light := MapData[i].btlight;
      

     { fridx := (MapInfo.wFrImg) and $7FFF;
      if fridx > 0 then begin
        ani := MapInfo.btAniFrame;
        wunit := MapInfo.btArea;
        if (ani and $80) > 0 then begin
          ani := ani and $7F;
        end;
        for I := 0 to ani do begin
          nAddFridx := fridx + I;
          if (MapInfo.btDoorOffset and $80) > 0 then begin
            if (MapInfo.btDoorIndex and $7F) > 0 then
              nAddFridx := nAddFridx + (MapInfo.btDoorOffset and $7F);
          end;
          nAddFridx := nAddFridx - 1;
          if wunit in [Low(UseObject)..High(UseObject)] then begin
            if (nAddFridx >= 0) and (nAddFridx <= $7FFF) then begin
              UseObject[wunit] := True;
              UseImages[wunit][nAddFridx] := True;
            end;
          end;
        end;
      end;}
    end;

    FileStream.Write(ENMapData[0], Length(ENMapData) * SizeOf(TENMapInfo));
    ENMapData := nil;
  Finally
    FileStream.Free;
  End;
end;

end.

