unit FrmMain;

interface

uses
  Windows, Messages, SysUtils, StrUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin, ComCtrls, ExtCtrls, MudUtil, DateUtils, Grobal2, HUtil32,
  Buttons;

const
  NameArry: array[0..35] of string = (
    'a', 'b', 'c', 'd', 'e', 'f', 'g',
    'h', 'i', 'j', 'k', 'l', 'n', 'm',
    'o', 'p', 'q', 'r', 's', 't',
    'u', 'v', 'w', 'x', 'y', 'z',
    '0', '1', '2', '3', '4', '5',
    '6', '7', '8', '9'
    );

type

  pTUniteInfo = ^TUniteInfo;
  TUniteInfo = packed record
    DelMirDB: TQuickList;
    DelHumDB: TQuickList;
    DelIDDB: TQuickList;

    MirDB: TQuickList;
    HumDB: TQuickList;
    IDDB: TQuickList;
  end;

  pTRenameList = ^TRenameList;
  TRenameList = packed record
    OldName: TQuickList;
    NewName: TStringList;
  end;

  TFormMain = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    EditMainID: TEdit;
    EditMainHum: TEdit;
    EditMainMir: TEdit;
    EditMainGuild: TEdit;
    EditMainEMail: TEdit;
    ButtonMainID: TButton;
    ButtonMainHum: TButton;
    ButtonMainMir: TButton;
    ButtonMainEMail: TButton;
    ButtonMainGuild: TButton;
    GroupBox2: TGroupBox;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    EditSubID: TEdit;
    EditSubHum: TEdit;
    EditSubMir: TEdit;
    EditSubGuild: TEdit;
    EditSubEMail: TEdit;
    ButtonSubID: TButton;
    ButtonSubHum: TButton;
    ButtonSubMir: TButton;
    ButtonSubEMail: TButton;
    ButtonSubGuild: TButton;
    GroupBox3: TGroupBox;
    Label11: TLabel;
    Label12: TLabel;
    CheckBoxAcc1: TCheckBox;
    CheckBoxAcc2: TCheckBox;
    EditAcc2: TSpinEdit;
    CheckBoxHum1: TCheckBox;
    CheckBoxHum3: TCheckBox;
    EditHum3: TSpinEdit;
    CheckBoxHum2: TCheckBox;
    CheckBoxRefId: TCheckBox;
    GroupBox4: TGroupBox;
    Label15: TLabel;
    EditSaveDir: TEdit;
    ButtonSaveDir: TButton;
    ButtonState: TButton;
    ButtonClose: TButton;
    ProgressBar1: TProgressBar;
    Panel1: TPanel;
    OpenDialog1: TOpenDialog;
    GroupBox5: TGroupBox;
    GroupBox6: TGroupBox;
    EditAddText1: TEdit;
    Label13: TLabel;
    ButtonAddText1: TButton;
    Label14: TLabel;
    EditAddText2: TEdit;
    ButtonAddText2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    ListBox1: TListBox;
    procedure ButtonCloseClick(Sender: TObject);
    procedure ButtonStateClick(Sender: TObject);
    procedure CheckBoxAcc2Click(Sender: TObject);
    procedure CheckBoxHum3Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure ButtonMainIDClick(Sender: TObject);
    procedure ButtonMainGuildClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
  private
    m_OldProgress: Byte;
    procedure Lock(boLock: Boolean);
    procedure ShowHint(sHint: string; boError: Boolean = False);
    procedure ShowProgress(nProgress: Integer);
    function LoadMirDB(sFileName: string; UniteInfo: pTUniteInfo; boMain: Boolean): Boolean;
    function LoadHumDB(sFileName: string; UniteInfo: pTUniteInfo): Boolean;
    function LoadIDDB(sFileName: string; UniteInfo: pTUniteInfo; boMain, boWrite: Boolean): Boolean;
    function UniteGuild(sSaveDir: string; RenameList: pTRenameList): Boolean;
    function GetNewName(sName: string; nMaxLen: Integer; var RenameList: TStringList): string;
    function ChangeGuildName(sGuildName, sOldName, sNewName: string): Boolean;
    procedure ChangeItemIndex(HumData: pTHumData);
    procedure UpdateTextFileList(const ASaveDir: string);
  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;

implementation

{$R *.dfm}

uses
  ShlObj, HumDB, IDDB;


var
  MainUnite, SubUnite: TUniteInfo;
  SaveDir: string;
  GuildRename, HumRename, IDRename, WriteIDRename: TRenameList;
  NewMirDB: TFileStream;
  NewHumDB: TFileStream;
  NewIDDB: TFileStream;
  DelMainMirDB: TFileStream;
  DelMainHumDB: TFileStream;
  DelSubMirDB: TFileStream;
  DelSubHumDB: TFileStream;
  DelMainIDDB: TFileStream;
  DelSubIDDB: TFileStream;
  AllID, MainWriteID, SubWriteID: TQuickList;
  ItemIndex: Integer;
  CurrentDir: string;

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

procedure TFormMain.Button3Click(Sender: TObject);
begin
  if not (FileExists(EditAddText1.Text) and FileExists(EditAddText2.Text)) then
  begin
    Application.MessageBox('请输入正确的文本地址！', '提示信息', MB_OK + MB_ICONINFORMATION);
    Exit;
  end;
  ListBox1.Items.Add(format('%s <== %s', [EditAddText1.Text, EditAddText2.Text]));
end;

procedure TFormMain.Button4Click(Sender: TObject);
var
  i: Integer;
begin
  if Application.MessageBox('是否确定删除已经选择的合并文本信息？', '提示信息', MB_OKCANCEL + MB_ICONQUESTION) <> IDOK then
    exit;
  for i := ListBox1.Items.Count - 1 downto 0 do
    if ListBox1.Selected[i] then
      ListBox1.Items.Delete(i);
end;

procedure TFormMain.Button5Click(Sender: TObject);
begin
  if Application.MessageBox('是否确定清空已经添加的合并文本信息？', '提示信息', MB_OKCANCEL + MB_ICONQUESTION) <> IDOK then
    exit;
  ListBox1.Items.Clear;
end;

procedure TFormMain.ButtonCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFormMain.ButtonMainGuildClick(Sender: TObject);
var
  FileName: string;
begin
  FileName := BrowseForFolder(Handle, '请选择目录');
  if FileName <> '' then begin
    if Sender = ButtonMainGuild then
      EditMainGuild.Text := FileName
    else if Sender = ButtonMainEMail then
      EditMainEMail.Text := FileName
    else if Sender = ButtonSubGuild then
      EditSubGuild.Text := FileName
    else if Sender = ButtonSubEMail then
      EditSubEMail.Text := FileName
    else if Sender = ButtonSaveDir then
      EditSaveDir.Text := FileName;
  end;
end;

procedure TFormMain.ButtonMainIDClick(Sender: TObject);
begin
  with OpenDialog1 do begin
    if Sender = ButtonMainID then
      Filter := 'id.db|id.db'
    else if Sender = ButtonMainHum then
      Filter := 'Hum.db|Hum.db'
    else if Sender = ButtonMainMir then
      Filter := 'Mir.db|Mir.db'
    else if Sender = ButtonSubId then
      Filter := 'id.db|id.db'
    else if Sender = ButtonSubHum then
      Filter := 'Hum.db|Hum.db'
    else if Sender = ButtonSubMir then
      Filter := 'Mir.db|Mir.db'
    else if Sender = ButtonAddText1 then
      Filter := '文本文件|*'
    else if Sender = ButtonAddText2 then
      Filter := '文本文件|*';
    Execute;
    if FileName <> '' then begin
      if Sender = ButtonMainID then
        EditMainID.Text := FileName
      else if Sender = ButtonMainHum then
        EditMainHum.Text := FileName
      else if Sender = ButtonMainMir then
        EditMainMir.Text := FileName
      else if Sender = ButtonSubId then
        EditSubId.Text := FileName
      else if Sender = ButtonSubHum then
        EditSubHum.Text := FileName
      else if Sender = ButtonSubMir then
        EditSubMir.Text := FileName
      else if Sender = ButtonAddText1 then
        EditAddText1.Text := FileName
      else if Sender = ButtonAddText2 then
        EditAddText2.Text := FileName;
    end;
  end;
end;

procedure TFormMain.ButtonStateClick(Sender: TObject);
var
  TempList: TStringList;
  I: Integer;
begin
  SaveDir := Trim(EditSaveDir.Text);
  if not DirectoryExists(SaveDir) then begin
    Application.MessageBox('保存文件夹位置不正确！', '提示信息', MB_OK + MB_ICONINFORMATION);
    Exit;
  end;
  if RightStr(SaveDir, 1) <> '\' then
    SaveDir := SaveDir + '\';
  Lock(False);
  TempList := TStringList.Create;
  MainUnite.MirDB := TQuickList.Create;
  MainUnite.HumDB := TQuickList.Create;
  MainUnite.IDDB := TQuickList.Create;
  MainUnite.DelMirDB := TQuickList.Create;
  MainUnite.DelHumDB := TQuickList.Create;
  MainUnite.DelIDDB := TQuickList.Create;
  AllID := TQuickList.Create;
  MainWriteID := TQuickList.Create;
  SubWriteID := TQuickList.Create;

  SubUnite.MirDB := TQuickList.Create;
  SubUnite.HumDB := TQuickList.Create;
  SubUnite.IDDB := TQuickList.Create;
  SubUnite.DelMirDB := TQuickList.Create;
  SubUnite.DelHumDB := TQuickList.Create;
  SubUnite.DelIDDB := TQuickList.Create;

  GuildRename.OldName := TQuickList.Create;
  GuildRename.NewName := TStringList.Create;
  HumRename.OldName := TQuickList.Create;
  HumRename.NewName := TQuickList.Create;
  IDRename.OldName := TQuickList.Create;
  IDRename.NewName := TQuickList.Create;
  WriteIDRename.OldName := TQuickList.Create;
  WriteIDRename.NewName := TQuickList.Create;

  ItemIndex := 10000;

  CreateDir(SaveDir + '删除数据\');

  CreateDir(SaveDir + '文本数据\');
  
  DeleteFile(SaveDir + 'Mir.DB');
  DeleteFile(SaveDir + 'Hum.DB');
  DeleteFile(SaveDir + 'ID.DB');
  DeleteFile(SaveDir + '删除数据\' + '主.Mir.DB');
  DeleteFile(SaveDir + '删除数据\' + '主.Hum.DB');
  DeleteFile(SaveDir + '删除数据\' + '从.Mir.DB');
  DeleteFile(SaveDir + '删除数据\' + '从.Hum.DB');
  DeleteFile(SaveDir + '删除数据\' + '主.ID.DB');
  DeleteFile(SaveDir + '删除数据\' + '从.ID.DB');
  NewMirDB := TFileStream.Create(SaveDir + 'Mir.DB', fmCreate);
  NewHumDB := TFileStream.Create(SaveDir + 'Hum.DB', fmCreate);
  NewIDDB := TFileStream.Create(SaveDir + 'ID.DB', fmCreate);
  DelMainMirDB := TFileStream.Create(SaveDir + '删除数据\' + '主.Mir.DB', fmCreate);
  DelMainHumDB := TFileStream.Create(SaveDir + '删除数据\' + '主.Hum.DB', fmCreate);
  DelSubMirDB := TFileStream.Create(SaveDir + '删除数据\' + '从.Mir.DB', fmCreate);
  DelSubHumDB := TFileStream.Create(SaveDir + '删除数据\' + '从.Hum.DB', fmCreate);
  DelMainIDDB := TFileStream.Create(SaveDir + '删除数据\' + '主.ID.DB', fmCreate);
  DelSubIDDB := TFileStream.Create(SaveDir + '删除数据\' + '从.ID.DB', fmCreate);
  try
    if Trim(EditMainID.Text) <> '' then begin
      ShowHint('正在加载主库ID.DB...');
      if not LoadIDDB(Trim(EditMainID.Text), @MainUnite, True, False) then begin
        ShowHint('加载主库ID.DB失败，文件不存在或版本不符...', True);
        Exit;
      end;

      ShowHint('正在加载从库ID.DB...');
      if not LoadIDDB(Trim(EditSubID.Text), @SubUnite, False, False) then begin
        ShowHint('加载从库ID.DB失败，文件不存在或版本不符...', True);
        Exit;
      end;
    end;

    ShowHint('正在合并行会信息...');
    if not UniteGuild(SaveDir + 'GuildBase\', @GuildRename) then begin
      ShowHint('合并行会信息失败...', True);
      Exit;
    end;

    ShowHint('正在加载主库Hum.DB...');
    if not LoadHumDB(Trim(EditMainHum.Text), @MainUnite) then begin
      ShowHint('加载主库Hum.DB失败，文件不存在或版本不符...', True);
      Exit;
    end;
    
    ShowHint('正在加载主库Mir.DB...');
    if not LoadMirDB(Trim(EditMainMir.Text), @MainUnite, True) then begin
      ShowHint('加载主库Mir.DB失败，文件不存在或版本不符...', True);
      Exit;
    end;

    ShowHint('正在加载从库Hum.DB...');
    if not LoadHumDB(Trim(EditSubHum.Text), @SubUnite) then begin
      ShowHint('加载从库Hum.DB失败，文件不存在或版本不符...', True);
      Exit;
    end;
    
    ShowHint('正在加载从库Mir.DB...');
    if not LoadMirDB(Trim(EditSubMir.Text), @SubUnite, False) then begin
      ShowHint('加载从库Mir.DB失败，文件不存在或版本不符...', True);
      Exit;
    end;

    if Trim(EditMainID.Text) <> '' then begin
      ShowHint('正在加载主库ID.DB...');
      if not LoadIDDB(Trim(EditMainID.Text), @MainUnite, True, True) then begin
        ShowHint('加载主库ID.DB失败，文件不存在或版本不符...', True);
        Exit;
      end;

      ShowHint('正在加载从库ID.DB...');
      if not LoadIDDB(Trim(EditSubID.Text), @SubUnite, False, True) then begin
        ShowHint('加载从库ID.DB失败，文件不存在或版本不符...', True);
        Exit;
      end;
    end;

    UpdateTextFileList(SaveDir + '文本数据\');

    TempList.Clear;
    for I := 0 to HumRename.OldName.Count - 1 do begin
      TempList.Add(HumRename.OldName[I] + ' --> ' + HumRename.NewName[Integer(HumRename.OldName.Objects[I])]);
    end;
    TempList.SaveToFile(CurrentDir + 'HumLog.txt');

    TempList.Clear;
    for I := 0 to WriteIDRename.OldName.Count - 1 do begin
      TempList.Add(WriteIDRename.OldName[I] + ' --> ' + WriteIDRename.NewName[Integer(WriteIDRename.OldName.Objects[I])]);
    end;
    TempList.SaveToFile(CurrentDir + 'IDLog.txt');

    MainUnite.DelMirDB.SaveToFile(CurrentDir + '主.DelHumLog.txt');
    SubUnite.DelMirDB.SaveToFile(CurrentDir + '从.DelHumLog.txt');
    MainUnite.DelIDDB.SaveToFile(CurrentDir + '主.DelIDLog.txt');
    SubUnite.DelIDDB.SaveToFile(CurrentDir + '从.DelIDLog.txt');

    TempList.Clear;
    TempList.Add(IntToStr(ItemIndex));
    TempList.SaveToFile(CurrentDir + 'ItemIndex.txt');

    ShowHint('合区工作已完成...');
  finally
    MainUnite.MirDB.Free;
    MainUnite.HumDB.Free;
    MainUnite.IDDB.Free;
    MainUnite.DelMirDB.Free;
    MainUnite.DelHumDB.Free;
    MainUnite.DelIDDB.Free;
    AllID.Free;
    MainWriteID.Free;
    SubWriteID.Free;
    WriteIDRename.OldName.Free;
    WriteIDRename.NewName.Free;

    SubUnite.MirDB.Free;
    SubUnite.HumDB.Free;
    SubUnite.IDDB.Free;
    SubUnite.DelMirDB.Free;
    SubUnite.DelHumDB.Free;
    SubUnite.DelIDDB.Free;

    GuildRename.OldName.Free;
    GuildRename.NewName.Free;
    HumRename.OldName.Free;
    HumRename.NewName.Free;
    IDRename.OldName.Free;
    IDRename.NewName.Free;
    
    NewMirDB.Free;
    NewHumDB.Free;
    NewIDDB.Free;
    DelMainMirDB.Free;
    DelMainHumDB.Free;
    DelSubMirDB.Free;
    DelSubHumDB.Free;
    DelMainIDDB.Free;
    DelSubIDDB.Free;
    TempList.Free;
    Lock(True);
  end;
end;

procedure TFormMain.CheckBoxAcc2Click(Sender: TObject);
begin
  EditAcc2.Enabled := CheckBoxAcc2.Checked;
end;

procedure TFormMain.CheckBoxHum3Click(Sender: TObject);
begin
  EditHum3.Enabled := CheckBoxHum3.Checked;
  //EditHum31.Enabled := CheckBoxHum3.Checked;
end;

procedure TFormMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := False;
  if Application.MessageBox('是否确定关闭合区工具？', '提示信息', MB_OKCANCEL + MB_ICONQUESTION) = IDOK then begin
    CanClose := True;
  end;
end;

procedure TFormMain.FormCreate(Sender: TObject);
begin
  m_OldProgress := 0;
  CurrentDir := GetCurrentDir;
  if RightStr(CurrentDir, 1) <> '\' then
    CurrentDir := CurrentDir + '\';
{$IFDEF DEBUG}
  EditMainID.Text := 'D:\合区测试数据\Id.DB';
  EditMainHum.Text := 'D:\合区测试数据\DB\Hum.DB';
  EditMainMir.Text := 'D:\合区测试数据\DB\Mir.DB';
  EditMainGuild.Text := 'D:\合区测试数据\GuildBase';
  EditMainEMail.Text := 'D:\合区测试数据\EMail';

  EditSubID.Text := 'D:\合区测试数据\Id.DB';
  EditSubHum.Text := 'D:\合区测试数据\从\Hum.DB';
  EditSubMir.Text := 'D:\合区测试数据\从\Mir.DB';
  EditSubGuild.Text := 'D:\合区测试数据\从\GuildBase';
  EditSubEMail.Text := 'D:\合区测试数据\从\EMail';

  EditSaveDir.Text := 'D:\合区测试数据\完成';
{$ENDIF}
end;

function TFormMain.GetNewName(sName: string; nMaxLen: Integer; var RenameList: TStringList): string;
var
  I: Integer;
begin
  Result := '';
  if Length(sName) < nMaxLen then begin
    for I := Low(NameArry) to High(NameArry) do begin
      Result := sName + NameArry[I];
      if RenameList.IndexOf(Result) = -1 then
        Exit;
    end;
    Result := '';
  end
  else begin
    for I := Low(NameArry) to High(NameArry) do begin
      if Word(sName[length(sName)]) > 126 then
        Result := Copy(sName, 0, Length(sName) - 2) + NameArry[I]
      else
        Result := Copy(sName, 0, Length(sName) - 1) + NameArry[I];
      if RenameList.IndexOf(Result) = -1 then Exit;
    end;
    Result := '';
  end;
end;

function TFormMain.LoadHumDB(sFileName: string; UniteInfo: pTUniteInfo): Boolean;
var
  FileStream: TFileStream;
  Header: HumDB.TIdxHeader;
  HumRecord: HumDB.THumInfo;
  I: Integer;
begin
  Result := False;
  ShowProgress(0);
  if FileExists(sFileName) then begin
    FileStream := TFileStream.Create(sFileName, fmOpenRead or fmShareDenyWrite);
    try
      if FileStream.Read(Header, SizeOf(Header)) = SizeOf(Header) then begin
        if Header.sDesc <> HumDB.sDBHeaderDesc then begin
          Result := False;
          Exit;
        end;
        for I := 0 to Header.nHumCount - 1 do begin
          if FileStream.Read(HumRecord, SizeOf(HumRecord)) = SizeOf(HumRecord) then begin
            if HumRecord.sChrName <> '' then begin
              if (HumRecord.boDeleted or HumRecord.boGMDeleted) and CheckBoxHum1.Checked then begin
                UniteInfo.DelHumDB.AddRecord(HumRecord.sChrName, I);
              end
              else
              if UniteInfo.IDDB.GetIndex(HumRecord.sAccount) = -1 then begin
                UniteInfo.DelHumDB.AddRecord(HumRecord.sChrName, I);
              end else
                UniteInfo.HumDB.AddRecord(HumRecord.sChrName, I);  
              {if CheckBoxHum2.Checked and (UniteInfo.MirDB.GetIndex(HumRecord.sChrName) = -1) then begin
                UniteInfo.DelHumDB.AddRecord(HumRecord.sChrName, I);
              end
              else   }
                
            end;
          end;
          ShowProgress(Round((I + 1) / Header.nHumCount * 100));
          Application.ProcessMessages;
        end;
        Result := True;
      end;
    finally
      FileStream.Free;
    end;
  end;
end;

function TFormMain.LoadIDDB(sFileName: string; UniteInfo: pTUniteInfo; boMain, boWrite: Boolean): Boolean;
var
  Header, wHeader: IDDB.TDBHeader;
  FileStream: TFileStream;
  DBRecord: TAccountDBRecord;
  I, Idx: Integer;
  sNewName: string;
  DelID: TFileStream;
  WriteList: TQuickList;
begin
  Result := False;
  ShowProgress(0);
  if FileExists(sFileName) then begin
    FileStream := TFileStream.Create(sFileName, fmOpenRead or fmShareDenyWrite);
    Try
      if FileStream.Read(Header, SizeOf(Header)) = SizeOf(Header) then begin
        if Header.sDesc <> IDDB.sDBHeaderDesc then begin
          Result := False;
          Exit;
        end;
        DelID := nil;
        WriteList := nil;
        if boWrite then begin
          if boMain then begin
            FillChar(wHeader, SizeOf(wHeader), #0);

            wHeader.sDesc := IDDB.sDBHeaderDesc;
            wHeader.nIDCount := 0;
            wHeader.nLastIndex := -1;
            wHeader.dLastDate := Now();
            wHeader.nDeletedIdx := -1;
            wHeader.dUpdateDate := Now();

            NewIDDB.Write(wHeader, SizeOf(wHeader));
            DelMainIDDB.Write(wHeader, SizeOf(wHeader));
            DelSubIDDB.Write(wHeader, SizeOf(wHeader));

            DelID := DelMainIDDB;
            WriteList := MainWriteID;
          end else begin
            DelID := DelSubIDDB;
            WriteList := SubWriteID;
          end;
          UniteInfo.IDDB.Clear;
        end;
        for I := 0 to Header.nIDCount - 1 do begin
          if FileStream.Read(DBRecord, SizeOf(DBRecord)) = SizeOf(DBRecord) then begin
            if DBRecord.UserEntry.sAccount <> '' then begin
              if boWrite then begin
                if WriteList.GetIndex(DBRecord.UserEntry.sAccount) > -1 then begin
                  if not boMain then begin
                    sNewName := DBRecord.UserEntry.sAccount;
                    Idx := IDRename.OldName.GetIndex(sNewName);
                    if Idx > -1 then begin
                      sNewName := IDRename.NewName[Integer(IDRename.OldName.Objects[Idx])];
                      WriteIDRename.OldName.AddObject(DBRecord.UserEntry.sAccount, TObject(WriteIDRename.NewName.Add(sNewName)));
                    end;
                    DBRecord.UserEntry.sAccount := sNewName;
                    DBRecord.Header.sAccount := sNewName;
                  end;
                  UniteInfo.IDDB.Add(DBRecord.UserEntry.sAccount);
                  NewIDDB.Write(DBRecord, SizeOf(DBRecord));
                end else begin
                  UniteInfo.DelIDDB.AddRecord(DBRecord.UserEntry.sAccount, I);
                  DelID.Write(DBRecord, SizeOf(DBRecord));
                end;

              end else begin
                if CheckBoxAcc2.Checked and (DaysBetween(Now, DBRecord.Header.UpdateDate) > EditAcc2.Value) then begin
                  //if boWrite then UniteInfo.DelIDDB.AddRecord(DBRecord.UserEntry.sAccount, I);
                end else begin
                  UniteInfo.IDDB.AddRecord(DBRecord.UserEntry.sAccount, I);
                  sNewName := DBRecord.UserEntry.sAccount;
                  if not boMain then begin
                    if AllID.GetIndex(sNewName) <> -1 then begin
                      sNewName := GetNewName(sNewName, 10, TStringList(AllID));
                      if sNewName = '' then begin
                        Application.MessageBox('重命名帐号失败！', '提示信息', MB_OK + MB_ICONINFORMATION);
                        Exit;
                      end;
                      IDRename.OldName.AddRecord(DBRecord.UserEntry.sAccount, IDRename.NewName.Add(sNewName));
                    end;
                  end;
                  AllID.AddRecord(sNewName, 1);
                end;
              end;
            end;
          end else break;
          ShowProgress(Round((I + 1) / Header.nIDCount * 100));
          Application.ProcessMessages;
        end;
        if boWrite then begin
          if not boMain then begin
            FillChar(Header, SizeOf(Header), #0);

            Header.sDesc := IDDB.sDBHeaderDesc;
            Header.nIDCount := 0;
            Header.nLastIndex := -1;
            Header.dLastDate := Now();
            Header.nDeletedIdx := -1;
            Header.dUpdateDate := Now();
            Header.nIDCount := MainUnite.IDDB.Count + SubUnite.IDDB.Count;
            NewIDDB.Seek(0, 0);
            NewIDDB.Write(Header, SizeOf(Header));

            Header.nIDCount := MainUnite.DelIDDB.Count;
            DelMainIDDB.Seek(0, 0);
            DelMainIDDB.Write(Header, SizeOf(Header));

            Header.nIDCount := SubUnite.DelIDDB.Count;
            DelSubIDDB.Seek(0, 0);
            DelSubIDDB.Write(Header, SizeOf(Header));
          end;
        end;
        Result := True;
      end;
    Finally
      FileStream.Free;
    End;
  end;
end;

function TFormMain.LoadMirDB(sFileName: string; UniteInfo: pTUniteInfo; boMain: Boolean): Boolean;
var
  FileStream: TFileStream;
  Header, NewHeader: HumDB.TDBHeader;
  HumRecord: Grobal2.THumDataInfo;
  IdxHeader: HumDB.TIdxHeader;
  IdxRecord: HumDB.THumInfo;
  I, Idx: Integer;
  DelMir, DelHum: TFileStream;
  boDel: Boolean;
  sName, sAccount: string;
begin
  Result := False;
  ShowProgress(0);
  if FileExists(sFileName) then begin
    FileStream := TFileStream.Create(sFileName, fmOpenRead or fmShareDenyWrite);
    try
      if FileStream.Read(Header, SizeOf(Header)) = SizeOf(Header) then begin
        if Header.sDesc <> HumDB.sDBHeaderDesc then begin
          Result := False;
          Exit;
        end;
        if boMain then begin
          FillChar(NewHeader, SizeOf(NewHeader), #0);
          FillChar(IdxHeader, SizeOf(IdxHeader), #0);
          FillChar(IdxRecord, SizeOf(IdxRecord), #0);

          NewHeader.sDesc := HumDB.sDBHeaderDesc; 
          NewHeader.dUpdateDate := Now;
          NewHeader.nLastIndex := -1;
          NewMirDB.Write(NewHeader, SizeOf(NewHeader));
          DelMainMirDB.Write(NewHeader, SizeOf(NewHeader));
          DelSubMirDB.Write(NewHeader, SizeOf(NewHeader));

          IdxHeader.sDesc := HumDB.sDBHeaderDesc;
          IdxHeader.nLastIndex := -1;
          IdxHeader.dUpdateDate := Now;
          NewHumDB.Write(IdxHeader, SizeOf(IdxHeader));
          DelMainHumDB.Write(IdxHeader, SizeOf(IdxHeader));
          DelSubHumDB.Write(IdxHeader, SizeOf(IdxHeader));
          
          DelMir := DelMainMirDB;
          DelHum := DelMainHumDB;
        end else begin
          DelMir := DelSubMirDB;
          DelHum := DelSubHumDB;
        end;
   
        for I := 0 to Header.nHumCount - 1 do begin
          if FileStream.Read(HumRecord, SizeOf(HumRecord)) = SizeOf(HumRecord) then begin
            boDel := False;
            FillChar(HumRecord.Data.FriendList[0], SizeOf(HumRecord.Data.FriendList), #0);
            ChangeItemIndex(@HumRecord.Data);
            if (HumRecord.Header.sName <> '') then begin
              if HumRecord.Header.boDeleted then begin
                UniteInfo.DelMirDB.AddRecord(HumRecord.Data.sChrName, I);
                boDel := True;
              end
              else if CheckBoxHum3.Checked and (DaysBetween(Now, HumRecord.Header.dwUpdateDate) > EditHum3.Value) then begin
                UniteInfo.DelMirDB.AddRecord(HumRecord.Data.sChrName, I);
                boDel := True;
              end
              else if CheckBoxHum2.Checked and (UniteInfo.HumDB.GetIndex(HumRecord.Data.sChrName) = -1) then begin
                UniteInfo.DelMirDB.AddRecord(HumRecord.Data.sChrName, I);
                boDel := True;
              end else
              if UniteInfo.IDDB.GetIndex(HumRecord.Data.sAccount) = -1 then begin
                UniteInfo.DelMirDB.AddRecord(HumRecord.Data.sChrName, I);
                boDel := True;
              end;

              if boDel then begin
                HumRecord.Data.sGuildName := '';
                DelMir.Write(HumRecord, SizeOf(HumRecord));
                IdxRecord.Header.dwCreateDate := Now;
                IdxRecord.Header.dwUpdateDate := Now;
                IdxRecord.Header.sName := HumRecord.Data.sChrName;
                IdxRecord.sChrName := HumRecord.Data.sChrName;
                IdxRecord.sAccount := HumRecord.Data.sAccount;
                DelHum.Write(IdxRecord, SizeOf(IdxRecord));
              end else begin

                if boMain then begin
                  NewMirDB.Write(HumRecord, SizeOf(HumRecord));
                  IdxRecord.Header.dwCreateDate := Now;
                  IdxRecord.Header.dwUpdateDate := Now;
                  IdxRecord.Header.sName := HumRecord.Data.sChrName;
                  IdxRecord.sChrName := HumRecord.Data.sChrName;
                  IdxRecord.sAccount := HumRecord.Data.sAccount;
                  NewHumDB.Write(IdxRecord, SizeOf(IdxRecord));
                  UniteInfo.MirDB.AddRecord(HumRecord.Data.sChrName, I);
                  MainWriteID.AddRecord(HumRecord.Data.sAccount, 1);
                end else begin
                  sName := '';
                  sAccount := HumRecord.Data.sAccount;
                  SubWriteID.AddRecord(sAccount, 1);
                  Idx := IDRename.OldName.GetIndex(sAccount);
                  
                  if Idx > -1 then begin
                    sAccount := IDRename.NewName[Integer(IDRename.OldName.Objects[Idx])];
                  end;
                  HumRecord.Data.sAccount := sAccount;

                  if HumRecord.Data.sGuildName <> '' then begin
                    Idx := GuildRename.OldName.GetIndex(HumRecord.Data.sGuildName);
                    if Idx > -1 then begin
                      HumRecord.Data.sGuildName := GuildRename.NewName[Integer(GuildRename.OldName.Objects[Idx])];
                    end;
                  end;

                  if MainUnite.MirDB.GetIndex(HumRecord.Data.sChrName) <> -1 then begin
                    sName := GetNewName(HumRecord.Data.sChrName, ActorNameLen, TStringList(MainUnite.MirDB));
                    if sName = '' then begin
                      Application.MessageBox('重命名人物名称失败！', '提示信息', MB_OK + MB_ICONINFORMATION);
                      Exit;
                    end;
                    HumRecord.Data.boChangeName := True;
                    MainUnite.MirDB.AddRecord(sName, I);
                    HumRename.OldName.AddRecord(HumRecord.Data.sChrName, HumRename.NewName.Add(sName));
                    ChangeGuildName(HumRecord.Data.sGuildName, HumRecord.Data.sChrName, sName);
                    //改变行会文件中的人物名称
                  end else begin
                    sName := HumRecord.Data.sChrName;
                    MainUnite.MirDB.AddRecord(sName, I);
                  end;
                    
                  HumRecord.Data.sChrName := sName;
                  HumRecord.Header.sName := sName;
                  NewMirDB.Write(HumRecord, SizeOf(HumRecord));
                  IdxRecord.Header.dwCreateDate := Now;
                  IdxRecord.Header.dwUpdateDate := Now;
                  IdxRecord.Header.sName := HumRecord.Data.sChrName;
                  IdxRecord.sChrName := HumRecord.Data.sChrName;
                  IdxRecord.sAccount := HumRecord.Data.sAccount;
                  NewHumDB.Write(IdxRecord, SizeOf(IdxRecord));
                  UniteInfo.MirDB.AddRecord(HumRecord.Data.sChrName, I);
                end; 
              end;
            end;
          end;
          ShowProgress(Round((I + 1) / Header.nHumCount * 100));
          Application.ProcessMessages;
        end;
        if not boMain then begin
          FillChar(NewHeader, SizeOf(NewHeader), #0);
          FillChar(IdxHeader, SizeOf(IdxHeader), #0);

          NewHeader.sDesc := HumDB.sDBHeaderDesc; 
          NewHeader.dUpdateDate := Now;
          NewHeader.nLastIndex := -1;
          NewHeader.nHumCount := MainUnite.MirDB.Count;
          NewMirDB.Seek(0, 0);
          NewMirDB.Write(NewHeader, SizeOf(NewHeader));

          NewHeader.nHumCount := MainUnite.DelMirDB.Count;
          DelMainMirDB.Seek(0, 0);
          DelMainMirDB.Write(NewHeader, SizeOf(NewHeader));

          NewHeader.nHumCount := SubUnite.DelMirDB.Count;
          DelSubMirDB.Seek(0, 0);
          DelSubMirDB.Write(NewHeader, SizeOf(NewHeader));

          IdxHeader.sDesc := HumDB.sDBHeaderDesc;
          IdxHeader.nLastIndex := -1;
          IdxHeader.dUpdateDate := Now;
          IdxHeader.nHumCount := MainUnite.MirDB.Count;
          NewHumDB.Seek(0, 0);
          NewHumDB.Write(IdxHeader, SizeOf(IdxHeader));

          IdxHeader.nHumCount := MainUnite.DelMirDB.Count;
          DelMainHumDB.Seek(0, 0);
          DelMainHumDB.Write(IdxHeader, SizeOf(IdxHeader));

          IdxHeader.nHumCount := SubUnite.DelMirDB.Count;
          DelSubHumDB.Seek(0, 0);
          DelSubHumDB.Write(IdxHeader, SizeOf(IdxHeader));
        end;
        Result := True;
      end;
    finally
      FileStream.Free;
    end;
  end;
end;

procedure TFormMain.Lock(boLock: Boolean);
begin
  EditMainID.Enabled := boLock;
  EditMainHum.Enabled := boLock;
  EditMainMir.Enabled := boLock;
  EditMainGuild.Enabled := boLock;
  EditMainEMail.Enabled := boLock;
  EditSubID.Enabled := boLock;
  EditSubHum.Enabled := boLock;
  EditSubMir.Enabled := boLock;
  EditSubGuild.Enabled := boLock;
  EditSubEMail.Enabled := boLock;

  ButtonMainID.Enabled := boLock;
  ButtonMainHum.Enabled := boLock;
  ButtonMainMir.Enabled := boLock;
  ButtonMainGuild.Enabled := boLock;
  ButtonMainEMail.Enabled := boLock;
  ButtonSubID.Enabled := boLock;
  ButtonSubHum.Enabled := boLock;
  ButtonSubMir.Enabled := boLock;
  ButtonSubGuild.Enabled := boLock;
  ButtonSubEMail.Enabled := boLock;

  CheckBoxAcc1.Enabled := boLock;
  CheckBoxAcc2.Enabled := boLock;
  EditAcc2.Enabled := boLock and CheckBoxAcc2.Checked;
  CheckBoxHum1.Enabled := boLock;
  CheckBoxHum2.Enabled := boLock;

  CheckBoxHum3.Enabled := boLock;
  EditHum3.Enabled := boLock and CheckBoxHum3.Checked;
  //EditHum31.Enabled := boLock and CheckBoxHum3.Checked;
  CheckBoxRefID.Enabled := boLock;
  EditSaveDir.Enabled := boLock;
  ButtonSaveDir.Enabled := boLock;
  ButtonState.Enabled := boLock;
  //ButtonLog.Enabled := boLock;
  Label11.Enabled := boLock;
  Label12.Enabled := boLock;
  //Label13.Enabled := boLock;

end;

procedure TFormMain.ShowHint(sHint: string; boError: Boolean);
begin
  if boError then
    Panel1.Font.Color := clRed
  else
    Panel1.Font.Color := clBlue;
  Panel1.Caption := sHint;
end;

procedure TFormMain.ShowProgress(nProgress: Integer);
begin
  if nProgress < 0 then
    nProgress := 0;
  if nProgress > 100 then
    nProgress := 100;
  if m_OldProgress <> nProgress then begin
    m_OldProgress := nProgress;
    ProgressBar1.Position := nProgress;
  end;
end;

function TFormMain.ChangeGuildName(sGuildName, sOldName, sNewName: string): Boolean;
var
  sFileName, sTempStr: string;
  LoadList: TStringList;
begin
  Result := False;
  sFileName := SaveDir + 'GuildBase\Guilds\' + sGuildName + '.ini';
  if FileExists(sFileName) then begin
    LoadList := TStringList.Create;
    LoadList.LoadFromFile(sFileName);
    sTempStr := LoadList.Text;
    sTempStr := AnsiReplaceText(sTempStr, 'CreateGuildName=' + sOldName + #13#10, 'CreateGuildName=' + sNewName + #13#10);
    sTempStr := AnsiReplaceText(sTempStr, #13#10 + sOldName + '=', #13#10 + sNewName + '=');
    LoadList.SetText(PChar(sTempStr));
    LoadList.SaveToFile(sFileName);
    LoadList.Free;
  end;
end;

procedure TFormMain.ChangeItemIndex(HumData: pTHumData);
  function GetItemIndex: Integer;
  begin
    Inc(ItemIndex);
    Result := ItemIndex;
  end;
var
  I: Integer;
  UserItem: pTUserItem;
begin
  if not CheckBoxRefid.Checked then Exit;
  for I := Low(HumData.ReturnItems) to High(HumData.ReturnItems) do begin
    UserItem := @HumData.ReturnItems[I];
    if (UserItem.wIndex > 0) and (UserItem.MakeIndex > 0) then
      UserItem.MakeIndex := GetItemIndex;
  end;

  for I := Low(HumData.AppendBagItems) to High(HumData.AppendBagItems) do begin
    UserItem := @HumData.AppendBagItems[I];
    if (UserItem.wIndex > 0) and (UserItem.MakeIndex > 0) then
      UserItem.MakeIndex := GetItemIndex;
  end;

  for I := Low(HumData.HumItems) to High(HumData.HumItems) do begin
    UserItem := @HumData.HumItems[I];
    if (UserItem.wIndex > 0) and (UserItem.MakeIndex > 0) then
      UserItem.MakeIndex := GetItemIndex;
  end;

  for I := Low(HumData.BagItems) to High(HumData.BagItems) do begin
    UserItem := @HumData.BagItems[I];
    if (UserItem.wIndex > 0) and (UserItem.MakeIndex > 0) then
      UserItem.MakeIndex := GetItemIndex;
  end;

  for I := Low(HumData.StorageItems) to High(HumData.StorageItems) do begin
    UserItem := @HumData.StorageItems[I].UserItem;
    if (UserItem.wIndex > 0) and (UserItem.MakeIndex > 0) then
      UserItem.MakeIndex := GetItemIndex;
  end;

  for I := Low(HumData.StorageItems2) to High(HumData.StorageItems2) do begin
    UserItem := @HumData.StorageItems2[I].UserItem;
    if (UserItem.wIndex > 0) and (UserItem.MakeIndex > 0) then
      UserItem.MakeIndex := GetItemIndex;
  end;

  for I := Low(HumData.StorageItems3) to High(HumData.StorageItems3) do begin
    UserItem := @HumData.StorageItems3[I].UserItem;
    if (UserItem.wIndex > 0) and (UserItem.MakeIndex > 0) then
      UserItem.MakeIndex := GetItemIndex;
  end;
end;

function TFormMain.UniteGuild(sSaveDir: string; RenameList: pTRenameList): Boolean;
var
  MainGuildDir, SubGuildDir: string;
  MainList, SubList: TStringList;
  I: Integer;
  sName: string;
begin
  Result := False;
  MainGuildDir := Trim(EditMainGuild.Text);
  SubGuildDir := Trim(EditSubGuild.Text);
  MainList := TStringList.Create;
  SubList := TStringList.Create;
  CreateDir(sSaveDir);
  CreateDir(sSaveDir + 'Guilds\');
  if RightStr(MainGuildDir, 1) <> '\' then
    MainGuildDir := MainGuildDir + '\';
  if RightStr(SubGuildDir, 1) <> '\' then
    SubGuildDir := SubGuildDir + '\';
  if FileExists(MainGuildDir + 'GuildList.txt') and FileExists(SubGuildDir + 'GuildList.txt') then begin
    MainList.LoadFromFile(MainGuildDir + 'GuildList.txt');
    SubList.LoadFromFile(SubGuildDir + 'GuildList.txt');
    for I := 0 to MainList.Count - 1 do begin
      if FileExists(MainGuildDir + 'Guilds\' + MainList[I] + '.ini') then
        CopyFile(PChar(MainGuildDir + 'Guilds\' + MainList[I] + '.ini'), PChar(sSaveDir + 'Guilds\' + MainList[I] + '.ini'), False);
    end;
    for I := 0 to SubList.Count - 1 do begin
      if FileExists(SubGuildDir + 'Guilds\' + SubList[I] + '.ini') then begin
        sName := SubList[I];
        if MainList.IndexOf(sName) <> -1 then begin
          sName := GetNewName(sName, ActorNameLen, MainList);
          if sName = '' then begin
            Application.MessageBox('重命名行会名称失败！', '提示信息', MB_OK + MB_ICONINFORMATION);
            Exit;
          end;
          MainList.Add(sName);
          RenameList.OldName.AddRecord(SubList[I], RenameList.NewName.Add(sName));
        end else begin
          MainList.Add(sName);
          //RenameList.OldName.AddRecord(SubList[I], RenameList.NewName.Add(sName));
        end;
        CopyFile(PChar(SubGuildDir + 'Guilds\' + SubList[I] + '.ini'), PChar(sSaveDir + 'Guilds\' + sName + '.ini'), False);
      end;
    end;
    MainList.SaveToFile(sSaveDir + 'GuildList.txt');
    SubList.Clear;
    for I := 0 to RenameList.OldName.Count - 1 do begin
      SubList.Add(RenameList.OldName[I] + ' --> ' + RenameList.NewName[Integer(RenameList.OldName.Objects[I])]);
    end;
    SubList.SaveToFile(CurrentDir + 'GuildLog.txt');
    Result := True;
  end;
  MainList.Free;
  SubList.Free;
end;

procedure TFormMain.UpdateTextFileList(const ASaveDir: string);
var
  i, j, k: Integer;
  sText, sFrom, sTo: string;
  vStringList, tmp: TStringList;
begin
  vStringList := TStringList.Create;
  tmp := TStringList.Create;
  try
    for i := 0 to ListBox1.Items.Count - 1 do
    begin
      sText := ListBox1.Items[i];
      sText := GetValidStr3(sText, sTo, ['<']);
      sFrom := GetValidStr3(sText, sText, [' ']);
      if not (FileExists(sTo) and FileExists(sFrom)) then
        Continue;
      vStringList.Clear;
      vStringList.LoadFromFile(sTo);
      tmp.Clear;
      tmp.LoadFromFile(sFrom);
      for j := 0 to tmp.Count - 1 do
      begin
        sText := tmp.Strings[j];
        if Trim(sText) = '' then
          Continue;
        k := HumRename.OldName.IndexOf(sText);
        if (k >= 0) then
          vStringList.Add(HumRename.NewName[Integer(HumRename.OldName.Objects[k])])
        else
          vStringList.Add(sText);
      end;
      vStringList.SaveToFile(ASaveDir + ExtractFileName(sTo));
    end;
  finally
    tmp.Free;
    vStringList.Free;
  end;
  //sFrom :=
end;

end.

