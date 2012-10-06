object FormEditServer: TFormEditServer
  Left = 184
  Top = 106
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'FormEditServer'
  ClientHeight = 214
  ClientWidth = 472
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
  object GroupBox1: TGroupBox
    Left = 16
    Top = 8
    Width = 442
    Height = 193
    TabOrder = 0
    object Label1: TLabel
      Left = 16
      Top = 24
      Width = 90
      Height = 12
      Caption = #26381#21153#22120#26174#31034#21517#31216':'
    end
    object Label2: TLabel
      Left = 16
      Top = 48
      Width = 66
      Height = 12
      Caption = #26381#21153#22120#21517#31216':'
    end
    object Label3: TLabel
      Left = 16
      Top = 72
      Width = 66
      Height = 12
      Caption = #26381#21153#22120#22320#22336':'
    end
    object Label4: TLabel
      Left = 16
      Top = 98
      Width = 66
      Height = 12
      Caption = #26381#21153#22120#31471#21475':'
    end
    object Label5: TLabel
      Left = 16
      Top = 122
      Width = 90
      Height = 12
      Caption = #25152#23646#26381#21153#22120#20998#32452':'
    end
    object EditShowName: TEdit
      Left = 109
      Top = 21
      Width = 324
      Height = 20
      TabOrder = 0
      Text = 'EditShowName'
    end
    object EditName: TEdit
      Left = 109
      Top = 45
      Width = 324
      Height = 20
      TabOrder = 1
      Text = 'EditName'
    end
    object EditAddr: TEdit
      Left = 109
      Top = 69
      Width = 324
      Height = 20
      TabOrder = 2
      Text = 'EditAddr'
    end
    object ComboBoxServerGroup: TComboBox
      Left = 109
      Top = 119
      Width = 156
      Height = 20
      Style = csDropDownList
      ItemHeight = 12
      TabOrder = 3
    end
    object ButtonOk: TButton
      Left = 109
      Top = 154
      Width = 73
      Height = 25
      Caption = #30830#23450'(&O)'
      TabOrder = 4
      OnClick = ButtonOkClick
    end
    object ButtonClose: TButton
      Left = 248
      Top = 154
      Width = 73
      Height = 25
      Caption = #21462#28040'(&X)'
      ModalResult = 2
      TabOrder = 5
    end
    object edtPort: TEdit
      Left = 109
      Top = 95
      Width = 324
      Height = 20
      TabOrder = 6
      Text = 'EditAddr'
    end
  end
end
