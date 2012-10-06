unit FrmEdit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, RzTreeVw, StdCtrls, MapShare, Spin;

type
  TFormEdit = class(TForm)
    grp1: TGroupBox;
    tvSaveFileInfo: TRzCheckTree;
    btnReLoad: TButton;
    btnDelete: TButton;
    btnSaveToFile: TButton;
    grp2: TGroupBox;
    cbb1: TComboBox;
    seBegin: TSpinEdit;
    seEnd: TSpinEdit;
    lbl1: TLabel;
    btn1: TButton;
    procedure btnSaveToFileClick(Sender: TObject);
    procedure btnReLoadClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btn1Click(Sender: TObject);
  private
    FFileName: string;
    FWriteImages: array[Low(UseImages)..High(UseImages), Low(TImageTag)..High(TImageTag)] of TWriteImageInfo;
    function LoadWriteImageInfo(sFileName: string): Boolean;
    procedure SaveWriteImageInfo(sFileName: string);
    procedure AddWriteImageToNode();
  public
    procedure Open(sFileName: string);
  end;

var
  FormEdit: TFormEdit;

implementation

{$R *.dfm}

{ TFormEdit }

procedure TFormEdit.AddWriteImageToNode;
var
  I, J, nCount, nUpIndex, nSubCount: Integer;
  ObjName: string;
  MNode, UpNode: TTreeNode;
  Info: pTWriteImageInfo;
begin
  tvSaveFileInfo.Items.Clear;
  for I := Low(UseImages) to High(UseImages) do begin
    ObjName := GetObjectsName(I);
    MNode := nil;
    nCount := 0;
    UpNode := nil;
    nUpIndex := -10;
    nSubCount := 0;
    for j := Low(TImageTag) to High(TImageTag) do begin
      Info := @FWriteImages[I][J];
      if (Info.Objects <> 0) and (Info.Images <> 0) then begin
        if MNode = nil then begin
          MNode := tvSaveFileInfo.Items.Add(nil, ObjName);
        end;
        if UpNode <> nil then begin
          if (J - 1) = nUpIndex then begin
            tvSaveFileInfo.Items.AddChild(UpNode, Format('%.6d', [J - 1])).Data := Pointer(I + 1);
            UpNode.Data := nil;
            nSubCount := 1;
          end;
          tvSaveFileInfo.Items.AddChild(UpNode, Format('%.6d', [J])).Data := Pointer(I + 1);
          Inc(nSubCount);
        end
        else begin
          UpNode := tvSaveFileInfo.Items.AddChild(MNode, Format('%.6d', [J]));
          UpNode.Data := Pointer(I + 1);
          nUpIndex := J;
        end;
        Inc(nCount);
      end
      else begin
        if (UpNode <> nil) and ((J - 1) <> nUpIndex) then begin
          UpNode.Text := UpNode.Text + ' - ' + Format('%.6d (%d)', [J - 1, nSubCount]);
        end;
        UpNode := nil;
        nSubCount := 0;
      end;
    end;
    if MNode <> nil then begin
      MNode.Text := ObjName + ' (' + IntToStr(nCount) + ')';
    end;
  end;
end;

procedure TFormEdit.btn1Click(Sender: TObject);
var
  J, K, nBegin, nEnd: Integer;
  nIdx: Integer;
  Info: pTWriteImageInfo;
begin
  if seEnd.Value < seBegin.Value then begin
    Application.MessageBox('结束编号不能小于开始编号！', '提示信息', MB_OK + MB_ICONINFORMATION);
    Exit;
  end;
  nIdx := cbb1.ItemIndex + 30;
  nBegin := seBegin.Value;
  nEnd := seEnd.Value;
  for j := Low(UseImages) to High(UseImages) do begin
    for K := Low(TImageTag) to High(TImageTag) do begin
      Info := @FWriteImages[J][K];
      if (Info.Objects = nIdx) and (Info.Images >= nBegin) and (Info.Images <= nEnd) then begin
        FWriteImages[J][K].Objects := 0;
        FWriteImages[J][K].Images := 0;
      end;
    end;
  end;
  AddWriteImageToNode();
end;

procedure TFormEdit.btnDeleteClick(Sender: TObject);
var
  I, nIdx, nImage: Integer;
  Node: TTreeNode;
begin
  for I := tvSaveFileInfo.Items.Count - 1 downto 0 do begin
    Node := tvSaveFileInfo.Items[I];
    if (Node.StateIndex = 2) then begin
      if (Node.Data <> nil) then begin
        nIdx := Integer(Node.Data) - 1;
        nImage := StrToIntDef(Node.Text, -1);
        if nIdx in [Low(UseObject)..High(UseObject)] then begin
          if (nImage >= 0) and (nImage <= $7FFF) then begin
            FWriteImages[nIdx][nImage].Objects := 0;
            FWriteImages[nIdx][nImage].Images := 0;
          end;
        end;
      end;
      tvSaveFileInfo.Items.Delete(Node);
    end;
  end;
end;

procedure TFormEdit.btnReLoadClick(Sender: TObject);
begin
  if Application.MessageBox('是否确定重新加载记录文件配置信息！', '提示信息', MB_YESNO + MB_ICONQUESTION) = IDYES then
  begin
    if LoadWriteImageInfo(FFileName) then begin
      AddWriteImageToNode;
    end else
      Application.MessageBox('重新加载记录文件失败！', '提示信息', MB_OK + MB_ICONSTOP);
  end;
end;

procedure TFormEdit.btnSaveToFileClick(Sender: TObject);
begin
  if Application.MessageBox('是否确定保存设置，该操作将不可还原！建议操作前备份。', '提示信息', MB_YESNO + MB_ICONQUESTION) = IDYES then
  begin
    SaveWriteImageInfo(FFileName);
    Application.MessageBox('保存设置成功！', '提示信息', MB_OK + MB_ICONINFORMATION);
  end;
end;

function TFormEdit.LoadWriteImageInfo(sFileName: string): Boolean;
var
  FileStream: TFileStream;
begin
  Result := False;
  FillChar(FWriteImages[0, 0], SizeOf(FWriteImages), #0);
  if FileExists(sFileName) then begin
    FileStream := TFileStream.Create(sFileName, fmOpenRead or fmShareDenyNone);
    Try
      if FileStream.Read(FWriteImages[0, 0], SizeOf(FWriteImages)) <> SizeOf(FWriteImages) then
        FillChar(FWriteImages[0, 0], SizeOf(FWriteImages), #0)
      else Result := True;
    Finally
      FileStream.Free;
    End;
  end;
end;

procedure TFormEdit.Open(sFileName: string);
begin
  FFileName := sFileName;
  if LoadWriteImageInfo(sFileName) then begin
    AddWriteImageToNode;
    ShowModal;
  end else
    Application.MessageBox('加载记录文件失败！', '提示信息', MB_OK + MB_ICONSTOP);
end;

procedure TFormEdit.SaveWriteImageInfo(sFileName: string);
var
  FileStream: TFileStream;
begin
  if not FileExists(sFileName) then FileStream := TFileStream.Create(sFileName, fmCreate)
  else FileStream := TFileStream.Create(sFileName, fmOpenWrite or fmShareDenyNone);
  Try
    FileStream.Write(FWriteImages[0, 0], SizeOf(FWriteImages))
  Finally
    FileStream.Free;
  End;
end;

end.
