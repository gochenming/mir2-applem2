object FormQuest: TFormQuest
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = #25552#31034#31383#21475
  ClientHeight = 95
  ClientWidth = 199
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object Label1: TLabel
    Left = 16
    Top = 16
    Width = 132
    Height = 12
    Caption = #35831#36755#20837#24744#30340#29992#25143#21517#20449#24687#65306
  end
  object EditName: TEdit
    Left = 16
    Top = 34
    Width = 169
    Height = 20
    CharCase = ecLowerCase
    TabOrder = 0
  end
  object ButtonOK: TButton
    Left = 24
    Top = 63
    Width = 65
    Height = 25
    Caption = #30830#23450'(&O)'
    TabOrder = 1
    OnClick = ButtonOKClick
  end
  object ButtonExit: TButton
    Left = 112
    Top = 63
    Width = 65
    Height = 25
    Caption = #21462#28040'(&E)'
    TabOrder = 2
    OnClick = ButtonExitClick
  end
end
