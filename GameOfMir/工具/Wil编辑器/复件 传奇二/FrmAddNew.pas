unit FrmAddNew;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TFormAddNew = class(TForm)
    Button1: TButton;
    edtImageName: TEdit;
    Label1: TLabel;
    GroupBox1: TGroupBox;
    rbRumpAdd: TRadioButton;
    RadioButton2: TRadioButton;
    GroupBox2: TGroupBox;
    edtX: TEdit;
    Label2: TLabel;
    edtY: TEdit;
    Label3: TLabel;
    btnExit: TButton;
    btnGo: TButton;
    CheckBox1: TCheckBox;
    EditCount: TEdit;
    Label4: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
    procedure btnGoClick(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormAddNew: TFormAddNew;

implementation
uses
  FrmMain, Share, Wil, DIB;

{$R *.dfm}

procedure TFormAddNew.btnExitClick(Sender: TObject);
begin
  Close;
end;

procedure TFormAddNew.btnGoClick(Sender: TObject);
var
  m_FileName: string;
  X, Y, nSize: Integer;
  lsDib: TDIB;
  List: TList;
  PBits: PByte;
  nCount: Integer;
begin
  if not FormMain.WMImages.boInitialize then
    exit;
  if EditCount.Enabled then begin
    nCount := StrToIntDef(EditCount.Text, -1);
    if nCount <= 0 then begin
      Application.MessageBox('空图片数量设置不正确', '提示信息', MB_OK
        or
        MB_ICONASTERISK);
      Exit;
    end;
    lsDib := TDIB.Create;
    List := TList.Create;
    try
      lsDib.BitCount := 8;
      lsDib.Width := 1;
      lsDib.Height := 1;
      PBits := lsDib.PBits;
      PBits^ := 0;
      if rbRumpAdd.Checked then begin
        for x := 0 to nCount - 1 do
          FormMain.WMImages.AddImages(0, 0, lsDib);
      end
      else begin
        nSize := FormMain.WMImages.GetDibSize(lsDib) +
          FormMain.WMImages.GetImageHeaderSize;
        for x := 0 to nCount - 1 do
          List.Add(Pointer(nSize));
        nSize := nSize * nCount;
        FormMain.WMImages.InsertImagesGetRoom(FormMain.DrawGrid.Row * 6 +
          FormMain.DrawGrid.Col, nSize, List);
        for x := 0 to nCount - 1 do
          FormMain.WMImages.InsertImages(Integer(List.Items[x]), 0, 0, lsDib);
      end;
      FormMain.WMImages.SaveIndex;
      FormMain.DrawGrid.RowCount := FormMain.WMImages.ImageCount div 6 + 1;
      FormMain.DrawGrid.Repaint;
      Application.MessageBox('添加图片完成', '提示信息', MB_OK or
        MB_ICONASTERISK);
      Close;
    finally
      lsDib.Free;
      List.Free;
    end;
  end
  else begin
    m_Filename := Trim(edtImageName.Text);
    if (m_Filename <> '') and FileExists(m_Filename) then begin
      X := StrToIntDef(edtX.Text, 0);
      Y := StrToIntDef(edtY.Text, 0);
      lsDib := TDIB.Create;
      List := TList.Create;
      try
        lsDib.LoadFromFile(m_Filename);
        if rbRumpAdd.Checked then begin
          FormMain.WMImages.AddImages(x, y, lsDib);
        end
        else begin
          nSize := FormMain.WMImages.GetDibSize(lsDib) +
            FormMain.WMImages.GetImageHeaderSize;
          List.Add(Pointer(nSize));
          FormMain.WMImages.InsertImagesGetRoom(FormMain.DrawGrid.Row * 6 +
            FormMain.DrawGrid.Col, nSize, List);
          FormMain.WMImages.InsertImages(Integer(List.Items[0]), x, y, lsDib);
        end;
        FormMain.WMImages.SaveIndex;
        FormMain.DrawGrid.RowCount := FormMain.WMImages.ImageCount div 6 + 1;
        FormMain.DrawGrid.Repaint;
        Application.MessageBox('添加图片完成', '提示信息', MB_OK or
          MB_ICONASTERISK);
        Close;
      finally
        lsDib.Free;
        List.Free;
      end;
    end
    else
      Application.MessageBox('请先选择图片位置', '提示信息', MB_OK
        or
        MB_ICONASTERISK);
  end;
end;

procedure TFormAddNew.Button1Click(Sender: TObject);
begin
  if FormMain.WMImages.boInitialize then begin
    if FormMain.OpenPictureDialog.Execute(Handle) then begin
      if FormMain.OpenPictureDialog.FileName <> '' then begin
        edtImageName.Text := FormMain.OpenPictureDialog.FileName;
      end;
    end;
  end;
end;

procedure TFormAddNew.CheckBox1Click(Sender: TObject);
begin
  edtImageName.Enabled := not CheckBox1.Checked;
  Button1.Enabled := not CheckBox1.Checked;
  EditCount.Enabled := CheckBox1.Checked;
end;

end.

