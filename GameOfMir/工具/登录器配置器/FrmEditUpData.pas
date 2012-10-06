unit FrmEditUpData;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, MD5Unit, 
  Dialogs, StdCtrls, Spin, Mask, RzEdit, ComCtrls, DropGroupPas;

type
  TFormEditUpData = class(TForm)
    GroupBox1: TGroupBox;
    EditSaveDir: TEdit;
    EditDownUrl: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    EditVer: TSpinEdit;
    Label1: TLabel;
    EditSaveName: TEdit;
    ButtonClose: TButton;
    ButtonOk: TButton;
    Label5: TLabel;
    ComboBoxZip: TComboBox;
    cbbDownType: TComboBox;
    lbl4: TLabel;
    cbbCheckType: TComboBox;
    edtMD5: TEdit;
    lbl1: TLabel;
    edtHint: TEdit;
    edtDate: TEdit;
    edtdownmd5: TEdit;
    lbl2: TLabel;
    DropFileGroupBox1: TDropFileGroupBox;
    Label6: TLabel;
    lbl5: TLabel;
    pb1: TProgressBar;
    edt2: TEdit;
    edt1: TEdit;
    procedure ButtonOkClick(Sender: TObject);
    procedure cbbCheckTypeChange(Sender: TObject);
    procedure DropFileGroupBox1DropFile(Sender: TObject);
  private
    { Private declarations }
  public
    procedure ShowProgress(aPercent: Integer);
  end;

var
  FormEditUpData: TFormEditUpData;

implementation

{$R *.dfm}

procedure TFormEditUpData.ButtonOkClick(Sender: TObject);
begin
  if Trim(edtHint.Text)='' then begin
    Application.MessageBox('更新提示不能为空!','提示信息', MB_OK + MB_ICONERROR );
    edtHint.SetFocus;
  end else
  if Trim(EditDownUrl.Text)='' then begin
    Application.MessageBox('下载不能为空!','提示信息', MB_OK + MB_ICONERROR );
    EditDownUrl.SetFocus;
  end else
  if Trim(EditSaveDir.Text)='' then begin
    Application.MessageBox('保存位置不能为空!','提示信息', MB_OK + MB_ICONERROR );
    EditSaveDir.SetFocus;
  end else
  if Trim(EditSaveName.Text)='' then begin
    Application.MessageBox('保存文件名不能为空!','提示信息', MB_OK + MB_ICONERROR );
    EditSaveName.SetFocus;
  end else Self.ModalResult:=mrOk;
end;

procedure TFormEditUpData.cbbCheckTypeChange(Sender: TObject);
begin
  EditVer.Visible := False;
  edtDate.Visible := False;
  Label1.Visible := False;
  edtmd5.Visible := False;
  if cbbCheckType.ItemIndex = 0 then begin
    Label1.Visible := True;
    Label1.Caption := '版本号:';
    EditVer.Visible := True;

  end else
  if cbbCheckType.ItemIndex = 2 then begin
    Label1.Visible := True;
    Label1.Caption := 'PAK更新时间:';
    edtDate.Visible := True;
    edtDate.Top := 92;
  end else
  if cbbCheckType.ItemIndex = 3 then begin
    Label1.Visible := True;
    Label1.Caption := '文件MD5值:';
    edtmd5.Visible := True;
    edtmd5.Top := 92;
  end;
end;

procedure TFormEditUpData.DropFileGroupBox1DropFile(Sender: TObject);
begin
  edt1.Text := DropFileGroupBox1.Files[0];
  edt2.Text := MD5Print(GetMD5OfFile(edt1.Text, ShowProgress));
end;

procedure TFormEditUpData.ShowProgress(aPercent: Integer);
begin
  pb1.Position := aPercent;
  Application.ProcessMessages;
end;

end.
