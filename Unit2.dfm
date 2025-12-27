object Form2: TForm2
  Left = 817
  Top = 443
  Caption = '[epub reader]'
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
  object StatusBar1: TStatusBar
    Left = 0
    Top = 422
    Width = 624
    Height = 19
    Panels = <>
  end
  object EdgeBrowser1: TEdgeBrowser
    Left = 0
    Top = 0
    Width = 624
    Height = 422
    Align = alClient
    TabOrder = 2
    AllowSingleSignOnUsingOSPrimaryAccount = False
    TargetCompatibleBrowserVersion = '117.0.2045.28'
    UserDataFolder = '%LOCALAPPDATA%\bds.exe.WebView2'
    OnNavigationCompleted = EdgeBrowser1NavigationCompleted
    OnNewWindowRequested = EdgeBrowser1NewWindowRequested
  end
  object Panel1: TPanel
    Left = 224
    Top = 208
    Width = 185
    Height = 41
    Caption = #29694#22312'App'#12469#12540#12496#12540#12434#36215#21205#20013#12391#12377
    TabOrder = 0
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
  object DdeClientConv1: TDdeClientConv
    ServiceApplication = 'ReaderServer'
    OnOpen = DdeClientConv1Open
    Left = 480
    Top = 232
  end
  object DdeClientItem1: TDdeClientItem
    DdeConv = DdeClientConv1
    Left = 360
    Top = 304
  end
  object ApplicationEvents1: TApplicationEvents
    OnMessage = ApplicationEvents1Message
    Left = 104
    Top = 136
  end
end
