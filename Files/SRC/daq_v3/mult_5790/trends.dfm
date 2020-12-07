object FormTrends: TFormTrends
  Left = 63
  Top = 36
  Width = 1771
  Height = 940
  Caption = 'FormTrends'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 120
  TextHeight = 16
  object Chart1: TChart
    Left = 0
    Top = 41
    Width = 1753
    Height = 813
    BackWall.Brush.Color = clWhite
    BackWall.Brush.Style = bsClear
    BottomAxis.DateTimeFormat = 'HH:NN:SS'
    Legend.Alignment = laTop
    Legend.LegendStyle = lsSeries
    View3D = False
    Align = alClient
    TabOrder = 0
    object w1271ser: TLineSeries
      Marks.ArrowLength = 8
      Marks.Visible = False
      SeriesColor = clRed
      Title = 'Wavetek1271'
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
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1753
    Height = 41
    Align = alTop
    TabOrder = 1
  end
  object Panel2: TPanel
    Left = 0
    Top = 854
    Width = 1753
    Height = 41
    Align = alBottom
    TabOrder = 2
  end
end
