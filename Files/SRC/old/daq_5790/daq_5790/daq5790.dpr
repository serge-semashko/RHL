program daq5790;

uses
  Forms,
  main in 'main.pas' {MainForm} ,
  Adgpib in 'Adgpib.pas',
  gpib_user in 'gpib_user.pas',
  Logging in 'Logging.pas',
  SetMinMax in '..\common\SetMinMax.pas' {SetMinMaxForm} ,
  DAS_Const in '..\common\DAS_Const.pas',
  I7000 in 'I7000.pas',
  I7000u in 'i7000u.pas',
  DCON_PC in 'dcon_pc.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TSetMinMaxForm, SetMinMaxForm);
  Application.Run;

end.
