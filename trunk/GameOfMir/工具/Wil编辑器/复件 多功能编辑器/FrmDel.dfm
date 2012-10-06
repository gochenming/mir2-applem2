object FormDel: TFormDel
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #21024#38500#25968#25454
  ClientHeight = 128
  ClientWidth = 297
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
    Width = 145
    Height = 79
    Caption = #32534#21495
    TabOrder = 0
    object Label2: TLabel
      Left = 8
      Top = 22
      Width = 54
      Height = 12
      Caption = #36215#22987#32534#21495':'
    end
    object Label3: TLabel
      Left = 8
      Top = 48
      Width = 54
      Height = 12
      Caption = #32467#26463#32534#21495':'
    end
    object edtIndexStart: TSpinEdit
      Left = 68
      Top = 18
      Width = 69
      Height = 21
      MaxValue = 10000000
      MinValue = 0
      TabOrder = 0
      Value = 9
    end
    object edtIndexEnd: TSpinEdit
      Left = 68
      Top = 45
      Width = 69
      Height = 21
      MaxValue = 10000000
      MinValue = 0
      TabOrder = 1
      Value = 9
    end
  end
  object GroupBox2: TGroupBox
    Left = 159
    Top = 8
    Width = 130
    Height = 79
    Caption = #36873#39033
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
      Caption = #20351#29992#31354#25968#25454#26367#20195
      TabOrder = 1
    end
  end
  object btnGo: TButton
    Left = 62
    Top = 93
    Width = 75
    Height = 25
    Caption = #25191#34892'(&G)'
    TabOrder = 2
    OnClick = btnGoClick
  end
  object btnExit: TButton
    Left = 167
    Top = 93
    Width = 75
    Height = 25
    Cancel = True
    Caption = #36864#20986'(&E)'
    Default = True
    ModalResult = 2
    TabOrder = 3
  end
end
