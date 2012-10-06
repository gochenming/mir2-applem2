object FormEdit: TFormEdit
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #35760#24405#25991#20214#32534#36753#31383#21475
  ClientHeight = 410
  ClientWidth = 393
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
  object grp1: TGroupBox
    Left = 8
    Top = 8
    Width = 244
    Height = 393
    Caption = #35760#24405#25991#20214#37197#32622#20449#24687
    TabOrder = 0
    object tvSaveFileInfo: TRzCheckTree
      Left = 10
      Top = 19
      Width = 223
      Height = 364
      Indent = 19
      MultiSelect = True
      SelectionPen.Color = clBtnShadow
      StateImages = tvSaveFileInfo.CheckImages
      TabOrder = 0
    end
  end
  object btnReLoad: TButton
    Left = 258
    Top = 47
    Width = 127
    Height = 25
    Caption = #37325#21152#36733'(&R)'
    TabOrder = 1
    OnClick = btnReLoadClick
  end
  object btnDelete: TButton
    Left = 258
    Top = 15
    Width = 127
    Height = 25
    Caption = #21024#38500#36873#20013'(&D)'
    TabOrder = 2
    OnClick = btnDeleteClick
  end
  object btnSaveToFile: TButton
    Left = 258
    Top = 78
    Width = 127
    Height = 25
    Caption = #20445#23384#35774#32622'(&S)'
    TabOrder = 3
    OnClick = btnSaveToFileClick
  end
  object grp2: TGroupBox
    Left = 260
    Top = 109
    Width = 125
    Height = 108
    Caption = #25351#23450#21024#38500
    TabOrder = 4
    object lbl1: TLabel
      Left = 59
      Top = 52
      Width = 6
      Height = 12
      Caption = '>'
    end
    object cbb1: TComboBox
      Left = 7
      Top = 22
      Width = 111
      Height = 20
      Style = csDropDownList
      ItemHeight = 12
      ItemIndex = 0
      TabOrder = 0
      Text = 'Objects1.pak'
      Items.Strings = (
        'Objects1.pak'
        'Objects2.pak'
        'Objects3.pak'
        'Objects4.pak'
        'Objects5.pak'
        'Objects6.pak'
        'Objects7.pak'
        'Objects8.pak'
        'Objects9.pak'
        'Objects10.pak')
    end
    object seBegin: TSpinEdit
      Left = 7
      Top = 48
      Width = 52
      Height = 21
      MaxValue = 32766
      MinValue = 0
      TabOrder = 1
      Value = 0
    end
    object seEnd: TSpinEdit
      Left = 66
      Top = 48
      Width = 52
      Height = 21
      MaxValue = 32767
      MinValue = 0
      TabOrder = 2
      Value = 0
    end
    object btn1: TButton
      Left = 7
      Top = 75
      Width = 111
      Height = 25
      Caption = #21024#38500#25351#23450
      TabOrder = 3
      OnClick = btn1Click
    end
  end
end
