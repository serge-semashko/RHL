unit trends;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TeEngine, Series, ExtCtrls, TeeProcs, Chart;

type
  TFormTrends = class(TForm)
    Chart1: TChart;
    Panel1: TPanel;
    Panel2: TPanel;
    w1271ser: TLineSeries;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormTrends: TFormTrends;

implementation

{$R *.dfm}

end.
