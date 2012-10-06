unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TMainForm = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    eLevel: TEdit;
    Label2: TLabel;
    cbLevelJob: TComboBox;
    Label3: TLabel;
    eLevelJob: TEdit;
    Label4: TLabel;
    eDC: TEdit;
    Label5: TLabel;
    cbDCJob: TComboBox;
    Label6: TLabel;
    eDCJob: TEdit;
    Label7: TLabel;
    eMC: TEdit;
    Label8: TLabel;
    cbMCJob: TComboBox;
    Label9: TLabel;
    eMCJob: TEdit;
    Label10: TLabel;
    eSC: TEdit;
    Label11: TLabel;
    cbSCJob: TComboBox;
    Label12: TLabel;
    eSCJob: TEdit;
    Label13: TLabel;
    eRelive1: TEdit;
    Label14: TLabel;
    eLevel1: TEdit;
    Label15: TLabel;
    eReliveLevel: TEdit;
    Label16: TLabel;
    eRelive2: TEdit;
    Label17: TLabel;
    eDC1: TEdit;
    Label18: TLabel;
    eReliveDC: TEdit;
    Label19: TLabel;
    eRelive3: TEdit;
    Label20: TLabel;
    eMC1: TEdit;
    Label21: TLabel;
    eReliveMC: TEdit;
    Label22: TLabel;
    eRelive4: TEdit;
    Label23: TLabel;
    eSC1: TEdit;
    Label24: TLabel;
    eReliveSC: TEdit;
    Label25: TLabel;
    eVIPType: TEdit;
    Label26: TLabel;
    eVIPLevel: TEdit;
    Label27: TLabel;
    eVIPTypeLevel: TEdit;
    procedure eChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.eChange(Sender: TObject);
begin
  eLevelJob.Text := IntToStr(MakeLong(cbLevelJob.ItemIndex, StrToIntDef(eLevel.Text, 0)));
  eDCJob.Text := IntToStr(MakeLong(cbDCJob.ItemIndex, StrToIntDef(eDC.Text, 0)));
  eMCJob.Text := IntToStr(MakeLong(cbMCJob.ItemIndex, StrToIntDef(eMC.Text, 0)));
  eSCJob.Text := IntToStr(MakeLong(cbSCJob.ItemIndex, StrToIntDef(eSC.Text, 0)));
  eReliveLevel.Text := IntToStr(MakeLong(StrToIntDef(eRelive1.Text, 0), StrToIntDef(eLevel1.Text, 0)));
  eReliveDC.Text := IntToStr(MakeLong(StrToIntDef(eRelive2.Text, 0), StrToIntDef(eDC1.Text, 0)));
  eReliveMC.Text := IntToStr(MakeLong(StrToIntDef(eRelive3.Text, 0), StrToIntDef(eMC1.Text, 0)));
  eReliveSC.Text := IntToStr(MakeLong(StrToIntDef(eRelive4.Text, 0), StrToIntDef(eSC1.Text, 0)));
  eVIPTypeLevel.Text := IntToStr(MakeLong(StrToIntDef(eVIPType.Text, 0), StrToIntDef(eVIPLevel.Text, 0)));
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  eChange(nil);
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
//
end;

end.
