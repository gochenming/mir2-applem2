object FormMain: TFormMain
  Left = 0
  Top = 0
  Caption = #32593#31449#31471#21475#20445#25252#31243#24207
  ClientHeight = 398
  ClientWidth = 437
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
  object grp3: TGroupBox
    Left = 8
    Top = 8
    Width = 419
    Height = 81
    Caption = #25805#20316
    TabOrder = 0
    object btn1: TButton
      Left = 9
      Top = 16
      Width = 75
      Height = 25
      Caption = #21551#21160#26381#21153'(&O)'
      TabOrder = 0
      OnClick = btn1Click
    end
    object btn2: TButton
      Left = 9
      Top = 47
      Width = 75
      Height = 25
      Caption = #20572#27490#26381#21153'(&S)'
      Enabled = False
      TabOrder = 1
      OnClick = btn2Click
    end
    object chk1: TCheckBox
      Left = 99
      Top = 20
      Width = 97
      Height = 17
      Caption = #35760#24405#25509#25910#25968#25454
      TabOrder = 2
    end
    object chk2: TCheckBox
      Left = 202
      Top = 20
      Width = 97
      Height = 17
      Caption = #35760#24405#36830#25509'IP'
      TabOrder = 3
    end
    object chk3: TCheckBox
      Left = 99
      Top = 43
      Width = 97
      Height = 17
      Caption = #36807#28388'GETHTTP'
      TabOrder = 4
    end
    object chk4: TCheckBox
      Left = 290
      Top = 20
      Width = 126
      Height = 17
      Caption = #35760#24405#38750#27861#36830#25509#25968#25454
      TabOrder = 5
    end
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 379
    Width = 437
    Height = 19
    Panels = <
      item
        Alignment = taCenter
        Text = #36830#25509#25968
        Width = 50
      end
      item
        Alignment = taCenter
        Text = '0/0'
        Width = 100
      end
      item
        Alignment = taCenter
        Text = #38750#27861#36830#25509
        Width = 70
      end
      item
        Alignment = taCenter
        Text = '0'
        Width = 70
      end
      item
        Alignment = taCenter
        Text = #36339#36716#27425#25968
        Width = 80
      end
      item
        Alignment = taCenter
        Text = '0'
        Width = 50
      end>
  end
  object pgc1: TPageControl
    Left = 8
    Top = 95
    Width = 419
    Height = 258
    ActivePage = ts2
    TabOrder = 2
    OnChange = pgc1Change
    object ts1: TTabSheet
      Caption = #26085#24535#20449#24687
      object grp2: TGroupBox
        Left = 3
        Top = 3
        Width = 405
        Height = 225
        Caption = #26085#24535#31383#21475
        TabOrder = 0
        object mmo1: TMemo
          Left = 9
          Top = 16
          Width = 387
          Height = 200
          Color = clBlack
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clYellow
          Font.Height = -12
          Font.Name = #23435#20307
          Font.Style = []
          Lines.Strings = (
            'mmo1')
          ParentFont = False
          ReadOnly = True
          ScrollBars = ssVertical
          TabOrder = 0
        end
      end
    end
    object ts2: TTabSheet
      Caption = #36716#25442#22320#22336
      ImageIndex = 1
      object grp1: TGroupBox
        Left = 3
        Top = 3
        Width = 405
        Height = 225
        Caption = #36716#25442#22320#22336
        TabOrder = 0
        object lv1: TListView
          Left = 9
          Top = 16
          Width = 386
          Height = 201
          Columns = <
            item
              Caption = #21407#22320#22336
              Width = 170
            end
            item
              Caption = #26032#22320#22336
              Width = 180
            end>
          GridLines = True
          ReadOnly = True
          RowSelect = True
          PopupMenu = pm1
          TabOrder = 0
          ViewStyle = vsReport
        end
      end
    end
    object ts3: TTabSheet
      Caption = #36807#28388'IP'#27573
      ImageIndex = 2
      object grp4: TGroupBox
        Left = 3
        Top = 3
        Width = 405
        Height = 225
        Caption = #36807#28388'IP'
        TabOrder = 0
        object lst1: TListBox
          Left = 8
          Top = 17
          Width = 385
          Height = 200
          ItemHeight = 12
          PopupMenu = pmIPListPopupMenu
          TabOrder = 0
        end
      end
    end
    object ts4: TTabSheet
      Caption = #26469#36335#22495#21517
      ImageIndex = 3
      object grp5: TGroupBox
        Left = 3
        Top = 3
        Width = 405
        Height = 225
        Caption = #26469#36335#22495#21517
        TabOrder = 0
        object lst2: TListBox
          Left = 9
          Top = 17
          Width = 384
          Height = 200
          ItemHeight = 12
          TabOrder = 0
        end
      end
    end
  end
  object pm1: TPopupMenu
    Left = 32
    Top = 200
    object A1: TMenuItem
      Caption = #22686#21152'(&A)'
      OnClick = A1Click
    end
    object D1: TMenuItem
      Caption = #21024#38500'(&D)'
      OnClick = D1Click
    end
  end
  object SSocket: TServerSocket
    Active = False
    Address = '0.0.0.0'
    Port = 80
    ServerType = stNonBlocking
    OnListen = SSocketListen
    OnClientConnect = SSocketClientConnect
    OnClientDisconnect = SSocketClientDisconnect
    OnClientRead = SSocketClientRead
    OnClientError = SSocketClientError
    Left = 64
    Top = 200
  end
  object pmIPListPopupMenu: TPopupMenu
    Left = 95
    Top = 200
    object IPMENU_SORT: TMenuItem
      Caption = #25490#24207'(&S)'
      OnClick = IPMENU_SORTClick
    end
    object IPMENU_ADD: TMenuItem
      Caption = #22686#21152'IP'#27573'(&A)'
      OnClick = IPMENU_ADDClick
    end
    object IPMENU_DEL: TMenuItem
      Caption = #21024#38500'IP'#27573'(&D)'
      OnClick = IPMENU_DELClick
    end
  end
  object tmr1: TTimer
    Enabled = False
    Interval = 2000
    OnTimer = tmr1Timer
    Left = 128
    Top = 200
  end
end
