unit PayThread;

interface

uses
  Windows, Messages, Classes, SysUtils, StrUtils, IdHTTP, IdSSLOpenSSL, Share, IdCookieManager, IdCookie;

const
  COPYMSG_BANK_GETKEY_OK = 1000;
  COPYMSG_BANK_GETKEY_FAIL = 1001;
  COPYMSG_CARD_GETKEY_FAIL = 1002;
  COPYMSG_CARD_IDPASS_FAIL = 1003;
  COPYMSG_CARD_TIMEOUT = 1004;
  COPYMSG_CARD_OK = 1005;

type
  pTPayInfo = ^TPayInfo;
  TPayInfo = packed record
    PayDBInfo: TPayDBInfo;
    ErrorCount: Integer;
    DelayTick: LongWord;
    TimeOutTick: LongWord;
    PostKey: string[40];
    CheckUrl: string;
    BackUrl: string;
  end;

  TPayGetThread = class(TThread)
  private
    FCriticalSection: TRTLCriticalSection;
    FIndex: Integer;
    FHTTP: TIdHTTP;
    FList1: TList;
    FList2: TList;
  protected
    procedure Execute; override;
    function GetUrlStr(sUrl: string): string;
    function GetBeginParam(PayInfo: pTPayInfo): string;
    function GetCardParam(PayInfo: pTPayInfo): string;
    function GetCardSZXParam(PayInfo: pTPayInfo): string;
    function ExecuteBank(PayInfo: pTPayInfo): Boolean;
    function ExecuteCard(PayInfo: pTPayInfo): Boolean;
    function ExecuteSZX(PayInfo: pTPayInfo): Boolean;
    procedure SendMsg(nCode: Integer; sSendMsg: string);
  public
    constructor Create(Index: Integer; Terminate: TNotifyEvent; CreateSuspended: Boolean);
    destructor Destroy; override;
    procedure Lock;
    procedure UnLock;
    procedure AddPayInfo(PayDBInfo: pTPayDBInfo);
    property ListIndex: Integer read FIndex;
  end;

implementation

uses
  MD5Unit, Hutil32, FrmMain;

const
  CS_ACTION = 'https://pay.168reg.cn/pay.do';
  CS_CARD_ACTION = 'https://pay.168reg.cn/payment_cardpay.do';
  CS_CARD_SZX_ACTION = 'https://pay.168reg.cn/payment_szxpay.do';
  CS_CARDCHECK = 'https://pay.168reg.cn/';
  CS_SERVICENAME = '新热血传奇';
  CS_CUSTOM1NAME = '通行证';
  CS_CUSTOM2NAME = '邮箱';


procedure TPayGetThread.AddPayInfo(PayDBInfo: pTPayDBInfo);
var
  PayInfo: pTPayInfo;
begin
  New(PayInfo);
  PayInfo.PayDBInfo := PayDBInfo^;
  PayInfo.ErrorCount := 0;
  PayInfo.DelayTick := 0;
  PayInfo.PostKey := '';
  PayInfo.CheckUrl := '';
  PayInfo.BackUrl := '';
  PayInfo.TimeOutTick := GetTickCount + 5 * 60 * 1000;
  Lock;
  try
    FList1.Add(PayInfo);
  finally
    UnLock;
  end;
end;

constructor TPayGetThread.Create(Index: Integer; Terminate: TNotifyEvent; CreateSuspended: Boolean);
begin
  inherited Create(CreateSuspended);
  InitializeCriticalSection(FCriticalSection);
  FreeOnTerminate := True;
  OnTerminate := Terminate;
  FIndex := Index;
  FHTTP := nil;
  FList1 := TList.Create;
  FList2 := TList.Create;
end;

destructor TPayGetThread.Destroy;
var
  I: Integer;
begin
  for I := 0 to FList1.Count - 1 do
    Dispose(pTPayInfo(FList1[I]));
  for I := 0 to FList2.Count - 1 do
    Dispose(pTPayInfo(FList2[I]));
  FList1.Free;
  FList2.Free;
  DeleteCriticalSection(FCriticalSection);
  inherited;
end;

procedure TPayGetThread.Execute;
var
  PayInfo: pTPayInfo;
  I: Integer;
begin
  while not Terminated do begin
    Try
      if FHTTP = nil then begin
        FHTTP := TIdHTTP.Create(nil);
        FHTTP.IOHandler := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
        FHTTP.CookieManager := TIdCookieManager.Create(nil);
        TIdSSLIOHandlerSocketOpenSSL(FHTTP.IOHandler).SSLOptions.Method := sslvTLSv1;
        FHTTP.ReadTimeout := 30000;
      end;
      Lock;
      try
        for I := 0 to FList1.Count - 1 do
          FList2.Insert(0, FList1[I]);
        FList1.Clear;
      finally
        UnLock;
      end;
      for I := FList2.Count - 1 downto 0 do begin
        PayInfo := FList2[I];
        if PayInfo.PayDBInfo.payvia = '1' then begin
          if ExecuteBank(PayInfo) then FList2.Delete(I);
        end else
        if PayInfo.PayDBInfo.payvia = '7' then begin
          if GetTickCount > PayInfo.DelayTick then begin
            if ExecuteSZX(PayInfo) then FList2.Delete(I);
          end;
        end else begin
          if GetTickCount > PayInfo.DelayTick then begin
            if ExecuteCard(PayInfo) then FList2.Delete(I);
          end;
        end;
      end;
    Except
    End;
    Sleep(100);
  end;
  if FHTTP <> nil then begin
    TIdSSLIOHandlerSocketOpenSSL(FHTTP.IOHandler).Free;
    TIdCookieManager(FHTTP.CookieManager).Free;
    FHTTP.Free;
    FHTTP := nil;
  end;
end;

function TPayGetThread.ExecuteBank(PayInfo: pTPayInfo): Boolean;
var
  sBackStr, sKey: string;
  nPos: Integer;
begin
  Result := True;
  sBackStr := GetUrlStr(GetBeginParam(PayInfo));
  if sBackStr = '' then begin
    Inc(PayInfo.ErrorCount);
    if PayInfo.ErrorCount < 2 then
      Result := False
    else
      SendMsg(COPYMSG_BANK_GETKEY_FAIL, IntToStr(PayInfo.PayDBInfo.ID));
  End else begin
    sKey := '';
    nPos := Pos('postkey', sBackStr);
    if nPos > 0 then begin
      sBackStr := Copy(sBackStr, nPos, 100);
      sBackStr := GetValidStr3(sBackStr, sKey, ['=']);
      ArrestStringEx(sBackStr, '"', '"', sKey);
    end;
    if Length(sKey) = 32 then begin
      SendMsg(COPYMSG_BANK_GETKEY_OK, IntToStr(PayInfo.PayDBInfo.ID) + '|' + sKey);
    end else begin
      SendMsg(COPYMSG_BANK_GETKEY_FAIL, IntToStr(PayInfo.PayDBInfo.ID));
    end;
  end;
end;

function TPayGetThread.ExecuteSZX(PayInfo: pTPayInfo): Boolean;
var
  sBackStr, sKey, sCheckUrl, sBackUrl: string;
  nPos: Integer;
//  List: TStringList;
begin
  Result := False;
  if PayInfo.PostKey = '' then begin
    sBackStr := GetUrlStr(GetBeginParam(PayInfo));
    if sBackStr = '' then begin
      Inc(PayInfo.ErrorCount);
      if PayInfo.ErrorCount > 1 then begin
        SendMsg(COPYMSG_CARD_GETKEY_FAIL, IntToStr(PayInfo.PayDBInfo.ID));
        Result := True;
        Exit;
      end;
    End else begin
      sKey := '';
      nPos := Pos('postkey', sBackStr);
      if nPos > 0 then begin
        sBackStr := Copy(sBackStr, nPos, 100);
        sBackStr := GetValidStr3(sBackStr, sKey, ['=']);
        ArrestStringEx(sBackStr, '"', '"', sKey);
      end;
      if Length(sKey) = 32 then begin
        PayInfo.PostKey := sKey;
      end else begin
        SendMsg(COPYMSG_CARD_GETKEY_FAIL, IntToStr(PayInfo.PayDBInfo.ID));
        Result := True;
        Exit;
      end;
    end;
  end;
  if (PayInfo.PostKey <> '') and (PayInfo.CheckUrl = '') and (PayInfo.BackUrl = '') then begin
    sBackStr := GetUrlStr(GetCardSZXParam(PayInfo));
    nPos := Pos('check_status', sBackStr);
    sBackStr := Copy(sBackStr, nPos, Length(sBackStr));
    sBackStr := ArrestStringEx(sBackStr, '{', '}', sCheckUrl);
    nPos := Pos('.send', sCheckUrl);
    sCheckUrl := Copy(sCheckUrl, nPos, Length(sCheckUrl));
    ArrestStringEx(sCheckUrl, '"', '"', sCheckUrl);
    nPos := Pos('payment_szx_result.do', sBackStr);
    sBackStr := Copy(sBackStr, nPos - 2, Length(sBackStr));
    ArrestStringEx(sBackStr, '"', '"', sBackUrl);
    if (sCheckUrl = '') or (sBackUrl = '') then begin
      Result := True;
      SendMsg(COPYMSG_CARD_IDPASS_FAIL, IntToStr(PayInfo.PayDBInfo.ID));
    end else begin
      PayInfo.CheckUrl := CS_CARDCHECK + 'payment_szxcheck.do?' + sCheckUrl;
      PayInfo.BackUrl := CS_CARDCHECK + sBackUrl;
    end;
    Exit;
  end else
  if (PayInfo.CheckUrl <> '') and (PayInfo.BackUrl <> '') then begin
    if GetTickCount > PayInfo.TimeOutTick then begin
      SendMsg(COPYMSG_CARD_TIMEOUT, IntToStr(PayInfo.PayDBInfo.ID));
      Result := True;
      Exit;
    end;
    PayInfo.DelayTick := GetTickCount + 10 * 1000;
    sBackStr := GetUrlStr(PayInfo.CheckUrl);
    if Pos('jumpcheck', sBackStr) > 0 then begin
      SendMsg(COPYMSG_CARD_GETKEY_FAIL, IntToStr(PayInfo.PayDBInfo.ID));
      Result := True;
    end else
    if Pos('nextpay', sBackStr) > 0 then begin
      SendMsg(COPYMSG_CARD_GETKEY_FAIL, IntToStr(PayInfo.PayDBInfo.ID));
      Result := True;
    end else
    if Pos('payfailure', sBackStr) > 0 then begin
      SendMsg(COPYMSG_CARD_IDPASS_FAIL, IntToStr(PayInfo.PayDBInfo.ID));
      Result := True;
    end else
    if Pos('jumppay', sBackStr) > 0 then begin
      SendMsg(COPYMSG_CARD_TIMEOUT, IntToStr(PayInfo.PayDBInfo.ID));
      Result := True;
    end else
    if Pos('payok', sBackStr) > 0 then begin
      sBackStr := GetUrlStr(PayInfo.BackUrl);
      SendMsg(COPYMSG_CARD_OK, IntToStr(PayInfo.PayDBInfo.ID) + '|' + sBackStr);
      Result := True;
      {Try
      List := TStringList.Create;
      List.Add(sBackStr);
      List.SaveToFile('.\' + PayInfo.PayDBInfo.payvia + '-' + FormatDateTime('yyyymmddhhmmss', Now) + '.txt');
      List.Free;
      Except

      End;   }
    end;
    Exit;
  end;
end;

function TPayGetThread.ExecuteCard(PayInfo: pTPayInfo): Boolean;
var
  sBackStr, sKey, sCheckUrl, sBackUrl: string;
  nPos: Integer;
//  List: TStringList;
begin
  Result := False;
  if PayInfo.PostKey = '' then begin
    sBackStr := GetUrlStr(GetBeginParam(PayInfo));
    {List := TStringList.Create;
    List.Add(sBackStr);
    List.SaveToFile('d:\card2.txt');
    List.Free;   }
    if sBackStr = '' then begin
      Inc(PayInfo.ErrorCount);
      if PayInfo.ErrorCount > 1 then begin
        SendMsg(COPYMSG_CARD_GETKEY_FAIL, IntToStr(PayInfo.PayDBInfo.ID));
        Result := True;
        Exit;
      end;
    End else begin
      sKey := '';
      nPos := Pos('postkey', sBackStr);
      if nPos > 0 then begin
        sBackStr := Copy(sBackStr, nPos, 100);
        sBackStr := GetValidStr3(sBackStr, sKey, ['=']);
        ArrestStringEx(sBackStr, '"', '"', sKey);
      end;
      if Length(sKey) = 32 then begin
        PayInfo.PostKey := sKey;
      end else begin
        SendMsg(COPYMSG_CARD_GETKEY_FAIL, IntToStr(PayInfo.PayDBInfo.ID));
        Result := True;
        Exit;
      end;
    end;
  end;
  if (PayInfo.PostKey <> '') and (PayInfo.CheckUrl = '') and (PayInfo.BackUrl = '') then begin
    sBackStr := GetUrlStr(GetCardParam(PayInfo));
    nPos := Pos('check_status', sBackStr);
    sBackStr := Copy(sBackStr, nPos, Length(sBackStr));
    sBackStr := ArrestStringEx(sBackStr, '{', '}', sCheckUrl);
    nPos := Pos('.send', sCheckUrl);
    sCheckUrl := Copy(sCheckUrl, nPos, Length(sCheckUrl));
    ArrestStringEx(sCheckUrl, '"', '"', sCheckUrl);
    nPos := Pos('payment_card_result.do', sBackStr);
    sBackStr := Copy(sBackStr, nPos - 2, Length(sBackStr));
    ArrestStringEx(sBackStr, '"', '"', sBackUrl);
    if (sCheckUrl = '') or (sBackUrl = '') then begin
      Result := True;
      SendMsg(COPYMSG_CARD_IDPASS_FAIL, IntToStr(PayInfo.PayDBInfo.ID));
    end else begin
      PayInfo.CheckUrl := CS_CARDCHECK + 'payment_cardcheck.do?' + sCheckUrl;
      PayInfo.BackUrl := CS_CARDCHECK + sBackUrl;
    end;
    Exit;
  end else
  if (PayInfo.CheckUrl <> '') and (PayInfo.BackUrl <> '') then begin
    if GetTickCount > PayInfo.TimeOutTick then begin
      SendMsg(COPYMSG_CARD_TIMEOUT, IntToStr(PayInfo.PayDBInfo.ID));
      Result := True;
      Exit;
    end;
    PayInfo.DelayTick := GetTickCount + 10 * 1000;
    sBackStr := GetUrlStr(PayInfo.CheckUrl);
    //FormMain.MainOutMessage(sBackStr);
    if Pos('jumpcheck', sBackStr) > 0 then begin
      SendMsg(COPYMSG_CARD_GETKEY_FAIL, IntToStr(PayInfo.PayDBInfo.ID));
      Result := True;
    end else
    if Pos('nextpay', sBackStr) > 0 then begin
      SendMsg(COPYMSG_CARD_GETKEY_FAIL, IntToStr(PayInfo.PayDBInfo.ID));
      Result := True;
    end else
    if Pos('payfailure', sBackStr) > 0 then begin
      SendMsg(COPYMSG_CARD_IDPASS_FAIL, IntToStr(PayInfo.PayDBInfo.ID));
      Result := True;
    end else
    if Pos('jumppay', sBackStr) > 0 then begin
      SendMsg(COPYMSG_CARD_TIMEOUT, IntToStr(PayInfo.PayDBInfo.ID));
      Result := True;
    end else
    if Pos('payok', sBackStr) > 0 then begin
      sBackStr := GetUrlStr(PayInfo.BackUrl);
      SendMsg(COPYMSG_CARD_OK, IntToStr(PayInfo.PayDBInfo.ID) + '|' + sBackStr);
      Result := True;
      {Try
      List := TStringList.Create;
      List.Add(sBackStr);
      List.SaveToFile('.\' + PayInfo.PayDBInfo.payvia + '-' + FormatDateTime('yyyymmddhhmmss', Now) + '.txt');
      List.Free;
      Except

      End;   }

    end;
    Exit;
  end;
end;

function TPayGetThread.GetBeginParam(PayInfo: pTPayInfo): string;
begin
  Result := CS_ACTION + '?';
  Result := Result + 'reg_userid=' + g_PayUserID;
  Result := Result + '&servicename=' + CS_SERVICENAME;
  Result := Result + '&amount=' + IntToStr(PayInfo.PayDBInfo.price * 100);
  Result := Result + '&ymd=' + FormatDateTime('yyyymmdd', PayInfo.PayDBInfo.orderdate);
  Result := Result + '&receive_url=' + g_HTTPEncodeBackUrl;
  Result := Result + '&billno=' + PayInfo.PayDBInfo.billno;
  Result := Result + '&custom1name=' + CS_CUSTOM1NAME;
  Result := Result + '&custom2name=' + CS_CUSTOM2NAME;
  Result := Result + '&custom1=' + HTTPEncode(PayInfo.PayDBInfo.custom1);
  Result := Result + '&custom2=' + HTTPEncode(PayInfo.PayDBInfo.custom2);
  Result := Result + '&payvia=' + PayInfo.PayDBInfo.payvia;
  //Result := Result + '&paymode=testmode';
  Result := Result + '&post_md5info=' + UpperCase(GetMD5Text(
    g_PayUserID +
    IntToStr(PayInfo.PayDBInfo.price * 100) +
    FormatDateTime('yyyymmdd', PayInfo.PayDBInfo.orderdate) +
    g_PayBackUrl +
    PayInfo.PayDBInfo.billno +
    PayInfo.PayDBInfo.custom1 +
    PayInfo.PayDBInfo.custom2 +
    PayInfo.PayDBInfo.payvia +
    g_PayUserPass{ + 'testmode'}));
end;

function TPayGetThread.GetCardParam(PayInfo: pTPayInfo): string;
var
  sCardType: string;
begin
  Result := CS_CARD_ACTION + '?';
  Result := Result + 'reg_userid=' + g_PayUserID;
  Result := Result + '&servicename=' + CS_SERVICENAME;
  Result := Result + '&amount=' + IntToStr(PayInfo.PayDBInfo.price * 100);
  Result := Result + '&ymd=' + FormatDateTime('yyyymmdd', PayInfo.PayDBInfo.orderdate);
  Result := Result + '&receive_url=' + g_HTTPEncodeBackUrl;
  Result := Result + '&billno=' + PayInfo.PayDBInfo.billno;
  Result := Result + '&custom1name=' + CS_CUSTOM1NAME;
  Result := Result + '&custom2name=' + CS_CUSTOM2NAME;
  Result := Result + '&custom1=' + HTTPEncode(PayInfo.PayDBInfo.custom1);
  Result := Result + '&custom2=' + HTTPEncode(PayInfo.PayDBInfo.custom2);
  Result := Result + '&postkey=' + PayInfo.PostKey;
  Result := Result + '&jcardmoney=' + IntToStr(PayInfo.PayDBInfo.price);
  Result := Result + '&jcardno=' + PayInfo.PayDBInfo.paycardno;
  Result := Result + '&jcardpass=' + PayInfo.PayDBInfo.paycardpass;
  if PayInfo.PayDBInfo.payvia = '21' then sCardType := '25'
  else if PayInfo.PayDBInfo.payvia = '13' then sCardType := '17'
  else if PayInfo.PayDBInfo.payvia = '12' then sCardType := '16'
  else if PayInfo.PayDBInfo.payvia = '8' then sCardType := '6'
  else sCardType := '';
  Result := Result + '&cardtype=' + sCardType;
end;

function TPayGetThread.GetCardSZXParam(PayInfo: pTPayInfo): string;
begin
  Result := CS_CARD_SZX_ACTION + '?';
  Result := Result + 'reg_userid=' + g_PayUserID;
  Result := Result + '&servicename=' + CS_SERVICENAME;
  Result := Result + '&amount=' + IntToStr(PayInfo.PayDBInfo.price * 100);
  Result := Result + '&ymd=' + FormatDateTime('yyyymmdd', PayInfo.PayDBInfo.orderdate);
  Result := Result + '&receive_url=' + g_HTTPEncodeBackUrl;
  Result := Result + '&billno=' + PayInfo.PayDBInfo.billno;
  Result := Result + '&custom1name=' + CS_CUSTOM1NAME;
  Result := Result + '&custom2name=' + CS_CUSTOM2NAME;
  Result := Result + '&custom1=' + HTTPEncode(PayInfo.PayDBInfo.custom1);
  Result := Result + '&custom2=' + HTTPEncode(PayInfo.PayDBInfo.custom2);
  Result := Result + '&postkey=' + PayInfo.PostKey;
  Result := Result + '&cardmoney=' + IntToStr(PayInfo.PayDBInfo.price);
  Result := Result + '&szxcardsn=' + PayInfo.PayDBInfo.paycardno;
  Result := Result + '&szxcardpass=' + PayInfo.PayDBInfo.paycardpass;
  Result := Result + '&szxyepay=0';
end;

function TPayGetThread.GetUrlStr(sUrl: string): string;
begin
  Try
    FHTTP.CookieManager.CookieCollection.Clear;
    Result := FHTTP.Get(sUrl);
  Except
    FHTTP.Disconnect;
    Result := '';
  End;
end;

procedure TPayGetThread.Lock;
begin
  EnterCriticalSection(FCriticalSection);
end;

procedure TPayGetThread.SendMsg(nCode: Integer; sSendMsg: string);
var
  SendData: TCopyDataStruct;
begin
  SendData.cbData := Length(sSendMsg) + 1;
  GetMem(SendData.lpData, SendData.cbData);
  StrCopy(SendData.lpData, PChar(sSendMsg));
  SendMessage(g_MainHandle, WM_COPYDATA, nCode, Cardinal(@SendData));
  FreeMem(SendData.lpData);
end;

procedure TPayGetThread.UnLock;
begin
  LeaveCriticalSection(FCriticalSection);
end;

end.
