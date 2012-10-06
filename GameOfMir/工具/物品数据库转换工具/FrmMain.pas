unit FrmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, DB, DBTables;

type
  TFormMain = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    BtnMonster: TButton;
    GroupBox1: TGroupBox;
    LogMonster: TMemo;
    BarMonster: TProgressBar;
    Query: TQuery;
    QuerySave: TQuery;
    Label5: TLabel;
    Label6: TLabel;
    BtnStdItems: TButton;
    GroupBox2: TGroupBox;
    Label7: TLabel;
    CBStdItems: TComboBox;
    LogStdItems: TMemo;
    CheckBoxMonster: TCheckBox;
    CheckBoxStdItems: TCheckBox;
    BarStdItems: TProgressBar;
    procedure FormCreate(Sender: TObject);
    procedure BtnMonsterClick(Sender: TObject);
    procedure BtnStdItemsClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;

implementation

{$R *.dfm}
{$R DB.res}

procedure TFormMain.BtnMonsterClick(Sender: TObject);
const
  INSERTSTR = 'INSERT INTO Monster_New.DB (Name, Race, RaceImg, Appr, Lvl, Undead, CoolEye, NotInSafe, Exp, HP, MP, AC, MAC, DC, DCMAX, MC, SC, Speed, Hit, WALK_SPD, WalkStep, WalkWait, ATTACK_SPD, Color)';
  INSERTSTRVALUES = '  values (''%s'', %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d)';
var
  Res: TResourceStream;
  i: Integer;
  SqlStr: string;
  nAppr, nRace, nRaceImg: Integer;
begin

  LogMonster.Lines.Clear;
  Try
    LogMonster.Lines.Add('正在准备转换Monster.DB...');
    BtnMonster.Enabled := False;
    CheckBoxMonster.Enabled := False;
    Try
      LogMonster.Lines.Add('正在生成Monster_New.DB...');
      Res := TResourceStream.Create(Hinstance, 'Monster', 'DB');
      try
        Res.SaveToFile('Monster_New.DB');
      finally
        Res.Free;
      end;
      Query.SQL.Clear;
      Query.DatabaseName := '.\';
      Query.SQL.Add('Select * from Monster.DB');
      Query.Open;
      Try
        QuerySave.DatabaseName := '.\';
        BarMonster.Max := Query.RecordCount - 1;
        BarMonster.Min := 0;
        LogMonster.Lines.Add('正在转换数据...');
        for i := 0 to Query.RecordCount - 1 do begin
          BarMonster.Position := i;
          nAppr := Query.FieldByName('Appr').AsInteger;
          nRace := Query.FieldByName('Race').AsInteger;
          nRaceImg := Query.FieldByName('RaceImg').AsInteger;
          if CheckBoxMonster.Checked then begin
            case nAppr of
              34: begin
                  nRace := 170;
                  nRaceImg := 21; 
                end;
              63: begin
                  nRace := 171;
                  nRaceImg := 49; 
                end;
              180: begin
                  nRace := 150;
                  nRaceImg := 60; 
                end;
              182: begin
                  nRace := 170;
                  nRaceImg := 37; 
                end;
              219: begin
                  nRace := 172;
                  nRaceImg := 78; 
                end;
              220, 222, 230, 239, 240, 252..254, 258..261: begin
                  nRace := 81;
                  nRaceImg := 19;
                end;
              221, 232, 233: begin
                  nRace := 108;
                  nRaceImg := 47; 
                end;
              223: begin
                  nRace := 121;
                  nRaceImg := 86; 
                end;
              231: begin
                  nRace := 122;
                  nRaceImg := 86; 
                end;
              234: begin
                  nRace := 105;
                  nRaceImg := 52; 
                end;
              235: begin
                  nRace := 123;
                  nRaceImg := 19; 
                end;
              236: begin
                  nRace := 175;
                  nRaceImg := 85; 
                end;
              237: begin
                  nRace := 93;
                  nRaceImg := 22;
                end;
              238: begin
                  nRace := 89;
                  nRaceImg := 14; 
                end;
              241: begin
                  nRace := 109;
                  nRaceImg := 85; 
                end;
              243, 255, 280, 320..322, 331, 332: begin
                  nRace := 99;
                  nRaceImg := 85; 
                end;
              250: begin
                  nRace := 124;
                  nRaceImg := 85; 
                end;
              251: begin
                  nRace := 122;
                  nRaceImg := 85; 
                end;
              256, 266, 267, 329: begin
                  nRace := 174;
                  nRaceImg := 91; 
                end;
              262: begin
                  nRace := 127;
                  nRaceImg := 85;
                end;
              263: begin
                  nRace := 126;
                  nRaceImg := 47;
                end;
              264: begin
                  nRace := 83;
                  nRaceImg := 10; 
                end;
              265: begin
                  nRace := 152;
                  nRaceImg := 101; 
                end;
              281: begin
                  nRace := 57;
                  nRaceImg := 85; 
                end;
              290..292: begin
                  nRace := 31;
                  nRaceImg := 19;
                end;
              323: begin
                  nRace := 104;
                  nRaceImg := 45; 
                end;
              327, 328: begin
                  nRace := 151;
                  nRaceImg := 100; 
                end;
              330, 334: begin
                  nRace := 101;
                  nRaceImg := 47;
                end;
            end;
          end;
          SqlStr := INSERTSTR + Format(INSERTSTRVALUES, [Trim(Query.FieldByName('NAME').AsString),
                                        nRace,
                                        nRaceImg,
                                        nAppr,
                                        Query.FieldByName('Lvl').AsInteger,
                                        Query.FieldByName('Undead').AsInteger,
                                        Query.FieldByName('CoolEye').AsInteger,
                                        0,
                                        Query.FieldByName('Exp').AsInteger,
                                        Query.FieldByName('HP').AsInteger,
                                        Query.FieldByName('MP').AsInteger,
                                        Query.FieldByName('AC').AsInteger,
                                        Query.FieldByName('MAC').AsInteger,
                                        Query.FieldByName('DC').AsInteger,
                                        Query.FieldByName('DCMAX').AsInteger,
                                        Query.FieldByName('MC').AsInteger,
                                        Query.FieldByName('SC').AsInteger,
                                        Query.FieldByName('SPEED').AsInteger,
                                        Query.FieldByName('HIT').AsInteger,
                                        Query.FieldByName('WALK_SPD').AsInteger,
                                        Query.FieldByName('WalkStep').AsInteger,
                                        Query.FieldByName('WalkWait').AsInteger,
                                        Query.FieldByName('ATTACK_SPD').AsInteger,
                                        0]);
          QuerySave.SQL.Clear;
          QuerySave.SQL.Add(SqlStr);
          QuerySave.ExecSQL;
          Query.Next;
        end;
      Finally
        Query.Close;
      End;
      LogMonster.Lines.Add('转换完成...');
    Finally
      BtnMonster.Enabled := True;
      CheckBoxMonster.Enabled := True;
    End;
  Except
    on E:Exception do begin
      LogMonster.Lines.Add(E.Message);
    end;
  End;
end;

procedure TFormMain.BtnStdItemsClick(Sender: TObject);
const
  INSERTSTR = 'INSERT INTO StdItems_New.DB (Idx, Name, StdMode, Shape, Weight, Anicount, Source, Reserved, Looks, Effect, DuraMax';
  INSERTSTR2 = ', AC, Ac2, Mac, Mac2, DC, DC2, MC, MC2, SC, SC2, HP, MP, AddDamage, DelDamage, HitPoint, SpeedPoint, Strong, Luck, HitSpeed, AntiMagic, PoisonMagic, HealthRecover, SpellRecover, PoisonRecover, Need, NeedLevel, Price, Bind, Color, Text)';
  INSERTSTRVALUES = '  values (%d, ''%s'', %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, ''%s'')';
var
  Res: TResourceStream;
  i: Integer;                             
  SqlStr: string;
  StdMode, Shape, AC, Ac2, Mac, Mac2, DC, DC2, MC, MC2, SC, SC2, HP, MP, AddDamage, DelDamage, HitPoint, SpeedPoint, Strong, Luck, HitSpeed, AntiMagic, PoisonMagic, HealthRecover, SpellRecover, PoisonRecover, nColor: Integer;
  Text: string[255];
begin
  Try
    LogStdItems.Lines.Add('正在准备转换StdItems.DB...');
    BtnStdItems.Enabled := False;
    CheckBoxStdItems.Enabled := False;
    CBStdItems.Enabled := False;
    Try
      LogStdItems.Lines.Add('正在生成StdItems_New.DB...');
      Res := TResourceStream.Create(Hinstance, 'StdItems', 'DB');
      try
        Res.SaveToFile('StdItems_New.DB');
      finally
        Res.Free;
      end;
      Query.SQL.Clear;
      Query.DatabaseName := '.\';
      Query.SQL.Add('Select * from StdItems.DB order by idx');
      Query.Open;
      Try
        QuerySave.DatabaseName := '.\';
        BarStdItems.Max := Query.RecordCount - 1;
        BarStdItems.Min := 0;
        LogStdItems.Lines.Add('正在转换数据...');
        for i := 0 to Query.RecordCount - 1 do begin
          BarStdItems.Position := i;
          StdMode := Query.FieldByName('StdMode').AsInteger; 
          Shape := Query.FieldByName('Shape').AsInteger;
          AC := Query.FieldByName('Ac').AsInteger;
          Ac2 := Query.FieldByName('Ac2').AsInteger;
          Mac := Query.FieldByName('Mac').AsInteger;
          Mac2 := Query.FieldByName('Mac2').AsInteger;
          DC := Query.FieldByName('Dc').AsInteger;
          DC2 := Query.FieldByName('DC2').AsInteger;
          MC := Query.FieldByName('Mc').AsInteger;
          MC2 := Query.FieldByName('Mc2').AsInteger;
          SC := Query.FieldByName('Sc').AsInteger;
          SC2 := Query.FieldByName('Sc2').AsInteger;
          HP := 0;
          MP := 0;
          AddDamage := 0;
          DelDamage := 0;
          HitPoint := 0;
          SpeedPoint := 0;
          Strong := 0;
          Luck := 0;
          HitSpeed := 0;
          AntiMagic := 0;
          PoisonMagic := 0;
          HealthRecover := 0;
          SpellRecover := 0;
          PoisonRecover := 0;
          if CBStdItems.ItemIndex = 0 then begin
            Text := Query.FieldByName('Descr').AsString;
            nColor := Query.FieldByName('Color').AsInteger;
          end else begin
            Text := Query.FieldByName('Reference').AsString;
            nColor := 0;
          end;
          SqlStr := INSERTSTR + INSERTSTR2 + Format(INSERTSTRVALUES, [Query.FieldByName('idx').AsInteger,
                                        Trim(Query.FieldByName('Name').AsString),
                                        StdMode,
                                        Shape,
                                        Query.FieldByName('Weight').AsInteger,
                                        Query.FieldByName('Anicount').AsInteger,
                                        Query.FieldByName('Source').AsInteger,
                                        Query.FieldByName('Reserved').AsInteger,
                                        Query.FieldByName('Looks').AsInteger,
                                        0,
                                        Query.FieldByName('DuraMax').AsInteger,
                                        AC,
                                        Ac2,
                                        Mac,
                                        Mac2,
                                        DC,
                                        DC2,
                                        MC,
                                        MC2,
                                        SC,
                                        SC2,
                                        HP,
                                        MP,
                                        AddDamage,
                                        DelDamage,
                                        HitPoint,
                                        SpeedPoint,
                                        Strong,
                                        Luck,
                                        HitSpeed,
                                        AntiMagic,
                                        PoisonMagic,
                                        HealthRecover,
                                        SpellRecover,
                                        PoisonRecover,
                                        Query.FieldByName('Need').AsInteger,
                                        Query.FieldByName('NeedLevel').AsInteger,
                                        Query.FieldByName('Price').AsInteger,
                                        0,
                                        nColor,
                                        Text]);
          QuerySave.SQL.Clear;
          QuerySave.SQL.Add(SqlStr);
          QuerySave.ExecSQL;
          Query.Next;
        end;
      Finally
        Query.Close;
      End;
      LogStdItems.Lines.Add('转换完成...');
    Finally
      BtnStdItems.Enabled := True;
      CheckBoxStdItems.Enabled := True;
      CBStdItems.Enabled := True;
    End;
  Except
    on E:Exception do begin
      LogStdItems.Lines.Add(E.Message);
    end;
  End;
end;

procedure TFormMain.FormCreate(Sender: TObject);
begin
  PageControl1.TabIndex := 0;
end;

end.
