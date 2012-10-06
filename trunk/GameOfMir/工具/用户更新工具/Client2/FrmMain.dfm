object FormMain: TFormMain
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = '361M2'#19979#36733#24037#20855' V1.0'
  ClientHeight = 314
  ClientWidth = 559
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poDesktopCenter
  OnActivate = FormActivate
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object ListView1: TListView
    Left = 0
    Top = 0
    Width = 374
    Height = 295
    Align = alClient
    Columns = <
      item
        Caption = #25991#20214#21517#31216
        Width = 150
      end
      item
        Caption = #25991#20214#22823#23567
        Width = 70
      end
      item
        Caption = #26356#26032#26102#38388
        Width = 130
      end>
    GridLines = True
    ReadOnly = True
    RowSelect = True
    PopupMenu = PopupMenu1
    TabOrder = 0
    ViewStyle = vsReport
    ExplicitHeight = 215
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 295
    Width = 559
    Height = 19
    Panels = <
      item
        Text = #23578#26410#30331#24405
        Width = -1
      end>
    ExplicitTop = 215
  end
  object Panel1: TPanel
    Left = 374
    Top = 0
    Width = 185
    Height = 295
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 2
    ExplicitHeight = 215
    object MemoHint: TMemo
      Left = 0
      Top = 0
      Width = 185
      Height = 295
      Align = alClient
      BevelOuter = bvRaised
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
      ExplicitHeight = 215
    end
  end
  object MainMenu1: TMainMenu
    Left = 40
    Top = 40
    object httpwww361m2com1: TMenuItem
      Caption = 'http://www.361m2.com'
      OnClick = httpwww361m2com1Click
    end
  end
  object CSocket: TClientSocket
    Active = False
    ClientType = ctNonBlocking
    Host = 'check.361m2.net'
    Port = 9000
    OnConnect = CSocketConnect
    OnDisconnect = CSocketDisconnect
    OnRead = CSocketRead
    OnError = CSocketError
    Left = 8
    Top = 40
  end
  object PopupMenu1: TPopupMenu
    OnPopup = PopupMenu1Popup
    Left = 72
    Top = 40
    object D1: TMenuItem
      Caption = #19979#36733#25991#20214'(&D)'
      OnClick = D1Click
    end
  end
  object KeepTimer: TTimer
    Enabled = False
    Interval = 30000
    OnTimer = KeepTimerTimer
    Left = 104
    Top = 40
  end
  object DownTimer: TTimer
    Enabled = False
    Interval = 5000
    OnTimer = DownTimerTimer
    Left = 136
    Top = 40
  end
  object DownLoginTimer: TTimer
    Enabled = False
    Interval = 5000
    OnTimer = DownLoginTimerTimer
    Left = 168
    Top = 40
  end
end
