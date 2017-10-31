object MainForm: TMainForm
  Left = 108
  Top = 119
  Caption = 'Read/Write'
  ClientHeight = 815
  ClientWidth = 1210
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 754
    Width = 1210
    Height = 31
    Align = alBottom
    TabOrder = 0
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 1210
    Height = 164
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
        Width = 1202
        Height = 993
        Align = alTop
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
        object StartCycle: TSpeedButton
          Left = 628
          Top = 17
          Width = 98
          Height = 17
          Caption = 'Get stat'
          OnClick = StartCycleClick
        end
        object cmbGPIB: TComboBox
          Left = 47
          Top = 16
          Width = 74
          Height = 28
          ImeName = #164#164#164#1077' ('#1041'c'#1045#1081') - '#183's'#1028'`'#173#181
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
          OnClick = Button1Click
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
          Left = 0
          Top = 44
          Width = 673
          Height = 77
          ImeName = #164#164#164#1077' ('#1041'c'#1045#1081') - '#183's'#1028'`'#173#181
          Lines.Strings = (
            'Memo1')
          TabOrder = 4
        end
        object CycBox: TCheckBox
          Left = 734
          Top = 19
          Width = 125
          Height = 13
          Caption = 'Continue read'
          Checked = True
          State = cbChecked
          TabOrder = 5
        end
        object DAQlen: TSpinEdit
          Left = 564
          Top = 12
          Width = 60
          Height = 31
          MaxValue = 0
          MinValue = 0
          TabOrder = 6
          Value = 0
        end
        object Topspn: TSpinEdit
          Left = 801
          Top = 89
          Width = 121
          Height = 31
          MaxValue = 0
          MinValue = 0
          TabOrder = 7
          Value = 500
        end
        object Bottomspn: TSpinEdit
          Left = 677
          Top = 89
          Width = 121
          Height = 31
          MaxValue = 0
          MinValue = 0
          TabOrder = 8
          Value = 300
        end
        object expspn: TSpinEdit
          Left = 925
          Top = 89
          Width = 69
          Height = 31
          MaxValue = 0
          MinValue = 0
          TabOrder = 9
          Value = 60
        end
        object StaticText1: TStaticText
          Left = 678
          Top = 41
          Width = 239
          Height = 24
          Alignment = taCenter
          AutoSize = False
          BevelKind = bkTile
          BevelOuter = bvRaised
          Caption = #1043#1088#1072#1085#1080#1094#1099
          TabOrder = 10
        end
        object StaticText2: TStaticText
          Left = 677
          Top = 66
          Width = 119
          Height = 24
          Alignment = taCenter
          AutoSize = False
          BevelKind = bkSoft
          Caption = 'Bottom'
          TabOrder = 11
        end
        object StaticText3: TStaticText
          Left = 802
          Top = 65
          Width = 117
          Height = 24
          Alignment = taCenter
          AutoSize = False
          BevelKind = bkSoft
          Caption = 'Top'
          TabOrder = 12
        end
        object StaticText4: TStaticText
          Left = 923
          Top = 63
          Width = 73
          Height = 24
          Caption = 'Exp. Time'
          TabOrder = 13
        end
        object StaticText5: TStaticText
          Left = 1003
          Top = 63
          Width = 77
          Height = 24
          Caption = 'Dead time'
          TabOrder = 14
        end
        object deadspn: TSpinEdit
          Left = 1005
          Top = 89
          Width = 69
          Height = 31
          MaxValue = 0
          MinValue = 0
          TabOrder = 15
          Value = 2
        end
        object StaticText6: TStaticText
          Left = 1084
          Top = 63
          Width = 38
          Height = 24
          Caption = 'Step'
          TabOrder = 16
        end
        object stepspn: TSpinEdit
          Left = 1081
          Top = 87
          Width = 69
          Height = 31
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
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Panel3: TPanel
        Left = 0
        Top = 0
        Width = 801
        Height = 129
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
          Left = 417
          Top = 43
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
        object Memo1: TMemo
          Left = 413
          Top = 64
          Width = 383
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
          Value = 2
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
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Panel4: TPanel
        Left = 0
        Top = 0
        Width = 465
        Height = 129
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
    Top = 164
    Width = 1210
    Height = 590
    Align = alClient
    Caption = 'Panel5'
    TabOrder = 2
    object Splitter1: TSplitter
      Left = 1
      Top = 1
      Width = 1208
      Height = 3
      Cursor = crVSplit
      Align = alTop
      ExplicitWidth = 1210
    end
    object PageControl2: TPageControl
      Left = 1
      Top = 4
      Width = 1208
      Height = 585
      ActivePage = TabSheet6
      Align = alClient
      TabOrder = 0
      object TabSheet4: TTabSheet
        Caption = 'Meam&STD'
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object Chart1: TChart
          Left = 0
          Top = 0
          Width = 1202
          Height = 328
          BackWall.Brush.Style = bsClear
          Legend.Alignment = laTop
          MarginBottom = 0
          MarginLeft = 0
          MarginRight = 0
          MarginTop = 0
          Title.Font.Height = -19
          Title.Text.Strings = (
            'Voltage')
          BottomAxis.DateTimeFormat = 'HH:MM:SS'
          BottomAxis.LabelsFormat.Font.Height = -16
          BottomAxis.LabelsSize = 18
          BottomAxis.RoundFirstLabel = False
          BottomAxis.TickInnerLength = 8
          BottomAxis.TickLength = 7
          BottomAxis.TicksInner.Width = 2
          BottomAxis.Title.Caption = 'Date time'
          BottomAxis.Title.Font.Height = -16
          BottomAxis.TitleSize = 9
          LeftAxis.AxisValuesFormat = '#0.#### ##0'
          LeftAxis.LabelsFormat.Font.Height = -16
          LeftAxis.Title.Caption = 'Voltage'
          LeftAxis.Title.Font.Height = -16
          LeftAxis.Title.Font.Style = [fsBold]
          RightAxis.AxisValuesFormat = '##.#### ##0'
          RightAxis.LabelsFormat.Font.Height = -15
          RightAxis.LabelStyle = talValue
          RightAxis.Title.Caption = 'Standart deviation'
          RightAxis.Title.Font.Height = -16
          RightAxis.Title.Font.Style = [fsBold]
          View3D = False
          Align = alTop
          TabOrder = 0
          OnDblClick = Chart1DblClick
          DefaultCanvas = 'TGDIPlusCanvas'
          ColorPaletteIndex = 13
          object ch1Voltseries: TLineSeries
            SeriesColor = clBlue
            Title = 'Voltage'
            Brush.BackColor = clDefault
            Dark3D = False
            Pointer.HorizSize = 2
            Pointer.InflateMargins = False
            Pointer.Pen.Visible = False
            Pointer.Style = psRectangle
            Pointer.VertSize = 2
            Pointer.Visible = True
            XValues.DateTime = True
            XValues.Name = 'X'
            XValues.Order = loAscending
            YValues.Name = 'Y'
            YValues.Order = loNone
          end
          object ch1StdSeries: TLineSeries
            SeriesColor = clRed
            Title = 'Std'
            ValueFormat = '#,##0.##########'
            VertAxis = aRightAxis
            Brush.BackColor = clDefault
            Pointer.InflateMargins = True
            Pointer.Style = psRectangle
            XValues.DateTime = True
            XValues.Name = 'X'
            XValues.Order = loAscending
            YValues.Name = 'Y'
            YValues.Order = loNone
          end
          object ch1MeanSeries: TLineSeries
            SeriesColor = clGreen
            Title = 'mean'
            Brush.BackColor = clDefault
            Pointer.InflateMargins = True
            Pointer.Style = psRectangle
            XValues.DateTime = True
            XValues.Name = 'X'
            XValues.Order = loAscending
            YValues.Name = 'Y'
            YValues.Order = loNone
          end
        end
        object Chart2: TChart
          Left = 0
          Top = 328
          Width = 1202
          Height = 236
          BackWall.Brush.Style = bsClear
          Legend.Alignment = laTop
          Legend.ColorWidth = 25
          Legend.DividingLines.Visible = True
          Legend.Font.Height = -16
          Legend.Font.Style = [fsBold]
          Legend.LegendStyle = lsSeries
          Legend.Shadow.Color = 8355711
          Legend.Shadow.HorizSize = 2
          Legend.Shadow.VertSize = 2
          Legend.Symbol.Width = 25
          Legend.TextStyle = ltsPlain
          Legend.VertMargin = 4
          MarginBottom = 0
          MarginLeft = 0
          MarginRight = 0
          MarginTop = 0
          Title.Text.Strings = (
            '')
          Title.Visible = False
          BottomAxis.DateTimeFormat = 'HH:NN:SS'
          LeftAxis.AxisValuesFormat = '##.#### ##0'
          LeftAxis.LabelsFormat.Font.Height = -16
          LeftAxis.Title.Caption = 'Voltage'
          LeftAxis.Title.Font.Color = clGreen
          LeftAxis.Title.Font.Height = -16
          LeftAxis.Title.Font.Style = [fsBold]
          RightAxis.Automatic = False
          RightAxis.AutomaticMinimum = False
          RightAxis.AxisValuesFormat = '##.#### ##0'
          RightAxis.Title.Caption = 'STD'
          RightAxis.Title.Font.Color = clRed
          View3D = False
          Align = alClient
          TabOrder = 1
          OnDblClick = Chart2DblClick
          DefaultCanvas = 'TGDIPlusCanvas'
          ColorPaletteIndex = 13
          object CounterSeries: TLineSeries
            Active = False
            SeriesColor = clRed
            Title = 'Counter'
            VertAxis = aRightAxis
            Brush.BackColor = clDefault
            Pointer.HorizSize = 2
            Pointer.InflateMargins = True
            Pointer.Pen.Visible = False
            Pointer.Style = psRectangle
            Pointer.VertSize = 2
            Pointer.Visible = True
            XValues.DateTime = True
            XValues.Name = 'X'
            XValues.Order = loAscending
            YValues.Name = 'Y'
            YValues.Order = loNone
          end
          object meanVoltageSeries: TLineSeries
            SeriesColor = clGreen
            Title = 'Voltage. Mean'
            Brush.BackColor = clDefault
            Pointer.HorizSize = 2
            Pointer.InflateMargins = True
            Pointer.Pen.Visible = False
            Pointer.Style = psRectangle
            Pointer.VertSize = 2
            Pointer.Visible = True
            XValues.DateTime = True
            XValues.Name = 'X'
            XValues.Order = loAscending
            YValues.Name = 'Y'
            YValues.Order = loNone
          end
          object STDVoltageSeries: TLineSeries
            SeriesColor = clRed
            Title = 'Voltage. Standard deviation'
            VertAxis = aRightAxis
            Brush.BackColor = clDefault
            Pointer.HorizSize = 2
            Pointer.InflateMargins = True
            Pointer.Pen.Visible = False
            Pointer.Style = psRectangle
            Pointer.VertSize = 2
            Pointer.Visible = True
            XValues.Name = 'X'
            XValues.Order = loAscending
            YValues.Name = 'Y'
            YValues.Order = loNone
          end
        end
      end
      object TabSheet5: TTabSheet
        Caption = 'Counter'
        ImageIndex = 1
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object Chart3: TChart
          Left = 0
          Top = 0
          Width = 1202
          Height = 564
          BackWall.Brush.Style = bsClear
          Legend.Visible = False
          Title.Text.Strings = (
            #1057#1087#1077#1082#1090#1088)
          BottomAxis.AxisValuesFormat = '#.#### ##0'
          BottomAxis.Title.Caption = 'Voltage'
          RightAxis.Automatic = False
          RightAxis.AutomaticMaximum = False
          RightAxis.AutomaticMinimum = False
          RightAxis.AxisValuesFormat = '#.#####0'
          RightAxis.Maximum = 30.000000000000000000
          View3D = False
          Align = alClient
          Color = clWhite
          TabOrder = 0
          DefaultCanvas = 'TGDIPlusCanvas'
          ColorPaletteIndex = 13
          object CountperVSeries: TPointSeries
            SeriesColor = clRed
            Title = 'Counter'
            ClickableLine = False
            Pointer.Brush.Color = clBlack
            Pointer.HorizSize = 2
            Pointer.InflateMargins = True
            Pointer.Pen.Visible = False
            Pointer.Style = psRectangle
            Pointer.VertSize = 2
            XValues.Name = 'X'
            XValues.Order = loAscending
            YValues.Name = 'Y'
            YValues.Order = loNone
          end
          object Series1: TPointSeries
            SeriesColor = clGreen
            VertAxis = aRightAxis
            ClickableLine = False
            Pointer.Brush.Color = 8388863
            Pointer.HorizSize = 1
            Pointer.InflateMargins = True
            Pointer.Pen.Visible = False
            Pointer.Style = psRectangle
            Pointer.VertSize = 1
            XValues.Name = 'X'
            XValues.Order = loAscending
            YValues.Name = 'Y'
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
          Width = 1200
          Height = 41
          Align = alTop
          TabOrder = 0
          object startDacbtn: TSpeedButton
            Left = 8
            Top = 4
            Width = 65
            Height = 33
            Caption = 'Start'
            OnClick = startDacbtnClick
          end
        end
        object Panel7: TPanel
          Left = 0
          Top = 41
          Width = 1200
          Height = 516
          Align = alClient
          Caption = 'Panel7'
          TabOrder = 1
          object Chart4: TChart
            Left = 1
            Top = 1
            Width = 1198
            Height = 514
            BackWall.Brush.Style = bsClear
            Legend.Visible = False
            Title.Text.Strings = (
              #1050#1072#1083#1080#1073#1088#1086#1074#1082#1072)
            LeftAxis.AxisValuesFormat = '#.#### #'
            View3D = False
            Align = alClient
            TabOrder = 0
            DefaultCanvas = 'TGDIPlusCanvas'
            ColorPaletteIndex = 13
            object Dacseries: TLineSeries
              SeriesColor = clRed
              Brush.BackColor = clDefault
              Pointer.HorizSize = 2
              Pointer.InflateMargins = True
              Pointer.Style = psRectangle
              Pointer.VertSize = 2
              Pointer.Visible = True
              XValues.Name = 'X'
              XValues.Order = loAscending
              YValues.Name = 'Y'
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
