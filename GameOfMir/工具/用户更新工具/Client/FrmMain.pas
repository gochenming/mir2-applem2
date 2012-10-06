unit FrmMain;

interface

uses
  Windows, Messages, SysUtils, StrUtils, Variants, Classes, Graphics, Controls, Forms, FShare, ShellAPI, INIFIles, MyCommon,
  Dialogs, BusinessSkinForm, bsSkinData, bsMessages, bsSkinCtrls, Menus, bsTrayIcon, bsSkinMenus, ImgList, bsSkinHint, bsSkinExCtrls, StdCtrls,
  bsSkinBoxCtrls, Mask, bsPngImageList, FrmHeQu, bsSkinShellCtrls, FrmGoods, AppEvnts, bsDialogs, FrmLSetup, FrmMakeLogin, FrmTools, JSocket, ExtCtrls,
  RSA, GeneralCommon, Grobal2, EDCode, Hutil32, SCShare, FrmAddLogin, FrmAddM2, FrmChangePass, FrmDownM2, FrmDownLogin, ComCtrls, FrmBindTool,
  FrmRPGView, bsColorCtrls, OleCtrls, SHDocVw, FrmShare;
const
  WM_UPDATEMSG = WM_USER + 1000;
type
  TFormMain = class(TForm)
    DForm: TbsBusinessSkinForm;
    DSkinData: TbsSkinData;
    DMsg: TbsSkinMessage;
    MainMenu: TMainMenu;
    MAINMENU_SOFT: TMenuItem;
    DHint: TbsSkinHint;
    ImageListMenuIcon: TImageList;
    MainMenuBar: TbsSkinMainMenuBar;
    N1: TMenuItem;
    MAINMENU_SOFT_EXIT: TMenuItem;
    MAINMENU_HELP: TMenuItem;
    MAINMENU_HELP_ABOUT: TMenuItem;
    MAINMENU_HELP_HOME: TMenuItem;
    N2: TMenuItem;
    MAINMENU_SOFT_CHANGEPASSWORD: TMenuItem;
    StatusBar: TbsSkinStatusBar;
    GaugeMain: TbsSkinGauge;
    PanelLog: TbsSkinStatusPanel;
    ImageListMinIcon: TImageList;
    ImageListMaxIcon: TImageList;
    MAINMENU_HELP_UPLOG: TMenuItem;
    GroupBoxBag: TbsSkinGroupBox;
    GroupBoxTool: TbsSkinGroupBox;
    ScrollBoxTool: TbsSkinScrollBox;
    BoxScrollBarRight: TbsSkinScrollBar;
    BoxSkinScrollBarBottom: TbsSkinScrollBar;
    GroupBoxLogin: TbsSkinGroupBox;
    EditPassword2: TbsSkinEdit;
    ButtonLogin: TbsSkinButton;
    CheckBoxSaveName: TbsSkinCheckRadioBox;
    LogoImage: TbsPngImageView;
    PngImages: TbsPngImageStorage;
    bsSkinTextLabel5: TbsSkinTextLabel;
    bsSkinTextLabel1: TbsSkinTextLabel;
    ComboBoxName: TbsSkinComboBox;
    EditPassword: TEdit;
    TrayIcon: TbsTrayIcon;
    FrmHeQu: TFrameHeQu;
    SelectDirectory: TbsSkinSelectDirectoryDialog;
    OpenDialog: TbsSkinOpenDialog;
    GroupBoxUserLeft: TbsSkinGroupBox;
    bsSkinVistaGlowLabel1: TbsSkinVistaGlowLabel;
    ButtonsBarLeft: TbsSkinButtonsBar;
    GroupBoxUserName: TbsSkinGroupBox;
    bsSkinStdLabel3: TbsSkinStdLabel;
    LabelBindCount: TbsSkinStdLabel;
    bsSkinStdLabel5: TbsSkinStdLabel;
    GroupBoxAgentLeft: TbsSkinGroupBox;
    bsSkinVistaGlowLabel2: TbsSkinVistaGlowLabel;
    ButtonsBarAgent: TbsSkinButtonsBar;
    GroupBoxAgentName: TbsSkinGroupBox;
    bsSkinStdLabel7: TbsSkinStdLabel;
    LabelMoney: TbsSkinStdLabel;
    bsSkinStdLabel11: TbsSkinStdLabel;
    LabelLoginMoney: TbsSkinStdLabel;
    bsSkinStdLabel1: TbsSkinStdLabel;
    LabelM2Money: TbsSkinStdLabel;
    bsSkinStdLabel9: TbsSkinStdLabel;
    bsSkinMemo2: TbsSkinMemo;
    MemoUrl: TMemo;
    FrmGoods: TFrameGoods;
    ApplicationEvents: TApplicationEvents;
    CompressedSkinList: TbsCompressedSkinList;
    S1: TMenuItem;
    Win71: TMenuItem;
    SelectSkinDialog: TbsSelectSkinDialog;
    TextDialog: TbsSkinTextDialog;
    FrmLSetup: TFrameLSetup;
    FrmMakeLogin: TFrameMakeLogin;
    OpenPictureDialog: TbsSkinOpenPictureDialog;
    SaveDialog: TbsSkinSaveDialog;
    FrmTools: TFrameTools;
    InputDialog: TbsSkinInputDialog;
    CSocket: TClientSocket;
    tmrStartTimer: TTimer;
    RP: TRSA;
    KeepTimer: TTimer;
    LabelUpLog: TbsSkinTextLabel;
    FrmAddLogin: TFrameAddLogin;
    FrmAddM2: TFrameAddM2;
    FrmChangePass: TFrameChangePass;
    FrmDownM2: TFrameDownM2;
    FrmDownLogin: TFrameDownLogin;
    DownTimer: TTimer;
    DownLoginTimer: TTimer;
    bsSkinStdLabel2: TbsSkinStdLabel;
    LabelResetCount: TbsSkinStdLabel;
    FrmBindTool: TFrameBindTool;
    EDTimer: TTimer;
    FrmRPGView: TFrameRPGView;
    ColorDialog: TbsSkinColorDialog;
    ButtonOfflinLogin: TbsSkinButton;
    GroupBoxOfflineLeft: TbsSkinGroupBox;
    bsSkinVistaGlowLabel3: TbsSkinVistaGlowLabel;
    ButtonsBarLeft11: TbsSkinButtonsBar;
    FrmShare: TFrameShare;
    ToolSocket: TClientSocket;
    ToolTimer: TTimer;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure EditPassword2Change(Sender: TObject);
    procedure MAINMENU_SOFT_EXITClick(Sender: TObject);
    procedure ButtonsBarLeftSections1Items1Click(Sender: TObject);
    procedure ButtonsBarLeftSections1Items2Click(Sender: TObject);
    procedure ApplicationEventsException(Sender: TObject; E: Exception);
    procedure Win71Click(Sender: TObject);
    procedure ButtonsBarLeftSections1Items0Click(Sender: TObject);
    procedure ButtonsBarLeftSections1Items4Click(Sender: TObject);
    procedure ButtonsBarLeftSections1Items3Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure tmrStartTimerTimer(Sender: TObject);
    procedure CSocketConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure CSocketDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure CSocketError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure KeepTimerTimer(Sender: TObject);
    procedure CSocketRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure ButtonLoginClick(Sender: TObject);
    procedure EditPasswordChange(Sender: TObject);
    procedure ComboBoxNameKeyPress(Sender: TObject; var Key: Char);
    procedure MAINMENU_HELP_UPLOGClick(Sender: TObject);
    procedure ButtonsBarAgentSections0Items0Click(Sender: TObject);
    procedure ButtonsBarAgentSections0Items1Click(Sender: TObject);
    procedure ButtonsBarAgentSections0Items2Click(Sender: TObject);
    procedure ButtonsBarAgentSections0Items3Click(Sender: TObject);
    procedure MAINMENU_HELP_HOMEClick(Sender: TObject);
    procedure MAINMENU_SOFT_CHANGEPASSWORDClick(Sender: TObject);
    procedure ButtonsBarLeftSections0Items0Click(Sender: TObject);
    procedure ButtonsBarLeftSections0Items1Click(Sender: TObject);
    procedure ComboBoxNameChange(Sender: TObject);
    procedure DownTimerTimer(Sender: TObject);
    procedure DownLoginTimerTimer(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure ButtonsBarLeftSections2Items0Click(Sender: TObject);
    procedure ButtonsBarLeftSections2Items1Click(Sender: TObject);
    procedure EDTimerTimer(Sender: TObject);
    procedure ButtonsBarLeftSections1Items5Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ButtonOfflinLoginClick(Sender: TObject);
    procedure ButtonsBarLeftSections3Items0Click(Sender: TObject);
    procedure ToolTimerTimer(Sender: TObject);
    procedure ToolSocketError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure ToolSocketConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure ToolSocketRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure ToolSocketDisconnect(Sender: TObject; Socket: TCustomWinSocket);
  private
    FSocketStr: string;
    FSocketReadStr: string;
    FSocketToolReadStr: string;
    FSocketToolStr: string;
    FPassword: string;
    FAccount: string;
    DefMsg: TDefaultMessage;
    FFileMD5: string;
    FFileName: string;
    FboFrist: Boolean;
    procedure InitFrame();
    procedure UnInitFrame();
    procedure CloseAllFrame();
    procedure ChangeLoginState(boLogin: Boolean);
    procedure ToolsLoginOK(sData: string);
    procedure GetDownListInfo(Msg: pTDefaultMessage; sBody: string);
    procedure SaveFileData(Msg: TDefaultMessage; sData: string; boLogin: Boolean);
    procedure DownFileOk(boLogin: Boolean);
    procedure WriteLogin(sLoginFile, sSkinFile: string);
    procedure ChangeSkinIndex(nIndex: Integer);
    procedure EDSocket();
    procedure EDToolSocket();
  public
    m_GameName: string;
    m_SkinName: string;
    m_DownUrl: string;
    procedure ShowHint(sHint: string);
    procedure ShowProgress(nProgress: Integer);
    procedure Lock(boLock: Boolean);
    procedure SendSocket(sSendStr: string);
    function SendToolSocket(sSendStr: string): Boolean;
    procedure GetInfo(sData: string);
    procedure MyUpdate(var message: TMessage); message WM_UPDATEMSG;
  end;

var
  FormMain: TFormMain;

implementation

uses FrmEditServer, FrmEditUpData, MD5Unit, Share, FrmUpdate, FrmRPGDelete, FrmRPGOut, FrmRPGAppend;

{$R *.dfm}
{$R ColorTable.RES}
{$R FileBmp.res}

procedure TFormMain.MAINMENU_HELP_HOMEClick(Sender: TObject);
begin
  ShellExecute(Handle, 'Open', 'http://www.361m2.com', '', '', SW_SHOW);
end;

procedure TFormMain.MAINMENU_HELP_UPLOGClick(Sender: TObject);
begin
  CloseAllFrame;
  LabelUpLog.Visible := True;
end;

procedure TFormMain.MAINMENU_SOFT_CHANGEPASSWORDClick(Sender: TObject);
begin
  CloseAllFrame;
  FrmChangePass.Open();
  FrmChangePass.Visible := True;
  FrmChangePass.EditOldPassword.SetFocus;
end;

procedure TFormMain.MAINMENU_SOFT_EXITClick(Sender: TObject);
begin
  Close;
end;

procedure TFormMain.MyUpdate(var message: TMessage);
begin
  if DMsg.MessageDlg('程序有新的版本，是否现在更新？', mtConfirmation, [mbYes, mbNo], 0) = mrYes then begin
    Hide;
    FormUpdate.Open(m_DownUrl);
    Application.Terminate;
  end;
end;

procedure TFormMain.SaveFileData(Msg: TDefaultMessage; sData: string; boLogin: Boolean);
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
      DeleteFile(g_CurrentDir + DOWNDIRNAME + '\' + FFileName);
    end;
    if boLogin then DefMsg := MakeDefaultMsg(CM_GETDOWNDATA, SM_DOWNLOGINEXE_DATA, 0, 0, 0)
    else DefMsg := MakeDefaultMsg(CM_GETDOWNDATA, SM_DOWNM2SERVER_DATA, 0, 0, 0);
    SendSocket(EncodeMessage(DefMsg));
  end else begin
//    nPar := 0;
    sFileName := g_CurrentDir + DOWNDIRNAME + '\' + FFileName;
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
      ShowProgress(nPar);
    Finally
      FileStream.Free;
      FreeMem(Buffer);
    End;
    if boDownOK then begin
      ShowHint('正在效验文件...');
      if FileToMD5Text(sFileName) = FFileMD5 then begin
        //ShowHint('下载完成，保存在[' + sFileName + ']');
        DownFileOk(boLogin);
      end else begin
        ShowHint('文件效验失败，请重新下载...');
        if boLogin then begin
          Lock(False);
          FrmDownLogin.ButtonAdd.Enabled := True;
          FrmDownLogin.EditName.Enabled := True;
          FrmDownLogin.EditSkinFile.Enabled := True;
        end else begin
          Lock(False);
          FrmDownM2.ButtonAdd.Enabled := True;
        end;
      end;

      //ListView1.Enabled := True;
    end else begin
      ShowHint('正在下载，已完成 ' + IntToStr(nPar) + '%');
      if boLogin then DefMsg := MakeDefaultMsg(CM_GETDOWNDATA, SM_DOWNLOGINEXE_DATA, 0, 0, 0)
      else DefMsg := MakeDefaultMsg(CM_GETDOWNDATA, SM_DOWNM2SERVER_DATA, 0, 0, 0);
      SendSocket(EncodeMessage(DefMsg));
    end;
  end;
end;

procedure TFormMain.SendSocket(sSendStr: string);
begin
  CSocket.Socket.SendText(g_CodeHead + sSendStr + g_CodeEnd);
end;

function TFormMain.SendToolSocket(sSendStr: string): Boolean;
var
  sStr: string;
  nIndex: Integer;
begin
  Result := False;
  sStr := g_CodeHead + sSendStr + g_CodeEnd;
  nIndex := 0;
  while True do begin
    if ((nIndex mod 10) = 0) and (ToolSocket.Socket.SendText(sStr) <> -1) then begin
      Result := True;
      break;
    end;
    Inc(nIndex);
    Sleep(10);
    Application.ProcessMessages;
    if nIndex > 10000 then break;
  end;
end;

procedure TFormMain.ShowHint(sHint: string);
begin
  PanelLog.Caption := sHint;
end;

procedure TFormMain.ShowProgress(nProgress: Integer);
begin
  if nProgress > 100 then nProgress := 100;
  if nProgress < 0 then nProgress := 0;
  if nProgress <> GaugeMain.Value then begin
    GaugeMain.Value := nProgress;
    GaugeMain.ShowPercent := nProgress > 0;
  end;
end;

procedure TFormMain.EDTimerTimer(Sender: TObject);
begin
  EDSocket;
  EDToolSocket;
end;

procedure TFormMain.EDToolSocket;
var
  msg: TDefaultMessage;
  sData, head, body: string;
begin
  FSocketToolStr := FSocketToolStr + FSocketToolReadStr;
  FSocketToolReadStr := '';
  while FSocketToolStr <> '' do begin
    if Pos('!', FSocketToolStr) <= 0 then break;
    FSocketToolStr := ArrestStringEx(FSocketToolStr, '#', '!', sData);
    if Length(sData) >= DEFBLOCKSIZE then begin
      head := Copy(sData, 1, DEFBLOCKSIZE);
      body := Copy(sData, DEFBLOCKSIZE + 1, Length(sData) - DEFBLOCKSIZE);
      msg := DecodeMessage(head);
      case Msg.Ident of
        SM_SETTOOLMARK: begin
            DefMsg := MakeDefaultMsg(CM_TOOLS_SENDMARK, 0, 0, 0, 0);
            SendSocket(EncodeMessage(DefMsg) + body);
          end;
        SM_SHARE_LOGON_OK: g_boToolConnect := True;
        SM_SHARE_UPLOADFILE_BACK: begin
            if Msg.Recog = 1 then begin
              ShowHint('文件上传成功...');
              FrmShare.SendGetList();
            end
            else ShowHint('文件上传失败，效验失败...');
          end;
        SM_SHARE_FILELIST: FrmShare.GetFileList(Msg.Series, Msg.Recog = 1, body);
        SM_SHARE_DOWNFILE_FAIL: begin
            Lock(False);
            FrmShare.GroupBoxBg.Enabled := True;
            ShowHint(DecodeString(body));
            DMsg.MessageDlg(DecodeString(body), mtError, [mbYes], 0);
          end;
        SM_SHARE_DOWNFILE_DATA: FrmShare.GetFileData(Msg.Recog, MakeLong(Msg.Param, Msg.tag), Msg.Series, body);
      end;
    end;
  end;
end;

procedure TFormMain.KeepTimerTimer(Sender: TObject);
begin
  CSocket.Socket.SendText('*');
end;

procedure TFormMain.tmrStartTimerTimer(Sender: TObject);
begin
  ShowHint('正在连接服务器...');
  tmrStartTimer.Enabled := False;
  CSocket.Active := True;
end;

procedure TFormMain.ToolsLoginOK(sData: string);
var
  sInfo, sUrl: string;
  NewLoginInfo: TNewLoginInfo;
  LoginInfo: TLoginInfo;
  nIdx: Integer;
begin
  sUrl := GetValidStr3(sData, sInfo, ['/']);
  FillChar(LoginInfo, SizeOf(LoginInfo), #0);
  DecodeBuffer(sInfo, @NewLoginInfo, SizeOf(NewLoginInfo));
  LoginInfo := NewLoginInfo.LoginInfo;
  g_PackPassword := NewLoginInfo.sPackPassword;
  if not g_boLogin then begin
    GroupBoxLogin.Visible := False;
    ShowHint('登录成功...');
    ChangeLoginState(False);
    g_boLogin := True;
    nIdx := ComboBoxName.Items.IndexOf(FAccount);
    if nIdx > -1 then begin
      ComboBoxName.Items.Delete(nIdx);
    end;
    ComboBoxName.Items.Insert(0, FAccount);
    ComboBoxName.ItemIndex := 0;
    g_Config.WriteString('Default', 'Account', FAccount);
    if CheckBoxSaveName.Checked then g_Config.WriteString('Account', FAccount, FPassword)
    else g_Config.WriteString('Account', FAccount, '');
 
    if LoginInfo.boAgent then begin
      GroupBoxAgentName.Caption := FAccount;
      GroupBoxAgentLeft.Visible := True;
      LabelMoney.Caption := '￥' + IntToStr(LoginInfo.nMoney);
      LabelLoginMoney.Caption := '￥' + IntToStr(LoginInfo.nAgentLogin);
      LabelM2Money.Caption := '￥' + IntToStr(LoginInfo.nAgentM2);
      g_nAgentLogin := LoginInfo.nAgentLogin;
      g_nAgentM2 := LoginInfo.nAgentM2;
    end else begin
      g_Config.WriteString('Offline', FAccount, UpperCase(GetMD5Text(GetIdeSerialNumber + GetCpuID + UpperCase(FAccount))));
      GroupBoxUserName.Caption := FAccount;
      sUrl := DecodeString(sUrl);
      GroupBoxUserLeft.Visible := True;
      MemoUrl.Lines.SetText(PChar(sUrl));
      LabelBindCount.Caption := IntToStr(LoginInfo.nBindCount);
      LabelResetCount.Caption := IntToStr(NewLoginInfo.nResetCount);
      DefMsg := MakeDefaultMsg(CM_GETDOWNLIST, 0, 0, 0, 0);
      SendSocket(EncodeMessage(DefMsg));
      ToolTimer.Interval := 500;
      ToolTimer.Enabled := True;
    end;
    LabelUpLog.Visible := True;
  end else begin
    ShowHint('重新登录成功...');
    if LoginInfo.boAgent then begin
      LabelMoney.Caption := '￥' + IntToStr(LoginInfo.nMoney);
      LabelLoginMoney.Caption := '￥' + IntToStr(LoginInfo.nAgentLogin);
      LabelM2Money.Caption := '￥' + IntToStr(LoginInfo.nAgentM2);
      g_nAgentLogin := LoginInfo.nAgentLogin;
      g_nAgentM2 := LoginInfo.nAgentM2;
    end else begin
      GroupBoxUserName.Caption := FAccount;
      sUrl := DecodeString(sUrl);
      MemoUrl.Lines.SetText(PChar(sUrl));
      LabelBindCount.Caption := IntToStr(LoginInfo.nBindCount);
      ToolTimer.Interval := 500;
      ToolTimer.Enabled := True;
    end;
  end;
end;

procedure TFormMain.ToolSocketConnect(Sender: TObject; Socket: TCustomWinSocket);
var
  DefMsg: TDefaultMessage;
begin
  g_boToolConnect := False;
  FSocketToolReadStr := '';
  FSocketToolStr := '';
  DefMsg := MakeDefaultMsg(CM_TOOLS_GETSHAREPASS, 0, 0, 0, 0);
  SendToolSocket(EncodeMessage(DefMsg));
end;

procedure TFormMain.ToolSocketDisconnect(Sender: TObject; Socket: TCustomWinSocket);
begin
  g_boToolConnect := False;
  FSocketToolReadStr := '';
  FSocketToolStr := '';
  ToolTimer.Interval := 10 * 1000;
  ToolTimer.Enabled := True;
end;

procedure TFormMain.ToolSocketError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
  g_boToolConnect := False;
  ErrorCode := 0;
  Socket.Close;
  ToolTimer.Interval := 10 * 1000;
  ToolTimer.Enabled := True;
end;

procedure TFormMain.ToolSocketRead(Sender: TObject; Socket: TCustomWinSocket);
begin
  FSocketToolReadStr := FSocketToolReadStr + Socket.ReceiveText;
end;

procedure TFormMain.ToolTimerTimer(Sender: TObject);
begin
  if g_boConnect and g_boLogin then begin
    ToolTimer.Enabled := False;
    ToolSocket.Active := True;
  end;
end;

procedure TFormMain.UnInitFrame;
begin
  FrmRPGView.UnInit();
  FrmShare.UnInit();
end;

procedure TFormMain.Win71Click(Sender: TObject);
begin
  if SelectSkinDialog.Execute(DSkinData.SkinIndex) then begin
    FrmRPGView.Finalize;
    Try
      ChangeSkinIndex(SelectSkinDialog.SelectedSkinIndex);
    Finally
      FrmRPGView.Initialize;
    End;
    g_Config.WriteInteger('Default', 'SkinIndex', SelectSkinDialog.SelectedSkinIndex);
  end;
end;

procedure TFormMain.WriteLogin(sLoginFile, sSkinFile: string);
var
  boOK: Boolean;
  sSaveFile: string;
  LoginStream, SkinStream, SaveStream: TFileStream;
  SkinBottom: TLoginSkinBottom;
begin
  boOK := False;
  if FileExists(sLoginFile) and FileExists(sSkinFile) then begin
    sSaveFile := sLoginFile + '.exe';
    DeleteFile(sSaveFile);
    LoginStream := TFileStream.Create(sLoginFile, fmOpenRead);
    SkinStream := TFileStream.Create(sSkinFile, fmOpenRead);
    SaveStream := TFileStream.Create(sSaveFile, fmCreate);
    try
      SkinBottom.sTitle[0] := '3';
      SkinBottom.sTitle[1] := '6';
      SkinBottom.sTitle[2] := '1';
      SkinBottom.nSize := SkinStream.Size;
      SKinBottom.nOffset := LoginStream.Size;
      SaveStream.CopyFrom(LoginStream, 0);
      SaveStream.CopyFrom(SkinStream, 0);
      SaveStream.Write(SkinBottom, SizeOf(SkinBottom));
      boOK := True;
    finally
      LoginStream.Free;
      SkinStream.Free;
      SaveStream.Free;
    end;
  end;
  if boOK then begin
    ShowHint('生成完成，保存在[' + sSaveFile + ']');
  end else
    ShowHint('合并皮肤生成登录器失败...');
  Lock(False);
  FrmDownLogin.ButtonAdd.Enabled := True;
  FrmDownLogin.EditName.Enabled := True;
  FrmDownLogin.EditSkinFile.Enabled := True;
end;

procedure TFormMain.InitFrame;
begin
  FrmHeQu.Align := alClient;
  FrmHeQu.Visible := False;

  FrmGoods.Align := alClient;
  FrmGoods.Visible := False;

  FrmLSetup.Align := alClient;
  FrmLSetup.Visible := False;

  FrmMakeLogin.Align := alClient;
  FrmMakeLogin.Visible := False;

  FrmTools.Align := alClient;
  FrmTools.Visible := False;

  FrmAddLogin.Align := alClient;
  FrmAddLogin.Visible := False;

  FrmAddM2.Align := alClient;
  FrmAddM2.Visible := False;

  FrmChangePass.Align := AlClient;
  FrmChangePass.Visible := False;

  FrmDownM2.Align := AlClient;
  FrmDownM2.Visible := False;

  FrmDownLogin.Align := AlClient;
  FrmDownLogin.Visible := False;

  FrmBindTool.Align := AlClient;
  FrmBindTool.Visible := False;

  FrmRPGView.Align := alClient;
  FrmRPGView.Visible := False;

  FrmShare.Align := alClient;
  FrmShare.Visible := False;
  FrmShare.DBPageControl.TabIndex := 0;
  FrmShare.FOpenIndex := -1;

  FrmHeQu.DSkinData.SkinList := CompressedSkinList;
  FrmHeQu.DSkinData.SkinList := CompressedSkinList;
  FrmGoods.DSkinData.SkinList := CompressedSkinList;
  FrmLSetup.DSkinData.SkinList := CompressedSkinList;
  FrmMakeLogin.DSkinData.SkinList := CompressedSkinList;
  FrmTools.DSkinData.SkinList := CompressedSkinList;
  //FormEditServer.DSkinData.SkinList := CompressedSkinList;
  //FormEditUpData.DSkinData.SkinList := CompressedSkinList;
  FrmAddLogin.DSkinData.SkinList := CompressedSkinList;
  FrmAddM2.DSkinData.SkinList := CompressedSkinList;
  FrmChangePass.DSkinData.SkinList := CompressedSkinList;
  FrmDownM2.DSkinData.SkinList := CompressedSkinList;
  FrmDownLogin.DSkinData.SkinList := CompressedSkinList;
  FrmBindTool.DSkinData.SkinList := CompressedSkinList;
  //FormUpdate.DSkinData.SkinList := CompressedSkinList;
  FrmRPGView.DSkinData.SkinList := CompressedSkinList;
  FrmShare.DSkinData.SkinList := CompressedSkinList;
  FrmRPGView.BGColor.ColorDialog := ColorDialog;
  FrmRPGView.BlendColor.ColorDialog := ColorDialog;
  FrmShare.ListViewAdmin.SmallImages := ImageListMinIcon;
  FrmShare.ListViewUser.SmallImages := ImageListMinIcon;
  FrmRPGView.Init();
  FrmShare.Init();
end;

procedure TFormMain.Lock(boLock: Boolean);
begin
  GroupBoxAgentLeft.Enabled := not boLock;
  GroupBoxUserLeft.Enabled := not boLock;
  MAINMENU_SOFT_CHANGEPASSWORD.Enabled := not boLock and not g_boOfflineLogin;
  MAINMENU_HELP_UPLOG.Enabled := not boLock and not g_boOfflineLogin;
end;

procedure TFormMain.ApplicationEventsException(Sender: TObject; E: Exception);
begin
  DMsg.MessageDlg(E.Message, mtError, [mbOK], 0);
end;

procedure TFormMain.ButtonLoginClick(Sender: TObject);
var
  sName, sPass: string;
  DefMsg: TDefaultMessage;
begin
  sName := Trim(ComboBoxName.Text);
  sPass := FPassword;
  if sName = '' then begin
    DMsg.MessageDlg('帐号不能为空！', mtError, [mbYes], 0);
    ComboBoxName.SetFocus;
    Exit;
  end;
  if not CheckEMailRule(sName) then begin
    DMsg.MessageDlg('帐号格式不正确！', mtError, [mbYes], 0);
    ComboBoxName.SetFocus;
    Exit;
  end;
  if sPass = '' then begin
    DMsg.MessageDlg('密码不能为空！', mtError, [mbYes], 0);
    EditPassword.SetFocus;
    Exit;
  end;
  FAccount := sName;
  ButtonLogin.Enabled := False;
  ComboBoxName.Enabled := False;
  EditPassword.Enabled := False;
  CheckBoxSaveName.Enabled := False;
  ShowHint('正在验证帐户信息...');
  g_nLoginMark := Random(80000000) + 10000000;
  DefMsg := MakeDefaultMsg(CM_NEWTOOLS_LOGIN, VAR_22, 0, 0, 0);
  SendSocket(EncodeMessage(DefMsg) + RP.EncryptStr(sName + '/' + sPass + '/' + IntToStr(g_nLoginMark)));
end;

procedure TFormMain.ButtonOfflinLoginClick(Sender: TObject);
begin
  //if g_boCanOfflineLogin then begin
    g_PackPassword := '';
    g_boLogin := True;
    g_boOfflineLogin := True;
    CSocket.Close;
    KeepTimer.Enabled := False;
    EDTimer.Enabled := False;
    tmrStartTimer.Enabled := False;
    GroupBoxLogin.Visible := False;
    ChangeLoginState(False);
    GroupBoxUserLeft.Visible := False;
    GroupBoxAgentLeft.Visible := False;
    MAINMENU_SOFT_CHANGEPASSWORD.Enabled := False;
    MAINMENU_HELP_UPLOG.Enabled := False;
    GroupBoxOfflineLeft.Visible := True;
    ShowHint('部份功能需登录才能正常使用，现已隐藏...');
 { end else begin
    DMsg.MessageDlg('正常登录一次后，既可使用当前帐号离线登录！', mtError, [mbYes], 0);
  end;       }
end;

procedure TFormMain.ButtonsBarAgentSections0Items0Click(Sender: TObject);
begin
  CloseAllFrame;
  FrmAddLogin.Open();
  FrmAddLogin.Visible := True;
  FrmAddLogin.EditName.SetFocus;
end;

procedure TFormMain.ButtonsBarAgentSections0Items1Click(Sender: TObject);
begin
  CloseAllFrame;
  FrmAddM2.Open();
  FrmAddM2.Visible := True;
  FrmAddM2.EditName.SetFocus;
end;

procedure TFormMain.ButtonsBarAgentSections0Items2Click(Sender: TObject);
begin
  //
end;

procedure TFormMain.ButtonsBarAgentSections0Items3Click(Sender: TObject);
begin
  //
end;

procedure TFormMain.ButtonsBarLeftSections0Items0Click(Sender: TObject);
begin
  CloseAllFrame;
  FrmDownM2.Visible := True;
end;

procedure TFormMain.ButtonsBarLeftSections0Items1Click(Sender: TObject);
begin
  CloseAllFrame;
  FrmDownLogin.Open();
  FrmDownLogin.Visible := True;
  FrmDownLogin.EditName.SetFocus;
end;

procedure TFormMain.ButtonsBarLeftSections1Items0Click(Sender: TObject);
begin
  CloseAllFrame;
  {FrmLSetup.Open;
  FrmLSetup.Visible := True;}
  FrmMakeLogin.Open;
  FrmMakeLogin.Visible := True;
end;

procedure TFormMain.ButtonsBarLeftSections1Items1Click(Sender: TObject);
begin
  CloseAllFrame;
  FrmLSetup.Open;
  FrmLSetup.Visible := True;
end;

procedure TFormMain.ButtonsBarLeftSections1Items2Click(Sender: TObject);
begin
  CloseAllFrame;
  FrmHeQu.Visible := True;
end;

procedure TFormMain.ButtonsBarLeftSections1Items3Click(Sender: TObject);
begin
  CloseAllFrame;
  FrmGoods.Open;
  FrmGoods.Visible := True;
end;

procedure TFormMain.ButtonsBarLeftSections1Items4Click(Sender: TObject);
begin
  DForm.WindowState := wsMaximized;
  CloseAllFrame;
  FrmRPGView.Open;
  FrmRPGView.Visible := True;
end;

procedure TFormMain.ButtonsBarLeftSections1Items5Click(Sender: TObject);
begin
  CloseAllFrame;
  FrmTools.Open;
  FrmTools.Visible := True;
end;

procedure TFormMain.ButtonsBarLeftSections2Items0Click(Sender: TObject);
begin
  CloseAllFrame;
  FrmChangePass.Open();
  FrmChangePass.Visible := True;
  FrmChangePass.EditOldPassword.SetFocus;
end;

procedure TFormMain.ButtonsBarLeftSections2Items1Click(Sender: TObject);
begin
  CloseAllFrame;
  FrmBindTool.Open();
  FrmBindTool.Visible := True;
end;

procedure TFormMain.ButtonsBarLeftSections3Items0Click(Sender: TObject);
begin
  CloseAllFrame;
  FrmShare.Open((Sender as TbsButtonBarItem).Tag);
  FrmShare.Visible := True;
end;

procedure TFormMain.ChangeLoginState(boLogin: Boolean);
begin
  if boLogin then begin
    CloseAllFrame;
    GroupBoxUserLeft.Visible := False;
    GroupBoxAgentLeft.Visible := False;
    ButtonLogin.Enabled := True;
    ComboBoxName.Enabled := True;
    EditPassword.Enabled := True;
    CheckBoxSaveName.Enabled := True;
    GroupBoxLogin.Visible := True;
    ButtonLogin.Enabled := False;
    MAINMENU_SOFT_CHANGEPASSWORD.Enabled := False;
    MAINMENU_HELP_UPLOG.Enabled := False;
  end else begin
    GroupBoxLogin.Visible := False;
    MAINMENU_SOFT_CHANGEPASSWORD.Enabled := True;
    MAINMENU_HELP_UPLOG.Enabled := True;
  end;
end;

procedure TFormMain.ChangeSkinIndex(nIndex: Integer);
begin
  DragFinish(FrmTools.GroupBoxMD5.Handle);
  DragFinish(FormEditUpData.GroupBoxMD5.Handle);
  Try
    if nIndex in [0..CompressedSkinList.Skins.Count - 1] then begin
      DSkinData.SkinIndex := nIndex;
      FrmHeQu.DSkinData.SkinIndex := nIndex;
      FrmGoods.DSkinData.SkinIndex := nIndex;
      FrmLSetup.DSkinData.SkinIndex := nIndex;
      FrmMakeLogin.DSkinData.SkinIndex := nIndex;
      FrmTools.DSkinData.SkinIndex := nIndex;
      FormEditServer.DSkinData.SkinIndex := nIndex;
      FormEditUpData.DSkinData.SkinIndex := nIndex;
      FrmAddLogin.DSkinData.SkinIndex := nIndex;
      FrmAddM2.DSkinData.SkinIndex := nIndex;
      FrmChangePass.DSkinData.SkinIndex := nIndex;
      FrmDownM2.DSkinData.SkinIndex := nIndex;
      FrmDownLogin.DSkinData.SkinIndex := nIndex;
      FrmBindTool.DSkinData.SkinIndex := nIndex;
      FormUpdate.DSkinData.SkinIndex := nIndex;
      FrmRPGView.DSkinData.SkinIndex := nIndex;
      FormRPGDelete.DSkinData.SkinIndex := nIndex;
      FormRPGOut.DSkinData.SkinIndex := nIndex;
      FormRPGAppend.DSkinData.SkinIndex := nIndex;
      FrmShare.DSkinData.SkinIndex := nIndex;
    end else begin
      DSkinData.SkinIndex := 0;
      FrmHeQu.DSkinData.SkinIndex := 0;
      FrmGoods.DSkinData.SkinIndex := 0;
      FrmLSetup.DSkinData.SkinIndex := 0;
      FrmMakeLogin.DSkinData.SkinIndex := 0;
      FrmTools.DSkinData.SkinIndex := 0;
      FormEditServer.DSkinData.SkinIndex := 0;
      FormEditUpData.DSkinData.SkinIndex := 0;
      FrmAddLogin.DSkinData.SkinIndex := 0;
      FrmAddM2.DSkinData.SkinIndex := 0;
      FrmChangePass.DSkinData.SkinIndex := 0;
      FrmDownM2.DSkinData.SkinIndex := 0;
      FrmDownLogin.DSkinData.SkinIndex := 0;
      FrmBindTool.DSkinData.SkinIndex := 0;
      FormUpdate.DSkinData.SkinIndex := 0;
      FrmRPGView.DSkinData.SkinIndex := 0;
      FormRPGDelete.DSkinData.SkinIndex := 0;
      FormRPGOut.DSkinData.SkinIndex := 0;
      FormRPGAppend.DSkinData.SkinIndex := 0;
      FrmShare.DSkinData.SkinIndex := 0;
    end;
  Finally
    DragAcceptFiles(FrmTools.GroupBoxMD5.Handle, True);
    DragAcceptFiles(FormEditUpData.GroupBoxMD5.Handle, True);
  End;
end;

procedure TFormMain.CloseAllFrame;
begin
  FrmRPGView.Close;
  FrmShare.Close;
  FrmHeQu.Visible := False;
  FrmGoods.Visible := False;
  FrmLSetup.Visible := False;
  FrmMakeLogin.Visible := False;
  FrmTools.Visible := False;
  LabelUpLog.Visible := False;
  FrmAddLogin.Visible := False;
  FrmAddM2.Visible := False;
  FrmChangePass.Visible := False;
  FrmDownM2.Visible := False;
  FrmDownLogin.Visible := False;
  FrmBindTool.Visible := False;
  FrmRPGView.Visible := False;
  FrmShare.Visible := False;
end;

procedure TFormMain.ComboBoxNameChange(Sender: TObject);
begin
  if ComboBoxName.Text <> '' then begin
    //EditPassword.Text := g_Config.ReadString('Account', ComboBoxName.Text, '');
    FPassword := g_Config.ReadString('Account', ComboBoxName.Text, '');
    CheckBoxSaveName.Checked := FPassword <> '';
    if CheckBoxSaveName.Checked then begin
      EditPassword.Text := '000000';
      FPassword := g_Config.ReadString('Account', ComboBoxName.Text, '');
    end else EditPassword.Text := '';
    g_boCanOfflineLogin := (UpperCase(GetMD5Text(GetIdeSerialNumber + GetCpuID + UpperCase(ComboBoxName.Text))) = g_Config.ReadString('Offline', ComboBoxName.Text, ''));
    ButtonOfflinLogin.Enabled := g_boCanOfflineLogin;
  end;
end;

procedure TFormMain.ComboBoxNameKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then begin
    ButtonLoginClick(ButtonLogin);
  end;
end;

procedure TFormMain.CSocketConnect(Sender: TObject; Socket: TCustomWinSocket);
var
  DefMsg: TDefaultMessage;
begin
  ShowHint('请先登录...');
  ButtonLogin.Enabled := True;
  FSocketStr := '';
  FSocketReadStr := '';
  SendSocket('+');
  g_boConnect := True;
  KeepTimer.Enabled := True;
  EDTimer.Enabled := True;
  if g_boLogin then begin
    ShowHint('正在重新登录...');
    DefMsg := MakeDefaultMsg(CM_NEWTOOLS_LOGIN, VAR_22, 0, 0, 0);
    SendSocket(EncodeMessage(DefMsg) + RP.EncryptStr(FAccount + '/' + FPassword + '/' + IntToStr(g_nLoginMark)));
  end else begin
    DefMsg := MakeDefaultMsg(CM_CHECKUPDATE, VAR_22, 0, 0, 0);
    SendSocket(EncodeMessage(DefMsg));
  end;
end;

procedure TFormMain.CSocketDisconnect(Sender: TObject; Socket: TCustomWinSocket);
begin
  FSocketStr := '';
  FSocketReadStr := '';
  g_boConnect := False;
  ToolSocket.Close;
  if not g_boOfflineLogin then begin
    ShowHint('与服务器断开连接，10秒钟后将重试连接...');
    KeepTimer.Enabled := False;
    EDTimer.Enabled := False;
    //ChangeLoginState(True);
    tmrStartTimer.Interval := 10 * 1000;
    tmrStartTimer.Enabled := True;
  end;
end;

procedure TFormMain.CSocketError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
  ErrorCode := 0;
  FSocketStr := '';
  Socket.Close;
  if not g_boOfflineLogin then begin
    ShowHint('连接服务器失败，10秒钟后将重试连接...');
    tmrStartTimer.Interval := 10 * 1000;
    tmrStartTimer.Enabled := True;
  end;
end;

procedure TFormMain.CSocketRead(Sender: TObject; Socket: TCustomWinSocket);
begin
  FSocketReadStr := FSocketReadStr + Socket.ReceiveText;
end;

procedure TFormMain.DownFileOk(boLogin: Boolean);
begin
  if boLogin then begin
    ShowHint('下载完成，正在准备合并皮肤生成登录器，请稍候...');
    WriteLogin(g_CurrentDir + DOWNDIRNAME + '\' + m_GameName, m_SkinName);
  end else begin
    ShowHint('下载完成，保存在[' + g_CurrentDir + DOWNDIRNAME + '\M2Server.exe]');
    Lock(False);
    FrmDownM2.ButtonAdd.Enabled := True;
  end;
end;

procedure TFormMain.DownLoginTimerTimer(Sender: TObject);
begin
  DownLoginTimer.Enabled := False;
  DefMsg := MakeDefaultMsg(CM_DOWNLOGINEXE, 0, 0, 0, 0);
  SendSocket(EncodeMessage(DefMsg) + EncodeString(m_GameName));
end;

procedure TFormMain.DownTimerTimer(Sender: TObject);
begin
  DownTimer.Enabled := False;
  DefMsg := MakeDefaultMsg(CM_DOWNM2SERVER_NEW, 0, 0, 0, 0);
  SendSocket(EncodeMessage(DefMsg));
end;

procedure TFormMain.EditPassword2Change(Sender: TObject);
begin
  Caption := EditPassword.Text;
end;

procedure TFormMain.EditPasswordChange(Sender: TObject);
begin
  if EditPassword.Text <> '' then FPassword := GetMD5Text(EditPassword.Text)
  else FPassword := '';
end;

procedure TFormMain.EDSocket;
var
  msg: TDefaultMessage;
  sData, head, body: string;
begin
  FSocketStr := FSocketStr + FSocketReadStr;
  FSocketReadStr := '';
  while FSocketStr <> '' do begin
    if Pos('!', FSocketStr) <= 0 then break;
    FSocketStr := ArrestStringEx(FSocketStr, '#', '!', sData);
    if Length(sData) >= DEFBLOCKSIZE then begin
      head := Copy(sData, 1, DEFBLOCKSIZE);
      body := Copy(sData, DEFBLOCKSIZE + 1, Length(sData) - DEFBLOCKSIZE);
      msg := DecodeMessage(head);
      case Msg.Ident of
        SM_NEWTOOLS_LOGIN_FAIL: begin
            DMsg.MessageDlg(DecodeString(body), mtError, [mbYes], 0);
            ButtonLogin.Enabled := True;
            ComboBoxName.Enabled := True;
            EditPassword.Enabled := True;
            CheckBoxSaveName.Enabled := True;
            EditPassword.SetFocus;
            ShowHint(DecodeString(body));
          end;
        SM_NEWTOOLS_LOGIN_OK: begin
            if Msg.Recog = g_nLoginMark then begin
              ToolsLoginOK(body);
            end;
          end;
        SM_TOOLS_LOGS: begin
            LabelUpLog.Lines.SetText(PChar(DecodeString(body)));
          end;
        SM_TOOLS_REGLOGIN_FAIL: begin
            DMsg.MessageDlg(DecodeString(body), mtError, [mbYes], 0);
            Lock(False);
            FrmAddLogin.ButtonAdd.Enabled := True;
            FrmAddLogin.EditName.Enabled := True;
            FrmAddLogin.EditQQ.Enabled := True;
            FrmAddLogin.EditBindList.Enabled := True;
            FrmAddLogin.EditName.SetFocus;
            ShowHint(DecodeString(body));
          end;
        SM_TOOLS_REGLOGIN_OK: begin
            DMsg.MessageDlg('恭喜你，帐号创建成功！', mtInformation, [mbYes], 0);
            LabelMoney.Caption := '￥' + IntToStr(Msg.Recog);
            Lock(False);
            FrmAddLogin.ButtonAdd.Enabled := True;
            FrmAddLogin.EditName.Enabled := True;
            FrmAddLogin.EditQQ.Enabled := True;
            FrmAddLogin.EditBindList.Enabled := True;
            FrmAddLogin.EditName.Text := '';
            FrmAddLogin.EditQQ.Text := '';
            FrmAddLogin.EditBindList.Text := '';
            ShowHint('恭喜你，帐号创建成功！');
          end;
        SM_TOOLS_REGM2_FAIL: begin
            DMsg.MessageDlg(DecodeString(body), mtError, [mbYes], 0);
            Lock(False);
            FrmAddM2.ButtonAdd.Enabled := True;
            FrmAddM2.EditName.Enabled := True;
            FrmAddM2.EditBindCount.Enabled := True;
            FrmAddM2.EditName.SetFocus;
            ShowHint(DecodeString(body));
          end;
        SM_TOOLS_REGM2_OK: begin
            DMsg.MessageDlg('恭喜你，添加成功！', mtInformation, [mbYes], 0);
            LabelMoney.Caption := '￥' + IntToStr(Msg.Recog);
            Lock(False);
            FrmAddM2.ButtonAdd.Enabled := True;
            FrmAddM2.EditName.Enabled := True;
            FrmAddM2.EditBindCount.Enabled := True;
            FrmAddM2.EditName.Text := '';
            FrmAddM2.EditBindCount.Value := 1;
            ShowHint('恭喜你，添加成功！');
          end;
        SM_TOOLS_CHANGEPASS_FAIL: begin
            ShowHint('密码修改失败，旧密码不正确！');
            DMsg.MessageDlg('密码修改失败，旧密码不正确！', mtError, [mbYes], 0);
            FrmChangePass.EditOldPassword.Text := '';
            FormMain.Lock(False);
            FrmChangePass.ButtonOK.Enabled := True;
            FrmChangePass.EditOldPassword.Enabled := True;
            FrmChangePass.EditPassword.Enabled := True;
            FrmChangePass.EditPassword2.Enabled := True;
            FrmChangePass.EditOldPassword.SetFocus;
          end;
        SM_TOOLS_CHANGEPASS_OK: begin
            ShowHint('密码修改成功！');
            DMsg.MessageDlg('密码修改成功！', mtInformation, [mbYes], 0);
            FrmChangePass.EditOldPassword.Text := '';
            FrmChangePass.EditPassword.Text := '';
            FrmChangePass.EditPassword2.Text := '';
            FormMain.Lock(False);
            FrmChangePass.ButtonOK.Enabled := True;
            FrmChangePass.EditOldPassword.Enabled := True;
            FrmChangePass.EditPassword.Enabled := True;
            FrmChangePass.EditPassword2.Enabled := True;
          end;
        SM_TOOLS_BINDLIST: begin
            ShowHint('获取列表成功！');
            FrmBindTool.GetBindList(body);
          end;
        SM_DOWNLIST: GetDownListInfo(@Msg, body);

        SM_DOWNM2SERVER_FAIL: begin
            ShowHint(DecodeString(body));
            Lock(False);
            FrmDownM2.ButtonAdd.Enabled := True;
          end;
        SM_DOWNM2SERVER_MAKEFILE: begin
            ShowHint(DecodeString(body));
            DownTimer.Enabled := True;
          end;
        SM_DOWNM2SERVER_DATA: SaveFileData(Msg, body, False);
        SM_DOWNM2SERVER_OK: DownFileOk(False);
        SM_DOWNLOGINEXE_FAIL: begin
            ShowHint(DecodeString(body));
            Lock(False);
            FrmDownLogin.ButtonAdd.Enabled := True;
            FrmDownLogin.EditName.Enabled := True;
            FrmDownLogin.EditSkinFile.Enabled := True;
            //DownLoginTimer.Enabled := True;
          end;
        SM_DOWNLOGINEXE_MAKEFILE: begin
            ShowHint(DecodeString(body));
            DownLoginTimer.Enabled := True;
          end;
        SM_DOWNLOGINEXE_DATA: SaveFileData(Msg, body, True);
        SM_DOWNLOGINEXE_OK: DownFileOk(True);
        SM_USERGETENINFO_OK: GetInfo(body);
        SM_TOOLS_CHANGEBIND_FAIL: begin
            ShowHint(DecodeString(body));
            DMsg.MessageDlg(DecodeString(body), mtError, [mbYes], 0);
            FrmBindTool.IsLock(False);
          end;
        SM_TOOLS_CHANGEBIND_OK: begin
            LabelBindCount.Caption := IntToStr(Msg.Param);
            LabelResetCount.Caption := IntToStr(Msg.tag);
            ShowHint('更改绑定信息成功！');
            FrmBindTool.ChangeBindList(body);
          end;
        SM_TOOLS_UPDATE: begin
            //if Msg.Recog > FILEVARINDEX then begin
            m_DownUrl := DecodeString(body);
            PostMessage(Handle, WM_UPDATEMSG, 0, 0);
            //end;
          end;
        SM_TOOLS_SENDUSRNAME: begin
            DefMsg := MakeDefaultMsg(CM_TOOLS_SENDUSERNAME, 0, 0, 0, 0);
            SendToolSocket(EncodeMessage(DefMsg) + body);
          end;
      end;
    end;
  end;
end;

procedure TFormMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  UnInitFrame();
end;

procedure TFormMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if DMsg.MessageDlg('是否确定关闭管理工具？', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    CanClose := True
  else
    CanClose := False;
end;

procedure TFormMain.FormCreate(Sender: TObject);
var
  sDefAccount: string;
  nIdx: Integer;
  Res: TResourceStream;
//  Icon: TIcon;
begin
  {FrameHeQu.Visible := True;
  FrameHeQu.Width := 800;
  FrameHeQu.Height := 600;   }
  ClientWidth := 800;
  ClientHeight := 426;
  g_DefDatImage := TBitmap.Create;
  g_DefWavImage := TBitmap.Create;
  g_DefMp3Image := TBitmap.Create;
  
  Res := TResourceStream.Create(Hinstance, '256RGB', 'RGB');
  try
    Res.Read(g_DefMainPalette, SizeOf(g_DefMainPalette));
  finally
    Res.Free;
  end;
  g_DefDatImage.LoadFromResourceName(Hinstance, 'DATFILE');
  g_DefWavImage.LoadFromResourceName(Hinstance, 'WAVFILE');
  g_DefMp3Image.LoadFromResourceName(Hinstance, 'MP3FILE');

  FboFrist := True;
  Randomize;
  FSocketStr := '';
  GroupBoxLogin.Align := alClient;
  LabelUpLog.Left := 10;
  LabelUpLog.Top := 10;

  g_RunFileName := ParamStr(0);

  g_CurrentDir := GetCurrentDir;
  if RightStr(g_CurrentDir, 1) <> '\' then
    g_CurrentDir := g_CurrentDir + '\';
  OpenDialog.InitialDir := g_CurrentDir;

  g_Config := TINIFIle.Create(g_CurrentDir + 'ToolSetup.ini');
  CreateDir(g_CurrentDir + DOWNDIRNAME);

  FrmDownLogin.EditName.Text := g_Config.ReadString('Down', 'ServerName', '');
  FrmDownLogin.EditSkinFile.Text := g_Config.ReadString('Down', 'SkinFile', '');

  sDefAccount := g_Config.ReadString('Default', 'Account', '');
  g_Config.ReadSection('Account', ComboBoxName.Items);
  nIdx := ComboBoxName.Items.IndexOf(sDefAccount);
  if nIdx > -1 then ComboBoxName.ItemIndex := nIdx
  else if ComboBoxName.Items.Count > 0 then ComboBoxName.ItemIndex := 0;

  ComboBoxNameChange(ComboBoxName);

  InitFrame;
  CloseAllFrame;
  GroupBoxLogin.Visible := True;
  Application.Title := '361M2管理工具';

  DragAcceptFiles(FrmTools.GroupBoxMD5.Handle, True);
  //DragAcceptFiles(FormEditUpData.GroupBoxMD5.Handle, True);


  {Icon := GetFileIconIndex('.txt');
  if Icon <> nil then begin
    Icon.SaveToFile('D:\dd.ico');
    //ButtonsBarLeft.Sections[3].Items[0].ImageIndex := ImageListMaxIcon.AddIcon(Icon);
    Icon.Free;
  end;    }

{$IFDEF DEBUG}
  FrmHeQu.EditMainID.Text := 'D:\合区测试数据\Id.DB';
  FrmHeQu.EditMainHum.Text := 'D:\合区测试数据\DB\Hum.DB';
  FrmHeQu.EditMainMir.Text := 'D:\合区测试数据\DB\Mir.DB';
  FrmHeQu.EditMainGuild.Text := 'D:\合区测试数据\GuildBase';

  FrmHeQu.EditSubID.Text := 'D:\合区测试数据\Id.DB';
  FrmHeQu.EditSubHum.Text := 'D:\合区测试数据\从\Hum.DB';
  FrmHeQu.EditSubMir.Text := 'D:\合区测试数据\从\Mir.DB';
  FrmHeQu.EditSubGuild.Text := 'D:\合区测试数据\从\GuildBase';

  FrmHeQu.EditSaveDir.Text := 'D:\合区测试数据\完成';
{$ENDIF}
end;

procedure TFormMain.FormDestroy(Sender: TObject);
begin
  g_DefDatImage.Free;
  g_DefWavImage.Free;
  g_DefMp3Image.Free;
  DragFinish(FrmTools.GroupBoxMD5.Handle);
  //DragFinish(FormEditUpData.GroupBoxMD5.Handle);

  g_Config.Free;
end;

procedure TFormMain.FormResize(Sender: TObject);
begin
  if FboFrist then ChangeSkinIndex(g_Config.ReadInteger('Default', 'SkinIndex', 0));
  FboFrist := False;
end;

procedure TFormMain.GetDownListInfo(Msg: pTDefaultMessage; sBody: string);
var
  TempList: TStringList;
begin
  TempList := TStringList.Create;
  Try
    TempList.SetText(PChar(DecodeString(sBody)));
    if Msg.Recog = 1 then begin
      if TempList.Count > 1 then begin
        FrmDownM2.LabelUpVar.Caption := TempList[0];
        FrmDownM2.LabelUpTime.Caption := TempList[1];
        TempList.Delete(0);
        TempList.Delete(0);
        FrmDownM2.LabelUpLog.Lines.Assign(TempList);
      end;
    end else
    if Msg.Recog = 2 then begin
      if TempList.Count > 1 then begin
        FrmDownLogin.LabelUpVar.Caption := TempList[0];
        FrmDownLogin.LabelUpTime.Caption := TempList[1];
        TempList.Delete(0);
        TempList.Delete(0);
        FrmDownLogin.LabelUpLog.Lines.Assign(TempList);
      end;
    end else
    if Msg.Recog = 3 then begin

    end;
  Finally
    TempList.Free;
  End;
end;

procedure TFormMain.GetInfo(sData: string);
var
  sInfo, S1, S2, S3: string;
  nItem: Integer;
  boAddr: Boolean;
  Item: TListItem;
begin
  if FrmLSetup.Visible then begin
    FormMain.ShowHint('正在生成登录器配置列表...');
    FormMain.Lock(False);
    FrmLSetup.GroupBoxBG.Enabled := True;
    FrmLSetup.bsSkinButton1.Enabled := True;
    while sData <> '' do begin
      sData := GetValidStr3(sData, sInfo, ['/']);
      if sInfo = '' then break;
      sInfo := DecodeString(sInfo);
      sInfo := GetValidStr3(sInfo, S1, ['/']);
      sInfo := GetValidStr3(sInfo, S2, ['/']);
      sInfo := GetValidStr3(sInfo, S3, ['/']);
      nItem := StrToIntDef(S1, -1);
      boAddr := S2 = '1';
      if (nItem > -1) and (nItem < FrmLSetup.lvServerList.Items.Count) then begin
        Item := FrmLSetup.lvServerList.Items[nItem];
        if boAddr then Item.SubItems[4] := S3
        else Item.SubItems[5] := S3;
      end;
    end;
    FrmLSetup.bsSkinButton1Click(FrmLSetup.bsSkinButton1);
  end;
end;

end.

