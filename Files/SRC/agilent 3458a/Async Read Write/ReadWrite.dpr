program ReadWrite;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  Adgpib in 'Adgpib.pas',
  gpib_user in 'gpib_user.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
