unit ThreadUnit;

interface

uses
  Classes, SysUtils, StdCtrls, MGfile, DataTypeUnit;

type
  {TaskThread = class(TThread)
  private
    TaskProgressLabel: TLabel;
    CurrInfo: string;
    TaskResultList: TStrings;
    procedure DoTask(TaskList: TStrings); virtual; abstract;
    procedure UpdateInfo;
  public
    constructor Create(ProgressLabel: TLabel; TaskList: TStrings);
  end; }
  TSearchThread = class(TThread)
  private
    SInfoLabel: TLabel;
    CurrInfo: string;
    SFolderList, SResultList: TStrings;
    procedure Dosearch(ResultList: TStrings);
    procedure UpdateInfo;
  protected
    procedure Execute; override;
  public
    constructor Create(FolderList: TStrings; InfoLabel: TLabel; ResultList: TStrings);
  end;

  TNormalizeThread = class(TThread)
  private
    NProgressLabel: TLabel;
    CurrInfo: string;
    BMSList: TList;
    IndexArray: TIntArray;
    NReTitle, NBPMTrim, NTotalCal, NLR2Tag, NNote, NBackup: boolean;
    NMeasure: integer;
    TaskCounter: ^integer;

    procedure DoNormalize(ReTitle, BPMTrim, TotalCal, LR2Tag,
      NoteNormal, GenBackup: boolean; MEASURE: integer);
    procedure UpdateProgress;
  protected
    procedure Execute; override;
  public
    constructor Create(ProgressLabel: TLabel;
      var TaskArray: TIntArray; FileTList: TList;
      ReTitle, BPMTrim, TotalCal, LR2Tag, NoteNormal, GenBackup: boolean;
      MEASURE: integer; var DoneCounter: integer);
  end;

  TLoadInfoThread = class(TThread)
  private
    LProgressLabel: TLabel;
    CurrInfo: string;
    LFileList: TStrings;
    LTaskList: TStrings;
    LFileTList: TList;

    procedure DoTask(FileList: TStrings; TaskList: TStrings; FileTList: TList);
    procedure UpdateProgress;
  protected
    procedure Execute; override;
  public
    constructor Create(ProgressLabel: TLabel; FileList: TStrings;
    TaskList: TStrings; FileTList: TList);
  end;

  TSaveThread = class(TThread)
  private
    SProgressLabel: TLabel;
    CurrInfo: string;
    BMSList: TList;
    IndexArray: TIntArray;
    SBackUp: boolean;
    TaskCounter: ^integer;
    procedure DoSave(GenBackup: boolean);
    procedure UpdateProgress;
  protected
    procedure Execute; override;
  public
    constructor Create(ProgressLabel: TLabel;
      var TaskArray: TIntArray; FileTList: TList; GenBackup: boolean;
      var DoneCounter: integer);
  end;

  TReloadThread = class(TThread)
  private
    RProgressLabel: TLabel;
    CurrInfo: string;
    RFileTList: TList;
    RFileIndexArray: TIntArray;
    procedure DoReload(FileTList: TList);
    procedure UpdateProgress;
  protected
    procedure Execute; override;
  public
    constructor Create(ProgressLabel: TLabel; var FileIndexArray: TIntArray; FileTList: TList);
  end;

  TRecoverThread = class(TThread)
  private
    InfoLabel: TLabel;
    CurrInfo: string;
    DirName: string;
    TaskCounter: ^integer;
    procedure DoRecover;
    procedure UpdateProgress;
  protected
    procedure Execute; override;
  public
    constructor Create(const DirStr: string; ProgressLabel: TLabel; var DoneCounter: integer);
  end;



implementation

uses
  Forms, Windows, StrUtils;

{ Important: Methods and properties of objects in visual components can only be
  used in a method called using Synchronize, for example,

      Synchronize(UpdateCaption);

  and UpdateCaption could look like,

    procedure TSearchThread.UpdateCaption;
    begin
      Form1.Caption := 'Updated in a thread';
    end; }



{ TSearchThread }


constructor TSearchThread.Create(FolderList: TStrings; InfoLabel: TLabel; ResultList: TStrings);
begin
  SFolderList:= FolderList;
  SInfoLabel:= InfoLabel;
  SResultList:= ResultList;
  FreeOnTerminate := True;
  inherited Create(False);
end;

procedure TSearchThread.UpdateInfo;
begin
  SInfoLabel.Caption:= 'Searching:' + CurrInfo;
end;

procedure TSearchThread.Dosearch(ResultList: TStrings);
var
  Sr: TSearchRec;
  Flag: integer;
begin
  Flag:= FindFirst('*.*', faDirectory, Sr);
  while Flag = 0 do
  begin
    if ((Sr.Attr and faDirectory) <> 0) and (Sr.Name <> '.') and (Sr.Name <> '..') then
    begin
      ChDir(Sr.Name);
      CurrInfo:= ExpandFileName(Sr.Name);
      Synchronize(UpdateInfo);
      DoSearch(ResultList);
      ChDir('..');
    end
    else if ((Sr.Attr and faDirectory) = 0) and ((LowerCase(ExtractFileExt(Sr.Name)) = '.bme') or (LowerCase(ExtractFileExt(Sr.Name)) = '.bms')) then
      ResultList.Add(ExpandFileName(Sr.Name));
    Flag:= FindNext(Sr);
  end;
  SysUtils.FindClose(Sr);
end;

procedure TSearchThread.Execute;
var
  i: integer;
//  DirName: string;
begin
//  if SelectDirectory('Select Folder', '\', DirName) then
//  begin
    SInfoLabel.Caption:= '';
    SInfoLabel.Show;
    for i:= 0 to SFolderList.Count - 1 do
    begin
      ChDir(SFolderList[i]);
      DoSearch(SResultList);
      ChDir('\');
    end;
//  end;
end;

{ TNormalizeThread }

constructor TNormalizeThread.Create(ProgressLabel: TLabel;
  var TaskArray: TIntArray; FileTList: TList;
  ReTitle, BPMTrim, TotalCal, LR2Tag, NoteNormal, GenBackup: boolean;
  MEASURE: integer; var DoneCounter: integer);
begin
  NProgressLabel:= ProgressLabel;
  IndexArray:= TaskArray;
  BMSList:= FileTList;
  NReTitle:= ReTitle;
  NBPMTrim:= BPMTrim;
  NTotalCal:= TotalCal;
  NLR2Tag:= LR2Tag;
  NNote:= NoteNormal;
  NBackup:= GenBackup;
  NMeasure:= MEASURE;
  DoneCounter:= 0;
  TaskCounter:= @DoneCounter;
  FreeOnTerminate := True;
  inherited Create(False);
end;

procedure TNormalizeThread.DoNormalize(ReTitle, BPMTrim, TotalCal, LR2Tag,
  NoteNormal, GenBackup: boolean; MEASURE: integer);
var
  TaskFile, SourceFile: TBMSfile;
  i: integer;
begin
  for i:= 0 to High(IndexArray) do
  begin
    SourceFile:= TBMSfile(BMSList[IndexArray[i]]);
    ChDir(ExtractFilePath(SourceFile.FileName));
    while (DiskFree(0) shr 10) < 400 do
      if Application.MessageBox('Not enough space...', 'OOps', MB_RETRYCANCEL) = 2 then
        exit;
    TaskFile:= TBMSfile.Create;
    CurrInfo:= ExtractFileName(SourceFile.FileName);
    Synchronize(UpdateProgress);
    SourceFile.NormalizeInfo(ReTitle, BPMTrim, TotalCal, LR2Tag);
    TaskFile.Assign(SourceFile);
    if NoteNormal then
    begin
      TaskFile.Normalize(MEASURE);
    end;
    TaskFile.Save(GenBackup);
    TaskFile.Free;
    Inc(TaskCounter^);
    SourceFile.Changed:= false;
  end;
end;

procedure TNormalizeThread.Execute;
begin
  NProgressLabel.Caption:= '';
  NProgressLabel.Show;
  DoNormalize(NReTitle, NBPMTrim, NTotalCal, NLR2Tag, NNote, NBackup, NMeasure);
end;

procedure TNormalizeThread.UpdateProgress;
begin
  NProgressLabel.Caption:= 'Normalizing: ' + CurrInfo;
end;


{ TLoadInfoThread }

constructor TLoadInfoThread.Create(ProgressLabel: TLabel; FileList: TStrings;
  TaskList: TStrings; FileTList: TList);
begin
  LProgressLabel:= ProgressLabel;
  LTaskList:= TaskList;
  LFileList:= FileList;
  LFileTList:= FileTList;
  FreeOnTerminate := True;
  inherited Create(False);
end;

procedure TLoadInfoThread.DoTask(FileList: TStrings; TaskList: TStrings;
  FileTList: TList);
var
  LBMSfile: TBMSfile;
  i: integer;
begin
  for i:= 0 to TaskList.Count - 1 do
  begin
    LBMSfile:= TBMSfile.Create;
    CurrInfo:= ExtractFileName(TaskList[i]);
    Synchronize(UpdateProgress);
    LBMSfile.LoadInfo(TaskList[i]);
    FileTlist.Insert(FileList.Add(TaskList[i]), LBMSfile);
    //FileTList.Add(LBMSfile);
  end;

end;

procedure TLoadInfoThread.Execute;
begin
  LProgressLabel.Caption:= '';
  LProgressLabel.Show;
  DoTask(LFileList, LTaskList, LFileTList);
end;

procedure TLoadInfoThread.UpdateProgress;
begin
  LProgressLabel.Caption:= 'Loading: ' + CurrInfo;
end;

{ TSaveThread }

constructor TSaveThread.Create(ProgressLabel: TLabel;
  var TaskArray: TIntArray; FileTList: TList; GenBackup: boolean;
  var DoneCounter: integer);
begin
  SProgressLabel:= ProgressLabel;
  IndexArray:= TaskArray;
  BMSList:= FileTList;
  SBackup:= GenBackup;
  DoneCounter:= 0;
  TaskCounter:= @DoneCounter;
  FreeOnTerminate := True;
  inherited Create(False);
end;

procedure TSaveThread.DoSave(GenBackup: boolean);
var
  TaskFile, SourceFile: TBMSfile;
  i: integer;
begin
  for i:= 0 to High(IndexArray) do
  begin
    SourceFile:= TBMSfile(BMSList[IndexArray[i]]);
    ChDir(ExtractFilePath(SourceFile.FileName));
    while (DiskFree(0) shr 10) < 400 do
      if Application.MessageBox('Not enough space...', 'OOps', MB_RETRYCANCEL) = 2 then
        exit;

    TaskFile:= TBMSfile.Create;
    CurrInfo:= ExtractFileName(SourceFile.FileName);
    Synchronize(UpdateProgress);
    TaskFile.Assign(SourceFile);
    TaskFile.Save(GenBackup);
    TaskFile.Free;
    Inc(TaskCounter^);
    SourceFile.Changed:= false;
  end;
end;

procedure TSaveThread.Execute;
begin
  SProgressLabel.Caption:= '';
  SProgressLabel.Show;
  DoSave(SBackup);
end;

procedure TSaveThread.UpdateProgress;
begin
  SProgressLabel.Caption:= 'Saving: ' + CurrInfo;
end;

{ TReloadThread }

constructor TReloadThread.Create(ProgressLabel: TLabel;
  var FileIndexArray: TIntArray; FileTList: TList);
begin
  RProgressLabel:= ProgressLabel;
  RFileIndexArray:= FileIndexArray;
  RFileTList:= FileTList;
  FreeOnTerminate := True;
  inherited Create(False);
end;

procedure TReloadThread.DoReload(FileTList: TList);
var
  i, tempvar: integer;
  tempname: string;
begin
  for i:= 0 to High(RFileIndexArray) do
  begin
    tempvar:= RFileIndexArray[i];
    tempname:= TBMSfile(FileTList[tempvar]).FileName;
    CurrInfo:= ExtractFileName(tempname);
    Synchronize(UpdateProgress);
    TBMSfile(FileTList[tempvar]).ClearInfo;
    TBMSfile(FileTList[tempvar]).LoadInfo(tempname);
  end;
end;

procedure TReloadThread.Execute;
begin
  RProgressLabel.Caption:= '';
  RProgressLabel.Show;
  DoReload(RFileTList);
end;

procedure TReloadThread.UpdateProgress;
begin
  RProgressLabel.Caption:= 'Reloading: ' + CurrInfo;
end;

{ TRecoverThread }

constructor TRecoverThread.Create(const DirStr: string; ProgressLabel: TLabel;
  var DoneCounter: integer);
begin
  DirName:= DirStr;
  InfoLabel:= ProgressLabel;
  DoneCounter:= 0;
  TaskCounter:= @DoneCounter;
  FreeOnTerminate := True;
  inherited Create(False);
end;

procedure TRecoverThread.DoRecover;
var
  Sr: TSearchRec;
  Flag, i: integer;
  OldFileName, TempFileName: string;
begin
  Flag:= FindFirst('*.*', faDirectory, Sr);
  while Flag = 0 do
  begin
    if ((Sr.Attr and faDirectory) <> 0) and (Sr.Name <> '.') and (Sr.Name <> '..') then
    begin
      ChDir(Sr.Name);
      DoRecover;
      ChDir('..');
    end
    else if ((Sr.Attr and faDirectory) = 0) and (LowerCase(ExtractFileExt(Sr.Name)) = '.old') then
    begin
      OldFileName:= LeftStr(Sr.Name, Length(Sr.Name) - 4);
      if FileExists(OldFileName) then
      begin
        i:= 1;
        While FileExists(OldFileName + '.' + IntToStr(i)) do
          Inc(i);
        TempFileName:= OldFileName + '.' + IntToStr(i);
        RenameFile(OldFileName, TempFileName);
        RenameFile(Sr.Name, OldFileName);
        SysUtils.DeleteFile(TempFileName);
        Inc(TaskCounter^);
      end
      else
      begin
        RenameFile(Sr.Name, OldFileName);
        Inc(TaskCounter^);
      end;
      CurrInfo:= OldFileName;
      Synchronize(UpdateProgress);
    end;
    Flag:= FindNext(Sr);
  end;
  SysUtils.FindClose(Sr);
end;

procedure TRecoverThread.Execute;
begin
  InfoLabel.Caption:= '';
  ChDir(DirName);
  DoRecover
end;

procedure TRecoverThread.UpdateProgress;
begin
  InfoLabel.Caption:= 'Recovering: ' + CurrInfo;
end;

end.
