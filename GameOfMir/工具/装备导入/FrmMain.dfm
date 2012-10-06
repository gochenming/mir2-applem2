object FormMain: TFormMain
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Excel '#35013#22791#23548#20837
  ClientHeight = 463
  ClientWidth = 651
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 12
  object DropFileGroupBox1: TDropFileGroupBox
    Left = 8
    Top = 8
    Width = 635
    Height = 409
    Caption = #35013'TXT'#25991#20214#25176#25918#21040#36825#37324
    TabOrder = 0
    OnDropFile = DropFileGroupBox1DropFile
    Active = True
    AutoActive = True
    object lv1: TListView
      Left = 9
      Top = 17
      Width = 616
      Height = 389
      Columns = <
        item
          Caption = #35013#22791#21517#31216
          Width = 110
        end
        item
          Caption = 'AC'
          Width = 40
        end
        item
          Caption = 'AC2'
          Width = 40
        end
        item
          Caption = 'MAC'
          Width = 40
        end
        item
          Caption = 'MAC2'
          Width = 40
        end
        item
          Caption = 'DC'
          Width = 40
        end
        item
          Caption = 'DC2'
          Width = 40
        end
        item
          Caption = 'MC'
        end
        item
          Caption = 'MC2'
        end
        item
          Caption = 'SC'
          Width = 40
        end
        item
          Caption = 'SC2'
          Width = 40
        end
        item
          Caption = #20934#30830
          Width = 40
        end
        item
          Caption = #25935#25463
          Width = 40
        end
        item
          Caption = 'Look'
        end>
      GridLines = True
      Items.ItemData = {
        01460000000100000000000000FFFFFFFFFFFFFFFF0200000000000000076400
        7300660061007300640066000664007300660061006400660008640066006100
        73006400660064006600FFFFFFFF}
      ReadOnly = True
      RowSelect = True
      TabOrder = 0
      ViewStyle = vsReport
    end
  end
  object btn1: TButton
    Left = 280
    Top = 430
    Width = 137
    Height = 25
    Caption = #20840#37096#23548#20837
    TabOrder = 1
    OnClick = btn1Click
  end
  object Query: TQuery
    Left = 17
    Top = 22
  end
end
