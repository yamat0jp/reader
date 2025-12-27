program reader;

uses
  Vcl.Forms,
  Unit2 in 'Unit2.pas' {Form2},
  about in 'about.pas' {AboutBox};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.Run;

end.
