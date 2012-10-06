object Form6: TForm6
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Form6'
  ClientHeight = 421
  ClientWidth = 649
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object MyDevice: TDX9Device
    Width = 800
    Height = 600
    BitDepth = bdLow
    Refresh = 0
    Windowed = True
    VSync = True
    HardwareTL = True
    LockBackBuffer = False
    DepthBuffer = True
    WindowHandle = 0
    OnInitialize = MyDeviceInitialize
    OnRender = MyDeviceRender
    AutoInitialize = True
    Left = 8
    Top = 8
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 10
    OnTimer = Timer1Timer
    Left = 40
    Top = 8
  end
end
