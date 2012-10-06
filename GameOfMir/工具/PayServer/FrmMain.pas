unit FrmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin, INIFIles, JSocket, DB, ADODB, Share;

type
  pTWEBSession = ^TWEBSession;
  TWEBSession = packed record
    sRemoteIPaddr: string;
    ReadString: string;
    SendString: string;
  end;
  
  TFormMain = class(TForm)
    grp1: TGroupBox;
    lbl1: TLabel;
    edtPort: TEdit;
    btnStateServer: TButton;
    grp2: TGroupBox;
    grp3: TGroupBox;
    lbl4: TLabel;
    lblreg: TLabel;
    lblChangepass: TLabel;
    lbl13: TLabel;
    lbl5: TLabel;
    lblSendEmail: TLabel;
    edtPayID: TEdit;
    lbl2: TLabel;
    edtPayPass: TEdit;
    lbl3: TLabel;
    lbl7: TLabel;
    edtBackUrl: TEdit;
    grp4: TGroupBox;
    mmoLog: TMemo;
    lbl11: TLabel;
    edtDataFile: TEdit;
    btnGetFile: TButton;
    lbl12: TLabel;
    seBankCount: TSpinEdit;
    lbl14: TLabel;
    seCardCount: TSpinEdit;
    WEBSocket: TServerSocket;
    qry1: TADOQuery;
    chk1: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure edtPortChange(Sender: TObject);
    procedure btnStateServerClick(Sender: TObject);
    procedure WEBSocketClientError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
      var ErrorCode: Integer);
    procedure WEBSocketListen(Sender: TObject; Socket: TCustomWinSocket);
    procedure WEBSocketClientConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure WEBSocketClientDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure WEBSocketClientRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure btnGetFileClick(Sender: TObject);
  private
    function ProcessHttpMsg(sData: string): string;
    function ProcessGetPayInfo(sData: string): string;
    procedure BankGetKeyOk(sData: string);
    procedure BankGetKeyFail(sData: string);
    procedure CardGetKeyFail(sData, sFlag: string);
    procedure CardPayOK(sData, sFlag: string);
  public
    m_BankCount: Integer;
    m_CardCount: Integer;
    procedure MainOutMessage(sMsg: string);
    procedure LockEdit(boLock: Boolean);
    procedure ThreadTerminate(Sender: TObject);
    procedure MyException(Sender: TObject; E: Exception);
    procedure MyCopyDataMessage(var MsgData: TWmCopyData); message WM_COPYDATA;
  end;

var
  FormMain: TFormMain;

implementation

{$R *.dfm}

uses
  HUtil32, MD5Unit, MyCommon, PayThread;

const
  INIFILENAME = '.\PAYSetup.ini';

var
  Ini: TINIFile;
  boNotRead: Boolean;
  PayThreadArr: array[0..10] of TPayGetThread;
  BankCount: Integer;
  CardCount: Integer;

procedure TFormMain.BankGetKeyFail(sData: string);
begin
  qry1.SQL.Clear;
  qry1.SQL.Add('UPDATE myorder SET paystatus = 2 where id = ' + sData);
  qry1.ExecSQL;
end;

procedure TFormMain.BankGetKeyOk(sData: string);
var
  sID, sKey: string;
begin
  sKey := GetValidStr3(sData, sID, ['|']);
  qry1.SQL.Clear;
  qry1.SQL.Add('UPDATE myorder SET paystatus = 1, paystring = ' + #39 + sKey + #39 + ' where id = ' + sID);
  qry1.ExecSQL;
end;

procedure TFormMain.btnGetFileClick(Sender: TObject);
{var
  SendData: TCopyDataStruct;
  sSendMsg: string;
  List: TStringList;    }
begin
{  List := TStringList.Create;
  List.LoadFromFile('D:\111.txt');
  sSendMsg := '255|' + List.Text;
  List.Free;
  SendData.cbData := Length(sSendMsg) + 1;
  GetMem(SendData.lpData, SendData.cbData);
  StrCopy(SendData.lpData, PChar(sSendMsg));
  SendMessage(Handle, WM_COPYDATA, COPYMSG_CARD_OK, Cardinal(@SendData));
  FreeMem(SendData.lpData);  }
end;

procedure TFormMain.btnStateServerClick(Sender: TObject);
var
  i: Integer;
  boExit: Boolean;
begin
  btnStateServer.Enabled := False;
  if WEBSocket.Active then begin
    for I := Low(PayThreadArr) to High(PayThreadArr) do begin
      if PayThreadArr[I] <> nil then begin
        PayThreadArr[I].Terminate;
      end;
    end;
    btnStateServer.Caption := '正在停止..';
    MainOutMessage('正在停止服务...');
    WEBSocket.Active := False;
  end else begin
    btnStateServer.Caption := '正在启动..';
    MainOutMessage('正在启动服务...');
    g_PayUserID := Trim(edtPayID.Text);
    g_PayUserPass := Trim(edtPayPass.Text);
    g_PayBackUrl := Trim(edtBackUrl.Text);
    g_HTTPEncodeBackUrl := HTTPEncode(g_PayBackUrl);
    qry1.ConnectionString := 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=' + edtDataFile.Text + ';Persist Security Info=False';
    WEBSocket.Port := StrToIntDef(edtPort.Text, 8999);
    WEBSocket.Active := True;
    BankCount := seBankCount.Value;
    CardCount := seCardCount.Value;
    for I := 0 to BankCount - 1 do
      PayThreadArr[I] := TPayGetThread.Create(I, ThreadTerminate, False);
    for I := 0 to CardCount - 1 do
      PayThreadArr[10 - I] := TPayGetThread.Create(10 - I, ThreadTerminate, False);
  end;
  if WEBSocket.Active then begin
    LockEdit(True);
    btnStateServer.Caption := '停止服务(&S)';
    MainOutMessage('服务启动完成...');
  end
  else begin
    WEBSocket.Active := False;
    while True do begin
      boExit := True;
      for I := Low(PayThreadArr) to High(PayThreadArr) do begin
        if PayThreadArr[I] <> nil then begin
          boExit := False;
          Break;
        end;
      end;
      if boExit then break;
      application.ProcessMessages;
      Sleep(10);
    end;
    btnStateServer.Caption := '启动服务(&S)';
    MainOutMessage('服务已停止...');
    LockEdit(False);
  end;
  btnStateServer.Enabled := True;
end;

procedure TFormMain.CardGetKeyFail(sData, sFlag: string);
begin
  qry1.SQL.Clear;
  qry1.SQL.Add('UPDATE myorder SET disposed = true, paystatus = ' + sFlag + ' where id = ' + sData);
  qry1.ExecSQL;
end;

procedure TFormMain.CardPayOK(sData, sFlag: string);
var
  sID, sStr: string;
begin
  sStr := GetValidStrEx(sData, sID, ['|']);
  qry1.SQL.Clear;
  qry1.SQL.Add('select * from myorder where id = ' + sID);
  qry1.Open;
  Try
    if qry1.RecordCount > 0 then begin
      qry1.Edit;
      qry1.FieldByName('disposed').AsBoolean := True;
      qry1.FieldByName('paystatus').AsInteger := StrToIntDef(sFlag, 0);
      qry1.FieldByName('paystring').AsString := sStr;
      qry1.Post;
    end;
  Finally
    qry1.Close;
  End;
end;

procedure TFormMain.edtPortChange(Sender: TObject);
begin
  if not boNotRead then begin
    Ini.WriteString('Setup', 'Port', edtPort.Text);
    Ini.WriteString('Setup', 'DataFile', edtDataFile.Text);
    Ini.WriteString('Setup', 'BankCount', seBankCount.Text);
    Ini.WriteString('Setup', 'CardCount', seCardCount.Text);
    Ini.WriteString('Setup', 'PayID', edtPayID.Text);
    Ini.WriteString('Setup', 'BackUrl', edtBackUrl.Text);
    Ini.WriteString('Setup', 'UserName', edtPayPass.Text);
    Ini.WriteBool('Setup', 'IISVer', chk1.Checked);
  end;
end;

procedure TFormMain.MyException(Sender: TObject; E: Exception);
begin
  MainOutMessage(E.Message);
end;

procedure TFormMain.FormCreate(Sender: TObject);
begin
  Application.OnException := MyException;
  g_MainHandle := Handle;
  mmoLog.Lines.Clear;
  Randomize;
  boNotRead := True;
  Ini := TIniFile.Create(INIFILENAME);
  edtPort.Text := Ini.ReadString('Setup', 'Port', '8999');
  edtDataFile.Text := Ini.ReadString('Setup', 'DataFile', '');
  seBankCount.Text := Ini.ReadString('Setup', 'BankCount', '1');
  seCardCount.Text := Ini.ReadString('Setup', 'CardCount', '1');
  edtPayID.Text := Ini.ReadString('Setup', 'PayID', '');
  edtBackUrl.Text := Ini.ReadString('Setup', 'BackUrl', '');
  edtPayPass.Text := Ini.ReadString('Setup', 'UserName', '');
  chk1.Checked := Ini.ReadBool('Setup', 'IISVer', False);
  boNotRead := False;
  m_BankCount := 0;
  m_CardCount := 0;
end;

procedure TFormMain.FormDestroy(Sender: TObject);
begin
  Ini.Free;
end;

procedure TFormMain.LockEdit(boLock: Boolean);
begin
  edtPort.Enabled := not boLock;
  edtDataFile.Enabled := not boLock;
  seBankCount.Enabled := not boLock;
  seCardCount.Enabled := not boLock;
  edtPayID.Enabled := not boLock;
  edtBackUrl.Enabled := not boLock;
  edtPayPass.Enabled := not boLock;
end;

procedure TFormMain.MainOutMessage(sMsg: string);
begin
  if sMsg = '' then exit;
  if mmoLog.Lines.Count > 200 then
    mmoLog.Lines.Delete(0);
  mmoLog.Lines.Add(FormatDateTime('[DD HH:MM:SS] ', Now) + sMsg);
end;

procedure TFormMain.MyCopyDataMessage(var MsgData: TWmCopyData);
begin
  Try
    case MsgData.From of
      COPYMSG_BANK_GETKEY_OK: BankGetKeyOk(StrPas(MsgData.CopyDataStruct^.lpData));
      COPYMSG_BANK_GETKEY_FAIL: BankGetKeyFail(StrPas(MsgData.CopyDataStruct^.lpData));
      COPYMSG_CARD_GETKEY_FAIL: CardGetKeyFail(StrPas(MsgData.CopyDataStruct^.lpData), '-1');
      COPYMSG_CARD_IDPASS_FAIL: CardGetKeyFail(StrPas(MsgData.CopyDataStruct^.lpData), '-3');
      COPYMSG_CARD_TIMEOUT: CardGetKeyFail(StrPas(MsgData.CopyDataStruct^.lpData), '-4');
      COPYMSG_CARD_OK: CardPayOK(StrPas(MsgData.CopyDataStruct^.lpData), '1');
    end;
  Except
    on E: Exception do begin
      MainOutMessage(E.Message);
    end;
  End;
end;

function TFormMain.ProcessGetPayInfo(sData: string): string;
var
  PayDBInfo: TPayDBInfo;
begin
  qry1.SQL.Clear;
  qry1.SQL.Add('select top 1 * from myorder where id = ' + sData + ' and paydispose = false');
  qry1.Open;
  try
    if qry1.RecordCount > 0 then begin
      PayDBInfo.ID := qry1.FieldByName('id').AsInteger;
      PayDBInfo.billno := qry1.FieldByName('billno').AsString;
      PayDBInfo.price := qry1.FieldByName('price').AsInteger;
      PayDBInfo.custom1 := qry1.FieldByName('custom1').AsString;
      PayDBInfo.custom2 := qry1.FieldByName('custom2').AsString;
      PayDBInfo.payvia := qry1.FieldByName('payvia').AsString;
      PayDBInfo.paycardno := qry1.FieldByName('paycardno').AsString;
      PayDBInfo.paycardpass := qry1.FieldByName('paycardpass').AsString;
      PayDBInfo.orderdate := qry1.FieldByName('orderdate').AsDateTime;
      if PayDBInfo.payvia = '1' then begin
        if PayThreadArr[Random(BankCount)] <> nil then begin
          PayThreadArr[Random(BankCount)].AddPayInfo(@PayDBInfo);
          Inc(m_BankCount);
          lblreg.Caption := IntToStr(m_BankCount);
        end;
      end else
      if (PayDBInfo.payvia = '21') or (PayDBInfo.payvia = '13') or (PayDBInfo.payvia = '7') or
        (PayDBInfo.payvia = '12') or (PayDBInfo.payvia = '8') then begin
        if PayThreadArr[10 - Random(CardCount)] <> nil then begin
          PayThreadArr[10 - Random(CardCount)].AddPayInfo(@PayDBInfo);
          Inc(m_CardCount);
          lblChangepass.Caption := IntToStr(m_CardCount);
        end;
      end;
    end;
  finally
    qry1.Close;
  end;
end;

function TFormMain.ProcessHttpMsg(sData: string): string;
var
  sMsgCode, sParam: string;
  btMsgCode: Byte;
begin
  Result := '-1';
  sParam := GetValidStr3(sData, sMsgCode, ['&']);
  btMsgCode := StrToIntDef(sMsgCode, 0);
  if (sParam <> '') and (btMsgCode > 0) then begin
    case btMsgCode of
      1: ProcessGetPayInfo(sParam);
    end;
  end;
end;

procedure TFormMain.ThreadTerminate(Sender: TObject);
begin
  with Sender as TPayGetThread do begin
    if ListIndex in [Low(PayThreadArr)..High(PayThreadArr)] then begin
      PayThreadArr[ListIndex] := nil;
    end;
  end;
end;

procedure TFormMain.WEBSocketClientConnect(Sender: TObject; Socket: TCustomWinSocket);
var
  WEBSession: pTWEBSession;
begin
  Socket.nIndex := 0;

  New(WEBSession);
  WEBSession.sRemoteIPaddr := Socket.RemoteAddress;
  WEBSession.ReadString := '';
  WEBSession.SendString := '';
  Socket.nIndex := Integer(WEBSession);
end;

procedure TFormMain.WEBSocketClientDisconnect(Sender: TObject; Socket: TCustomWinSocket);
begin
  if Socket.nIndex <> 0 then
    Dispose(pTWEBSession(Socket.nIndex));
  Socket.nIndex := 0;
end;

procedure TFormMain.WEBSocketClientError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
  Socket.Close;
  ErrorCode := 0;
end;

procedure TFormMain.WEBSocketClientRead(Sender: TObject; Socket: TCustomWinSocket);
var
  WEBSession: pTWEBSession;
  sReadStr, sTempStr, sSendStr, sOldReadStr: string;
  nPos, nDataSize: Integer;
begin
  if Socket.nIndex <> 0 then begin
    WEBSession := pTWEBSession(Socket.nIndex);
    WEBSession.ReadString := WEBSession.ReadString + Socket.ReceiveText;
    if length(WEBSession.ReadString) > 4096 then begin
      Socket.Close;
      exit;
    end;
    while WEBSession.ReadString <> '' do begin
      nPos := Pos(#13#10#13#10, WEBSession.ReadString);
      if nPos <= 0 then break;
      sOldReadStr := WEBSession.ReadString;
      sSendStr := '';
      sTempStr := Copy(WEBSession.ReadString, 1, nPos);
      WEBSession.ReadString := Copy(WEBSession.ReadString, nPos + 4, Length(WEBSession.ReadString));
      nPos := Pos('Content-Length: ', sTempStr);
      if nPos > 0 then begin
        sTempStr := Copy(sTempStr, nPos + Length('Content-Length: '), 12);
        GetValidStr3(sTempStr, sTempStr, [#13, #10]);
        nDataSize := StrToIntDef(sTempStr, 0);
        if (nDataSize > 0) then begin
          if nDataSize <= Length(WEBSession.ReadString) then begin
            sReadStr := Copy(WEBSession.ReadString, 1, nDataSize);
            WEBSession.ReadString := Copy(WEBSession.ReadString, nDataSize + 1, Length(WEBSession.ReadString));
            sSendStr := ProcessHttpMsg(sReadStr);

            sReadStr := 'HTTP/1.1 200 OK'#13#10;
            sReadStr := sReadStr + 'Date: ' + DateTimeToGMT(Now) + #13#10;
            sReadStr := sReadStr + 'Server: Microsoft-IIS/5.1'#13#10;
            if sSendStr <> '' then
              sReadStr := sReadStr + 'Content-Length: ' + IntToStr(Length(sSendStr)) + #13#10;
            sReadStr := sReadStr + 'Content-Type: text/html'#13#10;
            sReadStr := sReadStr + 'Cache-control: private'#13#10#13#10;
            Socket.SendText(sReadStr + sSendStr);
            if chk1.Checked then Socket.Close;
          end else begin
            WEBSession.ReadString := sOldReadStr;
            break;
          end;
        end else begin
          Socket.Close;
          break;
        end;
      end else begin
        Socket.Close;
        break;
      end;
    end;
  end
  else
    Socket.Close;
end;

procedure TFormMain.WEBSocketListen(Sender: TObject; Socket: TCustomWinSocket);
begin
  MainOutMessage(Format('开始监听[%s:%d]...', [Socket.LocalAddress, Socket.LocalPort]));
end;

end.
