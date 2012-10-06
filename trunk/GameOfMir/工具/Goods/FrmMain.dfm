object FormMain: TFormMain
  Left = 0
  Top = 0
  Caption = 'AppleM2'#29289#21697#25968#25454#24211#31649#29702#24037#20855#65288#21333#20987#21491#38190#20462#25913#65289
  ClientHeight = 356
  ClientWidth = 934
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
  object Panel4: TPanel
    Left = 0
    Top = 347
    Width = 934
    Height = 9
    Align = alBottom
    BevelOuter = bvNone
    Caption = ' '
    TabOrder = 0
    object ProgressBar1: TProgressBar
      Left = 0
      Top = 0
      Width = 934
      Height = 9
      Align = alClient
      TabOrder = 0
    end
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 934
    Height = 347
    ActivePage = TabMagic
    Align = alClient
    TabOrder = 1
    object TabStdItems: TTabSheet
      Caption = 'StdItems.DB'
      object ListView1: TListView
        Left = 0
        Top = 0
        Width = 926
        Height = 320
        Align = alClient
        BevelInner = bvNone
        BevelOuter = bvNone
        Columns = <
          item
            Caption = #29289#21697'ID'
          end
          item
            Caption = #29289#21697#21517#31216
            Width = 105
          end
          item
            Alignment = taCenter
            Caption = #20844#24320
            Width = 40
          end
          item
            Alignment = taCenter
            Caption = #20132#26131
            Width = 40
          end
          item
            Alignment = taCenter
            Caption = #23384#20179
            Width = 40
          end
          item
            Alignment = taCenter
            Caption = #20462#29702
            Width = 40
          end
          item
            Alignment = taCenter
            Caption = #20002#24323
            Width = 40
          end
          item
            Alignment = taCenter
            Caption = #25481#33853
            Width = 40
          end
          item
            Alignment = taCenter
            Caption = #25171#36896
            Width = 40
          end
          item
            Alignment = taCenter
            Caption = #20986#21806
            Width = 40
          end
          item
            Alignment = taCenter
            Caption = #28040#22833
            Width = 40
          end
          item
            Alignment = taCenter
            Caption = #26174
            Width = 25
          end
          item
            Alignment = taCenter
            Caption = #25441
            Width = 25
          end
          item
            Alignment = taCenter
            Caption = #29305
            Width = 25
          end
          item
            Alignment = taCenter
            Caption = #25552
            Width = 25
          end
          item
            AutoSize = True
            Caption = #22791#27880
          end>
        GridLines = True
        MultiSelect = True
        ReadOnly = True
        RowSelect = True
        StateImages = ImageList1
        TabOrder = 0
        ViewStyle = vsReport
        OnColumnClick = ListView1ColumnClick
        OnCompare = ListView1Compare
        OnMouseDown = ListView1MouseDown
      end
    end
    object TabMagic: TTabSheet
      Caption = 'Magic.DB'
      ImageIndex = 1
      object ListViewMagic: TListView
        Left = 0
        Top = 0
        Width = 926
        Height = 320
        Align = alClient
        BevelInner = bvNone
        BevelOuter = bvNone
        Columns = <
          item
            Caption = #25216#33021'ID'
          end
          item
            Caption = #25216#33021#21517#31216
            Width = 105
          end
          item
            Alignment = taCenter
            Caption = #20844#24320
            Width = 40
          end
          item
            Alignment = taCenter
            Caption = #32844#19994
            Width = 40
          end
          item
            Alignment = taCenter
            Caption = #24310#26102
            Width = 40
          end
          item
            Alignment = taCenter
            Caption = #38388#38548
            Width = 40
          end
          item
            AutoSize = True
            Caption = #22791#27880
          end>
        GridLines = True
        MultiSelect = True
        ReadOnly = True
        RowSelect = True
        StateImages = ImageList1
        TabOrder = 0
        ViewStyle = vsReport
        OnColumnClick = ListViewMagicColumnClick
        OnCompare = ListViewMagicCompare
        OnMouseDown = ListViewMagicMouseDown
      end
    end
  end
  object Query: TQuery
    Left = 25
    Top = 286
  end
  object MainMenu1: TMainMenu
    Left = 56
    Top = 288
    object N1: TMenuItem
      Caption = #25805#20316'(&C)'
      object S1: TMenuItem
        Caption = #20445#23384#37197#32622'(&S)'
        OnClick = S1Click
      end
      object R1: TMenuItem
        Caption = #37325#26032#21152#36733#37197#32622'(&R)'
        OnClick = R1Click
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object W1: TMenuItem
        Caption = #29983#25104#23458#25143#31471#25991#20214'(&W)'
        Visible = False
        OnClick = W1Click
      end
      object ID1: TMenuItem
        Caption = #37325#32622#29289#21697#25968#25454#24211'ID(&I)'
        OnClick = ID1Click
      end
    end
    object S2: TMenuItem
      Caption = #36873#25321'(&S)'
      object A1: TMenuItem
        Caption = #20840#36873'(&A)'
        OnClick = A1Click
      end
    end
  end
  object ImageList1: TImageList
    Width = 8
    Left = 88
    Top = 288
  end
end
