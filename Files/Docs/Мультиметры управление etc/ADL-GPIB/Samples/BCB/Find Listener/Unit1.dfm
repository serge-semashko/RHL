object Form1: TForm1
  Left = 209
  Top = 161
  Width = 294
  Height = 241
  Caption = 'Find Listener'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
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
    Left = 8
    Top = 40
    Width = 52
    Height = 13
    Caption = 'Instrument:'
  end
  object btnFind: TButton
    Left = 168
    Top = 8
    Width = 105
    Height = 25
    Caption = 'Find'
    TabOrder = 0
    OnClick = btnFindClick
  end
  object cmbGPIB: TComboBox
    Left = 40
    Top = 8
    Width = 81
    Height = 21
    Style = csDropDownList
    ImeName = #20013#25991' ('#32321#39636') - '#26032#27880#38899
    ItemHeight = 13
    ItemIndex = 0
    TabOrder = 1
    Text = 'GPIB0'
    Items.Strings = (
      'GPIB0'
      'GPIB1'
      'GPIB2'
      'GPIB3')
  end
  object ListBox1: TListBox
    Left = 8
    Top = 56
    Width = 265
    Height = 145
    ImeName = #20013#25991' ('#32321#39636') - '#26032#27880#38899
    ItemHeight = 13
    TabOrder = 2
  end
end
