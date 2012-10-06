unit FrmEditServer;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BusinessSkinForm, bsSkinData, bsSkinBoxCtrls, StdCtrls, bsSkinCtrls, Mask;

type
  TFormEditServer = class(TForm)
    DForm: TbsBusinessSkinForm;
    DSkinData: TbsSkinData;
    bsSkinGroupBox1: TbsSkinGroupBox;
    bsSkinStdLabel10: TbsSkinStdLabel;
    EditShowName: TbsSkinEdit;
    bsSkinStdLabel1: TbsSkinStdLabel;
    EditName: TbsSkinEdit;
    bsSkinStdLabel2: TbsSkinStdLabel;
    EditAddr: TbsSkinEdit;
    bsSkinStdLabel3: TbsSkinStdLabel;
    edtPort: TbsSkinEdit;
    bsSkinStdLabel4: TbsSkinStdLabel;
    ComboBoxServerGroup: TbsSkinComboBox;
    btnAddServer: TbsSkinButton;
    btnEditServer: TbsSkinButton;
    procedure btnAddServerClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    procedure SetComBoxIdx(sName: string);
    function Open():Integer;
  end;

var
  FormEditServer: TFormEditServer;

implementation

uses
  FrmMain;

{$R *.dfm}

procedure TFormEditServer.btnAddServerClick(Sender: TObject);
begin
  if Trim(EditShowName.Text) = '' then begin
    FormMain.DMsg.MessageDlg('服务器显示名称不能为空！', mtError, [mbYes], 0);
    EditShowName.SetFocus;
  end
  else if Trim(EditName.Text) = '' then begin
    FormMain.DMsg.MessageDlg('服务器名称不能为空！', mtError, [mbYes], 0);
    EditName.SetFocus;
  end
  else if Trim(EditAddr.Text) = '' then begin
    FormMain.DMsg.MessageDlg('服务器地址不能为空！', mtError, [mbYes], 0);
    EditAddr.SetFocus;
  end
  else if ComboBoxServerGroup.ItemIndex = -1 then begin
    FormMain.DMsg.MessageDlg('请选择服务器分组！', mtError, [mbYes], 0);
    ComboBoxServerGroup.SetFocus;
  end
  else
    Self.ModalResult := mrOk;
end;

procedure TFormEditServer.FormCreate(Sender: TObject);
begin
  DSkinData.SkinList := FormMain.CompressedSkinList;
end;


function TFormEditServer.Open: Integer;
begin
  ClientHeight := 219;
  ClientWidth := 372;
  Result := ShowModal;
end;

procedure TFormEditServer.SetComBoxIdx(sName: string);
var
  i: integer;
begin
  for I := 0 to ComboBoxServerGroup.Items.Count - 1 do begin
    if CompareText(ComboBoxServerGroup.Items.Strings[I], sName) = 0 then begin
      ComboBoxServerGroup.ItemIndex := I;
      break;
    end;
  end;
end;

end.

