object FormMain: TFormMain
  Left = 0
  Top = 0
  Caption = #25968#25454#24211#31649#29702#24037#20855
  ClientHeight = 492
  ClientWidth = 926
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object PageControl: TPageControl
    Left = 0
    Top = 0
    Width = 926
    Height = 492
    ActivePage = TabSheet
    Align = alClient
    TabOrder = 0
    OnChange = PageControlChange
    object TabSheet: TTabSheet
      Caption = #29289#21697#25968#25454#24211
      object Panel: TPanel
        Left = 0
        Top = 0
        Width = 918
        Height = 52
        Align = alTop
        BevelOuter = bvNone
        Caption = #12288
        TabOrder = 0
        object ComboBox: TComboBox
          Left = 0
          Top = 14
          Width = 131
          Height = 20
          Hint = 'TABNAMECOMBOX'
          Style = csDropDownList
          ItemHeight = 12
          TabOrder = 0
        end
      end
      object Grid: TStringGrid
        Left = 0
        Top = 52
        Width = 918
        Height = 413
        Hint = 'DBGRID'
        Align = alClient
        ColCount = 2
        DefaultRowHeight = 17
        FixedCols = 0
        RowCount = 2
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goEditing, goAlwaysShowEditor]
        TabOrder = 1
      end
    end
  end
  object Query: TQuery
    Left = 9
    Top = 174
  end
  object Database: TDatabase
    ReadOnly = True
    SessionName = 'Default'
    Left = 40
    Top = 174
  end
  object MainMenu1: TMainMenu
    Left = 72
    Top = 174
    object S1: TMenuItem
      Caption = #25805#20316'(&S)'
      object N1: TMenuItem
        Caption = #25968#25454#24211#36716#31227#24037#20855
        OnClick = N1Click
      end
      object N2: TMenuItem
        Caption = #29983#25104#23458#25143#31471#25991#20214
        OnClick = N2Click
      end
    end
    object H1: TMenuItem
      Caption = #24110#21161'(&H)'
      object A1: TMenuItem
        Caption = #20851#20110'(&A)'
      end
    end
  end
  object QuerySet: TQuery
    Left = 103
    Top = 174
  end
end
