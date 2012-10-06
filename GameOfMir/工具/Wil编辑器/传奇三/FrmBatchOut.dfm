object FormBatchOut: TFormBatchOut
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #25209#37327#23548#20986#22270#29255
  ClientHeight = 196
  ClientWidth = 290
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
    Width = 84
    Height = 12
    Caption = #23548#20986#22270#29255#25991#20214#22841
  end
  object edtSaveDir: TEdit
    Left = 104
    Top = 11
    Width = 121
    Height = 20
    TabOrder = 0
  end
  object Button1: TButton
    Left = 232
    Top = 7
    Width = 41
    Height = 25
    Caption = '...'
    TabOrder = 1
    OnClick = Button1Click
  end
  object GroupBox1: TGroupBox
    Left = 16
    Top = 37
    Width = 257
    Height = 84
    Caption = #22270#29255#32534#21495
    TabOrder = 2
    object Label2: TLabel
      Left = 8
      Top = 23
      Width = 78
      Height = 12
      Caption = #22270#29255#36215#22987#32534#21495':'
    end
    object Label3: TLabel
      Left = 8
      Top = 49
      Width = 78
      Height = 12
      Caption = #22270#29255#32467#26463#32534#21495':'
    end
    object edtIndexStart: TEdit
      Left = 92
      Top = 19
      Width = 89
      Height = 20
      TabOrder = 0
      Text = 'Edit1'
    end
    object edtIndexEnd: TEdit
      Left = 92
      Top = 45
      Width = 89
      Height = 20
      TabOrder = 1
      Text = 'Edit1'
    end
  end
  object ProgressBar: TProgressBar
    Left = 16
    Top = 127
    Width = 257
    Height = 12
    TabOrder = 3
  end
  object btnGo: TButton
    Left = 117
    Top = 152
    Width = 75
    Height = 25
    Caption = #24320#22987
    TabOrder = 4
    OnClick = btnGoClick
  end
  object btnExit: TButton
    Left = 198
    Top = 152
    Width = 75
    Height = 25
    Caption = #36864#20986
    TabOrder = 5
    OnClick = btnExitClick
  end
  object CheckBox1: TCheckBox
    Left = 14
    Top = 152
    Width = 67
    Height = 17
    Caption = #21024#38500#22352#39569
    TabOrder = 6
  end
end
