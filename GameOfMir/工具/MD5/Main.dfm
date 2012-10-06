object FormMain: TFormMain
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'MD5'#26597#30475#24037#20855
  ClientHeight = 110
  ClientWidth = 382
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
  object Edit1: TEdit
    Left = 24
    Top = 16
    Width = 337
    Height = 20
    TabOrder = 0
    Text = 'Edit1'
    OnChange = Edit1Change
  end
  object Edit2: TEdit
    Left = 24
    Top = 56
    Width = 337
    Height = 20
    TabOrder = 1
    Text = 'Edit2'
  end
  object CheckBox1: TCheckBox
    Left = 96
    Top = 85
    Width = 81
    Height = 17
    Caption = #22823#20889
    TabOrder = 2
    OnClick = Edit1Change
  end
  object CheckBox2: TCheckBox
    Left = 216
    Top = 85
    Width = 81
    Height = 17
    Caption = '16'#20301
    TabOrder = 3
    OnClick = Edit1Change
  end
end
