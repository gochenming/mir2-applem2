unit FrmChangePass;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, JSocket, Common;

type
  TFormChangePass = class(TForm)
    ClientSocket: TClientSocket;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    EditName: TEdit;
    EditOldPass: TEdit;
    EditNewPass: TEdit;
    EditNewPass2: TEdit;
    Button1: TButton;
    ButtonClose: TButton;
    Label8: TLabel;
    Label16: TLabel;
    procedure ClientSocketConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure ClientSocketDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure ClientSocketError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure EditNameKeyPress(Sender: TObject; var Key: Char);
    procedure ButtonCloseClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ClientSocketRead(Sender: TObject; Socket: TCustomWinSocket);
  private
    code: Byte;
  public
    procedure Open(addrs: string; Port: Word);
    procedure CheckEditText();
    procedure ChangePassword;
    procedure SendSocket(sendstr: string);
  end;

var
  FormChangePass: TFormChangePass;

implementation

{$R *.dfm}

uses
  Hutil32, Grobal2, EDcode;

{ TFormChangePass }

procedure TFormChangePass.Button1Click(Sender: TObject);
begin
  CheckEditText;
end;

procedure TFormChangePass.ButtonCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFormChangePass.ChangePassword;
resourcestring
  sText1 = '%s'#9'%s'#9'%s';
var
  msg: TDefaultMessage;
  sMsg, SendMsg: string;
begin
  Button1.Enabled := False;
  msg := MakeDefaultMsg(CM_CHANGEPASSWORD, 0, 0, 0, 0);
  sMsg := ForMat(sText1, [EditName.Text, EditOldPass.Text, EditNewPass.Text]);
  SendMsg := EncodeMessage(msg) + EncodeString(sMsg);
  SendSocket(SendMsg);
end;

procedure TFormChangePass.CheckEditText;
begin
  if EditName.Text = '' then begin
    Beep;
    EditName.SetFocus;
    exit;
  end;
  if EditOldPass.Text = '' then begin
    Beep;
    EditOldPass.SetFocus;
    exit;
  end;
  if EditNewPass.Text = '' then begin
    Beep;
    EditNewPass.SetFocus;
    exit;
  end;
  if EditNewPass2.Text <> EditNewPass.Text then begin
    Beep;
    EditNewPass.SetFocus;
    exit;
  end;
  ChangePassword;
end;

procedure TFormChangePass.ClientSocketConnect(Sender: TObject; Socket: TCustomWinSocket);
begin
  Socket.SendText('*');
end;

procedure TFormChangePass.ClientSocketDisconnect(Sender: TObject; Socket: TCustomWinSocket);
begin
  Label16.Caption := '连接已关闭...';
end;

procedure TFormChangePass.ClientSocketError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
  ErrorCode := 0;
  Socket.Close;
  Label16.Caption := '连接服务器失败...';
end;

procedure TFormChangePass.ClientSocketRead(Sender: TObject; Socket: TCustomWinSocket);
resourcestring
  sText1 = '密码变更成功.     ';
  sText2 = '[失败]：原密码或账号错误，不能修改.';
  sText3 = '[失败]：账号被锁定，请稍后再试.';
  sText4 = '[失败]：未知错误，不能进行此项操作.';
var
  datablock, data, head, body: string;
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
      case msg.Ident of
        SM_CHGPASSWD_SUCCESS: begin
            MessageBox(Handle, PChar(sText1), '修改密码', MB_OK or MB_ICONASTERISK);
            Close;
          end;
        SM_CHGPASSWD_FAIL: begin
            case msg.Recog of
              -1: MessageBox(Handle, PChar(sText2), '修改密码', MB_OK or MB_ICONASTERISK);
              -2: MessageBox(Handle, PChar(sText3), '修改密码', MB_OK or MB_ICONASTERISK);
            else
              MessageBox(Handle, PChar(sText4), '修改密码', MB_OK or MB_ICONASTERISK);
            end;
          end;
      end;
    end;
  end;
end;

procedure TFormChangePass.EditNameKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = '~') or (Key = '''') or (Key = ' ') then
    Key := #0;
  if Key = #13 then begin
    Key := #0;
    CheckEditText;
  end;
end;

procedure TFormChangePass.Open(addrs: string; Port: Word);
begin
  code := 1;
  Label16.Caption := '正在连接服务器...';
  ClientSocket.Close;
  ClientSocket.Host := addrs;
  ClientSocket.Port := Port;
  ClientSocket.Open;
  ShowModal;
end;

procedure TFormChangePass.SendSocket(sendstr: string);
begin
  if ClientSocket.Socket.Connected then begin
    ClientSocket.Socket.SendText('#' + IntToStr(code) + sendstr + '!');
    Inc(code);
    if code >= 10 then
      code := 1;
  end;
end;

end.

