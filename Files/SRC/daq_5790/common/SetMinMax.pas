unit SetMinMax;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, chart, das_Const;

type
  TSetMinMaxForm = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    UpperLimit: TEdit;
    OkBtn: Tspeedbutton;
    BitBtn2: Tspeedbutton;
    LowerLimit: TEdit;
    procedure OkBtnClick(Sender: TObject);
    procedure UpperLimitChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    chart: TChart;
    Function SetLimits(Sender: TChart): integer;
    { Public declarations }
  end;

var
  SetMinMaxForm: TSetMinMaxForm;

implementation

uses main;

{$R *.DFM}

{ TForm1 }
var
  fs: TFormatSettings;

Function TSetMinMaxForm.SetLimits;
begin
  UpperLimit.Text := Format('%.4f', [Sender.LeftAxis.Maximum]);
  LowerLimit.Text := Format('%.4f', [Sender.LeftAxis.minimum]);
  chart := Sender;
  OkBtn.enabled := true;
  Top := chart.Top + (chart.Height div 2) + MainForm.Top;
  Left := chart.Left + (chart.Width div 2) + MainForm.Left;
  self.BringToFront;
  result := showmodal;
end;

procedure TSetMinMaxForm.OkBtnClick(Sender: TObject);
Var
  OldDelimiter: Char;
  i1: integer;
begin
  OldDelimiter := fs.DecimalSeparator;
  fs.DecimalSeparator := '.';
  UpperLimit.Text := ChangeChar(UpperLimit.Text, ',', '.');
  LowerLimit.Text := ChangeChar(LowerLimit.Text, ',', '.');
  chart.LeftAxis.SetMinMax(StrToFloat(LowerLimit.Text),
    StrToFloat(UpperLimit.Text));
  fs.DecimalSeparator := OldDelimiter;
  chart.LeftAxis.Automatic := false;
  chart.LeftAxis.AutomaticMaximum := false;
  chart.LeftAxis.AutomaticMinimum := false;
  ModalResult := mrOK;

end;

procedure TSetMinMaxForm.UpperLimitChange(Sender: TObject);
var
  Hi, Lo: double;
  Res1, res2: integer;
  OldSeparator: Char;
  i1: integer;
begin
  OldSeparator := fs.DecimalSeparator;
  fs.DecimalSeparator := '.';
  UpperLimit.Text := ChangeChar(UpperLimit.Text, ',', '.');
  LowerLimit.Text := ChangeChar(LowerLimit.Text, ',', '.');
  Val(LowerLimit.Text, Lo, Res1);
  Val(UpperLimit.Text, Hi, res2);
  fs.DecimalSeparator := OldSeparator;
  OkBtn.enabled := (Res1 = 0) and (res2 = 0) and (Hi > Lo);
end;

procedure TSetMinMaxForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  chart.CancelMouse := true;
end;

procedure TSetMinMaxForm.BitBtn2Click(Sender: TObject);
begin
  ModalResult := mrcancel;
  close;
end;

procedure TSetMinMaxForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    if OkBtn.enabled then
      OkBtn.Click;
end;

end.
