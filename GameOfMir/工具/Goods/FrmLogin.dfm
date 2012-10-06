object FormLogin: TFormLogin
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #36873#25321#25968#25454#24211
  ClientHeight = 128
  ClientWidth = 271
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
  object GroupBox1: TGroupBox
    Left = 18
    Top = 12
    Width = 235
    Height = 101
    BiDiMode = bdLeftToRight
    Caption = #36873#25321#25968#25454#24211
    ParentBiDiMode = False
    TabOrder = 0
    object Label1: TLabel
      Left = 10
      Top = 29
      Width = 54
      Height = 12
      Caption = #25968#25454#24211#21517':'
    end
    object ComboBox: TComboBox
      Left = 75
      Top = 26
      Width = 151
      Height = 20
      Style = csDropDownList
      ItemHeight = 12
      TabOrder = 0
    end
    object Button1: TButton
      Left = 75
      Top = 63
      Width = 75
      Height = 25
      Caption = #30830#23450'(&O)'
      TabOrder = 1
      OnClick = Button1Click
    end
  end
end
