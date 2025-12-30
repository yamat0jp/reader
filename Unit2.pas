unit Unit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Winapi.WebView2, Winapi.ActiveX,
  Vcl.Menus, Vcl.AppEvnts, Vcl.OleCtrls, SHDocVw, IdBaseComponent,
  IdComponent, IdCustomTCPServer, IdCustomHTTPServer, IdHTTPServer, IdContext,
  Vcl.DdeMan, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Edge, DragDrop, DropTarget,
  DragDropGraphics, DragDropFile;

type
  TNaviMode = (nmOpen, nmTop, nmMove);

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
    EdgeBrowser1: TEdgeBrowser;
    DropFileTarget1: TDropFileTarget;
    procedure File2Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure Version1Click(Sender: TObject);
    procedure EdgeBrowser1NewWindowRequested(Sender: TCustomEdgeBrowser;
      Args: TNewWindowRequestedEventArgs);
    procedure open1Click(Sender: TObject);
    procedure DdeClientConv1Open(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure EdgeBrowser1NavigationCompleted(Sender: TCustomEdgeBrowser;
      IsSuccess: Boolean; WebErrorStatus: COREWEBVIEW2_WEB_ERROR_STATUS);
    procedure FormDestroy(Sender: TObject);
    procedure EdgeBrowser1WebMessageReceived(Sender: TCustomEdgeBrowser;
      Args: TWebMessageReceivedEventArgs);
    procedure DropFileTarget1DragOver(Sender: TObject; ShiftState: TShiftState;
      APoint: TPoint; var Effect: LongInt);
    procedure DropFileTarget1Drop(Sender: TObject; ShiftState: TShiftState;
      APoint: TPoint; var Effect: LongInt);
  private
    { Private 宣言 }
    name: string;
    procedure StartPosition;
    procedure Title(const FileName: string);
    function MakeURL(const FileName: string): string;
    procedure LinkAndNavi(mode: TNaviMode);
  public
    { Public 宣言 }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

uses Winapi.ShellAPI, System.Generics.Collections, System.IOUtils,
  System.AnsiStrings, about, System.NetEncoding, System.JSON;

const
  OPEN = 0;
  SILENT = 1;
  DISPLAY = 2;
  NONE = 4;

  url = 'http://localhost:5050/index.html';

procedure TForm2.LinkAndNavi(mode: TNaviMode);
var
  s: string;
  data: PAnsiChar;
begin
  case mode of
    nmOpen:
      EdgeBrowser1.Tag := OPEN;
    nmTop:
      EdgeBrowser1.Tag := DISPLAY;
    nmMove:
      begin
        EdgeBrowser1.Tag := SILENT;
        s := ExtractFilePath(Application.ExeName) + 'bibi-bookshelf\temp.epub';
        CopyFile(PChar(name), PChar(s), false);
      end;
  end;
  data := DdeClientConv1.RequestData('DdeServerItem1');
  try
    if 'open'#13#10 = data then
      DdeClientConv1Open(nil)
    else
    begin
      Panel1.Show;
      Application.ProcessMessages;
      DdeClientConv1.SetLink('ReaderServer', 'server');
    end;
  finally
    System.AnsiStrings.StrDispose(data);
  end;
end;

procedure TForm2.DdeClientConv1Open(Sender: TObject);
begin
  Panel1.Hide;
  case EdgeBrowser1.Tag of
    SILENT:
      begin
        EdgeBrowser1.Tag := DISPLAY;
        EdgeBrowser1.Navigate(url + '?book=/bibi-bookshelf/temp.epub');
      end;
    OPEN, DISPLAY:
      EdgeBrowser1.Navigate(url);
  end;
end;

procedure TForm2.DropFileTarget1DragOver(Sender: TObject;
  ShiftState: TShiftState; APoint: TPoint; var Effect: LongInt);
var
  ext: string;
begin
  if DropFileTarget1.Files.Count > 0 then
  begin
    ext := ExtractFileExt(DropFileTarget1.Files[0]).ToLower;
    if ext = '.epub' then
      Effect := DROPEFFECT_MOVE;
  end;
end;

procedure TForm2.DropFileTarget1Drop(Sender: TObject; ShiftState: TShiftState;
  APoint: TPoint; var Effect: LongInt);
begin
  if DropFileTarget1.Files.Count > 0 then
    caption := ExtractFileName(DropFileTarget1.Files[0]);
end;

procedure TForm2.EdgeBrowser1NavigationCompleted(Sender: TCustomEdgeBrowser;
  IsSuccess: Boolean; WebErrorStatus: COREWEBVIEW2_WEB_ERROR_STATUS);
begin
  if not EdgeBrowser1.WebMessageEnabled then
    EdgeBrowser1.WebMessageEnabled := true;
  if IsSuccess then
    case Sender.Tag of
      OPEN:
        begin
          Sender.ExecuteScript
            ('document.querySelector("input[type=''file'']").click();');
          Title('??? ???');
        end;
      SILENT:
        EdgeBrowser1.Navigate(name);
    end;
end;

procedure TForm2.EdgeBrowser1NewWindowRequested(Sender: TCustomEdgeBrowser;
  Args: TNewWindowRequestedEventArgs);
begin
  Args.ArgsInterface.Set_Handled(1);
  Sender.Tag:=SILENT;
  DdeClientConv1Open(nil);
//  Args.ArgsInterface.Set_NewWindow(Sender.DefaultInterface);
end;

procedure TForm2.EdgeBrowser1WebMessageReceived(Sender: TCustomEdgeBrowser;
  Args: TWebMessageReceivedEventArgs);
var
  JSON, FileName: string;
  LJSONObject: TJSONObject;
begin
  // JSON := Args;
  LJSONObject := TJSONObject.ParseJSONValue(JSON) as TJSONObject;
  try
    if LJSONObject.GetValue('type').Value = 'BookLoaded' then
    begin
      FileName := LJSONObject.GetValue('filename').Value;
      ShowMessage('EPUB ファイル名: ' + FileName);
      // ここで保存・処理など自由に
    end;
  finally
    LJSONObject.Free;
  end;
end;

procedure TForm2.File2Click(Sender: TObject);
begin
  LinkAndNavi(nmTop);
  Title('no title');
end;

procedure TForm2.FormCreate(Sender: TObject);
var
  data: PAnsiChar;
  mode: TNaviMode;
begin
  if ParamStr(1) = '' then
  begin
    name := '';
    mode := nmTop;
    Title('no title');
  end
  else
  begin
    mode := nmMove;
    name := ParamStr(1);
    Title(ExtractFileName(ParamStr(1)));
  end;
  LinkAndNavi(mode);
  data := DdeClientConv1.RequestData('LeftTop');
  try
    DdeClientItem1.Lines.Text := String(data);
  finally
    System.AnsiStrings.StrDispose(data);
  end;
  if DdeClientItem1.Lines.Count > 0 then
  begin
    Left := DdeClientItem1.Lines.Values['Left'].ToInteger;
    Top := DdeClientItem1.Lines.Values['Top'].ToInteger;
    DdeClientItem1.Lines.Clear;
  end;
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
  LinkAndNavi(nmOpen);
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
  caption := '[epub reader] -- ' + FileName;
end;

procedure TForm2.Version1Click(Sender: TObject);
begin
  AboutBox.ShowModal;
end;

end.
