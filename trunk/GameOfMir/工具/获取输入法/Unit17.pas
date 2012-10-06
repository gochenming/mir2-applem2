unit Unit17;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, iMM,
  Dialogs, StdCtrls;

type
  TForm17 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Button1: TButton;
    Button2: TButton;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    procedure OnWM_INPUTLANGCHANGE(var WMessage: TMessage); message WM_INPUTLANGCHANGE;
    procedure OnWM_INPUTLANGCHANGEREQUEST(var WMessage: TMessage); message WM_INPUTLANGCHANGEREQUEST;
    procedure OnWM_IME_NOTIFY(var WMessage: TMessage); message WM_IME_NOTIFY;
    procedure OnWM_IME_COMPOSITION(var WMessage: TMessage); message WM_IME_COMPOSITION;
    procedure OnWM_IME_STARTCOMPOSITION(var WMessage: TMessage); message WM_IME_STARTCOMPOSITION;
    procedure OnWM_IME_ENDCOMPOSITION(var WMessage: TMessage); message WM_IME_ENDCOMPOSITION;
    procedure OnWM_IME_SETCONTEXT(var WMessage: TMessage); message WM_IME_SETCONTEXT;


    //procedure WinMessage(var Msg: TMsg; var Handled: Boolean);

  end;

var
  Form17: TForm17;
  m_strCandList: string;
  dmyhkl:hkl;

implementation

{$R *.dfm}

{ TForm17 }
            //SendMessage(Handle,WM_SYSCOMMAND,SC_MINIMIZE,0);
function GetCandList(WinHandle: HWND): boolean;
var
  hHimc: HIMC;
  dwSize, i: Integer;
  pcan: PCandidateList;
  temp: array of tagCANDIDATELIST;
  pstr: PChar;
begin
  Result := False;
  m_strCandList := '';
  if GetKeyboardLayout(0) = 0 then
    Exit;
  hHimc := ImmGetContext(WinHandle); //取得输入上下文
  if hHimc = 0 then
    Exit;
  {getmem(pstr, 256);
  fillchar(pstr^, 256, #0);
  dwSize := ImmGetGuideLine(hHimc, 0, pstr, 255);
  edit3.Text:= edit3.Text + strpas(pstr);
  freemem(pstr); }
  {dwSize := ImmGetCompositionString(hHimc, GCS_COMPREADSTR, nil, 0);
  getmem(pstr, dwsize + 1);
  fillchar(pstr^, dwsize + 1, #0);
  dwSize := ImmGetCompositionString(hHimc, GCS_COMPREADSTR, pstr, dwSize);
  edit3.Text:= strpas(pstr);
  freemem(pstr);        }
  dwSize := ImmGetCandidateList(hHimc, 0, nil, 0);
  if dwSize > 0 then
  begin
    SetLength(temp, dwSize);
    pcan := @temp[0];
    ImmGetCandidateList(hHimc, 0, pcan, dwSize);
    if pcan.dwCount > 0 then
    begin
      i := 1;
      m_strCandList := '';
      while (i <= pcan.dwCount - pcan.dwSelection) and (i < pcan.dwPageSize + 1) do
      begin
        m_strCandList := m_strCandList + ' ' + Format('%d.%s', [i, PChar(PChar(pcan) +
            pcan.dwOffset[pcan.dwSelection + i])]);
        i := i + 1;
      end;
    end
    else
      m_strCandList := '';
  end;
  ImmReleaseContext(WinHandle, hHimc);
  Result := True;
end;

procedure TForm17.Button1Click(Sender: TObject);
begin
  dmyhkl := GetKeyBoardLayOut(0); //获取当前输入法
end;

procedure TForm17.Button2Click(Sender: TObject);
var
  CandidateForm: TCandidateForm;
  hIMC: Integer;
begin
  //activatekeyboardlayout(dmyhkl, KLF_ACTIVATE);//设置相应的输入法
  SetCaretPos(10, 10);
  ShowCaret(Handle);
  {hIMC := ImmGetContext(Handle);
  ImmGetCandidateWindow(hIMC, @CandidateForm);
  CandidateForm.ptCurrentPos.X := 100;
  CandidateForm.ptCurrentPos.Y := 200;
  ImmSetCandidateWindow(hIMC, @CandidateForm);  }
end;

procedure TForm17.FormCreate(Sender: TObject);
begin
  //Application.OnMessage := WinMessage;
  //CreateCaret(Handle, 0, 2, 10);
  //ShowCaret(Handle);
end;

procedure TForm17.FormKeyPress(Sender: TObject; var Key: Char);
var
  H: HIMC;
  CForm: TCompositionForm;
  LFont: TLogFont;
begin
  H := Imm32GetContext(Handle);
  if H <> 0 then
  begin
    with CForm do
    begin
      dwStyle := CFS_POINT;
      ptCurrentPos.x := Label4.Left + Label4.Canvas.TextWidth(Label4.Caption);
      ptCurrentPos.y := Label4.Top;
    end;
    Imm32SetCompositionWindow(H, @CForm);
    {if Assigned(Font) then
    begin
      GetObject(Font.Handle, SizeOf(TLogFont), @LFont);
      Imm32SetCompositionFont(H, @LFont);
    end;        }
    Imm32ReleaseContext(Handle, H);
  end;
  Label4.Caption := Label4.Caption + Key;
end;

procedure TForm17.OnWM_IME_COMPOSITION(var WMessage: TMessage);
var
  hkl: Integer;
  hIMC: Integer;
  pstr: PChar;
  dwSize: Integer;
begin
  //hkl := GetKeyboardLayout(0);
  //if ImmIsIME(hKL) then begin
  if (WMessage.LParam and GCS_RESULTSTR) <> 0 then begin
  inherited;
  end else begin

  hIMC := ImmGetContext(Handle);
  dwSize := ImmGetCompositionString( hIMC, GCS_COMPREADSTR, nil, 0);
  getmem(pstr, dwsize + 1);
  fillchar(pstr^, dwsize + 1, #0);
  dwSize := ImmGetCompositionString( hIMC, GCS_COMPREADSTR, pstr, dwSize);
  label2.Caption := strpas(pstr);
  freemem(pstr);
  ImmReleaseContext(Handle, hIMC);
  //WMessage.Result := 1;
  inherited;
  end;
  //end;
  //WMessage.Result := 0;

end;

procedure TForm17.OnWM_IME_ENDCOMPOSITION(var WMessage: TMessage);
begin
  {label2.Caption := '';
  WMessage.Result := 1;  }
  inherited;
end;

procedure TForm17.OnWM_IME_NOTIFY(var WMessage: TMessage);
var
  hkl: Integer;
  hIMC: Integer;
  pstr: PChar;
  dwSize: Integer;
begin
  m_strCandList := '';
  case wMessage.WParam of
    IMN_CHANGECANDIDATE, IMN_OPENCANDIDATE: begin
      GetCandList(Handle);

    end;
  end;
  label3.Caption := m_strCandList;
  //WMessage.Result := 1;
  inherited;
end;

procedure TForm17.OnWM_IME_SETCONTEXT(var WMessage: TMessage);
begin
  {WMessage.WParam := 0;
  WMessage.LParam := 0;
  WMessage.Result := 1;   }
  inherited;
  //WMessage.Result := DefWindowProc(Handle, WM_IME_SETCONTEXT, 0, 0);
end;

procedure TForm17.OnWM_IME_STARTCOMPOSITION(var WMessage: TMessage);
begin
  {label2.Caption := '';
  WMessage.Result := 1;   }
  inherited;
end;    

procedure TForm17.OnWM_INPUTLANGCHANGE(var WMessage: TMessage);  //ime改变
var
  hkl: Integer;
  hIMC: Integer;
  pstr: PChar;
begin

  hkl := GetKeyboardLayout(0);
  if ImmIsIME(hKL) then begin
    hIMC := ImmGetContext(Handle);
    GetMem(pstr, 256);
    FillChar(pstr^, 256, #0);
    ImmEscape( hKL, hIMC, IME_ESC_IME_NAME, pstr);//取得新输入法名字
    Label1.Caption := strpas(pstr);
    Freemem(pstr);
    //ImmGetConversionStatus( hIMC, &dwConversion, &dwSentence );
        //g_bImeSharp = ( dwConversion & IME_CMODE_FULLSHAPE )? true : false;//取得全角标志
        //g_bImeSymbol = ( dwConversion & IME_CMODE_SYMBOL )? true : false;//取得中文标点标志
    ImmReleaseContext(Handle, hIMC );
  end else begin
    Label1.Caption := '';
  end;

  inherited;
end;

procedure TForm17.OnWM_INPUTLANGCHANGEREQUEST(var WMessage: TMessage);
begin
  inherited;  //禁用输入法的话，直接过滤这个
  //return !g_bIme;//如果禁止ime则返回false，此时窗口函数应返回0，否则DefWindowProc会打开输入法
end;
{
procedure TForm17.WinMessage(var Msg: TMsg; var Handled: Boolean);
begin
  case Msg.message of
    WM_CONVERTREQUESTEX..WM_IME_KEYLAST,
    WM_IME_SETCONTEXT..WM_IME_CHAR,
    WM_IME_KEYDOWN..WM_IME_KEYUP: begin
      self.Caption := Caption + Inttostr(msg.message) +  '+';
      //showmessage(Inttostr(msg.message));
      //ListBox1.Items.Add(Inttostr(msg.message))
      //Memo1.Lines.Add(Inttostr(msg.message));
    end;
  end;
end;       }

{
procedure TForm17.WMCOMPOSITION(var WMessage: TMessage);
var
  dwSize: Integer;
  pstr: PChar;
  hHimc: HIMC;
begin
  if GetKeyboardLayout(0) = 0 then
    Exit;
  hHimc := ImmGetContext(Handle); //取得输入上下文
  if hHimc = 0 then
    Exit;
  dwSize := ImmGetCompositionString(hHimc, GCS_COMPREADSTR, nil, 0);
  getmem(pstr, dwsize + 1);
  fillchar(pstr^, dwsize + 1, #0);
  dwSize := ImmGetCompositionString(hHimc, GCS_COMPREADSTR, pstr, dwSize);
  label1.Caption := strpas(pstr);
  freemem(pstr);
  WMessage.Result := 1;
  ImmReleaseContext(Handle, hHimc);
end;
   {
procedure TForm17.WMINPUTLANGCHANGEREQUEST(var WMessage: TMessage);
begin
  WMessage.Result := 0;
end;

procedure TForm17.WMTabKey(var WMessage: TMessage);
begin
  //showmessage('aaa');
  //WMessage.Result := 0;
end;
  {
procedure TForm17.WMWM_IME_NOTIFY(var WMessage: TMessage);
begin
  WMessage.Result := 1;
end;    }

end.
