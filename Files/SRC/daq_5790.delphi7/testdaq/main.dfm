object MainForm: TMainForm
  Left = 153
  Top = 295
  Width = 1029
  Height = 564
  Caption = 'MainForm'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object SpeedButton1: TSpeedButton
    Left = 48
    Top = 25
    Width = 91
    Height = 21
    Caption = 'MM Timer '
    OnClick = SpeedButton1Click
  end
  object SpeedButton2: TSpeedButton
    Left = 155
    Top = 25
    Width = 102
    Height = 21
    Caption = 'Thread'
    OnClick = SpeedButton2Click
  end
  object SpeedButton3: TSpeedButton
    Left = 271
    Top = 25
    Width = 23
    Height = 22
    OnClick = SpeedButton3Click
  end
  object Memo1: TMemo
    Left = 25
    Top = 73
    Width = 448
    Height = 144
    Lines.Strings = (
      'Memo1')
    TabOrder = 0
  end
end
