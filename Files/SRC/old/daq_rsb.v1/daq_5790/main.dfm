object MainForm: TMainForm
  Left = 536
  Top = 208
  Width = 1228
  Height = 860
  Caption = 'Read/Write'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 120
  TextHeight = 16
  object Panel1: TPanel
    Left = 0
    Top = 747
    Width = 1210
    Height = 38
    Align = alBottom
    TabOrder = 0
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 1210
    Height = 202
    ActivePage = TabSheet2
    Align = alTop
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object TabSheet1: TTabSheet
      Caption = 'Wavetek 1271'
      object Panel2: TPanel
        Left = 0
        Top = 0
        Width = 1202
        Height = 1222
        Align = alTop
        TabOrder = 0
        object Label1: TLabel
          Left = 1
          Top = 22
          Width = 47
          Height = 24
          Caption = 'GPIB:'
        end
        object Label2: TLabel
          Left = 151
          Top = 22
          Width = 92
          Height = 24
          Caption = 'Instrument:'
        end
        object Label3: TLabel
          Left = 366
          Top = 23
          Width = 48
          Height = 24
          Caption = 'Write:'
        end
        object StartCycle: TSpeedButton
          Left = 773
          Top = 20
          Width = 121
          Height = 22
          Caption = 'Get stat'
          OnClick = StartCycleClick
        end
        object cmbGPIB: TComboBox
          Left = 58
          Top = 20
          Width = 91
          Height = 32
          ImeName = #164#164#164#1077' ('#1041'c'#1045#1081') - '#183's'#1028'`'#173#181
          ItemHeight = 24
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
          Left = 255
          Top = 20
          Width = 99
          Height = 32
          Style = csDropDownList
          ImeName = #164#164#164#1077' ('#1041'c'#1045#1081') - '#183's'#1028'`'#173#181
          ItemHeight = 24
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
          Left = 553
          Top = 21
          Width = 135
          Height = 29
          Caption = 'Write && Read'
          TabOrder = 2
          OnClick = Button1Click
        end
        object editWrite: TEdit
          Left = 425
          Top = 20
          Width = 128
          Height = 28
          ImeName = #164#164#164#1077' ('#1041'c'#1045#1081') - '#183's'#1028'`'#173#181
          TabOrder = 3
          Text = '*IDN?'
        end
        object memoRead: TMemo
          Left = 0
          Top = 54
          Width = 828
          Height = 95
          ImeName = #164#164#164#1077' ('#1041'c'#1045#1081') - '#183's'#1028'`'#173#181
          Lines.Strings = (
            'Memo1')
          TabOrder = 4
        end
        object CycBox: TCheckBox
          Left = 903
          Top = 23
          Width = 154
          Height = 16
          Caption = 'Continue read'
          Checked = True
          State = cbChecked
          TabOrder = 5
        end
        object DAQlen: TSpinEdit
          Left = 694
          Top = 15
          Width = 74
          Height = 30
          MaxValue = 0
          MinValue = 0
          TabOrder = 6
          Value = 0
        end
        object Topspn: TSpinEdit
          Left = 986
          Top = 110
          Width = 149
          Height = 30
          MaxValue = 0
          MinValue = 0
          TabOrder = 7
          Value = 500
        end
        object Bottomspn: TSpinEdit
          Left = 833
          Top = 110
          Width = 149
          Height = 30
          MaxValue = 0
          MinValue = 0
          TabOrder = 8
          Value = 300
        end
        object expspn: TSpinEdit
          Left = 1138
          Top = 110
          Width = 85
          Height = 30
          MaxValue = 0
          MinValue = 0
          TabOrder = 9
          Value = 60
        end
        object StaticText1: TStaticText
          Left = 834
          Top = 50
          Width = 295
          Height = 30
          Alignment = taCenter
          AutoSize = False
          BevelKind = bkTile
          BevelOuter = bvRaised
          Caption = #1043#1088#1072#1085#1080#1094#1099
          TabOrder = 10
        end
        object StaticText2: TStaticText
          Left = 833
          Top = 81
          Width = 147
          Height = 30
          Alignment = taCenter
          AutoSize = False
          BevelKind = bkSoft
          Caption = 'Bottom'
          TabOrder = 11
        end
        object StaticText3: TStaticText
          Left = 987
          Top = 80
          Width = 144
          Height = 30
          Alignment = taCenter
          AutoSize = False
          BevelKind = bkSoft
          Caption = 'Top'
          TabOrder = 12
        end
        object StaticText4: TStaticText
          Left = 1136
          Top = 78
          Width = 91
          Height = 28
          Caption = 'Exp. Time'
          TabOrder = 13
        end
        object StaticText5: TStaticText
          Left = 1234
          Top = 78
          Width = 89
          Height = 28
          Caption = 'Dead time'
          TabOrder = 14
        end
        object deadspn: TSpinEdit
          Left = 1237
          Top = 110
          Width = 85
          Height = 30
          MaxValue = 0
          MinValue = 0
          TabOrder = 15
          Value = 2
        end
        object StaticText6: TStaticText
          Left = 1334
          Top = 78
          Width = 42
          Height = 28
          Caption = 'Step'
          TabOrder = 16
        end
        object stepspn: TSpinEdit
          Left = 1330
          Top = 107
          Width = 85
          Height = 30
          MaxValue = 0
          MinValue = 0
          TabOrder = 17
          Value = 1
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = '7088D'
      ImageIndex = 1
      object Panel3: TPanel
        Left = 0
        Top = 0
        Width = 986
        Height = 163
        Align = alLeft
        TabOrder = 0
        object Label5: TLabel
          Left = 1
          Top = 22
          Width = 81
          Height = 24
          Caption = 'COM port'
        end
        object Label6: TLabel
          Left = 196
          Top = 22
          Width = 94
          Height = 24
          Caption = '7088d addr'
        end
        object Label7: TLabel
          Left = 1
          Top = 54
          Width = 48
          Height = 24
          Caption = 'Write:'
        end
        object Label8: TLabel
          Left = 513
          Top = 53
          Width = 50
          Height = 24
          Caption = 'Read:'
        end
        object Label9: TLabel
          Left = 368
          Top = 20
          Width = 71
          Height = 24
          Caption = 'Channel'
        end
        object ComComboBox: TComboBox
          Left = 89
          Top = 20
          Width = 104
          Height = 32
          Style = csDropDownList
          ImeName = #164#164#164#1077' ('#1041'c'#1045#1081') - '#183's'#1028'`'#173#181
          ItemHeight = 24
          ItemIndex = 0
          TabOrder = 0
          Text = 'COM1'
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
          Left = 748
          Top = 7
          Width = 137
          Height = 32
          Caption = 'Write && Read'
          TabOrder = 1
        end
        object Edit1: TEdit
          Left = 1
          Top = 79
          Width = 504
          Height = 28
          ImeName = #164#164#164#1077' ('#1041'c'#1045#1081') - '#183's'#1028'`'#173#181
          TabOrder = 2
          Text = '*IDN?'
        end
        object Memo1: TMemo
          Left = 508
          Top = 79
          Width = 472
          Height = 77
          ImeName = #164#164#164#1077' ('#1041'c'#1045#1081') - '#183's'#1028'`'#173#181
          Lines.Strings = (
            'Memo1')
          TabOrder = 3
        end
        object address: TSpinEdit
          Left = 302
          Top = 16
          Width = 64
          Height = 31
          MaxValue = 0
          MinValue = 0
          TabOrder = 4
          Value = 1
        end
        object edCh: TSpinEdit
          Left = 454
          Top = 16
          Width = 51
          Height = 31
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
        Width = 572
        Height = 163
        Align = alLeft
        TabOrder = 0
        object Label11: TLabel
          Left = 30
          Top = 59
          Width = 48
          Height = 24
          Caption = 'Write:'
        end
        object Label12: TLabel
          Left = 30
          Top = 118
          Width = 50
          Height = 24
          Caption = 'Read:'
        end
        object Button3: TButton
          Left = 423
          Top = 20
          Width = 110
          Height = 21
          Caption = 'Write && Read'
          TabOrder = 0
        end
        object Edit2: TEdit
          Left = 30
          Top = 79
          Width = 503
          Height = 28
          ImeName = #164#164#164#1077' ('#1041'c'#1045#1081') - '#183's'#1028'`'#173#181
          TabOrder = 1
          Text = '*IDN?'
        end
        object Memo2: TMemo
          Left = 30
          Top = 138
          Width = 503
          Height = 82
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
    Top = 202
    Width = 1210
    Height = 545
    Align = alClient
    Caption = 'Panel5'
    TabOrder = 2
    object Splitter1: TSplitter
      Left = 1
      Top = 1
      Width = 1208
      Height = 4
      Cursor = crVSplit
      Align = alTop
    end
    object PageControl2: TPageControl
      Left = 1
      Top = 5
      Width = 1208
      Height = 539
      ActivePage = TabSheet4
      Align = alClient
      TabOrder = 0
      object TabSheet4: TTabSheet
        Caption = 'Meam&STD'
        object Chart1: TChart
          Left = 0
          Top = 0
          Width = 1200
          Height = 404
          BackWall.Brush.Color = clWhite
          BackWall.Brush.Style = bsClear
          MarginBottom = 0
          MarginLeft = 0
          MarginRight = 0
          MarginTop = 0
          Title.Font.Charset = DEFAULT_CHARSET
          Title.Font.Color = clBlue
          Title.Font.Height = -19
          Title.Font.Name = 'Arial'
          Title.Font.Style = []
          Title.Text.Strings = (
            'Voltage')
          BottomAxis.DateTimeFormat = 'HH:MM:SS'
          BottomAxis.LabelsAngle = 360
          BottomAxis.LabelsFont.Charset = DEFAULT_CHARSET
          BottomAxis.LabelsFont.Color = clBlack
          BottomAxis.LabelsFont.Height = -16
          BottomAxis.LabelsFont.Name = 'Arial'
          BottomAxis.LabelsFont.Style = []
          BottomAxis.LabelsSize = 18
          BottomAxis.RoundFirstLabel = False
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
          LeftAxis.AxisValuesFormat = '#0.#### ##0'
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
          LeftAxis.Title.Font.Style = [fsBold]
          Legend.Alignment = laTop
          RightAxis.Automatic = False
          RightAxis.AutomaticMaximum = False
          RightAxis.AutomaticMinimum = False
          RightAxis.AxisValuesFormat = '##.#### ##0'
          RightAxis.LabelsFont.Charset = DEFAULT_CHARSET
          RightAxis.LabelsFont.Color = clBlack
          RightAxis.LabelsFont.Height = -15
          RightAxis.LabelsFont.Name = 'Arial'
          RightAxis.LabelsFont.Style = []
          RightAxis.LabelStyle = talValue
          RightAxis.Maximum = 0.000130000000000000
          RightAxis.Title.Caption = 'Standart deviation'
          RightAxis.Title.Font.Charset = DEFAULT_CHARSET
          RightAxis.Title.Font.Color = clBlack
          RightAxis.Title.Font.Height = -16
          RightAxis.Title.Font.Name = 'Arial'
          RightAxis.Title.Font.Style = [fsBold]
          View3D = False
          Align = alTop
          TabOrder = 0
          OnDblClick = Chart1DblClick
          object ch1Voltseries: TLineSeries
            Marks.ArrowLength = 8
            Marks.Visible = False
            SeriesColor = clBlue
            Title = 'Voltage'
            Dark3D = False
            Pointer.HorizSize = 2
            Pointer.InflateMargins = False
            Pointer.Pen.Visible = False
            Pointer.Style = psRectangle
            Pointer.VertSize = 2
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
          object ch1StdSeries: TLineSeries
            Marks.ArrowLength = 8
            Marks.Visible = False
            SeriesColor = clRed
            Title = 'Std'
            ValueFormat = '#,##0.##########'
            VertAxis = aRightAxis
            Pointer.InflateMargins = True
            Pointer.Style = psRectangle
            Pointer.Visible = False
            XValues.DateTime = True
            XValues.Name = 'X'
            XValues.Multiplier = 1.000000000000000000
            XValues.Order = loAscending
            YValues.DateTime = False
            YValues.Name = 'Y'
            YValues.Multiplier = 1.000000000000000000
            YValues.Order = loNone
          end
          object ch1MeanSeries: TLineSeries
            Marks.ArrowLength = 8
            Marks.Visible = False
            SeriesColor = clGreen
            Title = 'mean'
            Pointer.InflateMargins = True
            Pointer.Style = psRectangle
            Pointer.Visible = False
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
        object Chart2: TChart
          Left = 0
          Top = 404
          Width = 1200
          Height = 104
          BackWall.Brush.Color = clWhite
          BackWall.Brush.Style = bsClear
          MarginBottom = 0
          MarginLeft = 0
          MarginRight = 0
          MarginTop = 0
          Title.Text.Strings = (
            '')
          Title.Visible = False
          BottomAxis.DateTimeFormat = 'HH:NN:SS'
          LeftAxis.AxisValuesFormat = '##.#### ##0'
          LeftAxis.LabelsFont.Charset = DEFAULT_CHARSET
          LeftAxis.LabelsFont.Color = clBlack
          LeftAxis.LabelsFont.Height = -16
          LeftAxis.LabelsFont.Name = 'Arial'
          LeftAxis.LabelsFont.Style = []
          LeftAxis.Title.Caption = 'Voltage'
          LeftAxis.Title.Font.Charset = DEFAULT_CHARSET
          LeftAxis.Title.Font.Color = clGreen
          LeftAxis.Title.Font.Height = -16
          LeftAxis.Title.Font.Name = 'Arial'
          LeftAxis.Title.Font.Style = [fsBold]
          Legend.Alignment = laTop
          Legend.ColorWidth = 25
          Legend.DividingLines.Visible = True
          Legend.Font.Charset = DEFAULT_CHARSET
          Legend.Font.Color = clBlack
          Legend.Font.Height = -16
          Legend.Font.Name = 'Arial'
          Legend.Font.Style = [fsBold]
          Legend.LegendStyle = lsSeries
          Legend.ShadowColor = 8355711
          Legend.ShadowSize = 2
          Legend.TextStyle = ltsPlain
          Legend.VertMargin = 4
          RightAxis.Automatic = False
          RightAxis.AutomaticMinimum = False
          RightAxis.AxisValuesFormat = '##.#### ##0'
          RightAxis.Title.Caption = 'STD'
          RightAxis.Title.Font.Charset = DEFAULT_CHARSET
          RightAxis.Title.Font.Color = clRed
          RightAxis.Title.Font.Height = -13
          RightAxis.Title.Font.Name = 'Arial'
          RightAxis.Title.Font.Style = []
          View3D = False
          Align = alClient
          TabOrder = 1
          OnDblClick = Chart2DblClick
          object CounterSeries: TLineSeries
            Active = False
            Marks.ArrowLength = 8
            Marks.Visible = False
            SeriesColor = clRed
            Title = 'Counter'
            VertAxis = aRightAxis
            Pointer.HorizSize = 2
            Pointer.InflateMargins = True
            Pointer.Pen.Visible = False
            Pointer.Style = psRectangle
            Pointer.VertSize = 2
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
          object meanVoltageSeries: TLineSeries
            Marks.ArrowLength = 8
            Marks.Visible = False
            SeriesColor = clGreen
            Title = 'Voltage. Mean'
            Pointer.HorizSize = 2
            Pointer.InflateMargins = True
            Pointer.Pen.Visible = False
            Pointer.Style = psRectangle
            Pointer.VertSize = 2
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
          object STDVoltageSeries: TLineSeries
            Marks.ArrowLength = 8
            Marks.Visible = False
            SeriesColor = clRed
            Title = 'Voltage. Standard deviation'
            VertAxis = aRightAxis
            Pointer.HorizSize = 2
            Pointer.InflateMargins = True
            Pointer.Pen.Visible = False
            Pointer.Style = psRectangle
            Pointer.VertSize = 2
            Pointer.Visible = True
            XValues.DateTime = False
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
      object TabSheet5: TTabSheet
        Caption = 'Counter'
        ImageIndex = 1
        object Chart3: TChart
          Left = 0
          Top = 0
          Width = 1479
          Height = 694
          BackWall.Brush.Color = clWhite
          BackWall.Brush.Style = bsClear
          Title.Text.Strings = (
            #1057#1087#1077#1082#1090#1088)
          BottomAxis.AxisValuesFormat = '#.#### ##0'
          BottomAxis.Title.Caption = 'Voltage'
          Legend.Visible = False
          RightAxis.Automatic = False
          RightAxis.AutomaticMaximum = False
          RightAxis.AutomaticMinimum = False
          RightAxis.AxisValuesFormat = '#.#####0'
          RightAxis.Maximum = 30.000000000000000000
          View3D = False
          Align = alClient
          Color = clWhite
          TabOrder = 0
          object CountperVSeries: TPointSeries
            Marks.ArrowLength = 0
            Marks.Visible = False
            SeriesColor = clRed
            Title = 'Counter'
            Pointer.Brush.Color = clBlack
            Pointer.HorizSize = 2
            Pointer.InflateMargins = True
            Pointer.Pen.Visible = False
            Pointer.Style = psRectangle
            Pointer.VertSize = 2
            Pointer.Visible = True
            XValues.DateTime = False
            XValues.Name = 'X'
            XValues.Multiplier = 1.000000000000000000
            XValues.Order = loAscending
            YValues.DateTime = False
            YValues.Name = 'Y'
            YValues.Multiplier = 1.000000000000000000
            YValues.Order = loNone
          end
          object Series1: TPointSeries
            Marks.ArrowLength = 0
            Marks.Visible = False
            SeriesColor = clGreen
            VertAxis = aRightAxis
            Pointer.Brush.Color = 8388863
            Pointer.HorizSize = 1
            Pointer.InflateMargins = True
            Pointer.Pen.Visible = False
            Pointer.Style = psRectangle
            Pointer.VertSize = 1
            Pointer.Visible = True
            XValues.DateTime = False
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
      object TabSheet6: TTabSheet
        Caption = 'TabSheet6'
        ImageIndex = 2
        object Panel6: TPanel
          Left = 0
          Top = 0
          Width = 1479
          Height = 50
          Align = alTop
          TabOrder = 0
          object startDacbtn: TSpeedButton
            Left = 10
            Top = 5
            Width = 80
            Height = 41
            Caption = 'Start'
            OnClick = startDacbtnClick
          end
        end
        object Panel7: TPanel
          Left = 0
          Top = 50
          Width = 1479
          Height = 644
          Align = alClient
          Caption = 'Panel7'
          TabOrder = 1
          object Chart4: TChart
            Left = 1
            Top = 1
            Width = 1477
            Height = 641
            BackWall.Brush.Color = clWhite
            BackWall.Brush.Style = bsClear
            Title.Text.Strings = (
              #1050#1072#1083#1080#1073#1088#1086#1074#1082#1072)
            LeftAxis.AxisValuesFormat = '#.#### #'
            Legend.Visible = False
            View3D = False
            Align = alClient
            TabOrder = 0
            object Dacseries: TLineSeries
              Marks.ArrowLength = 8
              Marks.Visible = False
              SeriesColor = clRed
              Pointer.HorizSize = 2
              Pointer.InflateMargins = True
              Pointer.Style = psRectangle
              Pointer.VertSize = 2
              Pointer.Visible = True
              XValues.DateTime = False
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
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 785
    Width = 1210
    Height = 30
    Panels = <
      item
        Width = 200
      end
      item
        Width = 200
      end
      item
        Width = 300
      end>
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 1124
    Top = 63
  end
end
