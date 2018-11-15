object Form1: TForm1
  Left = 562
  Top = 149
  Width = 719
  Height = 619
  Caption = 'Read/Write'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object Label1: TLabel
    Left = 24
    Top = 18
    Width = 34
    Height = 16
    Caption = 'GPIB:'
  end
  object Label2: TLabel
    Left = 136
    Top = 18
    Width = 117
    Height = 16
    Caption = 'Instrument Address:'
  end
  object Label3: TLabel
    Left = 24
    Top = 48
    Width = 34
    Height = 16
    Caption = 'Write:'
  end
  object Label4: TLabel
    Left = 32
    Top = 176
    Width = 37
    Height = 16
    Caption = 'Read:'
  end
  object cmbGPIB: TComboBox
    Left = 56
    Top = 16
    Width = 57
    Height = 24
    Style = csDropDownList
    ImeName = #164#164#164#1077' ('#1041'c'#1045#1081') - '#183's'#1028'`'#173#181
    ItemHeight = 16
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
    Height = 24
    Style = csDropDownList
    ImeName = #164#164#164#1077' ('#1041'c'#1045#1081') - '#183's'#1028'`'#173#181
    ItemHeight = 16
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
  object Button1: TButton
    Left = 344
    Top = 16
    Width = 89
    Height = 17
    Caption = 'Write && Read'
    TabOrder = 2
    OnClick = Button1Click
  end
  object editWrite: TEdit
    Left = 24
    Top = 64
    Width = 409
    Height = 24
    ImeName = #164#164#164#1077' ('#1041'c'#1045#1081') - '#183's'#1028'`'#173#181
    TabOrder = 3
    Text = 'ID?'
  end
  object memoRead: TMemo
    Left = 0
    Top = 326
    Width = 686
    Height = 345
    Align = alBottom
    ImeName = #164#164#164#1077' ('#1041'c'#1045#1081') - '#183's'#1028'`'#173#181
    Lines.Strings = (
      'Memo1')
    TabOrder = 4
  end
  object Memo1: TMemo
    Left = 0
    Top = 192
    Width = 686
    Height = 134
    Align = alBottom
    Lines.Strings = (
      'Memo1')
    TabOrder = 5
  end
end
