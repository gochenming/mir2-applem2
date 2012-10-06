object FormMain: TFormMain
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'AppleM2'#21512#21306#24037#20855
  ClientHeight = 592
  ClientWidth = 704
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
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 341
    Height = 150
    Caption = #25968#25454#24211'1('#20027#24211')'
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 24
      Width = 30
      Height = 12
      Caption = 'ID.DB'
    end
    object Label2: TLabel
      Left = 8
      Top = 48
      Width = 36
      Height = 12
      Caption = 'Hum.DB'
    end
    object Label3: TLabel
      Left = 8
      Top = 72
      Width = 36
      Height = 12
      Caption = 'Mir.DB'
    end
    object Label4: TLabel
      Left = 8
      Top = 96
      Width = 54
      Height = 12
      Caption = 'GuildBase'
    end
    object Label5: TLabel
      Left = 8
      Top = 120
      Width = 30
      Height = 12
      Caption = 'EMail'
      Visible = False
    end
    object EditMainID: TEdit
      Left = 72
      Top = 22
      Width = 230
      Height = 20
      TabOrder = 0
    end
    object EditMainHum: TEdit
      Left = 72
      Top = 46
      Width = 230
      Height = 20
      TabOrder = 1
    end
    object EditMainMir: TEdit
      Left = 72
      Top = 70
      Width = 230
      Height = 20
      TabOrder = 2
    end
    object EditMainGuild: TEdit
      Left = 72
      Top = 94
      Width = 230
      Height = 20
      TabOrder = 3
    end
    object EditMainEMail: TEdit
      Left = 72
      Top = 118
      Width = 230
      Height = 20
      Color = clSilver
      Enabled = False
      TabOrder = 4
      Visible = False
    end
    object ButtonMainID: TButton
      Left = 302
      Top = 22
      Width = 27
      Height = 19
      Caption = '...'
      TabOrder = 5
      OnClick = ButtonMainIDClick
    end
    object ButtonMainHum: TButton
      Left = 302
      Top = 46
      Width = 27
      Height = 19
      Caption = '...'
      TabOrder = 6
      OnClick = ButtonMainIDClick
    end
    object ButtonMainMir: TButton
      Left = 302
      Top = 70
      Width = 27
      Height = 19
      Caption = '...'
      TabOrder = 7
      OnClick = ButtonMainIDClick
    end
    object ButtonMainEMail: TButton
      Left = 302
      Top = 118
      Width = 27
      Height = 19
      Caption = '...'
      Enabled = False
      TabOrder = 9
      Visible = False
      OnClick = ButtonMainGuildClick
    end
    object ButtonMainGuild: TButton
      Left = 302
      Top = 94
      Width = 27
      Height = 19
      Caption = '...'
      TabOrder = 8
      OnClick = ButtonMainGuildClick
    end
  end
  object GroupBox2: TGroupBox
    Left = 355
    Top = 8
    Width = 341
    Height = 150
    Caption = #25968#25454#24211'2('#20174#24211')'
    TabOrder = 1
    object Label6: TLabel
      Left = 8
      Top = 24
      Width = 30
      Height = 12
      Caption = 'ID.DB'
    end
    object Label7: TLabel
      Left = 8
      Top = 48
      Width = 36
      Height = 12
      Caption = 'Hum.DB'
    end
    object Label8: TLabel
      Left = 8
      Top = 72
      Width = 36
      Height = 12
      Caption = 'Mir.DB'
    end
    object Label9: TLabel
      Left = 8
      Top = 96
      Width = 54
      Height = 12
      Caption = 'GuildBase'
    end
    object Label10: TLabel
      Left = 8
      Top = 120
      Width = 30
      Height = 12
      Caption = 'EMail'
      Visible = False
    end
    object EditSubID: TEdit
      Left = 72
      Top = 22
      Width = 230
      Height = 20
      TabOrder = 0
    end
    object EditSubHum: TEdit
      Left = 72
      Top = 46
      Width = 230
      Height = 20
      TabOrder = 1
    end
    object EditSubMir: TEdit
      Left = 72
      Top = 70
      Width = 230
      Height = 20
      TabOrder = 2
    end
    object EditSubGuild: TEdit
      Left = 72
      Top = 94
      Width = 230
      Height = 20
      TabOrder = 3
    end
    object EditSubEMail: TEdit
      Left = 72
      Top = 118
      Width = 230
      Height = 20
      Color = clSilver
      Enabled = False
      TabOrder = 4
      Visible = False
    end
    object ButtonSubID: TButton
      Left = 302
      Top = 22
      Width = 27
      Height = 19
      Caption = '...'
      TabOrder = 5
      OnClick = ButtonMainIDClick
    end
    object ButtonSubHum: TButton
      Left = 302
      Top = 46
      Width = 27
      Height = 19
      Caption = '...'
      TabOrder = 6
      OnClick = ButtonMainIDClick
    end
    object ButtonSubMir: TButton
      Left = 302
      Top = 70
      Width = 27
      Height = 19
      Caption = '...'
      TabOrder = 7
      OnClick = ButtonMainIDClick
    end
    object ButtonSubEMail: TButton
      Left = 302
      Top = 118
      Width = 27
      Height = 19
      Caption = '...'
      Enabled = False
      TabOrder = 9
      Visible = False
      OnClick = ButtonMainGuildClick
    end
    object ButtonSubGuild: TButton
      Left = 302
      Top = 94
      Width = 27
      Height = 19
      Caption = '...'
      TabOrder = 8
      OnClick = ButtonMainGuildClick
    end
  end
  object GroupBox3: TGroupBox
    Left = 8
    Top = 364
    Width = 688
    Height = 121
    Caption = #21512#24182#35774#32622
    TabOrder = 2
    object Label11: TLabel
      Left = 161
      Top = 40
      Width = 48
      Height = 12
      Caption = #22825#26410#35775#38382
    end
    object Label12: TLabel
      Left = 161
      Top = 95
      Width = 48
      Height = 12
      Caption = #22825#26410#35775#38382
    end
    object CheckBoxAcc1: TCheckBox
      Left = 8
      Top = 18
      Width = 137
      Height = 17
      Caption = #28165#29702#24080#21495'('#26080#35282#33394#24080#21495')'
      Checked = True
      State = cbChecked
      TabOrder = 0
    end
    object CheckBoxAcc2: TCheckBox
      Left = 8
      Top = 38
      Width = 105
      Height = 17
      Caption = #28165#29702#24080#21495'  '#36317#20170
      TabOrder = 1
      OnClick = CheckBoxAcc2Click
    end
    object EditAcc2: TSpinEdit
      Left = 114
      Top = 36
      Width = 47
      Height = 21
      Enabled = False
      MaxValue = 65535
      MinValue = 0
      TabOrder = 2
      Value = 90
    end
    object CheckBoxHum1: TCheckBox
      Left = 8
      Top = 57
      Width = 137
      Height = 17
      Caption = #28165#29702#20154#29289'('#24050#21024#38500')'
      Checked = True
      State = cbChecked
      TabOrder = 3
    end
    object CheckBoxHum3: TCheckBox
      Left = 8
      Top = 93
      Width = 105
      Height = 17
      Caption = #28165#29702#20154#29289'  '#36317#20170
      TabOrder = 4
      OnClick = CheckBoxHum3Click
    end
    object EditHum3: TSpinEdit
      Left = 114
      Top = 91
      Width = 47
      Height = 21
      Enabled = False
      MaxValue = 65535
      MinValue = 0
      TabOrder = 5
      Value = 90
    end
    object CheckBoxHum2: TCheckBox
      Left = 8
      Top = 75
      Width = 137
      Height = 17
      Caption = #28165#29702#20154#29289'('#26080#35282#33394#25968#25454')'
      Checked = True
      State = cbChecked
      TabOrder = 6
    end
    object CheckBoxRefId: TCheckBox
      Left = 336
      Top = 18
      Width = 113
      Height = 17
      Caption = #37325#26032#25490#21015#29289#21697'ID'
      Checked = True
      State = cbChecked
      TabOrder = 7
    end
  end
  object GroupBox4: TGroupBox
    Left = 8
    Top = 491
    Width = 688
    Height = 65
    Caption = #20445#23384#35774#32622
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    object Label15: TLabel
      Left = 8
      Top = 29
      Width = 54
      Height = 12
      Caption = #20445#23384#30446#24405':'
    end
    object EditSaveDir: TEdit
      Left = 65
      Top = 26
      Width = 361
      Height = 20
      TabOrder = 0
    end
    object ButtonSaveDir: TButton
      Left = 432
      Top = 26
      Width = 27
      Height = 18
      Caption = '...'
      TabOrder = 1
      OnClick = ButtonMainGuildClick
    end
    object ButtonState: TButton
      Left = 481
      Top = 22
      Width = 89
      Height = 25
      Caption = #24320#22987#21512#24182'(&S)'
      TabOrder = 2
      OnClick = ButtonStateClick
    end
    object ButtonClose: TButton
      Left = 576
      Top = 22
      Width = 89
      Height = 25
      Caption = #36864#20986'(&X)'
      TabOrder = 3
      OnClick = ButtonCloseClick
    end
  end
  object ProgressBar1: TProgressBar
    Left = 0
    Top = 575
    Width = 704
    Height = 17
    Align = alBottom
    TabOrder = 4
    ExplicitTop = 375
  end
  object Panel1: TPanel
    Left = 0
    Top = 555
    Width = 704
    Height = 20
    Align = alBottom
    BevelOuter = bvNone
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -12
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
    TabOrder = 5
    ExplicitTop = 355
  end
  object GroupBox5: TGroupBox
    Left = 8
    Top = 164
    Width = 688
    Height = 194
    Caption = #25991#26412#21512#24182
    TabOrder = 6
    object GroupBox6: TGroupBox
      Left = 2
      Top = 152
      Width = 684
      Height = 40
      Align = alBottom
      Caption = #22320#22336
      TabOrder = 0
      object Label13: TLabel
        Left = 8
        Top = 18
        Width = 18
        Height = 12
        Caption = #20027':'
      end
      object Label14: TLabel
        Left = 243
        Top = 18
        Width = 18
        Height = 12
        Caption = #20174':'
      end
      object EditAddText1: TEdit
        Left = 32
        Top = 12
        Width = 175
        Height = 20
        TabOrder = 0
      end
      object ButtonAddText1: TButton
        Left = 210
        Top = 13
        Width = 27
        Height = 18
        Caption = '...'
        TabOrder = 1
        OnClick = ButtonMainIDClick
      end
      object EditAddText2: TEdit
        Left = 265
        Top = 12
        Width = 175
        Height = 20
        TabOrder = 2
      end
      object ButtonAddText2: TButton
        Left = 443
        Top = 13
        Width = 27
        Height = 18
        Caption = '...'
        TabOrder = 3
        OnClick = ButtonMainIDClick
      end
      object Button3: TButton
        Left = 476
        Top = 10
        Width = 60
        Height = 25
        Caption = #28155#21152
        TabOrder = 4
        OnClick = Button3Click
      end
      object Button4: TButton
        Left = 542
        Top = 10
        Width = 60
        Height = 25
        Caption = #21024#38500
        TabOrder = 5
        OnClick = Button4Click
      end
      object Button5: TButton
        Left = 606
        Top = 10
        Width = 60
        Height = 25
        Caption = #28165#31354
        TabOrder = 6
        OnClick = Button5Click
      end
    end
    object ListBox1: TListBox
      Left = 2
      Top = 14
      Width = 684
      Height = 138
      Align = alClient
      ItemHeight = 12
      TabOrder = 1
    end
  end
  object OpenDialog1: TOpenDialog
    Left = 8
    Top = 544
  end
end
