program reader;

uses
  Vcl.Forms,
  Vcl.Dialogs,
  Windows,
  Unit2 in 'Unit2.pas' {Form2};

{$R *.res}

var
  MutexHandle: THandle;

begin
  MutexHandle := CreateMutex(nil, True, 'MyUniqueAppMutex');
  if (MutexHandle = 0) or (GetLastError = ERROR_ALREADY_EXISTS) then
  begin
    ShowMessage('‚·‚Å‚É‹N“®‚µ‚Ä‚¢‚Ü‚·');
    Halt;
  end;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm2, Form2);
  Application.Run;

end.
