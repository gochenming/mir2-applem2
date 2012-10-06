unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls;

type
  TForm1 = class(TForm)
    tmr1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  DllHandle: THandle;

implementation

{$R *.dfm}

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if Application.MessageBox('全部转换完成！', '', MB_OKCANCEL + 
    MB_ICONINFORMATION) = IDOK then
  begin
    CanClose := True;
  end else
    CanClose := False;

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  DllHandle := LoadLibrary('Encrypt.dll');
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FreeLibrary(DllHandle);
end;

end.
