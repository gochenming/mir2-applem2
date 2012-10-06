unit FrmLogin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TFormLogin = class(TForm)
    GroupBox1: TGroupBox;
    ComboBox: TComboBox;
    Button1: TButton;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormLogin: TFormLogin;

implementation
uses
Share;

{$R *.dfm}

procedure TFormLogin.Button1Click(Sender: TObject);
begin
  if ComboBox.ItemIndex > -1 then
  begin
    DBNAME := ComboBox.Items[ComboBox.ItemIndex];
    Close;
  end else
    Application.MessageBox('请选择数据库名称!', '提示信息', MB_OK + MB_ICONINFORMATION);
end;

end.
