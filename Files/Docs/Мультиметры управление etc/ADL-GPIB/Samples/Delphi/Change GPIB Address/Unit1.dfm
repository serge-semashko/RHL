object Form1: TForm1
  Left = 524
  Top = 304
  Width = 413
  Height = 307
  Caption = 'Change GPIB Address'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 96
    Top = 18
    Width = 28
    Height = 13
    Caption = 'GPIB:'
  end
  object cmbGPIB: TComboBox
    Left = 136
    Top = 16
    Width = 73
    Height = 21
    Style = csDropDownList
    ImeName = '中文 (繁體) - 新注音'
    ItemHeight = 13
    TabOrder = 0
    OnClick = cmbGPIBClick
    Items.Strings = (
      'GPIB0'
      'GPIB1'
      'GPIB2'
      'GPIB3')
  end
  object GroupBox1: TGroupBox
    Left = 24
    Top = 48
    Width = 361
    Height = 97
    Caption = 'Get'
    TabOrder = 1
    object Label2: TLabel
      Left = 24
      Top = 26
      Width = 75
      Height = 13
      Caption = 'Pimary Address:'
    end
    object Label3: TLabel
      Left = 24
      Top = 58
      Width = 95
      Height = 13
      Caption = 'Secondary Address:'
    end
    object editPadGet: TEdit
      Left = 128
      Top = 24
      Width = 65
      Height = 21
      ImeName = '中文 (繁體) - 新注音'
      TabOrder = 0
      Text = '0'
    end
    object editSadGet: TEdit
      Left = 128
      Top = 56
      Width = 65
      Height = 21
      ImeName = '中文 (繁體) - 新注音'
      TabOrder = 1
      Text = '0'
    end
    object btnGet: TButton
      Left = 264
      Top = 40
      Width = 57
      Height = 25
      Caption = 'Get'
      TabOrder = 2
      OnClick = btnGetClick
    end
  end
  object GroupBox2: TGroupBox
    Left = 24
    Top = 160
    Width = 361
    Height = 97
    Caption = 'Set'
    TabOrder = 2
    object Label4: TLabel
      Left = 24
      Top = 26
      Width = 75
      Height = 13
      Caption = 'Pimary Address:'
    end
    object Label5: TLabel
      Left = 24
      Top = 58
      Width = 95
      Height = 13
      Caption = 'Secondary Address:'
    end
    object Label6: TLabel
      Left = 192
      Top = 27
      Width = 31
      Height = 13
      Caption = '(0~30)'
    end
    object Label7: TLabel
      Left = 192
      Top = 59
      Width = 55
      Height = 13
      Caption = '(0, 96~126)'
    end
    object editPadSet: TEdit
      Left = 128
      Top = 24
      Width = 65
      Height = 21
      ImeName = '中文 (繁體) - 新注音'
      TabOrder = 0
      Text = '0'
    end
    object editSadSet: TEdit
      Left = 128
      Top = 56
      Width = 65
      Height = 21
      ImeName = '中文 (繁體) - 新注音'
      TabOrder = 1
      Text = '0'
    end
    object btnSet: TButton
      Left = 264
      Top = 40
      Width = 57
      Height = 25
      Caption = 'Set'
      TabOrder = 2
      OnClick = btnSetClick
    end
  end
end
