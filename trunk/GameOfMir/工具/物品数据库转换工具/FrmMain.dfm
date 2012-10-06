object FormMain: TFormMain
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'AppleM2'#25968#25454#24211#36716#25442#24037#20855' (20120501)'
  ClientHeight = 264
  ClientWidth = 522
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object PageControl1: TPageControl
    Left = 8
    Top = 8
    Width = 506
    Height = 248
    ActivePage = TabSheet1
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'StdItems.DB'
      object Label5: TLabel
        Left = 7
        Top = 7
        Width = 318
        Height = 12
        Caption = #27880#24847#65306#21407#26469#30340'StdItems.DB'#25918#22312#26412#31243#24207#30446#24405#19979#12290#36716#25442#25104#21151#21518#65292
      end
      object Label6: TLabel
        Left = 7
        Top = 22
        Width = 312
        Height = 12
        Caption = #29983#25104#26032#30340#65306'StdItems_New.DB'#65292#35831#33258#34892#21629#21517#20026#65306'StdItems.DB'
      end
      object BtnStdItems: TButton
        Left = 336
        Top = 7
        Width = 153
        Height = 25
        Caption = #33258#21160#36716#25442'StdItems.DB'
        TabOrder = 0
        OnClick = BtnStdItemsClick
      end
      object GroupBox2: TGroupBox
        Left = 7
        Top = 37
        Width = 482
        Height = 52
        Caption = #36873#39033
        TabOrder = 1
        object Label7: TLabel
          Left = 16
          Top = 24
          Width = 84
          Height = 12
          Caption = #21407#25968#25454#24211#31867#22411#65306
        end
        object CBStdItems: TComboBox
          Left = 106
          Top = 21
          Width = 55
          Height = 20
          Style = csDropDownList
          ItemHeight = 12
          ItemIndex = 0
          TabOrder = 0
          Text = 'SKY'
          Items.Strings = (
            'SKY'
            'BLUE')
        end
        object CheckBoxStdItems: TCheckBox
          Left = 184
          Top = 23
          Width = 295
          Height = 17
          Caption = #33258#21160#35774#32622#29289#21697#30340'StdMode('#22914#26524#25163#21160#20462#25913#36807#65292#35831#19981#36873')'
          TabOrder = 1
          Visible = False
        end
      end
      object LogStdItems: TMemo
        Left = 7
        Top = 95
        Width = 482
        Height = 106
        Color = clBlack
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clYellow
        Font.Height = -12
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 2
      end
      object BarStdItems: TProgressBar
        Left = 7
        Top = 207
        Width = 482
        Height = 11
        TabOrder = 3
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Monster.DB'
      ImageIndex = 1
      object Label2: TLabel
        Left = 7
        Top = 7
        Width = 312
        Height = 12
        Caption = #27880#24847#65306#21407#26469#30340'Monster.DB'#25918#22312#26412#31243#24207#30446#24405#19979#12290#36716#25442#25104#21151#21518#65292
      end
      object Label3: TLabel
        Left = 7
        Top = 22
        Width = 300
        Height = 12
        Caption = #29983#25104#26032#30340#65306'Monster_New.DB'#65292#35831#33258#34892#21629#21517#20026#65306'Monster.DB'
      end
      object BtnMonster: TButton
        Left = 336
        Top = 7
        Width = 153
        Height = 25
        Caption = #33258#21160#36716#25442'Monster.DB'
        TabOrder = 0
        OnClick = BtnMonsterClick
      end
      object GroupBox1: TGroupBox
        Left = 7
        Top = 37
        Width = 482
        Height = 52
        Caption = #36873#39033
        TabOrder = 1
        object CheckBoxMonster: TCheckBox
          Left = 9
          Top = 21
          Width = 432
          Height = 17
          Caption = #33258#21160#26367#25442#26032#24618#29289#30340'Race'#21644'RaceImg'#35774#32622#65292#22914#26524#20320#24050#25163#21160#20462#25913#36807#35831#19981#35201#36873#25321#27492#39033
          TabOrder = 0
          Visible = False
        end
      end
      object LogMonster: TMemo
        Left = 7
        Top = 95
        Width = 482
        Height = 106
        Color = clBlack
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clYellow
        Font.Height = -12
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 2
      end
      object BarMonster: TProgressBar
        Left = 7
        Top = 207
        Width = 482
        Height = 11
        TabOrder = 3
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Magic.DB'
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label1: TLabel
        Left = 16
        Top = 16
        Width = 180
        Height = 12
        Caption = 'Magic.DB'#35831#30452#25509#20351#29992#25105#20204#25552#20379#30340'DB'
      end
    end
  end
  object Query: TQuery
    Left = 32
    Top = 136
  end
  object QuerySave: TQuery
    Left = 64
    Top = 136
  end
end
