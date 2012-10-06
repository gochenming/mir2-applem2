program Project;

uses
  Forms,
  Main in 'Main.pas' {Form1},
  EDcode in '..\..\Common\EDcode.pas',
  Grobal2 in '..\..\Common\Grobal2.pas',
  HUtil32 in '..\..\Common\HUtil32.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := '封包加解密工具';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
