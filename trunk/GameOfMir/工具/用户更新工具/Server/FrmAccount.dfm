object FormAccount: TFormAccount
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #24080#25143#31649#29702
  ClientHeight = 369
  ClientWidth = 495
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
    Left = 6
    Top = 8
    Width = 480
    Height = 57
    Caption = #36873#25321#24080#25143
    TabOrder = 0
    object Label1: TLabel
      Left = 16
      Top = 24
      Width = 54
      Height = 12
      Caption = #24080#25143#21015#34920':'
    end
    object Label2: TLabel
      Left = 207
      Top = 24
      Width = 54
      Height = 12
      Caption = #26597#25214#20869#23481':'
    end
    object ComboBoxAccount: TComboBox
      Left = 76
      Top = 21
      Width = 125
      Height = 20
      Style = csDropDownList
      ItemHeight = 12
      TabOrder = 0
      OnChange = ComboBoxAccountChange
    end
    object EditFind: TEdit
      Left = 267
      Top = 21
      Width = 121
      Height = 20
      TabOrder = 1
    end
    object ButtonFind: TBitBtn
      Left = 393
      Top = 18
      Width = 75
      Height = 25
      Caption = #26597#25214'(&F)'
      TabOrder = 2
      OnClick = ButtonFindClick
      Glyph.Data = {
        DE010000424DDE01000000000000760000002800000024000000120000000100
        0400000000006801000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333444444
        33333333333F8888883F33330000324334222222443333388F3833333388F333
        000032244222222222433338F8833FFFFF338F3300003222222AAAAA22243338
        F333F88888F338F30000322222A33333A2224338F33F8333338F338F00003222
        223333333A224338F33833333338F38F00003222222333333A444338FFFF8F33
        3338888300003AAAAAAA33333333333888888833333333330000333333333333
        333333333333333333FFFFFF000033333333333344444433FFFF333333888888
        00003A444333333A22222438888F333338F3333800003A2243333333A2222438
        F38F333333833338000033A224333334422224338338FFFFF8833338000033A2
        22444442222224338F3388888333FF380000333A2222222222AA243338FF3333
        33FF88F800003333AA222222AA33A3333388FFFFFF8833830000333333AAAAAA
        3333333333338888883333330000333333333333333333333333333333333333
        0000}
      NumGlyphs = 2
    end
  end
  object GroupBox2: TGroupBox
    Left = 7
    Top = 71
    Width = 480
    Height = 290
    Caption = #24080#25143#20449#24687
    TabOrder = 1
    object Label3: TLabel
      Left = 16
      Top = 24
      Width = 54
      Height = 12
      Caption = #24080#25143#21517#31216':'
    end
    object Label4: TLabel
      Left = 16
      Top = 74
      Width = 54
      Height = 12
      Caption = #24080#25143#23494#30721':'
    end
    object Label5: TLabel
      Left = 16
      Top = 102
      Width = 42
      Height = 12
      Caption = #32852#31995'QQ:'
    end
    object Label6: TLabel
      Left = 15
      Top = 258
      Width = 54
      Height = 12
      Caption = #30331#24405#22320#22336':'
    end
    object Label7: TLabel
      Left = 207
      Top = 258
      Width = 54
      Height = 12
      Caption = #30331#24405#26102#38388':'
    end
    object Label8: TLabel
      Left = 15
      Top = 206
      Width = 54
      Height = 12
      Caption = #20844#20849#26631#35782':'
    end
    object Label9: TLabel
      Left = 15
      Top = 180
      Width = 54
      Height = 12
      Caption = #32465#23450#21015#34920':'
    end
    object Label10: TLabel
      Left = 15
      Top = 232
      Width = 30
      Height = 12
      Caption = 'GUID:'
    end
    object Label11: TLabel
      Left = 208
      Top = 102
      Width = 30
      Height = 12
      Caption = #26410#32465':'
    end
    object Label12: TLabel
      Left = 293
      Top = 102
      Width = 30
      Height = 12
      Caption = #24050#32465':'
    end
    object Label13: TLabel
      Left = 16
      Top = 151
      Width = 54
      Height = 12
      Caption = #24080#25143#20313#39069':'
    end
    object Label14: TLabel
      Left = 180
      Top = 151
      Width = 66
      Height = 12
      Caption = #30331#24405#22120#20215#26684':'
    end
    object Label15: TLabel
      Left = 320
      Top = 151
      Width = 54
      Height = 12
      Caption = #24341#25806#20215#26684':'
    end
    object Label16: TLabel
      Left = 207
      Top = 206
      Width = 54
      Height = 12
      Caption = #27880#20876#26102#38388':'
    end
    object Label17: TLabel
      Left = 376
      Top = 102
      Width = 30
      Height = 12
      Caption = #36824#21407':'
    end
    object EditAccount: TEdit
      Left = 76
      Top = 21
      Width = 125
      Height = 20
      CharCase = ecLowerCase
      Color = clSilver
      MaxLength = 30
      ReadOnly = True
      TabOrder = 0
      OnChange = EditAccountChange
    end
    object EditPassword: TEdit
      Left = 76
      Top = 71
      Width = 125
      Height = 20
      MaxLength = 20
      TabOrder = 1
      OnChange = EditAccountChange
    end
    object EditQQ: TEdit
      Left = 76
      Top = 99
      Width = 125
      Height = 20
      MaxLength = 10
      TabOrder = 2
      OnChange = EditAccountChange
    end
    object CheckBoxActive: TCheckBox
      Left = 77
      Top = 48
      Width = 76
      Height = 17
      Caption = #28608#27963#24080#25143
      TabOrder = 3
      OnClick = EditAccountChange
    end
    object ButtonNew: TButton
      Left = 207
      Top = 18
      Width = 66
      Height = 25
      Caption = #26032#24314'(&N)'
      TabOrder = 4
      OnClick = ButtonNewClick
    end
    object ButtonSave: TButton
      Left = 279
      Top = 18
      Width = 66
      Height = 25
      Caption = #20445#23384'(&S)'
      Enabled = False
      TabOrder = 5
      OnClick = ButtonSaveClick
    end
    object EditAddress: TEdit
      Left = 75
      Top = 255
      Width = 125
      Height = 20
      Color = clSilver
      ReadOnly = True
      TabOrder = 6
    end
    object EditLoginTime: TEdit
      Left = 267
      Top = 255
      Width = 201
      Height = 20
      Color = clSilver
      ReadOnly = True
      TabOrder = 7
    end
    object ButtonGetRandomPass: TButton
      Left = 207
      Top = 68
      Width = 138
      Height = 25
      Caption = #33719#21462#38543#26426#23494#30721'(&R)'
      TabOrder = 8
      OnClick = ButtonGetRandomPassClick
    end
    object ButtonDel: TButton
      Left = 351
      Top = 18
      Width = 66
      Height = 25
      Caption = #21024#38500'(&D)'
      Enabled = False
      TabOrder = 9
      OnClick = ButtonDelClick
    end
    object EditPublicID: TEdit
      Left = 75
      Top = 203
      Width = 126
      Height = 20
      Color = clSilver
      ReadOnly = True
      TabOrder = 10
    end
    object EditBindList: TEdit
      Left = 75
      Top = 177
      Width = 393
      Height = 20
      MaxLength = 255
      TabOrder = 11
      OnChange = EditAccountChange
    end
    object EditGUID: TEdit
      Left = 75
      Top = 229
      Width = 393
      Height = 20
      Color = clSilver
      ReadOnly = True
      TabOrder = 12
    end
    object EditBindCount: TSpinEdit
      Left = 244
      Top = 98
      Width = 43
      Height = 21
      MaxValue = 9999
      MinValue = 0
      TabOrder = 13
      Value = 0
      OnChange = EditAccountChange
    end
    object EditUseBindCount: TSpinEdit
      Left = 329
      Top = 98
      Width = 41
      Height = 21
      Color = clSilver
      MaxValue = 0
      MinValue = 0
      ReadOnly = True
      TabOrder = 14
      Value = 0
    end
    object CheckBoxAgent: TCheckBox
      Left = 77
      Top = 125
      Width = 93
      Height = 17
      Caption = #26159#21542#20195#29702#24080#21495
      TabOrder = 15
      OnClick = CheckBoxAgentClick
    end
    object EditMoney: TSpinEdit
      Left = 76
      Top = 148
      Width = 94
      Height = 21
      Color = clWhite
      Enabled = False
      MaxValue = 999999
      MinValue = 0
      TabOrder = 16
      Value = 0
      OnChange = EditAccountChange
    end
    object EditAgentLogin: TSpinEdit
      Left = 252
      Top = 148
      Width = 61
      Height = 21
      Color = clWhite
      Enabled = False
      MaxValue = 9999
      MinValue = 0
      TabOrder = 17
      Value = 0
      OnChange = EditAccountChange
    end
    object EditAgentM2: TSpinEdit
      Left = 380
      Top = 148
      Width = 61
      Height = 21
      Color = clWhite
      Enabled = False
      MaxValue = 9999
      MinValue = 0
      TabOrder = 18
      Value = 0
      OnChange = EditAccountChange
    end
    object EditRegTime: TEdit
      Left = 267
      Top = 203
      Width = 201
      Height = 20
      Color = clSilver
      ReadOnly = True
      TabOrder = 19
    end
    object CheckBoxBindPC: TCheckBox
      Left = 305
      Top = 125
      Width = 78
      Height = 17
      Caption = #32465#23450#26426#22120#30721
      TabOrder = 20
      OnClick = CheckBoxAgentClick
    end
    object CheckBoxBindIP: TCheckBox
      Left = 389
      Top = 125
      Width = 78
      Height = 17
      Caption = #32465#23450'IP'#22320#22336
      TabOrder = 21
      OnClick = CheckBoxAgentClick
    end
    object EditUserResetCount: TSpinEdit
      Left = 412
      Top = 98
      Width = 43
      Height = 21
      MaxValue = 9999
      MinValue = 0
      TabOrder = 22
      Value = 0
      OnChange = EditAccountChange
    end
    object CheckBoxAdmin: TCheckBox
      Left = 194
      Top = 125
      Width = 93
      Height = 17
      Caption = #26159#21542#20026#31649#29702#21592
      TabOrder = 23
      OnClick = CheckBoxAgentClick
    end
  end
  object Button2: TButton
    Left = 353
    Top = 139
    Width = 118
    Height = 25
    Caption = #21457#36865#23494#30721#37038#20214'(&E)'
    Enabled = False
    TabOrder = 2
  end
end
