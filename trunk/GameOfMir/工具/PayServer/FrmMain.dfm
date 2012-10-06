object FormMain: TFormMain
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #36154#21916#25903#20184#24179#21488#30452#36830#31995#32479#26381#21153#31471
  ClientHeight = 344
  ClientWidth = 611
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
  object grp1: TGroupBox
    Left = 8
    Top = 8
    Width = 297
    Height = 105
    Caption = #22522#26412#35774#32622
    TabOrder = 0
    object lbl1: TLabel
      Left = 8
      Top = 23
      Width = 54
      Height = 12
      Caption = #36890#20449#31471#21475':'
    end
    object lbl11: TLabel
      Left = 8
      Top = 49
      Width = 42
      Height = 12
      Caption = #25968#25454#24211':'
    end
    object lbl12: TLabel
      Left = 8
      Top = 75
      Width = 54
      Height = 12
      Caption = #38134#34892#32447#31243':'
    end
    object lbl14: TLabel
      Left = 133
      Top = 75
      Width = 54
      Height = 12
      Caption = #21345#31867#32447#31243':'
    end
    object edtPort: TEdit
      Left = 68
      Top = 20
      Width = 45
      Height = 20
      TabOrder = 0
      Text = '8999'
      OnChange = edtPortChange
    end
    object btnStateServer: TButton
      Left = 119
      Top = 19
      Width = 83
      Height = 21
      Caption = #21551#21160#26381#21153'(&S)'
      TabOrder = 1
      OnClick = btnStateServerClick
    end
    object edtDataFile: TEdit
      Left = 68
      Top = 46
      Width = 186
      Height = 20
      TabOrder = 2
      OnChange = edtPortChange
    end
    object btnGetFile: TButton
      Left = 260
      Top = 45
      Width = 23
      Height = 21
      Caption = '...'
      TabOrder = 3
      OnClick = btnGetFileClick
    end
    object seBankCount: TSpinEdit
      Left = 68
      Top = 72
      Width = 61
      Height = 21
      EditorEnabled = False
      MaxValue = 5
      MinValue = 1
      TabOrder = 4
      Value = 1
      OnChange = edtPortChange
    end
    object seCardCount: TSpinEdit
      Left = 193
      Top = 72
      Width = 61
      Height = 21
      EditorEnabled = False
      MaxValue = 5
      MinValue = 1
      TabOrder = 5
      Value = 1
      OnChange = edtPortChange
    end
    object chk1: TCheckBox
      Left = 216
      Top = 22
      Width = 65
      Height = 17
      Caption = 'IIS'#29256#26412
      TabOrder = 6
      OnClick = edtPortChange
    end
  end
  object grp2: TGroupBox
    Left = 8
    Top = 119
    Width = 595
    Height = 74
    Caption = #21830#22478#35774#32622
    TabOrder = 1
    object lbl2: TLabel
      Left = 8
      Top = 23
      Width = 42
      Height = 12
      Caption = #21830#25143'ID:'
    end
    object lbl3: TLabel
      Left = 200
      Top = 23
      Width = 54
      Height = 12
      Caption = #21830#25143#23494#21273':'
      Visible = False
    end
    object lbl7: TLabel
      Left = 8
      Top = 49
      Width = 48
      Height = 12
      Caption = #36820#22238'URL:'
    end
    object edtPayID: TEdit
      Left = 68
      Top = 20
      Width = 121
      Height = 20
      TabOrder = 0
      OnChange = edtPortChange
    end
    object edtPayPass: TEdit
      Left = 260
      Top = 20
      Width = 325
      Height = 20
      TabOrder = 1
      Visible = False
      OnChange = edtPortChange
    end
    object edtBackUrl: TEdit
      Left = 68
      Top = 46
      Width = 517
      Height = 20
      TabOrder = 2
      OnChange = edtPortChange
    end
  end
  object grp3: TGroupBox
    Left = 311
    Top = 8
    Width = 292
    Height = 105
    Caption = #32479#35745#20449#24687
    TabOrder = 2
    object lbl4: TLabel
      Left = 8
      Top = 23
      Width = 54
      Height = 12
      Caption = #38134#34892#30452#36830':'
    end
    object lblreg: TLabel
      Left = 63
      Top = 23
      Width = 6
      Height = 12
      Caption = '0'
    end
    object lblChangepass: TLabel
      Left = 63
      Top = 49
      Width = 6
      Height = 12
      Caption = '0'
    end
    object lbl13: TLabel
      Left = 8
      Top = 49
      Width = 54
      Height = 12
      Caption = #21345#23494#30452#36830':'
    end
    object lbl5: TLabel
      Left = 8
      Top = 75
      Width = 54
      Height = 12
      Caption = #21457#36865#37038#20214':'
      Visible = False
    end
    object lblSendEmail: TLabel
      Left = 63
      Top = 75
      Width = 54
      Height = 12
      Caption = #20801#35768#22320#22336':'
      Visible = False
    end
  end
  object grp4: TGroupBox
    Left = 8
    Top = 199
    Width = 595
    Height = 138
    Caption = #26085#24535#31383#21475
    TabOrder = 3
    object mmoLog: TMemo
      Left = 8
      Top = 18
      Width = 577
      Height = 111
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
  object WEBSocket: TServerSocket
    Active = False
    Address = '0.0.0.0'
    Port = 8999
    ServerType = stNonBlocking
    OnListen = WEBSocketListen
    OnClientConnect = WEBSocketClientConnect
    OnClientDisconnect = WEBSocketClientDisconnect
    OnClientRead = WEBSocketClientRead
    OnClientError = WEBSocketClientError
    Left = 32
    Top = 240
  end
  object qry1: TADOQuery
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=.\db.mdb;Persist Se' +
      'curity Info=False'
    Parameters = <>
    SQL.Strings = (
      'sql')
    Left = 64
    Top = 240
  end
end
