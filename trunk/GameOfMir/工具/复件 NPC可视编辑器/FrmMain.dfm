object FormMain: TFormMain
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'NPC'#21487#35270#32534#36753#22120
  ClientHeight = 649
  ClientWidth = 1168
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 12
  object lbl1: TLabel
    Left = 839
    Top = 448
    Width = 24
    Height = 12
    Caption = 'lbl1'
  end
  object lbl2: TLabel
    Left = 839
    Top = 463
    Width = 24
    Height = 12
    Caption = 'lbl1'
  end
  object lbl3: TLabel
    Left = 839
    Top = 480
    Width = 24
    Height = 12
    Caption = 'lbl1'
  end
  object lbl4: TLabel
    Left = 839
    Top = 495
    Width = 24
    Height = 12
    Caption = 'lbl1'
  end
  object lbl5: TLabel
    Left = 839
    Top = 512
    Width = 24
    Height = 12
    Caption = 'lbl1'
  end
  object lbl6: TLabel
    Left = 839
    Top = 527
    Width = 24
    Height = 12
    Caption = 'lbl1'
  end
  object lbl7: TLabel
    Left = 839
    Top = 544
    Width = 24
    Height = 12
    Caption = 'lbl1'
  end
  object lbl8: TLabel
    Left = 839
    Top = 559
    Width = 24
    Height = 12
    Caption = 'lbl1'
  end
  object lbl9: TLabel
    Left = 839
    Top = 577
    Width = 24
    Height = 12
    Caption = 'lbl1'
  end
  object lbl10: TLabel
    Left = 839
    Top = 592
    Width = 24
    Height = 12
    Caption = 'lbl1'
  end
  object lbl11: TLabel
    Left = 839
    Top = 609
    Width = 24
    Height = 12
    Caption = 'lbl1'
  end
  object lbl12: TLabel
    Left = 839
    Top = 624
    Width = 24
    Height = 12
    Caption = 'lbl1'
  end
  object lbl13: TLabel
    Left = 921
    Top = 448
    Width = 24
    Height = 12
    Caption = 'lbl1'
  end
  object lbl14: TLabel
    Left = 921
    Top = 463
    Width = 24
    Height = 12
    Caption = 'lbl1'
  end
  object lbl15: TLabel
    Left = 921
    Top = 480
    Width = 24
    Height = 12
    Caption = 'lbl1'
  end
  object lbl16: TLabel
    Left = 921
    Top = 495
    Width = 24
    Height = 12
    Caption = 'lbl1'
  end
  object lbl17: TLabel
    Left = 921
    Top = 512
    Width = 24
    Height = 12
    Caption = 'lbl1'
  end
  object lbl18: TLabel
    Left = 921
    Top = 527
    Width = 24
    Height = 12
    Caption = 'lbl1'
  end
  object lbl19: TLabel
    Left = 921
    Top = 544
    Width = 24
    Height = 12
    Caption = 'lbl1'
  end
  object lbl20: TLabel
    Left = 921
    Top = 559
    Width = 24
    Height = 12
    Caption = 'lbl1'
  end
  object lbl21: TLabel
    Left = 921
    Top = 577
    Width = 24
    Height = 12
    Caption = 'lbl1'
  end
  object lbl22: TLabel
    Left = 921
    Top = 592
    Width = 24
    Height = 12
    Caption = 'lbl1'
  end
  object lbl23: TLabel
    Left = 921
    Top = 609
    Width = 24
    Height = 12
    Caption = 'lbl1'
  end
  object lbl24: TLabel
    Left = 921
    Top = 624
    Width = 24
    Height = 12
    Caption = 'lbl1'
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 825
    Height = 633
    Caption = #23454#38469#25928#26524
    TabOrder = 0
    object PanelBG: TPanel
      Left = 12
      Top = 18
      Width = 800
      Height = 600
      Caption = 'PanelBG'
      TabOrder = 0
      OnMouseDown = PanelBGMouseDown
      OnMouseMove = PanelBGMouseMove
      OnMouseUp = PanelBGMouseUp
    end
  end
  object GroupBox2: TGroupBox
    Left = 839
    Top = 8
    Width = 321
    Height = 411
    Caption = #36755#20837#20869#23481
    TabOrder = 1
    object Label4: TLabel
      Left = 9
      Top = 298
      Width = 300
      Height = 16
      Alignment = taCenter
      AutoSize = False
    end
    object Label3: TLabel
      Left = 9
      Top = 305
      Width = 300
      Height = 19
      Alignment = taCenter
      AutoSize = False
      Caption = #25991#23383#39068#33394' ABCDEFG 123456'
    end
    object MemoText: TMemo
      Left = 9
      Top = 22
      Width = 300
      Height = 274
      Lines.Strings = (
        'MemoText')
      ScrollBars = ssBoth
      TabOrder = 0
      OnChange = MemoTextChange
      OnKeyDown = MemoTextKeyDown
    end
    object ScrollBar1: TScrollBar
      Left = 9
      Top = 326
      Width = 300
      Height = 17
      Max = 255
      PageSize = 0
      TabOrder = 1
      OnChange = ScrollBar1Change
    end
    object ScrollBar2: TScrollBar
      Left = 9
      Top = 349
      Width = 300
      Height = 17
      Max = 255
      PageSize = 0
      Position = 255
      TabOrder = 2
      OnChange = ScrollBar1Change
    end
    object scrbr1: TScrollBar
      Left = 9
      Top = 372
      Width = 300
      Height = 17
      Max = 255
      PageSize = 0
      Position = 255
      TabOrder = 3
    end
  end
  object chk1: TCheckBox
    Left = 839
    Top = 425
    Width = 50
    Height = 17
    Caption = 'chk1'
    TabOrder = 2
  end
  object chk2: TCheckBox
    Left = 895
    Top = 425
    Width = 50
    Height = 17
    Caption = 'chk1'
    TabOrder = 3
    OnClick = chk2Click
  end
  object se1: TSpinEdit
    Left = 951
    Top = 425
    Width = 66
    Height = 21
    MaxValue = 0
    MinValue = 0
    TabOrder = 4
    Value = 0
  end
  object se2: TSpinEdit
    Left = 1023
    Top = 425
    Width = 66
    Height = 21
    MaxValue = 0
    MinValue = 0
    TabOrder = 5
    Value = 0
    OnChange = se2Change
  end
  object chk3: TCheckBox
    Left = 951
    Top = 452
    Width = 114
    Height = 17
    Caption = #25130#21462#25351#23450#20301#32622
    TabOrder = 6
    OnClick = chk3Click
  end
  object se3: TSpinEdit
    Left = 951
    Top = 471
    Width = 66
    Height = 21
    MaxValue = 0
    MinValue = 0
    TabOrder = 7
    Value = 0
    OnChange = chk3Click
  end
  object se4: TSpinEdit
    Left = 951
    Top = 498
    Width = 66
    Height = 21
    MaxValue = 0
    MinValue = 0
    TabOrder = 8
    Value = 0
    OnChange = chk3Click
  end
  object se5: TSpinEdit
    Left = 1031
    Top = 471
    Width = 66
    Height = 21
    MaxValue = 0
    MinValue = 0
    TabOrder = 9
    Value = 0
    OnChange = chk3Click
  end
  object se6: TSpinEdit
    Left = 1031
    Top = 498
    Width = 66
    Height = 21
    MaxValue = 0
    MinValue = 0
    TabOrder = 10
    Value = 0
    OnChange = chk3Click
  end
  object chk4: TCheckBox
    Left = 1095
    Top = 425
    Width = 50
    Height = 17
    Caption = 'chk1'
    TabOrder = 11
  end
  object se7: TSpinEdit
    Left = 1103
    Top = 448
    Width = 51
    Height = 21
    MaxValue = 0
    MinValue = 0
    TabOrder = 12
    Value = 0
  end
  object Device: TDX9Device
    Width = 300
    Height = 344
    BitDepth = bdLow
    Refresh = 0
    Windowed = True
    VSync = False
    HardwareTL = True
    LockBackBuffer = True
    DepthBuffer = True
    WindowHandle = 0
    OnInitialize = DeviceInitialize
    OnFinalize = DeviceFinalize
    OnRender = DeviceRender
    AutoInitialize = False
    Left = 24
    Top = 40
  end
  object TimerDraw: TTimer
    Enabled = False
    Interval = 10
    OnTimer = TimerDrawTimer
    Left = 56
    Top = 40
  end
end
