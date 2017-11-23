program Daq_es50;

uses
  Forms,
  main in 'main.pas' {MainForm},
  Adgpib in 'Adgpib.pas',
  gpib_user in 'gpib_user.pas',
  Logging in 'Logging.pas',
  SetMinMax in '..\common\SetMinMax.pas' {SetMinMaxForm},
  CommonConstants in '..\common\CommonConstants.pas',
  DAS_Const in '..\common\DAS_Const.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TSetMinMaxForm, SetMinMaxForm);
  Application.Run;
end.
