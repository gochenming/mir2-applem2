object FormDown: TFormDown
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #20934#22791#19979#36733
  ClientHeight = 159
  ClientWidth = 288
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
  object Label1: TLabel
    Left = 8
    Top = 82
    Width = 42
    Height = 12
    Caption = #24050#19979#36733':'
  end
  object Label2: TLabel
    Left = 8
    Top = 101
    Width = 42
    Height = 12
    Caption = #19979#36733#21040':'
  end
  object Label3: TLabel
    Left = 152
    Top = 82
    Width = 54
    Height = 12
    Caption = #20256#36755#36895#24230':'
  end
  object Label4: TLabel
    Left = 56
    Top = 82
    Width = 30
    Height = 12
    Caption = '743KB'
  end
  object Label5: TLabel
    Left = 56
    Top = 101
    Width = 90
    Height = 12
    Caption = 'E:\test\ddd.rar'
  end
  object Label6: TLabel
    Left = 212
    Top = 82
    Width = 48
    Height = 12
    Caption = '843KB/'#31186
  end
  object RzProgressBar1: TRzProgressBar
    Left = 8
    Top = 61
    Width = 272
    Height = 15
    BorderWidth = 0
    InteriorOffset = 0
    PartsComplete = 0
    Percent = 60
    TotalParts = 0
  end
  object Animate1: TAnimate
    Left = 8
    Top = -5
    Width = 272
    Height = 60
    CommonAVI = aviCopyFile
    StopFrame = 20
    Timers = True
  end
  object BitBtn1: TBitBtn
    Left = 59
    Top = 123
    Width = 75
    Height = 25
    Caption = #19979#36733'(&D)'
    TabOrder = 1
    OnClick = BitBtn1Click
    Kind = bkYes
  end
  object BitBtn2: TBitBtn
    Left = 163
    Top = 123
    Width = 75
    Height = 25
    Caption = #21462#28040'(&E)'
    TabOrder = 2
    Kind = bkCancel
  end
end
