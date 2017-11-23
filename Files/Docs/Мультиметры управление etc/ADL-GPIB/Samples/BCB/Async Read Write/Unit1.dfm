object Form1: TForm1
  Left = 192
  Top = 107
  Width = 488
  Height = 268
  Caption = 'Async Write & Read'
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
    Left = 40
    Top = 26
    Width = 28
    Height = 13
    Caption = 'GPIB:'
  end
  object Label2: TLabel
    Left = 168
    Top = 26
    Width = 93
    Height = 13
    Caption = 'Instrument Address:'
  end
  object Label3: TLabel
    Left = 24
    Top = 56
    Width = 28
    Height = 13
    Caption = 'Write:'
  end
  object Label4: TLabel
    Left = 24
    Top = 104
    Width = 29
    Height = 13
    Caption = 'Read:'
  end
  object cmbGPIB: TComboBox
    Left = 72
    Top = 24
    Width = 57
    Height = 21
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
    Left = 264
    Top = 24
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
  object btnRW: TButton
    Left = 360
    Top = 24
    Width = 81
    Height = 17
    Caption = 'Write && Read'
    TabOrder = 2
    OnClick = btnRWClick
  end
  object editWrite: TEdit
    Left = 24
    Top = 72
    Width = 433
    Height = 21
    ImeName = #20013#25991' ('#32321#39636') - '#26032#27880#38899
    TabOrder = 3
    Text = '*IDN?'
  end
  object memoRead: TMemo
    Left = 24
    Top = 120
    Width = 433
    Height = 105
    ImeName = #20013#25991' ('#32321#39636') - '#26032#27880#38899
    Lines.Strings = (
      'memoRead')
    TabOrder = 4
  end
end
