program OffLine;

uses
  Forms,
  FrmMain in 'FrmMain.pas' {FormMain},
  EDcode in '..\..\Common\EDcode.pas',
  Grobal2 in '..\..\Common\Grobal2.pas',
  HUtil32 in '..\..\Common\HUtil32.pas',
  Common in '..\..\Common\Common.pas',
  MD5Unit in '..\..\Common\MD5Unit.pas',
  PlayList in 'PlayList.pas' {FormList},
  DES in '..\..\Common\DES.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormMain, FormMain);
  //Application.CreateForm(TFormList, FormList);
  Application.Run;
end.
