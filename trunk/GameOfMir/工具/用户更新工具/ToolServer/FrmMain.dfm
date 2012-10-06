object FormMain: TFormMain
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #29992#25143#20849#20139#26381#21153#31471' V1.3'
  ClientHeight = 244
  ClientWidth = 440
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 425
    Height = 209
    Caption = #26085#24535#31383#21475
    TabOrder = 0
    object MemoLog: TMemo
      Left = 9
      Top = 16
      Width = 407
      Height = 186
      Color = clBlack
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clYellow
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
      Lines.Strings = (
        'Memo1')
      ParentFont = False
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 0
    end
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 225
    Width = 440
    Height = 19
    Panels = <
      item
        Alignment = taCenter
        Text = '7700'
        Width = 40
      end
      item
        Alignment = taCenter
        Text = '[0]'
        Width = 30
      end
      item
        Width = 50
      end>
  end
  object MainMenu1: TMainMenu
    Left = 24
    Top = 48
    object O1: TMenuItem
      Caption = #36873#39033'(&O)'
      object R1: TMenuItem
        Caption = #37325#26032#21152#36733#36807#28388#21517#21333'(&R)'
      end
      object V1: TMenuItem
        Caption = #26597#30475#19978#20256#21015#34920'(&V)'
        OnClick = V1Click
      end
    end
    object H1: TMenuItem
      Caption = #24110#21161'(&H)'
      object A2: TMenuItem
        Caption = #20851#20110'(&A)'
      end
    end
  end
  object ShareRSA: TRSA
    CommonalityKey = '438932551'
    CommonalityMode = '430722197387646401855452920803'
    PrivateKey = '1'
    Left = 56
    Top = 48
  end
  object SSocket: TServerSocket
    Active = False
    Address = '0.0.0.0'
    Port = 9900
    ServerType = stNonBlocking
    OnListen = SSocketListen
    OnClientConnect = SSocketClientConnect
    OnClientDisconnect = SSocketClientDisconnect
    OnClientRead = SSocketClientRead
    OnClientError = SSocketClientError
    Left = 88
    Top = 48
  end
  object ADOQuery: TADOQuery
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=.\DB.mdb;Persist Se' +
      'curity Info=False'
    Parameters = <>
    SQL.Strings = (
      'sql')
    Left = 120
    Top = 48
  end
  object ApplicationEvents1: TApplicationEvents
    OnException = ApplicationEvents1Exception
    Left = 152
    Top = 48
  end
  object StateTimer: TTimer
    Interval = 500
    OnTimer = StateTimerTimer
    Left = 184
    Top = 48
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 1
    OnTimer = Timer1Timer
    Left = 216
    Top = 48
  end
  object Timer2: TTimer
    OnTimer = Timer2Timer
    Left = 248
    Top = 48
  end
end
