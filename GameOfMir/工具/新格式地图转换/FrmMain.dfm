object FormMain: TFormMain
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #26032#26684#24335#22320#22270#36716#25442
  ClientHeight = 395
  ClientWidth = 329
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 12
  object DropFileGroupBox1: TDropFileGroupBox
    Left = 8
    Top = 8
    Width = 233
    Height = 377
    Caption = #23558#25991#20214#25176#25918#21040#35813#22788
    TabOrder = 0
    OnDropFile = DropFileGroupBox1DropFile
    Active = True
    AutoActive = True
    object lst1: TListBox
      Left = 7
      Top = 18
      Width = 218
      Height = 348
      ItemHeight = 12
      TabOrder = 0
    end
  end
  object btn1: TButton
    Left = 247
    Top = 26
    Width = 75
    Height = 25
    Caption = #28165#31354
    TabOrder = 1
    OnClick = btn1Click
  end
  object btn2: TButton
    Left = 247
    Top = 57
    Width = 75
    Height = 25
    Caption = #36716#25442
    TabOrder = 2
    OnClick = btn2Click
  end
end
