unit FrmUploadList;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, DateUtils,
  Dialogs, ComCtrls, StdCtrls, ImgList, Menus;

type
  TFormUploadList = class(TForm)
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    ListView1: TListView;
    ImageListMinIcon: TImageList;
    Label1: TLabel;
    DateTimeBegin: TDateTimePicker;
    Label2: TLabel;
    DateTimeEnd: TDateTimePicker;
    Button1: TButton;
    Label3: TLabel;
    ComboBox1: TComboBox;
    Label4: TLabel;
    Edit1: TEdit;
    PopupMenu1: TPopupMenu;
    D1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure D1Click(Sender: TObject);
  private
    procedure RefShowList(sSQL: string);
  public
    procedure Open();
  end;

var
  FormUploadList: TFormUploadList;

implementation

uses
  FrmMain;

{$R *.dfm}

{ TFormUploadList }

procedure TFormUploadList.Button1Click(Sender: TObject);
var
  sSQL: string;
begin
  sSQL := 'select * from FileList where ';
  if Trim(Edit1.Text) = '' then begin                             // 00:00:00    23:59:59
    sSQL := sSQL + 'CreateTime between ' + FormatDateTime('#YYYY-MM-DD#', DateTimeBegin.DateTime);
    sSQL := sSQL + ' and ' + FormatDateTime('#YYYY-MM-DD#', IncDay(DateTimeEnd.DateTime));
  end else begin
    if ComboBox1.ItemIndex = 0 then begin
      sSQL := sSQL + 'UpName like ''%' + Trim(Edit1.Text) + '%''';
    end else begin
      sSQL := sSQL + 'ShowFileName like ''%' + Trim(Edit1.Text) + '%''';
    end;
  end;
  sSQL := sSQL + ' order by ID';
  RefShowList(sSQL);
end;

procedure TFormUploadList.D1Click(Sender: TObject);
var
  Item: TListItem;
  sFileName: string;
  nID: Integer;
begin
  Item := ListView1.Selected;
  if Item <> nil then begin
    nID := Integer(Item.SubItems.Objects[0]);
    sFileName := Item.SubItems[3];
    FormMain.ADOQuery.SQL.Clear;
    FormMain.ADOQuery.SQL.Add('Delete from FileList where ID =' + IntToStr(nID));
    FormMain.ADOQuery.ExecSQL;
    FormMain.ADOQuery.Close;
    DeleteFile(sFileName);
    Button1Click(Button1);
  end;
end;

procedure TFormUploadList.FormCreate(Sender: TObject);
begin
  DateTimeBegin.DateTime := Now();
  DateTimeEnd.DateTime := Now();
end;

procedure TFormUploadList.Open;
begin
  
  ShowModal;
end;

procedure TFormUploadList.RefShowList(sSQL: string);
  function FormatValue(nValue: Integer): string;
  begin
    if nValue > 1024 * 800 then begin
      Result := Format('%.2f', [nValue / 1024 / 1024]) + ' M';
    end else
    if nValue > 800 then begin
      Result := Format('%.2f', [nValue / 1024]) + ' KB';
    end else begin
      Result := IntToStr(nValue) + ' B';
    end;
  end;

var
  I: Integer;
  Item: TListItem;
begin
  ListView1.Items.Clear;
  FormMain.ADOQuery.SQL.Clear;
  FormMain.ADOQuery.SQL.Add(sSQL);
  FormMain.ADOQuery.Open;
  try
    //sSendMsg := '';
    for I := 0 to FormMain.ADOQuery.RecordCount - 1 do begin
      Item := ListView1.Items.Add;
      Item.Caption := FormMain.ADOQuery.FieldByName('ShowFileName').AsString;
      if CompareText(ExtractFileExt(Item.Caption), '.txt') = 0 then Item.ImageIndex := 14
      else Item.ImageIndex := 15;
      Item.SubItems.AddObject(FormatValue(FormMain.ADOQuery.FieldByName('FileSize').AsInteger), TObject(FormMain.ADOQuery.FieldByName('ID').AsInteger));
      Item.SubItems.Add(FormatDateTime('YYYY-MM-DD HH:MM:SS', FormMain.ADOQuery.FieldByName('CreateTime').AsDateTime));
      Item.SubItems.Add(FormMain.ADOQuery.FieldByName('UpName').AsString);
      Item.SubItems.Add(FormMain.ADOQuery.FieldByName('FileName').AsString);
      FormMain.ADOQuery.Next;
    end;
  finally
    FormMain.ADOQuery.Close;
  end;
end;

end.
