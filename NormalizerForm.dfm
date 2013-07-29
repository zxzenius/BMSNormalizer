object Form1: TForm1
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'BMSNormalizer 0.3.3'
  ClientHeight = 568
  ClientWidth = 994
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object TagViewGroup: TGroupBox
    Left = 440
    Top = 8
    Width = 440
    Height = 315
    Caption = 'Tag Viewer'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    object ValueListEditor1: TValueListEditor
      Left = 10
      Top = 20
      Width = 420
      Height = 282
      Ctl3D = True
      DefaultColWidth = 200
      DefaultRowHeight = 22
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentCtl3D = False
      ParentFont = False
      Strings.Strings = (
        'PLAYER='
        'GENRE='
        'TITLE='
        'ARTIST='
        'BPM='
        'LEVEL='
        'RANK='
        'TotalNotes='
        'Normalized?='
        'FileInfo=')
      TabOrder = 0
      TitleCaptions.Strings = (
        'INFO'
        'Value')
      OnKeyDown = ValueListEditor1KeyDown
      OnValidate = ValueListEditor1Validate
      ColWidths = (
        81
        333)
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 549
    Width = 994
    Height = 19
    Panels = <
      item
        Alignment = taRightJustify
        Bevel = pbNone
        Text = 'Total:'
        Width = 50
      end
      item
        Width = 50
      end
      item
        Alignment = taRightJustify
        Bevel = pbNone
        Text = 'Selected:'
        Width = 60
      end
      item
        Width = 50
      end
      item
        Width = 400
      end
      item
        Alignment = taRightJustify
        Text = 'BMSNormalizer 0.3 by Zenius@SJTUBBS      '
        Width = 100
      end>
  end
  object ListGroup: TGroupBox
    Left = 8
    Top = 8
    Width = 420
    Height = 454
    Caption = 'File List'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object ListView1: TListView
      Left = 22
      Top = 49
      Width = 383
      Height = 341
      Columns = <
        item
          AutoSize = True
          Caption = 'FileName'
        end
        item
        end>
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      FullDrag = True
      GridLines = True
      HideSelection = False
      MultiSelect = True
      ReadOnly = True
      RowSelect = True
      ParentFont = False
      PopupMenu = PopupMenu1
      TabOrder = 0
      ViewStyle = vsReport
      OnColumnClick = ListView1ColumnClick
      OnCompare = ListView1Compare
      OnKeyDown = ListView1KeyDown
      OnSelectItem = ListView1SelectItem
    end
  end
  object BtnSave: TButton
    Left = 701
    Top = 518
    Width = 70
    Height = 25
    Action = ActionSave
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 9
  end
  object BtnNormalize: TButton
    Left = 298
    Top = 505
    Width = 100
    Height = 35
    Action = ActionNormalAll
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 7
  end
  object BtnStrCode: TButton
    Left = 94
    Top = 505
    Width = 80
    Height = 35
    Action = ActionJPView
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 6
  end
  object BtnReload: TButton
    Left = 620
    Top = 518
    Width = 70
    Height = 25
    Action = ActionReload
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 8
  end
  object BtnSaveAll: TButton
    Left = 782
    Top = 518
    Width = 70
    Height = 25
    Action = ActionSaveAll
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 10
  end
  object BtnListMode: TButton
    Left = 8
    Top = 505
    Width = 80
    Height = 35
    Action = ActionListMode
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 5
  end
  object BGAGroup: TGroupBox
    Left = 440
    Top = 422
    Width = 437
    Height = 90
    Caption = 'BGA Adjustor'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    object LabelBGAPos: TLabel
      Left = 375
      Top = 58
      Width = 28
      Height = 13
      Alignment = taCenter
      AutoSize = False
      Caption = '0/1'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 15
      Top = 58
      Width = 50
      Height = 13
      Caption = 'StartTrack'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 120
      Top = 58
      Width = 37
      Height = 13
      Caption = 'Position'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label4: TLabel
      Left = 15
      Top = 22
      Width = 36
      Height = 13
      Caption = 'BGAFile'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object LabelLayer: TLabel
      Left = 374
      Top = 22
      Width = 31
      Height = 13
      Caption = 'LAYER'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object BGAPosBar: TTrackBar
      Left = 160
      Top = 47
      Width = 200
      Height = 34
      Hint = '111'
      Max = 15
      ParentShowHint = False
      ShowHint = False
      TabOrder = 3
      ThumbLength = 16
      TickMarks = tmBoth
      OnChange = BGAPosBarChange
    end
    object EditBGAFileName: TEdit
      Left = 70
      Top = 20
      Width = 260
      Height = 20
      AutoSize = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 1
      Text = 'BGAFileName'
      OnChange = EditBGAFileNameChange
      OnKeyDown = EditBGAFileNameKeyDown
    end
    object EditBGATrack: TEdit
      Left = 70
      Top = 55
      Width = 26
      Height = 20
      AutoSize = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = []
      MaxLength = 2
      ParentFont = False
      TabOrder = 4
      Text = '0'
      OnExit = EditBGATrackExit
      OnKeyDown = EditBGATrackKeyDown
    end
    object BtnBGAFile: TButton
      Left = 330
      Top = 19
      Width = 25
      Height = 22
      Action = ActionBGAFile
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
    object CheckLayer: TCheckBox
      Left = 410
      Top = 20
      Width = 20
      Height = 20
      Action = ActionLayer
      TabOrder = 2
    end
  end
  object ActionMainMenuBar1: TActionMainMenuBar
    Left = 0
    Top = 0
    Width = 994
    Height = 23
    UseSystemFont = False
    ActionManager = ActionManager1
    Caption = 'ActionMainMenuBar1'
    ColorMap.HighlightColor = 16514043
    ColorMap.BtnSelectedColor = clBtnFace
    ColorMap.UnusedColor = 16514043
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    PersistentHotKeys = True
    Spacing = 0
  end
  object GroupGroup: TGroupBox
    Left = 440
    Top = 327
    Width = 437
    Height = 90
    Caption = 'Group Editor'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    object LabelSPA: TLabel
      Left = 105
      Top = 45
      Width = 25
      Height = 13
      Alignment = taCenter
      AutoSize = False
      Caption = 'SPA'
      Color = clBtnFace
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
    object LabelSPH: TLabel
      Left = 129
      Top = 45
      Width = 25
      Height = 13
      Alignment = taCenter
      AutoSize = False
      Caption = 'SPH'
      Color = clBtnFace
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
    object LabelSPN: TLabel
      Left = 164
      Top = 45
      Width = 25
      Height = 13
      Alignment = taCenter
      AutoSize = False
      Caption = 'SPN'
      Color = clBtnFace
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
    object LabelBGN: TLabel
      Left = 195
      Top = 45
      Width = 25
      Height = 13
      Alignment = taCenter
      AutoSize = False
      Caption = 'BGN'
      Color = clBtnFace
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
    object LabelDPN: TLabel
      Left = 230
      Top = 45
      Width = 25
      Height = 13
      Alignment = taCenter
      AutoSize = False
      Caption = 'DPN'
      Color = clBtnFace
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
    object LabelDPH: TLabel
      Left = 265
      Top = 45
      Width = 25
      Height = 13
      Alignment = taCenter
      AutoSize = False
      Caption = 'DPH'
      Color = clBtnFace
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
    object LabelDPA: TLabel
      Left = 300
      Top = 45
      Width = 25
      Height = 13
      Alignment = taCenter
      AutoSize = False
      Caption = 'DPA'
      Color = clBtnFace
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
    object BaseLabel: TLabel
      Left = 15
      Top = 22
      Width = 39
      Height = 13
      Caption = 'BaseFile'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label5: TLabel
      Left = 15
      Top = 62
      Width = 25
      Height = 13
      Caption = 'Level'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object LabelDPX: TLabel
      Left = 340
      Top = 45
      Width = 25
      Height = 13
      Alignment = taCenter
      AutoSize = False
      Caption = 'DPX'
      Color = clBtnFace
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
    object LabelSPX: TLabel
      Left = 70
      Top = 45
      Width = 25
      Height = 13
      Alignment = taCenter
      AutoSize = False
      Caption = 'SPX'
      Color = clBtnFace
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
    object DropBaseFile: TComboBox
      Left = 70
      Top = 20
      Width = 357
      Height = 21
      Style = csDropDownList
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ItemHeight = 13
      ParentFont = False
      TabOrder = 0
      OnSelect = DropBaseFileSelect
    end
    object EditSPA: TEdit
      Tag = 2
      Left = 109
      Top = 60
      Width = 25
      Height = 20
      Alignment = taCenter
      AutoSize = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = []
      MaxLength = 2
      NumbersOnly = True
      ParentFont = False
      TabOrder = 2
      Text = '12'
      OnExit = LevelEditExit
      OnKeyDown = LevelEditKeyDown
    end
    object EditSPH: TEdit
      Tag = 3
      Left = 140
      Top = 60
      Width = 25
      Height = 20
      Alignment = taCenter
      AutoSize = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = []
      MaxLength = 2
      NumbersOnly = True
      ParentFont = False
      TabOrder = 3
      Text = '12'
      OnExit = LevelEditExit
      OnKeyDown = LevelEditKeyDown
    end
    object EditSPN: TEdit
      Tag = 4
      Left = 175
      Top = 60
      Width = 25
      Height = 20
      Alignment = taCenter
      AutoSize = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = []
      MaxLength = 2
      NumbersOnly = True
      ParentFont = False
      TabOrder = 4
      Text = '12'
      OnExit = LevelEditExit
      OnKeyDown = LevelEditKeyDown
    end
    object EditBGN: TEdit
      Tag = 5
      Left = 210
      Top = 60
      Width = 25
      Height = 20
      Alignment = taCenter
      AutoSize = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = []
      MaxLength = 2
      NumbersOnly = True
      ParentFont = False
      TabOrder = 5
      Text = '12'
      OnExit = LevelEditExit
      OnKeyDown = LevelEditKeyDown
    end
    object EditDPN: TEdit
      Tag = 6
      Left = 245
      Top = 60
      Width = 25
      Height = 20
      Alignment = taCenter
      AutoSize = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = []
      MaxLength = 2
      NumbersOnly = True
      ParentFont = False
      TabOrder = 6
      Text = '12'
      OnExit = LevelEditExit
      OnKeyDown = LevelEditKeyDown
    end
    object EditDPH: TEdit
      Tag = 7
      Left = 280
      Top = 60
      Width = 25
      Height = 20
      Alignment = taCenter
      AutoSize = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = []
      MaxLength = 2
      NumbersOnly = True
      ParentFont = False
      TabOrder = 7
      Text = '12'
      OnExit = LevelEditExit
      OnKeyDown = LevelEditKeyDown
    end
    object EditDPA: TEdit
      Tag = 8
      Left = 315
      Top = 60
      Width = 25
      Height = 20
      Alignment = taCenter
      AutoSize = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = []
      MaxLength = 2
      NumbersOnly = True
      ParentFont = False
      TabOrder = 8
      Text = '12'
      OnExit = LevelEditExit
      OnKeyDown = LevelEditKeyDown
    end
    object EditSPX: TEdit
      Tag = 1
      Left = 70
      Top = 60
      Width = 25
      Height = 20
      Alignment = taCenter
      AutoSize = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = []
      MaxLength = 2
      NumbersOnly = True
      ParentFont = False
      TabOrder = 1
      Text = '12'
      OnExit = LevelEditExit
      OnKeyDown = LevelEditKeyDown
    end
    object EditDPX: TEdit
      Tag = 9
      Left = 350
      Top = 60
      Width = 25
      Height = 20
      Alignment = taCenter
      AutoSize = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = []
      MaxLength = 2
      NumbersOnly = True
      ParentFont = False
      TabOrder = 9
      Text = '12'
      OnExit = LevelEditExit
      OnKeyDown = LevelEditKeyDown
    end
  end
  object OpenBGA: TOpenDialog
    Filter = 'BGAfile (*.avi, *.mpg)|*.avi;*.mpg'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 897
    Top = 279
  end
  object PopupMenu1: TPopupMenu
    Left = 892
    Top = 201
    object RemoveSelection1: TMenuItem
      Action = ActionRemSel
    end
    object RemoveAll1: TMenuItem
      Action = ActionRemAll
    end
    object Save1: TMenuItem
      Action = ActionSave
    end
  end
  object ActionManager1: TActionManager
    ActionBars = <
      item
        Items = <
          item
            Items = <
              item
                Action = ActionAddFolder
                Caption = '&Add Folder'
              end
              item
                Action = ActionRecover
                Caption = '&Recover'
              end
              item
                Caption = '-'
              end
              item
                Action = ActionReload
                Caption = 'R&eload'
              end
              item
                Action = ActionSave
                Caption = '&Save'
              end
              item
                Action = ActionSaveAll
                Caption = 'Sa&ve All'
              end>
            Caption = '&File'
          end
          item
            Items = <
              item
                Action = ActionSelAll
                Caption = '&Select All'
                ShortCut = 16449
              end
              item
                Action = ActionSelNone
                Caption = 'S&elect None'
              end
              item
                Action = ActionInvSel
                Caption = '&Invert Selection'
              end
              item
                Caption = '-'
              end
              item
                Action = ActionRemSel
                Caption = '&Remove Selection'
              end
              item
                Action = ActionRemAll
                Caption = 'Re&move All'
              end>
            Caption = '&Edit'
          end
          item
            Items = <
              item
                Action = ActionJPView
                Caption = '&JP View'
                ShortCut = 16458
              end
              item
                Action = ActionListMode
                Caption = '&List Mode'
                ShortCut = 16460
              end>
            Caption = '&View'
          end
          item
            Items = <
              item
                Action = ActionNormalAll
                Caption = '&Normalize'
              end
              item
                Caption = '-'
              end
              item
                Items = <
                  item
                    Action = ActionNoteNormal
                    Caption = '&Notes'
                  end
                  item
                    Items = <
                      item
                        Action = ActionMeasure16
                        Caption = '&16'
                      end
                      item
                        Action = ActionMeasure32
                        Caption = '&32'
                      end
                      item
                        Action = ActionMeasure48
                        Caption = '&48'
                      end>
                    Caption = 'Note/Be&at'
                    UsageCount = 1
                  end
                  item
                    Caption = '-'
                  end
                  item
                    Action = ActionReTitle
                    Caption = '&TITLE'
                  end
                  item
                    Action = ActionBPMTrim
                    Caption = '&BPM'
                  end
                  item
                    Action = ActionTotalCal
                    Caption = 'T&OTAL'
                  end
                  item
                    Action = ActionLR2Tag
                    Caption = '&DIFFICULTY'
                  end
                  item
                    Action = ActionGenBackup
                    Caption = 'On&e Backup'
                  end>
                Caption = '&Options'
                UsageCount = 1
              end>
            Caption = '&Normalize'
          end>
        ActionBar = ActionMainMenuBar1
      end>
    Left = 894
    Top = 237
    StyleName = 'Platform Default'
    object ActionAddFolder: TAction
      Category = 'File'
      Caption = 'Add Folder'
      OnExecute = ActionAddFolderExecute
    end
    object ActionAddFiles: TAction
      Caption = 'Add Files'
    end
    object ActionRecover: TAction
      Category = 'File'
      Caption = 'Recover'
      OnExecute = ActionRecoverExecute
    end
    object ActionReload: TAction
      Category = 'File'
      Caption = 'Reload'
      OnExecute = ActionReloadExecute
      OnUpdate = ActionReloadUpdate
    end
    object ActionSave: TAction
      Category = 'File'
      Caption = 'Save'
      OnExecute = ActionSaveExecute
      OnUpdate = ActionSaveUpdate
    end
    object ActionSaveAll: TAction
      Category = 'File'
      Caption = 'Save All'
      OnExecute = ActionSaveAllExecute
      OnUpdate = ActionSaveAllUpdate
    end
    object ActionSelAll: TAction
      Category = 'Edit'
      Caption = 'Select All'
      ShortCut = 16449
      OnExecute = ActionSelAllExecute
      OnUpdate = ActionSelAllUpdate
    end
    object ActionSelNone: TAction
      Category = 'Edit'
      Caption = 'Select None'
      OnExecute = ActionSelNoneExecute
      OnUpdate = ActionSelNoneUpdate
    end
    object ActionInvSel: TAction
      Category = 'Edit'
      Caption = 'Invert Selection'
      OnExecute = ActionInvSelExecute
      OnUpdate = ActionInvSelUpdate
    end
    object ActionRemSel: TAction
      Category = 'Edit'
      Caption = 'Remove Selection'
      OnExecute = ActionRemSelExecute
      OnUpdate = ActionRemSelUpdate
    end
    object ActionRemAll: TAction
      Category = 'Edit'
      Caption = 'Remove All'
      OnExecute = ActionRemAllExecute
      OnUpdate = ActionRemAllUpdate
    end
    object ActionNormalAll: TAction
      Category = 'Normalize'
      Caption = 'Normalize'
      Hint = 'Normalize all files'
      OnExecute = ActionNormalAllExecute
      OnUpdate = ActionNormalAllUpdate
    end
    object ActionJPView: TAction
      Category = 'View'
      Caption = 'JP View'
      Hint = 'Switch CodePage'
      ShortCut = 16458
      OnExecute = ActionJPViewExecute
      OnUpdate = ActionJPViewUpdate
    end
    object ActionListMode: TAction
      Category = 'View'
      Caption = 'List Mode'
      Hint = 'Switch list mode'
      ShortCut = 16460
      OnExecute = ActionListModeExecute
      OnUpdate = ActionListModeUpdate
    end
    object ActionBGAFile: TAction
      Caption = '...'
      OnExecute = ActionBGAFileExecute
    end
    object ActionReTitle: TAction
      Category = 'Options'
      Caption = 'TITLE'
      Checked = True
      OnExecute = ActionReTitleExecute
      OnUpdate = ActionReTitleUpdate
    end
    object ActionBPMTrim: TAction
      Category = 'Options'
      Caption = 'BPM'
      Checked = True
      OnExecute = ActionBPMTrimExecute
      OnUpdate = ActionBPMTrimUpdate
    end
    object ActionTotalCal: TAction
      Category = 'Options'
      Caption = 'TOTAL'
      Checked = True
      OnExecute = ActionTotalCalExecute
      OnUpdate = ActionTotalCalUpdate
    end
    object ActionLR2Tag: TAction
      Category = 'Options'
      Caption = 'DIFFICULTY'
      Checked = True
      OnExecute = ActionLR2TagExecute
      OnUpdate = ActionLR2TagUpdate
    end
    object ActionNoteNormal: TAction
      Category = 'Options'
      Caption = 'Notes'
      Checked = True
      OnExecute = ActionNoteNormalExecute
      OnUpdate = ActionNoteNormalUpdate
    end
    object ActionGenBackup: TAction
      Category = 'Options'
      Caption = 'One Backup'
      Checked = True
      OnExecute = ActionGenBackupExecute
      OnUpdate = ActionGenBackupUpdate
    end
    object ActionMeasure16: TAction
      Category = 'Notes/Beat'
      Caption = '16'
      GroupIndex = 1
      OnExecute = ActionMeasure16Execute
    end
    object ActionMeasure32: TAction
      Category = 'Notes/Beat'
      Caption = '32'
      Checked = True
      GroupIndex = 1
      OnExecute = ActionMeasure32Execute
    end
    object ActionMeasure48: TAction
      Category = 'Notes/Beat'
      Caption = '48'
      GroupIndex = 1
      OnExecute = ActionMeasure48Execute
    end
    object ActionLayer: TAction
      OnExecute = ActionLayerExecute
      OnUpdate = ActionLayerUpdate
    end
  end
end
