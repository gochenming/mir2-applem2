object FormMain: TFormMain
  Left = 230
  Top = 113
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #26085#24535#26381#21153#22120
  ClientHeight = 38
  ClientWidth = 298
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 12
  object Label1: TLabel
    Left = 6
    Top = 6
    Width = 78
    Height = 12
    Caption = #24403#21069#26085#24535#25991#20214':'
  end
  object Label2: TLabel
    Left = 6
    Top = 23
    Width = 36
    Height = 12
    Caption = #25991#20214#21517
  end
  object Label3: TLabel
    Left = 88
    Top = 6
    Width = 6
    Height = 12
    Caption = '0'
  end
  object Memo1: TMemo
    Left = 0
    Top = 48
    Width = 297
    Height = 145
    Lines.Strings = (
      'Memo1')
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object CheckBox1: TCheckBox
    Left = 218
    Top = 5
    Width = 72
    Height = 17
    Caption = #26597#30475#38169#35823
    TabOrder = 1
    OnClick = CheckBox1Click
  end
  object MainMenu1: TMainMenu
    Left = 176
    Top = 8
    object V1: TMenuItem
      Caption = #26597#30475'(&V)'
      object MEMU_VIEW_LOGVIEW: TMenuItem
        Caption = #26085#24535#26597#35810'(&L)'
        OnClick = MEMU_VIEW_LOGVIEWClick
      end
    end
    object H1: TMenuItem
      Caption = #24110#21161'(&H)'
      object MEMU_HELP_ABOUT: TMenuItem
        Caption = #20851#20110'(&A)'
        OnClick = MEMU_HELP_ABOUTClick
      end
    end
  end
  object TimerSave: TTimer
    Interval = 3000
    OnTimer = TimerSaveTimer
    Left = 144
    Top = 16
  end
  object IdUDPServer: TIdUDPServer
    BufferSize = 81920
    Bindings = <
      item
        IP = '0.0.0.0'
        Port = 0
      end>
    DefaultPort = 0
    OnUDPRead = IdUDPServerUDPRead
    Left = 184
  end
  object ADOQuery1: TADOQuery
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=.\db.mdb;Persist Se' +
      'curity Info=False'
    Parameters = <>
    SQL.Strings = (
      'sql')
    Left = 96
    Top = 16
  end
  object ApplicationEvents1: TApplicationEvents
    OnException = ApplicationEvents1Exception
    Left = 120
    Top = 8
  end
end
