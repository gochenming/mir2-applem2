unit PlayList;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TFormList = class(TForm)
    pnl1: TPanel;
    lst1: TListBox;
    btn1: TButton;
    btn2: TButton;
    procedure btn2Click(Sender: TObject);
    procedure lst1DblClick(Sender: TObject);
    procedure btn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormList: TFormList;
  SelectID: Integer;

implementation

{$R *.dfm}

uses
  FrmMain, EDcode, Grobal2;

procedure TFormList.btn1Click(Sender: TObject);
begin
  lst1.Clear;
  FormMain.SendSocket(EncodeMessage(MakeDefaultMsg(CM_APPEND, 0, 0, 0, APE_GLIST)));
end;

procedure TFormList.btn2Click(Sender: TObject);
begin
  SelectID := FormMain.m_nID;
  Close;
end;

procedure TFormList.lst1DblClick(Sender: TObject);
begin
  if (lst1.ItemIndex >= 0) and (lst1.ItemIndex < lst1.Items.Count) then begin
    SelectID := Integer(lst1.Items.Objects[lst1.ItemIndex]);
    Close;
  end;
end;

end.
