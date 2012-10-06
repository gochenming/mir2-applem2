unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,HUtil32,EDcode,Grobal2;

type
  TForm1 = class(TForm)
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    EncodeButton: TButton;
    DecodeButton: TButton;
    EncodeEdit: TEdit;
    RecogEdit: TEdit;
    IdentEdit: TEdit;
    ParamEdit: TEdit;
    TagEdit: TEdit;
    SeriesEdit: TEdit;
    Memo1: TMemo;
    Greds: TGroupBox;
    edtEncode: TEdit;
    edtDecode: TEdit;
    procedure DecodeButtonClick(Sender: TObject);
    procedure EncodeButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.DecodeButtonClick(Sender: TObject);
var
  sMsg:String;
  DefMsg:TDefaultMessage;
  I:Integer;
  //cu: TOClientItem1;
begin
  if EncodeEdit.Text<>'' then
  begin
    DefMsg:=DecodeMessage(EncodeEdit.Text);
    RecogEdit.Text:=IntToStr(DefMsg.Recog);
    IdentEdit.Text:=IntToStr(DefMsg.Ident);
    ParamEdit.Text:=IntToStr(DefMsg.Param);
    TagEdit.Text:=IntToStr(DefMsg.Tag);
    SeriesEdit.Text:=IntToStr(DefMsg.Series);
  end;
    edtDecode.Text:=DecodeString(edtEncode.Text);
 // DecodeBuffer(edtEncode.Text, @cu, sizeof(TOClientItem1));
end;

procedure TForm1.EncodeButtonClick(Sender: TObject);
  var
  DefMsg:TDefaultMessage;
  I :Integer;
begin
  if (RecogEdit.Text<>'') and (IdentEdit.Text<>'') and
       (ParamEdit.Text<>'') and (TagEdit.Text<>'') and (SeriesEdit.Text<>'') then begin
    DefMsg.Recog:=StrToInt(RecogEdit.Text);
    DefMsg.Ident:=StrToInt(IdentEdit.Text);
    DefMsg.Param:=StrToInt(ParamEdit.Text);
    DefMsg.Tag:=StrToInt(TagEdit.Text);
    DefMsg.Series:=StrToInt(SeriesEdit.Text);
    EncodeEdit.Text:=EncodeMessage(DefMsg);
  end;
    edtEncode.Text:=EncodeString(edtDecode.Text);
end;

end.
