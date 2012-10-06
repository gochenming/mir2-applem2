object FormMain: TFormMain
  Left = 0
  Top = 0
  Caption = 'ETEngine'#19987#29992#21047#24618#37197#32622#29983#25104#24037#20855' - http://www.etm2.com'
  ClientHeight = 566
  ClientWidth = 798
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
  object Panel_BG_Right: TPanel
    Left = 476
    Top = 0
    Width = 322
    Height = 566
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 0
    object GroupBox1: TGroupBox
      Left = 6
      Top = 8
      Width = 312
      Height = 351
      Caption = #21047#24618#20449#24687
      TabOrder = 0
      object ListBox1: TListBox
        Left = 7
        Top = 44
        Width = 145
        Height = 299
        ItemHeight = 12
        TabOrder = 0
      end
      object ListBox2: TListBox
        Left = 158
        Top = 44
        Width = 145
        Height = 299
        ItemHeight = 12
        TabOrder = 1
      end
      object Edit1: TEdit
        Left = 7
        Top = 18
        Width = 121
        Height = 20
        TabOrder = 2
        Text = 'Edit1'
      end
      object Edit2: TEdit
        Left = 158
        Top = 18
        Width = 121
        Height = 20
        TabOrder = 3
        Text = 'Edit1'
      end
    end
    object GroupBox2: TGroupBox
      Left = 6
      Top = 365
      Width = 312
      Height = 84
      Caption = #21047#24618#21442#25968
      TabOrder = 1
      object Label1: TLabel
        Left = 16
        Top = 24
        Width = 54
        Height = 12
        Caption = #21047#24618#33539#22260':'
      end
      object Label2: TLabel
        Left = 166
        Top = 24
        Width = 54
        Height = 12
        Caption = #21047#24618#25968#37327':'
      end
      object Label3: TLabel
        Left = 16
        Top = 50
        Width = 54
        Height = 12
        Caption = #21047#24618#38388#38548':'
      end
      object Label4: TLabel
        Left = 166
        Top = 50
        Width = 54
        Height = 12
        Caption = #38598#20013#26426#29575':'
      end
      object Edit3: TEdit
        Left = 76
        Top = 21
        Width = 77
        Height = 20
        TabOrder = 0
        Text = '20'
      end
      object Edit4: TEdit
        Left = 226
        Top = 21
        Width = 77
        Height = 20
        TabOrder = 1
        Text = '10'
      end
      object Edit5: TEdit
        Left = 76
        Top = 47
        Width = 77
        Height = 20
        TabOrder = 2
        Text = '5'
      end
      object Edit6: TEdit
        Left = 226
        Top = 47
        Width = 77
        Height = 20
        TabOrder = 3
        Text = '0'
      end
    end
  end
  object Panel_BG_Left: TPanel
    Left = 0
    Top = 0
    Width = 476
    Height = 566
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitLeft = 184
    ExplicitTop = 120
    ExplicitWidth = 185
    ExplicitHeight = 41
    object Panel_Left_Bottom: TPanel
      Left = 0
      Top = 359
      Width = 476
      Height = 207
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 0
      ExplicitTop = 272
      ExplicitWidth = 496
      object Memo1: TMemo
        Left = 0
        Top = 0
        Width = 476
        Height = 207
        Align = alClient
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = #23435#20307
        Font.Style = []
        Lines.Strings = (
          'Memo1')
        ParentFont = False
        ScrollBars = ssBoth
        TabOrder = 0
        ExplicitWidth = 496
      end
    end
    object Panel_Left_Top: TPanel
      Left = 0
      Top = 0
      Width = 476
      Height = 359
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      ExplicitTop = -6
      ExplicitWidth = 512
      object ScrollBox: TScrollBox
        Left = 0
        Top = 0
        Width = 476
        Height = 359
        Align = alClient
        Color = clWhite
        ParentColor = False
        TabOrder = 0
        ExplicitWidth = 414
        ExplicitHeight = 340
        object Image1: TImage
          Left = 0
          Top = 0
          Width = 352
          Height = 295
          AutoSize = True
        end
      end
    end
  end
end
