object FormAddNew: TFormAddNew
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #28155#21152#22270#29255
  ClientHeight = 236
  ClientWidth = 287
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
    Left = 16
    Top = 15
    Width = 78
    Height = 12
    Caption = #35201#23548#20837#30340#22270#29255':'
  end
  object Label4: TLabel
    Left = 182
    Top = 41
    Width = 30
    Height = 12
    Caption = #25968#37327':'
  end
  object Button1: TButton
    Left = 232
    Top = 8
    Width = 41
    Height = 25
    Caption = '...'
    TabOrder = 0
    OnClick = Button1Click
  end
  object edtImageName: TEdit
    Left = 102
    Top = 10
    Width = 121
    Height = 20
    TabOrder = 1
  end
  object GroupBox1: TGroupBox
    Left = 16
    Top = 61
    Width = 257
    Height = 60
    Caption = #23548#20837#26041#24335
    TabOrder = 2
    object rbRumpAdd: TRadioButton
      Left = 40
      Top = 24
      Width = 73
      Height = 17
      Caption = #23614#37096#28155#21152
      Checked = True
      TabOrder = 0
      TabStop = True
    end
    object RadioButton2: TRadioButton
      Left = 144
      Top = 24
      Width = 73
      Height = 17
      Caption = #24403#21069#25554#20837
      TabOrder = 1
    end
  end
  object GroupBox2: TGroupBox
    Left = 16
    Top = 127
    Width = 257
    Height = 58
    Caption = #22352#26631
    TabOrder = 3
    object Label2: TLabel
      Left = 40
      Top = 26
      Width = 12
      Height = 12
      Caption = 'X:'
    end
    object Label3: TLabel
      Left = 144
      Top = 26
      Width = 12
      Height = 12
      Caption = 'Y:'
    end
    object edtX: TEdit
      Left = 58
      Top = 22
      Width = 55
      Height = 20
      TabOrder = 0
      Text = '0'
    end
    object edtY: TEdit
      Left = 162
      Top = 22
      Width = 55
      Height = 20
      TabOrder = 1
      Text = '0'
    end
  end
  object btnExit: TButton
    Left = 160
    Top = 197
    Width = 75
    Height = 25
    Caption = #36864#20986
    TabOrder = 4
    OnClick = btnExitClick
  end
  object btnGo: TButton
    Left = 50
    Top = 197
    Width = 75
    Height = 25
    Caption = #24320#22987
    TabOrder = 5
    OnClick = btnGoClick
  end
  object CheckBox1: TCheckBox
    Left = 102
    Top = 38
    Width = 78
    Height = 17
    Caption = #25554#20837#31354#22270#29255
    TabOrder = 6
    OnClick = CheckBox1Click
  end
  object EditCount: TEdit
    Left = 218
    Top = 36
    Width = 55
    Height = 20
    Enabled = False
    TabOrder = 7
    Text = '1'
  end
end
