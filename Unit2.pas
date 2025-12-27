unit Unit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Winapi.WebView2, Winapi.ActiveX,
  Vcl.Menus, Vcl.AppEvnts, Vcl.OleCtrls, SHDocVw, IdBaseComponent,
  IdComponent, IdCustomTCPServer, IdCustomHTTPServer, IdHTTPServer, IdContext,
  Vcl.DdeMan, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Edge;

type
  TForm2 = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    File2: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    Help1: TMenuItem;
    Version1: TMenuItem;
    open1: TMenuItem;
    DdeClientConv1: TDdeClientConv;
    Panel1: TPanel;
    StatusBar1: TStatusBar;
    DdeClientItem1: TDdeClientItem;
    ApplicationEvents1: TApplicationEvents;
    EdgeBrowser1: TEdgeBrowser;
    procedure File2Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure Version1Click(Sender: TObject);
    procedure EdgeBrowser1NewWindowRequested(Sender: TCustomEdgeBrowser;
      Args: TNewWindowRequestedEventArgs);
    procedure open1Click(Sender: TObject);
    procedure DdeClientConv1Open(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ApplicationEvents1Message(var Msg: TMsg; var Handled: Boolean);
    procedure EdgeBrowser1NavigationCompleted(Sender: TCustomEdgeBrowser;
      IsSuccess: Boolean; WebErrorStatus: COREWEBVIEW2_WEB_ERROR_STATUS);
    procedure FormDestroy(Sender: TObject);
  private
    { Private êÈåæ }
    name: string;
    procedure StartPosition;
    procedure Title(const FileName: string);
    function MakeURL(const FileName: string): string;
  public
    { Public êÈåæ }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

uses Winapi.ShellAPI, System.Generics.Collections, System.IOUtils,
  System.AnsiStrings, about, System.NetEncoding;

const
  OPEN = 0;
  SILENT = 1;
  DISPLAY = 2;

  url = 'http://localhost:5050/index.html';

procedure TForm2.ApplicationEvents1Message(var Msg: TMsg; var Handled: Boolean);
var
  s: string;
begin
  if Msg.message = WM_DROPFILES then
  begin
    s := Msg.wParam.ToString;
    Title(ExtractFileName(s));
    name := MakeURL(s);
    EdgeBrowser1.Tag := SILENT;
    EdgeBrowser1.Navigate(url);
  end;
end;

procedure TForm2.DdeClientConv1Open(Sender: TObject);
begin
  Panel1.Hide;
  if EdgeBrowser1.Tag = SILENT then
    EdgeBrowser1.Navigate(url + '?book=/bibi-bookshelf/temp.epub')
  else
    EdgeBrowser1.Navigate(url);
end;

procedure TForm2.EdgeBrowser1NavigationCompleted(Sender: TCustomEdgeBrowser;
  IsSuccess: Boolean; WebErrorStatus: COREWEBVIEW2_WEB_ERROR_STATUS);
begin
  if IsSuccess then
    case Sender.Tag of
      OPEN:
        begin
          Sender.ExecuteScript
            ('document.querySelector("input[type=''file'']").click();');
          Title('??? ???');
        end;
      SILENT:
        begin
          Sender.Tag := DISPLAY;
          Sender.Navigate(name);
        end;
    end;
end;

procedure TForm2.EdgeBrowser1NewWindowRequested(Sender: TCustomEdgeBrowser;
  Args: TNewWindowRequestedEventArgs);
begin
  Args.ArgsInterface.Set_Handled(1);
  Args.ArgsInterface.Set_NewWindow(Sender.DefaultInterface);
end;

procedure TForm2.File2Click(Sender: TObject);
var
  data: PAnsiChar;
begin
  EdgeBrowser1.Tag := DISPLAY;
  data := DdeClientConv1.RequestData('DdeServerItem1');
  if data = 'open'#13#10 then
    EdgeBrowser1.Navigate(url)
  else
  begin
    Panel1.Show;
    Application.ProcessMessages;
    DdeClientConv1.OpenLink;
  end;
  System.AnsiStrings.StrDispose(data);
  Title('no title');
end;

procedure TForm2.FormCreate(Sender: TObject);
var
  data: PAnsiChar;
  s: string;
begin
  EdgeBrowser1.Tag := DISPLAY;
  if ParamStr(1) = '' then
  begin
    name := '';
    Title('no title');
  end
  else
  begin
    s := ExtractFilePath(Application.ExeName) + 'bibi-bookshelf\temp.epub';
    CopyFile(PChar(ParamStr(1)), PChar(s), false);
    EdgeBrowser1.Tag := SILENT;
    Title(ExtractFileName(ParamStr(1)));
  end;
  DdeClientConv1.SetLink('ReaderServer', 'server');
  data := DdeClientConv1.RequestData('LeftTop');
  if data <> '' then
  begin
    DdeClientItem1.Lines.Text := String(data);
    Left := DdeClientItem1.Lines.Values['Left'].ToInteger;
    Top := DdeClientItem1.Lines.Values['Top'].ToInteger;
    DdeClientItem1.Lines.Clear;
  end;
  System.AnsiStrings.StrDispose(data);
  StartPosition;
end;

procedure TForm2.FormDestroy(Sender: TObject);
begin
  DeleteFile(ExtractFilePath(Application.ExeName) + 'bibi-bookshelf\temp.epub');
end;

function TForm2.MakeURL(const FileName: string): string;
var
  source: string;
begin
  source := ExtractFilePath(Application.ExeName);
  result := url + '?book=' + TNetEncoding.url.EncodePath
    (ExtractRelativePath(source, FileName).Replace('\', '/'));
end;

procedure TForm2.N2Click(Sender: TObject);
begin
  Close;
end;

procedure TForm2.open1Click(Sender: TObject);
begin
  EdgeBrowser1.Tag := OPEN;
  EdgeBrowser1.Navigate(url);
end;

procedure TForm2.StartPosition;
const
  min_left = 300;
  max_left = 500;
  min_top = 200;
  max_top = 400;
  dx = 40;
  dy = 20;
begin
  if (Left > max_left) or (Top > max_top) then
  begin
    Left := min_left;
    Top := min_top;
  end;
  DdeClientItem1.Lines.Add('Left=' + (Left + dx).ToString);
  DdeClientItem1.Lines.Add('Top=' + (Top + dy).ToString);
  DdeClientConv1.PokeDataLines('LeftTop', DdeClientItem1.Lines);
end;

procedure TForm2.Title(const FileName: string);
begin
  Caption := '[epub reader] -- ' + FileName;
end;

procedure TForm2.Version1Click(Sender: TObject);
begin
  AboutBox.ShowModal;
end;

end.
