object FormBatchInput: TFormBatchInput
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #25209#37327#23548#20837#22270#29255
  ClientHeight = 294
  ClientWidth = 269
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 12
  object Label1: TLabel
    Left = 7
    Top = 68
    Width = 84
    Height = 12
    Caption = #22270#29255#25152#22312#25991#20214#22841
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 252
    Height = 49
    Caption = #23548#20837#20869#23481
    TabOrder = 0
    object rbImageAndXY: TRadioButton
      Left = 7
      Top = 20
      Width = 82
      Height = 17
      Caption = #22270#29255#21644#22352#26631
      Checked = True
      TabOrder = 0
      TabStop = True
      OnClick = rbImageAndXYClick
    end
    object rbImage: TRadioButton
      Left = 111
      Top = 20
      Width = 42
      Height = 17
      Caption = #22270#29255
      TabOrder = 1
      OnClick = rbImageAndXYClick
    end
    object rbXY: TRadioButton
      Left = 184
      Top = 20
      Width = 42
      Height = 17
      Caption = #22352#26631
      TabOrder = 2
      OnClick = rbImageAndXYClick
    end
  end
  object Button1: TButton
    Left = 223
    Top = 62
    Width = 37
    Height = 24
    Caption = '...'
    TabOrder = 1
    OnClick = Button1Click
  end
  object edtSaveDir: TEdit
    Left = 95
    Top = 65
    Width = 121
    Height = 20
    TabOrder = 2
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 91
    Width = 149
    Height = 78
    Caption = #23548#20837#32034#24341
    TabOrder = 3
    object Label3: TLabel
      Left = 8
      Top = 49
      Width = 54
      Height = 12
      Caption = #32467#26463#32534#21495':'
      Enabled = False
    end
    object Label2: TLabel
      Left = 8
      Top = 23
      Width = 54
      Height = 12
      Caption = #36215#22987#32534#21495':'
      Enabled = False
    end
    object edtIndexStart: TEdit
      Left = 68
      Top = 19
      Width = 69
      Height = 20
      TabOrder = 0
      Text = 'Edit1'
    end
    object edtIndexEnd: TEdit
      Left = 68
      Top = 45
      Width = 69
      Height = 20
      TabOrder = 1
      Text = 'Edit1'
    end
  end
  object GroupBox3: TGroupBox
    Left = 163
    Top = 91
    Width = 98
    Height = 78
    Caption = #23548#20837#26041#24335
    TabOrder = 4
    object rbRumpAdd: TRadioButton
      Left = 8
      Top = 18
      Width = 86
      Height = 17
      Caption = #20174#23614#37096#28155#21152
      Checked = True
      TabOrder = 0
      TabStop = True
      OnClick = rbRumpAddClick
    end
    object rbIndexInsert: TRadioButton
      Left = 8
      Top = 35
      Width = 86
      Height = 17
      Caption = #25353#26631#21495#25554#20837
      TabOrder = 1
      OnClick = rbRumpAddClick
    end
    object rbIndexBestrow: TRadioButton
      Left = 8
      Top = 52
      Width = 86
      Height = 17
      Caption = #25353#32534#21495#35206#30422
      TabOrder = 2
      OnClick = rbRumpAddClick
    end
  end
  object GroupBox4: TGroupBox
    Left = 8
    Top = 175
    Width = 253
    Height = 50
    Caption = #22352#26631#33719#24471#26041#24335
    TabOrder = 5
    object rbXYFile: TRadioButton
      Left = 7
      Top = 21
      Width = 89
      Height = 17
      Caption = #21516#21517#22352#26631#25991#20214
      Checked = True
      TabOrder = 0
      TabStop = True
    end
    object rbSetXY: TRadioButton
      Left = 118
      Top = 21
      Width = 66
      Height = 17
      Caption = #30456#21516#22352#26631
      TabOrder = 1
    end
    object edtXY: TEdit
      Left = 189
      Top = 19
      Width = 54
      Height = 20
      TabOrder = 2
      Text = '0,0'
    end
  end
  object btnExit: TButton
    Left = 186
    Top = 256
    Width = 75
    Height = 25
    Caption = #36864#20986
    TabOrder = 6
    OnClick = btnExitClick
  end
  object btnGo: TButton
    Left = 95
    Top = 256
    Width = 75
    Height = 25
    Caption = #24320#22987
    TabOrder = 7
    OnClick = btnGoClick
  end
  object ProgressBar: TProgressBar
    Left = 9
    Top = 231
    Width = 252
    Height = 12
    TabOrder = 8
  end
  object CheckBox1: TCheckBox
    Left = 8
    Top = 259
    Width = 81
    Height = 17
    Caption = #21512#24182#24433#23376
    TabOrder = 9
  end
end
