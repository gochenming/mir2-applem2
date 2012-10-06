unit FrmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, ComCtrls, ExtCtrls, DB, DBTables, StdCtrls, TypInfo, Menus;

type
  TFormMain = class(TForm)
    PageControl: TPageControl;
    TabSheet: TTabSheet;
    Panel: TPanel;
    Grid: TStringGrid;
    ComboBox: TComboBox;
    Query: TQuery;
    Database: TDatabase;
    MainMenu1: TMainMenu;
    S1: TMenuItem;
    H1: TMenuItem;
    A1: TMenuItem;
    QuerySet: TQuery;
    N1: TMenuItem;
    N2: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure PageControlChange(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
  private

    DefTabSheets: TTabSheet;
    procedure RefTabItem();
    procedure CopyTab(Name: string; index: Integer);
    procedure RefTabSheetItem(Sheet: TTabSheet);
    function CopyComponent(mSource: TComponent; mParent: TComponent; mOwner: TComponent): TComponent;
    function GetComponent(mSource: TComponent; Hint: string): TComponent;
  public

  end;

var
  FormMain: TFormMain;

implementation
uses
  FrmLogin, Share, SwitchDB,Grobal2;

{$R *.dfm}

procedure TFormMain.FormCreate(Sender: TObject);
var
  DatabaseList: TStringList;
  I: Integer;
begin
  for I := Low(TabSheets) to High(TabSheets) do TabSheets[i] := nil;
  DefTabSheets := nil;
  ComboBox.Hint := TABNAMECOMBOX;
  Grid.Hint := DBGRID;
  TabSheets[0] := TabSheet;
  FormLogin := TFormLogin.Create(Self);
  DatabaseList := TStringList.Create;
  try
    Query.DBSession.GetDatabaseNames(DatabaseList);

    FormLogin.ComboBox.Items.Clear;
    for i := 0 to DatabaseList.Count - 1 do
    begin
      FormLogin.ComboBox.Items.Add(DatabaseList[i]);
    end;

  finally
    DatabaseList.Free;
  end;
  FormLogin.ShowModal;
  FormLogin.Free;
  if DBNAME = '' then
  begin
    PostMessage(Handle, WM_CLOSE, 0, 0);
    Exit;
  end;
  Query.DatabaseName := DBNAME;
  QuerySet.DatabaseName := DBNAME;
  Database.DatabaseName := DBNAME;
  RefTabItem();
end;

function TFormMain.GetComponent(mSource: TComponent; Hint: string): TComponent;
var
  i: Integer;
begin
  Result := nil;
  if mSource is TWinControl then
    for I := 0 to TWinControl(mSource).ControlCount - 1 do
    begin
      if TWinControl(mSource).Controls[I].Hint = Hint then
      begin
        Result := TWinControl(mSource).Controls[I];
        Exit;
      end;
      Result := GetComponent(TWinControl(mSource).Controls[I], Hint);
      if Result <> nil then exit;
    end;
end;

procedure TFormMain.N1Click(Sender: TObject);
begin
  FormSwitch := TFormSwitch.Create(Application);
  FormSwitch.Open;
  FormSwitch.Free;
end;

procedure TFormMain.N2Click(Sender: TObject);
resourcestring
  sSQLString = 'select * from ';
  sFileName = '.\goods.dat';
var
  StdItem : TStdItem;
  StringGrid: TStringGrid;
  TableComBox: TComboBox;
  DatabaseList: TStringList;
  I, II: Integer;
  FileHandle: Integer;
  sDesc: string;
begin
  StringGrid := GetComponent(DefTabSheets, DBGRID) as TStringGrid;
  TableComBox := GetComponent(DefTabSheets, TABNAMECOMBOX) as TComboBox;
  if (StringGrid <> nil) and (TableComBox <> nil) then
  begin
    Query.SQL.Clear;
    Query.SQL.Add(sSQLString + DefTabSheets.Caption);
    try
      Query.Open;
      if FileExists(sFileName) then DeleteFile(PChar(sFileName));
      FileHandle := FileCreate(PChar(sFileName));
      for I := 0 to Query.RecordCount - 1 do
      begin
        FillChar(StdItem,SizeOf(TStdItem),#0);
        StdItem.Idx := Query.FieldByName('Idx').AsInteger;
        StdItem.Name := Query.FieldByName('Name').AsString;
        StdItem.StdMode2 := Query.FieldByName('StdMode').AsInteger;
        StdItem.Shape := Query.FieldByName('Shape').AsInteger;
        StdItem.Weight := Query.FieldByName('Weight').AsInteger;
        StdItem.AniCount := Query.FieldByName('AniCount').AsInteger;
        StdItem.Source := Query.FieldByName('Source').AsInteger;
        StdItem.Reserved := Query.FieldByName('Reserved').AsInteger;
        StdItem.Looks := Query.FieldByName('Looks').AsInteger;
        StdItem.DuraMax := Query.FieldByName('DuraMax').AsInteger;
        StdItem.nAC := Query.FieldByName('AC').AsInteger;
        StdItem.nAC2 := Query.FieldByName('AC2').AsInteger;
        StdItem.nMAC := Query.FieldByName('MAC').AsInteger;
        StdItem.nMAC2 := Query.FieldByName('MAC2').AsInteger;
        StdItem.nDC := Query.FieldByName('DC').AsInteger;
        StdItem.nDC2 := Query.FieldByName('DC2').AsInteger;
        StdItem.nMC := Query.FieldByName('MC').AsInteger;
        StdItem.nMC2 := Query.FieldByName('MC2').AsInteger;
        StdItem.nSC := Query.FieldByName('SC').AsInteger;
        StdItem.nSC2 := Query.FieldByName('SC2').AsInteger;
        StdItem.HP := Query.FieldByName('HP').AsInteger;
        StdItem.MP := Query.FieldByName('MP').AsInteger;
        //StdItem.Nicety := Query.FieldByName('Nicety').AsInteger;
        //StdItem.Celerity := Query.FieldByName('Celerity').AsInteger;
        StdItem.Strong := Query.FieldByName('Strong').AsInteger;
        StdItem.Luck := Query.FieldByName('Luck').AsInteger;
        //StdItem.UnLuck := Query.FieldByName('UnLuck').AsInteger;
        StdItem.HitSpeed := Query.FieldByName('HitSpeed').AsInteger;
        StdItem.AntiMagic := Query.FieldByName('AntiMagic').AsInteger;
        StdItem.PoisonMagic := Query.FieldByName('PoisonMagic').AsInteger;
        StdItem.HealthRecover := Query.FieldByName('HealthRecover').AsInteger;
        StdItem.SpellRecover := Query.FieldByName('SpellRecover').AsInteger;
        StdItem.PoisonRecover := Query.FieldByName('PoisonRecover').AsInteger;
        //StdItem.Dunt := Query.FieldByName('Dunt').AsInteger;
        //StdItem.Bind := Query.FieldByName('Bind').AsInteger;
        //StdItem.Wuxin := Query.FieldByName('Wuxin').AsInteger;
        //StdItem.DropItemRate := Query.FieldByName('DropItem').AsInteger;
        StdItem.Need := Query.FieldByName('Need').AsInteger;
        StdItem.NeedLevel := Query.FieldByName('NeedLevel').AsInteger;
        StdItem.Price := Query.FieldByName('Price').AsInteger;
        sDesc := Query.FieldByName('SDesc').AsString;
        //StdItem.WuxinCount := Length(sDesc);
        FileWrite(FileHandle,StdItem,SizeOf(Stditem));
        {if StdItem.WuxinCount > 0 then
          FileWrite(FileHandle,sDesc[1],StdItem.WuxinCount); }
        Query.Next;
      end;
    finally
      Query.Close;
      FileClose(FileHandle);
    end;
    Application.MessageBox('写出完成！', '提示信息', MB_OK + 
      MB_ICONINFORMATION);

  end;
end;

procedure TFormMain.RefTabItem;
var
  DatabaseList: TStringList;
  I: Integer;
begin
  DatabaseList := TStringList.Create;
  try
    Database.Open;
    Database.GetTableNames(DatabaseList);
    DBList.Clear;
    DBList.Assign(DatabaseList);
    for i := 0 to DatabaseList.Count - 1 do
    begin
      if i = 0 then
      begin
        TabSheets[0].Caption := DatabaseList[i] + '.DB';
      end else
        CopyTab(DatabaseList[i] + '.DB', i);
    end;
  finally
    DatabaseList.Free;
    Database.Close;
  end;
  PageControlChange(TabSheets[0]);
end;

procedure TFormMain.RefTabSheetItem(Sheet: TTabSheet);
resourcestring
  sSQLString = 'select * from ';
var
  StringGrid: TStringGrid;
  TableComBox: TComboBox;
  DatabaseList: TStringList;
  I, II: Integer;
begin
  StringGrid := GetComponent(Sheet, DBGRID) as TStringGrid;
  TableComBox := GetComponent(Sheet, TABNAMECOMBOX) as TComboBox;
  if (StringGrid <> nil) and (TableComBox <> nil) then
  begin
    Query.SQL.Clear;
    Query.SQL.Add(sSQLString + Sheet.Caption);
    try
      Query.Open;
      TableComBox.Clear;
      DatabaseList := TStringList.Create;
      try
        Query.GetFieldNames(DatabaseList);
        if DatabaseList.Count > 0 then StringGrid.ColCount := DatabaseList.Count
        else StringGrid.ColCount := 1;


        for i := 0 to DatabaseList.Count - 1 do
        begin
          TableComBox.Items.Add(DatabaseList[i]);
          StringGrid.Cells[i, 0] := DatabaseList[i];
        end;
        if Query.RecordCount > 0 then StringGrid.RowCount := Query.RecordCount + 1
        else
        begin
          StringGrid.RowCount := 2;
          for i := 0 to StringGrid.ColCount - 1 do
            StringGrid.Cells[i, 1] := '';
        end;

        for I := 0 to Query.RecordCount - 1 do
        begin
          for ii := 0 to DatabaseList.Count - 1 do
          begin
            StringGrid.Cells[ii, i + 1] := Query.FieldByName(DatabaseList[ii]).AsString;
          end;
          Query.Next;
        end;
      finally
        DatabaseList.Free;
      end;
    finally
      Query.Close;
    end;
  end;
  Sheet.Tag := 1;
end;

function TFormMain.CopyComponent(mSource: TComponent; mParent: TComponent; mOwner: TComponent): TComponent;
var
  vComponent: TComponent;
  I: Integer;
  vMemoryStream: TMemoryStream;
  vReader: TReader;
  vPropList: PPropList;
  vPropInfo: PPropInfo;
begin
  vComponent := nil;

  vMemoryStream := TMemoryStream.Create;
  vReader := TReader.Create(vMemoryStream, 256);
  try
    try
      vMemoryStream.WriteComponent(mSource);
      vMemoryStream.Position := 0;
      vReader.Parent := mParent;
      vComponent := vReader.ReadRootComponent(nil);

      for I := 0 to GetPropList(mSource, vPropList) - 1 do begin
        vPropInfo := vPropList^[I];
        if vPropInfo^.PropType^.Kind = tkMethod then
          SetMethodProp(vComponent, vPropInfo^.Name, GetMethodProp(mSource, vPropInfo^.Name));
      end;
      Result := vComponent;
    except
      Result := nil;
    end;
  finally
    vReader.Free;
    vMemoryStream.Free;
  end;

  if mSource is TWinControl then
    for I := 0 to TWinControl(mSource).ControlCount - 1 do
      if CopyComponent(TWinControl(mSource).Controls[I], vComponent, mOwner) = nil then Exit;
end;

procedure TFormMain.CopyTab(Name: string; index: Integer);
begin
  RegisterClasses([TTabSheet, TPanel, TComboBox, TStringGrid, TPageControl]);
  TabSheets[index] := CopyComponent(TabSheet, PageControl, Self) as TTabSheet;
  TabSheets[index].Caption := Name;
  UnRegisterClasses([TTabSheet, TPanel, TComboBox, TStringGrid, TPageControl]);
end;

procedure TFormMain.PageControlChange(Sender: TObject);
begin
  DefTabSheets := TabSheets[PageControl.TabIndex];
  if DefTabSheets = nil then exit;
  if DefTabSheets.Tag = 0 then RefTabSheetItem(DefTabSheets);
end;

end.

