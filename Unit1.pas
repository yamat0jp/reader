unit Unit1;

interface

uses
  System.SysUtils, System.Classes, JS, Web, WEBLib.Graphics, WEBLib.Controls,
  WEBLib.Forms, WEBLib.Electron, WEBLib.Dialogs, Vcl.Controls, WEBLib.WebCtrls;

type
  TForm1 = class(TElectronForm)
    WebBrowserControl1: TWebBrowserControl;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

initialization
  RegisterClass(TForm1);

end.