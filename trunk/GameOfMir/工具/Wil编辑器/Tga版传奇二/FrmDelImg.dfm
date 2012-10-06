object FormDelImg: TFormDelImg
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #21024#38500#22270#29255
  ClientHeight = 150
  ClientWidth = 313
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
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 161
    Height = 81
    Caption = #22270#29255#32534#21495
    TabOrder = 0
    object Label2: TLabel
      Left = 8
      Top = 23
      Width = 54
      Height = 12
      Caption = #36215#22987#32534#21495':'
    end
    object Label3: TLabel
      Left = 8
      Top = 49
      Width = 54
      Height = 12
      Caption = #32467#26463#32534#21495':'
    end
    object edtIndexStart: TEdit
      Left = 71
      Top = 19
      Width = 74
      Height = 20
      TabOrder = 0
      Text = 'Edit1'
    end
    object edtIndexEnd: TEdit
      Left = 71
      Top = 45
      Width = 74
      Height = 20
      TabOrder = 1
      Text = 'Edit1'
    end
  end
  object GroupBox2: TGroupBox
    Left = 175
    Top = 8
    Width = 130
    Height = 81
    Caption = #21024#38500#26041#24335
    TabOrder = 1
    object rbQuiteDel: TRadioButton
      Left = 8
      Top = 21
      Width = 113
      Height = 17
      Caption = #24443#24213#21024#38500
      Checked = True
      TabOrder = 0
      TabStop = True
    end
    object RadioButton2: TRadioButton
      Left = 8
      Top = 47
      Width = 113
      Height = 17
      Caption = #20351#29992#31354#22270#29255#26367#20195
      TabOrder = 1
    end
  end
  object ProgressBar: TProgressBar
    Left = 8
    Top = 95
    Width = 297
    Height = 12
    TabOrder = 2
  end
  object btnGo: TButton
    Left = 65
    Top = 115
    Width = 75
    Height = 25
    Caption = #24320#22987
    TabOrder = 3
    OnClick = btnGoClick
  end
  object btnExit: TButton
    Left = 175
    Top = 115
    Width = 75
    Height = 25
    Caption = #36864#20986
    TabOrder = 4
    OnClick = btnExitClick
  end
end
