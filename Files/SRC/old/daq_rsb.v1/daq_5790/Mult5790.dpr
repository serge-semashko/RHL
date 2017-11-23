program Mult5790;

uses
  Forms,
  main in '..\..\daq_5790.delphi7\daq_5790\main.pas' {MainForm},
  Adgpib in '..\..\daq_5790.delphi7\daq_5790\Adgpib.pas',
  gpib_user in '..\..\daq_5790.delphi7\daq_5790\gpib_user.pas',
  Logging in '..\..\daq_5790.delphi7\daq_5790\Logging.pas',
  SetMinMax in '..\..\daq_5790.delphi7\common\SetMinMax.pas' {SetMinMaxForm},
  DAS_Const in '..\..\daq_5790.delphi7\common\DAS_Const.pas',
  I7000 in '..\..\daq_5790.delphi7\daq_5790\I7000.pas',
  I7000u in '..\..\daq_5790.delphi7\daq_5790\i7000u.pas',
  DCON_PC in '..\..\daq_5790.delphi7\daq_5790\dcon_pc.pas';

{$R *.RES}

begin                             
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TSetMinMaxForm, SetMinMaxForm);
  Application.Run;
end.
