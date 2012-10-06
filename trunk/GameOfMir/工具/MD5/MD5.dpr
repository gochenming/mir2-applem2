program MD5;

uses
  Forms,
  Main in 'Main.pas' {FormMain},
  MD5Unit in '..\..\Common\MD5Unit.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
