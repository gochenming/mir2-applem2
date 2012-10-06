object FrmMain: TFrmMain
  Left = 445
  Top = 167
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'FrmMain'
  ClientHeight = 133
  ClientWidth = 268
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  Menu = MainMenu
  OldCreateOrder = False
  Position = poDesigned
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 12
  object Label1: TLabel
    Left = 115
    Top = 154
    Width = 36
    Height = 12
    Caption = 'Label1'
  end
  object MemoLog: TMemo
    Left = 0
    Top = 115
    Width = 268
    Height = 119
    Align = alClient
    Color = clBlack
    Font.Charset = ANSI_CHARSET
    Font.Color = clYellow
    Font.Height = -12
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssHorizontal
    TabOrder = 0
    OnChange = MemoLogChange
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 114
    Width = 268
    Height = 19
    Panels = <
      item
        Alignment = taCenter
        Text = '????'
        Width = 45
      end
      item
        Alignment = taCenter
        Text = #26410#36830#25509
        Width = 60
      end
      item
        Alignment = taCenter
        Text = '0/0/0'
        Width = 90
      end
      item
        Alignment = taCenter
        Text = '????'
        Width = -1
      end>
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 268
    Height = 115
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    Visible = False
    object GroupBox1: TGroupBox
      Left = 0
      Top = 0
      Width = 268
      Height = 66
      Align = alTop
      Caption = #32593#32476#27969#37327
      TabOrder = 0
      object LabelReviceMsgSize: TLabel
        Left = 12
        Top = 15
        Width = 42
        Height = 12
        Caption = #25509#25910': 0'
      end
      object LabelSendBlockSize: TLabel
        Left = 12
        Top = 31
        Width = 42
        Height = 12
        Caption = #21457#36865': 0'
      end
      object LabelBufferOfM2Size: TLabel
        Left = 115
        Top = 48
        Width = 78
        Height = 12
        Caption = #26381#21153#22120#25509#25910': 0'
      end
      object LabelSelfCheck: TLabel
        Left = 12
        Top = 48
        Width = 66
        Height = 12
        Caption = #36890#36805#33258#26816': 0'
      end
      object LabelPlayMsgSize: TLabel
        Left = 115
        Top = 32
        Width = 42
        Height = 12
        Caption = #25968#25454': 0'
      end
      object LabelLogonMsgSize: TLabel
        Left = 115
        Top = 16
        Width = 42
        Height = 12
        Caption = #30331#24405': 0'
      end
      object LabelProcessMsgSize: TLabel
        Left = 203
        Top = 32
        Width = 42
        Height = 12
        Caption = #32534#30721': 0'
      end
      object LabelDeCodeMsgSize: TLabel
        Left = 203
        Top = 16
        Width = 42
        Height = 12
        Caption = #35299#30721': 0'
      end
    end
    object GroupBox2: TGroupBox
      Left = 0
      Top = 66
      Width = 268
      Height = 49
      Align = alClient
      Caption = #22788#29702#26102#38388
      TabOrder = 1
      object LabelReceTime: TLabel
        Left = 12
        Top = 15
        Width = 42
        Height = 12
        Caption = #25509#25910': 0'
      end
      object LabelSendTime: TLabel
        Left = 12
        Top = 31
        Width = 42
        Height = 12
        Caption = #21457#36865': 0'
      end
      object LabelSendLimitTime: TLabel
        Left = 100
        Top = 31
        Width = 90
        Height = 12
        Caption = #21457#36865#22788#29702#38480#21046': 0'
      end
      object LabelReviceLimitTime: TLabel
        Left = 100
        Top = 15
        Width = 90
        Height = 12
        Caption = #25509#25910#22788#29702#38480#21046': 0'
      end
      object Label14: TLabel
        Left = 213
        Top = 15
        Width = 48
        Height = 12
        Caption = #25968#25454#22788#29702
      end
      object LabelLoopTime: TLabel
        Left = 213
        Top = 31
        Width = 42
        Height = 12
        Alignment = taCenter
        AutoSize = False
        Caption = '0'
      end
    end
  end
  object ServerSocket: TServerSocket
    Active = False
    Port = 0
    ServerType = stNonBlocking
    OnListen = ServerSocketListen
    OnClientConnect = ServerSocketClientConnect
    OnClientDisconnect = ServerSocketClientDisconnect
    OnClientRead = ServerSocketClientRead
    OnClientError = ServerSocketClientError
    Left = 75
    Top = 102
  end
  object SendTimer: TTimer
    Enabled = False
    Interval = 3000
    OnTimer = SendTimerTimer
    Left = 105
    Top = 102
  end
  object ClientSocket: TClientSocket
    Active = False
    Address = '127.0.0.1'
    ClientType = ctNonBlocking
    Port = 5000
    OnConnect = ClientSocketConnect
    OnDisconnect = ClientSocketDisconnect
    OnRead = ClientSocketRead
    OnError = ClientSocketError
    Left = 45
    Top = 102
  end
  object Timer: TTimer
    OnTimer = TimerTimer
    Left = 135
    Top = 102
  end
  object DecodeTimer: TTimer
    Interval = 1
    OnTimer = DecodeTimerTimer
    Left = 195
    Top = 102
  end
  object MainMenu: TMainMenu
    Left = 223
    Top = 102
    object MENU_CONTROL: TMenuItem
      Caption = #25511#21046'(&C)'
      object MENU_CONTROL_START: TMenuItem
        Caption = #21551#21160#26381#21153'(&S)'
        Visible = False
        OnClick = MENU_CONTROL_STARTClick
      end
      object MENU_CONTROL_STOP: TMenuItem
        Caption = #20572#27490#26381#21153'(&T)'
        Visible = False
        OnClick = MENU_CONTROL_STOPClick
      end
      object MENU_CONTROL_RECONNECT: TMenuItem
        Caption = #21047#26032#36830#25509'(&R)'
        Visible = False
        OnClick = MENU_CONTROL_RECONNECTClick
      end
      object MENU_CONTROL_RELOADCONFIG: TMenuItem
        Caption = #37325#21152#36733#37197#32622'(&R)'
        OnClick = MENU_CONTROL_RELOADCONFIGClick
      end
      object MENU_CONTROL_CLEAELOG: TMenuItem
        Caption = #28165#38500#26085#24535'(&C)'
        OnClick = MENU_CONTROL_CLEAELOGClick
      end
      object N1: TMenuItem
        Caption = #31105#27490#36830#25509'(&F)'
        OnClick = N1Click
      end
      object MENU_CONTROL_EXIT: TMenuItem
        Caption = #36864#20986'(&E)'
        OnClick = MENU_CONTROL_EXITClick
      end
    end
    object V1: TMenuItem
      Caption = #26597#30475'(&V)'
      object I2: TMenuItem
        Caption = #35814#32454#20449#24687'(&I)'
        OnClick = I2Click
      end
      object G1: TMenuItem
        Caption = #20840#23616#20250#35805'(&G)'
        OnClick = G1Click
      end
    end
    object MENU_OPTION: TMenuItem
      Caption = #36873#39033'(&O)'
      object MENU_OPTION_GENERAL: TMenuItem
        Caption = #22522#26412#35774#32622'(&G)'
        OnClick = MENU_OPTION_GENERALClick
      end
      object MENU_OPTION_PERFORM: TMenuItem
        Caption = #24615#33021#35774#32622'(&P)'
        OnClick = MENU_OPTION_PERFORMClick
      end
      object MENU_OPTION_IPFILTER: TMenuItem
        Caption = #23433#20840#36807#28388'(&S)'
        OnClick = MENU_OPTION_IPFILTERClick
      end
    end
    object H1: TMenuItem
      Caption = #24110#21161'(&H)'
      object I1: TMenuItem
        Caption = #20851#20110'(&I)'
        OnClick = I1Click
      end
    end
  end
  object StartTimer: TTimer
    Interval = 200
    OnTimer = StartTimerTimer
    Left = 165
    Top = 102
  end
  object CenterSocket: TClientSocket
    Active = False
    Address = '127.0.0.1'
    ClientType = ctNonBlocking
    Port = 5600
    OnConnect = CenterSocketConnect
    OnDisconnect = CenterSocketDisconnect
    OnRead = CenterSocketRead
    OnError = CenterSocketError
    Left = 13
    Top = 102
  end
end
