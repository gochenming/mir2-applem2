unit FrmLogin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, GeneralCommon, ComCtrls,
  Dialogs, StdCtrls, Buttons, JSocket, EDCode, SCShare, Hutil32, ExtCtrls;

type
  TFormLogin = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    EditName: TEdit;
    EditPassword: TEdit;
    Label2: TLabel;
    ButtonOK: TBitBtn;
    ButtonExit: TBitBtn;
    CSocket: TClientSocket;
    Timer1: TTimer;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CSocketConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure CSocketDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure CSocketError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure CSocketRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure Timer1Timer(Sender: TObject);
    procedure ButtonExitClick(Sender: TObject);
    procedure ButtonOKClick(Sender: TObject);
  private
    FSocketStr: string;
    procedure SendSocket(sSendStr: string);
    procedure GetInfo(sData: string);
  public
    procedure Lock(boLock: Boolean);
  end;

var
  FormLogin: TFormLogin;

implementation

uses FrmMain;

{$R *.dfm}

{ TFormLogin }

function CheckEMailRule(sEMail: string): Boolean;
var
  Chr: Char;
  str1, str2: string;
begin
  Result := False;
  str2 := GetValidStr3(sEMail, str1, ['@']);
  if Pos('.', str2) <= 0 then
    exit;
  Result := True;
  for Chr in str1 do begin
    if not (Chr in ['a'..'z', '0'..'9', '_', '-']) then begin
      Result := False;
      Exit;
    end;
  end;
  for Chr in str2 do begin
    if not (Chr in ['a'..'z', '0'..'9', '_', '.', '-']) then begin
      Result := False;
      Exit;
    end;
  end;
end;

procedure TFormLogin.ButtonExitClick(Sender: TObject);
begin
  Close;
end;

procedure TFormLogin.ButtonOKClick(Sender: TObject);
var
  sName, sPass: string;
  DefMsg: TDefaultMessage;
begin
  sName := Trim(EditName.Text);
  sPass := Trim(EditPassword.Text);
  if sName = '' then begin
    Application.MessageBox('帐号不能为空！', '提示信息', MB_OK + MB_ICONINFORMATION);
    Exit;
  end;
  if not CheckEMailRule(sName) then begin
    Application.MessageBox('帐号格式不正确！', '提示信息', MB_OK + MB_ICONINFORMATION);
    Exit;
  end;
  if sPass = '' then begin
    Application.MessageBox('密码不能为空！', '提示信息', MB_OK + MB_ICONINFORMATION);
    Exit;
  end;
  Lock(True);
  Caption := '正在验证帐户信息...';
  DefMsg := MakeDefaultMsg(CM_USERLISTLOGIN, 0, 0, 0, 0);
  SendSocket(EncodeMessage(DefMsg) + EncodeString(sName + '/' + sPass));
end;

procedure TFormLogin.CSocketConnect(Sender: TObject; Socket: TCustomWinSocket);
begin
  FSocketStr := '';
  Caption := '请先登录';
  Lock(False);
  SendSocket('+');
end;

procedure TFormLogin.CSocketDisconnect(Sender: TObject; Socket: TCustomWinSocket);
begin
  FSocketStr := '';
  Caption := '与服务器断开连接...';
end;

procedure TFormLogin.CSocketError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
  FSocketStr := '';
  Caption := '连接服务器失败...';
  ErrorCode := 0;
end;

procedure TFormLogin.CSocketRead(Sender: TObject; Socket: TCustomWinSocket);
var
  msg, DefMsg: TDefaultMessage;
  sData, head, body, sSendStr: string;
  Item: TListItem;
  I: Integer;
begin
  FSocketStr := FSocketStr + Socket.ReceiveText;
  while FSocketStr <> '' do begin
    if Pos('!', FSocketStr) <= 0 then break;
    FSocketStr := ArrestStringEx(FSocketStr, '#', '!', sData);
    if Length(sData) >= DEFBLOCKSIZE then begin
      head := Copy(sData, 1, DEFBLOCKSIZE);
      body := Copy(sData, DEFBLOCKSIZE + 1, Length(sData) - DEFBLOCKSIZE);
      msg := DecodeMessage(head);
      case Msg.Ident of
        SM_USERLISTLOGIN_FAIL: begin
            Application.MessageBox(PChar(DecodeString(body)), '提示信息', MB_OK + MB_ICONSTOP);
            Lock(False);
          end;
        SM_USERLISTLOGIN_OK: begin
            Caption := '正在获取数据...';
            sSendStr := '';
            for I := 0 to FormMain.lvServerList.Items.Count - 1 do begin
              Item := FormMain.lvServerList.Items[I];
              if Item.SubItems[4] = '' then
                sSendStr := sSendStr + EncodeString(IntToStr(I) + '/1/' + Item.SubItems[2]) + '/';
              if Item.SubItems[5] = '' then
                sSendStr := sSendStr + EncodeString(IntToStr(I) + '/2/' + Item.SubItems[3]) + '/';
            end;
            DefMsg := MakeDefaultMsg(CM_USERGETENINFO, 0, 0, 0, 0);
            SendSocket(EncodeMessage(DefMsg) + sSendStr);
          end;
        SM_USERGETENINFO_OK: GetInfo(body);
      end;
    end;
  end;
end;

procedure TFormLogin.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  CSocket.Close;
end;

procedure TFormLogin.GetInfo(sData: string);
var
  sInfo, S1, S2, S3: string;
  nItem: Integer;
  boAddr: Boolean;
  Item: TListItem;
begin
  while sData <> '' do begin
    sData := GetValidStr3(sData, sInfo, ['/']);
    if sInfo = '' then break;
    sInfo := DecodeString(sInfo);
    sInfo := GetValidStr3(sInfo, S1, ['/']);
    sInfo := GetValidStr3(sInfo, S2, ['/']);
    sInfo := GetValidStr3(sInfo, S3, ['/']);
    nItem := StrToIntDef(S1, -1);
    boAddr := S2 = '1';
    if (nItem > -1) and (nItem < FormMain.lvServerList.Items.Count) then begin
      Item := FormMain.lvServerList.Items[nItem];
      if boAddr then Item.SubItems[4] := S3
      else Item.SubItems[5] := S3;
    end;
  end;
  Close;
end;

procedure TFormLogin.Lock(boLock: Boolean);
begin
  FormLogin.EditPassword.Enabled := not boLock;
  FormLogin.EditName.Enabled := not boLock;
  FormLogin.ButtonOK.Enabled := not boLock;
end;

procedure TFormLogin.SendSocket(sSendStr: string);
begin
  CSocket.Socket.SendText(g_CodeHead + sSendStr + g_CodeEnd);
end;

procedure TFormLogin.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False;
  CSocket.Active := True;
  Caption := '正在连接服务器...';
end;

end.
