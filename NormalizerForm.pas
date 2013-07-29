unit NormalizerForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, ValEdit, StdCtrls, ComCtrls, MGfile, DataTypeUnit, Buttons,
  PlatformDefaultStyleActnCtrls, ActnList, ActnMan, FunctionUnit, Math,
  InfoForm, FileCtrl, Menus, ToolWin, ActnCtrls, ActnMenus, shellapi;

type
  TForm1 = class(TForm)
    ListGroup: TGroupBox;
    BtnSave: TButton;
    StatusBar1: TStatusBar;
    BtnNormalize: TButton;
    BtnStrCode: TButton;
    BtnReload: TButton;
    BtnSaveAll: TButton;
    ListView1: TListView;
    BtnListMode: TButton;
    BGAGroup: TGroupBox;
    EditBGAFileName: TEdit;
    BGAPosBar: TTrackBar;
    EditBGATrack: TEdit;
    BtnBGAFile: TButton;
    LabelBGAPos: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    OpenBGA: TOpenDialog;
    TagViewGroup: TGroupBox;
    ValueListEditor1: TValueListEditor;
    PopupMenu1: TPopupMenu;
    RemoveSelection1: TMenuItem;
    RemoveAll1: TMenuItem;
    Save1: TMenuItem;
    ActionMainMenuBar1: TActionMainMenuBar;
    ActionManager1: TActionManager;
    ActionAddFolder: TAction;
    ActionAddFiles: TAction;
    ActionReload: TAction;
    ActionSave: TAction;
    ActionSaveAll: TAction;
    ActionSelAll: TAction;
    ActionSelNone: TAction;
    ActionInvSel: TAction;
    ActionRemSel: TAction;
    ActionRemAll: TAction;
    ActionNormalAll: TAction;
    ActionJPView: TAction;
    ActionListMode: TAction;
    ActionBGAFile: TAction;
    ActionRecover: TAction;
    ActionNoteNormal: TAction;
    ActionBPMTrim: TAction;
    ActionTotalCal: TAction;
    ActionLR2Tag: TAction;
    ActionGenBackup: TAction;
    ActionReTitle: TAction;
    ActionMeasure16: TAction;
    ActionMeasure32: TAction;
    ActionMeasure48: TAction;
    GroupGroup: TGroupBox;
    LabelSPA: TLabel;
    LabelSPH: TLabel;
    LabelSPN: TLabel;
    LabelBGN: TLabel;
    LabelDPN: TLabel;
    LabelDPH: TLabel;
    LabelDPA: TLabel;
    BaseLabel: TLabel;
    Label5: TLabel;
    DropBaseFile: TComboBox;
    EditSPA: TEdit;
    EditSPH: TEdit;
    EditSPN: TEdit;
    EditBGN: TEdit;
    EditDPN: TEdit;
    EditDPH: TEdit;
    EditDPA: TEdit;
    EditSPX: TEdit;
    LabelDPX: TLabel;
    EditDPX: TEdit;
    LabelSPX: TLabel;
    CheckLayer: TCheckBox;
    ActionLayer: TAction;
    LabelLayer: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ValueListEditor1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure ValueListEditor1Validate(Sender: TObject; ACol, ARow: Integer;
      const KeyName, KeyValue: string);
    procedure ActionAddFolderExecute(Sender: TObject);
    procedure ListView1ColumnClick(Sender: TObject; Column: TListColumn);
    procedure ListView1Compare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure ListView1SelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure ActionJPViewExecute(Sender: TObject);
    procedure ActionSelAllExecute(Sender: TObject);
    procedure ActionSelNoneExecute(Sender: TObject);
    procedure ActionInvSelExecute(Sender: TObject);
    procedure ActionRemAllExecute(Sender: TObject);
    procedure ActionRemSelExecute(Sender: TObject);
    procedure DropBaseFileSelect(Sender: TObject);
    procedure ActionListModeExecute(Sender: TObject);
    procedure ListView1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ActionBGAFileExecute(Sender: TObject);
    procedure BGAPosBarChange(Sender: TObject);
    procedure EditBGATrackKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure LevelEditExit(Sender: TObject);
    procedure EditBGAFileNameChange(Sender: TObject);
    procedure EditBGAFileNameKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditBGATrackExit(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure ActionSaveExecute(Sender: TObject);
    procedure ActionSaveAllExecute(Sender: TObject);
    procedure ActionNormalAllExecute(Sender: TObject);
    procedure ActionReloadExecute(Sender: TObject);
    procedure ActionSaveAllUpdate(Sender: TObject);
    procedure ActionSaveUpdate(Sender: TObject);
    procedure ActionSelAllUpdate(Sender: TObject);
    procedure ActionSelNoneUpdate(Sender: TObject);
    procedure ActionInvSelUpdate(Sender: TObject);
    procedure ActionRemSelUpdate(Sender: TObject);
    procedure ActionRemAllUpdate(Sender: TObject);
    procedure ActionNormalAllUpdate(Sender: TObject);
    procedure ActionReloadUpdate(Sender: TObject);
    procedure ActionListModeUpdate(Sender: TObject);
    procedure ActionBPMTrimExecute(Sender: TObject);
    procedure ActionTotalCalExecute(Sender: TObject);
    procedure ActionLR2TagExecute(Sender: TObject);
    procedure ActionReTitleExecute(Sender: TObject);
    procedure ActionGenBackupExecute(Sender: TObject);
    procedure ActionNoteNormalExecute(Sender: TObject);
    procedure ActionRecoverExecute(Sender: TObject);
    procedure ActionMeasure16Execute(Sender: TObject);
    procedure ActionMeasure32Execute(Sender: TObject);
    procedure ActionMeasure48Execute(Sender: TObject);
    procedure ActionJPViewUpdate(Sender: TObject);
    procedure LevelEditKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ActionBPMTrimUpdate(Sender: TObject);
    procedure ActionTotalCalUpdate(Sender: TObject);
    procedure ActionReTitleUpdate(Sender: TObject);
    procedure ActionLR2TagUpdate(Sender: TObject);
    procedure ActionGenBackupUpdate(Sender: TObject);
    procedure ActionNoteNormalUpdate(Sender: TObject);
    procedure ActionLayerUpdate(Sender: TObject);
    procedure ActionLayerExecute(Sender: TObject);
  private
    FileList: TStringList;
    FolderList: TStringList;
    GroupArray: TGroupArray;
    BMSList: TList;
    LvEditList: TList;
    LvLabelList: TList;
    ResultList: TStringList;
    SortFlag: integer;
    FirstFlag: boolean;
    JPMode: boolean;
    GroupViewMode: boolean;  //false: SingleFile Mode   true: Group Mode
    BlackScoreMode: boolean;
    PastScoreMode: boolean;
    ShowInfoFinished: boolean;
    ListCanSelected: boolean;
    NullInfo: boolean;
    GenBackup: boolean;
    ReTitle, BPMTrim, TotalCal, LR2Tag, NoteNormal: boolean;
    Measure: integer;
    CurrCol: integer;
    CurrFileIndex: integer;
    CurrGroupIndex: integer;
    ChangedCounter: integer;
    TaskCounter: integer;
    TaskArray: TIntArray;
    BaseFileArray: TIntArray;
    debugv1: integer;
    VersionString: string;

    //procedure ShowLvGroup
    procedure MakeChangedMark(FileIndex: integer; MarkFlag: boolean);
    procedure ShowInfo(FileIndex: integer);
    procedure ShowListCount;
    procedure ShowSelCount;
    procedure ShowDoneInfo(SourceCounter: integer; const TaskStr: string);
    procedure UpdateMode;
    procedure UpdateList;
    procedure UpdateBlackScore;
    procedure UpdateHint(const HintStr: string);
    procedure GetSelected(var SelArray: TIntArray);
    procedure SearchFolder(FolderNameList: TStrings);
    procedure SearchDone(Sender: TObject);
    procedure SaveDone(Sender: TObject);
    procedure LoadInfoDone(Sender: TObject);
    procedure NormalizeDone(Sender: TObject);
    procedure RecoverDone(Sender: TObject);
    procedure ShowGroup(GroupIndex: Integer);
    procedure FillLevelGroup(Index: integer; Level: integer);
    procedure RefreshListItem(ListIndex, GroupIndex: integer);
    procedure LevelGroupValidate(DiffIndex: integer);
    procedure BGATrackValidate;
    procedure ColAutoSize;
    procedure CountChanged;

    procedure WMdropfiles(var Msg: TMessage); message WM_DROPFILES;

    function ListColIndex(ColTag: integer): integer;
    function ListItemIndex(FileIndex: integer): integer;
    function LevelEdit(DiffIndex: integer): TEdit;

    function GetVersion: string;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation
{$R *.dfm}
uses
  ThreadUnit;

procedure TForm1.SaveDone(Sender: TObject);
var
  i: integer;
begin
  Form1.Enabled:= true;
  Form1.SetFocus;
  Form2.Hide;

  if not GroupViewMode then
    for i:= 0 to High(TaskArray) do
    begin
      if i = TaskCounter then
        break;
      if not TBMSfile(BMSList[TaskArray[i]]).Changed then
        ListView1.Items[ListItemIndex(TaskArray[i])].Caption:= ModifiedMark(false);
    end;
  CountChanged;
  ShowDoneInfo(TaskCounter, 'saved.');
  ShowInfo(CurrFileIndex);
end;

procedure TForm1.SearchDone(Sender: TObject);
begin
  TrimResult(FileList, ResultList);
  ChDir('/');
  with TLoadInfoThread.Create(Form2.SearchProgressLabel, FileList, ResultList,
  BMSList) do
    OnTerminate:= LoadInfoDone;
end;

procedure TForm1.SearchFolder(FolderNameList: TStrings);
begin
  Form2.Show;
  Form1.Enabled:= false;
  with TSearchThread.Create(FolderNameList, Form2.SearchProgressLabel, ResultList) do
    OnTerminate:= SearchDone;
end;

procedure TForm1.ShowInfo(FileIndex: integer);
var
  i: integer;
begin
  ShowInfoFinished:= false;
  CurrFileIndex:= FileIndex;
  if FileIndex = -1 then
  begin
    with ValueListEditor1 do
    begin
      Enabled:= false;
      Font.Color:= clGray;
      for i:= 1 to RowCount - 1 do
        Cells[1, i]:= '';
    end;
    DropBaseFile.Enabled:= false;
    DropBaseFile.Clear;
    for i:= 0 to 8 do
      FillLevelGroup(i, -1);
    EditBGAFileName.Clear;
    EditBGAFileName.Enabled:= false;
    ActionBGAFile.Enabled:= false;
    ActionLayer.Checked:= false;
    exit;
  end;

  with ValueListEditor1 do
  begin
    if not Enabled then
    begin
      Enabled:= true;
      Font.Color:= clWindowText;
    end;
    if not GroupViewMode then
      with TBMSfile(BMSList[FileIndex]) do
      begin
        Values['GENRE']:= JPCode(GENRE, JPMode);
        Values['TITLE']:= JPCode(TITLE, JPMode);
        Values['ARTIST']:= JPCode(ARTIST, JPMode);
        Values['PLAYER']:= TransPLAYER(PLAYER);
        Values['DIFFICULTY']:= TransDIFFICULTY(DIFFICULTY);
        Values['BPM']:= FormatFloat('0.##', BPM);
        Values['LEVEL']:= IntToStr(PLAYLEVEL);
        Values['TOTAL']:= IntToStr(TOTAL);
        Values['RANK']:= TransRANK(RANK);
        Values['Notes']:= IntToStr(TotalNotes);
        Values['FilePath']:= ExtractFilePath(FileName);
      end
    else
      with TBMSfile(BMSList[FileIndex]) do
      begin
        Values['GENRE']:= JPCode(GENRE, JPMode);
        Values['TITLE']:= JPCode(SplitTITLE, JPMode);
        Values['ARTIST']:= JPCode(ARTIST, JPMode);
        Values['BPM']:= FormatFloat('0.##', BPM);
        Values['RANK']:= TransRANK(RANK);
        Values['FilePath']:= ExtractFilePath(FileName);
      end;
  end;

  EditBGAFileName.Enabled:= true;
  ActionBGAFile.Enabled:= true;
  with TBMSfile(BMSList[FileIndex]).BGAdata do
  begin
    EditBGAFileName.Text:= FileName;
    EditBGATrack.Text:= IntToStr(Track);
    BGAPosBar.Position:= TransBGAPos(Position, Denominator, BGAPosBar.Max);
    ActionLayer.Checked:= Layer;
  end;

  ShowInfoFinished:= true;
end;

procedure TForm1.ShowSelCount;
var
  TempVal: integer;
  SelArray: TIntArray;
begin
  TempVal:= ListView1.SelCount;
  if GroupViewMode and (TempVal > 0) then
  begin
    GetSelected(SelArray);
    TempVal:= Length(SelArray);
  end;
  StatusBar1.Panels[3].Text:= IntToStr(TempVal);
end;

procedure TForm1.UpdateBlackScore;
begin
  BlackScoreMode:= not BlackScoreMode;
  ColAutoSize;
  PastScoreMode:= BlackScoreMode;
end;

procedure TForm1.UpdateHint(const HintStr: string);
begin
  Self.StatusBar1.Panels[4].Text:= HintStr;
end;

procedure TForm1.UpdateList;
var
  i: integer;
begin
  if BMSList.Count = 0 then
    exit;

  ListCanSelected:= false;
  ListView1.Clear;
  ListCanSelected:= true;

  ListView1.Items.BeginUpdate;
  if not GroupViewMode then   //single file
  begin
    for i:= 0 to BMSList.Count - 1 do
    begin
      with ListView1.Items.Add do
      begin
        Caption:= ModifiedMark(TBMSfile(BMSList[i]).Changed);
        SubItems.Add(ExtractFileName(TBMSfile(BMSList[i]).FileName));
        SubItems.Add(IntToStr(i));
      end;
    end;
    CurrCol:= FileNameTAG;
  end
  else                                    //group
  begin
    GenGroupArray(BMSList, GroupArray);
    BlackScoreMode:= false;
    for i:= 0 to High(GroupArray) do
    begin
      with ListView1.Items.Add do
      begin
        Caption:= ListIntToLvl(GroupArray[i].SubItem[0], BMSList);      //SX
        SubItems.Add(ListIntToLvl(GroupArray[i].SubItem[1], BMSList));  //SA
        SubItems.Add(ListIntToLvl(GroupArray[i].SubItem[2], BMSList));  //SH
        SubItems.Add(ListIntToLvl(GroupArray[i].SubItem[3], BMSList));  //SN
        SubItems.Add(JPCode(GroupArray[i].Title, JPMode));              //TITLE
        SubItems.Add(ListIntToLvl(GroupArray[i].SubItem[4], BMSList));  //BG
        SubItems.Add(ListIntToLvl(GroupArray[i].SubItem[5], BMSList));  //DN
        SubItems.Add(ListIntToLvl(GroupArray[i].SubItem[6], BMSList));  //DH
        SubItems.Add(ListIntToLvl(GroupArray[i].SubItem[7], BMSList));  //DA
        SubItems.Add(ListIntToLvl(GroupArray[i].SubItem[8], BMSList));  //DX
        SubItems.Add(IntToStr(i));  //9
        if not BlackScoreMode and ((GroupArray[i].SubItem[0] > -1) or
        (GroupArray[i].SubItem[8] > -1)) then
        begin
          BlackScoreMode:= true;
        end;
      end;
    end;
    CurrCol:= TitleTAG;
  end;
  SortFlag:= 1;
  ListView1.AlphaSort;
  ListView1.Items.EndUpdate;
  if PastScoreMode <> BlackScoreMode then
  begin

    PastScoreMode:= BlackScoreMode;
  end;
  ColAutoSize;
  ShowListCount;
  ShowInfo(-1);
end;

procedure TForm1.UpdateMode;
const
  MARKWIDTH: integer = 20;
  LEVELWIDTH: integer = 26;
  DHEIGHT: integer = 30;
  DTOP: integer = 20;
  TempDIST: integer = 38;
var
  i: integer;
  KeyStrings, ColCaptions,
  PickListPlayer, PickListLevel, PickListDifficulty, PickListRank: TStringList;
begin
  KeyStrings:= TStringList.Create;
  ColCaptions:= TStringList.Create;
  PickListPlayer:= TStringList.Create;
  PickListLevel:= TStringList.Create;
  PickListDifficulty:= TStringList.Create;
  PickListRank:= TStringList.Create;
  with PickListRank do
  begin
    Add('EASY');
    Add('NORMAL');
    Add('HARD');
    Add('VERY HARD');
  end;

  ListView1.Columns.BeginUpdate;
  ListView1.Columns.Clear;
  if not GroupViewMode then
//File Mode
  begin
    ListGroup.Caption:= 'File List';

    with ColCaptions do
    begin
      Add('C');
      Add('FileName');
    end;

    with KeyStrings do
    begin
      Add('PLAYER=');
      Add('GENRE=');
      Add('TITLE=');
      Add('ARTIST=');
      Add('DIFFICULTY=');
      Add('BPM=');
      Add('LEVEL=');
      Add('RANK=');
      Add('TOTAL=');
      Add('Notes=');
      Add('FilePath=');
    end;

    with PickListPlayer do
    begin
      Add('1P');
      Add('2P');
      Add('DOUBLE');
    end;

    for i:= 1 to 12 do
      PickListLevel.Add(IntToStr(i));

    with PickListDifficulty do
    begin
      Add('Beginner');
      Add('Normal');
      Add('Hyper');
      Add('Another');
      Add('Black');
    end;

    with ValueListEditor1 do
    begin
      Strings.Assign(KeyStrings);
      ItemProps['Notes'].ReadOnly:= true;
      ItemProps['FilePath'].ReadOnly:= true;
      with ItemProps['PLAYER'] do
      begin
        ReadOnly:= true;
        PickList.Assign(PickListPlayer);
      end;
      with ItemProps['LEVEL'] do
        PickList.Assign(PickListLevel);
      with ItemProps['DIFFICULTY'] do
      begin
        ReadOnly:= true;
        PickList.Assign(PickListDifficulty);
      end;
      with ItemProps['RANK'] do
      begin
        ReadOnly:= true;
        PickList.Assign(PickListRank);
      end;

      //Height:= 279;
      TagViewGroup.Height:= 309;
    end;

    GroupGroup.Visible:= false;
    BGAGroup.Top:= TagViewGroup.Top + TagViewGroup.Height + 10;

    //DropBaseFile.Visible:= false;

  end
  else
//Group Mode
  begin
    ListGroup.Caption:= 'Group List';

    with ColCaptions do
    begin
      Add('SX');
      Add('SA');
      Add('SH');
      Add('SN');
      Add('Title');
      Add('BG');
      Add('DN');
      Add('DH');
      Add('DA');
      Add('DX');
    end;

    with KeyStrings do
    begin
      Add('GENRE=');
      Add('TITLE=');
      Add('ARTIST=');
      Add('BPM=');
      Add('RANK=');
      Add('FilePath=');
    end;

    with ValueListEditor1 do
    begin
      Strings.Assign(KeyStrings);
      ItemProps['FilePath'].ReadOnly:= true;
      with ItemProps['RANK'] do
      begin
        ReadOnly:= true;
        PickList.Assign(PickListRank);
      end;
      TagViewGroup.Height:= 194;
    end;
//GroupGroup Positioning
    DropBaseFile.Items.Clear;
    GroupGroup.Visible:= true;
    GroupGroup.Top:= TagViewGroup.Top + TagViewGroup.Height + 10;

    EditSPX.Left:= DropBaseFile.Left;
    LabelSPX.Left:= EditSPX.Left;
    EditDPX.Left:= DropBaseFile.Left + DropBaseFile.Width - EditDPX.Width;
    LabelDPX.Left:= EditDPX.Left;
    for i:= 1 to 3 do
    begin
      TEdit(LvEditList[i]).Left:= TEdit(LvEditList[i - 1]).Left + TempDIST;
      TLabel(LvLabelList[i]).Left:= TLabel(LvLabelList[i - 1]).Left + TempDIST;
    end;
    for i:= 7 downto 4 do
    begin
      TEdit(LvEditList[i]).Left:= TEdit(LvEditList[i + 1]).Left - TempDIST;
      TLabel(LvLabelList[i]).Left:= TLabel(LvLabelList[i + 1]).Left - TempDIST;
    end;

    BGAGroup.Top:= GroupGroup.Top + GroupGroup.Height + 5;
  end;

  for i:= 0 to ColCaptions.Count - 1 do
  with ListView1.Columns.Add do
  begin
    Caption:= ColCaptions[i];
    Tag:= i;
  end;

  ColAutoSize;
  ListView1.Columns.EndUpdate;

  BtnReload.Top:= BGAGroup.Top + BGAGroup.Height + 20;
  BtnSave.Top:= BtnReload.Top;
  BtnSaveAll.Top:= BtnReload.Top;

  KeyStrings.Free;
  ColCaptions.Free;
  PickListPlayer.Free;
  PickListLevel.Free;
  PickListDifficulty.Free;
  PickListRank.Free;
end;

procedure TForm1.ShowListCount;
begin
  StatusBar1.Panels[1].Text:= IntToStr(FileList.Count);
end;

procedure TForm1.ValueListEditor1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  with ValueListEditor1 do
    if (Key = VK_RETURN) and (Row < RowCount - 1) then
      Row:= Row + 1;

end;

procedure TForm1.ValueListEditor1Validate(Sender: TObject; ACol, ARow: Integer;
  const KeyName, KeyValue: string);
var
  i: integer;
begin
  if not ShowInfoFinished then
    exit;
  with TBMSfile(BMSList[CurrFileIndex]) do
  begin
    if (KeyName = 'PLAYER') and (PLAYER <> TransPLAYER(KeyValue)) then
    begin
      PLAYER:= TransPLAYER(KeyValue);
      MakeChangedMark(CurrFileIndex, true);
      exit;
    end

    else if (KeyName = 'GENRE') and (GENRE <> GBCode(KeyValue, JPMode)) then
    begin
      if not GroupViewMode then
      begin
        GENRE:= GBCode(KeyValue, JPMode);
        MakeChangedMark(CurrFileIndex, true);
        exit;
      end
      else
      begin
        for i:= 0 to High(BaseFileArray) do
        begin
          TBMSfile(BMSList[BaseFileArray[i]]).GENRE:= GBCode(KeyValue, JPMode);
          MakeChangedMark(BaseFileArray[i], true);
        end;
        exit;
      end;
    end

    else if (KeyName = 'TITLE') then
    begin
      if (not GroupViewMode) and (TITLE <> GBCode(KeyValue, JPMode)) then
      begin
        TITLE:= GBCode(KeyValue, JPMode);
        MakeChangedMark(CurrFileIndex, true);
        exit;
      end;

      if (GroupViewMode) and (GroupArray[CurrGroupIndex].Title <> GBCode(KeyValue, JPMode)) then
      begin
        GroupArray[CurrGroupIndex].Title:= GBCode(KeyValue, JPMode);
        ListView1.Items[ListItemIndex(CurrGroupIndex)].SubItems[GDataTitleCOL]:= KeyValue;
        for i:= 0 to High(BaseFileArray) do
        begin
          TBMSfile(BMSList[BaseFileArray[i]]).TITLE:= GBCode(KeyValue, JPMode);
          MakeChangedMark(BaseFileArray[i], true);
        end;
        exit;
      end;
    end

    else if (KeyName = 'ARTIST') and (ARTIST <> GBCode(KeyValue, JPMode)) then
    begin
      if not GroupViewMode then
      begin
        ARTIST:= GBCode(KeyValue, JPMode);
        MakeChangedMark(CurrFileIndex, true);
        exit;
      end
      else
      begin
        for i:= 0 to High(BaseFileArray) do
        begin
          TBMSfile(BMSList[BaseFileArray[i]]).ARTIST:= GBCode(KeyValue, JPMode);
          MakeChangedMark(BaseFileArray[i], true);
        end;
        exit;
      end;
    end

    else if (KeyName = 'DIFFICULTY') and (DIFFICULTY <> TransDIFFICULTY(KeyValue)) then
    begin
      DIFFICULTY:= TransDIFFICULTY(KeyValue);
      MakeChangedMark(CurrFileIndex, true);
    end

    else if (KeyName = 'BPM') and (FormatFloat('0.##', BPM) <> KeyValue) then
    begin
      if not GroupViewMode then
      begin
        BPM:= StrToFloatDef(KeyValue, 130);
        ValuelistEditor1.Values['BPM']:= FormatFloat('0.##', BPM);
        MakeChangedMark(CurrFileIndex, true);
        exit;
      end
      else
      begin
        for i:= 0 to High(BaseFileArray) do
        begin
          TBMSfile(BMSList[BaseFileArray[i]]).BPM:=  StrToFloatDef(KeyValue, 130);
          MakeChangedMark(BaseFileArray[i], true);
        end;
        ValuelistEditor1.Values['BPM']:= FormatFloat('0.##', BPM);
        exit;
      end;
    end

    else if (KeyName = 'LEVEL') and (KeyValue <> IntToStr(PLAYLEVEL)) then
    begin
      PLAYLEVEL:= StrToIntDef(KeyValue, 1);
      MakeChangedMark(CurrFileIndex, true);
      exit;
    end

    else if (KeyName = 'RANK') and (RANK <> TransRANK(KeyValue)) then
    begin
      if not GroupViewMode then
      begin
        RANK:= TransRANK(KeyValue);
        MakeChangedMark(CurrFileIndex, true);
        exit;
      end
      else
      begin
        for i:= 0 to High(BaseFileArray) do
        begin
          TBMSfile(BMSList[BaseFileArray[i]]).RANK:= TransRANK(KeyValue);
          MakeChangedMark(BaseFileArray[i], true);
        end;
        exit;
      end;
    end

    else if (KeyName = 'TOTAL') and (TOTAL <> StrToIntDef(KeyValue, 0)) then
    begin
      TOTAL:= StrToIntDef(KeyValue, 0);
      ValueListEditor1.Values['TOTAL']:= IntToStr(TOTAL);
      MakeChangedMark(CurrFileIndex, true);
    end;

  end;

end;

procedure TForm1.WMdropfiles(var Msg: TMessage);
var
  DragIndex, DragCount: integer;
  DragFileName: array[0..255] of char;
begin
  DragIndex:= -1;
  DragCount:= DragQueryFile(Msg.WParam, DragIndex, DragFileName, 255);
  FolderList.Clear;
  for DragIndex:= 0 to DragCount - 1 do
  begin
    DragQueryFile(Msg.WParam, DragIndex, DragFileName, 255);
    if DirectoryExists(DragFileName) then
      FolderList.Add(Trim(DragFileName));
  end;
  SearchFolder(FolderList);
  DragFinish(Msg.WParam);
end;

procedure TForm1.ActionAddFolderExecute(Sender: TObject);
var
  DirName: string;
begin
  if not SelectDirectory('Select Folder', '\', DirName) then
    exit;
  FolderList.Clear;
  FolderList.Add(DirName);
  SearchFolder(FolderList);
//  Form2.Show;
//  Form1.Enabled:= false;
//  with TSearchThread.Create(DirName, Form2.SearchProgressLabel, ResultList) do
//    OnTerminate:= SearchDone;
end;

procedure TForm1.ActionBGAFileExecute(Sender: TObject);
begin
  if CurrFileIndex = -1 then
    exit;
  with OpenBGA do
  begin
    InitialDir:= ExtractFilePath(TBMSfile(BMSList[CurrFileIndex]).FileName);
    FileName:= '';
    if Execute and BGAFileExt(FileName) and
      FileExists(InitialDir + '\' + ExtractFileName(FileName)) then
      EditBGAFileName.Text:= ExtractFileName(FileName);
  end;
end;

procedure TForm1.ActionBPMTrimExecute(Sender: TObject);
begin
  BPMTrim:= not BPMTrim;
end;

procedure TForm1.ActionBPMTrimUpdate(Sender: TObject);
begin
  ActionBPMTrim.Checked:= BPMTrim;
end;

procedure TForm1.ActionGenBackupExecute(Sender: TObject);
begin
  GenBackup:= not GenBackup;
end;

procedure TForm1.ActionGenBackupUpdate(Sender: TObject);
begin
  ActionGenBackup.Checked:= not GenBackup;
end;

procedure TForm1.ActionInvSelExecute(Sender: TObject);
var
  i: integer;
begin
  with ListView1 do
  begin
    if SelCount = 0 then
    begin
      ActionSelAll.Execute;
      exit;
    end;
    if SelCount = Items.Count then
    begin
      ActionSelNone.Execute;
      exit;
    end;
    for i:= 0 to Items.Count - 1 do
      Items[i].Selected:= not Items[i].Selected;
  end;
end;

procedure TForm1.ActionInvSelUpdate(Sender: TObject);
begin
  with ActionInvSel do
    if ListView1.Items.Count = 0 then
      Enabled:= false
    else
      Enabled:= true;
end;

procedure TForm1.ActionJPViewExecute(Sender: TObject);
var
  i: integer;
begin
  JPMode:= not JPMode;
  if GroupViewMode then
  begin
    ListView1.Items.BeginUpdate;
    for i:= 0 to ListView1.Items.Count - 1 do
      with ListView1.Items[i] do
        SubItems[GDataTitleCOL]:= JPCode(GroupArray[StrToInt(SubItems[GDataIndexCOL])].Title, JPMode);
    ListView1.Items.EndUpdate;
  end;

  ShowInfo(CurrFileIndex);
end;

procedure TForm1.ActionJPViewUpdate(Sender: TObject);
begin
  if JPMode then   //0: normal   1:JP MODE
  begin
    ActionJPView.Caption:= 'NM view';
    ActionJPView.Hint:= 'Back to Normal view';
  end
  else
  begin
    ActionJPView.Caption:= 'JP view';
    ActionJPView.Hint:= 'Activate Japanese Mode';
  end;
end;

procedure TForm1.ActionLayerExecute(Sender: TObject);
var
  i: integer;
begin
  if CurrFileIndex = -1 then
    exit;
  ActionLayer.Checked:= not ActionLayer.Checked;
  if not GroupViewMode then
  begin
    TBMSfile(BMSList[CurrFileIndex]).BGAdata.Layer:= ActionLayer.Checked;
    MakeChangedMark(CurrFileIndex, true);
  end
  else
  begin
    for i:= 0 to High(BaseFileArray) do
    begin
      with TBMSfile(BMSList[BaseFileArray[i]]) do
      begin
        BGAdata.Layer:= ActionLayer.Checked;
      end;
      MakeChangedMark(BaseFileArray[i], true);
    end;
  end;
end;

procedure TForm1.ActionLayerUpdate(Sender: TObject);
begin
  ActionLayer.Enabled:= ActionLayer.Checked;
end;

procedure TForm1.ActionListModeExecute(Sender: TObject);
begin
  GroupViewMode:= not GroupViewMode;
  UpdateMode;
  UpdateList;
  ShowSelCount;
end;

procedure TForm1.ActionListModeUpdate(Sender: TObject);
begin
  with ActionListMode do
    if GroupViewMode then
      Caption:= 'File Mode'
    else
      Caption:= 'Group Mode';
end;

procedure TForm1.ActionLR2TagExecute(Sender: TObject);
begin
  LR2Tag:= not LR2Tag;
end;

procedure TForm1.ActionLR2TagUpdate(Sender: TObject);
begin
  ActionLR2Tag.Checked:= LR2Tag;
end;

procedure TForm1.ActionMeasure16Execute(Sender: TObject);
begin
  Measure:= 16;
end;

procedure TForm1.ActionMeasure32Execute(Sender: TObject);
begin
  Measure:= 32;
end;

procedure TForm1.ActionMeasure48Execute(Sender: TObject);
begin
  Measure:= 48;
end;

procedure TForm1.ActionNormalAllExecute(Sender: TObject);
var
  i, j: integer;
begin
  if BMSList.Count = 0 then
    exit;
  SetLength(TaskArray, BMSList.Count);
  for i:= 0 to High(TaskArray) do
    TaskArray[i]:= i;

  if GroupViewMode then
  begin
    for i:= 0 to High(GroupArray) do
      for j:= 0 to High(GroupArray[i].SubItem) do
        if GroupArray[i].SubItem[j] > -1 then
        begin
          if GroupArray[i].SubItem[j] <> GroupArray[i].BaseIndex then
            TBMSfile(BMSList[GroupArray[i].SubItem[j]]).AssignGroupInfo(TBMSfile(BMSList[GroupArray[i].BaseIndex]));
        end;
  end;

  Form2.Show;
  Form1.Enabled:= false;

  with TNormalizeThread.Create(Form2.SearchProgressLabel, TaskArray, BMSList,
    ReTitle, BPMTrim, TotalCal, LR2Tag, NoteNormal, GenBackup, Measure,
    TaskCounter) do
    OnTerminate:= NormalizeDone;

end;

procedure TForm1.ActionNormalAllUpdate(Sender: TObject);
begin
  with ActionNormalAll do
    if (ListView1.Items.Count <> 0) and
      (NoteNormal or ReTitle or BPMTrim or TotalCal or LR2Tag) then
      Enabled:= true
    else
      Enabled:= false;
end;

procedure TForm1.ActionNoteNormalExecute(Sender: TObject);
begin
  NoteNormal:= not NoteNormal;
end;

procedure TForm1.ActionNoteNormalUpdate(Sender: TObject);
begin
  ActionNoteNormal.Checked:= NoteNormal;
end;

procedure TForm1.ActionRecoverExecute(Sender: TObject);
var
  DirName: string;
begin
  if not SelectDirectory('Select Folder', '\', DirName) then
    exit;
  Form2.Show;
  Form1.Enabled:= false;
  with TRecoverThread.Create(DirName, Form2.SearchProgressLabel, TaskCounter) do
    OnTerminate:= RecoverDone;
end;

procedure TForm1.ActionReloadExecute(Sender: TObject);
var
  i: integer;
begin
  if CurrFileIndex = -1 then
    exit;
  if not GroupViewMode then
  begin
    with TBMSfile(BMSList[CurrFileIndex]) do
    begin
      if not Changed then
        exit;
      ClearInfo;
      LoadInfo(FileList[CurrFileIndex]);
    end;
    MakeChangedMark(CurrFileIndex, false);
    ShowInfo(CurrFileIndex);
  end
  else
  begin
    for i:= 0 to High(BaseFileArray) do
    begin
      with TBMSfile(BMSList[BaseFileArray[i]]) do
      begin
        ClearInfo;
        LoadInfo(FileList[BaseFileArray[i]]);
      end;
      MakeChangedMark(BaseFileArray[i], false);
    end;
    GroupArray[CurrGroupIndex].Title:= TBMSfile(BMSList[BaseFileArray[0]]).SplitTITLE;
    RefreshListItem(ListItemIndex(CurrGroupIndex), CurrGroupIndex);
    ShowGroup(CurrGroupIndex);
  end;

end;

procedure TForm1.ActionReloadUpdate(Sender: TObject);
var
  i: integer;
begin
  if CurrFileIndex > -1 then
  begin
    if not GroupViewMode and (TBMSfile(BMSList[CurrFileIndex]).Changed) then
    begin
      ActionReload.Enabled:= true;
      exit;
    end
    else
    if GroupViewMode then
      for i:= 0 to High(BaseFileArray) do
        if TBMSfile(BMSList[BaseFileArray[i]]).Changed then
        begin
          ActionReload.Enabled:= true;
          exit;
        end;
  end;
  ActionReload.Enabled:= false;
end;

procedure TForm1.ActionRemAllExecute(Sender: TObject);
begin
  ListCanSelected:= false;
  ListView1.Clear;
  ListCanSelected:= true;
  FileList.Clear;
  SetLength(GroupArray, 0);
  ChangedCounter:= 0;
  BMSList.Pack;
  while BMSList.Count > 0 do
    begin
      TBMSfile(BMSList[0]).Free;
      BMSList.Delete(0);
    end;
  ShowListCount;
  ShowSelCount;
  ShowInfo(-1);
end;

procedure TForm1.ActionRemAllUpdate(Sender: TObject);
begin
  with ActionRemAll do
    if (ListView1.Items.Count = 0) then
      Enabled:= false
    else
      Enabled:= true;
end;

procedure TForm1.ActionRemSelExecute(Sender: TObject);
var
  SelArray: TIntArray;
  i, j: integer;
begin
  if (ListView1.Items.Count = 0) or (ListView1.SelCount = 0) then
    exit;
  if ListView1.SelCount = ListView1.Items.Count then
    ActionRemAll.Execute
  else
  begin
    GetSelected(SelArray);
    QuickSort(SelArray, Low(SelArray), High(SelArray));
    for i:= High(SelArray) downto Low(SelArray) do
    begin
      j:= SelArray[i];
      if TBMSfile(BMSList[j]).Changed then
        Dec(ChangedCounter);
      FileList.Delete(j);
      TBMSfile(BMSList[j]).Free;
      BMSList.Delete(j);
    end;
    UpdateList;
    ShowSelCount;
  end;
end;

procedure TForm1.ActionRemSelUpdate(Sender: TObject);
begin
  with ActionRemSel do
    if (ListView1.Items.Count = 0) or (ListView1.SelCount = 0) then
      Enabled:= false
    else
      Enabled:= true;
end;

procedure TForm1.ActionReTitleExecute(Sender: TObject);
begin
  ReTitle:= not ReTitle;
end;

procedure TForm1.ActionReTitleUpdate(Sender: TObject);
begin
  ActionReTitle.Checked:= ReTitle;
end;

procedure TForm1.ActionSaveAllExecute(Sender: TObject);
var
  i, j: integer;
  TempCounter: integer;
begin
  if (ListView1.Items.Count = 0) then
    exit;
  TempCounter:= 0;
  if not GroupViewMode then
  begin
    for i:= 0 to BMSList.Count - 1 do
    begin
      if TBMSfile(BMSList[i]).Changed then
      begin
        SetLength(TaskArray, Length(TaskArray) + 1);
        TaskArray[High(TaskArray)]:= i;
        Inc(TempCounter);
      end;
      if TempCounter = ChangedCounter then
        break;
    end;
  end
  else
  begin
    for i:= 0 to High(GroupArray) do
    begin
      with TBMSfile(BMSList[GroupArray[i].BaseIndex]) do
        TITLE:= SplitTITLE;
      for j:= 0 to High(GroupArray[i].SubItem) do
        if GroupArray[i].SubItem[j] > -1 then
        begin
          SetLength(TaskArray, Length(TaskArray) + 1);
          TaskArray[High(TaskArray)]:= GroupArray[i].SubItem[j];
          if GroupArray[i].SubItem[j] <> GroupArray[i].BaseIndex then
            TBMSfile(BMSList[GroupArray[i].SubItem[j]]).AssignGroupInfo(TBMSfile(BMSList[GroupArray[i].BaseIndex]));
        end;
    end;
  end;

  Form2.Show;
  Form1.Enabled:= false;
  with TSaveThread.Create(Form2.SearchProgressLabel, TaskArray, BMSList,
    GenBackup, TaskCounter) do
    OnTerminate:= SaveDone;
end;

procedure TForm1.ActionSaveAllUpdate(Sender: TObject);
begin
  with ActionSaveAll do
  begin
    if not GroupViewMode then
    begin
      if ChangedCounter = 0 then
        Enabled:= false
      else
        Enabled:= true;
    end
    else
    begin
      if ListView1.Items.Count = 0 then
        Enabled:= false
      else
        Enabled:= true;
    end;
  end;
end;

procedure TForm1.ActionSaveExecute(Sender: TObject);
var
  i: integer;
begin
  if (ListView1.Items.Count = 0) or (CurrFileIndex = -1) then
    exit;
  if not GroupViewMode then
  begin
    SetLength(TaskArray, 1);
    TaskArray[0]:= CurrFileIndex;
  end
  else
  begin
    TaskArray:= copy(BaseFileArray);
    with TBMSfile(BMSList[GroupArray[CurrGroupIndex].BaseIndex]) do
      TITLE:= SplitTITLE;
    for i:= 0 to High(BaseFileArray) do
      if GroupArray[CurrGroupIndex].BaseIndex <> BaseFileArray[i] then
        TBMSfile(BMSList[BaseFileArray[i]]).AssignGroupInfo(TBMSfile(BMSList[GroupArray[CurrGroupIndex].BaseIndex]));
  end;

  Form2.Show;
  Form1.Enabled:= false;

  with TSaveThread.Create(Form2.SearchProgressLabel, TaskArray, BMSList,
    GenBackup, TaskCounter) do
    OnTerminate:= SaveDone;
end;

procedure TForm1.ActionSaveUpdate(Sender: TObject);
begin
  with ActionSave do
    if CurrFileIndex <> -1 then
      Enabled:= true
    else
      Enabled:= false;
end;

procedure TForm1.ActionSelAllExecute(Sender: TObject);
begin
  ListCanSelected:= false;
  ListView1.SelectAll;
  ListCanSelected:= true;
  ShowSelCount;
  ShowInfo(-1);
end;

procedure TForm1.ActionSelAllUpdate(Sender: TObject);
begin
  with ActionSelAll do
    if ListView1.Items.Count = 0 then
      Enabled:= false
    else
      Enabled:= true;
end;

procedure TForm1.ActionSelNoneExecute(Sender: TObject);
begin
  ListCanSelected:= false;
  ListView1.ClearSelection;
  ListCanSelected:= true;
  ShowSelCount;
  ShowInfo(-1);
end;

procedure TForm1.ActionSelNoneUpdate(Sender: TObject);
begin
  with ActionSelNone do
    if ListView1.Items.Count = 0 then
      Enabled:= false
    else
      Enabled:= true;
end;

procedure TForm1.ActionTotalCalExecute(Sender: TObject);
begin
  TotalCal:= not TotalCal;
end;

procedure TForm1.ActionTotalCalUpdate(Sender: TObject);
begin
  ActionTotalCal.Checked:= TotalCal;
end;

procedure TForm1.BGAPosBarChange(Sender: TObject);
var
  i, TempPos, TempBase, TempVal: integer;
begin

  with BGAPosBar do
  begin
    TempVal:= BGAPosDivider(Position, Max);
    TempPos:= Trunc(Position / TempVal);
    TempBase:= Trunc((Max + 1) / TempVal);
  end;
    LabelBGAPos.Caption:= IntToStr(TempPos) + '/' + IntToStr(TempBase);
  if not showinfofinished then
    exit;

  if TransBGAPos(TBMSfile(BMSList[CurrFileIndex]).BGAdata.Position,
    TBMSfile(BMSList[CurrFileIndex]).BGAdata.Denominator, BGAPosBar.Max) <>
    BGAPosBar.Position then
  begin
    if not GroupViewMode then
    begin
      with TBMSfile(BMSList[CurrFileIndex]).BGAdata do
      begin
        BGAoverride:= true;
        Position:= TempPos;
        Denominator:= TempBase;
      end;
      MakeChangedMark(CurrFileIndex, true);
    end
    else
    begin
      for i:= 0 to High(BaseFileArray) do
      begin
        with TBMSfile(BMSList[BaseFileArray[i]]).BGAdata do
        begin
          BGAoverride:= true;
          Position:= TempPos;
          Denominator:= TempBase;
        end;
        MakeChangedMark(BaseFileArray[i], true);
      end;

    end;
  end;

end;

procedure TForm1.BGATrackValidate;
var
  i, TempVal: integer;
begin
  if not ShowInfoFinished then
    exit;
  TempVal:= StrToIntDef(EditBGATrack.Text, 0);
  EditBGATrack.Text:= IntToStr(TempVal);
  if TempVal <> TBMSFile(BMSList[CurrFileIndex]).BGAdata.Track then
  begin
    if not GroupViewMode then
    begin
      with TBMSfile(BMSList[CurrFileIndex]).BGAdata do
      begin
        BGAoverride:= true;
        Track:= TempVal;
      end;
      MakeChangedMark(CurrFileIndex, true);
    end
    else
    begin
      for i:= 0 to High(BaseFileArray) do
      begin
        with TBMSfile(BMSList[BaseFileArray[i]]).BGAdata do
        begin
          BGAoverride:= true;
          Track:= TempVal;
        end;
        MakeChangedMark(BaseFileArray[i], true);
      end;
    end;
  end;

end;

procedure TForm1.ColAutoSize;
const
  MARKWIDTH: integer = 20;
  LEVELWIDTH: integer = 26;
var
  i, TempWidth: integer;
begin
  if not GroupViewMode then
  begin
    TempWidth:= ListView1.ClientWidth - MARKWIDTH;
    for i:= 0 to ListView1.Columns.Count - 1 do
      with ListView1.Columns[i] do
      begin
        if AutoSize then
          AutoSize:= false;
        if Tag = FileNameTAG then
        begin
          MinWidth:= TempWidth;
          MaxWidth:= TempWidth;
          Width:= TempWidth;
        end
        else
        begin
          MinWidth:= MARKWIDTH;
          MaxWidth:= MARKWIDTH;
          Width:= MARKWIDTH;
        end;
      end;
  end
  else
  begin
    if BlackScoreMode then
    begin
      TempWidth:= ListView1.ClientWidth - 9 * LEVELWIDTH;
      EditSPX.Visible:= true;
      LabelSPX.Visible:= true;
      EditDPX.Visible:= true;
      LabelDPX.Visible:= true;
    end
    else
    begin
      TempWidth:= ListView1.ClientWidth - 7 * LEVELWIDTH - 2;
      EditSPX.Visible:= false;
      LabelSPX.Visible:= false;
      EditDPX.Visible:= false;
      LabelDPX.Visible:= false;
    end;
    for i:= 0 to ListView1.Columns.Count -1 do
      with ListView1.Columns[i] do
      begin
        if AutoSize then
          AutoSize:= false;
        if ((Tag = SXTAG) or (Tag = DXTAG)) and not BlackScoreMode then
        begin
          MinWidth:= 1;
          MaxWidth:= 1;
          Width:= 1;
        end
        else
        if Tag = TitleTAG then
        begin
          MinWidth:= TempWidth;
          MaxWidth:= TempWidth;
          Width:= TempWidth;
        end
        else
        begin
          MinWidth:= LEVELWIDTH;
          MaxWidth:= LEVELWIDTH;
          Width:= LEVELWIDTH;
        end;
      end;
  end;
end;

procedure TForm1.CountChanged;
var
  i: integer;
begin
  ChangedCounter:= 0;
  for i:= 0 to BMSList.Count - 1 do
    if TBMSfile(BMSList[i]).Changed then
      Inc(ChangedCounter);
end;

procedure TForm1.DropBaseFileSelect(Sender: TObject);
begin
  GroupArray[CurrGroupIndex].BaseIndex:= BaseFileArray[DropBaseFile.ItemIndex];
  ShowInfo(BaseFileArray[DropBaseFile.ItemIndex]);
end;

procedure TForm1.EditBGAFileNameChange(Sender: TObject);
var
  i: integer;
begin

  if EditBGAFileName.Text = '' then
  begin
    EditBGATrack.Enabled:= false;
    BGAPosBar.Enabled:= false;
    LabelBGAPos.Enabled:= false;
  end
  else
  begin
    EditBGATrack.Enabled:= true;
    BGAPosBar.Enabled:= true;
    LabelBGAPos.Enabled:= true;
  end;
  if not ShowInfoFinished then
    exit;
  if not GroupViewMode then
  begin
    with TBMSfile(BMSList[CurrFileIndex]) do
    begin
      BGAdata.BGAoverride:= true;
      BGAdata.FileName:= EditBGAFileName.Text;
    end;
    MakeChangedMark(CurrFileIndex, true);
  end
  else
  begin
    for i:= 0 to High(BaseFileArray) do
    begin
      with TBMSfile(BMSList[BaseFileArray[i]]) do
      begin
        BGAdata.BGAoverride:= true;
        BGAdata.FileName:= EditBGAFileName.Text;
      end;
      MakeChangedMark(BaseFileArray[i], true);
    end;
  end;
end;

procedure TForm1.EditBGAFileNameKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_DELETE) and (EditBGAFileName.Text <> '') then
    EditBGAFileName.Clear;
end;

procedure TForm1.EditBGATrackExit(Sender: TObject);
begin
  BGATrackValidate;
end;

procedure TForm1.EditBGATrackKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    EditBGATrack.SelectAll;
    BGATrackValidate;
  end;
end;

procedure TForm1.LevelEditExit(Sender: TObject);
begin
  LevelGroupValidate(TEdit(Sender).Tag - 1);
end;

procedure TForm1.LevelEditKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    TEdit(Sender).SelectAll;
    LevelGroupValidate(TEdit(Sender).Tag - 1);
  end;
end;

procedure TForm1.FillLevelGroup(Index, Level: integer);
var
  TempLevel: TEdit;
begin
  TempLevel:= LevelEdit(Index);
  with TempLevel do
    if Level > -1 then
    begin
      Color:= clWindow;
      Enabled:= true;
      Text:= IntToStr(Level);
    end
    else
    begin
      Clear;
      Color:= clBtnFace;
      Enabled:= false;
    end;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ShowInfo(-1);
  ListCanSelected:= false;
  ListView1.Clear;
  ListCanSelected:= true;
  FileList.Free;
  FolderList.Free;
  ResultList.Free;
  BMSList.Pack;
  while BMSList.Count > 0 do
  begin
    TBMSfile(BMSList[0]).Free;
    BMSList.Delete(0);
  end;
  BMSList.Free;
  LvEditList.Free;
  LvLabelList.Free;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FileList:= TStringList.Create;
  FileList.Sorted:= true;
  FolderList:= TStringList.Create;
  FolderList.Sorted:= true;
  ResultList:= TStringList.Create;
  BMSList:= TList.Create;
  FirstFlag:= false;
  GroupViewMode:= true;
  BlackScoreMode:= false;
  PastScoreMode:= false;
  JPMode:= true;
  ShowInfoFinished:= false;
  NullInfo:= true;
  CurrFileIndex:= -1;
  CurrGroupIndex:= -1;
  ChangedCounter:= 0;

  NoteNormal:= true;
  ReTitle:= false;
  BPMTrim:= true;
  LR2Tag:= false;
  GenBackup:= false;
  TotalCal:= true;
  Measure:= 32;

  LvEditList:= TList.Create;
  with LvEditList do
  begin
    Add(EditSPX);
    Add(EditSPA);
    Add(EditSPH);
    Add(EditSPN);
    Add(EditBGN);
    Add(EditDPN);
    Add(EditDPH);
    Add(EditDPA);
    Add(EditDPX);
  end;
  LvLabelList:= TList.Create;
  with LvLabelList do
  begin
    Add(LabelSPX);
    Add(LabelSPA);
    Add(LabelSPH);
    Add(LabelSPN);
    Add(LabelBGN);
    Add(LabelDPN);
    Add(LabelDPH);
    Add(LabelDPA);
    Add(LabelDPX);
  end;

  DragAcceptFiles(Form1.Handle, true);
end;

procedure TForm1.FormResize(Sender: TObject);
begin
  ListGroup.Width:= Trunc(0.5 * Form1.Width) + 30;
  ListGroup.Height:= Form1.Height - 130;
  BtnListMode.Top:= Form1.Height - 95;
  BtnStrCode.Top:= BtnListMode.Top;
  BtnNormalize.Left:= ListGroup.Width + ListGroup.Left - BtnNormalize.Width;
  BtnNormalize.Top:= BtnListMode.Top;

  TagViewGroup.Left:= ListGroup.Left + ListGroup.Width + 10;
  TagViewGroup.Width:= Form1.Width - TagViewGroup.Left - 15;
  GroupGroup.Left:= TagViewGroup.Left;
  BGAGroup.Left:= TagViewGroup.Left;
  BtnSaveAll.Left:= BGAGroup.Left + BGAGroup.Width - BtnSaveAll.Width;
  BtnSave.Left:= BtnSaveAll.Left - BtnSaveAll.Width - 5;
  BtnReload.Left:= BtnSave.Left - BtnSave.Width - 5;

  with ValueListEditor1 do
  begin
    ColWidths[0]:= 75;
    ColWidths[1]:= Width - ColWidths[0];
  end;

  ColAutoSize;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  VersionString:= GetVersion;
  Form1.Caption:= 'BMSNormalizer ' + VersionString;

  TagViewGroup.Top:= 30;

  with ValueListEditor1 do
  begin
    Align:= alClient;
    AlignWithMargins:= true;
    Margins.Top:= 6;
    Margins.Bottom:= 6;
    Margins.Left:= 6;
    Margins.Right:= 6;
  end;

  with ListGroup do
  begin
    Left:= 8;
    Top:= 30;
  end;

  with ListView1 do
  begin
    Align:= alClient;
    AlignWithMargins:= true;
    Margins.Top:= 6;
    Margins.Bottom:= 6;
    Margins.Left:= 6;
    Margins.Right:= 6;
  end;

  ListCanSelected:= true;
  ShowListCount;
  ShowSelCount;

  UpdateMode;
  ShowInfo(CurrFileIndex);


end;

procedure TForm1.GetSelected(var SelArray: TIntArray);
var
  i, j, k: integer;
  TempVal: integer;
begin
  j:= 0;
  if not GroupViewMode then
    for i:= 0 to ListView1.Items.Count - 1 do
    begin
      if ListView1.Items[i].Selected then
      begin
        SetLength(SelArray, Length(SelArray) + 1);
        SelArray[High(SelArray)]:= StrToInt(ListView1.Items[i].SubItems[FDataIndexCOL]);
        inc(j);
      end;
      if j = ListView1.SelCount then
        break;
    end
  else
    for i:= 0 to ListView1.Items.Count - 1 do
    begin
      if ListView1.Items[i].Selected then
      begin
        TempVal:= StrToInt(ListView1.Items[i].SubItems[GDataIndexCOL]);
        for k:= 0 to High(GroupArray[TempVal].SubItem) do
          if (GroupArray[TempVal].SubItem[k]) > -1 then
          begin
            SetLength(SelArray, Length(SelArray) + 1);
            SelArray[High(SelArray)]:= GroupArray[TempVal].SubItem[k];
          end;
        inc(j);
      end;
      if j = ListView1.SelCount then
        break;
    end;

end;


function TForm1.GetVersion: string;
var
  FixedFileInfo : VS_FIXEDFILEINFO;
  InfoSize : DWord;
  VersionInfo : Pointer;
  VersionBuffer : Pointer;
  BufferLen : DWord;
begin
  fillchar(FixedFileInfo, sizeof(VS_FIXEDFILEINFO), 0);
  InfoSize := GetFileVersionInfoSize(PChar(application.ExeName), InfoSize);
  if InfoSize > 0 then
  begin
    GetMem(VersionInfo, InfoSize);
    GetFileVersionInfo(PChar(application.ExeName), 0, InfoSize, VersionInfo);
    VerQueryValue(VersionInfo, '\', VersionBuffer, BufferLen);
    move(VersionBuffer^, FixedFileInfo, sizeof(VS_FIXEDFILEINFO));
    FreeMem(VersionInfo);
//    Result:=Format('%u.%u.%u.%u',
//                       [FixedFileInfo.dwProductVersionMS shr 16,
//                        FixedFileInfo.dwProductVersionMS and $FFFF,
//                        FixedFileInfo.dwProductVersionLS shr 16,
//                        FixedFileInfo.dwProductVersionLS and $FFFF]);
    Result:=Format('%u.%u.%u',
                       [FixedFileInfo.dwProductVersionMS shr 16,
                        FixedFileInfo.dwProductVersionMS and $FFFF,
                        FixedFileInfo.dwProductVersionLS shr 16]);
  end
  else
  begin
    Result:= '';
  end;
end;


procedure TForm1.ShowDoneInfo(SourceCounter: integer; const TaskStr: string);
var
  TempStr: string;
begin
  if SourceCounter > 1 then
    TempStr:= ' files have been '
  else
    TempStr:= ' file has been ';
  StatusBar1.Panels[4].Text:= IntToStr(SourceCounter) + TempStr + TaskStr;
end;

procedure TForm1.ShowGroup(GroupIndex: Integer);
var
  TempVar, i, CurrBaseIndex, TempCounter: integer;
  DropList: TStringList;
begin
  TempCounter:= 0;
  CurrBaseIndex:= 0;
  CurrGroupIndex:= GroupIndex;
  SetLength(BaseFileArray, 0);
  DropList:= TStringList.Create;
  for i:= 0 to High(GroupArray[GroupIndex].SubItem) do
  begin
    TempVar:= GroupArray[GroupIndex].SubItem[i];
    if TempVar > -1 then
    begin
      DropList.Add(ExtractFileName(FileList[TempVar]));
      SetLength(BaseFileArray, Length(BaseFileArray) + 1);
      BaseFileArray[High(BaseFileArray)]:= TempVar;
      FillLevelGroup(i, TBMSFile(BMSList[TempVar]).PLAYLEVEL);
      if TempVar = GroupArray[GroupIndex].BaseIndex then
        CurrBaseIndex:= TempCounter;
      Inc(TempCounter);
    end;
  end;

  with DropBaseFile do
  begin
    Items.Assign(DropList);
    Enabled:= true;
    ItemIndex:= CurrBaseIndex;
  end;

  DropList.Free;
  ShowInfo(GroupArray[GroupIndex].BaseIndex);
end;

function TForm1.LevelEdit(DiffIndex: integer): TEdit;
begin
  Result:= TEdit(LvEditList[DiffIndex]);
end;

procedure TForm1.LevelGroupValidate(DiffIndex: integer);
begin
  if not ShowInfoFinished then
    exit;

  if TBMSfile(BMSList[GroupArray[CurrGroupIndex].SubItem[DiffIndex]]).PLAYLEVEL
    <> StrToInt(LevelEdit(DiffIndex).Text) then
  begin
    TBMSfile(BMSList[GroupArray[CurrGroupIndex].SubItem[DiffIndex]]).PLAYLEVEL:=
      StrToInt(LevelEdit(DiffIndex).Text);

    with ListView1.Items[ListItemIndex(CurrGroupIndex)] do
      case DiffIndex of
        0: Caption:= LevelEdit(DiffIndex).Text;
        1..3: SubItems[DiffIndex - 1]:= LevelEdit(DiffIndex).Text;
        4..8: SubItems[DiffIndex]:= LevelEdit(DiffIndex).Text;
      end;

    MakeChangedMark(GroupArray[CurrGroupIndex].SubItem[DiffIndex], true);
  end;
end;

function TForm1.ListColIndex(ColTag: integer): integer;
var
  i: integer;
begin
  for i:= 0 to ListView1.Columns.Count - 1 do
    if ListView1.Columns[i].Tag = ColTag then
      exit(i);
  exit(-1);
end;

function TForm1.ListItemIndex(FileIndex: integer): integer;
var
  i, TempIndex: integer;
begin
  Result:= -1;
  if not GroupViewMode then
    TempIndex:= FDataIndexCOL
  else
    TempIndex:= GDataIndexCOL;

  for i:= 0 to ListView1.Items.Count - 1 do
    if StrToInt(ListView1.Items[i].SubItems[TempIndex]) = FileIndex then
      exit(i)
end;

procedure TForm1.ListView1ColumnClick(Sender: TObject; Column: TListColumn);
begin
  if CurrCol = Column.Tag then
  begin
    SortFlag:= -SortFlag;
  end
  else
  begin
    SortFlag:= 1;
  end;
  CurrCol:= Column.Tag;
  if GroupViewMode or (CurrCol <> 0) then
    ListView1.AlphaSort;
end;

procedure TForm1.ListView1Compare(Sender: TObject; Item1, Item2: TListItem;
  Data: Integer; var Compare: Integer);
begin
  if not GroupViewMode then
  begin
    if CurrCol = MarkTAG then
      Compare:= SortFlag * CompareText(Item1.Caption, Item2.Caption)
    else
      Compare:= SortFlag * CompareText(Item1.SubItems[CurrCol - 1],
      Item2.SubItems[CurrCol - 1]);
  end
  else
  begin
    if CurrCol = SXTAG then
      Compare:= SortFlag * CompareValue(StrToIntDef(Item1.Caption, 999),
      StrToIntDef(Item2.Caption, 999))
    else
    if CurrCol = TitleTAG then
      Compare:= SortFlag * CompareText(Item1.SubItems[CurrCol - 1],
      Item2.SubItems[CurrCol - 1])
    else
      Compare:= SortFlag * CompareValue(StrToIntDef(Item1.SubItems[CurrCol - 1], 999),
      StrToIntDef(Item2.SubItems[CurrCol - 1], 999));
  end;
end;

procedure TForm1.ListView1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_DELETE then
    ActionRemSel.Execute;
end;

procedure TForm1.ListView1SelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  if not ListCanSelected then
    exit;
  if ListView1.SelCount = 1 then
  begin
    if not GroupViewMode then
      ShowInfo(StrToInt(ListView1.Selected.SubItems[FDataIndexCOL]))
    else
      ShowGroup(StrToInt(ListView1.Selected.SubItems[GDataIndexCOL]));
    NullInfo:= false
  end
  else
  if not NullInfo then
  begin
    ShowInfo(-1);
    NullInfo:= true;
//    form1.Tag:= form1.Tag + 1;

  end;
  ShowSelCount;
end;

procedure TForm1.LoadInfoDone(Sender: TObject);
var
  IncVer: integer;
begin
  Form1.Enabled:= true;
  Form1.SetFocus;
  Form2.Hide;
  IncVer:= ResultList.Count;
//  UpdateMode;
  UpdateList;

  ResultList.Clear;
  ShowSelCount;
  ShowDoneInfo(IncVer, 'added.');
end;

procedure TForm1.MakeChangedMark(FileIndex: integer; MarkFlag: boolean);
begin
  with TBMSfile(BMSList[FileIndex]) do
  begin
    if Changed = MarkFlag then
      exit;
    if MarkFlag then
    begin
      Inc(ChangedCounter);
      Changed:= true;
    end
    else
    begin
      Changed:= false;
      Dec(ChangedCounter);
    end;
  end;

  if not GroupViewMode then
    ListView1.Items[ListItemIndex(FileIndex)].Caption:= ModifiedMark(MarkFlag);

end;

procedure TForm1.NormalizeDone(Sender: TObject);
begin
  Form1.Enabled:= true;
  Form1.SetFocus;
  Form2.Hide;
  CountChanged;
  UpdateList;
  ShowDoneInfo(TaskCounter, 'normalized.');
end;

procedure TForm1.RecoverDone(Sender: TObject);
begin
  Form1.Enabled:= true;
  Form1.SetFocus;
  Form2.Hide;
  ShowDoneInfo(TaskCounter, 'recovered.');
end;

procedure TForm1.RefreshListItem(ListIndex, GroupIndex: integer);
var
  i, j: integer;
begin
  if ListIndex < 0 then
    exit;
  with ListView1.Items[ListIndex] do
  begin
    Caption:= ListIntToLvl(GroupArray[GroupIndex].SubItem[0], BMSList);
    for i:= 1 to 8 do
    begin
      if i < TitleTAG then
        j:= i - 1
      else
        j:= i;
      SubItems[j]:= ListIntToLvl(GroupArray[GroupIndex].SubItem[i], BMSList);
    end;

    SubItems[GDataTitleCOL]:= JPCode(GroupArray[GroupIndex].Title, JPMode);
    SubItems[GDataIndexCOL]:= IntToStr(GroupIndex);  //9
  end;
end;

end.
