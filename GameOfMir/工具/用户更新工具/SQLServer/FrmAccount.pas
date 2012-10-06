unit FrmAccount;

interface

uses
  Windows, SysUtils, Classes, Graphics, Controls, Forms, StdCtrls, Buttons, Share, comObj, Spin, DB, ADODB, MD5Unit;

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
    GetUserNameList: TADOStoredProc;
    GetUserInfoByID: TADOStoredProc;
    DelUserInfoByID: TADOStoredProc;
    SetUserInfo: TADOStoredProc;
    CheckBoxPackEN: TCheckBox;
    Label18: TLabel;
    EditPackPassword: TEdit;
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
      Try
        DelUserInfoByID.Parameters[1].Value := Integer(ComboBoxAccount.Items.Objects[ComboBoxAccount.ItemIndex]);
        DelUserInfoByID.ExecProc;
      Except
        on e: Exception do begin
          MainOutMessage('[Exception] DelUserInfoByID -> ExecProc ');
          MainOutMessage(E.Message);
        end;
      End;
      ComboBoxAccount.Items.Delete(ComboBoxAccount.ItemIndex);
      ComboBoxAccountChange(ComboBoxAccount);
      Application.MessageBox('帐号删除成功！', '提示信息', MB_OK + MB_ICONINFORMATION);
    end;
  end;
end;

procedure TFormAccount.ButtonFindClick(Sender: TObject);
var
  sFindName: string;
begin
  sFindName := Trim(EditFind.Text);
  ComboBoxAccount.Items.Clear;
  GetUserNameList.Parameters[0].Value := 0;
  GetUserNameList.Parameters[1].Value := 1;
  GetUserNameList.Parameters[2].Value := sFindName;
  if sFindName = '' then begin
    GetUserNameList.Parameters[2].Value := ' ';
  end else
  if CompareText(sFindName, 'PACK') = 0 then begin
    GetUserNameList.Parameters[1].Value := 6;
  end else
  if Length(sFindName) = 38 then begin
    GetUserNameList.Parameters[1].Value := 2;
  end else
  if (Length(sFindName) = 18) and (StrToInt64Def(sFindName, 0) > 0) then begin
    GetUserNameList.Parameters[1].Value := 3;
  end else
  if StrToInt64Def(sFindName, 0) > 0 then begin
    GetUserNameList.Parameters[1].Value := 4;
  end else begin
    GetUserNameList.Parameters[1].Value := 5;
  end;
  Try
    Try
      GetUserNameList.Open;
      while not GetUserNameList.Eof do begin
        ComboBoxAccount.Items.AddObject(GetUserNameList.FieldByName('Account').AsString, TObject(GetUserNameList.FieldByName('ID').AsInteger));
        GetUserNameList.Next;
      end;
    Except
      on e: Exception do begin
        MainOutMessage('[Exception] GetUserNameList -> Open ');
        MainOutMessage(E.Message);
      end;
    End;
  finally
    GetUserNameList.Close;
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
    SetUserInfo.Parameters[0].Value := 0;
    SetUserInfo.Parameters[1].Value := 0;
    SetUserInfo.Parameters[2].Value := sAccount;
    SetUserInfo.Parameters[3].Value := sPassword;
    SetUserInfo.Parameters[4].Value := wQQ;
    SetUserInfo.Parameters[5].Value := CheckBoxActive.Checked;
    SetUserInfo.Parameters[6].Value := CreateClassID;
    SetUserInfo.Parameters[7].Value := FormatDateTime('YYYYMMDDHHMMSS', Now) + IntToStr(Random(8000) + 1000);
    SetUserInfo.Parameters[8].Value := LowerCase(Trim(EditBindList.Text));
    SetUserInfo.Parameters[9].Value := EditBindCount.Value;
    SetUserInfo.Parameters[10].Value := EditUserResetCount.Value;
    SetUserInfo.Parameters[11].Value := CheckBoxAgent.Checked;
    SetUserInfo.Parameters[12].Value := EditMoney.Value;
    SetUserInfo.Parameters[13].Value := EditAgentLogin.Value;
    SetUserInfo.Parameters[14].Value := EditAgentM2.Value;
    SetUserInfo.Parameters[15].Value := CheckBoxBindPC.Checked;
    SetUserInfo.Parameters[16].Value := CheckBoxBindIP.Checked;
    SetUserInfo.Parameters[17].Value := CheckBoxAdmin.Checked;
    SetUserInfo.Parameters[18].Value := CheckBoxPackEN.Checked;
    Try
      SetUserInfo.ExecProc;
      case SetUserInfo.Parameters[0].Value of
        0: begin
            EditAccount.Text := '';
            EditPassword.Text := GetRandomPassword(6);
            EditQQ.Text := '';
            ButtonSave.Enabled := False;
            Application.MessageBox('帐号添加成功！', '提示信息', MB_OK + MB_ICONINFORMATION);
          end;
        -1: Application.MessageBox(PChar('帐号' + sAccount + '已经存在！'), '提示信息', MB_OK + MB_ICONSTOP);
        else begin
            EditAccount.Text := '';
            EditPassword.Text := GetRandomPassword(6);
            EditQQ.Text := '';
            ButtonSave.Enabled := False;
          end;
      end;
    Except
      on e: Exception do begin
        MainOutMessage('[Exception] SetUserInfo -> ExecProc(New) ');
        MainOutMessage(E.Message);
      end;
    End;
  end else
  if ComboBoxAccount.ItemIndex > -1 then begin
    SetUserInfo.Parameters[0].Value := 0;
    SetUserInfo.Parameters[1].Value := IntToStr(Integer(ComboBoxAccount.Items.Objects[ComboBoxAccount.ItemIndex]));
    SetUserInfo.Parameters[2].Value := '';
    SetUserInfo.Parameters[3].Value := Trim(EditPassword.Text);
    SetUserInfo.Parameters[4].Value := StrToIntDef(Trim(EditQQ.Text), 0);
    SetUserInfo.Parameters[5].Value := CheckBoxActive.Checked;
    SetUserInfo.Parameters[6].Value := '';
    SetUserInfo.Parameters[7].Value := '';
    SetUserInfo.Parameters[8].Value := LowerCase(Trim(EditBindList.Text));
    SetUserInfo.Parameters[9].Value := EditBindCount.Value;
    SetUserInfo.Parameters[10].Value := EditUserResetCount.Value;
    SetUserInfo.Parameters[11].Value := CheckBoxAgent.Checked;
    SetUserInfo.Parameters[12].Value := EditMoney.Value;
    SetUserInfo.Parameters[13].Value := EditAgentLogin.Value;
    SetUserInfo.Parameters[14].Value := EditAgentM2.Value;
    SetUserInfo.Parameters[15].Value := CheckBoxBindPC.Checked;
    SetUserInfo.Parameters[16].Value := CheckBoxBindIP.Checked;
    SetUserInfo.Parameters[17].Value := CheckBoxAdmin.Checked;
    SetUserInfo.Parameters[18].Value := CheckBoxPackEN.Checked;
    Try
      SetUserInfo.ExecProc;
      if SetUserInfo.Parameters[0].Value = 0 then begin
        ButtonSave.Enabled := False;
        Application.MessageBox('帐号更新成功！', '提示信息', MB_OK + MB_ICONINFORMATION);
      end
      else begin
        Application.MessageBox(PChar('更新帐户' + ComboBoxAccount.Items[ComboBoxAccount.ItemIndex] + '信息失败！'), '提示信息', MB_OK + MB_ICONSTOP);
        ComboBoxAccount.ItemIndex := -1;
      end;
    Except
      on e: Exception do begin
        MainOutMessage('[Exception] SetUserInfo -> ExecProc(Edit) ');
        MainOutMessage(E.Message);
      end;
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
    GetUserInfoByID.Parameters[0].Value := 0;
    GetUserInfoByID.Parameters[1].Value := nID;
    Try
      Try
        GetUserInfoByID.Open;
        EditUseBindCount.Value := GetUserInfoByID.Parameters[0].Value;
        if not GetUserInfoByID.Eof then begin
          EditAccount.Text := GetUserInfoByID.FieldByName('Account').AsString;
          CheckBoxActive.Checked := GetUserInfoByID.FieldByName('Active').AsBoolean;
          EditQQ.Text := GetUserInfoByID.FieldByName('QQ').AsString;
          EditAddress.Text := GetUserInfoByID.FieldByName('LoginAddress').AsString;
          EditLoginTime.Text := GetUserInfoByID.FieldByName('LoginTime').AsString;
          EditPassword.Text := GetUserInfoByID.FieldByName('Password').AsString;
          EditBindList.Text := GetUserInfoByID.FieldByName('UrlList').AsString;
          EditPublicID.Text := GetUserInfoByID.FieldByName('PublicID').AsString;
          EditGUID.Text := GetUserInfoByID.FieldByName('GUID').AsString;
          EditBindCount.Value := GetUserInfoByID.FieldByName('BindCount').AsInteger;
          EditUserResetCount.Value := GetUserInfoByID.FieldByName('ResetCount').AsInteger;
          CheckBoxAgent.Checked := GetUserInfoByID.FieldByName('IsAgent').AsBoolean;
          EditMoney.Value := GetUserInfoByID.FieldByName('Money').AsInteger;
          EditAgentLogin.Value := GetUserInfoByID.FieldByName('AgentLogin').AsInteger;
          EditAgentM2.Value := GetUserInfoByID.FieldByName('AgentM2').AsInteger;
          EditRegTime.Text := GetUserInfoByID.FieldByName('CreateTime').AsString;
          CheckBoxBindPC.Checked := GetUserInfoByID.FieldByName('BindPC').AsBoolean;
          CheckBoxBindIP.Checked := GetUserInfoByID.FieldByName('BindIP').AsBoolean;
          CheckBoxAdmin.Checked := GetUserInfoByID.FieldByName('IsAdmin').AsBoolean;
          CheckBoxPackEN.Checked := GetUserInfoByID.FieldByName('PackEN').AsBoolean;
          if CheckBoxPackEN.Checked then begin
            EditPackPassword.Text := GetMD5TextOf16(FormMain.PackENRSA.EncryptStr(EditBindList.Text));
          end else
            EditPackPassword.Text := '';
        end else begin
          Application.MessageBox(PChar('获取帐户' + ComboBoxAccount.Items[ComboBoxAccount.ItemIndex] + '信息失败！'), '提示信息', MB_OK + MB_ICONSTOP);
          ComboBoxAccount.ItemIndex := -1;
        end;
      Except
        on e: Exception do begin
          MainOutMessage('[Exception] GetUserInfoByID -> Open ');
          MainOutMessage(E.Message);
        end;
      End;
    Finally
      GetUserInfoByID.Close;
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
