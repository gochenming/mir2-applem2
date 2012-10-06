unit FrmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls;

type
  TFormMain = class(TForm)
    Panel_BG_Right: TPanel;
    Panel_BG_Left: TPanel;
    Panel_Left_Bottom: TPanel;
    Panel_Left_Top: TPanel;
    Memo1: TMemo;
    ScrollBox: TScrollBox;
    Image1: TImage;
    GroupBox1: TGroupBox;
    ListBox1: TListBox;
    ListBox2: TListBox;
    Edit1: TEdit;
    Edit2: TEdit;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Edit3: TEdit;
    Label2: TLabel;
    Edit4: TEdit;
    Edit5: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    Edit6: TEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;

implementation

{$R *.dfm}

end.
