object FormMain: TFormMain
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = #26032#28909#34880#20256#22855
  ClientHeight = 579
  ClientWidth = 722
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
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 12
  object ImageBg: TImage
    Left = 0
    Top = 0
    Width = 722
    Height = 579
    Align = alClient
    OnMouseDown = ImageBgMouseDown
    ExplicitWidth = 721
    ExplicitHeight = 577
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
  object RzLabel1: TRzLabel
    Left = 259
    Top = 165
    Width = 66
    Height = 12
    Caption = 'Ver 1.0.0.0'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
    Transparent = True
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
  object TreeViewServer: TTreeView
    Left = 34
    Top = 216
    Width = 194
    Height = 230
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
    TabOrder = 2
    OnChange = TreeViewServerChange
    OnChanging = TreeViewServerChanging
    OnCustomDrawItem = TreeViewServerCustomDrawItem
    Items.NodeData = {
      01010000002B0000000000000000000000FFFFFFFFFFFFFFFF00000000000000
      0009636B2857B783D653175268882E002E002E00}
  end
  object BtnUpdating: TEzRgnBtn
    Left = 384
    Top = 463
    Width = 98
    Height = 37
    Enabled = False
    PaintMode = pmNormal
    OnClick = BtnUpdatingClick
  end
  object BtnPlay: TEzRgnBtn
    Left = 282
    Top = 463
    Width = 98
    Height = 37
    Enabled = False
    PaintMode = pmNormal
    OnClick = BtnPlayClick
  end
  object BtnSetup: TEzRgnBtn
    Left = 282
    Top = 505
    Width = 98
    Height = 37
    Enabled = True
    PaintMode = pmNormal
    OnClick = BtnSetupClick
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
  object WebBrowser: TWebBrowserWithUI
    Left = 241
    Top = 199
    Width = 448
    Height = 246
    TabOrder = 7
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
  object EzRgnBtn1: TEzRgnBtn
    Left = 488
    Top = 463
    Width = 98
    Height = 37
    Enabled = False
    PaintMode = pmNormal
    OnClick = EzRgnBtn1Click
  end
  object EzRgnBtn2: TEzRgnBtn
    Left = 591
    Top = 463
    Width = 98
    Height = 37
    Enabled = False
    PaintMode = pmNormal
    OnClick = EzRgnBtn2Click
  end
  object EzRgnBtn3: TEzRgnBtn
    Left = 385
    Top = 505
    Width = 98
    Height = 37
    Enabled = True
    PaintMode = pmNormal
    OnClick = EzRgnBtn3Click
  end
  object EzRgnBtn4: TEzRgnBtn
    Left = 488
    Top = 505
    Width = 98
    Height = 37
    Enabled = True
    PaintMode = pmNormal
    OnClick = EzRgnBtn4Click
  end
  object rs: TRSA
    CommonalityKey = '65537'
    CommonalityMode = '580550492449157111948032681889'
    Left = 24
    Top = 152
  end
  object tmrStart: TTimer
    Enabled = False
    Interval = 10
    OnTimer = tmrStartTimer
    Left = 56
    Top = 152
  end
  object xmldSetup: TXMLDocument
    Options = [doNodeAutoCreate, doNodeAutoIndent, doAttrNull, doAutoPrefix, doNamespaceDecl]
    Left = 88
    Top = 152
    DOMVendorDesc = 'MSXML'
  end
  object tmrCheck: TTimer
    Interval = 3000
    OnTimer = tmrCheckTimer
    Left = 120
    Top = 152
  end
  object DeleteTimer: TTimer
    Enabled = False
    Interval = 2000
    OnTimer = DeleteTimerTimer
    Left = 152
    Top = 152
  end
end
