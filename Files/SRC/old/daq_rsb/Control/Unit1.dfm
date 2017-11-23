object Form1: TForm1
  Left = 200
  Top = 134
  Width = 1063
  Height = 860
  Caption = 'Read/Write'
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
  object Panel1: TPanel
    Left = 0
    Top = 674
    Width = 1047
    Height = 148
    Align = alBottom
    TabOrder = 0
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 1047
    Height = 216
    ActivePage = TabSheet1
    Align = alTop
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
        Width = 465
        Height = 181
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
          Left = 1
          Top = 43
          Width = 41
          Height = 20
          Caption = 'Write:'
        end
        object Label4: TLabel
          Left = 1
          Top = 90
          Width = 43
          Height = 20
          Caption = 'Read:'
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
          Left = 297
          Top = 17
          Width = 110
          Height = 24
          Caption = 'Write && Read'
          TabOrder = 2
          OnClick = Button1Click
        end
        object editWrite: TEdit
          Left = 1
          Top = 64
          Width = 409
          Height = 28
          ImeName = #164#164#164#1077' ('#1041'c'#1045#1081') - '#183's'#1028'`'#173#181
          TabOrder = 3
          Text = '*IDN?'
        end
        object memoRead: TMemo
          Left = 1
          Top = 112
          Width = 409
          Height = 67
          ImeName = #164#164#164#1077' ('#1041'c'#1045#1081') - '#183's'#1028'`'#173#181
          Lines.Strings = (
            'Memo1')
          TabOrder = 4
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = '7088D'
      ImageIndex = 1
      object Panel3: TPanel
        Left = 0
        Top = 0
        Width = 465
        Height = 181
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
          Left = 147
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
        object ComboBox1: TComboBox
          Left = 72
          Top = 16
          Width = 68
          Height = 28
          Style = csDropDownList
          ImeName = #164#164#164#1077' ('#1041'c'#1045#1081') - '#183's'#1028'`'#173#181
          ItemHeight = 20
          TabOrder = 0
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
          Left = 336
          Top = 14
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
        object Memo1: TMemo
          Left = 1
          Top = 112
          Width = 409
          Height = 63
          ImeName = #164#164#164#1077' ('#1041'c'#1045#1081') - '#183's'#1028'`'#173#181
          Lines.Strings = (
            'Memo1')
          TabOrder = 3
        end
        object SpinEdit1: TSpinEdit
          Left = 234
          Top = 13
          Width = 98
          Height = 30
          MaxValue = 0
          MinValue = 0
          TabOrder = 4
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
        Height = 181
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
        object Memo2: TMemo
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
  object Panel5: TPanel
    Left = 0
    Top = 216
    Width = 1047
    Height = 458
    Align = alClient
    Caption = 'Panel5'
    TabOrder = 2
    object Chart1: TChart
      Left = 1
      Top = 1
      Width = 1045
      Height = 456
      BackWall.Brush.Color = clWhite
      BackWall.Brush.Style = bsClear
      Title.Font.Charset = DEFAULT_CHARSET
      Title.Font.Color = clBlue
      Title.Font.Height = -19
      Title.Font.Name = 'Arial'
      Title.Font.Style = []
      Title.Text.Strings = (
        'Voltage')
      BottomAxis.DateTimeFormat = 'dd:MM HH:MM'
      BottomAxis.LabelsAngle = 360
      BottomAxis.LabelsFont.Charset = DEFAULT_CHARSET
      BottomAxis.LabelsFont.Color = clBlack
      BottomAxis.LabelsFont.Height = -16
      BottomAxis.LabelsFont.Name = 'Arial'
      BottomAxis.LabelsFont.Style = []
      BottomAxis.LabelsSize = 18
      BottomAxis.TickInnerLength = 8
      BottomAxis.TickLength = 7
      BottomAxis.TicksInner.Width = 2
      BottomAxis.Title.Caption = 'Date time'
      BottomAxis.Title.Font.Charset = DEFAULT_CHARSET
      BottomAxis.Title.Font.Color = clBlack
      BottomAxis.Title.Font.Height = -16
      BottomAxis.Title.Font.Name = 'Arial'
      BottomAxis.Title.Font.Style = []
      BottomAxis.TitleSize = 9
      LeftAxis.LabelsFont.Charset = DEFAULT_CHARSET
      LeftAxis.LabelsFont.Color = clBlack
      LeftAxis.LabelsFont.Height = -16
      LeftAxis.LabelsFont.Name = 'Arial'
      LeftAxis.LabelsFont.Style = []
      LeftAxis.Title.Caption = 'Voltage'
      LeftAxis.Title.Font.Charset = DEFAULT_CHARSET
      LeftAxis.Title.Font.Color = clBlack
      LeftAxis.Title.Font.Height = -16
      LeftAxis.Title.Font.Name = 'Arial'
      LeftAxis.Title.Font.Style = []
      Legend.Visible = False
      View3D = False
      Align = alClient
      TabOrder = 0
      object Series1: TLineSeries
        Marks.ArrowLength = 8
        Marks.Visible = True
        SeriesColor = clRed
        Pointer.InflateMargins = True
        Pointer.Style = psRectangle
        Pointer.Visible = True
        XValues.DateTime = True
        XValues.Name = 'X'
        XValues.Multiplier = 1.000000000000000000
        XValues.Order = loAscending
        YValues.DateTime = False
        YValues.Name = 'Y'
        YValues.Multiplier = 1.000000000000000000
        YValues.Order = loNone
      end
    end
  end
end
