object FormSetXY: TFormSetXY
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #25209#37327#35774#32622#22270#20687#22352#26631
  ClientHeight = 148
  ClientWidth = 316
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
    Left = 8
    Top = 8
    Width = 161
    Height = 81
    Caption = #22270#29255#32534#21495
    TabOrder = 0
    object Label2: TLabel
      Left = 8
      Top = 23
      Width = 54
      Height = 12
      Caption = #36215#22987#32534#21495':'
    end
    object Label3: TLabel
      Left = 8
      Top = 49
      Width = 54
      Height = 12
      Caption = #32467#26463#32534#21495':'
    end
    object edtIndexStart: TEdit
      Left = 71
      Top = 19
      Width = 74
      Height = 20
      TabOrder = 0
      Text = 'Edit1'
    end
    object edtIndexEnd: TEdit
      Left = 71
      Top = 45
      Width = 74
      Height = 20
      TabOrder = 1
      Text = 'Edit1'
    end
  end
  object ProgressBar: TProgressBar
    Left = 8
    Top = 95
    Width = 297
    Height = 12
    TabOrder = 1
  end
  object btnGo: TButton
    Left = 65
    Top = 115
    Width = 75
    Height = 25
    Caption = #24320#22987
    TabOrder = 2
    OnClick = btnGoClick
  end
  object btnExit: TButton
    Left = 175
    Top = 115
    Width = 75
    Height = 25
    Caption = #36864#20986
    TabOrder = 3
    OnClick = btnExitClick
  end
  object GroupBox2: TGroupBox
    Left = 175
    Top = 8
    Width = 130
    Height = 81
    Caption = #22352#26631#22686'/'#20943#37327
    TabOrder = 4
    object Label1: TLabel
      Left = 22
      Top = 49
      Width = 12
      Height = 12
      Caption = 'Y:'
    end
    object Label4: TLabel
      Left = 22
      Top = 23
      Width = 12
      Height = 12
      Caption = 'X:'
    end
    object EditX: TEdit
      Left = 40
      Top = 19
      Width = 74
      Height = 20
      TabOrder = 0
      Text = 'EditX'
    end
    object EditY: TEdit
      Left = 40
      Top = 45
      Width = 74
      Height = 20
      TabOrder = 1
      Text = 'EditY'
    end
  end
end
