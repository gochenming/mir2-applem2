unit FrmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus;

type
  TFormMain = class(TForm)
    mm1: TMainMenu;
    T1: TMenuItem;
    H1: TMenuItem;
    A1: TMenuItem;
    Q1: TMenuItem;
    N1: TMenuItem;
    E1: TMenuItem;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;

implementation

uses
  ZShare, MyCommon;

{$R *.dfm}

procedure TFormMain.FormCreate(Sender: TObject);
begin
  Randomize;
  GetFileVersion(ParamStr(0), @g_FileVersionInfo);
  Caption := MAINFORMCAPTION + g_FileVersionInfo.sVersion;
end;

end.
