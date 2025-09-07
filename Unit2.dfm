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
  object WebBrowser1: TWebBrowser
    Left = 0
    Top = 0
    Width = 624
    Height = 441
    Align = alClient
    TabOrder = 0
    SelectedEngine = EdgeIfAvailable
    OnDownloadBegin = WebBrowser1DownloadBegin
    ControlData = {
      4C0000007E400000942D00000000000000000000000000000000000000000000
      000000004C000000000000000000000001000000E0D057007335CF11AE690800
      2B2E126208000000000000004C0000000114020000000000C000000000000046
      8000000000000000000000000000000000000000000000000000000000000000
      00000000000000000100000000000000000000000000000000000000}
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
      object List1: TMenuItem
        Caption = 'List'
        OnClick = List1Click
      end
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
