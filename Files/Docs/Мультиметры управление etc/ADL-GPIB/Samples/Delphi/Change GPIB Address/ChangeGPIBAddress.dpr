program ChangeGPIBAddress;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  gpib_user in '..\..\..\Include\Delphi\gpib_user.pas',
  Adgpib in '..\..\..\Include\Delphi\Adgpib.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
