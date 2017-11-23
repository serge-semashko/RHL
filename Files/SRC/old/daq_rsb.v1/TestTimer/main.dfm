object MainForm: TMainForm
  Left = -3
  Top = 246
  Width = 1019
  Height = 405
  Caption = 'MainForm'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -10
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object SpeedButton1: TSpeedButton
    Left = 39
    Top = 20
    Width = 74
    Height = 17
    Caption = 'MM Timer '
    OnClick = SpeedButton1Click
  end
  object SpeedButton2: TSpeedButton
    Left = 126
    Top = 20
    Width = 83
    Height = 17
    Caption = 'Thread'
    OnClick = SpeedButton2Click
  end
  object SpeedButton3: TSpeedButton
    Left = 220
    Top = 20
    Width = 19
    Height = 18
    OnClick = SpeedButton3Click
  end
  object Memo1: TMemo
    Left = 20
    Top = 59
    Width = 364
    Height = 117
    Lines.Strings = (
      'Memo1')
    TabOrder = 0
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 207
    Width = 1003
    Height = 160
    ActivePage = TabSheet1
    Align = alBottom
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object TabSheet1: TTabSheet
      Caption = 'Wavetek 1271'
      object Panel2: TPanel
        Left = 0
        Top = 0
        Width = 993
        Height = 125
        Align = alLeft
        TabOrder = 0
        object Label1: TLabel
          Left = 1
          Top = 18
          Width = 43
          Height = 20
          Caption = 'GPIB:'
        end
        object Label2: TLabel
          Left = 123
          Top = 18
          Width = 81
          Height = 20
          Caption = 'Instrument:'
        end
        object Label3: TLabel
          Left = 297
          Top = 19
          Width = 41
          Height = 20
          Caption = 'Write:'
        end
        object Label4: TLabel
          Left = 1
          Top = 47
          Width = 43
          Height = 20
          Caption = 'Read:'
        end
        object StartCycle: TSpeedButton
          Left = 732
          Top = 4
          Width = 98
          Height = 17
          Caption = 'Get stat'
        end
        object cmbGPIB: TComboBox
          Left = 47
          Top = 16
          Width = 74
          Height = 28
          ImeName = #164#164#164#1077' ('#1041'c'#1045#1081') - '#183's'#1028'`'#173#181
          ItemHeight = 20
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
          Left = 207
          Top = 16
          Width = 81
          Height = 28
          Style = csDropDownList
          ImeName = #164#164#164#1077' ('#1041'c'#1045#1081') - '#183's'#1028'`'#173#181
          ItemHeight = 20
          ItemIndex = 15
          TabOrder = 1
          Text = '16'
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
          Left = 449
          Top = 17
          Width = 110
          Height = 24
          Caption = 'Write && Read'
          TabOrder = 2
        end
        object editWrite: TEdit
          Left = 345
          Top = 16
          Width = 104
          Height = 28
          ImeName = #164#164#164#1077' ('#1041'c'#1045#1081') - '#183's'#1028'`'#173#181
          TabOrder = 3
          Text = '*IDN?'
        end
        object memoRead: TMemo
          Left = 56
          Top = 44
          Width = 890
          Height = 77
          ImeName = #164#164#164#1077' ('#1041'c'#1045#1081') - '#183's'#1028'`'#173#181
          Lines.Strings = (
            'Memo1')
          TabOrder = 4
        end
        object CycBox: TCheckBox
          Left = 831
          Top = 6
          Width = 150
          Height = 13
          Caption = 'Continue read'
          Checked = True
          State = cbChecked
          TabOrder = 5
        end
        object DAQlen: TSpinEdit
          Left = 629
          Top = -1
          Width = 60
          Height = 30
          MaxValue = 0
          MinValue = 0
          TabOrder = 6
          Value = 0
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = '7088D'
      ImageIndex = 1
      object Panel3: TPanel
        Left = 0
        Top = 0
        Width = 801
        Height = 125
        Align = alLeft
        TabOrder = 0
        object Label5: TLabel
          Left = 1
          Top = 18
          Width = 68
          Height = 20
          Caption = 'COM port'
        end
        object Label6: TLabel
          Left = 159
          Top = 18
          Width = 81
          Height = 20
          Caption = '7088d addr'
        end
        object Label7: TLabel
          Left = 1
          Top = 44
          Width = 41
          Height = 20
          Caption = 'Write:'
        end
        object Label8: TLabel
          Left = 1
          Top = 91
          Width = 43
          Height = 20
          Caption = 'Read:'
        end
        object Label9: TLabel
          Left = 299
          Top = 16
          Width = 59
          Height = 20
          Caption = 'Channel'
        end
        object ComComboBox: TComboBox
          Left = 72
          Top = 16
          Width = 85
          Height = 28
          Style = csDropDownList
          ImeName = #164#164#164#1077' ('#1041'c'#1045#1081') - '#183's'#1028'`'#173#181
          ItemHeight = 20
          ItemIndex = 11
          TabOrder = 0
          Text = 'COM12'
          Items.Strings = (
            'COM1'
            'COM2'
            'COM3'
            'COM4'
            'COM5'
            'COM6'
            'COM7'
            'COM8'
            'COM9'
            'COM10'
            'COM11'
            'COM12')
        end
        object Button2: TButton
          Left = 608
          Top = 6
          Width = 111
          Height = 26
          Caption = 'Write && Read'
          TabOrder = 1
        end
        object Edit1: TEdit
          Left = 1
          Top = 64
          Width = 409
          Height = 28
          ImeName = #164#164#164#1077' ('#1041'c'#1045#1081') - '#183's'#1028'`'#173#181
          TabOrder = 2
          Text = '*IDN?'
        end
        object Memo2: TMemo
          Left = 1
          Top = 112
          Width = 409
          Height = 63
          ImeName = #164#164#164#1077' ('#1041'c'#1045#1081') - '#183's'#1028'`'#173#181
          Lines.Strings = (
            'Memo1')
          TabOrder = 3
        end
        object address: TSpinEdit
          Left = 245
          Top = 13
          Width = 52
          Height = 30
          MaxValue = 0
          MinValue = 0
          TabOrder = 4
          Value = 0
        end
        object edCh: TSpinEdit
          Left = 369
          Top = 13
          Width = 41
          Height = 30
          MaxValue = 0
          MinValue = 0
          TabOrder = 5
          Value = 0
        end
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'AD5790'
      ImageIndex = 2
      object Panel4: TPanel
        Left = 0
        Top = 0
        Width = 465
        Height = 125
        Align = alLeft
        TabOrder = 0
        object Label11: TLabel
          Left = 24
          Top = 48
          Width = 41
          Height = 20
          Caption = 'Write:'
        end
        object Label12: TLabel
          Left = 24
          Top = 96
          Width = 43
          Height = 20
          Caption = 'Read:'
        end
        object Button3: TButton
          Left = 344
          Top = 16
          Width = 89
          Height = 17
          Caption = 'Write && Read'
          TabOrder = 0
        end
        object Edit2: TEdit
          Left = 24
          Top = 64
          Width = 409
          Height = 28
          ImeName = #164#164#164#1077' ('#1041'c'#1045#1081') - '#183's'#1028'`'#173#181
          TabOrder = 1
          Text = '*IDN?'
        end
        object Memo3: TMemo
          Left = 24
          Top = 112
          Width = 409
          Height = 67
          ImeName = #164#164#164#1077' ('#1041'c'#1045#1081') - '#183's'#1028'`'#173#181
          Lines.Strings = (
            'Memo1')
          TabOrder = 2
        end
      end
    end
  end
end
