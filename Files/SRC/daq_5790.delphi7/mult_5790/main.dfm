object MainForm: TMainForm
  Left = -10
  Top = 135
  Width = 1296
  Height = 781
  Caption = 'Read/Write'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 682
    Width = 1280
    Height = 31
    Align = alBottom
    TabOrder = 0
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 1280
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
      object StartCycle: TSpeedButton
        Left = 814
        Top = 33
        Width = 176
        Height = 40
        Caption = 'Start measurement'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -16
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        OnClick = StartCycleClick
      end
      object dbgrd2: TDBGrid
        Left = 0
        Top = 0
        Width = 801
        Height = 129
        Align = alLeft
        DataSource = ds1
        Enabled = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -15
        Font.Name = 'Courier New'
        Font.Style = [fsBold]
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
        ParentFont = False
        ReadOnly = True
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -20
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
      end
    end
  end
  object Panel5: TPanel
    Left = 0
    Top = 164
    Width = 1280
    Height = 518
    Align = alClient
    Caption = 'Panel5'
    TabOrder = 2
    object Splitter1: TSplitter
      Left = 1
      Top = 1
      Width = 1278
      Height = 3
      Cursor = crVSplit
      Align = alTop
    end
    object PageControl2: TPageControl
      Left = 1
      Top = 4
      Width = 1278
      Height = 513
      ActivePage = ts1
      Align = alClient
      TabOrder = 0
      object TabSheet4: TTabSheet
        Caption = #1053#1072#1087#1088#1103#1078#1077#1085#1080#1077' '#1101#1082#1089#1087#1086#1079#1080#1094#1080#1080
        object Chart1: TChart
          Left = 0
          Top = 0
          Width = 1270
          Height = 328
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
          RightAxis.AxisValuesFormat = '##.#### ##0'
          RightAxis.LabelsFont.Charset = DEFAULT_CHARSET
          RightAxis.LabelsFont.Color = clBlack
          RightAxis.LabelsFont.Height = -15
          RightAxis.LabelsFont.Name = 'Arial'
          RightAxis.LabelsFont.Style = []
          RightAxis.LabelStyle = talValue
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
          Top = 328
          Width = 1270
          Height = 290
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
        Caption = #1057#1087#1077#1089#1082#1090#1088#1099
        ImageIndex = 1
        object Chart3: TChart
          Left = 0
          Top = 0
          Width = 1212
          Height = 618
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
      object ts1: TTabSheet
        Caption = #1044#1080#1072#1087#1072#1079#1086#1085#1099' '#1080' '#1085#1072#1089#1090#1088#1086#1081#1082#1072
        ImageIndex = 3
        object pnl1: TPanel
          Left = 0
          Top = 0
          Width = 657
          Height = 485
          Align = alLeft
          Caption = 'pnl1'
          TabOrder = 0
          object pnl3: TPanel
            Left = 1
            Top = 431
            Width = 655
            Height = 53
            Align = alBottom
            Caption = 'pnl3'
            TabOrder = 0
            object addbtn: TSpeedButton
              Left = 2
              Top = 9
              Width = 25
              Height = 24
              Glyph.Data = {
                F6060000424DF606000000000000360000002800000018000000180000000100
                180000000000C006000074120000741200000000000000000000FFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFB0B0B016161600000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF1515150000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFF000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000FFFFFFFFFFFFB0B0B016
                1616000000000000000000000000000000000000000000000000000000000000
                000000000000171717B2B2B2FFFFFFFFFFFFFFFFFFFFFFFF000000000000FFFF
                FFFFFFFF15151500000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000171717FFFFFFFFFFFFFFFFFFFFFFFF
                000000000000FFFFFFFFFFFF0000000000000000000000000000000000000000
                00000000000000000000000000000000000000000000000000000000FFFFFFFF
                FFFFFFFFFFFFFFFF000000000000FFFFFFFFFFFF000000000000000000000000
                000000000000000000FFFFFFFFFFFF0000000000000000000000000000000000
                00000000FFFFFFFFFFFFFFFFFFFFFFFF000000000000FFFFFFFFFFFF00000000
                0000000000000000000000000000000000FFFFFFFFFFFF000000000000000000
                000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFF000000000000FFFF
                FFFFFFFF000000000000000000000000000000000000000000FFFFFFFFFFFF00
                0000000000000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFF
                000000000000FFFFFFFFFFFF0000000000000000000000000000000000000000
                00FFFFFFFFFFFF000000000000000000000000000000000000000000FFFFFFFF
                FFFFFFFFFFFFFFFF000000000000FFFFFFFFFFFF000000000000000000FFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000
                00000000FFFFFFFFFFFFFFFFFFFFFFFF000000000000FFFFFFFFFFFF00000000
                0000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFF000000000000000000FFFFFFFFFFFFFFFFFFFFFFFF000000000000FFFF
                FFFFFFFF000000000000000000000000000000000000000000FFFFFFFFFFFF00
                0000000000000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFF
                000000000000FFFFFFFFFFFF0000000000000000000000000000000000000000
                00FFFFFFFFFFFF000000000000000000000000000000000000000000FFFFFFFF
                FFFFFFFFFFFFFFFF000000000000FFFFFFFFFFFF000000000000000000000000
                000000000000000000FFFFFFFFFFFF0000000000000000000000000000000000
                00000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000
                0000000000000000000000000000000000FFFFFFFFFFFF000000000000000000
                000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFFFF00000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFF1616160000000000000000000000000000000000
                00000000000000000000000000000000000000000000000000161616FFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFAEAEAE161616000000000000
                0000000000000000000000000000000000000000000000000000000000001515
                15B0B0B0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
              OnClick = pnl3Click
            end
            object rembtn: TSpeedButton
              Left = 28
              Top = 9
              Width = 25
              Height = 24
              Glyph.Data = {
                F6060000424DF606000000000000360000002800000018000000180000000100
                180000000000C006000074120000741200000000000000000000FFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFB0B0B016161600000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF1515150000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFF000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000FFFFFFFFFFFFB0B0B016
                1616000000000000000000000000000000000000000000000000000000000000
                000000000000171717B2B2B2FFFFFFFFFFFFFFFFFFFFFFFF000000000000FFFF
                FFFFFFFF15151500000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000171717FFFFFFFFFFFFFFFFFFFFFFFF
                000000000000FFFFFFFFFFFF0000000000000000000000000000000000000000
                00000000000000000000000000000000000000000000000000000000FFFFFFFF
                FFFFFFFFFFFFFFFF000000000000FFFFFFFFFFFF000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                00000000FFFFFFFFFFFFFFFFFFFFFFFF000000000000FFFFFFFFFFFF00000000
                0000000000000000000000000000000000020202020202000000000000000000
                000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFF000000000000FFFF
                FFFFFFFF00000000000000000000000000000000000000000001010101010100
                0000000000000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFF
                000000000000FFFFFFFFFFFF0000000000000000000000000000000000000000
                00040404040404000000000000000000000000000000000000000000FFFFFFFF
                FFFFFFFFFFFFFFFF000000000000FFFFFFFFFFFF000000000000000000FFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000
                00000000FFFFFFFFFFFFFFFFFFFFFFFF000000000000FFFFFFFFFFFF00000000
                0000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFF000000000000000000FFFFFFFFFFFFFFFFFFFFFFFF000000000000FFFF
                FFFFFFFF00000000000000000000000000000000000000000010101012121200
                0000000000000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFF
                000000000000FFFFFFFFFFFF0000000000000000000000000000000000000000
                00000000000000000000000000000000000000000000000000000000FFFFFFFF
                FFFFFFFFFFFFFFFF000000000000FFFFFFFFFFFF000000000000000000000000
                0000000000000000000707070303030000000000000000000000000000000000
                00000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000
                0000000000000000000000000000000000060606020202000000000000000000
                000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFFFF00000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFF1616160000000000000000000000000000000000
                00000000000000000000000000000000000000000000000000161616FFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFAEAEAE161616000000000000
                0000000000000000000000000000000000000000000000000000000000001515
                15B0B0B0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
              OnClick = rembtnClick
            end
            object btn1: TSpeedButton
              Left = 475
              Top = 13
              Width = 65
              Height = 18
              Caption = #1054#1095#1080#1089#1090#1080#1090#1100
              OnClick = btn1Click
            end
            object Bottomspn: TSpinEdit
              Left = 66
              Top = 17
              Width = 66
              Height = 22
              MaxValue = 0
              MinValue = 0
              TabOrder = 0
              Value = 300
            end
            object Topspn: TSpinEdit
              Left = 135
              Top = 17
              Width = 66
              Height = 22
              MaxValue = 0
              MinValue = 0
              TabOrder = 1
              Value = 500
            end
            object expspn: TSpinEdit
              Left = 200
              Top = 17
              Width = 66
              Height = 22
              MaxValue = 0
              MinValue = 0
              TabOrder = 2
              Value = 60
            end
            object deadspn: TSpinEdit
              Left = 267
              Top = 17
              Width = 65
              Height = 22
              MaxValue = 60
              MinValue = 5
              TabOrder = 3
              Value = 5
            end
            object stepspn: TSpinEdit
              Left = 334
              Top = 17
              Width = 66
              Height = 22
              MaxValue = 100000
              MinValue = 100
              TabOrder = 4
              Value = 1000
            end
            object StaticText2: TStaticText
              Left = 66
              Top = 2
              Width = 65
              Height = 18
              Alignment = taCenter
              AutoSize = False
              BevelKind = bkTile
              BorderStyle = sbsSingle
              Caption = 'Ubeg(V)'
              TabOrder = 5
            end
            object StaticText3: TStaticText
              Left = 133
              Top = 2
              Width = 65
              Height = 18
              Alignment = taCenter
              AutoSize = False
              BevelKind = bkTile
              BorderStyle = sbsSingle
              Caption = 'Uend(V)'
              TabOrder = 6
            end
            object StaticText4: TStaticText
              Left = 200
              Top = 2
              Width = 51
              Height = 17
              BevelKind = bkTile
              BorderStyle = sbsSingle
              Caption = 'Exp. Time'
              TabOrder = 7
            end
            object StaticText5: TStaticText
              Left = 267
              Top = 2
              Width = 52
              Height = 17
              BevelKind = bkTile
              BorderStyle = sbsSingle
              Caption = 'Dead time'
              TabOrder = 8
            end
            object StaticText6: TStaticText
              Left = 334
              Top = 2
              Width = 47
              Height = 17
              BevelKind = bkTile
              BorderStyle = sbsSingle
              Caption = 'Step(mV)'
              TabOrder = 9
            end
          end
          object dbgrd1: TDBGrid
            Left = 1
            Top = 1
            Width = 655
            Height = 430
            Align = alClient
            DataSource = ds1
            Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
            ReadOnly = True
            TabOrder = 1
            TitleFont.Charset = DEFAULT_CHARSET
            TitleFont.Color = clWindowText
            TitleFont.Height = -11
            TitleFont.Name = 'MS Sans Serif'
            TitleFont.Style = []
          end
        end
        object pnl2: TPanel
          Left = 657
          Top = 0
          Width = 613
          Height = 485
          Align = alClient
          Caption = 'pnl2'
          TabOrder = 1
          object Panel3: TPanel
            Left = 1
            Top = 1
            Width = 611
            Height = 483
            Align = alClient
            BorderStyle = bsSingle
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
            object Label5: TLabel
              Left = 11
              Top = 18
              Width = 45
              Height = 13
              Alignment = taRightJustify
              AutoSize = False
              Caption = 'COM port'
            end
            object Label6: TLabel
              Left = 130
              Top = 18
              Width = 54
              Height = 13
              Caption = '7088d addr'
            end
            object Label9: TLabel
              Left = 235
              Top = 18
              Width = 39
              Height = 13
              Caption = 'Channel'
            end
            object Label1: TLabel
              Left = 11
              Top = 54
              Width = 45
              Height = 13
              Alignment = taRightJustify
              AutoSize = False
              Caption = 'GPIB:'
            end
            object Label2: TLabel
              Left = 130
              Top = 54
              Width = 52
              Height = 13
              Caption = 'Instrument:'
            end
            object ComComboBox: TComboBox
              Left = 60
              Top = 18
              Width = 70
              Height = 21
              Style = csDropDownList
              ImeName = #164#164#164#1077' ('#1041'c'#1045#1081') - '#183's'#1028'`'#173#181
              ItemHeight = 13
              ItemIndex = 0
              TabOrder = 0
              Text = 'COM1'
              OnChange = ComComboBoxChange
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
            object address: TSpinEdit
              Left = 190
              Top = 18
              Width = 40
              Height = 22
              MaxValue = 0
              MinValue = 0
              TabOrder = 1
              Value = 1
              OnChange = addressChange
            end
            object edCh: TSpinEdit
              Left = 284
              Top = 18
              Width = 40
              Height = 22
              MaxValue = 0
              MinValue = 0
              TabOrder = 2
              Value = 0
              OnChange = edChChange
            end
            object Panel2: TPanel
              Left = 1
              Top = 166
              Width = 605
              Height = 312
              Align = alBottom
              BorderStyle = bsSingle
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -13
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              TabOrder = 3
              object Label3: TLabel
                Left = 202
                Top = 11
                Width = 90
                Height = 16
                Caption = 'Sweep number'
              end
              object Label4: TLabel
                Left = 1
                Top = 144
                Width = 599
                Height = 16
                Align = alBottom
                Alignment = taCenter
                Caption = #1054#1087#1080#1089#1072#1085#1080#1077
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -15
                Font.Name = 'MS Sans Serif'
                Font.Style = [fsBold]
                ParentFont = False
              end
              object SpeedButton1: TSpeedButton
                Left = 545
                Top = 88
                Width = 23
                Height = 22
                Caption = '...'
                OnClick = SpeedButton1Click
              end
              object memoRead: TMemo
                Left = 15
                Top = 207
                Width = 377
                Height = 77
                ImeName = #164#164#164#1077' ('#1041'c'#1045#1081') - '#183's'#1028'`'#173#181
                Lines.Strings = (
                  'Memo1')
                TabOrder = 0
                Visible = False
              end
              object DescMemo: TMemo
                Left = 1
                Top = 160
                Width = 599
                Height = 147
                Align = alBottom
                TabOrder = 1
              end
              object seSweepCount: TSpinEdit
                Left = 202
                Top = 32
                Width = 65
                Height = 26
                MaxValue = 0
                MinValue = 0
                TabOrder = 2
                Value = 0
              end
              object rgSweepMode: TRadioGroup
                Left = 8
                Top = 8
                Width = 185
                Height = 55
                Caption = 'Sweep mode'
                ItemIndex = 0
                Items.Strings = (
                  'Up-Down'
                  'Up')
                TabOrder = 3
              end
              object DataDir: TLabeledEdit
                Left = 8
                Top = 88
                Width = 529
                Height = 24
                EditLabel.Width = 84
                EditLabel.Height = 16
                EditLabel.Caption = 'Data directory'
                TabOrder = 4
              end
            end
            object cmbGPIB: TComboBox
              Left = 60
              Top = 54
              Width = 65
              Height = 21
              ImeName = #164#164#164#1077' ('#1041'c'#1045#1081') - '#183's'#1028'`'#173#181
              ItemHeight = 13
              ItemIndex = 0
              TabOrder = 4
              Text = 'GPIB0'
              OnChange = cmbGPIBChange
              Items.Strings = (
                'GPIB0'
                'GPIB1'
                'GPIB2'
                'GPIB3')
            end
            object cmbInst: TComboBox
              Left = 190
              Top = 54
              Width = 40
              Height = 21
              Style = csDropDownList
              ImeName = #164#164#164#1077' ('#1041'c'#1045#1081') - '#183's'#1028'`'#173#181
              ItemHeight = 13
              ItemIndex = 15
              TabOrder = 5
              Text = '16'
              OnChange = cmbInstChange
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
          end
        end
      end
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 713
    Width = 1280
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
  object con1: TADOConnection
    Provider = 'ADsDSOObject'
    Left = 654
    Top = 282
  end
  object ds1: TDataSource
    Left = 686
    Top = 370
  end
  object OpenDialog1: TOpenDialog
    Left = 1104
    Top = 391
  end
end
