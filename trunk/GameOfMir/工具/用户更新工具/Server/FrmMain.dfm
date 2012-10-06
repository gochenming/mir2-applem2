object FormMain: TFormMain
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = '361M2'#26381#21153#31471#31649#29702#24037#20855' V1.9'
  ClientHeight = 241
  ClientWidth = 440
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
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
    Top = 222
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
        Text = ' '#39564#35777#65306'0'
        Width = 90
      end
      item
        BiDiMode = bdLeftToRight
        ParentBiDiMode = False
        Text = ' '#30331#24405#22120#65306'0'
        Width = 102
      end
      item
        Text = ' '#24341#25806#65306'0'
        Width = 90
      end
      item
        Width = 50
      end>
  end
  object MainMenu1: TMainMenu
    Left = 24
    Top = 48
    object MENU_ACCOUNT: TMenuItem
      Caption = #24080#25143'(&A)'
      object MENU_ACCOUNT_MANAGE: TMenuItem
        Caption = #24080#25143#31649#29702'(&M)'
        OnClick = MENU_ACCOUNT_MANAGEClick
      end
    end
    object S1: TMenuItem
      Caption = #35774#32622'(&S)'
      object N2: TMenuItem
        Caption = #28165#29702#26410#29983#25104#25968#25454'(&C)'
        OnClick = N2Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object T1: TMenuItem
        Caption = #27979#35797#27169#24335'(&T)'
        OnClick = T1Click
      end
      object N201103111: TMenuItem
        Caption = #32479#35745'(&T)'
        OnClick = N201103111Click
      end
    end
    object H1: TMenuItem
      Caption = #24110#21161'(&H)'
      object A2: TMenuItem
        Caption = #20851#20110'(&A)'
      end
    end
  end
  object ADOQuery: TADOQuery
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=.\DB.mdb;Persist Se' +
      'curity Info=False'
    Parameters = <>
    SQL.Strings = (
      'sql')
    Left = 56
    Top = 48
  end
  object SSocket: TServerSocket
    Active = False
    Address = '0.0.0.0'
    Port = 7800
    ServerType = stNonBlocking
    OnListen = SSocketListen
    OnClientConnect = SSocketClientConnect
    OnClientDisconnect = SSocketClientDisconnect
    OnClientRead = SSocketClientRead
    OnClientError = SSocketClientError
    Left = 88
    Top = 48
  end
  object StartTimer: TTimer
    Interval = 200
    OnTimer = StartTimerTimer
    Left = 120
    Top = 48
  end
  object ApplicationEvents1: TApplicationEvents
    OnException = ApplicationEvents1Exception
    Left = 152
    Top = 47
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 2000
    OnTimer = Timer1Timer
    Left = 184
    Top = 48
  end
  object DecodeTimer: TTimer
    Enabled = False
    Interval = 1
    OnTimer = DecodeTimerTimer
    Left = 216
    Top = 48
  end
  object CHECKRSA: TRSA
    CommonalityMode = '1019792440150204761367420205883145987530635720731440113'
    PrivateKey = '1'
    Server = True
    Left = 248
    Top = 48
  end
  object LISTRSA: TRSA
    CommonalityMode = '859155539878932763694923350143'
    PrivateKey = '1'
    Server = True
    Left = 280
    Top = 48
  end
  object ADDRSRSA: TRSA
    CommonalityMode = '486041964784552904735358570911'
    PrivateKey = '1'
    Server = True
    Left = 312
    Top = 48
  end
  object TOOLSRSA: TRSA
    CommonalityKey = '732212959'
    CommonalityMode = '964913030490212291072611329949'
    PrivateKey = '1'
    Server = True
    Left = 344
    Top = 48
  end
  object IdHTTP1: TIdHTTP
    AllowCookies = True
    HandleRedirects = True
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
    Request.ContentLength = -1
    Request.Accept = 'text/html, */*'
    Request.BasicAuthentication = False
    Request.UserAgent = 'Mozilla/3.0 (compatible; Indy Library)'
    HTTPOptions = [hoForceEncodeParams]
    Compressor = IdCompressorZLibEx1
    Left = 24
    Top = 80
  end
  object IdCompressorZLibEx1: TIdCompressorZLibEx
    Left = 56
    Top = 80
  end
  object ADRSA: TRSA
    CommonalityKey = '65537'
    CommonalityMode = '84637663316415018074435415671'
    PrivateKey = '1'
    Server = True
    Left = 376
    Top = 48
  end
  object ADOQuery_Temp: TADOQuery
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=.\DB.mdb;Persist Se' +
      'curity Info=False'
    Parameters = <>
    SQL.Strings = (
      'sql')
    Left = 88
    Top = 80
  end
  object ShareRSA: TRSA
    CommonalityKey = '438932551'
    CommonalityMode = '430722197387646401855452920803'
    PrivateKey = '285569886502809593162490792151'
    Server = True
    Left = 120
    Top = 80
  end
end
