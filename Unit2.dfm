object Form2: TForm2
  Left = 0
  Top = 0
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
    ExplicitLeft = 392
    ExplicitWidth = 232
  end
  object MainMenu1: TMainMenu
    Left = 272
    Top = 128
    object File1: TMenuItem
      Caption = 'File'
      object File2: TMenuItem
        Caption = 'Start'
        OnClick = File2Click
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
  object IdHTTPServer1: TIdHTTPServer
    Active = True
    Bindings = <>
    DefaultPort = 8080
    OnCommandGet = IdHTTPServer1CommandGet
    Left = 368
    Top = 128
  end
end
