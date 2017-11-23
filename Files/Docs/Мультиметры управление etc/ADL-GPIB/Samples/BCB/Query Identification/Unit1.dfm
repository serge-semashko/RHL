object Form1: TForm1
  Left = 498
  Top = 264
  Width = 428
  Height = 284
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
    Left = 8
    Top = 11
    Width = 28
    Height = 13
    Caption = 'GPIB:'
  end
  object Label2: TLabel
    Left = 144
    Top = 11
    Width = 93
    Height = 13
    Caption = 'Instrument Address:'
  end
  object Label3: TLabel
    Left = 9
    Top = 40
    Width = 33
    Height = 13
    Caption = 'Result:'
  end
  object cmbGPIB: TComboBox
    Left = 40
    Top = 8
    Width = 65
    Height = 21
    Style = csDropDownList
    ImeName = #20013#25991' ('#32321#39636') - '#26032#27880#38899
    ItemHeight = 13
    ItemIndex = 0
    TabOrder = 0
    Text = 'GPIB0'
    Items.Strings = (
      'GPIB0'
      'GPIB1'
      'GPIB2'
      'GPIB3')
  end
  object cmbInst: TComboBox
    Left = 240
    Top = 8
    Width = 57
    Height = 21
    ImeName = #20013#25991' ('#32321#39636') - '#26032#27880#38899
    ItemHeight = 13
    ItemIndex = 7
    TabOrder = 1
    Text = '8'
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
    Left = 336
    Top = 8
    Width = 73
    Height = 25
    Caption = '*IDN?'
    TabOrder = 2
    OnClick = btnQueryClick
  end
  object memoRead: TMemo
    Left = 8
    Top = 56
    Width = 401
    Height = 193
    ImeName = #20013#25991' ('#32321#39636') - '#26032#27880#38899
    Lines.Strings = (
      'memoRead')
    TabOrder = 3
  end
end
