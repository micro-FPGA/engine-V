program futty;

uses
  Forms,
  Main_Futty in 'Main_Futty.pas' {Form1},
  D2XXUnit in 'D2XXUnit.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'SpiPro';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
