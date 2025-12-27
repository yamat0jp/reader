unit Unit4;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.DdeMan, IdBaseComponent,
  IdComponent, IdCustomTCPServer, IdCustomHTTPServer, IdHTTPServer,
  Vcl.ExtCtrls,
  Vcl.Menus, IdContext;

type
  TForm4 = class(TForm)
    IdHTTPServer1: TIdHTTPServer;
    TrayIcon1: TTrayIcon;
    PopupMenu1: TPopupMenu;
    Reader1: TMenuItem;
    DdeServerItem1: TDdeServerItem;
    LeftTop: TDdeServerItem;
    procedure FormCreate(Sender: TObject);
    procedure IdHTTPServer1CommandGet(AContext: TIdContext;
      ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
    procedure FormDestroy(Sender: TObject);
    procedure Reader1Click(Sender: TObject);
  private
    { Private êÈåæ }
  public
    { Public êÈåæ }
  end;

var
  Form4: TForm4;

implementation

{$R *.dfm}

uses System.Generics.Collections;

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
var
  key: string;
begin
  key := LowerCase(Ext);
  if MimeMap.ContainsKey(key) then
    Result := MimeMap[key]
  else
    Result := 'application/octet-stream';
end;

procedure TForm4.FormCreate(Sender: TObject);
begin
  Application.ShowMainForm := false;
  MimeMap := TDictionary<string, string>.Create;
  InitMimeMap;
end;

procedure TForm4.FormDestroy(Sender: TObject);
begin
  MimeMap.Free;
end;

procedure TForm4.IdHTTPServer1CommandGet(AContext: TIdContext;
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

procedure TForm4.Reader1Click(Sender: TObject);
begin
  Close;
end;

end.
