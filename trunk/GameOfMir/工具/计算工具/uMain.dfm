object MainForm: TMainForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'AppleM2 NeedLevel'
  ClientHeight = 320
  ClientWidth = 400
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
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 400
    Height = 320
    Align = alClient
    Caption = 'NeedLevel'#35745#31639
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 24
      Width = 30
      Height = 12
      Caption = #31561#32423':'
    end
    object Label2: TLabel
      Left = 140
      Top = 24
      Width = 30
      Height = 12
      Caption = #32844#19994':'
    end
    object Label3: TLabel
      Left = 275
      Top = 24
      Width = 6
      Height = 12
      Caption = '='
    end
    object Label4: TLabel
      Left = 8
      Top = 56
      Width = 30
      Height = 12
      Caption = #25915#20987':'
    end
    object Label5: TLabel
      Left = 140
      Top = 56
      Width = 30
      Height = 12
      Caption = #32844#19994':'
    end
    object Label6: TLabel
      Left = 275
      Top = 56
      Width = 6
      Height = 12
      Caption = '='
    end
    object Label7: TLabel
      Left = 8
      Top = 88
      Width = 30
      Height = 12
      Caption = #39764#27861':'
    end
    object Label8: TLabel
      Left = 140
      Top = 88
      Width = 30
      Height = 12
      Caption = #32844#19994':'
    end
    object Label9: TLabel
      Left = 275
      Top = 88
      Width = 6
      Height = 12
      Caption = '='
    end
    object Label10: TLabel
      Left = 8
      Top = 120
      Width = 30
      Height = 12
      Caption = #36947#26415':'
    end
    object Label11: TLabel
      Left = 140
      Top = 120
      Width = 30
      Height = 12
      Caption = #32844#19994':'
    end
    object Label12: TLabel
      Left = 275
      Top = 120
      Width = 6
      Height = 12
      Caption = '='
    end
    object Label13: TLabel
      Left = 8
      Top = 152
      Width = 54
      Height = 12
      Caption = #36716#29983#31561#32423':'
    end
    object Label14: TLabel
      Left = 140
      Top = 152
      Width = 30
      Height = 12
      Caption = #31561#32423':'
    end
    object Label15: TLabel
      Left = 275
      Top = 152
      Width = 6
      Height = 12
      Caption = '='
    end
    object Label16: TLabel
      Left = 8
      Top = 184
      Width = 54
      Height = 12
      Caption = #36716#29983#31561#32423':'
    end
    object Label17: TLabel
      Left = 140
      Top = 184
      Width = 30
      Height = 12
      Caption = #25915#20987':'
    end
    object Label18: TLabel
      Left = 275
      Top = 184
      Width = 6
      Height = 12
      Caption = '='
    end
    object Label19: TLabel
      Left = 8
      Top = 216
      Width = 54
      Height = 12
      Caption = #36716#29983#31561#32423':'
    end
    object Label20: TLabel
      Left = 140
      Top = 216
      Width = 30
      Height = 12
      Caption = #39764#27861':'
    end
    object Label21: TLabel
      Left = 275
      Top = 216
      Width = 6
      Height = 12
      Caption = '='
    end
    object Label22: TLabel
      Left = 8
      Top = 248
      Width = 54
      Height = 12
      Caption = #36716#29983#31561#32423':'
    end
    object Label23: TLabel
      Left = 140
      Top = 248
      Width = 30
      Height = 12
      Caption = #36947#26415':'
    end
    object Label24: TLabel
      Left = 275
      Top = 248
      Width = 6
      Height = 12
      Caption = '='
    end
    object Label25: TLabel
      Left = 8
      Top = 280
      Width = 54
      Height = 12
      Caption = #20250#21592#31867#22411':'
    end
    object Label26: TLabel
      Left = 140
      Top = 280
      Width = 30
      Height = 12
      Caption = #31561#32423':'
    end
    object Label27: TLabel
      Left = 275
      Top = 280
      Width = 6
      Height = 12
      Caption = '='
    end
    object eLevel: TEdit
      Left = 68
      Top = 21
      Width = 61
      Height = 20
      TabOrder = 0
      Text = '45'
      OnChange = eChange
    end
    object cbLevelJob: TComboBox
      Left = 176
      Top = 21
      Width = 93
      Height = 20
      Style = csDropDownList
      ItemHeight = 12
      ItemIndex = 0
      TabOrder = 1
      Text = #25112#22763
      OnChange = eChange
      Items.Strings = (
        #25112#22763
        #39764#27861#24072
        #36947#22763)
    end
    object eLevelJob: TEdit
      Left = 287
      Top = 21
      Width = 100
      Height = 20
      TabOrder = 2
      Text = 'eLevelJob'
    end
    object eDC: TEdit
      Left = 68
      Top = 53
      Width = 61
      Height = 20
      TabOrder = 3
      Text = '45'
      OnChange = eChange
    end
    object cbDCJob: TComboBox
      Left = 176
      Top = 53
      Width = 93
      Height = 20
      Style = csDropDownList
      ItemHeight = 12
      ItemIndex = 0
      TabOrder = 4
      Text = #25112#22763
      OnChange = eChange
      Items.Strings = (
        #25112#22763
        #39764#27861#24072
        #36947#22763)
    end
    object eDCJob: TEdit
      Left = 287
      Top = 53
      Width = 100
      Height = 20
      TabOrder = 5
      Text = 'eDCJob'
    end
    object eMC: TEdit
      Left = 68
      Top = 85
      Width = 61
      Height = 20
      TabOrder = 6
      Text = '45'
      OnChange = eChange
    end
    object cbMCJob: TComboBox
      Left = 176
      Top = 85
      Width = 93
      Height = 20
      Style = csDropDownList
      ItemHeight = 12
      ItemIndex = 0
      TabOrder = 7
      Text = #25112#22763
      OnChange = eChange
      Items.Strings = (
        #25112#22763
        #39764#27861#24072
        #36947#22763)
    end
    object eMCJob: TEdit
      Left = 287
      Top = 85
      Width = 100
      Height = 20
      TabOrder = 8
      Text = 'eMCJob'
    end
    object eSC: TEdit
      Left = 68
      Top = 117
      Width = 61
      Height = 20
      TabOrder = 9
      Text = '45'
      OnChange = eChange
    end
    object cbSCJob: TComboBox
      Left = 176
      Top = 117
      Width = 93
      Height = 20
      Style = csDropDownList
      ItemHeight = 12
      ItemIndex = 0
      TabOrder = 10
      Text = #25112#22763
      OnChange = eChange
      Items.Strings = (
        #25112#22763
        #39764#27861#24072
        #36947#22763)
    end
    object eSCJob: TEdit
      Left = 287
      Top = 117
      Width = 100
      Height = 20
      TabOrder = 11
      Text = 'eSCJob'
    end
    object eRelive1: TEdit
      Left = 68
      Top = 149
      Width = 61
      Height = 20
      TabOrder = 12
      Text = '10'
      OnChange = eChange
    end
    object eLevel1: TEdit
      Left = 176
      Top = 149
      Width = 93
      Height = 20
      TabOrder = 13
      Text = '45'
      OnChange = eChange
    end
    object eReliveLevel: TEdit
      Left = 287
      Top = 149
      Width = 100
      Height = 20
      TabOrder = 14
      Text = 'eReliveLevel'
    end
    object eRelive2: TEdit
      Left = 68
      Top = 181
      Width = 61
      Height = 20
      TabOrder = 15
      Text = '10'
      OnChange = eChange
    end
    object eDC1: TEdit
      Left = 176
      Top = 181
      Width = 93
      Height = 20
      TabOrder = 16
      Text = '45'
      OnChange = eChange
    end
    object eReliveDC: TEdit
      Left = 287
      Top = 181
      Width = 100
      Height = 20
      TabOrder = 17
      Text = 'eReliveDC'
    end
    object eRelive3: TEdit
      Left = 68
      Top = 213
      Width = 61
      Height = 20
      TabOrder = 18
      Text = '10'
      OnChange = eChange
    end
    object eMC1: TEdit
      Left = 176
      Top = 213
      Width = 93
      Height = 20
      TabOrder = 19
      Text = '45'
      OnChange = eChange
    end
    object eReliveMC: TEdit
      Left = 287
      Top = 213
      Width = 100
      Height = 20
      TabOrder = 20
      Text = 'eReliveMC'
    end
    object eRelive4: TEdit
      Left = 68
      Top = 245
      Width = 61
      Height = 20
      TabOrder = 21
      Text = '10'
      OnChange = eChange
    end
    object eSC1: TEdit
      Left = 176
      Top = 245
      Width = 93
      Height = 20
      TabOrder = 22
      Text = '45'
      OnChange = eChange
    end
    object eReliveSC: TEdit
      Left = 287
      Top = 245
      Width = 100
      Height = 20
      TabOrder = 23
      Text = 'eReliveSC'
    end
    object eVIPType: TEdit
      Left = 68
      Top = 277
      Width = 61
      Height = 20
      TabOrder = 24
      Text = '10'
      OnChange = eChange
    end
    object eVIPLevel: TEdit
      Left = 176
      Top = 277
      Width = 93
      Height = 20
      TabOrder = 25
      Text = '45'
      OnChange = eChange
    end
    object eVIPTypeLevel: TEdit
      Left = 287
      Top = 277
      Width = 100
      Height = 20
      TabOrder = 26
      Text = 'eVIPTypeLevel'
    end
  end
end
