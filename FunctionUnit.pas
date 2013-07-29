unit FunctionUnit;

interface

uses
  Classes, FileCtrl, SysUtils, StrUtils, DataTypeUnit;



procedure AddFolder(ResultList: TStrings);
procedure FillFileList(FileList: TStrings; ResultList: TStrings);
procedure GetVisualList(ResultList: TStrings);
//procedure CropResult(FileList: TStrings; ResultList: TStrings);
procedure TrimResult(FileList: TStrings; ResultList: TStrings);
procedure ChkExtName(ResultList: TStrings);
procedure RecoverFiles(DirStr: string; var FileCounter: integer);
procedure GenGroupArray(SourceList: TList; var GroupArray: TGroupArray);
procedure QuickSort(var IntArray: TIntArray; StartIndex, EndIndex: integer);

function GBCode(const Str: string; JPMode: boolean): string;
function JPCode(const Str: string; JPMode: boolean): string;
//function TransCode(const Str: string; JPMode: boolean): string;
function ModifiedMark(Changed: boolean): string;
function ListIntToLvl(FileIndex: integer; SourceList: TList): string;
function TransPLAYER(const PLAYERStr: string): integer; overload;
function TransPLAYER(const PLAYERInt: integer): string; overload;
function TransRANK(const RANKStr: string): integer; overload;
function TransRANK(const RANKInt: integer): string; overload;
function TransDIFFICULTY(const DIFFICULTYStr: string): integer; overload;
function TransDIFFICULTY(const DIFFICULTYInt: integer): string; overload;
function TransBGAPos(Position, Denominator, MaxPos: integer): integer;
function BGAFileExt(const BGAFileName: string): boolean;
function LayerFileExt(const BGAFileName: string): boolean;
function BGAPosDivider(Position, MaxPos: integer): integer;

implementation

uses
  MGfile;

procedure Dosearch(ResultList: TStrings);
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
      DoSearch(ResultList);
      ChDir('..');
    end
    else if ((Sr.Attr and faDirectory) = 0) and ((LowerCase(ExtractFileExt(Sr.Name)) = '.bme') or (LowerCase(ExtractFileExt(Sr.Name)) = '.bms')) then
      ResultList.Add(ExpandFileName(Sr.Name));
    Flag:= FindNext(Sr);
  end;
  FindClose(Sr);
end;

procedure DoRecover(var FileCounter: integer);
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
      DoRecover(FileCounter);
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
        DeleteFile(TempFileName);
        Inc(FileCounter);
      end
      else
      begin
        RenameFile(Sr.Name, OldFileName);
        Inc(FileCounter);
      end;
    end;
    Flag:= FindNext(Sr);
  end;
  FindClose(Sr);
end;

procedure RecoverFiles(DirStr: string; var FileCounter: integer);
begin
  ChDir(DirStr);
  DoRecover(FileCounter);
  ChDir('\');
end;

procedure AddFolder(ResultList: TStrings);
var
  DirName: string;
begin
  if SelectDirectory('Select Folder', '/', DirName) then
  begin
    ChDir(DirName);
    DoSearch(ResultList);
    ChDir('/');
  end;
end;

procedure FillFileList(FileList: TStrings; ResultList: TStrings);
var
  i: integer;
begin
  if ResultList.Count = 0 then
    exit;
  for i:= 0 to ResultList.Count - 1 do
    if FileList.IndexOf(ResultList[i]) = -1 then
      FileList.Add(ResultList[i]);
end;

procedure GetVisualList(ResultList: TStrings);
var
  i: integer;
begin
  for i:= 0 to ResultList.Count - 1 do
    ResultList[i]:= ExtractFileName(ResultList[i]);
end;

procedure CropResult(FileList: TStrings; ResultList: TStrings);
var
  i: integer;
  TempList: TStringList;
begin
  if ResultList.Count = 0 then
    exit;
  TempList:= TStringList.Create;
  for i:= 0 to ResultList.Count - 1 do
    if FileList.IndexOf(ResultList[i]) = -1 then
      TempList.Add(ResultList[i]);
  ResultList.Assign(TempList);
  FileList.AddStrings(TempList);
  //GetVisualList(ResultList);
  TempList.Free;
end;

procedure TrimResult(FileList: TStrings; ResultList: TStrings);
var
  i: integer;
  TempList: TStringList;
begin
  if ResultList.Count = 0 then
    exit;
  TempList:= TStringList.Create;
  for i:= 0 to ResultList.Count - 1 do
    if FileList.IndexOf(ResultList[i]) = -1 then
      TempList.Add(ResultList[i]);
  ResultList.Assign(TempList);
  TempList.Free;
end;

procedure ChkExtName(ResultList: TStrings);
var
  i: integer;
  TempList: TStringList;
begin
  if ResultList.Count = 0 then
    exit;
  TempList:= TStringList.Create;
  for i:= 0 to ResultList.Count - 1 do
    if (LowerCase(ExtractFileExt(ResultList[i])) = '.bme') or (LowerCase(ExtractFileExt(ResultList[i])) = '.bms') then
      TempList.Add(ResultList[i]);
  ResultList.Assign(TempList);
  TempList.Free;
end;

procedure SortNotes(var NotesArray: TNotesArray; StartIndex, EndIndex: integer);
var
  i, j, x, TempIndex, TempNotes: integer;
begin
  i := StartIndex;
  j := EndIndex;
  x := NotesArray[(i + j) shr 1].Notes;
  repeat
    while NotesArray[i].Notes < x do
      i := i + 1;
    while x < NotesArray[j].Notes do
      j := j - 1;
    if i <= j then
    begin
      TempIndex:= NotesArray[i].Index;
      TempNotes:= NotesArray[i].Notes;
      NotesArray[i].Index:= NotesArray[j].Index;
      NotesArray[i].Notes:= NotesArray[j].Notes;
      NotesArray[j].Index:= TempIndex;
      NotesArray[j].Notes:= TempNotes;
      i:= i + 1;
      j:= j - 1;
    end;
  until i > j;
  if StartIndex < j then
    SortNotes(NotesArray, StartIndex, j);
  if i < EndIndex then
    SortNotes(NotesArray, i, EndIndex);
end;

procedure NotesLevelize(SourceList: TList; var GroupArray: TGroupArray;
  var DivideArray: TDivideArray; ItemIndex: integer);
var
  i, j, k: integer;
  NotesArray: TNotesArray;
begin
  with DivideArray[ItemIndex] do
  begin
    SetLength(NotesArray, Length(SubItem));
    for k:= 0 to High(SubItem) do
    begin
      NotesArray[k].Index:= SubItem[k];
      NotesArray[k].Notes:= TBMSfile(SourceList[SubItem[k]]).TotalNotes;
    end;
  end;
  SortNotes(NotesArray, Low(NotesArray), High(NotesArray));

  with GroupArray[ItemIndex] do
  begin
    i:= 1;
    j:= 1;
    for k:= 0 to High(NotesArray) do
    begin
      if (TBMSfile(SourceList[NotesArray[k].Index]).PLAYER = 1) and
        (i < 5) then
      begin
        SubItem[4 - i]:= NotesArray[k].Index;
        TBMSfile(SourceList[NotesArray[k].Index]).DIFFICULTY:= i + 1;
        Inc(i);
      end
      else if j < 5 then
      begin
        SubItem[j + 4]:= NotesArray[k].Index;
        TBMSfile(SourceList[NotesArray[k].Index]).DIFFICULTY:= j + 1;
        Inc(j);
      end;
    end;
  end;
end;

procedure GenGroupArray(SourceList: TList; var GroupArray: TGroupArray);
var
  i, j, k: integer;
  TempLine: string;
  DivideArray: TDivideArray;
begin
  if SourceList.Count = 0 then
    exit;
  //NotesDivide:= false;
  SetLength(GroupArray, 0);
  TempLine:= '';

  for i:= 0 to SourceList.Count - 1 do
  begin
    if TempLine <> ExtractFilePath(TBMSfile(SourceList[i]).FileName) then
    begin
      SetLength(GroupArray, High(GroupArray) + 2);
 //Notes-Level DIVISION
      SetLength(DivideArray, High(GroupArray) + 2);       //Notes divide
      if (High(GroupArray) > 0) and
        (DivideArray[High(GroupArray) - 1].NotesDivide = Length(DivideArray[High(GroupArray) - 1].SubItem)) then
        NotesLevelize(SourceList, GroupArray, DivideArray, High(GroupArray) - 1);
//Notes-Level DIVISION

      with GroupArray[High(GroupArray)] do
      begin
        SetLength(SubItem, 9);
        for j:= 0 to High(SubItem) do
          SubItem[j]:= -1;
        Title:= TBMSfile(SourceList[i]).SplitTITLE;
        BaseIndex:= i;
      end;
      TempLine:= ExtractFilePath(TBMSfile(SourceList[i]).FileName);
    end;

    with DivideArray[High(GroupArray)] do
    begin
      SetLength(SubItem, Length(SubItem) + 1);
      SubItem[High(SubItem)]:= i;
    end;

    if TBMSfile(SourceList[i]).PLAYER = 1 then
      case TBMSfile(SourceList[i]).DIFFICULTY of
        1: GroupArray[High(GroupArray)].SubItem[4]:= i;
        2: GroupArray[High(GroupArray)].SubItem[3]:= i;
        3: GroupArray[High(GroupArray)].SubItem[2]:= i;
        4: GroupArray[High(GroupArray)].SubItem[1]:= i;
        5: GroupArray[High(GroupArray)].SubItem[0]:= i;
        0: Inc(DivideArray[High(GroupArray)].NotesDivide);
      end
    else
      case TBMSfile(SourceList[i]).DIFFICULTY of
        2: GroupArray[High(GroupArray)].SubItem[5]:= i;
        3: GroupArray[High(GroupArray)].SubItem[6]:= i;
        4: GroupArray[High(GroupArray)].SubItem[7]:= i;
        5: GroupArray[High(GroupArray)].SubItem[8]:= i;
        0: Inc(DivideArray[High(GroupArray)].NotesDivide);
      end;
  end;

  if (High(GroupArray) > -1) and
    (DivideArray[High(GroupArray)].NotesDivide = Length(DivideArray[High(GroupArray)].SubItem)) then
    NotesLevelize(SourceList, GroupArray, DivideArray, High(GroupArray));


end;

procedure QuickSort(var IntArray: TIntArray; StartIndex, EndIndex: integer);
var
  i, j, x, TempVar: integer;
begin
  i := StartIndex;
  j := EndIndex;
  x := IntArray[(i + j) shr 1];
  repeat
    while IntArray[i] < x do
      i := i + 1;
    while x < IntArray[j] do
      j := j - 1;
    if i <= j then
    begin
      TempVar:= IntArray[i];
      IntArray[i]:= IntArray[j];
      IntArray[j]:= TempVar;
      i:= i + 1;
      j:= j - 1;
    end;
  until i > j;
  if StartIndex < j then
    QuickSort(IntArray, StartIndex, j);
  if i < EndIndex then
    QuickSort(IntArray, i, EndIndex);
end;

function ListIntToLvl(FileIndex: integer; SourceList: TList): string;
begin
  if FileIndex = -1 then
    Result:= ''
  else
    Result:= IntToStr(TBMSfile(SourceList[FileIndex]).PLAYLEVEL);
end;

function GBCode(const Str: string; JPMode: boolean): string;
var
  TempStr: RawByteString;
begin
  if JPMode then
  begin
    TempStr:= Str;
    SetCodePage(TempStr, 932, true);
    SetCodePage(TempStr, 936, false);
    Result:= TempStr;
  end
  else
    Result:= Str;
end;

function JPCode(const Str: string; JPMode: boolean): string;
var
  TempStr: RawByteString;
begin
  if JPMode then
  begin
    TempStr:= Str;
    SetCodePage(TempStr, 932, false);
    Result:= TempStr;
  end
  else
    Result:= Str;
end;

function ModifiedMark(Changed: boolean): string;
begin
  if Changed then
    Result:= '*'
  else
    Result:= '';
end;

function TransPLAYER(const PLAYERStr: string): integer;
var
  TempStr: string;
begin
  TempStr:= LeftStr(PLAYERStr, 1);
  if TempStr = '1' then
    Result:= 1
  else
  if TempStr = 'D' then
    Result:= 3
  else
  if TempStr = '2' then
    Result:= 2
  else
    Result:= 1;
end;

function TransPLAYER(const PLAYERInt: integer): string;
begin
  case PLAYERInt of
    1: Result:= '1P';
    2: Result:= '2P';
    3: Result:= 'DOUBLE';
  end;
end;

function TransRANK(const RANKStr: string): integer;
var
  TempStr: string;
begin
  TempStr:= LeftStr(RANKStr, 1);
  if TempStr = 'E' then
    Result:= 3
  else
  if TempStr = 'N' then
    Result:= 2
  else
  if TempStr = 'H' then
    Result:= 1
  else
  if TempStr = 'V' then
    Result:= 0
  else
    Result:= 3;
end;

function TransRANK(const RANKInt: integer): string;
begin
  case RANKInt of
    0: Result:= 'VERY HARD';
    1: Result:= 'HARD';
    2: Result:= 'NORMAL';
    3: Result:= 'EASY';
  end;
end;

function TransDIFFICULTY(const DIFFICULTYStr: string): integer;
var
  TempStr: string;
begin
  TempStr:= LeftStr(DIFFICULTYStr, 2);
  if TempStr = 'No' then
    Result:= 2
  else
  if TempStr = 'Hy' then
    Result:= 3
  else
  if TempStr = 'An' then
    Result:= 4
  else
  if TempStr = 'Bl' then
    Result:= 5
  else
  if TempStr = 'Be' then
    Result:= 1
  else
    Result:= 0;
end;

function TransDIFFICULTY(const DIFFICULTYInt: integer): string;
begin
  case DIFFICULTYInt of
    0: Result:= '';
    1: Result:= 'Beginner';
    2: Result:= 'Normal';
    3: Result:= 'Hyper';
    4: Result:= 'Another';
    5: Result:= 'Black';
  end;
end;

function TransBGAPos(Position, Denominator, MaxPos: integer): integer;
begin
  if Denominator = 0 then
    Result:= 0
  else
    Result:= Trunc(Position * (MaxPos + 1) / Denominator);
end;

function BGAPosDivider(Position, MaxPos: integer): integer;
begin
  MaxPos:= MaxPos + 1;
  while (Position mod MaxPos) > 0 do
    MaxPos:= MaxPos shr 1;
  Result:= MaxPos;
end;

function BGAFileExt(const BGAFileName: string): boolean;
var
  TempStr: string;
begin
  Result:= false;
  TempStr:= UpperCase(ExtractFileExt(BGAFileName));
  if (TempStr = '.AVI') or (TempStr = '.MPG') then
    Result:= true;
end;

function LayerFileExt(const BGAFileName: string): boolean;
var
  TempStr: string;
begin
  Result:= false;
  TempStr:= UpperCase(ExtractFileExt(BGAFileName));
  if (TempStr = '.BMP') or (TempStr = '.PNG') then
    Result:= true;
end;

end.
