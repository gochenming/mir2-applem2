unit SwitchDB;

interface

uses
  Windows, Messages, SysUtils, StrUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls,DB, DBTables;

type
  TFormSwitch = class(TForm)
    df: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    ComboBoxOld: TComboBox;
    ComboBoxNew: TComboBox;
    Button1: TButton;
    Label3: TLabel;
    ProgressBar1: TProgressBar;
    QueryAdd: TQuery;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    procedure Open();
  end;

var
  FormSwitch: TFormSwitch;

implementation
uses
  FrmMain, Share;

{$R *.dfm}

procedure TFormSwitch.Button1Click(Sender: TObject);
resourcestring
  sSQLDELStr = 'Delete from ';
  sSQLString = 'select * from ';
  //'INSERT INTO Login_RegLoginLog (UserName,LoginAddr,RegAddr,RegPoint) values ('#39'%s'#39','#39'%s'#39','#39'%s'#39',%d)';
var
  sOldName: string;
  sNewName: string;
  OldList: TStringList;
  NewList: TStringList;
  AddList: TStringList;
  NotList: TStringList;
  i,II: Integer;
  sNames: string;
  sValues: string;
  boAdd: Boolean;
begin
  if (ComboBoxNew.ItemIndex > -1) and (ComboBoxOld.ItemIndex > -1) then
  begin
    sOldName := ComboBoxOld.Items[ComboBoxOld.ItemIndex];
    sNewName := ComboBoxNew.Items[ComboBoxNew.ItemIndex];
    FormMain.QuerySet.SQL.SetText(PChar(sSQLDELStr + sNewName));
    FormMain.QuerySet.ExecSQL;
    FormMain.QuerySet.Close;
    FormMain.Query.SQL.SetText(PChar(sSQLString + sOldName));
    FormMain.QuerySet.SQL.SetText(PChar(sSQLString + sNewName));
    FormMain.Query.Open;
    FormMain.QuerySet.Open;
    OldList := TStringList.Create;
    NewList := TStringList.Create;
    AddList := TStringList.Create;
    NotList := TStringList.Create;
    try
      with FormMain do begin
        Query.GetFieldNames(OldList);
        QuerySet.GetFieldNames(NewList);
        for ii := 0 to NewList.Count - 1 do
        begin
          boAdd := False;
          for i := 0 to OldList.Count - 1 do
          begin
            if CompareText(OldList[i],NewList[ii]) = 0 then
            begin
              AddList.Add(OldList[i]);
              boAdd := True;
              Break;
            end;
          end;
          if not boAdd then NotList.Add(NewList[ii]);
        end;
        //QuerySet.Close;
        for I := 0 to Query.RecordCount - 1 do
        begin
          sNames := '';
          sValues := '';
          for ii := 0 to NotList.Count - 1 do
          begin
            if sNames = '' then sNames := '(' + NotList[ii]
            else sNames := sNames + ',' + NotList[ii];
            if sValues = '' then sValues := '('
            else sValues := sValues + ',';

            case QuerySet.FieldByName(NotList[ii]).DataType of
            ftString,ftMemo: begin
              sValues := sValues + #39 + '' + #39;
            end;
            ftSmallint,
            ftInteger,
            ftWord: begin
              sValues := sValues + '0';
            end;
            else begin
              ShowMessage(IntToStr(Integer(QuerySet.FieldByName(NotList[ii]).DataType)));
            end;
            end;
          end;

          for ii := 0 to AddList.Count - 1 do
          begin
            if sNames = '' then sNames := '(' + AddList[ii]
            else sNames := sNames + ',' + AddList[ii];
            if sValues = '' then sValues := '('
            else sValues := sValues + ',';

            case Query.FieldByName(AddList[ii]).DataType of
            ftString,ftMemo: begin
              sValues := sValues + #39 + Query.FieldByName(AddList[ii]).AsString + #39;
            end;
            ftSmallint,
            ftInteger,
            ftWord: begin
              sValues := sValues + IntToStr(Query.FieldByName(AddList[ii]).AsInteger);
            end;
            else begin
              ShowMessage(IntToStr(Integer(QuerySet.FieldByName(AddList[ii]).DataType)));
            end;
            end;
          end;
          sNames := sNames + ')';
          sValues := sValues + ')';
          QueryAdd.SQL.SetText(PChar('INSERT INTO '+ sNewName +' ' + sNames + ' values ' + sValues + ';'));
          QueryAdd.ExecSQL;
          //QueryAdd.Close;
          Query.Next;
          ProgressBar1.Position := Round((I/Query.RecordCount)*100)
        end;
        //ShowMessage(PChar('INSERT INTO '+ sNewName +' ' + sNames + ' values ' + sValues + ';'));
        Application.MessageBox('转换完成！', '提示信息', MB_OK + 
          MB_ICONINFORMATION);
          
      end;

    finally
      OldList.Free;
      NewList.Free;
      AddList.Free;
      NotList.Free;

      FormMain.Query.Close;
      FormMain.QuerySet.Close;
    end;

  end;
  //Update magic.db set effecttype =1 where magid=1
end;

procedure TFormSwitch.Open();
var
  i: Integer;
begin
  ComboBoxOld.Items.Assign(DBList);
  ComboBoxNew.Items.Assign(DBList);
  QueryAdd.DatabaseName := DBNAME;
  ShowModal;
end;

end.

