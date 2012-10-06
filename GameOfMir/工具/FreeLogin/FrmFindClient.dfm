object FormFindClient: TFormFindClient
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #26597#25214#20256#22855#23458#25143#31471
  ClientHeight = 271
  ClientWidth = 315
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object grp1: TGroupBox
    Left = 8
    Top = 8
    Width = 297
    Height = 161
    Caption = #33258#21160#26597#25214#23458#25143#31471
    TabOrder = 0
    object lbl1: TLabel
      Left = 13
      Top = 20
      Width = 276
      Height = 57
      AutoSize = False
      Caption = 
        #22914#26524#24744#19981#30693#36947#20256#22855#30446#24405#20301#32622#65292#21487#20197#35753#31243#24207#33258#21160#26597#25214#12290#13#10#35831#20808#36873#25321#39537#21160#22120#22914#65306'D'#30424#65292#28982#21518#28857#20987#26597#25214#12290#13#10#22914#26524#26597#25214#23436#27605#20063#26410#25214#21040#65292#26356#25442#20854#23427#30424#32487#32493 +
        #26597#25214#12290#13#10#30452#21040#25214#21040#23458#25143#31471#20026#27490
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGreen
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object lbl2: TLabel
      Left = 13
      Top = 83
      Width = 54
      Height = 12
      Caption = #25351#23450#30424#31526':'
    end
    object lbl3: TLabel
      Left = 13
      Top = 101
      Width = 54
      Height = 12
      Caption = #24403#21069#20301#32622':'
    end
    object lbl4: TLabel
      Left = 13
      Top = 117
      Width = 271
      Height = 38
      AutoSize = False
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
      ParentColor = False
      ParentFont = False
      WordWrap = True
    end
    object RzLabel1: TRzLabel
      Left = 120
      Top = 80
      Width = 48
      Height = 12
      Caption = 'RzLabel1'
    end
  end
  object btnFind: TButton
    Left = 203
    Top = 86
    Width = 89
    Height = 23
    Caption = #33258#21160#26597#25214'(&F)'
    TabOrder = 1
    OnClick = btnFindClick
  end
  object cbb1: TComboBox
    Left = 81
    Top = 88
    Width = 113
    Height = 20
    Style = csDropDownList
    ItemHeight = 12
    ItemIndex = 0
    TabOrder = 2
    Text = #25152#26377#30424#31526
    Items.Strings = (
      #25152#26377#30424#31526)
  end
  object grp2: TGroupBox
    Left = 8
    Top = 175
    Width = 299
    Height = 58
    Caption = #25163#21160#25351#23450#23458#25143#31471
    TabOrder = 3
    object lbl5: TLabel
      Left = 13
      Top = 26
      Width = 30
      Height = 12
      Caption = #20301#32622':'
    end
    object edtClientDir: TEdit
      Left = 45
      Top = 23
      Width = 248
      Height = 20
      TabOrder = 0
    end
    object btn1: TButton
      Left = 266
      Top = 25
      Width = 25
      Height = 16
      Caption = '...'
      TabOrder = 1
      OnClick = btn1Click
    end
  end
  object btnOk: TButton
    Left = 64
    Top = 239
    Width = 75
    Height = 25
    Caption = #30830#23450'(&O)'
    TabOrder = 4
    OnClick = btnOkClick
  end
  object btnCancel: TButton
    Left = 176
    Top = 239
    Width = 75
    Height = 25
    Cancel = True
    Caption = #21462#28040'(&X)'
    ModalResult = 2
    TabOrder = 5
  end
end
