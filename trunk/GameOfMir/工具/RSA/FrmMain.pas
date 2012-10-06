unit FrmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, RSACode, 
  Dialogs, StdCtrls;

type
  TFormMain = class(TForm)
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
    procedure Edit1Change(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure Edit3Change(Sender: TObject);
    procedure RadioButton1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    RSAED: TRSAED;
  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;

implementation

{$R *.dfm}

procedure TFormMain.Edit1Change(Sender: TObject);
begin
  RSAED.CommonalityKey:=Edit1.Text;
end;

procedure TFormMain.Edit2Change(Sender: TObject);
begin
  RSAED.CommonalityMode:=Edit2.Text;
end;

procedure TFormMain.Edit3Change(Sender: TObject);
begin
  RSAED.PrivateKey:=Edit3.Text;
end;

procedure TFormMain.FormCreate(Sender: TObject);
begin
  RSAED := TRSAED.Create;
end;

procedure TFormMain.FormDestroy(Sender: TObject);
begin
  RSAED.Free;
end;

procedure TFormMain.RadioButton1Click(Sender: TObject);
begin
  //RSA1.Server:=RadioButton1.Checked;
end;

procedure TFormMain.Button1Click(Sender: TObject);
begin
  //Memo2.Lines.Clear;
  //Memo2.Lines.Add(RSA1.EncryptStr(Memo1.Lines.GetText));
end;

procedure TFormMain.Button2Click(Sender: TObject);
begin
  //Memo1.Lines.Clear;
  //Memo1.Lines.Add(RSA1.DecryptStr(Memo2.Lines.GetText));
end;

end.
