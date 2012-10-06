program Project6;

uses
  Forms,
  Unit6 in 'Unit6.pas' {Form6},
  DES in 'Common\DES.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm6, Form6);
  Application.Run;
end.
