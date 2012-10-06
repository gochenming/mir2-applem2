object FormEditUpData: TFormEditUpData
  Left = 322
  Top = 120
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'FormEditUpData'
  ClientHeight = 305
  ClientWidth = 402
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
    Top = 119
    Width = 385
    Height = 179
    TabOrder = 0
    object Label2: TLabel
      Left = 12
      Top = 43
      Width = 54
      Height = 12
      Caption = #19979#36733#22320#22336':'
    end
    object Label3: TLabel
      Left = 12
      Top = 69
      Width = 54
      Height = 12
      Caption = #20445#23384#20301#32622':'
    end
    object Label4: TLabel
      Left = 180
      Top = 69
      Width = 66
      Height = 12
      Caption = #20445#23384#25991#20214#21517':'
    end
    object Label1: TLabel
      Left = 204
      Top = 95
      Width = 42
      Height = 12
      Alignment = taRightJustify
      Caption = #29256#26412#21495':'
    end
    object Label5: TLabel
      Left = 271
      Top = 17
      Width = 54
      Height = 12
      Caption = #26159#21542#35299#21387':'
    end
    object lbl4: TLabel
      Left = 12
      Top = 95
      Width = 54
      Height = 12
      Caption = #26816#27979#27169#24335':'
    end
    object lbl1: TLabel
      Left = 12
      Top = 17
      Width = 54
      Height = 12
      Caption = #26356#26032#25552#31034':'
    end
    object lbl2: TLabel
      Left = 12
      Top = 120
      Width = 54
      Height = 12
      Caption = #19979#36733#25928#39564':'
    end
    object EditSaveDir: TEdit
      Left = 70
      Top = 66
      Width = 104
      Height = 20
      Hint = #25991#20214#26356#26032#21518#20445#23384#25991#20214#22841#20301#32622#65292#20363#22914#65306#35201#20445#23384#21040#30331#24405#22120#25152#22312#30340' Data '#25991#20214#22841#19979#23601#22635'  .\Data\ '#26082#21487
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      Text = '.\'
    end
    object EditDownUrl: TEdit
      Left = 70
      Top = 40
      Width = 221
      Height = 20
      Hint = #26356#26032#25991#20214#19979#36733#22320#22336#12290
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
    end
    object EditVer: TSpinEdit
      Left = 249
      Top = 92
      Width = 63
      Height = 21
      Hint = #24403#23458#25143#31471#20445#23384#30340#21319#32423#29256#26412#20302#20110#35813#29256#26412#21495#26102#65292#33258#21160#26356#26032#35813#25991#20214#12290#24314#35758#27599#19968#39033#37117#20351#29992#19981#21516#30340#29256#26412#21495#12290
      MaxValue = 65535
      MinValue = 1
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      Value = 1
    end
    object EditSaveName: TEdit
      Left = 249
      Top = 66
      Width = 122
      Height = 20
      Hint = #19979#36733#23436#25104#21518#65292#20445#23384#25991#20214#21517#31216#35774#32622#12290
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
    end
    object ButtonClose: TButton
      Left = 204
      Top = 144
      Width = 73
      Height = 25
      Caption = #21462#28040'(&X)'
      ModalResult = 2
      TabOrder = 4
    end
    object ButtonOk: TButton
      Left = 101
      Top = 144
      Width = 73
      Height = 25
      Caption = #30830#23450'(&O)'
      TabOrder = 5
      OnClick = ButtonOkClick
    end
    object ComboBoxZip: TComboBox
      Left = 329
      Top = 14
      Width = 42
      Height = 20
      Hint = #35299#21387#21482#25903#25345'Zip'#26684#24335
      Style = csDropDownList
      ItemHeight = 12
      ItemIndex = 0
      ParentShowHint = False
      ShowHint = True
      TabOrder = 6
      Text = #21542
      Items.Strings = (
        #21542
        #26159)
    end
    object cbbDownType: TComboBox
      Left = 297
      Top = 40
      Width = 74
      Height = 20
      Style = csDropDownList
      ItemHeight = 12
      ItemIndex = 0
      ParentShowHint = False
      ShowHint = False
      TabOrder = 7
      Text = #30452#25509#19979#36733
      Items.Strings = (
        #30452#25509#19979#36733
        #30334#24230#30456#20876)
    end
    object cbbCheckType: TComboBox
      Left = 70
      Top = 92
      Width = 104
      Height = 20
      Hint = #35299#21387#21482#25903#25345'Zip'#26684#24335
      Style = csDropDownList
      ItemHeight = 12
      ParentShowHint = False
      ShowHint = True
      TabOrder = 8
      OnChange = cbbCheckTypeChange
      Items.Strings = (
        #29256#26412#21495'('#26410#23436#25104')'
        #26159#21542#23384#22312
        'PAK'#25991#20214'('#26410#23436#25104')'
        'MD5'#20540)
    end
    object edtMD5: TEdit
      Left = 249
      Top = 134
      Width = 122
      Height = 20
      CharCase = ecLowerCase
      ParentShowHint = False
      ShowHint = False
      TabOrder = 9
      Visible = False
    end
    object edtHint: TEdit
      Left = 70
      Top = 14
      Width = 195
      Height = 20
      ParentShowHint = False
      ShowHint = False
      TabOrder = 10
    end
    object edtDate: TEdit
      Left = 249
      Top = 144
      Width = 122
      Height = 20
      CharCase = ecLowerCase
      ParentShowHint = False
      ShowHint = False
      TabOrder = 11
      Text = '20050505'
      Visible = False
    end
    object edtdownmd5: TEdit
      Left = 70
      Top = 118
      Width = 301
      Height = 20
      CharCase = ecLowerCase
      ParentShowHint = False
      ShowHint = False
      TabOrder = 12
      Text = '20050505'
    end
  end
  object DropFileGroupBox1: TDropFileGroupBox
    Left = 8
    Top = 8
    Width = 385
    Height = 105
    Caption = 'MD5'#20540#35745#31639'('#25903#25345#25991#20214#25176#25918')'
    TabOrder = 1
    OnDropFile = DropFileGroupBox1DropFile
    Active = True
    AutoActive = True
    object Label6: TLabel
      Left = 16
      Top = 24
      Width = 48
      Height = 12
      Caption = #25991#20214#21517#65306
    end
    object lbl5: TLabel
      Left = 16
      Top = 50
      Width = 42
      Height = 12
      Caption = 'MD5'#20540#65306
    end
    object pb1: TProgressBar
      Left = 70
      Top = 73
      Width = 301
      Height = 18
      Smooth = True
      TabOrder = 0
    end
    object edt2: TEdit
      Left = 70
      Top = 47
      Width = 301
      Height = 20
      Color = clBlack
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 1
    end
    object edt1: TEdit
      Left = 70
      Top = 21
      Width = 301
      Height = 20
      TabOrder = 2
    end
  end
end
