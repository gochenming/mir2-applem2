unit FrmLostPass;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, JSocket, StdCtrls, Common;

type
  TFormLostPass = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    EditName: TEdit;
    EditTW1: TEdit;
    EditHD1: TEdit;
    EditTW2: TEdit;
    EditHD2: TEdit;
    Edit6: TEdit;
    EditBD: TEdit;
    Button1: TButton;
    ButtonClose: TButton;
    Label8: TLabel;
    Label16: TLabel;
    ClientSocket: TClientSocket;
    procedure EditNameKeyPress(Sender: TObject; var Key: Char);
    procedure ButtonCloseClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ClientSocketConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure ClientSocketDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure ClientSocketError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure ClientSocketRead(Sender: TObject; Socket: TCustomWinSocket);
  private
    code: Byte;
  public
    procedure Open(addrs: string; Port: Word);
    procedure CheckEditText();
    procedure LoadPassword;
    function NewIdCheckBirthDay: Boolean;
    procedure SendSocket(sendstr: string);
  end;

var
  FormLostPass: TFormLostPass;

implementation

{$R *.dfm}

uses
  Hutil32, Grobal2, EDcode;

{ TFormLostPass }

procedure TFormLostPass.Button1Click(Sender: TObject);
begin
  CheckEditText;
end;

procedure TFormLostPass.ButtonCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFormLostPass.CheckEditText;
begin
  if EditName.Text = '' then begin
    Beep;
    EditName.SetFocus;
    exit;
  end;
  if EditTW1.Text = '' then begin
    Beep;
    EditTW1.SetFocus;
    exit;
  end;
  if EditHD1.Text = '' then begin
    Beep;
    EditHD1.SetFocus;
    exit;
  end;
  if EditTW2.Text = '' then begin
    Beep;
    EditTW2.SetFocus;
    exit;
  end;
  if EditHD2.Text = '' then begin
    Beep;
    EditHD2.SetFocus;
    exit;
  end;
  if EditBD.Text = '' then begin
    Beep;
    EditBD.SetFocus;
    exit;
  end;
  if not NewIdCheckBirthDay then
    exit;
  LoadPassword;
end;

procedure TFormLostPass.ClientSocketConnect(Sender: TObject; Socket: TCustomWinSocket);
begin
  Socket.SendText('*');
end;

procedure TFormLostPass.ClientSocketDisconnect(Sender: TObject; Socket: TCustomWinSocket);
begin
  Label16.Caption := '连接已关闭...';
end;

procedure TFormLostPass.ClientSocketError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
  ErrorCode := 0;
  Socket.Close;
  Label16.Caption := '连接服务器失败...';
end;

procedure TFormLostPass.ClientSocketRead(Sender: TObject; Socket: TCustomWinSocket);
resourcestring
  sText1 = '游戏账号不存在     ';
  sText2 = '密码保护资料或生日不正确！   ';
  sText3 = '服务器已关闭密码找回服务！   ';
  sText4 = '密码保护资料或生日不正确！   ';
  sText5 = '未知错误信息..        ';
  sText6 = '账号被锁定，请稍后再试.';
var
  datablock, data, head, body{, TempData, data2}: string;
//  n: Integer;
  msg: TDefaultMessage;
begin
  Button1.Enabled := True;
  datablock := Socket.ReceiveText;
  if datablock = '*' then begin
    Socket.SendText(g_CodeHead + '+' + g_CodeEnd);
    Label16.Caption := '服务器状态良好...';
  end
  else begin
    ArrestStringEx(datablock, '#', '!', data);
    if Length(data) >= DEFBLOCKSIZE then begin
      head := Copy(data, 1, DEFBLOCKSIZE);
      body := Copy(data, DEFBLOCKSIZE + 1, Length(data) - DEFBLOCKSIZE);
      msg := DecodeMessage(head);
      if msg.Ident = SM_GETBACKPASSWD_FAIL then begin
        case msg.Recog of
          0: MessageBox(Handle, PChar(sText1), '找回密码', MB_OK or MB_ICONASTERISK);
          -1: MessageBox(Handle, PChar(sText2), '找回密码', MB_OK or MB_ICONASTERISK);
          -2: MessageBox(Handle, PChar(sText6), '找回密码', MB_OK or MB_ICONASTERISK);
          -3: MessageBox(Handle, PChar(sText4), '找回密码', MB_OK or MB_ICONASTERISK);
          -4: MessageBox(Handle, PChar(sText3), '找回密码', MB_OK or MB_ICONASTERISK);
        else
          MessageBox(Handle, PChar(sText5), '找回密码', MB_OK or MB_ICONASTERISK);
        end;
      end
      else if msg.Ident = SM_GETBACKPASSWD_SUCCESS then begin
        Edit6.Text := DecodeString(body);
      end;
    end;
  end;
end;

procedure TFormLostPass.EditNameKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = '~') or (Key = '''') or (Key = ' ') then
    Key := #0;
  if Key = #13 then begin
    Key := #0;
    CheckEditText;
  end;
end;

procedure TFormLostPass.LoadPassword;
resourcestring
  sText1 = '%s'#9'%s'#9'%s'#9'%s'#9'%s'#9'%s';
var
  msg: TDefaultMessage;
  sMsg, SendMsg: string;
begin
  Button1.Enabled := False;
  msg := MakeDefaultMsg(CM_GETBACKPASSWORD, 0, 0, 0, 0);
  sMsg := ForMat(sText1, [EditName.Text, EditTW1.Text, EditHD1.Text, EditTW2.Text, EditHD2.Text, EditBD.Text]);
  SendMsg := EncodeMessage(msg) + EncodeString(sMsg);
  SendSocket(SendMsg);
end;

function TFormLostPass.NewIdCheckBirthDay: Boolean;
var
  str, syear, smon, sday: string;
  ayear, amon, aday: integer;
  flag: Boolean;
begin
  Result := TRUE;
  flag := TRUE;
  str := EditBD.Text;
  str := GetValidStr3(str, syear, ['/']);
  str := GetValidStr3(str, smon, ['/']);
  str := GetValidStr3(str, sday, ['/']);
  ayear := StrToIntDef(syear, 0);
  amon := StrToIntDef(smon, 0);
  aday := StrToIntDef(sday, 0);
  if (ayear <= 1890) or (ayear > 2101) then
    flag := FALSE;
  if (amon <= 0) or (amon > 12) then
    flag := FALSE;
  if (aday <= 0) or (aday > 31) then
    flag := FALSE;
  if not flag then begin
    Beep;
    EditBD.SetFocus;
    Result := FALSE;
  end;
end;

procedure TFormLostPass.Open(addrs: string; Port: Word);
begin
  code := 1;
  Label16.Caption := '正在连接服务器...';
  ClientSocket.Close;
  ClientSocket.Host := addrs;
  ClientSocket.Port := Port;
  ClientSocket.Open;
  ShowModal;
end;

procedure TFormLostPass.SendSocket(sendstr: string);
begin
  if ClientSocket.Socket.Connected then begin
    ClientSocket.Socket.SendText('#' + IntToStr(code) + sendstr + '!');
    Inc(code);
    if code >= 10 then
      code := 1;
  end;
end;

end.

