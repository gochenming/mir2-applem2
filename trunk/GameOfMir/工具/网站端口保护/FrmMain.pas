unit FrmMain;

interface

uses
  Windows, Messages, SysUtils, StrUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Menus, JSocket, WinSock, ExtCtrls;

const
  BlockIPListName = '.\BlockIPList.txt';
  UrlListName = '.\UrlList.txt';

type
  pTWEBSession = ^TWEBSession;
  TWEBSession = packed record
    sRemoteIPaddr: string;
    ReadString: string;
    SendString: string;
  end;
  
  pTBlockaddr = ^TBlockaddr;
  TBlockaddr = packed record
    nBeginAddr: LongWord;
    nEndAddr: LongWord;
  end;


  TFormMain = class(TForm)
    pm1: TPopupMenu;
    A1: TMenuItem;
    D1: TMenuItem;
    SSocket: TServerSocket;
    grp3: TGroupBox;
    btn1: TButton;
    btn2: TButton;
    chk1: TCheckBox;
    chk2: TCheckBox;
    StatusBar: TStatusBar;
    pgc1: TPageControl;
    ts1: TTabSheet;
    grp2: TGroupBox;
    mmo1: TMemo;
    ts2: TTabSheet;
    grp1: TGroupBox;
    lv1: TListView;
    ts3: TTabSheet;
    grp4: TGroupBox;
    lst1: TListBox;
    pmIPListPopupMenu: TPopupMenu;
    IPMENU_SORT: TMenuItem;
    IPMENU_ADD: TMenuItem;
    IPMENU_DEL: TMenuItem;
    tmr1: TTimer;
    chk3: TCheckBox;
    chk4: TCheckBox;
    ts4: TTabSheet;
    grp5: TGroupBox;
    lst2: TListBox;
    procedure FormCreate(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure SSocketListen(Sender: TObject; Socket: TCustomWinSocket);
    procedure btn2Click(Sender: TObject);
    procedure SSocketClientConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure SSocketClientDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure FormDestroy(Sender: TObject);
    procedure IPMENU_SORTClick(Sender: TObject);
    procedure IPMENU_ADDClick(Sender: TObject);
    procedure IPMENU_DELClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure tmr1Timer(Sender: TObject);
    procedure SSocketClientError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
      var ErrorCode: Integer);
    procedure SSocketClientRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure A1Click(Sender: TObject);
    procedure D1Click(Sender: TObject);
    procedure pgc1Change(Sender: TObject);
  private
    FConnCount: Integer;
    FKickCount: Integer;
    FGotoCount: Integer;
    FBlockaddr: TList;
    FUrlList1: TStringList;
    FUrlList2: TStringList;
    FRefererList: TStringList;
    procedure LoadBlockIpList;
    procedure SaveBlockIPList;
    procedure LoadUrlList;
    procedure SaveUrlList;
    function IsBlockIP(sIPaddr: string): Boolean;
    function ProcessHttpMsg(sReadMsg: string): string;
  public
    procedure MainOutMessage(sMsg: string);
    procedure OnProgramException(Sender: TObject; E: Exception);
  end;

var
  FormMain: TFormMain;

implementation

{$R *.dfm}

uses
  HUtil32, MyCommon;

{ TFormMain }

procedure TFormMain.A1Click(Sender: TObject);
var
  sIPaddress, sIPaddress2: string;
  Item: TListItem;
begin
  sIPaddress := '';
  sIPaddress2 := '';
  if not InputQuery('过滤IP段信息', '请输入原HOST: ', sIPaddress) then Exit;
  if sIPaddress = '' then begin
    Application.MessageBox('原HOST不能为空！', '提示信息', MB_OK + MB_ICONINFORMATION);
    Exit;
  end;
  if FUrlList1.IndexOf(sIPaddress) > -1 then begin
    Application.MessageBox('原HOST已经存在了！', '提示信息', MB_OK + MB_ICONINFORMATION);
    Exit;
  end;
  if not InputQuery('过滤IP段信息', '请输入新HOST: ', sIPaddress2) then Exit;
  if sIPaddress2 = '' then begin
    Application.MessageBox('新HOST不能为空！', '提示信息', MB_OK + MB_ICONINFORMATION);
    Exit;
  end;
  Item := lv1.Items.Add;
  FUrlList1.Add(sIPaddress);
  FUrlList2.Add(sIPaddress2);
  Item.Caption := sIPaddress;
  Item.SubItems.Add(sIPaddress2);
  SaveUrlList;
end;

procedure TFormMain.btn1Click(Sender: TObject);
begin
  FConnCount := 0;
  FKickCount := 0;
  FGotoCount := 0;
  SSocket.Active := True;
  //showmessage(IntToStr(lv1.Items.IndexOf('http://www.mir2k.com')));
end;

procedure TFormMain.btn2Click(Sender: TObject);
begin
  FConnCount := 0;
  FKickCount := 0;
  FGotoCount := 0;
  SSocket.Active := False;
  btn1.Enabled := True;
  btn2.Enabled := False;
end;

procedure TFormMain.D1Click(Sender: TObject);
var
  i: Integer;
  Item: TListItem;
begin
  if (lv1.ItemIndex >= 0) and (lv1.ItemIndex < lv1.Items.Count) then begin
    Item := lv1.Items[lv1.ItemIndex];
    for i := 0 to FUrlList1.Count - 1 do begin
      if Item.Caption = FUrlList1[I] then begin
        FUrlList1.Delete(i);
        FUrlList2.Delete(i);
        lv1.Items.Delete(lv1.ItemIndex);
        break;
      end;
    end;
  end;
  SaveUrlList;
end;

procedure TFormMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if Application.MessageBox('是否确认退出服务器？', '确认信息', MB_YESNO + MB_ICONQUESTION) = IDYES then begin
  end
  else
    CanClose := False;
end;

procedure TFormMain.FormCreate(Sender: TObject);
begin
  mmo1.Lines.Clear;
  Application.OnException := OnProgramException;
  pgc1.TabIndex := 0;
  FBlockaddr := TList.Create;
  FUrlList1 := TStringList.Create;
  FUrlList2 := TStringList.Create;
  FRefererList := TStringList.Create;
  LoadBlockIpList;
  LoadUrlList;
  tmr1.Enabled := True;
end;

procedure TFormMain.FormDestroy(Sender: TObject);
begin
  FBlockaddr.Free;
  FUrlList1.Free;
  FUrlList2.Free;
  FRefererList.Free;
end;

procedure TFormMain.IPMENU_ADDClick(Sender: TObject);
var
  sIPaddress: string;
  nBeginaddr, nEndaddr: integer;
  Blockaddr: pTBlockaddr;
begin
  sIPaddress := '';
  if not InputQuery('过滤IP段信息', '请输入起始IP地址: ', sIPaddress) then Exit;
  nBeginaddr := inet_addr(PChar(sIPaddress));
  if nBeginaddr = INADDR_NONE then begin
    Application.MessageBox('输入的地址格式不正确！', '提示信息', MB_OK + MB_ICONINFORMATION);
    Exit;
  end;
  if not InputQuery('过滤IP段信息', '请输入结束IP地址: ', sIPaddress) then Exit;
  nEndaddr := inet_addr(PChar(sIPaddress));
  if nEndaddr = INADDR_NONE then begin
    Application.MessageBox('输入的地址格式不正确！', '提示信息', MB_OK + MB_ICONINFORMATION);
    Exit;
  end;
  if LongWord(nEndaddr) >= LongWord(nBeginaddr) then begin
    New(Blockaddr);
    Blockaddr.nBeginAddr := nBeginaddr;
    Blockaddr.nEndAddr := nEndaddr;
    FBlockaddr.Add(Blockaddr);
    lst1.AddItem(StrPas(inet_ntoa(TInAddr(nBeginAddr))) + ' - ' + StrPas(inet_ntoa(TInAddr(nEndAddr))), TObject(Blockaddr));
    SaveBlockIPList;
  end else
    Application.MessageBox('结束地址不能小于开始地址', '提示信息', MB_OK + MB_ICONINFORMATION);
end;

procedure TFormMain.IPMENU_DELClick(Sender: TObject);
var
  i: Integer;
  Blockaddr: pTBlockaddr;
begin
  if (lst1.ItemIndex >= 0) and (lst1.ItemIndex < lst1.Items.Count) then begin
    Blockaddr := pTBlockaddr(lst1.Items.Objects[lst1.ItemIndex]);
    for i := 0 to FBlockaddr.Count - 1 do begin
      if pTBlockaddr(FBlockaddr.Items[i]) = Blockaddr then begin
        FBlockaddr.Delete(i);
        Dispose(Blockaddr);
        lst1.Items.Delete(lst1.ItemIndex);
        break;
      end;
    end;
  end;
  SaveBlockIPList;
end;

procedure TFormMain.IPMENU_SORTClick(Sender: TObject);
begin
  lst1.Sorted := True;
end;

function TFormMain.IsBlockIP(sIPaddr: string): Boolean;
var
  i: Integer;
  nIPaddr: Integer;
  Blockaddr: pTBlockaddr;
begin
  Result := False;
  nIPaddr := inet_addr(PChar(sIPaddr));

  for i := 0 to FBlockaddr.Count - 1 do begin
    Blockaddr := FBlockaddr[i];
    if (LongWord(nIPaddr) >= Blockaddr.nBeginAddr) and (LongWord(nIPaddr) <= Blockaddr.nEndAddr) then begin
      Result := True;
      break;
    end;
  end;
end;

procedure TFormMain.LoadBlockIpList;
var
  i: Integer;
  sFileName: string;
  LoadList: TStringList;
  sIPaddr, sBeginaddr, sEndaddr: string;
  nBeginaddr, nEndaddr: Integer;
  Blockaddr: pTBlockaddr;
begin
  sFileName := BlockIPListName;

  for i := 0 to FBlockaddr.Count - 1 do begin
    Dispose(pTBlockaddr(FBlockaddr[i]))
  end;
  FBlockaddr.Clear;
  if FileExists(sFileName) then begin
    LoadList := TStringList.Create;
    LoadList.LoadFromFile(sFileName);
    for i := 0 to LoadList.Count - 1 do begin
      sIPaddr := Trim(LoadList.Strings[i]);
      if sIPaddr = '' then Continue;
      sEndaddr := GetValidStr3(sIPaddr, sBeginaddr, [' ', #9]);
      nBeginaddr := inet_addr(PChar(sBeginaddr));
      nEndaddr := inet_addr(PChar(sEndaddr));
      if (nBeginaddr <> INADDR_NONE) and (nEndaddr <> INADDR_NONE) and (LongWord(nEndaddr) >= LongWord(nBeginaddr)) then begin
        New(Blockaddr);
        Blockaddr.nBeginAddr := nBeginaddr;
        Blockaddr.nEndAddr := nEndaddr;
        FBlockaddr.Add(Blockaddr);
        lst1.AddItem(StrPas(inet_ntoa(TInAddr(nBeginAddr))) + ' - ' + StrPas(inet_ntoa(TInAddr(nEndAddr))), TObject(Blockaddr));
      end;
    end;
    LoadList.Free;
  end;
end;

procedure TFormMain.LoadUrlList;
var
  LoadList: TStringList;
  sFileName, str, str2, str1: string;
  I: Integer;
  Item: TListItem;
begin
  FUrlList1.Clear;
  FUrlList2.Clear;
  lv1.Items.Clear;

  sFileName := UrlListName;

  if FileExists(sFileName) then begin
    LoadList := TStringList.Create;
    LoadList.LoadFromFile(sFileName);
    for i := 0 to LoadList.Count - 1 do begin
      str := Trim(LoadList.Strings[i]);
      str2 := GetValidStr3(str, str1, [' ', #9]);
      if (str1 <> '') and (str2 <> '') then begin
        FUrlList1.Add(str1);
        FUrlList2.Add(str2);
        Item := lv1.Items.Add;
        Item.Caption := str1;
        Item.SubItems.Add(str2);
      end;

    end;
    LoadList.Free;
  end;
end;

procedure TFormMain.MainOutMessage(sMsg: string);
begin
  if mmo1.Lines.Count > 200 then
    mmo1.Lines.Clear;
  mmo1.Lines.Add('[' + TimeToStr(Now) + '] ' + sMsg);
end;

procedure TFormMain.OnProgramException(Sender: TObject; E: Exception);
begin
  MainOutMessage(E.Message);
end;

procedure TFormMain.pgc1Change(Sender: TObject);
var
  i: Integer;
begin
  if pgc1.TabIndex = 3 then begin
    lst2.Items.Clear;
    for I := 0 to FRefererList.Count - 1 do begin
      lst2.Items.Add(FRefererList[I] + ' - ' + IntToStr(Integer(FRefererList.Objects[I])));
    end;
  end;

end;

function TFormMain.ProcessHttpMsg(sReadMsg: string): string;
var
  TempList: TStringList;
  I, nID, nCount, nIndex: Integer;
  str, temp: string;
  sURL, sHost, sReferer: string;
begin
  Result := '';
  sURL := '';
  sReferer := '';
  sHost := '';
  TempList := TStringList.Create;
  Try
    TempList.SetText(PChar(sReadMsg));
    if TempList.Count > 30 then exit;
    for I := 0 to TempList.Count - 1 do begin
      str := TempList[I];
      if I = 0 then begin
        if (LeftStr(str, 3) = 'GET') then begin
          ArrestStringEx(str, ' ', ' ', sURL);
          if sURL = '' then Exit;
          if (sURL[1] <> '/') then begin
            if chk3.Checked then  Exit;
            sURL := Copy(sURL, 10, Length(sURL));
            sURL := '/' + GetValidStr3(sURL, temp, ['/']);
          end;
        end else Exit;
      end else begin
        if (LeftStr(str, 6) = 'Host: ') then begin
          sHost := GetValidStr3(str, temp, [' ']);
        end else
        if (LeftStr(str, 9) = 'Referer: ') then begin
          sReferer := GetValidStr3(str, temp, [' ']);
          sReferer := GetValidStr3(sReferer, temp, ['/']);
          GetValidStr3(sReferer, sReferer, ['/']);
        end;
      end;
    end;
    if (sHost <> '') and (sURL <> '') then begin
      nID := FUrlList1.IndexOf(sHost);
      if nID > -1  then begin
        if sReferer <> '' then begin
          nIndex := FRefererList.IndexOf(sReferer);
          if nIndex > -1 then begin
            nCount := Integer(FRefererList.Objects[nIndex]) + 1;
            FRefererList.Objects[nIndex] := TObject(nCount);
          end else begin
            FRefererList.AddObject(sReferer, TObject(1));
          end;
        end;
        sURL := 'http://' + FUrlList2[nID] + sURL;
        temp := '<a HREF="' + sURL + '">如果没有自动跳转，请点击此处.</a>';
        Result := 'HTTP/1.1 302 Object moved' + #13#10;
        Result := Result + 'Date: ' + DateTimeToGMT(Now) + #13#10;
        Result := Result + 'Server: Microsoft-IIS/6.0' + #13#10;
        Result := Result + 'Location: ' + sURL + #13#10;
        Result := Result + 'Content-Length: ' + IntToStr(Length(sURL)) + #13#10;
        Result := Result + 'Content-Type: text/html' + #13#10;
        Result := Result + 'Cache-control: private' + #13#10;
        Result := Result + #13#10;
        Result := Result + temp;
        Inc(FGotoCount);
      end;
    end;
  Finally
    TempList.Free;
  End;
end;

procedure TFormMain.SaveBlockIPList;
var
  i: Integer;
  SaveList: TStringList;
  sFileName: string;
begin
  sFileName := BlockIPListName;
  SaveList := TStringList.Create;
  for i := 0 to FBlockaddr.Count - 1 do begin
    SaveList.Add(StrPas(inet_ntoa(TInAddr(pTBlockaddr(FBlockaddr[i]).nBeginAddr))) + #9 +
      StrPas(inet_ntoa(TInAddr(pTBlockaddr(FBlockaddr[i]).nEndAddr))));
  end;
  SaveList.SaveToFile(sFileName);
  SaveList.Free;
end;

procedure TFormMain.SaveUrlList;
var
  i: Integer;
  SaveList: TStringList;
  sFileName: string;
begin
  sFileName := UrlListName;
  SaveList := TStringList.Create;
  for i := 0 to FUrlList1.Count - 1 do begin
    SaveList.Add(FUrlList1[I] + #9 + FUrlList2[I]);
  end;
  SaveList.SaveToFile(sFileName);
  SaveList.Free;
end;

procedure TFormMain.SSocketClientConnect(Sender: TObject; Socket: TCustomWinSocket);
var
  WEBSession: pTWEBSession;
  sRemoteIPaddr: string;
begin
  Socket.nIndex := 0;
  sRemoteIPaddr := Socket.RemoteAddress;

  if IsBlockIP(sRemoteIPaddr) then begin
    MainOutMessage('非法连接: ' + sRemoteIPaddr);
    Socket.Close;
    Inc(FKickCount);
    Exit;
  end;
  Inc(FConnCount);
  New(WEBSession);
  WEBSession.sRemoteIPaddr := sRemoteIPaddr;
  WEBSession.ReadString := '';
  WEBSession.SendString := '';
  Socket.nIndex := Integer(WEBSession);
end;

procedure TFormMain.SSocketClientDisconnect(Sender: TObject; Socket: TCustomWinSocket);
begin
  if Socket.nIndex <> 0 then begin
    Dec(FConnCount);
    Dispose(pTWEBSession(Socket.nIndex));
  end;
  Socket.nIndex := 0;
end;

procedure TFormMain.SSocketClientError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
  ErrorCode := 0;
  Socket.Close;
end;

procedure TFormMain.SSocketClientRead(Sender: TObject; Socket: TCustomWinSocket);
var
  WEBSession: pTWEBSession;
//  sReadStr, sTempStr, sOldReadStr,
  sSendStr: string;
  nPos: Integer;
begin
  if Socket.nIndex <> 0 then begin
    WEBSession := pTWEBSession(Socket.nIndex);
    WEBSession.ReadString := WEBSession.ReadString + Socket.ReceiveText;
    if length(WEBSession.ReadString) > 4096 then begin
      Inc(FKickCount);
      Socket.Close;
      exit;
    end;
    while WEBSession.ReadString <> '' do begin
      nPos := Pos(#13#10#13#10, WEBSession.ReadString);
      if nPos <= 0 then break;
      //sSendStr := Inc(FKickCount);()
      sSendStr := ProcessHttpMsg(WEBSession.ReadString);
      if (sSendStr = '') and chk4.Checked then begin
        MainOutMessage(sSendStr);
      end;
      WEBSession.ReadString := '';
      if sSendStr <> '' then begin
        Socket.SendText(sSendStr);
      end else begin
        Inc(FKickCount);
        Socket.Close;
        exit;
      end;
      (*

     HTTP/1.1 302 Object moved
Date: Sat, 03 Jul 2010 02:25:30 GMT
Server: Microsoft-IIS/6.0
X-Powered-By: ASP.NET
Location: register
Content-Length: 129
Content-Type: text/html
Set-Cookie: ASPSESSIONIDAAQSCDRS=OHEMDEMCBMFELNBLGFIOFAGC; path=/
Cache-control: private

<head><title>Object moved</title></head>
<body><h1>Object Moved</h1>This object may be found <a HREF="register">here</a>.</body>




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
            //sSendStr := ProcessHttpMsg(sReadStr);

            {sReadStr := 'HTTP/1.1 200 OK'#13#10;
            sReadStr := sReadStr + 'Date: ' + DateTimeToGMT(Now) + #13#10;
            sReadStr := sReadStr + 'Server: Microsoft-IIS/5.1'#13#10;
            if sSendStr <> '' then
              sReadStr := sReadStr + 'Content-Length: ' + IntToStr(Length(sSendStr)) + #13#10;
            sReadStr := sReadStr + 'Content-Type: text/html'#13#10;
            sReadStr := sReadStr + 'Cache-control: private'#13#10#13#10;   }
            Socket.SendText(sReadStr + sSendStr);
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
      end;      *)
    end;
  end
  else
    Socket.Close;
end;

procedure TFormMain.SSocketListen(Sender: TObject; Socket: TCustomWinSocket);
begin
  btn1.Enabled := False;
  btn2.Enabled := True;
  MainOutMessage('端口绑定(' + Socket.LocalAddress + ':' + IntToStr(Socket.LocalPort) + ')...');
end;

procedure TFormMain.tmr1Timer(Sender: TObject);
begin
  StatusBar.Panels[1].Text := IntToStr(FConnCount) + '/' + IntToStr(SSocket.Socket.ConnectCount);
  StatusBar.Panels[3].Text := IntToStr(FKickCount);
  StatusBar.Panels[5].Text := IntToStr(FGotoCount);
end;

end.
