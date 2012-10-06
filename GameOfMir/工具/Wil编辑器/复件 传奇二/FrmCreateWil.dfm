object FormCreateWil: TFormCreateWil
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #21019#24314#26032#30340#25968#25454#25991#20214
  ClientHeight = 143
  ClientWidth = 286
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
  object lbl1: TLabel
    Left = 13
    Top = 15
    Width = 90
    Height = 12
    Caption = #26032#25968#25454#25991#20214#21517#31216':'
  end
  object btn1: TButton
    Left = 232
    Top = 7
    Width = 41
    Height = 25
    Caption = '...'
    TabOrder = 0
    OnClick = btn1Click
  end
  object edtSaveDir: TEdit
    Left = 104
    Top = 11
    Width = 121
    Height = 20
    TabOrder = 1
  end
  object grp1: TGroupBox
    Left = 13
    Top = 37
    Width = 260
    Height = 52
    Caption = #25991#20214#31867#22411
    TabOrder = 2
    object rb1: TRadioButton
      Left = 8
      Top = 21
      Width = 98
      Height = 17
      Caption = #36890#29992#25968#25454#26684#24335
      Checked = True
      TabOrder = 0
      TabStop = True
    end
    object rbNewEncrypt: TRadioButton
      Left = 145
      Top = 21
      Width = 98
      Height = 17
      Caption = #30495#24425#25968#25454#26684#24335
      TabOrder = 1
    end
  end
  object btnExit: TButton
    Left = 158
    Top = 104
    Width = 75
    Height = 25
    Caption = #36864#20986
    TabOrder = 3
    OnClick = btnExitClick
  end
  object btnGo: TButton
    Left = 48
    Top = 104
    Width = 75
    Height = 25
    Caption = #21019#24314
    TabOrder = 4
    OnClick = btnGoClick
  end
end
