object Form1: TForm1
  Left = 190
  Top = 105
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #20256#22855#23553#21253#21152#35299#23494#24037#20855
  ClientHeight = 434
  ClientWidth = 548
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 12
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 529
    Height = 129
    Caption = #21152#23494#26041
    TabOrder = 0
    object EncodeEdit: TEdit
      Left = 8
      Top = 16
      Width = 193
      Height = 20
      TabOrder = 0
    end
    object edtEncode: TEdit
      Left = 8
      Top = 42
      Width = 518
      Height = 84
      AutoSize = False
      TabOrder = 1
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 168
    Width = 529
    Height = 129
    Caption = #35299#23494#26041
    TabOrder = 1
    object RecogEdit: TEdit
      Left = 8
      Top = 16
      Width = 65
      Height = 20
      TabOrder = 0
    end
    object IdentEdit: TEdit
      Left = 80
      Top = 16
      Width = 65
      Height = 20
      TabOrder = 1
    end
    object ParamEdit: TEdit
      Left = 152
      Top = 16
      Width = 65
      Height = 20
      TabOrder = 2
    end
    object TagEdit: TEdit
      Left = 224
      Top = 16
      Width = 65
      Height = 20
      TabOrder = 3
    end
    object SeriesEdit: TEdit
      Left = 296
      Top = 16
      Width = 65
      Height = 20
      TabOrder = 4
    end
    object edtDecode: TEdit
      Left = 8
      Top = 42
      Width = 518
      Height = 84
      AutoSize = False
      TabOrder = 5
    end
  end
  object EncodeButton: TButton
    Left = 288
    Top = 143
    Width = 97
    Height = 24
    Caption = #21152#23494#8593
    TabOrder = 2
    OnClick = EncodeButtonClick
  end
  object DecodeButton: TButton
    Left = 128
    Top = 143
    Width = 97
    Height = 24
    Caption = #35299#23494#8595
    TabOrder = 3
    OnClick = DecodeButtonClick
  end
  object Greds: TGroupBox
    Left = 8
    Top = 304
    Width = 529
    Height = 121
    Caption = #23383#33410#38598#26597#30475
    TabOrder = 4
    object Memo1: TMemo
      Left = 8
      Top = 16
      Width = 513
      Height = 95
      TabOrder = 0
    end
  end
end
