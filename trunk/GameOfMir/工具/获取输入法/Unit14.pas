unit Unit14;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, imm, StdCtrls;

type
  TForm14 = class(TForm)
    Edit1: TEdit;
    Edit2: TEdit;
    Memo1: TMemo;
    Button1: TButton;
    Button2: TButton;
    Edit3: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    procedure WinMessage(var Msg: TMsg; var Handled: Boolean);
    function GetCandList(WinHandle: HWND): boolean;

  end;

var
  Form14: TForm14;
  m_strCandList: string;

implementation

{$R *.dfm}

{ TForm14 }

function FiltrateChar(Char1, Char2: Byte): Boolean;
begin
  Result := False;
  case Char1 of
    32..126: Result := Char2 = 0;
    129..160, 176..214, 216..247: Result := (Char2 in [64..126, 128..254]);
    161: Result := (Char2 in [162..254]);
    162: Result := (Char2 in [161..170, 177..226, 229..238, 241..252]);
    163: Result := (Char2 in [161..254]);
    164: Result := (Char2 in [161..243]);
    165: Result := (Char2 in [161..246]);
    166: Result := (Char2 in [161..184, 193..216, 224..235, 238..242, 244, 245]);
    167: Result := (Char2 in [161..193, 209..241]);
    168: Result := (Char2 in [64..126, 128..149, 161..187, 189, 190, 192, 197..233]);
    169: Result := (Char2 in [64..90, 92, 96..126, 128..136, 150, 164..239]);
    170..175, 248..253: Result := (Char2 in [64..126, 128..160]);
    215: Result := (Char2 in [64..126, 128..249]);
    254: Result := (Char2 in [64..79]); 
  end;
  {case Char1 of
    129..160, 176..214, 216..247: Result := (Char2 in [64..126, 128..254]);
    161: Result := (Char2 in [162..254]);
    162: Result := (Char2 in [161..170, 177..226, 229..238, 241..252]);
    163: Result := (Char2 in [161..254]);
    164: Result := (Char2 in [161..243]);
    165: Result := (Char2 in [161..246]);
    166: Result := (Char2 in [161..184, 193..216, 224..235, 238..240]);
    167: Result := (Char2 in [161..193, 209..241]);
    168: Result := (Char2 in [64..126, 128..149, 161..187, 197..233]);
    169: Result := (Char2 in [64..126, 128..87, 96..136, 164..239]);
    170..175, 248..253: Result := (Char2 in [64..126, 128..160]);
    215: Result := (Char2 in [64..126, 128..249]);
    254: Result := (Char2 in [64..79]);
  end;    }
 { case Char1 of
    129..160, 176..214, 216..247: Result := (Char2 in [64..126]);
    161: Result := (Char2 in [162..254]);
    162: Result := (Char2 in [161..170, 177..226, 229..238, 241..252]);
    163: Result := (Char2 in [161..254]);
    164: Result := (Char2 in [161..243]);
    165: Result := (Char2 in [161..246]);
    166: Result := (Char2 in [161..184, 193..216, 224..235, 238..240]);
    167: Result := (Char2 in [161..193, 209..241]);
    168: Result := (Char2 in [64..126]);
    169: Result := (Char2 in [64..126]);
    170..175, 248..253: Result := (Char2 in [64..126]);
    215: Result := (Char2 in [64..126]);
    254: Result := (Char2 in [64..79]);
  end;   }
end;

procedure TForm14.Button1Click(Sender: TObject);
var
  I: Integer;
  test: string;
  x: Integer;
begin
  memo1.Lines.Clear;
  test := '';
  x := 0;
  for I := 0 to 65535 do begin
    if FiltrateChar(LoByte(Word(I)), HiByte(Word(I))) then begin
      //if (HiByte(Word(I)) in [$A1..$FF]) and (LoByte(Word(I)) in [$A1..$FF]) then begin
      if LoByte(I) in [32..126] then test := test + Char(LoByte(I))
      else test := test + Char(LoByte(I)) + Char(HiByte(I));
        //test := test + Char(LoByte(I)) + Char(HiByte(I)) {+ IntToHex(i, 0)};
        inc(x);
      //end;
    end;
  end;
  self.Caption := Inttostr(x);
  memo1.Lines.Add(test);
end;

procedure TForm14.Button2Click(Sender: TObject);
var
  str: WideString;
  sstr: string;
  i, X: integer;
  nHeight, nWidth: Integer;
  test: array[0..5] of char;
begin
  sstr := '中，';
  move(sstr[1], test[0], 4);
  showmessage(test);
  exit;
  str := Memo1.Lines.GetText;
  str := Trim(str);
  nHeight := 0;
  nWidth := 0;

 { for I := 1 to length(str) do begin
    sstr := str[i];
    X := Canvas.TextWidth(sstr);
    if x > nWidth then nWidth := X;
    X := Canvas.TextHeight(sstr);
    if X > nHeight then nHeight := X;
  end;
  Caption := Inttostr(nWidth) + '*' + Inttostr(nHeight); }
  showmessage(inttostr(length(str)));

end;

procedure TForm14.FormCreate(Sender: TObject);
begin
  Application.OnMessage := WinMessage;
end;

function TForm14.GetCandList(WinHandle: HWND): boolean;
var
  hHimc: HIMC;
  dwSize, i: Integer;
  pcan: PCandidateList;
  temp: array of tagCANDIDATELIST;
  pstr: PChar;
begin
  Result := False;
  m_strCandList := '';
  edit2.Text := m_strCandList;
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
  dwSize := ImmGetCompositionString(hHimc, GCS_COMPREADSTR, nil, 0);
  getmem(pstr, dwsize + 1);
  fillchar(pstr^, dwsize + 1, #0);
  dwSize := ImmGetCompositionString(hHimc, GCS_COMPREADSTR, pstr, dwSize);
  edit3.Text:= strpas(pstr);
  freemem(pstr);
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
  edit2.Text := m_strCandList;
end;

procedure TForm14.WinMessage(var Msg: TMsg; var Handled: Boolean);
begin
  case Msg.message of
    {WM_INPUTLANGCHANGE: begin   //改变输入法
      msg.wParam := 0;
      msg.lParam := 0;
    end;
    WM_IME_SETCONTEXT: begin


      msg.wParam := 0;
      msg.lParam := 0;
      DefWindowProc(Edit1.Handle, WM_IME_SETCONTEXT, msg.wParam, msg.lParam);
    end;  }
    WM_IME_COMPOSITION: begin
      GetCandList(Msg.hwnd);
    end;
    WM_IME_ENDCOMPOSITION,
    WM_IME_STARTCOMPOSITION: begin
      edit2.Text := '';
//      Handled:= True;         //隐藏输入框的
    end;
    //WM_IME_SETCONTEXT,
    WM_IME_CONTROL,
    WM_IME_COMPOSITIONFULL,
    WM_IME_SELECT,
    WM_IME_CHAR: begin
      edit2.Text := '';
    end;
    WM_IME_NOTIFY:
      begin
        case Msg.wParam of
          IMN_OPENCANDIDATE: begin
            edit2.Text := '';
            msg.pt.X := 0;
            msg.pt.Y := 0;
            GetCandList(Msg.hwnd);
            //Handled:= True;    //隐藏原始输入法列表界面
          end;
          IMN_CHANGECANDIDATE: begin
            GetCandList(Msg.hwnd);
          end;
          IMN_CLOSECANDIDATE:
            begin
              m_strCandList := '';
              edit2.Text := '';
            end;
          IMN_SETCOMPOSITIONWINDOW: begin
            GetCandList(Msg.hwnd);
              //m_strCandList := '';
              //edit2.Text := '';
              //Handled := True;
          end;
          IMN_CLOSESTATUSWINDOW: begin
            edit2.Text := 'a';
          end;
          else begin
            showmessage(inttostr(Msg.wParam));
          end;
        end;
      end;
  end;
end;

end.

