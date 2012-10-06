object FormDesc: TFormDesc
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #36755#20837#22791#27880#20449#24687
  ClientHeight = 407
  ClientWidth = 604
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object DXDraw1: TDXDraw
    Left = 0
    Top = 0
    Width = 601
    Height = 233
    AutoInitialize = True
    AutoSize = True
    Color = clBlack
    Display.FixedBitCount = False
    Display.FixedRatio = True
    Display.FixedSize = True
    Options = [doAllowReboot, doWaitVBlank, doCenter, do3D, doDirectX7Mode, doHardware, doSelectDriver]
    SurfaceHeight = 233
    SurfaceWidth = 601
    TabOrder = 0
    Traces = <>
  end
end
