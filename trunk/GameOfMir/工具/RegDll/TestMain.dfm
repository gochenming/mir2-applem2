object Form12: TForm12
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'Form12'
  ClientHeight = 220
  ClientWidth = 450
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clYellow
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 12
  object Memo1: TMemo
    Left = 8
    Top = 8
    Width = 435
    Height = 176
    Color = clBlack
    Lines.Strings = (
      '2010-12-12 18:49:31 '#24050#35835#21462' 11'#20010#34892#20250#20449#24687'...'
      '2010-12-12 18:49:31 '#24050#35835#21462' 1'#20010#22478#22561#20449#24687'...')
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object Button1: TButton
    Left = 184
    Top = 190
    Width = 75
    Height = 25
    Caption = 'Start'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 280
    Top = 187
    Width = 75
    Height = 25
    Caption = 'Button2'
    TabOrder = 2
    OnClick = Button2Click
  end
end
