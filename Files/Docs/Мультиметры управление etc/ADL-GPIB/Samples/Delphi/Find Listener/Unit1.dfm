object Form1: TForm1
  Left = 651
  Top = 243
  Width = 351
  Height = 318
  Caption = 'Find Listener'
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
    Top = 10
    Width = 28
    Height = 13
    Caption = 'GPIB:'
  end
  object Label2: TLabel
    Left = 32
    Top = 40
    Width = 94
    Height = 13
    Caption = 'Indtrument Address:'
  end
  object cmbGPIB: TComboBox
    Left = 72
    Top = 8
    Width = 81
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
  object ListBox1: TListBox
    Left = 32
    Top = 56
    Width = 281
    Height = 209
    ImeName = '中文 (繁體) - 新注音'
    ItemHeight = 13
    TabOrder = 1
  end
  object btnFind: TButton
    Left = 208
    Top = 8
    Width = 73
    Height = 25
    Caption = 'Find'
    TabOrder = 2
    OnClick = btnFindClick
  end
end
