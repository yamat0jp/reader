unit Unit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Winapi.WebView2, Winapi.ActiveX,
  Vcl.Edge, Vcl.Menus, Vcl.AppEvnts, Vcl.OleCtrls, SHDocVw, IdBaseComponent,
  IdComponent, IdCustomTCPServer, IdCustomHTTPServer, IdHTTPServer, IdContext,
  Vcl.DdeMan, Vcl.ExtCtrls;

type
  TForm2 = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    File2: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    Help1: TMenuItem;
    Version1: TMenuItem;
    EdgeBrowser1: TEdgeBrowser;
    open1: TMenuItem;
    FileOpenDialog1: TFileOpenDialog;
    DdeClientConv1: TDdeClientConv;
    Panel1: TPanel;
    DdeClientItem1: TDdeClientItem;
    procedure File2Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Version1Click(Sender: TObject);
    procedure EdgeBrowser1NewWindowRequested(Sender: TCustomEdgeBrowser;
      Args: TNewWindowRequestedEventArgs);
    procedure open1Click(Sender: TObject);
    procedure DdeClientConv1Open(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DdeClientItem1Change(Sender: TObject);
  private
    { Private êÈåæ }
    url: string;
  public
    { Public êÈåæ }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

uses Winapi.ShellAPI, System.Generics.Collections, System.IOUtils,
  System.AnsiStrings;

procedure TForm2.DdeClientConv1Open(Sender: TObject);
var
  s: string;
begin
  Panel1.Hide;
  if ParamStr(1) <> '' then
  begin
    s := ExtractFilePath(ParamStr(0)) + 'bibi-bookshelf\temp.epub';
    CopyFile(PChar(ParamStr(1)), PChar(s), false);
    EdgeBrowser1.Navigate(url + '?book=temp.epub');
  end
  else
    File2Click(nil);
end;

procedure TForm2.DdeClientItem1Change(Sender: TObject);
begin
  caption := DdeClientItem1.Text
end;

procedure TForm2.EdgeBrowser1NewWindowRequested(Sender: TCustomEdgeBrowser;
  Args: TNewWindowRequestedEventArgs);
begin
  Args.ArgsInterface.Set_Handled(1);
end;

procedure TForm2.File2Click(Sender: TObject);
var
  data: PAnsiChar;
begin
  data := DdeClientConv1.RequestData('DdeServerItem1');
  if data = 'open'#13#10 then
    EdgeBrowser1.Navigate(url)
  else
  begin
    Panel1.Show;
    Application.ProcessMessages;
    if DdeClientConv1.OpenLink then
      EdgeBrowser1.Navigate(url);
  end;
  System.AnsiStrings.StrDispose(data);
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  url := 'http://localhost:5050/index.html';
  DdeClientConv1.SetLink('ReaderServer', 'server');
end;

procedure TForm2.FormDestroy(Sender: TObject);
begin
  DeleteFile(ExtractFilePath(Application.ExeName) + 'bibi-bookshelf\temp.epub');
end;

procedure TForm2.N2Click(Sender: TObject);
begin
  Close;
end;

procedure TForm2.open1Click(Sender: TObject);
var
  data: PAnsiChar;
begin
  if FileOpenDialog1.Execute then
  begin
    data := DdeClientConv1.RequestData('DdeServerItem1');
    if (data = 'open'#13#10) or DdeClientConv1.OpenLink then
    begin
      CopyFile(PChar(FileOpenDialog1.FileName),
        PChar(ExtractFilePath(Application.ExeName) +
        'bibi-bookshelf\temp.epub'), false);
      EdgeBrowser1.Navigate(url + '?book=temp.epub');
    end;
    System.AnsiStrings.StrDispose(data);
  end;
end;

procedure TForm2.Version1Click(Sender: TObject);
begin
  Showmessage('version 1.1.0');
end;

end.
