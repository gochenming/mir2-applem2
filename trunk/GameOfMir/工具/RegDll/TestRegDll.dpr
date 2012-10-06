program TestRegDll;

uses
  Forms,
  TestMain in 'TestMain.pas' {Form12},
  MyCommon in '..\..\MyCommon\MyCommon.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm12, Form12);
  Application.Run;
end.
