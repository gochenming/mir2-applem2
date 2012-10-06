object FrameGoods: TFrameGoods
  Left = 0
  Top = 0
  Width = 867
  Height = 453
  TabOrder = 0
  object GroupBoxBg: TbsSkinGroupBox
    Left = 0
    Top = 0
    Width = 867
    Height = 453
    HintImageIndex = 0
    TabOrder = 0
    SkinData = DSkinData
    SkinDataName = 'groupbox'
    DefaultFont.Charset = DEFAULT_CHARSET
    DefaultFont.Color = clWindowText
    DefaultFont.Height = 14
    DefaultFont.Name = 'Arial'
    DefaultFont.Style = []
    DefaultWidth = 0
    DefaultHeight = 0
    UseSkinFont = True
    RibbonStyle = False
    ImagePosition = bsipDefault
    TransparentMode = False
    CaptionImageIndex = -1
    RealHeight = -1
    AutoEnabledControls = True
    CheckedMode = False
    Checked = False
    DefaultAlignment = taLeftJustify
    DefaultCaptionHeight = 22
    BorderStyle = bvNone
    CaptionMode = True
    RollUpMode = False
    RollUpState = False
    NumGlyphs = 1
    Spacing = 2
    Caption = #25968#25454#24211#31649#29702#24037#20855' V2.0'
    Align = alClient
    UseSkinSize = True
    object bsSkinGroupBox3: TbsSkinGroupBox
      Left = 0
      Top = 22
      Width = 867
      Height = 62
      HintImageIndex = 0
      TabOrder = 0
      SkinData = DSkinData
      SkinDataName = 'groupbox'
      DefaultFont.Charset = DEFAULT_CHARSET
      DefaultFont.Color = clWindowText
      DefaultFont.Height = 14
      DefaultFont.Name = 'Arial'
      DefaultFont.Style = []
      DefaultWidth = 0
      DefaultHeight = 0
      UseSkinFont = True
      RibbonStyle = False
      ImagePosition = bsipDefault
      TransparentMode = True
      CaptionImageIndex = -1
      RealHeight = -1
      AutoEnabledControls = True
      CheckedMode = False
      Checked = False
      DefaultAlignment = taLeftJustify
      DefaultCaptionHeight = 22
      BorderStyle = bvFrame
      CaptionMode = True
      RollUpMode = False
      RollUpState = False
      NumGlyphs = 1
      Spacing = 2
      Caption = #36873#39033
      Align = alTop
      UseSkinSize = True
      object bsSkinStdLabel10: TbsSkinStdLabel
        Left = 11
        Top = 31
        Width = 66
        Height = 12
        EllipsType = bsetNone
        UseSkinFont = True
        UseSkinColor = True
        DefaultFont.Charset = DEFAULT_CHARSET
        DefaultFont.Color = clWindowText
        DefaultFont.Height = -12
        DefaultFont.Name = #23435#20307
        DefaultFont.Style = []
        SkinData = DSkinData
        SkinDataName = 'stdlabel'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBtnText
        Font.Height = -12
        Font.Name = #23435#20307
        Font.Style = []
        Caption = #36873#25321#25968#25454#24211':'
        ParentFont = False
      end
      object ButtonSave: TbsSkinButton
        Left = 239
        Top = 26
        Width = 113
        Height = 25
        HintImageIndex = 0
        TabOrder = 0
        SkinData = DSkinData
        SkinDataName = 'button'
        DefaultFont.Charset = DEFAULT_CHARSET
        DefaultFont.Color = clWindowText
        DefaultFont.Height = 14
        DefaultFont.Name = 'Arial'
        DefaultFont.Style = []
        DefaultWidth = 0
        DefaultHeight = 25
        UseSkinFont = True
        CheckedMode = False
        ImageIndex = -1
        AlwaysShowLayeredFrame = False
        UseSkinSize = True
        UseSkinFontColor = True
        RepeatMode = False
        RepeatInterval = 100
        AllowAllUp = False
        TabStop = True
        CanFocused = True
        Down = False
        GroupIndex = 0
        Caption = #20445#23384#35774#32622'(&S)'
        NumGlyphs = 2
        Spacing = 1
        Enabled = False
        OnClick = ButtonSaveClick
      end
      object ComboBoxDBList: TbsSkinComboBox
        Left = 83
        Top = 27
        Width = 134
        Height = 21
        HintImageIndex = 0
        TabOrder = 1
        SkinData = DSkinData
        SkinDataName = 'captioncombobox'
        DefaultFont.Charset = DEFAULT_CHARSET
        DefaultFont.Color = clWindowText
        DefaultFont.Height = 14
        DefaultFont.Name = 'Arial'
        DefaultFont.Style = []
        DefaultWidth = 0
        DefaultHeight = 21
        UseSkinFont = True
        UseSkinSize = True
        ToolButtonStyle = False
        AlphaBlend = False
        AlphaBlendValue = 0
        AlphaBlendAnimation = False
        ListBoxCaption = #35831#36873#25321
        ListBoxCaptionMode = True
        ListBoxDefaultFont.Charset = DEFAULT_CHARSET
        ListBoxDefaultFont.Color = clWindowText
        ListBoxDefaultFont.Height = 14
        ListBoxDefaultFont.Name = 'Arial'
        ListBoxDefaultFont.Style = []
        ListBoxDefaultCaptionFont.Charset = DEFAULT_CHARSET
        ListBoxDefaultCaptionFont.Color = clWindowText
        ListBoxDefaultCaptionFont.Height = 14
        ListBoxDefaultCaptionFont.Name = 'Arial'
        ListBoxDefaultCaptionFont.Style = []
        ListBoxDefaultItemHeight = 20
        ListBoxCaptionAlignment = taLeftJustify
        ListBoxUseSkinFont = True
        ListBoxUseSkinItemHeight = True
        ListBoxWidth = 0
        HideSelection = True
        AutoComplete = True
        ImageIndex = -1
        CharCase = ecNormal
        DefaultColor = clWindow
        Text = 'Text'
        ItemIndex = -1
        DropDownCount = 5
        HorizontalExtent = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = 14
        Font.Name = 'Arial'
        Font.Style = []
        Sorted = False
        Style = bscbFixedStyle
        OnChange = ComboBoxDBListChange
      end
      object ButtonLoad: TbsSkinButton
        Left = 358
        Top = 26
        Width = 113
        Height = 25
        HintImageIndex = 0
        TabOrder = 2
        SkinData = DSkinData
        SkinDataName = 'button'
        DefaultFont.Charset = DEFAULT_CHARSET
        DefaultFont.Color = clWindowText
        DefaultFont.Height = 14
        DefaultFont.Name = 'Arial'
        DefaultFont.Style = []
        DefaultWidth = 0
        DefaultHeight = 25
        UseSkinFont = True
        CheckedMode = False
        ImageIndex = -1
        AlwaysShowLayeredFrame = False
        UseSkinSize = True
        UseSkinFontColor = True
        RepeatMode = False
        RepeatInterval = 100
        AllowAllUp = False
        TabStop = True
        CanFocused = True
        Down = False
        GroupIndex = 0
        Caption = #37325#26032#21152#36733#35774#32622'(&R)'
        NumGlyphs = 2
        Spacing = 1
        Enabled = False
        OnClick = ButtonLoadClick
      end
      object ButtonRefItemID: TbsSkinButton
        Left = 477
        Top = 26
        Width = 156
        Height = 25
        HintImageIndex = 0
        TabOrder = 3
        SkinData = DSkinData
        SkinDataName = 'button'
        DefaultFont.Charset = DEFAULT_CHARSET
        DefaultFont.Color = clWindowText
        DefaultFont.Height = 14
        DefaultFont.Name = 'Arial'
        DefaultFont.Style = []
        DefaultWidth = 0
        DefaultHeight = 25
        UseSkinFont = True
        CheckedMode = False
        ImageIndex = -1
        AlwaysShowLayeredFrame = False
        UseSkinSize = True
        UseSkinFontColor = True
        RepeatMode = False
        RepeatInterval = 100
        AllowAllUp = False
        TabStop = True
        CanFocused = True
        Down = False
        GroupIndex = 0
        Caption = #37325#26032#25490#21015#29289#21697#25968#25454#24211'ID(&L)'
        NumGlyphs = 2
        Spacing = 1
        Enabled = False
        OnClick = ButtonRefItemIDClick
      end
    end
    object DBPageControl: TbsSkinPageControl
      Left = 0
      Top = 84
      Width = 867
      Height = 369
      ActivePage = bsSkinTabSheet1
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBtnText
      Font.Height = 14
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnChange = DBPageControlChange
      MouseWheelSupport = False
      TabExtededDraw = False
      ButtonTabSkinDataName = 'resizetoolbutton'
      TabsOffset = 0
      TabSpacing = 1
      TextInHorizontal = False
      TabsInCenter = False
      FreeOnClose = False
      ShowCloseButtons = False
      TabsBGTransparent = True
      DefaultFont.Charset = DEFAULT_CHARSET
      DefaultFont.Color = clBtnText
      DefaultFont.Height = 14
      DefaultFont.Name = 'Arial'
      DefaultFont.Style = []
      UseSkinFont = True
      DefaultItemHeight = 20
      SkinData = DSkinData
      SkinDataName = 'tab'
      object bsSkinTabSheet1: TbsSkinTabSheet
        Caption = 'StdItems.DB'
        object ListViewStdItems: TbsSkinListView
          Left = 0
          Top = 0
          Width = 846
          Height = 329
          DrawSkin = True
          DrawSkinLines = True
          ItemSkinDataName = 'listbox'
          CheckSkinDataName = 'checkbox'
          DefaultFont.Charset = DEFAULT_CHARSET
          DefaultFont.Color = clWindowText
          DefaultFont.Height = 14
          DefaultFont.Name = 'Arial'
          DefaultFont.Style = []
          DefaultColor = clWindow
          UseSkinFont = True
          SkinData = DSkinData
          SkinDataName = 'listview'
          Align = alClient
          Columns = <
            item
              Caption = #29289#21697'ID'
              ImageIndex = 0
            end
            item
              Caption = #29289#21697#21517#31216
              Width = 105
            end
            item
              Alignment = taCenter
              Caption = #20844#24320
              Width = 40
            end
            item
              Alignment = taCenter
              Caption = #20132#26131
              Width = 40
            end
            item
              Alignment = taCenter
              Caption = #23384#20179
              Width = 40
            end
            item
              Alignment = taCenter
              Caption = #20462#29702
              Width = 40
            end
            item
              Alignment = taCenter
              Caption = #20002#24323
              Width = 40
            end
            item
              Alignment = taCenter
              Caption = #25481#33853
              Width = 40
            end
            item
              Alignment = taCenter
              Caption = #25171#36896
              Width = 40
            end
            item
              Alignment = taCenter
              Caption = #20986#21806
              Width = 40
            end
            item
              Alignment = taCenter
              Caption = #28040#22833
              Width = 40
            end
            item
              Alignment = taCenter
              Caption = #26174
              Width = 25
            end
            item
              Alignment = taCenter
              Caption = #25441
              Width = 25
            end
            item
              Alignment = taCenter
              Caption = #29305
              Width = 25
            end
            item
              Alignment = taCenter
              Caption = #25552
              Width = 25
            end
            item
              Caption = #22791#27880
              Width = 307
            end>
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = 14
          Font.Name = 'Arial'
          Font.Style = []
          GridLines = True
          MultiSelect = True
          ReadOnly = True
          RowSelect = True
          ParentFont = False
          ParentShowHint = False
          ShowHint = False
          TabOrder = 0
          ViewStyle = vsReport
          HeaderSkinDataName = 'resizetoolbutton'
          HScrollBar = ScrollBarStdItemsBottom
          VScrollBar = ScrollBarStditemsRight
          OnColumnClick = ListViewStdItemsColumnClick
          OnCompare = ListViewStdItemsCompare
          OnMouseDown = ListViewStdItemsMouseDown
        end
        object ScrollBarStditemsRight: TbsSkinScrollBar
          Left = 846
          Top = 0
          Width = 19
          Height = 329
          HintImageIndex = 0
          TabOrder = 1
          Visible = False
          SkinData = DSkinData
          SkinDataName = 'vscrollbar'
          DefaultFont.Charset = DEFAULT_CHARSET
          DefaultFont.Color = clWindowText
          DefaultFont.Height = 14
          DefaultFont.Name = 'Arial'
          DefaultFont.Style = []
          DefaultWidth = 19
          DefaultHeight = 0
          UseSkinFont = True
          Both = False
          BothMarkerWidth = 0
          BothSkinDataName = 'bothhscrollbar'
          CanFocused = False
          Align = alRight
          Kind = sbVertical
          PageSize = 20
          Min = 0
          Max = 29
          Position = 0
          SmallChange = 1
          LargeChange = 20
        end
        object ScrollBarStdItemsBottom: TbsSkinScrollBar
          Left = 0
          Top = 329
          Width = 865
          Height = 19
          HintImageIndex = 0
          TabOrder = 2
          SkinData = DSkinData
          SkinDataName = 'hscrollbar'
          DefaultFont.Charset = DEFAULT_CHARSET
          DefaultFont.Color = clWindowText
          DefaultFont.Height = 14
          DefaultFont.Name = 'Arial'
          DefaultFont.Style = []
          DefaultWidth = 0
          DefaultHeight = 19
          UseSkinFont = True
          Both = False
          BothMarkerWidth = 19
          BothSkinDataName = 'bothhscrollbar'
          CanFocused = False
          Align = alBottom
          Kind = sbHorizontal
          PageSize = 846
          Min = 0
          Max = 921
          Position = 0
          SmallChange = 19
          LargeChange = 19
        end
      end
      object bsSkinTabSheet2: TbsSkinTabSheet
        Caption = 'Magic.DB'
        object ListViewMagic: TbsSkinListView
          Left = 0
          Top = 0
          Width = 846
          Height = 329
          DrawSkin = True
          DrawSkinLines = True
          ItemSkinDataName = 'listbox'
          CheckSkinDataName = 'checkbox'
          DefaultFont.Charset = DEFAULT_CHARSET
          DefaultFont.Color = clWindowText
          DefaultFont.Height = 14
          DefaultFont.Name = 'Arial'
          DefaultFont.Style = []
          DefaultColor = clWindow
          UseSkinFont = True
          SkinData = DSkinData
          SkinDataName = 'listview'
          Align = alClient
          Columns = <
            item
              Caption = #25216#33021'ID'
              ImageIndex = 0
            end
            item
              Caption = #25216#33021#21517#31216
              Width = 105
            end
            item
              Alignment = taCenter
              Caption = #20844#24320
              Width = 40
            end
            item
              Alignment = taCenter
              Caption = #32844#19994
              Width = 40
            end
            item
              Caption = #24310#26102
              Width = 60
            end
            item
              Caption = #38388#38548
              Width = 60
            end
            item
              Caption = #22791#27880
              Width = 607
            end>
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = 14
          Font.Name = 'Arial'
          Font.Style = []
          GridLines = True
          MultiSelect = True
          ReadOnly = True
          RowSelect = True
          ParentFont = False
          ParentShowHint = False
          ShowHint = False
          TabOrder = 0
          ViewStyle = vsReport
          HeaderSkinDataName = 'resizetoolbutton'
          HScrollBar = ScrollBarMagicBottom
          VScrollBar = ScrollBarMagicRight
          OnMouseDown = ListViewMagicMouseDown
        end
        object ScrollBarMagicRight: TbsSkinScrollBar
          Left = 846
          Top = 0
          Width = 19
          Height = 329
          HintImageIndex = 0
          TabOrder = 1
          Visible = False
          SkinData = DSkinData
          SkinDataName = 'vscrollbar'
          DefaultFont.Charset = DEFAULT_CHARSET
          DefaultFont.Color = clWindowText
          DefaultFont.Height = 14
          DefaultFont.Name = 'Arial'
          DefaultFont.Style = []
          DefaultWidth = 19
          DefaultHeight = 0
          UseSkinFont = True
          Both = False
          BothMarkerWidth = 0
          BothSkinDataName = 'bothhscrollbar'
          CanFocused = False
          Align = alRight
          Kind = sbVertical
          PageSize = 20
          Min = 0
          Max = 100
          Position = 0
          SmallChange = 1
          LargeChange = 20
        end
        object ScrollBarMagicBottom: TbsSkinScrollBar
          Left = 0
          Top = 329
          Width = 865
          Height = 19
          HintImageIndex = 0
          TabOrder = 2
          SkinData = DSkinData
          SkinDataName = 'hscrollbar'
          DefaultFont.Charset = DEFAULT_CHARSET
          DefaultFont.Color = clWindowText
          DefaultFont.Height = 14
          DefaultFont.Name = 'Arial'
          DefaultFont.Style = []
          DefaultWidth = 0
          DefaultHeight = 19
          UseSkinFont = True
          Both = False
          BothMarkerWidth = 19
          BothSkinDataName = 'bothhscrollbar'
          CanFocused = False
          Align = alBottom
          Kind = sbHorizontal
          PageSize = 846
          Min = 0
          Max = 961
          Position = 0
          SmallChange = 19
          LargeChange = 19
        end
      end
    end
  end
  object DSkinData: TbsSkinData
    DlgTreeViewDrawSkin = True
    DlgTreeViewItemSkinDataName = 'listbox'
    DlgListViewDrawSkin = True
    DlgListViewItemSkinDataName = 'listbox'
    SkinnableForm = True
    AnimationForAllWindows = True
    EnableSkinEffects = True
    ShowButtonGlowFrames = True
    ShowCaptionButtonGlowFrames = True
    ShowLayeredBorders = True
    AeroBlurEnabled = True
    SkinList = FormMain.CompressedSkinList
    SkinIndex = 0
    Left = 296
    Top = 8
  end
  object Query: TQuery
    Left = 329
    Top = 6
  end
end
