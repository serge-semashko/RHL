object Form1: TForm1
  Left = 292
  Top = 267
  Width = 464
  Height = 252
  Caption = 'Query Identification'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 18
    Width = 28
    Height = 13
    Caption = 'GPIB:'
  end
  object Label2: TLabel
    Left = 136
    Top = 18
    Width = 93
    Height = 13
    Caption = 'Instrument Address:'
  end
  object Label4: TLabel
    Left = 24
    Top = 48
    Width = 29
    Height = 13
    Caption = 'Read:'
  end
  object cmbGPIB: TComboBox
    Left = 56
    Top = 16
    Width = 57
    Height = 21
    Style = csDropDownList
    ImeName = '中文 (繁體) - 新注音'
    ItemHeight = 13
    TabOrder = 0
    Items.Strings = (
      'GPIB0'
      'GPIB1'
      'GPIB2'
      'GPIB3')
  end
  object cmbInst: TComboBox
    Left = 240
    Top = 16
    Width = 81
    Height = 21
    Style = csDropDownList
    ImeName = '中文 (繁體) - 新注音'
    ItemHeight = 13
    TabOrder = 1
    Items.Strings = (
      '1'
      '2'
      '3'
      '4'
      '5'
      '6'
      '7'
      '8'
      '9'
      '10'
      '11'
      '12'
      '13'
      '14'
      '15'
      '16'
      '17'
      '18'
      '19'
      '20'
      '21'
      '22'
      '23'
      '24'
      '25'
      '26'
      '27'
      '28'
      '29'
      '30')
  end
  object btnQuery: TButton
    Left = 344
    Top = 16
    Width = 89
    Height = 17
    Caption = 'Query'
    TabOrder = 2
    OnClick = btnQueryClick
  end
  object memoRead: TMemo
    Left = 24
    Top = 64
    Width = 409
    Height = 145
    ImeName = '中文 (繁體) - 新注音'
    Lines.Strings = (
      'Memo1')
    TabOrder = 3
  end
end
