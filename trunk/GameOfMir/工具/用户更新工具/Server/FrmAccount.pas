unit FrmAccount;

interface

uses
  Windows, SysUtils, Classes, Graphics, Controls, Forms, StdCtrls, Buttons, Share, comObj, Spin;

type
  TFormAccount = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    ComboBoxAccount: TComboBox;
    Label2: TLabel;
    EditFind: TEdit;
    ButtonFind: TBitBtn;
    GroupBox2: TGroupBox;
    Label3: TLabel;
    EditAccount: TEdit;
    Label4: TLabel;
    EditPassword: TEdit;
    EditQQ: TEdit;
    Label5: TLabel;
    CheckBoxActive: TCheckBox;
    ButtonNew: TButton;
    ButtonSave: TButton;
    Label6: TLabel;
    EditAddress: TEdit;
    Label7: TLabel;
    EditLoginTime: TEdit;
    ButtonGetRandomPass: TButton;
    Button2: TButton;
    ButtonDel: TButton;
    Label8: TLabel;
    EditPublicID: TEdit;
    EditBindList: TEdit;
    Label9: TLabel;
    EditGUID: TEdit;
    Label10: TLabel;
    Label11: TLabel;
    EditBindCount: TSpinEdit;
    Label12: TLabel;
    EditUseBindCount: TSpinEdit;
    CheckBoxAgent: TCheckBox;
    Label13: TLabel;
    EditMoney: TSpinEdit;
    Label14: TLabel;
    EditAgentLogin: TSpinEdit;
    Label15: TLabel;
    EditAgentM2: TSpinEdit;
    Label16: TLabel;
    EditRegTime: TEdit;
    CheckBoxBindPC: TCheckBox;
    CheckBoxBindIP: TCheckBox;
    EditUserResetCount: TSpinEdit;
    Label17: TLabel;
    CheckBoxAdmin: TCheckBox;
    procedure ButtonNewClick(Sender: TObject);
    procedure ButtonGetRandomPassClick(Sender: TObject);
    procedure EditAccountChange(Sender: TObject);
    procedure ButtonSaveClick(Sender: TObject);
    procedure ButtonFindClick(Sender: TObject);
    procedure ComboBoxAccountChange(Sender: TObject);
    procedure ButtonDelClick(Sender: TObject);
    procedure CheckBoxAgentClick(Sender: TObject);
  private

  public
    procedure Open();
  end;

var
  FormAccount: TFormAccount;

implementation

uses FrmMain;

{$R *.dfm}

{ TFormAccount }

procedure TFormAccount.ButtonDelClick(Sender: TObject);
begin
  if ComboBoxAccount.ItemIndex > -1 then begin
    if Application.MessageBox(PChar('是否确定删除[' + ComboBoxAccount.Items[ComboBoxAccount.ItemIndex] + ']？'), '提示信息', MB_OKCANCEL + MB_ICONQUESTION) = IDOK then
    begin
      g_Query.SQL.Clear;
      g_Query.SQL.Add('delete from users where ID = ' + IntToStr(Integer(ComboBoxAccount.Items.Objects[ComboBoxAccount.ItemIndex])));
      g_Query.ExecSQL;
      g_Query.Close;
      ComboBoxAccount.Items.Delete(ComboBoxAccount.ItemIndex);
      ComboBoxAccountChange(ComboBoxAccount);
      Application.MessageBox('帐号删除成功！', '提示信息', MB_OK + MB_ICONINFORMATION);
    end;
  end;
end;

procedure TFormAccount.ButtonFindClick(Sender: TObject);
var
  sFindName: string;
  I: Integer;
begin
  sFindName := Trim(EditFind.Text);
  g_Query.SQL.Clear;
  ComboBoxAccount.Items.Clear;
  //StrToInt64Def
  if sFindName = '' then begin
    g_Query.SQL.Add('select ID,Account from users order by ID desc');
  end else
  if Length(sFindName) = 38 then begin
    g_Query.SQL.Add('select ID,Account from users where GUID = ''' + sFindName + ''' order by ID desc');
  end else
  if (Length(sFindName) = 18) and (StrToInt64Def(sFindName, 0) > 0) then begin
    g_Query.SQL.Add('select ID,Account from users where PublicID = ''' + sFindName + ''' order by ID desc');
  end else
  if StrToInt64Def(sFindName, 0) > 0 then begin
    g_Query.SQL.Add('select ID,Account from users where QQ = ' + sFindName + ' order by ID desc');
  end else begin
    g_Query.SQL.Add('select ID,Account from users where Account like ''' + sFindName + '%'' order by ID desc');
  end;
  g_Query.Open;
  Try
    for I := 0 to g_Query.RecordCount - 1 do begin
      ComboBoxAccount.Items.AddObject(g_Query.FieldByName('Account').AsString, TObject(g_Query.FieldByName('ID').AsInteger));
      g_Query.Next;
    end;
  Finally
    g_Query.Close;
  End;

end;

procedure TFormAccount.ButtonGetRandomPassClick(Sender: TObject);
begin
  EditPassword.Text := GetRandomPassword(6);
end;

procedure TFormAccount.ButtonNewClick(Sender: TObject);
begin
  EditAccount.Color := clWindow;
  EditAccount.Text := '';
  EditPassword.Text := GetRandomPassword(6);
  EditAddress.Text := '';
  EditLoginTime.Text := '';
  EditQQ.Text := '';
  EditBindCount.Value := 5;
  EditBindList.Text := '';
  EditAccount.ReadOnly := False;
  EditMoney.Value := 0;
  EditAgentLogin.Value := 0;
  EditAgentM2.Value := 0;
  EditUserResetCount.Value := 0;
  CheckBoxAgent.Checked := False;
  CheckBoxBindPC.Checked := False;
  CheckBoxBindIP.Checked := False;
  ComboBoxAccount.ItemIndex := -1;
  CheckBoxAdmin.Checked := False
end;

procedure TFormAccount.ButtonSaveClick(Sender: TObject);
var
  sAccount: string;
  sPassword: string;
  wQQ: LongWord;
begin
  sAccount := Trim(EditAccount.Text);
  sPassword := Trim(EditPassword.Text);
  wQQ := StrToIntDef(Trim(EditQQ.Text), 0);
  if not EditAccount.ReadOnly then begin
    if (sAccount = '') then begin
      Application.MessageBox('帐号不能为空！', '提示信息', MB_OK + MB_ICONINFORMATION);
      Exit;
    end;
    if not CheckEMailRule(sAccount) then begin
      Application.MessageBox('帐号只能为有效EMail格式！', '提示信息', MB_OK + MB_ICONINFORMATION);
      Exit;
    end;
    if (sPassword = '') then begin
      Application.MessageBox('密码不能为空！', '提示信息', MB_OK + MB_ICONINFORMATION);
      Exit;
    end;
    g_Query.SQL.Clear;
    g_Query.SQL.Add('select * from users where Account = ''' + sAccount + '''');
    g_Query.Open;
    Try
      if g_Query.RecordCount <= 0 then begin
        g_Query.Append;
        g_Query.FieldByName('Account').AsString := sAccount;
        g_Query.FieldByName('Password').AsString := sPassword;
        g_Query.FieldByName('QQ').AsInteger := wQQ;
        g_Query.FieldByName('Active').AsBoolean := CheckBoxActive.Checked;
        g_Query.FieldByName('GUID').AsString := CreateClassID;
        g_Query.FieldByName('PublicID').AsString := FormatDateTime('YYYYMMDDHHMMSS', Now) + IntToStr(Random(8000) + 1000);
        g_Query.FieldByName('UrlList').AsString := LowerCase(Trim(EditBindList.Text));
        g_Query.FieldByName('BindCount').AsInteger := EditBindCount.Value;
        g_Query.FieldByName('ResetCount').AsInteger := EditUserResetCount.Value;
        g_Query.FieldByName('IsAgent').AsBoolean := CheckBoxAgent.Checked;
        g_Query.FieldByName('Money').AsInteger := EditMoney.Value;
        g_Query.FieldByName('AgentLogin').AsInteger := EditAgentLogin.Value;
        g_Query.FieldByName('AgentM2').AsInteger := EditAgentM2.Value;
        g_Query.FieldByName('BindPC').AsBoolean := CheckBoxBindPC.Checked;
        g_Query.FieldByName('BindIP').AsBoolean := CheckBoxBindIP.Checked;
        g_Query.FieldByName('IsAdmin').AsBoolean := CheckBoxAdmin.Checked;
        g_Query.Post;
        EditAccount.Text := '';
        EditPassword.Text := GetRandomPassword(6);
        EditQQ.Text := '';
        ButtonSave.Enabled := False;
        Application.MessageBox('帐号添加成功！', '提示信息', MB_OK + MB_ICONINFORMATION);
      end else
        Application.MessageBox(PChar('帐号' + sAccount + '已经存在！'), '提示信息', MB_OK + MB_ICONSTOP);
    Finally
      g_Query.Close;
    End;
  end else
  if ComboBoxAccount.ItemIndex > -1 then begin
    g_Query.SQL.Clear;
    g_Query.SQL.Add('select * from users where ID = ' + IntToStr(Integer(ComboBoxAccount.Items.Objects[ComboBoxAccount.ItemIndex])));
    g_Query.Open;
    Try
      if g_Query.RecordCount > 0 then begin
        g_Query.Edit;
        g_Query.FieldByName('Active').AsBoolean := CheckBoxActive.Checked;
        g_Query.FieldByName('QQ').AsInteger := StrToIntDef(Trim(EditQQ.Text), 0);
        g_Query.FieldByName('Password').AsString := Trim(EditPassword.Text);
        g_Query.FieldByName('UrlList').AsString := LowerCase(Trim(EditBindList.Text));
        g_Query.FieldByName('BindCount').AsInteger := EditBindCount.Value;
        g_Query.FieldByName('ResetCount').AsInteger := EditUserResetCount.Value;
        g_Query.FieldByName('IsAgent').AsBoolean := CheckBoxAgent.Checked;
        g_Query.FieldByName('Money').AsInteger := EditMoney.Value;
        g_Query.FieldByName('AgentLogin').AsInteger := EditAgentLogin.Value;
        g_Query.FieldByName('AgentM2').AsInteger := EditAgentM2.Value;
        g_Query.FieldByName('BindPC').AsBoolean := CheckBoxBindPC.Checked;
        g_Query.FieldByName('BindIP').AsBoolean := CheckBoxBindIP.Checked;
        g_Query.FieldByName('IsAdmin').AsBoolean := CheckBoxAdmin.Checked;
        g_Query.Post;
        ButtonSave.Enabled := False;
        Application.MessageBox('帐号更新成功！', '提示信息', MB_OK + MB_ICONINFORMATION);

      end else begin
        Application.MessageBox(PChar('更新帐户' + ComboBoxAccount.Items[ComboBoxAccount.ItemIndex] + '信息失败！'), '提示信息', MB_OK + MB_ICONSTOP);
        ComboBoxAccount.ItemIndex := -1;
      end;
    Finally
      g_Query.Close;
    End;
  end;

end;

procedure TFormAccount.CheckBoxAgentClick(Sender: TObject);
begin
  if ((not EditAccount.ReadOnly) and (Trim(EditAccount.Text) <> '')) or (EditAccount.ReadOnly and (ComboBoxAccount.ItemIndex > -1)) then
    ButtonSave.Enabled := True;

  EditMoney.Enabled := CheckBoxAgent.Checked;
  EditAgentLogin.Enabled := CheckBoxAgent.Checked;
  EditAgentM2.Enabled := CheckBoxAgent.Checked;
end;

procedure TFormAccount.ComboBoxAccountChange(Sender: TObject);
var
  nID: Integer;
begin
  if ComboBoxAccount.ItemIndex > -1 then begin
    EditAccount.Color := clSilver;
    EditAccount.Text := '';
    EditPassword.Text := '';
    EditAddress.Text := '';
    EditLoginTime.Text := '';
    EditAccount.ReadOnly := True;
    ButtonDel.Enabled := True;
    nID := Integer(ComboBoxAccount.Items.Objects[ComboBoxAccount.ItemIndex]);
    g_Query.SQL.Clear;
    g_Query.SQL.Add('select * from users where ID = ' + IntToStr(nID));
    g_Query.Open;
    Try
      if g_Query.RecordCount > 0 then begin
        EditAccount.Text := g_Query.FieldByName('Account').AsString;
        CheckBoxActive.Checked := g_Query.FieldByName('Active').AsBoolean;
        EditQQ.Text := g_Query.FieldByName('QQ').AsString;
        EditAddress.Text := g_Query.FieldByName('LoginAddress').AsString;
        EditLoginTime.Text := g_Query.FieldByName('LoginTime').AsString;
        EditPassword.Text := g_Query.FieldByName('Password').AsString;
        EditBindList.Text := g_Query.FieldByName('UrlList').AsString;
        EditPublicID.Text := g_Query.FieldByName('PublicID').AsString;
        EditGUID.Text := g_Query.FieldByName('GUID').AsString;
        EditBindCount.Value := g_Query.FieldByName('BindCount').AsInteger;
        EditUserResetCount.Value := g_Query.FieldByName('ResetCount').AsInteger;
        CheckBoxAgent.Checked := g_Query.FieldByName('IsAgent').AsBoolean;
        EditMoney.Value := g_Query.FieldByName('Money').AsInteger;
        EditAgentLogin.Value := g_Query.FieldByName('AgentLogin').AsInteger;
        EditAgentM2.Value := g_Query.FieldByName('AgentM2').AsInteger;
        EditRegTime.Text := g_Query.FieldByName('CreateTime').AsString;
        CheckBoxBindPC.Checked := g_Query.FieldByName('BindPC').AsBoolean;
        CheckBoxBindIP.Checked := g_Query.FieldByName('BindIP').AsBoolean;
        CheckBoxAdmin.Checked := g_Query.FieldByName('IsAdmin').AsBoolean;
      end else begin
        Application.MessageBox(PChar('获取帐户' + ComboBoxAccount.Items[ComboBoxAccount.ItemIndex] + '信息失败！'), '提示信息', MB_OK + MB_ICONSTOP);
        ComboBoxAccount.ItemIndex := -1;
      end;
    Finally
      g_Query.Close;
    End;
    EditUseBindCount.Value := 0;
    g_Query.SQL.Clear;
    g_Query.SQL.Add('select count(*) from MarkList where AccountID = ' + IntToStr(nID));
    g_Query.Open;
    Try
      if g_Query.RecordCount > 0 then begin
        EditUseBindCount.Value := g_Query.Fields[0].AsInteger;
      end;
    Finally
      g_Query.Close;
    End;
  end;

end;

procedure TFormAccount.EditAccountChange(Sender: TObject);
begin
  if ((not EditAccount.ReadOnly) and (Trim(EditAccount.Text) <> '')) or (EditAccount.ReadOnly and (ComboBoxAccount.ItemIndex > -1)) then
    ButtonSave.Enabled := True;
end;

procedure TFormAccount.Open;
begin
  ShowModal;
end;

end.
