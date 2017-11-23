program TestMMThr;

uses
  Forms,
  main in 'main.pas' {MainForm},
  CommonConstants in '..\common\CommonConstants.pas',
  DAS_Const in '..\common\DAS_Const.pas',
  SetMinMax in '..\common\SetMinMax.pas' {SetMinMaxForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TSetMinMaxForm, SetMinMaxForm);
  Application.Run;
end.
