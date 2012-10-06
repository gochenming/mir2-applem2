object FormMain: TFormMain
  Left = 320
  Top = 100
  Caption = #19987#29992#30495#24425'WIL'#32534#36753#22120' 2009-5-20('#21152#23494#29256')'
  ClientHeight = 572
  ClientWidth = 689
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 12
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 275
    Height = 572
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 0
    object Label1: TLabel
      Left = 15
      Top = 16
      Width = 48
      Height = 12
      Caption = #25991#20214#21517#65306
    end
    object Label8: TLabel
      Left = 42
      Top = 259
      Width = 24
      Height = 12
      Alignment = taRightJustify
      Caption = #26579#33394
    end
    object edtFileName: TEdit
      Left = 64
      Top = 12
      Width = 170
      Height = 20
      ReadOnly = True
      TabOrder = 0
    end
    object btnOpenDig: TButton
      Left = 240
      Top = 9
      Width = 29
      Height = 25
      Caption = '...'
      TabOrder = 1
      OnClick = btnOpenDigClick
    end
    object btnFront: TButton
      Left = 15
      Top = 40
      Width = 122
      Height = 25
      Caption = #19978#19968#24352
      TabOrder = 2
      OnClick = btnNextClick
    end
    object btnNext: TButton
      Left = 152
      Top = 40
      Width = 117
      Height = 25
      Caption = #19979#19968#24352
      TabOrder = 3
      OnClick = btnNextClick
    end
    object btnGoto: TButton
      Left = 152
      Top = 73
      Width = 117
      Height = 25
      Caption = #36339#36716
      TabOrder = 4
      OnClick = btnGotoClick
    end
    object btnDel: TButton
      Left = 15
      Top = 73
      Width = 122
      Height = 25
      Caption = #21024#38500
      TabOrder = 5
      OnClick = btnDelClick
    end
    object btnAutoPlay: TButton
      Left = 15
      Top = 106
      Width = 122
      Height = 25
      Caption = #33258#21160#25773#25918
      TabOrder = 6
      OnClick = btnAutoPlayClick
    end
    object btnStop: TButton
      Left = 152
      Top = 106
      Width = 117
      Height = 25
      Caption = #20572#27490
      TabOrder = 7
      OnClick = btnStopClick
    end
    object btnOut: TButton
      Left = 152
      Top = 139
      Width = 117
      Height = 25
      Caption = #23548#20986
      TabOrder = 8
      OnClick = btnOutClick
    end
    object btnInput: TButton
      Left = 15
      Top = 139
      Width = 122
      Height = 25
      Caption = #23548#20837
      TabOrder = 9
      OnClick = btnInputClick
    end
    object btnBatchOut: TButton
      Left = 152
      Top = 207
      Width = 117
      Height = 25
      Caption = #25209#37327#23548#20986
      TabOrder = 10
      OnClick = btnBatchOutClick
    end
    object btnAddBitmap: TButton
      Left = 15
      Top = 174
      Width = 122
      Height = 25
      Caption = #28155#21152#22270#29255
      TabOrder = 11
      OnClick = btnAddBitmapClick
    end
    object btnCreateWil: TButton
      Left = 152
      Top = 174
      Width = 117
      Height = 25
      Caption = #21019#24314#26032#25991#20214
      TabOrder = 12
      OnClick = btnCreateWilClick
    end
    object btnBatchInput: TButton
      Left = 15
      Top = 207
      Width = 122
      Height = 25
      Caption = #25209#37327#23548#20837
      TabOrder = 13
      OnClick = btnBatchInputClick
    end
    object GroupBox1: TGroupBox
      Left = 15
      Top = 277
      Width = 254
      Height = 141
      Caption = #22270#29255#20449#24687
      TabOrder = 14
      object Label2: TLabel
        Left = 9
        Top = 21
        Width = 36
        Height = 12
        Caption = #31867#22411#65306
      end
      object Label3: TLabel
        Left = 9
        Top = 44
        Width = 36
        Height = 12
        Caption = #23610#23544#65306
      end
      object Label4: TLabel
        Left = 9
        Top = 66
        Width = 42
        Height = 12
        Caption = 'x'#22352#26631#65306
      end
      object Label5: TLabel
        Left = 9
        Top = 90
        Width = 42
        Height = 12
        Caption = 'y'#22352#26631#65306
      end
      object Label6: TLabel
        Left = 9
        Top = 114
        Width = 36
        Height = 12
        Caption = #32534#21495#65306
      end
      object lblClass: TLabel
        Left = 62
        Top = 21
        Width = 187
        Height = 12
        AutoSize = False
      end
      object lblSize: TLabel
        Left = 62
        Top = 44
        Width = 187
        Height = 12
        AutoSize = False
      end
      object lblX: TLabel
        Left = 62
        Top = 66
        Width = 69
        Height = 12
        AutoSize = False
      end
      object lblY: TLabel
        Left = 62
        Top = 90
        Width = 69
        Height = 12
        AutoSize = False
      end
      object lblIndex: TLabel
        Left = 62
        Top = 114
        Width = 187
        Height = 12
        AutoSize = False
      end
      object btnChangeX: TButton
        Left = 137
        Top = 62
        Width = 50
        Height = 22
        Caption = #21464#26356
        TabOrder = 0
        OnClick = btnChangeXClick
      end
      object btnChangeY: TButton
        Left = 137
        Top = 86
        Width = 50
        Height = 22
        Caption = #21464#26356
        TabOrder = 1
        OnClick = btnChangeYClick
      end
      object Button1: TButton
        Left = 192
        Top = 62
        Width = 53
        Height = 46
        Caption = #25209#37327
        TabOrder = 2
        OnClick = Button1Click
      end
    end
    object GroupBox2: TGroupBox
      Left = 15
      Top = 424
      Width = 254
      Height = 137
      Caption = #26174#31034#25511#21046
      TabOrder = 15
      object Label7: TLabel
        Left = 49
        Top = 112
        Width = 120
        Height = 12
        Caption = 'http://www.mir2k.com'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -12
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
      end
      object rbZoom50: TRadioButton
        Left = 8
        Top = 20
        Width = 43
        Height = 17
        Caption = '50%'
        TabOrder = 0
        OnClick = rbZoom100Click
      end
      object rbZoom100: TRadioButton
        Left = 91
        Top = 20
        Width = 43
        Height = 17
        Caption = '100%'
        Checked = True
        TabOrder = 1
        TabStop = True
        OnClick = rbZoom100Click
      end
      object rbZoom200: TRadioButton
        Left = 175
        Top = 20
        Width = 43
        Height = 17
        Caption = '200%'
        TabOrder = 2
        OnClick = rbZoom100Click
      end
      object rbZoomAuto: TRadioButton
        Left = 175
        Top = 43
        Width = 75
        Height = 17
        Caption = #33258#21160#32553#25918
        TabOrder = 3
        OnClick = rbZoom100Click
      end
      object rbZoom800: TRadioButton
        Left = 91
        Top = 43
        Width = 43
        Height = 17
        Caption = '800%'
        TabOrder = 4
        OnClick = rbZoom100Click
      end
      object rbZoom400: TRadioButton
        Left = 8
        Top = 43
        Width = 43
        Height = 17
        Caption = '400%'
        TabOrder = 5
        OnClick = rbZoom100Click
      end
      object chkJmpNilBitmap: TCheckBox
        Left = 9
        Top = 66
        Width = 81
        Height = 17
        Caption = #36879#26126#26174#31034
        TabOrder = 6
        OnClick = chkJmpNilBitmapClick
      end
      object chkEncrypt: TCheckBox
        Left = 158
        Top = 66
        Width = 85
        Height = 17
        Caption = #35299#23494#22270#20687
        Enabled = False
        TabOrder = 7
      end
      object chkLineShow: TCheckBox
        Left = 9
        Top = 89
        Width = 104
        Height = 17
        Caption = #25353#23454#38469#22352#26631#26174#31034
        TabOrder = 8
        OnClick = rbZoom100Click
      end
      object chkShowLine: TCheckBox
        Left = 158
        Top = 89
        Width = 89
        Height = 17
        Caption = #26174#31034#22352#26631#32447
        TabOrder = 9
      end
    end
    object CKSetTransparentColor: TCheckBox
      Left = 15
      Top = 236
      Width = 75
      Height = 17
      Caption = #26367#25442#36879#26126#33394
      TabOrder = 16
      OnClick = CKSetTransparentColorClick
    end
    object CKAutoCutOut: TCheckBox
      Left = 152
      Top = 236
      Width = 97
      Height = 17
      Caption = #33258#21160#35009#21098#22270#20687
      TabOrder = 17
      OnClick = CKAutoCutOutClick
    end
    object EdTransparentColor: TEdit
      Left = 96
      Top = 234
      Width = 41
      Height = 20
      TabOrder = 18
      Text = '0'
    end
    object ComboBox1: TComboBox
      Left = 72
      Top = 256
      Width = 65
      Height = 20
      Style = csDropDownList
      ItemHeight = 12
      ItemIndex = 0
      TabOrder = 19
      Text = #26080
      OnChange = ComboBox1Change
      Items.Strings = (
        #26080
        #28784#30333
        #22686#20142
        #32418#33394
        #32511#33394
        #34013#33394
        #40644#33394)
    end
  end
  object Panel2: TPanel
    Left = 275
    Top = 0
    Width = 414
    Height = 572
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object Splitter1: TSplitter
      Left = 0
      Top = 340
      Width = 414
      Height = 1
      Cursor = crVSplit
      Align = alBottom
      ExplicitTop = 418
    end
    object ScrollBox: TScrollBox
      Left = 0
      Top = 0
      Width = 414
      Height = 340
      Align = alClient
      Color = clWhite
      ParentColor = False
      TabOrder = 0
      OnResize = ScrollBoxResize
      object Image1: TImage
        Left = 0
        Top = 0
        Width = 352
        Height = 295
        AutoSize = True
      end
    end
    object DrawGrid: TDrawGrid
      Left = 0
      Top = 341
      Width = 414
      Height = 231
      Align = alBottom
      Color = clBtnFace
      ColCount = 6
      DefaultRowHeight = 64
      FixedCols = 0
      RowCount = 1
      FixedRows = 0
      TabOrder = 1
      OnDrawCell = DrawGridDrawCell
      OnSelectCell = DrawGridSelectCell
    end
  end
  object OpenDialog: TOpenDialog
    Filter = #20256#22855#22270#20687#23384#20648#25991#20214'|*.wil|'#25152#26377#25991#20214'|*.*'
    Left = 8
    Top = 32
  end
  object Timer: TTimer
    Enabled = False
    Interval = 200
    OnTimer = TimerTimer
    Left = 8
    Top = 64
  end
  object SaveDialog: TSaveDialog
    Filter = #20256#22855#25968#25454#25991#20214'(*.wil)|*.wil'
    Left = 8
    Top = 96
  end
  object OpenPictureDialog: TOpenPictureDialog
    Filter = 
      'All (*.gif;*.jpg;*.jpeg;*.jpg;*.jpeg;*.bmp;*.ico;*.emf;*.wmf)|*.' +
      'gif;*.jpg;*.jpeg;*.jpg;*.jpeg;*.bmp;*.ico;*.emf;*.wmf|GIF Image ' +
      '(*.gif)|*.gif|JPEG-Grafikdatei (*.jpg)|*.jpg|JPEG-Grafikdatei (*' +
      '.jpeg)|*.jpeg|JPEG Image File (*.jpg)|*.jpg|JPEG Image File (*.j' +
      'peg)|*.jpeg|Bitmaps (*.bmp)|*.bmp|Icons (*.ico)|*.ico|Enhanced M' +
      'etafiles (*.emf)|*.emf|Metafiles (*.wmf)|*.wmf'
    Left = 8
    Top = 128
  end
  object SavePictureDialog: TSavePictureDialog
    Filter = 
      'All (*.gif;*.jpg;*.jpeg;*.jpg;*.jpeg;*.bmp;*.ico;*.emf;*.wmf)|*.' +
      'gif;*.jpg;*.jpeg;*.jpg;*.jpeg;*.bmp;*.ico;*.emf;*.wmf|GIF Image ' +
      '(*.gif)|*.gif|JPEG-Grafikdatei (*.jpg)|*.jpg|JPEG-Grafikdatei (*' +
      '.jpeg)|*.jpeg|JPEG Image File (*.jpg)|*.jpg|JPEG Image File (*.j' +
      'peg)|*.jpeg|Bitmaps (*.bmp)|*.bmp|Icons (*.ico)|*.ico|Enhanced M' +
      'etafiles (*.emf)|*.emf|Metafiles (*.wmf)|*.wmf'
    Left = 8
    Top = 160
  end
end
