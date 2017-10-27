object Form1: TForm1
  Left = 530
  Top = 163
  Width = 355
  Height = 351
  Caption = 'Change GPIB Address'
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
    Left = 104
    Top = 10
    Width = 28
    Height = 13
    Caption = 'GPIB:'
  end
  object cmbGPIB: TComboBox
    Left = 136
    Top = 8
    Width = 89
    Height = 21
    ImeName = #20013#25991' ('#32321#39636') - '#26032#27880#38899
    ItemHeight = 13
    ItemIndex = 0
    TabOrder = 0
    Text = 'GPIB0'
    OnClick = cmbGPIBClick
    Items.Strings = (
      'GPIB0'
      'GPIB1'
      'GPIB2'
      'GPIB3')
  end
  object GroupBox1: TGroupBox
    Left = 16
    Top = 184
    Width = 313
    Height = 121
    Caption = 'Set'
    TabOrder = 1
    object Label2: TLabel
      Left = 32
      Top = 34
      Width = 78
      Height = 13
      Caption = 'Primary Address:'
    end
    object Label5: TLabel
      Left = 32
      Top = 74
      Width = 95
      Height = 13
      Caption = 'Secondary Address:'
    end
    object Label6: TLabel
      Left = 168
      Top = 40
      Width = 31
      Height = 13
      Caption = '(0~30)'
    end
    object Label7: TLabel
      Left = 168
      Top = 80
      Width = 52
      Height = 13
      Caption = '0,(96~126)'
    end
    object btnSet: TButton
      Left = 224
      Top = 48
      Width = 73
      Height = 25
      Caption = 'Set'
      TabOrder = 0
      OnClick = btnSetClick
    end
    object EditPadSet: TEdit
      Left = 128
      Top = 33
      Width = 37
      Height = 21
      ImeName = #20013#25991' ('#32321#39636') - '#26032#27880#38899
      TabOrder = 1
      Text = '0'
    end
    object EditSadSet: TEdit
      Left = 128
      Top = 72
      Width = 37
      Height = 21
      ImeName = #20013#25991' ('#32321#39636') - '#26032#27880#38899
      TabOrder = 2
      Text = '0'
    end
  end
  object GroupBox2: TGroupBox
    Left = 16
    Top = 48
    Width = 313
    Height = 121
    Caption = 'Get'
    TabOrder = 2
    object Label3: TLabel
      Left = 32
      Top = 34
      Width = 78
      Height = 13
      Caption = 'Primary Address:'
    end
    object Label4: TLabel
      Left = 32
      Top = 74
      Width = 95
      Height = 13
      Caption = 'Secondary Address:'
    end
    object btnGet: TButton
      Left = 224
      Top = 56
      Width = 73
      Height = 25
      Caption = 'Get'
      TabOrder = 0
      OnClick = btnGetClick
    end
    object EditPadGet: TEdit
      Left = 128
      Top = 32
      Width = 33
      Height = 21
      ImeName = #20013#25991' ('#32321#39636') - '#26032#27880#38899
      TabOrder = 1
      Text = '0'
    end
    object EditSadGet: TEdit
      Left = 128
      Top = 72
      Width = 33
      Height = 21
      ImeName = #20013#25991' ('#32321#39636') - '#26032#27880#38899
      TabOrder = 2
      Text = '0'
    end
  end
end
