unit Unit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Winapi.WebView2, Winapi.ActiveX,
  Vcl.Edge, Vcl.Menus, Vcl.AppEvnts, Vcl.OleCtrls, SHDocVw, IdBaseComponent,
  IdComponent, IdCustomTCPServer, IdCustomHTTPServer, IdHTTPServer, IdContext;

type
  TForm2 = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    File2: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    IdHTTPServer1: TIdHTTPServer;
    Help1: TMenuItem;
    Version1: TMenuItem;
    EdgeBrowser1: TEdgeBrowser;
    procedure File2Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure IdHTTPServer1CommandGet(AContext: TIdContext;
      ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
    procedure FormDestroy(Sender: TObject);
    procedure Version1Click(Sender: TObject);
    procedure EdgeBrowser1NewWindowRequested(Sender: TCustomEdgeBrowser;
      Args: TNewWindowRequestedEventArgs);
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

var
  MimeMap: TDictionary<string, string>;

procedure InitMimeMap;
begin
  MimeMap.Add('.html', 'text/html;charset=utf-8');
  MimeMap.Add('.css', 'text/css;charset=utf-8');
  MimeMap.Add('.js', 'application/javascript;charset=utf-8');
  MimeMap.Add('.epub', 'application/epub+zip');
  MimeMap.Add('.png', 'image/png');
  MimeMap.Add('.jpg', 'image/jpeg');
  MimeMap.Add('.jpeg', 'image/jpeg');
  MimeMap.Add('.ico', 'image/x-icon');
end;

function GetMimeType(const Ext: string): string;
begin
  if MimeMap.ContainsKey(Ext) then
    Result := MimeMap[LowerCase(Ext)]
  else
    Result := 'application/octet-stream';
end;

procedure TForm2.EdgeBrowser1NewWindowRequested(Sender: TCustomEdgeBrowser;
  Args: TNewWindowRequestedEventArgs);
begin
  Args.ArgsInterface.Set_Handled(1);
end;

procedure TForm2.File2Click(Sender: TObject);
begin
  EdgeBrowser1.Navigate(url);
end;

procedure TForm2.FormCreate(Sender: TObject);
var
  s: string;
begin
  url := Format('http://localhost:%d/index.html', [IdHTTPServer1.DefaultPort]);
  MimeMap := TDictionary<string, string>.Create;
  InitMimeMap;
  if ParamStr(1) <> '' then
  begin
    s := ExtractFilePath(ParamStr(0)) + 'bibi-bookshelf\temp.epub';
    CopyFile(PChar(ParamStr(1)), PChar(s), false);
    EdgeBrowser1.Navigate(url + '?book=temp.epub');
  end
  else
    File2Click(nil);
end;

procedure TForm2.FormDestroy(Sender: TObject);
begin
  MimeMap.Free;
  DeleteFile(ExtractFilePath(Application.ExeName) + 'bibi-bookshelf\temp.epub');
end;

procedure TForm2.IdHTTPServer1CommandGet(AContext: TIdContext;
  ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
var
  FilePath: string;
  stream: TFileStream;
begin
  FilePath := ExtractFileDir(Application.ExeName) + ARequestInfo.Document;
  FilePath := FilePath.Replace('\', '/', [rfReplaceAll]);
  AResponseInfo.ContentType := GetMimeType(ExtractFileExt(FilePath));
  stream := TFileStream.Create(FilePath, fmOpenRead or fmShareDenyNone);
  try
    AResponseInfo.ContentStream := stream;
    AResponseInfo.FreeContentStream := true;
  except
    stream.Free;
    raise;
  end;
end;

procedure TForm2.N2Click(Sender: TObject);
begin
  Close;
end;

procedure TForm2.Version1Click(Sender: TObject);
begin
  Showmessage('version 1.0.4');
end;

end.
