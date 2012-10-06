object FormMain: TFormMain
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #28216#25103#26381#21153#31471#31649#29702#31243#24207' 20110505'
  ClientHeight = 357
  ClientWidth = 552
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 12
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 241
    Height = 341
    Caption = #25991#20214#21015#34920
    TabOrder = 0
    object tvFileList: TTreeView
      Left = 7
      Top = 17
      Width = 225
      Height = 312
      Color = clBlack
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clYellow
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
      Indent = 19
      ParentFont = False
      ReadOnly = True
      TabOrder = 0
    end
  end
  object GroupBox2: TGroupBox
    Left = 255
    Top = 8
    Width = 290
    Height = 105
    Caption = #22522#26412#35774#32622
    TabOrder = 1
    object Label1: TLabel
      Left = 8
      Top = 49
      Width = 54
      Height = 12
      Caption = #36890#20449#23494#30721':'
    end
    object Label2: TLabel
      Left = 8
      Top = 75
      Width = 54
      Height = 12
      Caption = #20801#35768#22320#22336':'
    end
    object Label3: TLabel
      Left = 8
      Top = 23
      Width = 54
      Height = 12
      Caption = #36890#20449#31471#21475':'
    end
    object edPass: TEdit
      Left = 68
      Top = 46
      Width = 121
      Height = 20
      TabOrder = 0
      OnChange = edPassChange
    end
    object btSetPassWord: TButton
      Left = 195
      Top = 45
      Width = 88
      Height = 21
      Caption = #29983#25104#23494#30721'(&P)'
      TabOrder = 1
      OnClick = btSetPassWordClick
    end
    object cbAddrs: TComboBox
      Left = 68
      Top = 72
      Width = 121
      Height = 20
      ItemHeight = 12
      TabOrder = 2
      Text = 'cbAddrs'
    end
    object btAddAddrs: TButton
      Left = 195
      Top = 71
      Width = 41
      Height = 21
      Caption = #22686#21152
      TabOrder = 3
      OnClick = btAddAddrsClick
    end
    object btDelAddrs: TButton
      Left = 242
      Top = 71
      Width = 41
      Height = 21
      Caption = #21024#38500
      TabOrder = 4
      OnClick = btDelAddrsClick
    end
    object edPort: TEdit
      Left = 68
      Top = 20
      Width = 121
      Height = 20
      TabOrder = 5
      Text = '18888'
      OnChange = edPortChange
    end
    object btStateServer: TButton
      Left = 195
      Top = 19
      Width = 88
      Height = 21
      Caption = #21551#21160#26381#21153'(&S)'
      TabOrder = 6
      OnClick = btStateServerClick
    end
  end
  object GroupBox3: TGroupBox
    Left = 255
    Top = 119
    Width = 290
    Height = 230
    Caption = #26085#24535#31383#21475
    TabOrder = 2
    object mmoLog: TMemo
      Left = 8
      Top = 17
      Width = 273
      Height = 201
      Color = clBlack
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clYellow
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
      Lines.Strings = (
        'mmoLog')
      ParentFont = False
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 0
    end
  end
  object SSocket: TServerSocket
    Active = False
    Address = '0.0.0.0'
    Port = 18888
    ServerType = stNonBlocking
    OnListen = SSocketListen
    OnClientConnect = SSocketClientConnect
    OnClientDisconnect = SSocketClientDisconnect
    OnClientRead = SSocketClientRead
    OnClientError = SSocketClientError
    Left = 24
    Top = 32
  end
  object ApplicationEvents: TApplicationEvents
    OnException = ApplicationEventsException
    Left = 56
    Top = 32
  end
  object DecodeTimer: TTimer
    Enabled = False
    Interval = 1
    OnTimer = DecodeTimerTimer
    Left = 88
    Top = 32
  end
  object Timer: TTimer
    Enabled = False
    OnTimer = TimerTimer
    Left = 120
    Top = 32
  end
end
