unit mgfile;
//{$M+}
//Core V0.2.3   2010.01.07
//Fix NoteUp Missing Bug & Adjust Normalize ScratchLongnote
//Core V0.2.2   2010.01
//Add Layer Support
//Core V0.2.1.5 2009.12
//Fix Note-Missing Bug
//Core V0.2.1   2009.12
//Add Longnote support & Other Channel

interface

type
  THeader = record
    PLAYER: Integer;
    GENRE: string;
    TITLE: string;
    ARTIST: string;
    BPM: Double;
    PLAYLEVEL: Integer;
    RANK: Integer;
    TOTAL: Integer;
    STAGEFILE: string;
    DIFFICULTY: Integer;
    AddTotalNote: Integer;
    TotalNotes: Integer;
    LNTYPE: Integer;
    LNOBJ: string;
  end;

  TBGAdata = record
    BGAoverride: Boolean;
    Layer: Boolean;
    FileName: string;
    KeyName: string;
    Track: Integer;
    Position: Integer;
    Denominator: Integer;
  end;

  TStrDef = record
    Key: string;
    Value: string;
  end;

  TValDef = record
    Key: string;
    Value: Double;
  end;

  TDefiner = record
    WAV: array of TStrDef;
    BPM: array of TvalDef;
    BMP: array of TStrDef;
  end;

  TBeat = record
    No: Integer;
    Value: Double;
  end;

  TNote = record
    Numerator: Integer;
    Name: string;
  end;

  TKeyItem = record
    Track: Integer;
    Channel: Integer;
    Denominator: Integer;
    Note: array of TNote;
  end;

  TMaindata = record
    Beat: array of TBeat;
    KeyItem: array of TKeyItem;
  end;

  TBMSdata = record
    Header: THeader;
    Definer: TDefiner;
    Maindata: TMaindata;
  end;

  TSwitch = record
    GenBackup: Boolean;
    CalTotal: Boolean;
    BGAOverride: Boolean;
    ReTitle: Boolean;
    NoteNormalize: Boolean;
    NormalizeSubD: Integer;
  end;

  TBMSfile = class(TObject)
  private
    BGAFilled: Boolean;
    BMSdata: TBMSdata;
    BMSfilename: string;
    BPMRound: Boolean;
    Normalized: Boolean;
    function CalTOTAL: Integer;
    procedure FillBGA(BGAKey: string; Source: TBMSFile);
    function FillHeader(TempHeaderLeft: string; TempRight: string): Boolean;
    function FindBeat(TracktoFind: integer): Double;
    function GetDIFFICULTY: Integer;
    procedure KeyItemProcess(KeyItemIndex: integer; var ToFinalMEASURE:
        integer);
    procedure KeyItemSort(StartIndex: integer; EndIndex: integer);
    procedure NoteUp(KeyItemIndex: integer; NoteIndex: integer; UpStep:
        integer);
  public
    BGAdata: TBGAdata;
    Changed: Boolean;
    constructor Create;
    destructor Destroy; override;
    procedure Assign(Source: TBMSfile);
    procedure AssignGroupInfo(Source: TBMSfile);
    procedure AssignInfo(Source: TBMSfile);
    procedure ClearInfo;
    procedure Load(const Filename: string);
    procedure LoadInfo(const Filename: string);
    procedure Normalize(MEASURE: integer = 32);
    procedure NormalizeInfo(ReTitle: boolean = true; BPMTrim: boolean = true;
        TotalCal: boolean = true; LR2Tag: boolean = true);
    procedure Save(GenBackup: boolean = false); overload;
    procedure Save(const Filename: string); overload;
    function SplitTITLE: string;
    property ARTIST: string read BMSdata.Header.ARTIST write
        BMSdata.Header.ARTIST;
    property BPM: Double read BMSdata.Header.BPM write BMSdata.Header.BPM;
    property DIFFICULTY: Integer read BMSdata.Header.DIFFICULTY write
        BMSdata.Header.DIFFICULTY;
    property FileName: string read BMSfilename;
    property GENRE: string read BMSdata.Header.GENRE write BMSdata.Header.GENRE;
    property PLAYER: Integer read BMSdata.Header.PLAYER write
        BMSdata.Header.PLAYER;
    property PLAYLEVEL: Integer read BMSdata.Header.PLAYLEVEL write
        BMSdata.Header.PLAYLEVEL;
    property RANK: Integer read BMSdata.Header.RANK write BMSdata.Header.RANK;
    property STAGEFILE: string read BMSdata.Header.STAGEFILE write
        BMSdata.Header.STAGEFILE;
    property TITLE: string read BMSdata.Header.TITLE write BMSdata.Header.TITLE;
    property TOTAL: Integer read BMSdata.Header.TOTAL write
        BMSdata.Header.TOTAL;
    property TotalNotes: Integer read BMSdata.Header.TotalNotes;
  end;

  TBMSArray = array of TBMSfile;


implementation

uses
  StrUtils, SysUtils, FunctionUnit;

{ TBMSfile }

{
*********************************** TBMSfile ***********************************
}
constructor TBMSfile.Create;
begin
  ClearInfo;
  Normalized:= false;
  BGAFilled:= false;
end;

destructor TBMSfile.Destroy;
var
  i, j: Integer;
begin
  with BMSdata do
  begin
    with Definer do
    begin
      WAV:= nil;
      BPM:= nil;
      BMP:= nil;
    end;

    with Maindata do
    begin
      Beat:= nil;
      for i:= 0 to High(KeyItem) do
        for j:= 0 to High(KeyItem[i].Note) do
          KeyItem[i].Note:= nil;
      KeyItem:= nil;
    end;
  end;
end;

procedure TBMSfile.Assign(Source: TBMSfile);
var
  Fbms: TextFile;
  TempLine, TempRight, TempDefinerLeft, TempNote: string;
  FlagPos, FlagMainPos: Integer;
  PlayNoteCounter, TotalNoteCounter, NoteIndexCounter: Integer;
  MainNo, TrackNo, ChannelNo: Integer;
  i, j: Integer;
begin
  if not Assigned(Source) then
    exit;
  try
    AssignInfo(Source);
    AssignFile(Fbms, BMSfilename);
    Reset(Fbms);
    PlayNoteCounter:= 0;
    TotalNoteCounter:= 0;

    While not Eof(Fbms) do
    begin
      Readln(Fbms, TempLine);
      if LeftStr(TempLine, 1) = '#' then
      begin
        Trim(TempLine);
        With BMSdata do
        begin
          FlagPos:= Pos(' ',TempLine);
          FlagMainPos:= Pos(':', TempLine);

          if FlagPos > 3 then
          begin
            TempRight:= RightStr(TempLine, Length(TempLine)-FlagPos);
            //TempHeaderLeft:= LeftStr(TempLine, FlagPos - 1);

            {Fill Definer}
            TempDefinerLeft:= LeftStr(TempLine, FlagPos - 3);
            if TempDefinerLeft = '#WAV' then
            begin
              Setlength(Definer.WAV, Length(Definer.WAV) + 1);
              With Definer.WAV[High(Definer.WAV)] do
              begin
                Key:= MidStr(TempLine, FlagPos - 2, 2);
                Value:= TempRight;
              end;
            end

            else if TempDefinerLeft = '#BPM' then
            begin
              Setlength(Definer.BPM, Length(Definer.BPM) + 1);
              With Definer.BPM[High(Definer.BPM)] do
              begin
                Key:= MidStr(TempLine, FlagPos - 2, 2);
                Value:= StrToFloat(TempRight);
              end;
            end

            else if (TempDefinerLeft = '#BMP') and
            (((not BGAdata.BGAOverride) and BGAFileExt(TempRight)) or
            (BGAdata.Layer and LayerFileExt(TempRight))) then
            begin
              Setlength(Definer.BMP, Length(Definer.BMP) + 1);
              With Definer.BMP[High(Definer.BMP)] do
              begin
                Key:= MidStr(TempLine, FlagPos - 2, 2);
                Value:= TempRight;
              end;
            end;

          end
          {Fill MainData}
          else if (FlagMainPos > 3) and Trystrtoint(MidStr(TempLine, 2, FlagMainPos - 2), MainNo) then
          begin
            TrackNo:= MainNo div 100;
            ChannelNo:= MainNo mod 100;
            TempRight:= RightStr(TempLine, Length(TempLine) - FlagMainPos);
            With Maindata do
            begin
              if ChannelNo = 2 then // beat channel
              begin
                Setlength(Beat, Length(Beat) + 1);
                with Beat[High(Beat)] do
                begin
                  No:= TrackNo;
                  Value:= Strtofloat(TempRight);
                end;
              end
              else if ((ChannelNo < 30) or (ChannelNo > 50)) and
                (((ChannelNo <> 7)) or BGAdata.Layer) and  //6: Miss layer 7: Layer channel
                ((ChannelNo <> 4) or (not BGAdata.BGAOverride)) then
              begin
                Setlength(KeyItem, Length(KeyItem) + 1);
                with KeyItem[High(KeyItem)] do
                begin
                  Track:= TrackNo;
                  Channel:= ChannelNo;
                  Denominator:= Length(TempRight) shr 1;
                  NoteIndexCounter:= 0;
                  j:= 1;
                  for i:= 1 to Denominator do
                  begin
                    TempNote:= MidStr(TempRight, j, 2);
                    if TempNote <> '00' then
                    begin
                      Setlength(Note, Length(Note) + 1);
                      Note[High(Note)].Numerator:= NoteIndexCounter;
                      Note[High(Note)].Name:= TempNote;
                      if ChannelNo > 10 then //playchannel
                        Inc(PlayNoteCounter);
                      Inc(TotalNoteCounter);
                    end;
                    Inc(NoteIndexCounter);
                    j:= j + 2;
                  end;

                end;
              end;
            end;
          end;
          {MainData Filled}
        end;
        {end of 'with BMSdata'}
      end;
    end;
    {end of while Readln}
    BMSdata.Header.TotalNotes:= PlayNoteCounter;
    BMSdata.Header.AddTotalNote:= TotalNoteCounter;

    if BGAdata.BGAOverride and (BGAdata.FileName <> '') then
      FillBGA(BGAdata.KeyName, Source);

  finally
    CloseFile(Fbms);
  end;

end;

procedure TBMSfile.AssignGroupInfo(Source: TBMSfile);
begin
  if not Assigned(Source) then
    exit;
  BMSdata.Header.GENRE:= Source.GENRE;
  BMSdata.Header.TITLE:= Source.TITLE;
  BMSdata.Header.ARTIST:= Source.ARTIST;
  BMSdata.Header.BPM:= Source.BPM;
  BMSdata.Header.RANK:= Source.RANK;

  BGAdata.BGAoverride:= Source.BGAdata.BGAoverride;
  BGAdata.Layer:= Source.BGAdata.Layer;
  BGAdata.FileName:= Source.BGAdata.FileName;
  BGAdata.KeyName:= Source.BGAdata.KeyName;
  BGAdata.Track:= Source.BGAdata.Track;
  BGAdata.Position:= Source.BGAdata.Position;
  BGAdata.Denominator:= Source.BGAdata.Denominator;
end;

procedure TBMSfile.AssignInfo(Source: TBMSfile);
begin
  if not Assigned(Source) then
    exit;
  BMSdata.Header.PLAYER:= Source.PLAYER;
  BMSdata.Header.GENRE:= Source.GENRE;
  BMSdata.Header.TITLE:= Source.TITLE;
  BMSdata.Header.ARTIST:= Source.ARTIST;
  BMSdata.Header.BPM:= Source.BPM;
  BMSdata.Header.PLAYLEVEL:= Source.PLAYLEVEL;
  BMSdata.Header.RANK:= Source.RANK;
  BMSdata.Header.TOTAL:= Source.TOTAL;
  BMSdata.Header.STAGEFILE:= Source.STAGEFILE;
  BMSdata.Header.DIFFICULTY:= Source.DIFFICULTY;
  BMSFileName:= Source.FileName;
  BGAdata.BGAoverride:= Source.BGAdata.BGAoverride;
  BGAdata.Layer:= Source.BGAdata.Layer;
  BGAdata.FileName:= Source.BGAdata.FileName;
  BGAdata.KeyName:= Source.BGAdata.KeyName;
  BGAdata.Track:= Source.BGAdata.Track;
  BGAdata.Position:= Source.BGAdata.Position;
  BGAdata.Denominator:= Source.BGAdata.Denominator;

  BPMRound:= Source.BPMRound;
end;

function TBMSfile.CalTOTAL: Integer;
begin
  if BMSdata.Header.TotalNotes < 338 then
    exit(260);
  result:= Round(7.605 * BMSdata.Header.TotalNotes / (0.01 * BMSdata.Header.TotalNotes + 6.5));
end;

procedure TBMSfile.ClearInfo;
begin
  with BMSdata do
  begin
    {Header Init}
    Header.PLAYER:= 1;
    Header.GENRE:= '';
    Header.TITLE:= '';
    Header.ARTIST:= '';
    Header.BPM:= 130;
    Header.PLAYLEVEL:= 1;
    Header.RANK:= 3;
    Header.TOTAL:= 0;
    Header.DIFFICULTY:= 0;
    Header.TotalNotes:= 0;
    Header.STAGEFILE:= '';
    Header.AddTotalNote:= 0;
    Header.LNTYPE:= 0;
    Header.LNOBJ:= '';
  end;

  with BGAdata do
  begin
    BGAoverride:= true;
    Layer:= false;
    //BGAoverride:= false;
    FileName:= '';
    KeyName:= 'ZZ';
    Track:= 0;
    Position:= 0;
    Denominator:= 0;
  end;

end;

procedure TBMSfile.FillBGA(BGAKey: string; Source: TBMSFile);
var
  KeyItemLen, i: Integer;
begin
  SetLength(BMSdata.Definer.BMP, High(BMSdata.Definer.BMP) + 2);
  BMSdata.Definer.BMP[High(BMSdata.Definer.BMP)].Key:= BGAKey;
  BMSdata.Definer.BMP[High(BMSdata.Definer.BMP)].Value:= BGAdata.FileName;

  KeyItemLen:= Length(BMSdata.Maindata.KeyItem);
  SetLength(BMSdata.Maindata.KeyItem, KeyItemLen + 1);

  with BMSdata.Maindata.KeyItem[KeyItemLen] do
  begin
    Track:= BGAdata.Track;
    Channel:= 4;
    Denominator:= BGAdata.Denominator;
    if Denominator = 0 then
      Denominator:= 1;
    SetLength(Note, 1);
    Note[0].Numerator:= BGAdata.Position;
    Note[0].Name:= BGAKey;
  end;

  //Track Moving
  if BGAdata.Track < 0 then
  begin
    for i:= 0 to KeyItemLen do
      with BMSdata.Maindata.KeyItem[i] do
        Track:= Track - BGAdata.Track;
    for i:= 0 to High(BMSdata.Maindata.Beat) do
      with BMSdata.Maindata.Beat[i] do
        No:= No - BGAdata.Track;
    Source.BGAdata.Track:= 0;
    BGAdata.Track:= 0;
  end;

  BGAFilled:= true;

end;

function TBMSfile.FillHeader(TempHeaderLeft: string; TempRight: string):
    Boolean;
begin
  Result:= true;
  if TempHeaderLeft = '#PLAYER' then
    BMSdata.Header.PLAYER:= Strtoint(TempRight)
  else if TempHeaderLeft = '#GENRE' then
    BMSdata.Header.GENRE:= TempRight
  else if TempHeaderLeft = '#TITLE' then
    BMSdata.Header.TITLE:= TempRight
  else if TempHeaderLeft = '#ARTIST' then
    BMSdata.Header.ARTIST:= TempRight
  else if TempHeaderLeft = '#BPM' then
    BMSdata.Header.BPM:= StrtofloatDef(TempRight, 130)
  else if TempHeaderLeft = '#PLAYLEVEL' then
    BMSdata.Header.PLAYLEVEL:= StrtointDef(TempRight, 1)
  else if TempHeaderLeft = '#RANK' then
    BMSdata.Header.RANK:= StrtointDef(TempRight, 3)
  else if TempHeaderLeft = '#TOTAL' then
    BMSdata.Header.TOTAL:= trunc(StrtofloatDef(TempRight, 0))
  else if TempHeaderLeft = '#DIFFICULTY' then
    BMSdata.Header.DIFFICULTY:= StrToIntDef(TempRight, 0)
  else if TempHeaderLeft = '#STAGEFILE' then
    BMSdata.Header.STAGEFILE:= TempRight
  else if TempHeaderLeft = '#LNTYPE' then
    BMSdata.Header.LNTYPE:= StrToIntDef(TempRight, 0)
  else if TempHeaderLeft = '#LNOBJ' then
    BMSdata.Header.LNOBJ:= TempRight
  else
    Result:= false;
end;

function TBMSfile.FindBeat(TracktoFind: integer): Double;
var
  i: Integer;
begin
  with BMSdata.Maindata do
  begin
    if High(Beat) = -1 then
    begin
      Result:= 1;
      exit;
    end;
    for i:= 0 to High(Beat) do
      if Beat[i].No = TracktoFind then
      begin
        Result:= Beat[i].Value;
        exit;
      end;
    Result:= 1;
  end;
end;

function TBMSfile.GetDIFFICULTY: Integer;
var
  TempStr: string;
  i, j: Integer;
begin
  TempStr:= ExtractFileName(BMSfilename);
  i:= Pos('[', TempStr);
  j:= Pos('].', TempStr);
  if (i = 0) or (i > j - 2) then
    exit(0);
  TempStr:= UpperCase(MidStr(TempStr, i + 1, j - 1 - i));
  if Pos('BEGINNER', TempStr) > 0 then
    exit(1);
  if (Pos('LIGHT', TempStr) > 0) or (Pos('NORMAL', TempStr) > 0) then
    exit(2);
  if (Pos('KEY', TempStr) > 0) or (Pos('HYPER', TempStr) > 0) then
    exit(3);
  if (Pos('ANOTHER', TempStr) > 0) then
    exit(4);
  if (Pos('BLACK', TempStr) > 0) then
    exit(5);
  if (Pos('01', TempStr) > 0) or (Pos('05', TempStr) > 0) then
    exit(2);
  if (Pos('02', TempStr) > 0) or (Pos('06', TempStr) > 0) then
    exit(3);
  if (Pos('03', TempStr) > 0) or (Pos('07', TempStr) > 0) then
    exit(4);
  if (Pos('PN', TempStr) > 0) or (Pos('SN', TempStr) > 0) or (Pos('DN', TempStr) > 0) then
    exit(2);
  if (Pos('PH', TempStr) > 0) or (Pos('SH', TempStr) > 0) or (Pos('DH', TempStr) > 0) then
    exit(3);
  if (Pos('PA', TempStr) > 0) or (Pos('SA', TempStr) > 0) or (Pos('DA', TempStr) > 0) then
    exit(4);
  result:= 0;
end;

procedure TBMSfile.KeyItemProcess(KeyItemIndex: integer; var ToFinalMEASURE:
    integer);
var
  TempArray: array of integer;
  i: Integer;
  flag: Boolean;
begin
  with BMSdata.Maindata do
  begin
    flag:= true;
    repeat
      for i:= 0 to High(KeyItem[KeyItemIndex].Note) do
      begin
        flag:= true;
        Setlength(TempArray, i + 1);
        TempArray[i]:= Round(KeyItem[KeyItemIndex].Note[i].Numerator / KeyItem[KeyItemIndex].Denominator * ToFinalMEASURE);
        if (i > 0) and (TempArray[i-1] = TempArray[i]) then
        begin
          ToFinalMEASURE:= ToFinalMEASURE shl 1;
          if ToFinalMEASURE >= KeyItem[KeyItemIndex].Denominator then
          begin
            ToFinalMEASURE:= KeyItem[KeyItemIndex].Denominator;
            TempArray:= nil;
            exit;
          end;
          flag:= false;
          break;
        end;
      end;
    until flag;
    for i:= 0 to High(KeyItem[KeyItemIndex].Note) do
      KeyItem[KeyItemIndex].Note[i].Numerator:= TempArray[i];
    TempArray:= nil;
  end;
end;

procedure TBMSfile.KeyItemSort(StartIndex: integer; EndIndex: integer);

    procedure KeyItemSwap(A, B: integer);
    var
      SwapTempKeyItem: TKeyItem;
      z: integer;
    begin
      with BMSdata.Maindata do
      begin
        SwapTempKeyItem.Track:= KeyItem[A].Track;
        SwapTempKeyItem.Channel:= KeyItem[A].Channel;
        SwapTempKeyItem.Denominator:= KeyItem[A].Denominator;
        Setlength(SwapTempKeyItem.Note, High(KeyItem[A].Note)+1);
        for z:= 0 to High(KeyItem[A].Note) do
        begin
          SwapTempKeyItem.Note[z].Numerator:= KeyItem[A].Note[z].Numerator;
          SwapTempKeyItem.Note[z].Name:= KeyItem[A].Note[z].Name;
        end;

        KeyItem[A].Track:= KeyItem[B].Track;
        KeyItem[A].Channel:= KeyItem[B].Channel;
        KeyItem[A].Denominator:= KeyItem[B].Denominator;
        Setlength(KeyItem[A].Note, High(KeyItem[B].Note)+1);
        for z:= 0 to High(KeyItem[B].Note) do
        begin
          KeyItem[A].Note[z].Numerator:= KeyItem[B].Note[z].Numerator;
          KeyItem[A].Note[z].Name:= KeyItem[B].Note[z].Name;
        end;

        KeyItem[B].Track:= SwapTempKeyItem.Track;
        KeyItem[B].Channel:= SwapTempKeyItem.Channel;
        KeyItem[B].Denominator:= SwapTempKeyItem.Denominator;
        Setlength(KeyItem[B].Note, High(SwapTempKeyItem.Note)+1);
        for z:= 0 to High(SwapTempKeyItem.Note) do
        begin
          KeyItem[B].Note[z].Numerator:= SwapTempKeyItem.Note[z].Numerator;
          KeyItem[B].Note[z].Name:= SwapTempKeyItem.Note[z].Name;
        end;
      end;
    end;

  var
    i, j, x: integer;

begin
  with BMSdata.Maindata do
  begin
    i := StartIndex;
    j := EndIndex;
    x := KeyItem[(StartIndex + EndIndex) shr 1].Track * 100 + KeyItem[(StartIndex + EndIndex) shr 1].Channel;
    repeat
      while (KeyItem[i].Track * 100 + KeyItem[i].Channel) < x do
        i := i + 1;
      while x < (KeyItem[j].Track * 100 + KeyItem[j].Channel) do
        j := j - 1;
      if i <= j then
      begin
        KeyItemSwap(i, j);
        i:= i + 1;
        j:= j - 1;
      end;
    until i > j;
    if StartIndex < j then
      KeyItemSort(StartIndex, j);
    if i < EndIndex then
      KeyItemSort(i, EndIndex);
  end;
end;

procedure TBMSfile.Load(const Filename: string);
var
  Fbms: TextFile;
  TempLine, TempRight, TempHeaderLeft, TempDefinerLeft, TempNote: string;
  FlagPos, FlagMainPos: Integer;
  PlayNoteCounter, TotalNoteCounter, NoteIndexCounter: Integer;
  MainNo, TrackNo, ChannelNo: Integer;
  i, j, k: Integer;
  BGAflag: Boolean;
begin
  BMSfilename:= Filename;
  if BMSfilename = '' then
    exit;
  try
    AssignFile(Fbms, BMSfilename);
    Reset(Fbms);
    PlayNoteCounter:= 0;
    TotalNoteCounter:= 0;
    BGAflag:= false;

    While not Eof(Fbms) do
    begin
      Readln(Fbms, TempLine);
      if LeftStr(TempLine, 1) = '#' then
      begin
        Trim(TempLine);
        With BMSdata do
        begin
          FlagPos:= Pos(' ',TempLine);
          FlagMainPos:= Pos(':', TempLine);

          {Fill Header}
          if FlagPos > 3 then
          begin
            TempRight:= RightStr(TempLine, Length(TempLine)-FlagPos);  //for ansistring no rightstr bug rightBstr
            TempHeaderLeft:= LeftStr(TempLine, FlagPos - 1);

            if not FillHeader(TempHeaderLeft, TempRight) then

            {Fill Definer}
            begin
              TempDefinerLeft:= LeftStr(TempLine, FlagPos - 3);
              if TempDefinerLeft = '#WAV' then
              begin
                Setlength(Definer.WAV, Length(Definer.WAV) + 1);
                With Definer.WAV[High(Definer.WAV)] do
                begin
                  Key:= MidStr(TempLine, FlagPos - 2, 2);
                  Value:= TempRight;
                end;
              end

              else if TempDefinerLeft = '#BPM' then
              begin
                Setlength(Definer.BPM, Length(Definer.BPM) + 1);
                With Definer.BPM[High(Definer.BPM)] do
                begin
                  Key:= MidStr(TempLine, FlagPos - 2, 2);
                  Value:= StrToFloat(TempRight);
                end;
              end

              else if (TempDefinerLeft = '#BMP') then
              begin
                Setlength(Definer.BMP, Length(Definer.BMP) + 1);
                With Definer.BMP[High(Definer.BMP)] do
                begin
                  Key:= MidStr(TempLine, FlagPos - 2, 2);
                  Value:= TempRight;
                  //Fill BGAData
                  if BGAFileExt(TempRight) and not BGAflag then
                  begin
                    BGAflag:= true;
                    BGAdata.FileName:= Value;
                    BGAdata.KeyName:= Key;
                  end
                  else if LayerFileExt(TempRight) and not BGAdata.Layer then
                  begin
                    BGAdata.Layer:= true;
                  end;
                  //BGAdata Filled
                end;
              end;
            end;

          end
          {Fill MainData}
          else if (FlagMainPos > 3) and Trystrtoint(MidStr(TempLine, 2, FlagMainPos - 2), MainNo) then
          begin
            TrackNo:= MainNo div 100;
            ChannelNo:= MainNo mod 100;
            TempRight:= RightStr(TempLine, Length(TempLine) - FlagMainPos);
            With Maindata do
            begin
              if ChannelNo = 2 then // beat channel
              begin
                Setlength(Beat, Length(Beat) + 1);
                with Beat[High(Beat)] do
                begin
                  No:= TrackNo;
                  Value:= Strtofloat(TempRight);
                end;
              end
              else if (ChannelNo < 30) or (ChannelNo > 50) then
              begin
                Setlength(KeyItem, Length(KeyItem) + 1);
                with KeyItem[High(KeyItem)] do
                begin
                  Track:= TrackNo;
                  Channel:= ChannelNo;
                  Denominator:= Length(TempRight) shr 1;
                  NoteIndexCounter:= 0;
                  j:= 1;
                  for i:= 1 to Denominator do
                  begin
                    TempNote:= MidStr(TempRight, j, 2);
                    if TempNote <> '00' then
                    begin
                      Setlength(Note, Length(Note) + 1);
                      Note[High(Note)].Numerator:= NoteIndexCounter;
                      Note[High(Note)].Name:= TempNote;
                      if ChannelNo > 10 then //playchannel
                        Inc(PlayNoteCounter);
                      Inc(TotalNoteCounter);
                    end;
                    Inc(NoteIndexCounter);
                    j:= j + 2;
                  end;
                  //Fill BGAdata 2
                  if (Channel = 4) and (BGAflag) and (BGAdata.Denominator = 0) then
                    for k:= 0 to High(Note) do
                      if Note[k].Name = BGAdata.KeyName then
                      begin
                        BGAdata.Denominator:= Denominator;
                        BGAdata.Track:= Track;
                        BGAdata.Position:= Note[k].Numerator;
                        break;
                      end;
                  //BGAdata 2 Filled
                end;
              end;
            end;
          end;
          {MainData Filled}
        end;
        {end of 'with BMSdata'}
      end;

    end;
    {end of while Readln}
    BMSdata.Header.TotalNotes:= PlayNoteCounter;
    BMSdata.Header.AddTotalNote:= TotalNoteCounter;
    if BMSdata.Header.DIFFICULTY = 0 then
      BMSdata.Header.DIFFICULTY:= GetDIFFICULTY;
    if BGAdata.Denominator = 0 then
      BGAdata.FileName:= ''
    else
      BGAdata.BGAoverride:= false;
  finally
    CloseFile(Fbms);
  end;

end;

procedure TBMSfile.LoadInfo(const Filename: string);
var
  Fbms: TextFile;
  TempLine, TempRight, TempHeaderLeft: string;
  FlagPos, FlagMainPos: Integer;
  PlayNoteCounter: Integer;
  MainNo, ChannelNo: Integer;
  i, j: Integer;
  BGAflag: Boolean;
begin
  BMSfilename:= Filename;
  if BMSfilename = '' then
    exit;
  try
    AssignFile(Fbms, BMSfilename);
    Reset(Fbms);
    PlayNoteCounter:= 0;
    BGAflag:= false;

    While not Eof(Fbms) do
    begin
      Readln(Fbms, TempLine);
      if LeftStr(TempLine, 1) = '#' then
      begin
        Trim(TempLine);
        With BMSdata do
        begin
          FlagPos:= Pos(' ',TempLine);
          FlagMainPos:= Pos(':', TempLine);
          {Fill Header}
          if FlagPos > 3 then
          begin
            TempRight:= RightStr(TempLine, Length(TempLine) - FlagPos);  //for ansistring no rightstr bug rightBstr
            TempHeaderLeft:= LeftStr(TempLine, FlagPos - 1);

            if not FillHeader(TempHeaderLeft, TempRight) then

            //Fill BGAdata
              if (LeftStr(TempHeaderLeft, 4) = '#BMP') then
              begin
                if BGAFileExt(TempRight) and (not BGAflag) then
                begin
                  BGAflag:= true;
                  BGAdata.FileName:= TempRight;
                  BGAdata.KeyName:= RightStr(TempHeaderLeft, 2);
                end
                else if LayerFileExt(TempRight) and (not BGAdata.Layer) then
                begin
                  BGAdata.Layer:= true;
                end;

              end;
            //BGAdata Filled

          end
          {Fill MainData}
          else if (FlagMainPos > 3) and TryStrToInt(MidStr(TempLine, 2, FlagMainPos - 2), MainNo) then
          begin
            ChannelNo:= MainNo mod 100;
            TempRight:= RightStr(TempLine, Length(TempLine) - FlagMainPos);
            if ((ChannelNo > 10) and (ChannelNo < 30)) or (ChannelNo > 50) then
            begin
              j:= 1;
              for i:= 1 to (Length(TempRight) shr 1) do
              begin
                if MidStr(TempRight, j, 2) <> '00' then
                  Inc(PlayNoteCounter);
                j:= j + 2;
              end;
            end
            //Fill BGAdata 2
            else if (ChannelNo = 4) and BGAflag and (BGAdata.Denominator = 0) then
            begin
              j:= 1;
              for i:= 1 to (Length(TempRight) shr 1) do
              begin
                if MidStr(TempRight, j, 2) = BGAdata.KeyName then
                begin
                  BGAdata.Denominator:= Length(TempRight) shr 1;
                  BGAdata.Track:= MainNo div 100;
                  BGAdata.Position:= i - 1;
                  break;
                end;
                j:= j + 2;
              end;
            end;
            //BGAdata 2 Filled
          end;
        end;
        {end of 'with BMSdata'}
      end;

    end;
    {end of while Readln}
    BMSdata.Header.TotalNotes:= PlayNoteCounter;
    if BMSdata.Header.DIFFICULTY = 0 then
      BMSdata.Header.DIFFICULTY:= GetDIFFICULTY;
    if BGAdata.Denominator = 0 then
      BGAdata.FileName:= ''
    else
      BGAdata.BGAoverride:= false;
  finally
    CloseFile(Fbms);
  end;
end;

procedure TBMSfile.Normalize(MEASURE: integer = 32);

                                                         //Self-Adapt Ver
  const
    BEATMEASURE: integer = 8;
  var
    finalmeasure: integer;  //default value is 32
    i, j: integer;
    lasttrack: integer;
    flag, divisor, minval: integer;

begin
  with BMSdata do
  begin
      {BPM Normalize}
    if BPMRound then
      with Definer do
        for i:= 0 to High(BPM) do
          BPM[i].Value:= Round(BPM[i].Value);

      {BeatNormalize}
    with Maindata do
      for i:= 0 to High(Beat) do
        Beat[i].Value:= Round(Beat[i].Value * BEATMEASURE) / BEATMEASURE;

      {NoteNormalize}
    with Maindata do
    begin
        {Pre-Sort}
      if High(KeyItem) = -1 then
        exit;
      KeyItemSort(Low(KeyItem), High(KeyItem));

        {NotesNormalize : to 1/32 note}
      lasttrack:= KeyItem[0].Track;
      finalmeasure:= Trunc(FindBeat(lasttrack) * MEASURE);
      for i:= 0 to High(KeyItem) do
      begin
          if KeyItem[i].Track <> lasttrack then
          begin
            finalmeasure:= Trunc(FindBeat(KeyItem[i].Track) * MEASURE);
            lasttrack:= KeyItem[i].Track;
          end;

  // array Note isn't nil
          if length(KeyItem[i].Note) = 0 then
            continue;
          if (((KeyItem[i].Channel < 4) or (KeyItem[i].Channel > 7))
          and ((KeyItem[i].Channel <> 56) and (KeyItem[i].Channel <> 66)))   //56&66: 1P&2P scratch Longnote
          and (KeyItem[i].Denominator > finalmeasure) then
          begin
            KeyItemProcess(i, finalmeasure);
            j:= High(KeyItem[i].Note);
            if KeyItem[i].Note[j].Numerator = finalmeasure then  //this time Note[j] refers to Tail, so the statement is out of for
            begin
              KeyItem[i].Note[j].Numerator:= 0;
              NoteUp(i, j, 1);  //upper track
            end;
            KeyItem[i].Denominator:= finalmeasure;
          end;

            {find common divisor & do div}
          if length(KeyItem[i].Note) = 0 then
            continue;

          flag:= -1;
          Setlength(KeyItem[i].Note, length(KeyItem[i].Note) + 1);   //attach Denominator for DivisorFinding

          KeyItem[i].Note[High(KeyItem[i].Note)].Numerator:= KeyItem[i].Denominator;
          minval:= KeyItem[i].Note[0].Numerator;
          if minval = 0 then
            minval:= KeyItem[i].Note[1].Numerator;

          for divisor:= minval downto 1 do
          begin
            for j:= 0 to High(KeyItem[i].Note) do
            begin
              flag:= -1;
              if KeyItem[i].Note[j].Numerator mod divisor = 0 then
                flag:= 1
              else
                break;
            end;
            if flag = 1 then break;
          end;

          Setlength(KeyItem[i].Note, High(KeyItem[i].Note));  //dettach Denominator

          //find one then div them
          if divisor > 1 then
          begin
            KeyItem[i].Denominator:= KeyItem[i].Denominator div divisor;
            for j:= 0 to High(KeyItem[i].Note) do
              KeyItem[i].Note[j].Numerator:= KeyItem[i].Note[j].Numerator div divisor;
          end;
      end;

        {Re-Sort}
  //      KeyItemSort(Low(KeyItem),High(KeyItem));
    end;
  end;

  Normalized:= true;
end;

procedure TBMSfile.NormalizeInfo(ReTitle: boolean = true; BPMTrim: boolean =
    true; TotalCal: boolean = true; LR2Tag: boolean = true);
begin
  BPMRound:= BPMTrim;
  if ReTitle then
    BMSdata.Header.TITLE:= SplitTITLE;
  if BPMTrim then
    BMSdata.Header.BPM:= Round(BPM);
  if TotalCal then
    BMSdata.Header.TOTAL:= CalTOTAL;
  if LR2Tag then
    BMSdata.Header.DIFFICULTY:= GetDIFFICULTY;
end;

procedure TBMSfile.NoteUp(KeyItemIndex: integer; NoteIndex: integer; UpStep:
    integer);
var
  i, j, flag: Integer;
  thistrack, thischannel: Integer;
begin
  with BMSdata.Maindata do
  begin
    i:= KeyItemIndex;
    thistrack:= KeyItem[KeyItemIndex].Track;
    thischannel:= KeyItem[KeyItemIndex].Channel;
    flag:= 0;
    if (thischannel > 10) and (KeyItemIndex < High(KeyItem)) then
      repeat
        Inc(i);
        flag:= KeyItem[i].Track - thistrack;
      until ((flag = UpStep) and (KeyItem[i].Channel = thischannel))
      or (flag > UpStep) or (i = High(KeyItem));

    if flag = 1 then
      with KeyItem[i] do
      begin
        Setlength(Note, High(Note) + 2);
        for j:= High(Note) - 1 downto 0 do
        begin
          Note[j + 1].Numerator:= Note[j].Numerator;
          Note[j + 1].Name:= Note[j].Name;
        end;
        //if High(Note) = -1 then
        //  Setlength(Note, 1);
        Note[0].Numerator:= 0;
        Note[0].Name:= KeyItem[KeyItemIndex].Note[NoteIndex].Name;
      end
    else
    begin
      Setlength(KeyItem, High(KeyItem) + 2);
      with KeyItem[High(KeyItem)] do
      begin
        Track:= thistrack + UpStep;
        Channel:= thischannel;
        Denominator:= 1;
        Setlength(Note, 1);
        Note[0].Numerator:= 0;
        Note[0].Name:= KeyItem[KeyItemIndex].Note[NoteIndex].Name;
      end;
    end;

    //clean up
    with KeyItem[KeyItemIndex] do
      Setlength(Note, High(Note));
  end;

end;

procedure TBMSfile.Save(GenBackup: boolean = false);
var
  i: Integer;
  Filename, BakFilename: string;
  Firstbackup: Boolean;
begin
  i:=1;
  Firstbackup:= true;
  Filename:= BMSfilename;
  BakFilename:= BMSfilename + '.old';
  if FileExists(BakFilename) then
  begin
    Firstbackup:= false;
    while FileExists(BakFilename + '.' + IntToStr(i)) do
      Inc(i);
    BakFilename:= BakFilename + '.' + IntToStr(i);
  end;
  RenameFile(Filename, BakFilename);
  Save(Filename);
  if (not GenBackup) and (not Firstbackup) then
    DeleteFile(BakFilename);
end;

procedure TBMSfile.Save(const Filename: string);
var
  Fbms: TextFile;
  i, j, k, lasttrack: Integer;
  Saveline: string;
  INFOLINE, HEADERLINE, MAINDATALINE: string;
begin
  if FileExists(Filename) then
    exit;
  try
    AssignFile(Fbms, Filename);
    Rewrite(Fbms);
  //    INFOLINE:= ';>>>>>>> Normalized V0.3, have a try:)';
    HEADERLINE:= '*---------------------- HEADER FIELD';
    MAINDATALINE:= '*---------------------- MAIN DATA FIELD';
    lasttrack:= 0;
    with BMSdata do
    begin
      if Normalized or BGAFilled then
        KeyItemSort(Low(Maindata.KeyItem),High(Maindata.KeyItem));

        //  Writeln(Fbms, INFOLINE);
      Writeln(Fbms, '');
      Writeln(Fbms, HEADERLINE);
      Writeln(Fbms, '');
      with Header do
      begin
        Writeln(Fbms, '#PLAYER ' + IntToStr(PLAYER));
        if GENRE <> '' then
          Writeln(Fbms, '#GENRE ' + GENRE);
        if TITLE <> '' then
          Writeln(Fbms, '#TITLE ' + TITLE);
        if ARTIST <> '' then
          Writeln(Fbms, '#ARTIST ' + ARTIST);
        Writeln(Fbms, '#BPM ' + FloatToStr(BPM));
        Writeln(Fbms, '#PLAYLEVEL ' + IntToStr(PLAYLEVEL));
        Writeln(Fbms, '#RANK ' + IntToStr(RANK));
        if TOTAL > 0 then
          Writeln(Fbms, '#TOTAL ' + IntToStr(TOTAL));
        if STAGEFILE <> '' then
          Writeln(Fbms, '#STAGEFILE ' + STAGEFILE);
        if DIFFICULTY <> 0 then
          Writeln(Fbms, '#DIFFICULTY ' + IntToStr(DIFFICULTY));
        if LNTYPE > 0 then
        begin
          Writeln(Fbms, '');
          Writeln(Fbms, '#LNTYPE ' + IntToStr(LNTYPE));
        end;
        if LNOBJ <> '' then
          Writeln(Fbms, '#LNOBJ ' + LNOBJ);
      end;

      Writeln(Fbms, '');
      with Definer do
      begin
        for i:= 0 to High(WAV) do
          Writeln(Fbms, '#WAV' + WAV[i].Key + ' ' + WAV[i].Value);
        Writeln(Fbms, '');
        for i:= 0 to High(BMP) do
          Writeln(Fbms, '#BMP' + BMP[i].Key + ' ' + BMP[i].Value);
        Writeln(Fbms, '');
        for i:= 0 to High(BPM) do
          Writeln(Fbms, '#BPM' + BPM[i].Key + ' ' + floattostr(BPM[i].Value));
      end;

      Writeln(Fbms, '');
      Writeln(Fbms, MAINDATALINE);
      Writeln(Fbms, '');
      with Maindata do
      begin
        for i:= 0 to High(Beat) do
          if Beat[i].Value <> 1 then
            Writeln(Fbms, '#' + formatfloat('000', Beat[i].No) + '02:' + floattostr(Beat[i].Value));
        Writeln(Fbms, '');
        for i:= 0 to High(KeyItem) do
        begin
          if High(KeyItem[i].Note) > -1 then
          begin
            Saveline:= '';
            k:= 0;
            if lasttrack <> KeyItem[i].Track then
            begin
              lasttrack:= KeyItem[i].Track;
              Writeln(Fbms, '');
            end;
            for j:= 1 to KeyItem[i].Denominator do
            begin
              if KeyItem[i].Note[k].Numerator = j - 1 then
              begin
                Saveline:= Saveline + KeyItem[i].Note[k].Name;
                if (k + 1) > High(KeyItem[i].Note) then
                  continue;
                Inc(k);
              end
              else
                Saveline:= Saveline + '00';
            end;
            Writeln(Fbms, '#' + formatfloat('00000', KeyItem[i].Track * 100 + KeyItem[i].Channel) + ':' + Saveline);
          end;
        end;
      end;
    end;
  finally
    CloseFile(Fbms);
  end;
end;

function TBMSfile.SplitTITLE: string;

  const
    DiffTag: string = '[';
  var
    TagPos: integer;

begin
  TagPos:= Pos(DiffTag, BMSdata.Header.TITLE);
  if TagPos > 1 then
    Result:= Trim(LeftStr(BMSdata.Header.TITLE, TagPos - 1))
  else
    Result:= BMSdata.Header.TITLE;
end;



end.
