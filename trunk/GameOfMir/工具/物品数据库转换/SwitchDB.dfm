object FormSwitch: TFormSwitch
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #25968#25454#24211#36716#25442#24037#20855
  ClientHeight = 159
  ClientWidth = 231
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 12
  object df: TGroupBox
    Left = 8
    Top = 8
    Width = 213
    Height = 143
    Caption = #36716#25442#36873#39033
    TabOrder = 0
    object Label1: TLabel
      Left = 10
      Top = 26
      Width = 54
      Height = 12
      Caption = #21407#25968#25454#24211':'
    end
    object Label2: TLabel
      Left = 10
      Top = 53
      Width = 54
      Height = 12
      Caption = #26032#25968#25454#24211':'
    end
    object Label3: TLabel
      Left = 10
      Top = 78
      Width = 54
      Height = 12
      Caption = #36716#25442#36827#24230':'
    end
    object ComboBoxOld: TComboBox
      Left = 70
      Top = 23
      Width = 131
      Height = 20
      Hint = 'TABNAMECOMBOX'
      Style = csDropDownList
      ItemHeight = 12
      TabOrder = 0
    end
    object ComboBoxNew: TComboBox
      Left = 70
      Top = 49
      Width = 131
      Height = 20
      Hint = 'TABNAMECOMBOX'
      Style = csDropDownList
      ItemHeight = 12
      TabOrder = 1
    end
    object Button1: TButton
      Left = 70
      Top = 103
      Width = 75
      Height = 25
      Caption = #24320#22987#36716#25442
      TabOrder = 2
      OnClick = Button1Click
    end
    object ProgressBar1: TProgressBar
      Left = 70
      Top = 75
      Width = 131
      Height = 17
      TabOrder = 3
    end
  end
  object QueryAdd: TQuery
    Left = 17
    Top = 110
  end
end
