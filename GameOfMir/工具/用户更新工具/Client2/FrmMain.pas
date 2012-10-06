unit FrmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, GeneralCommon, Hutil32, EDcode, SCShare, 
  Dialogs, ComCtrls, Menus, JSocket, ExtCtrls, StdCtrls, ShellAPI, MD5Unit;

type
  pTClientDownInfo = ^TClientDownInfo;
  TClientDownInfo = packed record
    DownListInfo: TDownListInfo;
    DownUrl: string;
  end;

  TFormMain = class(TForm)
    ListView1: TListView;
    StatusBar: TStatusBar;
    MainMenu1: TMainMenu;
    CSocket: TClientSocket;
    httpwww361m2com1: TMenuItem;
    Panel1: TPanel;
    MemoHint: TMemo;
    PopupMenu1: TPopupMenu;
    D1: TMenuItem;
    KeepTimer: TTimer;
    DownTimer: TTimer;
    DownLoginTimer: TTimer;
    procedure httpwww361m2com1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormActivate(Sender: TObject);
    procedure CSocketConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure CSocketDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure CSocketError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure FormCreate(Sender: TObject);
    procedure CSocketRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure KeepTimerTimer(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure D1Click(Sender: TObject);
    procedure DownTimerTimer(Sender: TObject);
    procedure DownLoginTimerTimer(Sender: TObject);
  private
    FSocketStr: string;
    FboLogin: Boolean;
    FFileMD5: string;
    FFileName: string;
    FGameName: string;
    DefMsg: TDefaultMessage;
    procedure ClientGetDownList(sData: string);
  public
    procedure SendSocket(sSendStr: string);
    procedure OutMessage(sMsg: string);
    procedure SaveFileData(Msg: TDefaultMessage; sData: string);
  end;

var
  FormMain: TFormMain;

implementation

uses FrmLogin;

{$R *.dfm}

procedure TFormMain.ClientGetDownList(sData: string);
var
  sInfo, sUrl: string;
  DownListInfo: TDownListInfo;
  ClientDownInfo: pTClientDownInfo;
  Item: TListItem;
begin
  ListView1.Items.Clear;
  while sData <> '' do begin
    sData := GetValidStr3(sData, sInfo, ['/']);
    sData := GetValidStr3(sData, sUrl, ['/']);
    if (sInfo = '') or (sUrl = '') then break;
    FillChar(DownListInfo, SizeOf(DownListInfo), #0);
    DecodeBuffer(sInfo, @DownListInfo, SizeOf(DownListInfo));
    sUrl := DecodeString(sUrl);
    New(ClientDownInfo);
    ClientDownInfo.DownListInfo := DownListInfo;
    ClientDownInfo.DownUrl := sUrl;
    Item := ListView1.Items.Add;
    Item.Caption := DownListInfo.sFileName;
    if DownListInfo.nFileSize = 0 then Item.SubItems.Add('未知')
    else if DownListInfo.nFileSize > (1024 * 1024) then Item.SubItems.Add(Format('%.2f M', [DownListInfo.nFileSize / 1024 / 1024]))
    else if DownListInfo.nFileSize > (1024) then Item.SubItems.Add(Format('%.2f KB', [DownListInfo.nFileSize / 1024]))
    else Item.SubItems.Add(Format('%d B', [DownListInfo.nFileSize]));
    Item.SubItems.AddObject(DateTimeToStr(DownListInfo.dwTime), TObject(ClientDownInfo));
  end;
  OutMessage('获取完成..');
end;

procedure TFormMain.CSocketConnect(Sender: TObject; Socket: TCustomWinSocket);
begin
  FboLogin := False;
  FormLogin.Caption := '登陆界面';
  FormLogin.Lock(False);
  FSocketStr := '';
  SendSocket('+');
  KeepTimer.Enabled := True;
end;

procedure TFormMain.CSocketDisconnect(Sender: TObject; Socket: TCustomWinSocket);
begin
  FboLogin := False;
  FSocketStr := '';
  KeepTimer.Enabled := False;
  Application.MessageBox('与服务器断开连接！', '提示信息', MB_OK + MB_ICONINFORMATION);
  Application.Terminate;
end;

procedure TFormMain.CSocketError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
  FboLogin := False;
  KeepTimer.Enabled := False;
  FSocketStr := '';
  ErrorCode := 0;
  FormLogin.Caption := '连接服务器失败...';
end;

procedure TFormMain.CSocketRead(Sender: TObject; Socket: TCustomWinSocket);
var
  msg: TDefaultMessage;
  sData, head, body: string;
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
        SM_DOWNLOGIN_OK: begin
            FboLogin := True;
            FormLogin.Close;
            OutMessage('正在获取下载列表信息...');
            DefMsg := MakeDefaultMsg(CM_GETDOWNLIST, 0, 0, 0, 0);
            SendSocket(EncodeMessage(DefMsg));
          end;
        SM_DOWNLOGIN_FAIL: begin
            FormLogin.Caption := '登陆界面';
            Application.MessageBox(PChar(DecodeString(body)), '提示信息', MB_OK + MB_ICONINFORMATION);
            FormLogin.Lock(False);
          end;
        SM_DOWNLIST: ClientGetDownList(body);
        SM_DOWNM2SERVER_FAIL: begin
            OutMessage(DecodeString(body));
            DownTimer.Enabled := True;
          end;
        SM_DOWNM2SERVER_DATA: SaveFileData(Msg, body);
        SM_DOWNLOGINEXE_FAIL: begin
            OutMessage(DecodeString(body));
            DownLoginTimer.Enabled := True;
          end;
        SM_DOWNLOGINEXE_DATA: SaveFileData(Msg, body);
      end;
    end;
  end;
end;

procedure TFormMain.D1Click(Sender: TObject);
var
  ClientDownInfo: pTClientDownInfo;
  sGameName: string;
begin
  if (ListView1.ItemIndex > -1) and (ListView1.ItemIndex < ListView1.Items.Count) then begin
    ClientDownInfo := pTClientDownInfo(ListView1.Items[ListView1.ItemIndex].SubItems.Objects[1]);
    case ClientDownInfo.DownListInfo.DownType of
      dtFile: ;
      dt_m2: begin
          ListView1.Enabled := False;
          OutMessage('正在准备下载M2Server.exe，请稍候...');
          DefMsg := MakeDefaultMsg(CM_DOWNM2SERVER, 0, 0, 0, 0);
          SendSocket(EncodeMessage(DefMsg));
        end;
      dt_Login: begin
          sGameName := '';
          if InputQuery('输入框', '请输入自定义游戏名称'#13#10'例如：飞鸿传奇', sGameName) then begin
            sGameName := Trim(sGameName);
            if sGameName = '' then begin
              Application.MessageBox('游戏名称不能为空！', '提示信息', MB_OK + MB_ICONINFORMATION);
              Exit;
            end;
            if Length(sGameName) > 12 then begin
              Application.MessageBox('游戏名称最多只允许6个汉字长度！', '提示信息', MB_OK + MB_ICONINFORMATION);
              Exit;
            end;
            ListView1.Enabled := False;
            FGameName := sGameName;
            OutMessage('正在准备下载Login.exe，请稍候...');
            DefMsg := MakeDefaultMsg(CM_DOWNLOGINEXE, 0, 0, 0, 0);
            SendSocket(EncodeMessage(DefMsg) + EncodeString(FGameName));
          end;
        end;
    end;
  end;

end;

procedure TFormMain.DownLoginTimerTimer(Sender: TObject);
begin
  DownLoginTimer.Enabled := False;
  DefMsg := MakeDefaultMsg(CM_DOWNLOGINEXE, 0, 0, 0, 0);
  SendSocket(EncodeMessage(DefMsg) + EncodeString(FGameName));
end;

procedure TFormMain.DownTimerTimer(Sender: TObject);
begin
  DownTimer.Enabled := False;
  DefMsg := MakeDefaultMsg(CM_DOWNM2SERVER, 0, 0, 0, 0);
  SendSocket(EncodeMessage(DefMsg));
end;

procedure TFormMain.FormActivate(Sender: TObject);
begin
  CSocket.Active := True;
  FormLogin.ShowModal;
end;

procedure TFormMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := False;
  if Application.MessageBox('是否确定关闭下载工具？', '提示信息', MB_OKCANCEL + MB_ICONQUESTION) = IDOK then
  begin
    CanClose := True;
  end;
end;

procedure TFormMain.FormCreate(Sender: TObject);
begin
  Randomize;
  MemoHint.Lines.Clear;
  CreateDir('.\DownDir\');
end;

procedure TFormMain.httpwww361m2com1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'Open', 'http://www.361m2.com', '', '', SW_SHOW);
end;

procedure TFormMain.KeepTimerTimer(Sender: TObject);
begin
  CSocket.Socket.SendText('*');
end;

procedure TFormMain.OutMessage(sMsg: string);
begin
  StatusBar.Panels[0].Text := sMsg;
end;

procedure TFormMain.PopupMenu1Popup(Sender: TObject);
begin
  D1.Enabled := (ListView1.ItemIndex > -1) and (ListView1.ItemIndex < ListView1.Items.Count);
end;

procedure TFormMain.SaveFileData(Msg: TDefaultMessage; sData: string);
var
  FileStream: TFileStream;
  sFileName: string;
  Buffer: PChar;
  boDownOK: Boolean;
  nPar: Integer;
begin
  boDownOK := False;
  if Msg.Recog = -1 then begin
    sData := DecodeString(sData);
    sData := GetValidStr3(sData, FFileMD5, ['/']);
    sData := GetValidStr3(sData, FFileName, ['/']);
    if FFileName <> '' then begin
      DeleteFile('.\DownDir\' + FFileName);
    end;
  end else begin
//    nPar := 0;
    sFileName := '.\DownDir\' + FFileName;
    GetMem(Buffer, Msg.Param);
    if FileExists(sFileName) then FileStream := TFileStream.Create(sFileName, fmOpenWrite)
    else FileStream := TFileStream.Create(sFileName, fmCreate);
    Try
      DecodeBuffer(sData, Buffer, Msg.Param);
      FileStream.Seek(MakeLong(Msg.tag, Msg.Series), soBeginning);
      FileStream.Write(Buffer^, Msg.Param);
      if FileStream.Position = Msg.Recog then begin
        boDownOK := True;
      end;
      nPar := Round(FileStream.Position / Msg.Recog * 100);
    Finally
      FileStream.Free;
      FreeMem(Buffer);
    End;
    if boDownOK then begin
      OutMessage('正在效验文件...');
      if FileToMD5Text(sFileName) = FFileMD5 then begin
        OutMessage('下载完成，保存在[' + sFileName + ']');
      end else begin
        OutMessage('文件效验失败，请重新下载...');
      end;
      ListView1.Enabled := True;
    end else begin
      OutMessage('正在下载，已完成 ' + IntToStr(nPar) + '%')
    end;
  end;
end;

procedure TFormMain.SendSocket(sSendStr: string);
begin
  CSocket.Socket.SendText(g_CodeHead + sSendStr + g_CodeEnd);
end;

end.
