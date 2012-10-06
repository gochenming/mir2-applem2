unit FrmFindClient;

interface

uses
  Windows, Messages, SysUtils, StrUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, RzLabel, ShlObj;

type
  TFormFindClient = class(TForm)
    grp1: TGroupBox;
    lbl1: TLabel;
    btnFind: TButton;
    cbb1: TComboBox;
    lbl2: TLabel;
    lbl3: TLabel;
    lbl4: TLabel;
    RzLabel1: TRzLabel;
    grp2: TGroupBox;
    btnOk: TButton;
    btnCancel: TButton;
    lbl5: TLabel;
    edtClientDir: TEdit;
    btn1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnFindClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnOkClick(Sender: TObject);
    procedure btn1Click(Sender: TObject);
  private
    FboStop: Boolean;
    FShowTick: LongWord;
  public
    procedure BeginFind(const DirList: TStringList);
    function FindChild(sDir: string): string;
    function CheckDir(sDir: string): Boolean;
    procedure ShowHint(sMsg: string; boTick: Boolean = True);
  end;

var
  FormFindClient: TFormFindClient;
  sFindDir: string;

implementation

{$R *.dfm}

uses LShare;

function TFormFindClient.CheckDir(sDir: string): Boolean;
begin
  Result := False;
  if CheckMirDir(sDir, False) and (Application.MessageBox(PChar(sDir +
    #13#10 + '是否使用上面客户端作为默认的游戏客户端？' +
    #13#10 + '选择“取消”将继续查找客户端。'), '提示信息',
    MB_OKCANCEL + MB_ICONQUESTION) = IDOK) then begin
    Result := True;
  end;
end;

function TFormFindClient.FindChild(sDir: string): string;
var
  sr: TSearchRec;
  n: Integer;
  boData, boMap, boWav: Boolean;
begin
  Result := '';
  n := FindFirst(sDir + '*.*', faDirectory, sr);
  ShowHint(sDir);
  boData := False;
  boMap := False;
  boWav := False;
  while n = 0 do begin
    if FboStop then
      Break;
    if (sr.Attr and faDirectory) = faDirectory then begin
      if sr.Name[1] <> '.' then begin
        if CompareText(sr.Name, 'Data') = 0 then
          boData := True;
        if CompareText(sr.Name, 'Map') = 0 then
          boMap := True;
        if CompareText(sr.Name, 'Wav') = 0 then
          boWav := True;
        Result := FindChild(sDir + sr.Name + '\');
        if Result <> '' then
          break;
      end;
    end;
    n := FindNext(sr);
    Application.ProcessMessages;
  end;
  FindClose(sr);
  if boData and boMap and boWav then begin
    if CheckDir(sDir) then begin
      Result := sDir;
    end;
  end;
end;

procedure TFormFindClient.BeginFind(const DirList: TStringList);
var
  sr: TSearchRec;
  n, I: Integer;
  sName: string;
begin
  sName := '';
  for I := 0 to DirList.Count - 1 do begin
    n := FindFirst(DirList[I] + '*.*', faDirectory, sr);
    while n = 0 do begin
      if FboStop then
        Break;
      ShowHint(DirList[I]);
      if (sr.Attr and faDirectory) = faDirectory then begin
        if sr.Name[1] <> '.' then begin
          if CompareText(sr.Name, 'WINDOWS') = 0 then begin
            n := FindNext(sr);
            Continue;
          end;
          if CompareText(sr.Name, 'Documents and Settings') = 0 then begin
            n := FindNext(sr);
            Continue;
          end;
          sName := FindChild(DirList[I] + sr.Name + '\');
          if sName <> '' then begin
            edtClientDir.Text := sName;
            break;
          end;
        end;
      end;
      n := FindNext(sr);
      Application.ProcessMessages;
    end;
    FindClose(sr);
    if sName <> '' then
      break;
  end;
  if sName = '' then
    ShowHint('没有找到合适的客户端', False)
  else
    ShowHint(sName, False);
end;

procedure TFormFindClient.btn1Click(Sender: TObject);
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
var
  sStr: string;
begin
  sStr := BrowseForFolder(Handle, '请选择传奇客户端目录');
  if sStr <> '' then
    edtClientDir.Text := sStr;

end;

procedure TFormFindClient.btnFindClick(Sender: TObject);
var
  DirList: TStringList;
begin
  cbb1.Enabled := False;
  try
    if btnFind.Caption = '自动查找(&F)' then begin
      btnFind.Caption := '停止查找(&S)';
      DirList := TStringList.Create;
      FboStop := False;
      if cbb1.ItemIndex = 0 then begin
        DirList.Assign(cbb1.Items);
        DirList.Delete(0);
      end
      else begin
        DirList.Add(cbb1.Items[cbb1.ItemIndex]);
      end;
      BeginFind(DirList);
      DirList.Free;
    end
    else begin
      btnFind.Caption := '自动查找(&F)';
      FboStop := True;
    end;
  finally
    FboStop := True;
    btnFind.Caption := '自动查找(&F)';
    cbb1.Enabled := True;
  end;
end;

procedure TFormFindClient.btnOkClick(Sender: TObject);
var
  sDir: string;
begin
  sDir := edtClientDir.Text;
  if (sDir <> '') and DirectoryExists(sDir) then begin
    if RightStr(sDir, 1) <> '\' then
      sDir := sDir + '\';
    if CheckMirDir(sDir, False) then begin
      sFindDir := sDir;
      Close;
    end
    else
      Application.MessageBox('客户端目录不正确！', '提示信息', MB_OK + MB_ICONSTOP);
  end
  else
    Application.MessageBox('客户端目录不正确！', '提示信息', MB_OK + MB_ICONSTOP);
end;

procedure TFormFindClient.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  FboStop := True;
end;

procedure TFormFindClient.FormCreate(Sender: TObject);
var
  buff: array[0..255] of array[0..3] of Char;
  Count, I: Integer;
begin
  sFindDir := '';
  FboStop := True;
  FShowTick := GetTickCount;
  Count := GetLogicalDriveStrings(SizeOf(Buff), @buff);
  cbb1.Items.Clear;
  cbb1.Items.Add('所有盘符');
  cbb1.ItemIndex := 0;
  for I := 0 to (Count div 4) - 1 do begin
    if GetDriveType(Buff[i]) in [DRIVE_FIXED] then
      cbb1.Items.Add(Buff[i]);
  end;
end;

procedure TFormFindClient.ShowHint(sMsg: string; boTick: Boolean);
begin
  if (not boTick) or (GetTickCount > FShowTick) then begin
    lbl4.Caption := sMsg;
    FShowTick := GetTickCount + 100;
  end;
end;

end.

