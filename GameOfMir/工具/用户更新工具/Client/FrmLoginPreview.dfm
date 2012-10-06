object FormPreview: TFormPreview
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsNone
  Caption = 'FormPreview'
  ClientHeight = 592
  ClientWidth = 724
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 12
  object imgBg: TImage
    Left = 0
    Top = 0
    Width = 724
    Height = 592
    Align = alClient
    OnMouseDown = imgBgMouseDown
    ExplicitLeft = -288
    ExplicitTop = -329
    ExplicitWidth = 722
    ExplicitHeight = 579
  end
  object LabelLog: TRzLabel
    Left = 115
    Top = 470
    Width = 150
    Height = 12
    Caption = #27491#22312#33719#21462#26381#21153#22120#26356#26032#21015#34920'...'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clYellow
    Font.Height = -12
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object ProgressNow: TRzProgressStatus
    Left = 105
    Top = 492
    Width = 130
    Height = 16
    ParentFillColor = False
    ParentShowHint = False
    BarColor = clBlack
    BarColorStop = clGreen
    BarStyle = bsGradient
    GradientDirection = gdVerticalEnd
    PartsComplete = 0
    Percent = 100
    TotalParts = 0
  end
  object ProgressAll: TRzProgressStatus
    Left = 105
    Top = 517
    Width = 130
    Height = 16
    ParentFillColor = False
    ParentShowHint = False
    BarColor = clBlack
    BarColorStop = clRed
    BarStyle = bsGradient
    GradientDirection = gdVerticalEnd
    PartsComplete = 0
    Percent = 100
    TotalParts = 0
  end
  object LabelNow: TRzLabel
    Left = 235
    Top = 494
    Width = 30
    Height = 12
    Alignment = taCenter
    AutoSize = False
    Caption = '100%'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -12
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object LabelAll: TRzLabel
    Left = 235
    Top = 520
    Width = 30
    Height = 12
    Alignment = taCenter
    AutoSize = False
    Caption = '110%'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -12
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object RzLabel1: TRzLabel
    Left = 259
    Top = 165
    Width = 78
    Height = 12
    Caption = 'Ver 3.3.1.127'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object tvServer: TTreeView
    Left = 34
    Top = 216
    Width = 194
    Height = 230
    AutoExpand = True
    BevelInner = bvNone
    BevelOuter = bvNone
    BorderStyle = bsNone
    BorderWidth = 6
    Color = clBlack
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clYellow
    Font.Height = -12
    Font.Name = #23435#20307
    Font.Style = []
    Indent = 19
    ParentFont = False
    ReadOnly = True
    TabOrder = 0
    OnCustomDrawItem = tvServerCustomDrawItem
    Items.NodeData = {
      0101000000210000000000000000000000FFFFFFFFFFFFFFFF00000000030000
      0004CC53BF7E27593A532F0000000000000000000000FFFFFFFFFFFFFFFF0000
      0000000000000BF182C496894E38975B00F182C4962B00FD70DF705D002F0000
      000000000000000000FFFFFFFFFFFFFFFF00000000000000000BDB76164E898F
      4C715B00DB76164E2B00D191A7785D00290000000000000000000000FFFFFFFF
      FFFFFFFF0000000000000000086E6629590C54865E5B004B6DD58B5D00}
  end
  object WebBrowser: TWebBrowserWithUI
    Left = 241
    Top = 199
    Width = 448
    Height = 246
    TabOrder = 1
    OnDownloadBegin = WebBrowserDownloadBegin
    OnNavigateComplete2 = WebBrowserNavigateComplete2
    UISettings.EnableScrollBars = False
    UISettings.EnableFlatScrollBars = True
    UISettings.EnableContextMenu = False
    UISettings.Enable3DBorder = False
    ControlData = {
      4C0000004D2E00006D1900000000000000000000000000000000000000000000
      000000004C000000000000000000000001000000E0D057007335CF11AE690800
      2B2E126208000000000000004C0000000114020000000000C000000000000046
      8000000000000000000000000000000000000000000000000000000000000000
      00000000000000000100000000000000000000000000000000000000}
  end
  object BtnPlay: TEzRgnBtn
    Left = 282
    Top = 463
    Width = 98
    Height = 37
    Enabled = True
    PaintMode = pmNormal
  end
  object BtnUpdating: TEzRgnBtn
    Left = 384
    Top = 463
    Width = 98
    Height = 37
    Enabled = True
    PaintMode = pmNormal
  end
  object EzRgnBtn1: TEzRgnBtn
    Left = 488
    Top = 463
    Width = 98
    Height = 37
    Enabled = True
    PaintMode = pmNormal
  end
  object EzRgnBtn2: TEzRgnBtn
    Left = 591
    Top = 463
    Width = 98
    Height = 37
    Enabled = True
    PaintMode = pmNormal
  end
  object BtnExit: TEzRgnBtn
    Left = 591
    Top = 505
    Width = 98
    Height = 37
    Enabled = True
    PaintMode = pmNormal
    OnClick = BtnCloseClick
  end
  object EzRgnBtn4: TEzRgnBtn
    Left = 488
    Top = 505
    Width = 98
    Height = 37
    Enabled = True
    PaintMode = pmNormal
  end
  object EzRgnBtn3: TEzRgnBtn
    Left = 385
    Top = 505
    Width = 98
    Height = 37
    Enabled = True
    PaintMode = pmNormal
  end
  object BtnSetup: TEzRgnBtn
    Left = 282
    Top = 505
    Width = 98
    Height = 37
    Enabled = True
    PaintMode = pmNormal
  end
  object BtnMin: TEzRgnBtn
    Left = 653
    Top = 165
    Width = 17
    Height = 16
    Enabled = True
    PaintMode = pmNormal
    OnClick = BtnMinClick
  end
  object BtnClose: TEzRgnBtn
    Left = 669
    Top = 165
    Width = 17
    Height = 16
    Enabled = True
    PaintMode = pmNormal
    OnClick = BtnCloseClick
  end
end
