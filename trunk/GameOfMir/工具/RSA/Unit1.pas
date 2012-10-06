unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, RSA;

type
  TForm1 = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Label4: TLabel;
    Memo1: TMemo;
    Memo2: TMemo;
    Label5: TLabel;
    Button1: TButton;
    Button2: TButton;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    rs1: TRSA;
    procedure Edit1Change(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure Edit3Change(Sender: TObject);
    procedure RadioButton1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Edit1Change(Sender: TObject);
begin
  RS1.CommonalityKey := Edit1.Text;
end;

procedure TForm1.Edit2Change(Sender: TObject);
begin
  RS1.CommonalityMode := Edit2.Text;
end;

procedure TForm1.Edit3Change(Sender: TObject);
begin
  RS1.PrivateKey := Edit3.Text;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  RS1.CommonalityKey := Edit1.Text;
  RS1.CommonalityMode := Edit2.Text;
  RS1.PrivateKey := Edit3.Text;
  RS1.Server := RadioButton1.Checked;
end;

procedure TForm1.RadioButton1Click(Sender: TObject);
begin
  RS1.Server := RadioButton1.Checked;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  Memo2.Lines.Clear;
  Memo2.Lines.SetText(PChar(RS1.EncryptStr(Memo1.Lines.GetText)));
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  Memo1.Lines.Clear;
  Memo1.Lines.SetText(PChar(RS1.DecryptStr(Memo2.Lines.GetText)));
end;

end.

