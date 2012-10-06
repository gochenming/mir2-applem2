object FormMain: TFormMain
  Left = 0
  Top = 0
  Caption = #26032#28909#34880#20256#22855'GM'#31649#29702#24037#20855
  ClientHeight = 400
  ClientWidth = 917
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = mm1
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object mm1: TMainMenu
    Left = 128
    Top = 72
    object T1: TMenuItem
      Caption = #24037#20855'(&T)'
      object Q1: TMenuItem
        Caption = #29609#23478#25552#38382'&Q)'
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object E1: TMenuItem
        Caption = #36864#20986'(&E)'
      end
    end
    object H1: TMenuItem
      Caption = #24110#21161'(&H)'
      object A1: TMenuItem
        Caption = #20851#20110'(&A)'
      end
    end
  end
end
