object Form2: TForm2
  Left = 817
  Top = 443
  Caption = 'epub reader'
  ClientHeight = 441
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Menu = MainMenu1
  Position = poDesigned
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 15
  object EdgeBrowser1: TEdgeBrowser
    Left = 0
    Top = 0
    Width = 624
    Height = 441
    Align = alClient
    TabOrder = 0
    AllowSingleSignOnUsingOSPrimaryAccount = False
    TargetCompatibleBrowserVersion = '117.0.2045.28'
    UserDataFolder = '%LOCALAPPDATA%\bds.exe.WebView2'
    OnNewWindowRequested = EdgeBrowser1NewWindowRequested
  end
  object Panel1: TPanel
    Left = 224
    Top = 208
    Width = 185
    Height = 41
    Caption = #29694#22312'App'#12469#12540#12496#12540#12434#36215#21205#20013#12391#12377
    TabOrder = 1
  end
  object MainMenu1: TMainMenu
    Left = 272
    Top = 128
    object File1: TMenuItem
      Caption = 'File'
      object File2: TMenuItem
        Caption = 'reset'
        OnClick = File2Click
      end
      object open1: TMenuItem
        Caption = 'open'
        OnClick = open1Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object N2: TMenuItem
        Caption = 'End'
        OnClick = N2Click
      end
    end
    object Help1: TMenuItem
      Caption = 'Help'
      object Version1: TMenuItem
        Caption = 'Version'
        OnClick = Version1Click
      end
    end
  end
  object FileOpenDialog1: TFileOpenDialog
    DefaultExtension = '.epub'
    FavoriteLinks = <>
    FileTypes = <
      item
        DisplayName = 'EPUB FILES'
        FileMask = '*.epub'
      end
      item
        DisplayName = #12377#12409#12390#12398#12501#12449#12452#12523
        FileMask = '*.*'
      end>
    Options = []
    Left = 480
    Top = 128
  end
  object DdeClientConv1: TDdeClientConv
    ServiceApplication = 'ReaderServer'
    OnOpen = DdeClientConv1Open
    Left = 480
    Top = 232
  end
  object DdeClientItem1: TDdeClientItem
    DdeConv = DdeClientConv1
    OnChange = DdeClientItem1Change
    Left = 360
    Top = 304
  end
end
