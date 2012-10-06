unit FrmGoods;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, grobal2, Hutil32,
  Dialogs, bsSkinCtrls, StdCtrls, Mask, bsSkinBoxCtrls, bsSkinData, DB, DBTables, ComCtrls, bsSkinTabs;

type
  pTGoodsStditem = ^TGoodsStditem;
  TGoodsStditem = packed record
    sItemname: string[14];
    isshow: Boolean;
    Filtrate: TClientItemFiltrate;
    sDesc: string[255];
  end;

  pTGoodsMagic = ^TGoodsMagic;
  TGoodsMagic = packed record
    sMagID: Word;
    isshow: Boolean;
    sDesc: string[255];
  end;

  pTItemStditem = ^TItemStditem;
  TItemStditem = packed record
    Item: TListItem;
    StdItem: TStdItem;
    Bind: LongWord;
    //isshow: Boolean;
    //Filtrate: TClientItemFiltrate;
    sDesc: string[255];
    boChange: Boolean;
  end;

  pTItemMagic = ^TItemMagic;
  TItemMagic = packed record
    Item: TListItem;
    Magic: TMagic;
    isshow: Boolean;
    sDesc: string[255];
    boChange: Boolean;
  end;

  TFrameGoods = class(TFrame)
    DSkinData: TbsSkinData;
    GroupBoxBg: TbsSkinGroupBox;
    bsSkinGroupBox3: TbsSkinGroupBox;
    bsSkinStdLabel10: TbsSkinStdLabel;
    ButtonSave: TbsSkinButton;
    ComboBoxDBList: TbsSkinComboBox;
    Query: TQuery;
    DBPageControl: TbsSkinPageControl;
    bsSkinTabSheet1: TbsSkinTabSheet;
    bsSkinTabSheet2: TbsSkinTabSheet;
    ListViewStdItems: TbsSkinListView;
    ScrollBarStditemsRight: TbsSkinScrollBar;
    ScrollBarStdItemsBottom: TbsSkinScrollBar;
    ListViewMagic: TbsSkinListView;
    ScrollBarMagicRight: TbsSkinScrollBar;
    ScrollBarMagicBottom: TbsSkinScrollBar;
    ButtonLoad: TbsSkinButton;
    ButtonRefItemID: TbsSkinButton;
    procedure ComboBoxDBListChange(Sender: TObject);
    procedure ListViewStdItemsMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ListViewStdItemsColumnClick(Sender: TObject; Column: TListColumn);
    procedure ListViewStdItemsCompare(Sender: TObject; Item1, Item2: TListItem; Data: Integer; var Compare: Integer);
    procedure ListViewMagicMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure CheckBoxDBSelectAllClick(Sender: TObject);
    procedure DBPageControlChange(Sender: TObject);
    procedure ButtonRefItemIDClick(Sender: TObject);
    procedure ButtonLoadClick(Sender: TObject);
    procedure ButtonSaveClick(Sender: TObject);
  private
    procedure RefTabItem();
    procedure RefMagicTabItem();
    procedure ClearStdItem();
    procedure ClearMagic();
    procedure SetStdItemStatus(Title: string);
    procedure SetMagicStatus(Title: string);
    procedure SaveSaveItem();
    procedure SaveSaveMagic();
  public
    procedure Open();
  end;

implementation

{$R *.dfm}

uses
  FrmMain, FShare;

var
  DBList: TList;
  MagicList: TList;
  SaveList: TList;
  SaveMagicList: TList;
  boStdItemSelect: Boolean = False;
  boStdItemBack: Boolean = False;
  boChange: Boolean = False;
  boMagicBack: Boolean = False;
  boMagicSelect: Boolean = False;
  DescStr: string;
  ColumnToSort: Integer;
  boFrist: Boolean = False;

  { TFrameGoods }

procedure TFrameGoods.ButtonLoadClick(Sender: TObject);
begin
  if FormMain.DMsg.MessageDlg('是否确定重新加载配置信息？', mtConfirmation, [mbYes, mbNo], 0) = mrYes then begin
    RefTabItem;
    RefMagicTabItem;
    boChange := False;
    ButtonLoad.Enabled := False;
    ButtonSave.Enabled := False;
  end;
end;

procedure TFrameGoods.ButtonRefItemIDClick(Sender: TObject);
resourcestring
  sSQLString = 'UPDATE StdItems.DB set Idx=%d where Name=' + '''%s''';
var
  i: Integer;
  ClientStditem: pTItemStditem;
begin
  FormMain.ShowHint('正在重新排列物品数据库ID...');
  for i := 0 to DBList.Count - 1 do begin
    ClientStditem := DBList.Items[i];
    Query.SQL.Clear;
    Query.SQL.Add(Format(sSQLString, [i, ClientStditem.StdItem.Name]));
    Query.ExecSQL;
    Query.Close;
    FormMain.ShowProgress(Round((i / (DBList.Count - 1)) * 100));
  end;
  RefTabItem;
end;

procedure TFrameGoods.CheckBoxDBSelectAllClick(Sender: TObject);
{var
  i: Integer;
  Item: TListItem;   }
begin
{  if DBPageControl.TabIndex = 0 then begin
    ListViewStdItems.Visible := False;
    Try
      for i := 0 to ListViewStdItems.Items.Count - 1 do begin
        Item := ListViewStdItems.Items[i];
        Item.Selected := CheckBoxDBSelectAll.Checked;
      end;
    Finally
      ListViewStdItems.Visible := True;
    End;
  end
  else begin
    ListViewMagic.Visible := False;
    Try
      for i := 0 to ListViewMagic.Items.Count - 1 do begin
        Item := ListViewMagic.Items[i];
        Item.Selected := CheckBoxDBSelectAll.Checked;
      end;
    Finally
      ListViewMagic.Visible := True;
    End;
  end;  }
end;

procedure TFrameGoods.ClearMagic;
var
  i: Integer;
begin
  for i := 0 to MagicList.Count - 1 do begin
    Dispose(pTItemMagic(MagicList[i]));
  end;
  MagicList.Clear;
end;

procedure TFrameGoods.ClearStdItem;
var
  i: Integer;
begin
  for i := 0 to DBList.Count - 1 do begin
    Dispose(pTItemStditem(DBList[i]));
  end;
  DBList.Clear;
end;

procedure TFrameGoods.ComboBoxDBListChange(Sender: TObject);
begin
  if ComboBoxDBList.ItemIndex > -1 then begin
    if Trim(ComboBoxDBList.Items[ComboBoxDBList.ItemIndex]) <> '' then begin
      Query.DatabaseName := ComboBoxDBList.Items[ComboBoxDBList.ItemIndex];
      ButtonSave.Enabled := False;
      ButtonLoad.Enabled := False;
      ButtonRefItemID.Enabled := False;
      FormMain.Lock(True);
      try
        RefTabItem();
        RefMagicTabItem();
        FormMain.ShowHint('数据库加载完成...');
        ButtonRefItemID.Enabled := DBPageControl.TabIndex = 0;
      finally
        FormMain.Lock(False);
      end;
    end;
  end;
end;

procedure TFrameGoods.DBPageControlChange(Sender: TObject);
begin
  ButtonRefItemID.Enabled := DBPageControl.TabIndex = 0;
end;

procedure TFrameGoods.ListViewMagicMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  Column: TListColumn;
  i: Integer;
  nLen: Integer;
begin
  if mbRight = Button then begin
    nLen := 0;
    if ScrollBarMagicBottom.Visible then
      Inc(X, ScrollBarMagicBottom.Position);
    for i := 0 to ListViewMagic.Columns.Count - 1 do begin
      Column := ListViewMagic.Columns.Items[i];
      Inc(nLen, Column.Width);
      if nLen > X then begin
        SetMagicStatus(Column.Caption);
        Break;
      end;
    end;
  end;
end;

procedure TFrameGoods.ListViewStdItemsColumnClick(Sender: TObject; Column: TListColumn);
begin
  if ColumnToSort = Column.Index then
    boStdItemBack := not boStdItemBack;
  ColumnToSort := Column.Index;
  (Sender as TCustomListView).AlphaSort;
end;

procedure TFrameGoods.ListViewStdItemsCompare(Sender: TObject; Item1, Item2: TListItem; Data: Integer; var Compare: Integer);
var
  ix: Integer;
begin
  if ColumnToSort = 0 then begin
    Compare := CompareStr(Item1.Caption, Item2.Caption);
    if not boStdItemBack then
      Compare := -Compare;
  end
  else begin
    ix := ColumnToSort - 1;
    Compare := CompareStr(Item1.SubItems[ix], Item2.SubItems[ix]);
    if not boStdItemBack then
      Compare := -Compare;
  end;
end;

procedure TFrameGoods.ListViewStdItemsMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  Column: TListColumn;
  i: Integer;
  nLen: Integer;
begin
  if mbRight = Button then begin
    nLen := 0;
    if ScrollBarStdItemsBottom.Visible then
      Inc(X, ScrollBarStdItemsBottom.Position);
    for i := 0 to ListViewStditems.Columns.Count - 1 do begin
      Column := ListViewStditems.Columns.Items[i];
      Inc(nLen, Column.Width);
      if nLen > X then begin
        SetStdItemStatus(Column.Caption);
        Break;
      end;
    end;
  end;
end;

procedure TFrameGoods.Open;
var
  DatabaseList: TStringList;
  I: Integer;
begin
  if not boFrist then begin
    boFrist := True;
    ListViewStdItems.Items.Clear;
    ListViewMagic.Items.Clear;
    ClearStdItem();
    ClearMagic();
    ComboBoxDBList.ItemIndex := ComboBoxDBList.Items.Add(' ');
    ComboBoxDBList.Items.Clear;
    DatabaseList := TStringList.Create;
    try
      Query.DBSession.GetDatabaseNames(DatabaseList);
      for i := 0 to DatabaseList.Count - 1 do begin
        ComboBoxDBList.Items.Add(DatabaseList[i]);
      end;
    finally
      DatabaseList.Free;
    end;
    DBPageControl.TabIndex := 0;
    ButtonRefItemID.Enabled := False;
    ButtonSave.Enabled := False;
    ButtonLoad.Enabled := False;
  end;
end;

procedure TFrameGoods.RefMagicTabItem;
resourcestring
  sSQLString = 'select * from Magic.DB';
var
  ItemMagic: pTItemMagic;
  i: integer;
  Item: TListItem;
begin
  ListViewMagic.Visible := False;
  ListViewMagic.Items.Clear;
  ClearMagic;
  Query.SQL.Clear;
  Query.SQL.Add(sSQLString);
  FormMain.ShowHint('正在加载技能数据库设置...');
  try

    Query.Open;
    for I := 0 to Query.RecordCount - 1 do begin
      New(ItemMagic);
      FillChar(ItemMagic^, SizeOf(TItemMagic), #0);
      ItemMagic.Magic.wMagicId := Query.FieldByName('MagId').AsInteger;
      ItemMagic.Magic.sMagicName := Query.FieldByName('MagName').AsString;
      ItemMagic.Magic.wMagicIcon := Query.FieldByName('MagicIcon').AsInteger;
      ItemMagic.Magic.btEffectType := Query.FieldByName('EffectType').AsInteger;
      ItemMagic.Magic.btEffect := Query.FieldByName('Effect').AsInteger;
      ItemMagic.Magic.wSpell := Query.FieldByName('Spell').AsInteger;
      ItemMagic.Magic.btDefSpell := Query.FieldByName('DefSpell').AsInteger;
      ItemMagic.Magic.wPower := Query.FieldByName('Power').AsInteger;
      ItemMagic.Magic.wMaxPower := Query.FieldByName('MaxPower').AsInteger;
      ItemMagic.Magic.btJob := Query.FieldByName('Job').AsInteger;
      ItemMagic.Magic.TrainLevel[0] := Query.FieldByName('NeedL1').AsInteger;
      ItemMagic.Magic.TrainLevel[1] := Query.FieldByName('NeedL2').AsInteger;
      ItemMagic.Magic.TrainLevel[2] := Query.FieldByName('NeedL3').AsInteger;
      ItemMagic.Magic.TrainLevel[3] := Query.FieldByName('NeedL3').AsInteger;
      ItemMagic.Magic.MaxTrain[0] := Query.FieldByName('L1Train').AsInteger;
      ItemMagic.Magic.MaxTrain[1] := Query.FieldByName('L2Train').AsInteger;
      ItemMagic.Magic.MaxTrain[2] := Query.FieldByName('L3Train').AsInteger;
      ItemMagic.Magic.MaxTrain[3] := ItemMagic.Magic.MaxTrain[2];
      ItemMagic.Magic.btTrainLv := Query.FieldByName('NeedMax').AsInteger;
      ;
      ItemMagic.Magic.dwDelayTime := Query.FieldByName('Delay').AsInteger;
      ItemMagic.Magic.btDefPower := Query.FieldByName('DefPower').AsInteger;
      ItemMagic.Magic.btDefMaxPower := Query.FieldByName('DefMaxPower').AsInteger;
      ItemMagic.Magic.nInterval := Query.FieldByName('Interval').AsInteger;
      ItemMagic.Magic.nSpellFrame := Query.FieldByName('SpellFrame').AsInteger;
      ItemMagic.sDesc := Query.FieldByName('Text').AsString;
      ItemMagic.isshow := Query.FieldByName('Bind').AsInteger <> 0;
      if ItemMagic.Magic.wMagicId > 0 then begin
        MagicList.Add(ItemMagic);
        ItemMagic.boChange := False;
        //SetMagic(ItemMagic);
        Item := ListViewMagic.Items.Add;
        Item.Caption := Format('%.3d', [ItemMagic.Magic.wMagicId]);
        Item.SubItems.AddObject(ItemMagic.Magic.sMagicName, TObject(ItemMagic));
        if ItemMagic.isshow then
          Item.SubItems.Add('√')
        else
          Item.SubItems.Add(' ');
        Item.SubItems.Add(IntToStr(ItemMagic.Magic.btJob));
        Item.SubItems.Add(IntToStr(ItemMagic.Magic.dwDelayTime));
        Item.SubItems.Add(IntToStr(ItemMagic.Magic.nInterval));
        Item.SubItems.Add(ItemMagic.sDesc);
        ItemMagic.Item := Item;
        ItemMagic.boChange := False;
      end
      else begin
        DisPose(ItemMagic);
      end;
      Query.Next;
      FormMain.ShowProgress(Round((i / (Query.RecordCount - 1)) * 100));
    end;
    FormMain.ShowHint('技能数据库加载完成...');
  finally
    Query.Close;
    ListViewMagic.Visible := True;
  end;
end;

procedure TFrameGoods.RefTabItem;
resourcestring
  sSQLString = 'select * from StdItems.DB';
var
  i, ii: Integer;
  ClientStditem: pTItemStditem;
  StdItem: pTStdItem;
  Item: TListItem;
begin
  ListViewStdItems.Visible := False;
  ListViewStdItems.Items.Clear;
  ClearStdItem;
  Query.SQL.Clear;
  Query.SQL.Add(sSQLString);
  FormMain.ShowHint('正在加载物品数据库设置...');
  try
    Query.Open;
    for I := 0 to Query.RecordCount - 1 do begin
      New(ClientStditem);
      FillChar(ClientStditem^, SizeOf(TItemStditem), #0);
      StdItem := @ClientStditem.StdItem;
      StdItem.Idx := Query.FieldByName('Idx').AsInteger;
      StdItem.Name := Query.FieldByName('Name').AsString;
      StdItem.StdMode2 := Query.FieldByName('StdMode').AsInteger;
      StdItem.Shape := Query.FieldByName('Shape').AsInteger;
      StdItem.Weight := Query.FieldByName('Weight').AsInteger;
      StdItem.AniCount := Query.FieldByName('AniCount').AsInteger;
      StdItem.Source := Query.FieldByName('Source').AsInteger;
      StdItem.Reserved := Query.FieldByName('Reserved').AsInteger;
      StdItem.Looks := Query.FieldByName('Looks').AsInteger;
      StdItem.Effect := Query.FieldByName('Effect').AsInteger;
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
      StdItem.AddAttack := Query.FieldByName('AddDamage').AsInteger;
      StdItem.DelDamage := Query.FieldByName('DelDamage').AsInteger;
      StdItem.HitPoint := Query.FieldByName('HitPoint').AsInteger;
      StdItem.SpeedPoint := Query.FieldByName('SpeedPoint').AsInteger;
      StdItem.Strong := Query.FieldByName('Strong').AsInteger;
      StdItem.Luck := Query.FieldByName('Luck').AsInteger;
      StdItem.HitSpeed := Query.FieldByName('HitSpeed').AsInteger;
      StdItem.AntiMagic := Query.FieldByName('AntiMagic').AsInteger;
      StdItem.PoisonMagic := Query.FieldByName('PoisonMagic').AsInteger;
      StdItem.HealthRecover := Query.FieldByName('HealthRecover').AsInteger;
      StdItem.SpellRecover := Query.FieldByName('SpellRecover').AsInteger;
      StdItem.PoisonRecover := Query.FieldByName('PoisonRecover').AsInteger;
      ClientStditem.Bind := LongWord(Query.FieldByName('Bind').AsInteger);

      StdItem.AddWuXinAttack := 0;
      StdItem.DelWuXinAttack := 0;
      StdItem.Need := Query.FieldByName('Need').AsInteger;
      StdItem.NeedLevel := Query.FieldByName('NeedLevel').AsInteger;
      StdItem.Price := Query.FieldByName('Price').AsInteger;
      ClientStditem.sDesc := Query.FieldByName('Text').AsString;
      if sm_Superposition in StdItem.StdModeEx then
        if StdItem.DuraMax < 1 then
          StdItem.DuraMax := 1;
      //StdItem.NeedIdentify := GetGameLogItemNameList(StdItem.Name);
      ClientStditem.boChange := False;
      DBList.Add(ClientStditem);
      //SetStdItem(ClientStditem);
      Item := ListViewStdItems.Items.Add;
      Item.Caption := Format('%.4d', [StdItem.Idx]);
      Item.SubItems.AddObject(StdItem.Name, TObject(ClientStditem));
      if CheckIntStatus(ClientStditem.Bind, II_Publicity) then
        Item.SubItems.Add('√')
      else
        Item.SubItems.Add(' ');
      for ii := 0 to 7 do begin
        if CheckIntStatus(ClientStditem.Bind, ii) then begin
          Item.SubItems.Add('√');
        end
        else begin
          Item.SubItems.Add(' ');
        end;
      end;
      if CheckIntStatus(ClientStditem.Bind, II_Show) then
        Item.SubItems.Add('√')
      else
        Item.SubItems.Add(' ');
      if CheckIntStatus(ClientStditem.Bind, II_PickUp) then
        Item.SubItems.Add('√')
      else
        Item.SubItems.Add(' ');
      if CheckIntStatus(ClientStditem.Bind, II_Color) then
        Item.SubItems.Add('√')
      else
        Item.SubItems.Add(' ');
      if CheckIntStatus(ClientStditem.Bind, II_Hint) then
        Item.SubItems.Add('√')
      else
        Item.SubItems.Add(' ');
      Item.SubItems.Add(ClientStditem.sDesc);
      ClientStditem.Item := Item;
      Query.Next;
      FormMain.ShowProgress(Round((i / (Query.RecordCount - 1)) * 100));
    end;
    FormMain.ShowHint('物品数据库加载完成...');
  finally
    Query.Close;
    ListViewStdItems.Visible := True;
  end;
end;

procedure TFrameGoods.SaveSaveItem;
resourcestring
  sSQLString = 'UPDATE StdItems.DB set Bind=%d, Text=''%s'' where Idx=%d';
var
  i: Integer;
  ClientStditem: pTItemStditem;
  SaveBind: Integer;
begin
  FormMain.ShowHint('正在保存物品数据库设置...');
  try
    for i := 0 to DBList.Count - 1 do begin
      ClientStditem := DBList.Items[i];
      if ClientStditem.boChange then begin
        Query.SQL.Clear;
        SaveBind := Integer(ClientStditem.Bind);
        Query.SQL.Add(Format(sSQLString, [SaveBind, ClientStditem.sDesc, ClientStditem.StdItem.Idx]));
        Query.ExecSQL;
        Query.Close;
        ClientStditem.boChange := False;
      end;
      FormMain.ShowProgress(Round((i / (DBList.Count - 1)) * 100));
    end;
    FormMain.ShowHint('物品数据库保存成功...');
  finally

  end;
  boChange := False;
end;

procedure TFrameGoods.SaveSaveMagic;
resourcestring
  sSQLString = 'UPDATE Magic.DB set Bind=%d, Text=''%s'' where MagName=''%s''';
var
  ClientMagic: pTItemMagic;
  I: integer;
begin
  FormMain.ShowHint('正在保存技能数据库设置...');
  for i := 0 to MagicList.Count - 1 do begin
    ClientMagic := MagicList.Items[i];
    if ClientMagic.boChange then begin
      Query.SQL.Clear;
      Query.SQL.Add(Format(sSQLString, [Integer(ClientMagic.isshow), ClientMagic.sDesc, ClientMagic.Magic.sMagicName]));
      Query.ExecSQL;
      Query.Close;
      ClientMagic.boChange := False;
    end;
    FormMain.ShowProgress(Round((i / (MagicList.Count - 1)) * 100));
  end;
  FormMain.ShowHint('技能数据库保存成功...');
  boChange := False;
end;

procedure TFrameGoods.SetMagicStatus(Title: string);
var
  i: Integer;
  ItemStditem: pTItemMagic;
  boOne: Boolean;
  bool: Boolean;
  str: string;
begin
  if (Title <> '公开') and (Title <> '备注') then
    exit;

  boOne := True;
  bool := False;
  boChange := True;
  str := '';
  ButtonSave.Enabled := True;
  ButtonLoad.Enabled := True;
  for i := 0 to MagicList.Count - 1 do begin
    ItemStditem := MagicList.Items[i];
    if ItemStditem.Item.Selected then begin
      if Title = '公开' then begin
        if boOne then begin
          if ItemStditem.isshow then begin
            ItemStditem.isshow := False;
            ItemStditem.Item.SubItems[1] := ' ';
          end
          else begin
            ItemStditem.isshow := True;
            ItemStditem.Item.SubItems[1] := '√';
          end;
          ItemStditem.boChange := True;
          bool := ItemStditem.isshow;
          boOne := False;
        end
        else begin
          if not bool then begin
            ItemStditem.isshow := False;
            ItemStditem.Item.SubItems[1] := ' ';
          end
          else begin
            ItemStditem.isshow := True;
            ItemStditem.Item.SubItems[1] := '√';
          end;
          ItemStditem.boChange := True;
        end;
      end
      else if Title = '备注' then begin
        if boOne then begin
          DescStr := ItemStditem.sDesc;
          FormMain.TextDialog.Lines.SetText(PChar(DescStr));
          if not FormMain.TextDialog.Execute then
            break;
          DescStr := FormMain.TextDialog.Lines.Text;
          ItemStditem.sDesc := DescStr;
          ItemStditem.Item.SubItems[5] := DescStr;
          ItemStditem.boChange := True;
          str := DescStr;
          boOne := False;
        end
        else begin
          ItemStditem.boChange := True;
          ItemStditem.sDesc := str;
          ItemStditem.Item.SubItems[5] := str;
        end;
      end
    end;
  end;
end;

procedure TFrameGoods.SetStdItemStatus(Title: string);
var
  i: Integer;
  ItemStditem: pTItemStditem;
  boOne: Boolean;
  bool: Boolean;
  bttype: byte;
  nIndex: Integer;
  str: string;
begin
  boOne := True;
  bool := False;
  bttype := 0;
  nIndex := 0;
  boChange := True;
  str := '';
  ButtonSave.Enabled := True;
  ButtonLoad.Enabled := True;
  for i := 0 to DBList.Count - 1 do begin
    ItemStditem := DBList.Items[i];
    if ItemStditem.Item.Selected then begin
      {if Title = '公开' then begin
        if boOne then begin
          if ItemStditem.isshow then begin
            ItemStditem.isshow := False;
            ItemStditem.Item.SubItems[1] := ' ';
          end
          else begin
            ItemStditem.isshow := True;
            ItemStditem.Item.SubItems[1] := '√';
          end;
          bool := ItemStditem.isshow;
          boOne := False;
        end
        else begin
          if not bool then begin
            ItemStditem.isshow := False;
            ItemStditem.Item.SubItems[1] := ' ';
          end
          else begin
            ItemStditem.isshow := True;
            ItemStditem.Item.SubItems[1] := '√';
          end;
        end;
      end
      else if Title = '显' then begin
        if boOne then begin
          ItemStditem.Filtrate.boShow := not ItemStditem.Filtrate.boShow;
          if ItemStditem.Filtrate.boShow then begin
            ItemStditem.Item.SubItems[10] := '√';
            bool := True;
          end
          else begin
            ItemStditem.Item.SubItems[10] := ' ';
            bool := False;
          end;
          boOne := False;
        end
        else begin
          ItemStditem.Filtrate.boShow := bool;
          if ItemStditem.Filtrate.boShow then begin
            ItemStditem.Item.SubItems[10] := '√';
          end
          else begin
            ItemStditem.Item.SubItems[10] := ' ';
          end;
        end;
      end
      else if Title = '捡' then begin
        if boOne then begin
          ItemStditem.Filtrate.boPickUp := not ItemStditem.Filtrate.boPickUp;
          if ItemStditem.Filtrate.boPickUp then begin
            ItemStditem.Item.SubItems[11] := '√';
            bool := True;
          end
          else begin
            ItemStditem.Item.SubItems[11] := ' ';
            bool := False;
          end;
          boOne := False;
        end
        else begin
          ItemStditem.Filtrate.boPickUp := bool;
          if ItemStditem.Filtrate.boPickUp then begin
            ItemStditem.Item.SubItems[11] := '√';
          end
          else begin
            ItemStditem.Item.SubItems[11] := ' ';
          end;
        end;
      end
      else if Title = '特' then begin
        if boOne then begin
          ItemStditem.Filtrate.boColor := not ItemStditem.Filtrate.boColor;
          if ItemStditem.Filtrate.boColor then begin
            ItemStditem.Item.SubItems[12] := '√';
            bool := True;
          end
          else begin
            ItemStditem.Item.SubItems[12] := ' ';
            bool := False;
          end;
          boOne := False;
        end
        else begin
          ItemStditem.Filtrate.boColor := bool;
          if ItemStditem.Filtrate.boColor then begin
            ItemStditem.Item.SubItems[12] := '√';
          end
          else begin
            ItemStditem.Item.SubItems[12] := ' ';
          end;
        end;
      end
      else if Title = '提' then begin
        if boOne then begin
          ItemStditem.Filtrate.boHint := not ItemStditem.Filtrate.boHint;
          if ItemStditem.Filtrate.boHint then begin
            ItemStditem.Item.SubItems[13] := '√';
            bool := True;
          end
          else begin
            ItemStditem.Item.SubItems[13] := ' ';
            bool := False;
          end;
          boOne := False;
        end
        else begin
          ItemStditem.Filtrate.boHint := bool;
          if ItemStditem.Filtrate.boHint then begin
            ItemStditem.Item.SubItems[13] := '√';
          end
          else begin
            ItemStditem.Item.SubItems[13] := ' ';
          end;
        end;
      end
      else}
      if Title = '备注' then begin
        if boOne then begin
          DescStr := ItemStditem.sDesc;
          FormMain.TextDialog.Lines.SetText(PChar(DescStr));
          if not FormMain.TextDialog.Execute then
            break;
          DescStr := FormMain.TextDialog.Lines.Text;
          if ItemStditem.sDesc <> DescStr then
            ItemStditem.boChange := True;
          ItemStditem.sDesc := DescStr;
          ItemStditem.Item.SubItems[14] := DescStr;
          str := DescStr;
          boOne := False;
        end
        else begin
          ItemStditem.sDesc := str;
          ItemStditem.Item.SubItems[14] := str;
        end;
      end
      else begin
        if Title = '公开' then begin
          bttype := II_Publicity;
          nIndex := 1;
        end
        else if Title = '交易' then begin
          bttype := Ib_NoDeal;
          nIndex := 2;
        end
        else if Title = '存仓' then begin
          bttype := Ib_NoSave;
          nIndex := 3;
        end
        else if Title = '修理' then begin
          bttype := Ib_NoRepair;
          nIndex := 4;
        end
        else if Title = '丢弃' then begin
          bttype := Ib_NoDrop;
          nIndex := 5;
        end
        else if Title = '掉落' then begin
          bttype := Ib_NoDown;
          nIndex := 6;
        end
        else if Title = '打造' then begin
          bttype := Ib_NoMake;
          nIndex := 7;
        end
        else if Title = '出售' then begin
          bttype := Ib_NoSell;
          nIndex := 8;
        end
        else if Title = '消失' then begin
          bttype := Ib_DropDestroy;
          nIndex := 9;
        end
        else if Title = '显' then begin
          bttype := II_Show;
          nIndex := 10;
        end
        else if Title = '捡' then begin
          bttype := II_PickUp;
          nIndex := 11;
        end
        else if Title = '特' then begin
          bttype := II_Color;
          nIndex := 12;
        end
        else if Title = '提' then begin
          bttype := II_Hint;
          nIndex := 13;
        end
        else
          Break;
        if boOne then begin
          if CheckIntStatus(ItemStditem.Bind, bttype) then begin
            SetIntStatus(ItemStditem.Bind, bttype, False);
            ItemStditem.Item.SubItems[nIndex] := ' ';
            bool := False;
          end
          else begin
            SetIntStatus(ItemStditem.Bind, bttype, True);
            ItemStditem.Item.SubItems[nIndex] := '√';
            bool := True;
          end;
          boOne := False;
        end
        else begin
          SetIntStatus(ItemStditem.Bind, bttype, bool);
          if bool then begin
            ItemStditem.Item.SubItems[nIndex] := '√';
          end
          else begin
            ItemStditem.Item.SubItems[nIndex] := ' ';
          end;
        end;
        ItemStditem.boChange := True;
      end;
    end;
  end;
end;

procedure TFrameGoods.ButtonSaveClick(Sender: TObject);
begin
  if g_boLogin then begin
    SaveSaveItem();
    SaveSaveMagic();
  end;
  FormMain.ShowHint('数据库设置保存成功...');
  ButtonSave.Enabled := False;
  ButtonLoad.Enabled := False;
end;

initialization
  begin
    DBList := TList.Create;
    MagicList := TList.Create;
    SaveList := TList.Create;
    SaveMagicList := TList.Create;
  end;

finalization
  begin
    MagicList.Free;
    DBList.Free;
    SaveList.Free;
    SaveMagicList.Free;
  end;

end.

