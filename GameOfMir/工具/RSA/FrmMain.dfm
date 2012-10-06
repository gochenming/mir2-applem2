object FormMain: TFormMain
  Left = 192
  Top = 112
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'FormMain'
  ClientHeight = 418
  ClientWidth = 336
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 12
  object GroupBox1: TGroupBox
    Left = 16
    Top = 8
    Width = 305
    Height = 401
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 16
      Width = 30
      Height = 12
      Caption = 'Key1:'
    end
    object Label2: TLabel
      Left = 8
      Top = 40
      Width = 30
      Height = 12
      Caption = 'Key1:'
    end
    object Label3: TLabel
      Left = 8
      Top = 64
      Width = 30
      Height = 12
      Caption = 'Key1:'
    end
    object Label4: TLabel
      Left = 8
      Top = 88
      Width = 30
      Height = 12
      Caption = #26126#25991':'
    end
    object Label5: TLabel
      Left = 8
      Top = 216
      Width = 30
      Height = 12
      Caption = #23494#25991':'
    end
    object Edit1: TEdit
      Left = 42
      Top = 13
      Width = 250
      Height = 20
      TabOrder = 0
      Text = '65537'
      OnChange = Edit1Change
    end
    object Edit2: TEdit
      Left = 42
      Top = 37
      Width = 250
      Height = 20
      TabOrder = 1
      Text = '626062042348457912149948387019'
      OnChange = Edit2Change
    end
    object Edit3: TEdit
      Left = 42
      Top = 61
      Width = 250
      Height = 20
      TabOrder = 2
      Text = '446402477923620138035234361233'
      OnChange = Edit3Change
    end
    object Memo1: TMemo
      Left = 42
      Top = 88
      Width = 247
      Height = 121
      Lines.Strings = (
        'Memo1')
      ScrollBars = ssVertical
      TabOrder = 3
    end
    object Memo2: TMemo
      Left = 42
      Top = 216
      Width = 247
      Height = 121
      Lines.Strings = (
        'Memo1')
      ScrollBars = ssVertical
      TabOrder = 4
    end
    object Button1: TButton
      Left = 40
      Top = 368
      Width = 75
      Height = 25
      Caption = #21152#23494
      TabOrder = 5
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 176
      Top = 368
      Width = 75
      Height = 25
      Caption = #35299#23494
      TabOrder = 6
      OnClick = Button2Click
    end
    object RadioButton1: TRadioButton
      Left = 40
      Top = 344
      Width = 113
      Height = 17
      Caption = 'Server'
      Checked = True
      TabOrder = 7
      TabStop = True
      OnClick = RadioButton1Click
    end
    object RadioButton2: TRadioButton
      Left = 168
      Top = 344
      Width = 113
      Height = 17
      Caption = 'Client'
      TabOrder = 8
      OnClick = RadioButton1Click
    end
  end
end
