object FormAdd: TFormAdd
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #23548#20837#25968#25454
  ClientHeight = 403
  ClientWidth = 483
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
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 259
    Height = 49
    Caption = #23548#20837#20869#23481
    TabOrder = 0
    object ImageStream: TRadioButton
      Left = 7
      Top = 20
      Width = 59
      Height = 17
      Caption = #22270#20687
      Checked = True
      TabOrder = 0
      TabStop = True
      OnClick = ImageStreamClick
    end
    object WavaStream: TRadioButton
      Left = 72
      Top = 20
      Width = 59
      Height = 17
      Caption = #38899#39057
      TabOrder = 1
      OnClick = ImageStreamClick
    end
    object DataStream: TRadioButton
      Left = 137
      Top = 20
      Width = 59
      Height = 17
      Caption = #20854#23427
      TabOrder = 2
      OnClick = ImageStreamClick
    end
    object NoneStream: TRadioButton
      Left = 202
      Top = 20
      Width = 45
      Height = 17
      Caption = #31354
      TabOrder = 3
      OnClick = ImageStreamClick
    end
  end
  object GroupBox2: TGroupBox
    Left = 273
    Top = 8
    Width = 202
    Height = 376
    Caption = #25991#20214#21015#34920
    TabOrder = 3
    object File_List: TListBox
      Left = 7
      Top = 20
      Width = 186
      Height = 285
      ItemHeight = 12
      MultiSelect = True
      Sorted = True
      TabOrder = 0
    end
    object File_Add: TButton
      Left = 7
      Top = 311
      Width = 58
      Height = 25
      Caption = #25991#20214'(&A)'
      TabOrder = 2
      OnClick = File_AddClick
    end
    object File_Del: TButton
      Left = 71
      Top = 342
      Width = 58
      Height = 25
      Caption = #21024#38500'(&D)'
      TabOrder = 3
      OnClick = File_DelClick
    end
    object File_Clear: TButton
      Left = 135
      Top = 342
      Width = 58
      Height = 25
      Caption = #28165#31354'(&C)'
      TabOrder = 4
      OnClick = File_ClearClick
    end
    object File_Begin: TButton
      Left = 7
      Top = 342
      Width = 58
      Height = 25
      Caption = #25191#34892'(&B)'
      TabOrder = 1
      OnClick = File_BeginClick
    end
    object File_AddDIR: TButton
      Left = 71
      Top = 311
      Width = 58
      Height = 25
      Caption = #30446#24405'(&I)'
      TabOrder = 5
      OnClick = File_AddDIRClick
    end
    object File_AddDIRALL: TButton
      Left = 135
      Top = 311
      Width = 58
      Height = 25
      Caption = #30446#24405'ALL'
      TabOrder = 6
      OnClick = File_AddDIRALLClick
    end
  end
  object GroupBox4: TGroupBox
    Left = 8
    Top = 306
    Width = 98
    Height = 78
    Caption = #23548#20837#26041#24335
    TabOrder = 1
    object Mode_after: TRadioButton
      Left = 8
      Top = 18
      Width = 86
      Height = 17
      Caption = #20174#23614#37096#28155#21152
      Checked = True
      TabOrder = 0
      TabStop = True
      OnClick = ImageStreamClick
    end
    object Mode_Insert: TRadioButton
      Left = 8
      Top = 35
      Width = 86
      Height = 17
      Caption = #25353#26631#21495#25554#20837
      TabOrder = 1
      OnClick = ImageStreamClick
    end
    object Mode_Bestrow: TRadioButton
      Left = 8
      Top = 52
      Width = 86
      Height = 17
      Caption = #25353#32534#21495#35206#30422
      TabOrder = 2
      OnClick = ImageStreamClick
    end
  end
  object GroupBox5: TGroupBox
    Left = 118
    Top = 306
    Width = 149
    Height = 78
    Caption = #32534#21495
    TabOrder = 2
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
    object Index_Start: TSpinEdit
      Left = 68
      Top = 18
      Width = 69
      Height = 21
      MaxValue = 10000000
      MinValue = 0
      TabOrder = 0
      Value = 9
      OnChange = ImageStreamClick
    end
    object Index_End: TSpinEdit
      Left = 68
      Top = 45
      Width = 69
      Height = 21
      MaxValue = 10000000
      MinValue = 0
      TabOrder = 1
      Value = 9
    end
  end
  object ProgressBar: TProgressBar
    Left = 0
    Top = 391
    Width = 483
    Height = 12
    Align = alBottom
    TabOrder = 5
  end
  object NoneOption: TGroupBox
    Left = 8
    Top = 63
    Width = 259
    Height = 237
    Caption = #31354#25968#25454#36873#39033
    TabOrder = 6
    object Label6: TLabel
      Left = 8
      Top = 22
      Width = 30
      Height = 12
      Caption = #25968#37327':'
    end
    object None_Count: TSpinEdit
      Left = 41
      Top = 19
      Width = 62
      Height = 21
      MaxValue = 100000
      MinValue = 1
      TabOrder = 0
      Value = 1
    end
  end
  object WavaOption: TGroupBox
    Left = 8
    Top = 63
    Width = 259
    Height = 237
    Caption = #38899#39057#36873#39033
    TabOrder = 4
    object GroupBox8: TGroupBox
      Left = 10
      Top = 17
      Width = 237
      Height = 51
      Caption = #21387#32553#36873#39033
      TabOrder = 0
      object Label4: TLabel
        Left = 94
        Top = 22
        Width = 78
        Height = 12
        Caption = #21387#32553#31561#32423'(0~9)'
      end
      object Wava_ZIP: TCheckBox
        Left = 10
        Top = 20
        Width = 65
        Height = 17
        Caption = 'ZIP'#21387#32553
        TabOrder = 0
        OnClick = ImageStreamClick
      end
      object Wava_ZIP_Level: TSpinEdit
        Left = 180
        Top = 18
        Width = 43
        Height = 21
        EditorEnabled = False
        MaxValue = 9
        MinValue = 0
        TabOrder = 1
        Value = 0
      end
    end
  end
  object DataOption: TGroupBox
    Left = 8
    Top = 63
    Width = 259
    Height = 237
    Caption = #25968#25454#36873#39033
    TabOrder = 8
    object GroupBox9: TGroupBox
      Left = 10
      Top = 17
      Width = 237
      Height = 51
      Caption = #21387#32553#36873#39033
      TabOrder = 0
      object Label5: TLabel
        Left = 94
        Top = 22
        Width = 78
        Height = 12
        Caption = #21387#32553#31561#32423'(0~9)'
      end
      object Data_ZIP: TCheckBox
        Left = 10
        Top = 20
        Width = 65
        Height = 17
        Caption = 'ZIP'#21387#32553
        Checked = True
        State = cbChecked
        TabOrder = 0
        OnClick = ImageStreamClick
      end
      object Data_ZIP_Level: TSpinEdit
        Left = 180
        Top = 18
        Width = 43
        Height = 21
        EditorEnabled = False
        MaxValue = 9
        MinValue = 0
        TabOrder = 1
        Value = 9
      end
    end
  end
  object ImageOption: TGroupBox
    Left = 8
    Top = 63
    Width = 259
    Height = 237
    Caption = #22270#20687#36873#39033
    TabOrder = 7
    object GroupBox7: TGroupBox
      Left = 10
      Top = 17
      Width = 237
      Height = 152
      Caption = #23548#20837#36873#39033
      TabOrder = 0
      object Label1: TLabel
        Left = 8
        Top = 71
        Width = 36
        Height = 12
        Caption = #36879#26126#33394
      end
      object Label7: TLabel
        Left = 8
        Top = 97
        Width = 48
        Height = 12
        Caption = #28151#21512#26041#24335
      end
      object Label8: TLabel
        Left = 8
        Top = 123
        Width = 48
        Height = 12
        Caption = #22270#20687#26684#24335
      end
      object Image_ImgAndOffset: TRadioButton
        Left = 8
        Top = 20
        Width = 82
        Height = 17
        Caption = #22270#29255#21644#22352#26631
        Checked = True
        TabOrder = 0
        TabStop = True
        OnClick = ImageStreamClick
      end
      object Image_Img: TRadioButton
        Left = 112
        Top = 20
        Width = 42
        Height = 17
        Caption = #22270#29255
        TabOrder = 1
        OnClick = ImageStreamClick
      end
      object Image_Offset: TRadioButton
        Left = 188
        Top = 20
        Width = 42
        Height = 17
        Caption = #22352#26631
        TabOrder = 2
        OnClick = ImageStreamClick
      end
      object Image_Alpha: TCheckBox
        Left = 8
        Top = 43
        Width = 98
        Height = 17
        Caption = #26377'Alpha'#36890#36947
        TabOrder = 3
        OnClick = ImageStreamClick
      end
      object Image_RLE: TCheckBox
        Left = 112
        Top = 43
        Width = 67
        Height = 17
        Caption = 'RLE'#21387#32553
        Checked = True
        State = cbChecked
        TabOrder = 4
        OnClick = ImageStreamClick
      end
      object Image_Cut: TCheckBox
        Left = 188
        Top = 43
        Width = 45
        Height = 17
        Caption = #20498#36716
        TabOrder = 5
        OnClick = ImageStreamClick
      end
      object Image_TColor: TRzColorEdit
        Left = 112
        Top = 68
        Width = 73
        Height = 20
        SelectedColor = clBlack
        ShowCustomColor = True
        TabOrder = 6
      end
      object Image_Blend: TComboBox
        Left = 112
        Top = 94
        Width = 118
        Height = 20
        Hint = #28151#21512#27169#24335
        Style = csDropDownList
        Ctl3D = False
        DropDownCount = 10
        ItemHeight = 0
        ParentCtl3D = False
        TabOrder = 7
        OnChange = Image_BlendChange
      end
      object Image_Format: TComboBox
        Left = 112
        Top = 120
        Width = 73
        Height = 20
        Hint = #28151#21512#27169#24335
        Style = csDropDownList
        Ctl3D = False
        DropDownCount = 10
        ItemHeight = 12
        ItemIndex = 0
        ParentCtl3D = False
        TabOrder = 8
        Text = 'A4R4G4B4'
        OnChange = ImageStreamClick
        Items.Strings = (
          'A4R4G4B4'
          'A1R5G5B5'
          'R5G6B5')
      end
      object Image_Window: TCheckBox
        Left = 188
        Top = 70
        Width = 45
        Height = 17
        Caption = #31383#21475
        TabOrder = 9
        OnClick = ImageStreamClick
      end
      object Image_Format_byFile: TCheckBox
        Left = 188
        Top = 122
        Width = 45
        Height = 17
        Caption = #25991#20214
        TabOrder = 10
        OnClick = ImageStreamClick
      end
    end
    object GroupBox6: TGroupBox
      Left = 10
      Top = 175
      Width = 237
      Height = 50
      Caption = #22352#26631#33719#24471#26041#24335
      TabOrder = 1
      object Image_Offset_File: TRadioButton
        Left = 8
        Top = 21
        Width = 89
        Height = 17
        Caption = #21516#21517#22352#26631#25991#20214
        Checked = True
        TabOrder = 0
        TabStop = True
        OnClick = ImageStreamClick
      end
      object Image_Offset_App: TRadioButton
        Left = 112
        Top = 21
        Width = 50
        Height = 17
        Caption = #22266#23450
        TabOrder = 1
        OnClick = ImageStreamClick
      end
      object Image_Offset_AppData: TEdit
        Left = 163
        Top = 19
        Width = 64
        Height = 20
        TabOrder = 2
        Text = '0,0'
      end
    end
  end
  object OpenDialog: TOpenDialog
    Filter = 
      #25152#26377#21487#35835#25991#20214'|*.*|BMP (*.bmp;*.dib)|*.bmp;*.dib|TARGA (*.tga)|*.tga|PNG' +
      ' (*.png)|*.png|WAV (*.wav)|*.wav|MP3 (*.mp3)|*.mp3'
    Options = [ofHideReadOnly, ofAllowMultiSelect, ofEnableSizing]
    Left = 285
    Top = 34
  end
end
