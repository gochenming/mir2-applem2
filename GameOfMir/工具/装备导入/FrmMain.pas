unit FrmMain;

interface

uses
  Windows, Messages, SysUtils, StrUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DropGroupPas, ComCtrls, DB, DBTables;

type
  TFormMain = class(TForm)
    DropFileGroupBox1: TDropFileGroupBox;
    lv1: TListView;
    btn1: TButton;
    Query: TQuery;
    procedure DropFileGroupBox1DropFile(Sender: TObject);
    procedure btn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;

implementation

{$R *.dfm}

uses
  HUtil32;



procedure TFormMain.btn1Click(Sender: TObject);
  function GetItemStdmode(sName: string): Integer;
  begin
    Result := 0;
  end;
resourcestring
  sSQLString = 'UPDATE StdItems.DB set Looks=%d, Ac=%d, Ac2=%d, MAc=%d, MAc2=%d, dc=%d, dc2=%d, mc=%d, mc2=%d, sc=%d, sc2=%d, HitPoint=%d, SpeedPoint=%d, HP=0, MP=0, Strong=0, AntiMagic=0, PoisonMagic=0, HealthRecover=0, SpellRecover=0, PoisonRecover=0  where Name=' + '''%s''';
  sSQLString2 = 'UPDATE StdItems.DB set Ac=%d, Ac2=%d, MAc=%d, MAc2=%d, dc=%d, dc2=%d, mc=%d, mc2=%d, sc=%d, sc2=%d, HitPoint=%d, SpeedPoint=%d, HP=0, MP=0, Strong=0, AntiMagic=0, PoisonMagic=0, HealthRecover=0, SpellRecover=0, PoisonRecover=0 where Name=' + '''%s''';

var
  Item: TListItem;
  I: Integer;
  sLook, sLook2: string;
begin
  btn1.Enabled := False;
  Try
    Query.DatabaseName := 'HeroDB';
    for I := 0 to lv1.Items.Count - 1 do begin
      Item := lv1.Items[I];
      Query.SQL.Clear;
      sLook := Item.SubItems[12];
      if sLook <> '' then begin
        if sLook[1] = '"' then
          ArrestStringEx(sLook, '"', '"', sLook);
        if RightStr(sLook, 1) = '*' then
          sLook := Copy(sLook, 1, Length(sLook) - 1);
        sLook2 := GetValidStrEx(sLook, sLook, [',', ' ', #9]);
        Query.SQL.Add(Format(sSQLString, [
          StrToIntDef(sLook, 0),
          StrToIntDef(Item.SubItems[0], 0),
          StrToIntDef(Item.SubItems[1], 0),
          StrToIntDef(Item.SubItems[2], 0),
          StrToIntDef(Item.SubItems[3], 0),
          StrToIntDef(Item.SubItems[4], 0),
          StrToIntDef(Item.SubItems[5], 0),
          StrToIntDef(Item.SubItems[6], 0),
          StrToIntDef(Item.SubItems[7], 0),
          StrToIntDef(Item.SubItems[8], 0),
          StrToIntDef(Item.SubItems[9], 0),
          StrToIntDef(Item.SubItems[10], 0),
          StrToIntDef(Item.SubItems[11], 0),
          Item.Caption]));
      end
      else
        Query.SQL.Add(Format(sSQLString2, [
          StrToIntDef(Item.SubItems[0], 0),
          StrToIntDef(Item.SubItems[1], 0),
          StrToIntDef(Item.SubItems[2], 0),
          StrToIntDef(Item.SubItems[3], 0),
          StrToIntDef(Item.SubItems[4], 0),
          StrToIntDef(Item.SubItems[5], 0),
          StrToIntDef(Item.SubItems[6], 0),
          StrToIntDef(Item.SubItems[7], 0),
          StrToIntDef(Item.SubItems[8], 0),
          StrToIntDef(Item.SubItems[9], 0),
          StrToIntDef(Item.SubItems[10], 0),
          StrToIntDef(Item.SubItems[11], 0),
          Item.Caption]));
        Query.ExecSQL;
        Query.Close;
      Caption := Item.Caption;
    end;

    Application.MessageBox('OK', 'ÐÅÏ¢¿ò', MB_OK + MB_ICONINFORMATION);
  Finally
    btn1.Enabled := True;
  End;
end;

procedure TFormMain.DropFileGroupBox1DropFile(Sender: TObject);
var
  LoadList: TStringList;
  I, n1: Integer;
  sStr, s1: String;
  Item: TListItem;
begin
  LoadList := TStringList.Create;
  lv1.Items.Clear;
  Try
    LoadList.LoadFromFile(DropFileGroupBox1.Files[0]);
    for I := 0 to LoadList.Count - 1 do begin
      sStr := Trim(LoadList[I]);
      if sStr <> '' then begin
        while True do begin
          sStr := GetValidStrEx(sStr, s1, [#9]);
          if (s1 <> '') and (s1 <> '»ã×Ü') then begin
            Item := lv1.Items.Add;
            Item.Caption := s1;

            sStr := GetValidStrEx(sStr, s1, [#9]);
            n1 := StrToIntDef(s1, -1);
            if n1 = -1 then begin
              lv1.Items.Delete(lv1.Items.Count - 1);
              break;
            end;
            Item.SubItems.Add(s1);
            sStr := GetValidStrEx(sStr, s1, [#9]);
            Item.SubItems.Add(s1);
            sStr := GetValidStrEx(sStr, s1, [#9]);

            sStr := GetValidStrEx(sStr, s1, [#9]);

            Item.SubItems.Add(s1);
            sStr := GetValidStrEx(sStr, s1, [#9]);
            Item.SubItems.Add(s1);
            sStr := GetValidStrEx(sStr, s1, [#9]);

            sStr := GetValidStrEx(sStr, s1, [#9]);

            Item.SubItems.Add(s1);
            sStr := GetValidStrEx(sStr, s1, [#9]);
            Item.SubItems.Add(s1);
            sStr := GetValidStrEx(sStr, s1, [#9]);

            sStr := GetValidStrEx(sStr, s1, [#9]);

            Item.SubItems.Add(s1);
            sStr := GetValidStrEx(sStr, s1, [#9]);
            Item.SubItems.Add(s1);
            sStr := GetValidStrEx(sStr, s1, [#9]);

            sStr := GetValidStrEx(sStr, s1, [#9]);

            Item.SubItems.Add(s1);
            sStr := GetValidStrEx(sStr, s1, [#9]);
            Item.SubItems.Add(s1);
            sStr := GetValidStrEx(sStr, s1, [#9]);
            Item.SubItems.Add(s1);
            sStr := GetValidStrEx(sStr, s1, [#9]);
            Item.SubItems.Add(s1);
            sStr := GetValidStrEx(sStr, s1, [#9]);
            Item.SubItems.Add(s1);
            sStr := GetValidStrEx(sStr, s1, [#9]);
          end else break;
        end;
      end;
    end;

  Finally
    LoadList.Free;
  End;

end;

end.
