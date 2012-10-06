unit FrmTools;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, MD5Unit, 
  Dialogs, bsSkinData, bsSkinCtrls, StdCtrls, Mask, bsSkinBoxCtrls, SHellAPI;

type
  TFrameTools = class(TFrame)
    DSkinData: TbsSkinData;
    GroupBoxBg: TbsSkinGroupBox;
    GroupBoxMD5: TbsSkinGroupBox;
    bsSkinStdLabel10: TbsSkinStdLabel;
    ButtonStart: TbsSkinButton;
    bsSkinGroupBox1: TbsSkinGroupBox;
    bsSkinStdLabel1: TbsSkinStdLabel;
    bsSkinEdit1: TbsSkinEdit;
    bsSkinStdLabel2: TbsSkinStdLabel;
    ComboBoxList: TbsSkinComboBox;
    bsSkinStdLabel3: TbsSkinStdLabel;
    bsSkinEdit2: TbsSkinEdit;
    bsSkinEdit3: TbsSkinEdit;
    bsSkinStdLabel4: TbsSkinStdLabel;
    bsSkinEdit4: TbsSkinEdit;
    bsSkinStdLabel5: TbsSkinStdLabel;
    bsSkinEdit5: TbsSkinEdit;
    bsSkinStdLabel6: TbsSkinStdLabel;
    bsSkinComboBox1: TbsSkinComboBox;
    bsSkinStdLabel7: TbsSkinStdLabel;
    bsSkinEdit6: TbsSkinEdit;
    bsSkinStdLabel8: TbsSkinStdLabel;
    bsSkinEdit7: TbsSkinEdit;
    bsSkinStdLabel9: TbsSkinStdLabel;
    bsSkinComboBox2: TbsSkinComboBox;
    bsSkinStdLabel11: TbsSkinStdLabel;
    bsSkinEdit8: TbsSkinEdit;
    bsSkinStdLabel12: TbsSkinStdLabel;
    bsSkinEdit9: TbsSkinEdit;
    bsSkinStdLabel13: TbsSkinStdLabel;
    bsSkinComboBox3: TbsSkinComboBox;
    bsSkinStdLabel14: TbsSkinStdLabel;
    bsSkinEdit10: TbsSkinEdit;
    bsSkinStdLabel15: TbsSkinStdLabel;
    bsSkinEdit11: TbsSkinEdit;
    bsSkinStdLabel16: TbsSkinStdLabel;
    bsSkinStdLabel17: TbsSkinStdLabel;
    bsSkinEdit12: TbsSkinEdit;
    bsSkinEdit13: TbsSkinEdit;
    bsSkinStdLabel18: TbsSkinStdLabel;
    bsSkinEdit14: TbsSkinEdit;
    bsSkinStdLabel19: TbsSkinStdLabel;
    bsSkinEdit15: TbsSkinEdit;
    bsSkinStdLabel20: TbsSkinStdLabel;
    bsSkinEdit16: TbsSkinEdit;
    bsSkinStdLabel21: TbsSkinStdLabel;
    bsSkinEdit17: TbsSkinEdit;
    bsSkinStdLabel22: TbsSkinStdLabel;
    bsSkinEdit18: TbsSkinEdit;
    bsSkinStdLabel23: TbsSkinStdLabel;
    bsSkinEdit19: TbsSkinEdit;
    bsSkinStdLabel24: TbsSkinStdLabel;
    bsSkinEdit20: TbsSkinEdit;
    bsSkinStdLabel25: TbsSkinStdLabel;
    bsSkinEdit21: TbsSkinEdit;
    bsSkinStdLabel26: TbsSkinStdLabel;
    bsSkinEdit22: TbsSkinEdit;
    bsSkinStdLabel27: TbsSkinStdLabel;
    bsSkinEdit23: TbsSkinEdit;
    bsSkinStdLabel28: TbsSkinStdLabel;
    bsSkinEdit24: TbsSkinEdit;
    bsSkinStdLabel29: TbsSkinStdLabel;
    bsSkinEdit25: TbsSkinEdit;
    bsSkinStdLabel30: TbsSkinStdLabel;
    bsSkinEdit26: TbsSkinEdit;
    bsSkinStdLabel31: TbsSkinStdLabel;
    bsSkinEdit27: TbsSkinEdit;
    bsSkinStdLabel32: TbsSkinStdLabel;
    bsSkinEdit28: TbsSkinEdit;
    bsSkinStdLabel33: TbsSkinStdLabel;
    bsSkinEdit29: TbsSkinEdit;
    bsSkinStdLabel34: TbsSkinStdLabel;
    bsSkinEdit30: TbsSkinEdit;
    bsSkinStdLabel35: TbsSkinStdLabel;
    bsSkinEdit31: TbsSkinEdit;
    procedure bsSkinEdit1Change(Sender: TObject);
    procedure ButtonStartClick(Sender: TObject);
  private
    procedure WMDropFiles(var Msg: TMsg);
  public
    procedure MainOnMessage(var Msg: TMsg; var Handled: Boolean);
    procedure Open();
    procedure ShowProgress(aPercent: Integer);
  end;

implementation

{$R *.dfm}

uses
  FrmMain;

var
  boFrist: Boolean = False;

{ TFrameTools }

procedure TFrameTools.bsSkinEdit1Change(Sender: TObject);
begin
  bsSkinEdit2.Text := IntToStr(MakeLong(ComboBoxList.ItemIndex, StrToIntDef(bsSkinEdit1.Text, 0)));
  bsSkinEdit6.Text := IntToStr(MakeLong(bsSkinComboBox1.ItemIndex, StrToIntDef(bsSkinEdit5.Text, 0)));
  bsSkinEdit8.Text := IntToStr(MakeLong(bsSkinComboBox2.ItemIndex, StrToIntDef(bsSkinEdit7.Text, 0)));
  bsSkinEdit10.Text := IntToStr(MakeLong(bsSkinComboBox3.ItemIndex, StrToIntDef(bsSkinEdit9.Text, 0)));
  bsSkinEdit12.Text := IntToStr(MakeLong(StrToIntDef(bsSkinEdit11.Text, 0), StrToIntDef(bsSkinEdit13.Text, 0)));
  bsSkinEdit16.Text := IntToStr(MakeLong(StrToIntDef(bsSkinEdit14.Text, 0), StrToIntDef(bsSkinEdit15.Text, 0)));
  bsSkinEdit19.Text := IntToStr(MakeLong(StrToIntDef(bsSkinEdit17.Text, 0), StrToIntDef(bsSkinEdit18.Text, 0)));
  bsSkinEdit22.Text := IntToStr(MakeLong(StrToIntDef(bsSkinEdit20.Text, 0), StrToIntDef(bsSkinEdit21.Text, 0)));
  bsSkinEdit25.Text := IntToStr(MakeLong(StrToIntDef(bsSkinEdit23.Text, 0), StrToIntDef(bsSkinEdit24.Text, 0)));
  bsSkinEdit28.Text := IntToStr(MakeLong(StrToIntDef(bsSkinEdit26.Text, 0), StrToIntDef(bsSkinEdit27.Text, 0)));
  bsSkinEdit31.Text := IntToStr(MakeLong(StrToIntDef(bsSkinEdit29.Text, 0), StrToIntDef(bsSkinEdit30.Text, 0)));
end;

procedure TFrameTools.ButtonStartClick(Sender: TObject);
begin
  FormMain.ShowHint('正在计算...');
  bsSkinEdit4.Text := '';
  if FileExists(bsSkinEdit3.Text) then bsSkinEdit4.Text := MD5Print(GetMD5OfFile(bsSkinEdit3.Text, ShowProgress))
  else bsSkinEdit4.Text := GetMD5Text(bsSkinEdit3.Text);
  FormMain.ShowHint('计算完成...');
end;

procedure TFrameTools.MainOnMessage(var Msg: TMsg; var Handled: Boolean);
begin
  if Msg.message = WM_DROPFILES then begin
    WMDropFiles(Msg);
  end;
end;

procedure TFrameTools.Open;
begin
  if not boFrist then begin
    boFrist := True;
    Application.OnMessage := MainOnMessage;
    
  end;
end;

procedure TFrameTools.ShowProgress(aPercent: Integer);
begin
  FormMain.ShowProgress(aPercent);
end;

procedure TFrameTools.WMDropFiles(var Msg: TMsg);
var
  AFileName: array[0..MAX_PATH] of Char;
  Drop: THandle;
begin
  Drop := Msg.wParam;
  if DragQueryFile(Drop, 0, AFileName, MAX_PATH) > 0 then begin
    if Msg.hwnd = GroupBoxMD5.Handle then begin
      bsSkinEdit3.Text := AFileName;
    end;
  end;
end;

end.
