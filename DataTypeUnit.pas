unit DataTypeUnit;

interface

type
//  TSelArray = array of integer;

  TIntArray = array of integer;

  TGroupItem = record
    Title: string;
    SubItem: TIntArray;  //0:SX; 1:SA; 2:SH; 3:SN; 4:SB; 5:DN; 6:DH; 7:DA; 8:DX
    BaseIndex: integer;
  end;

  TGroupArray = array of TGroupItem;

  TNotesItem = record
    Index: integer;
    Notes: integer;
  end;

  TNotesArray = array of TNotesItem;

  TDivideItem = record
    NotesDivide: integer;
    SubItem: TIntArray
  end;

  TDivideArray = array of TDivideItem;

const
  MarkTAG: integer = 0;
  FileNameTAG: integer = 1;
  FileItemIndexTAG: integer = 2;
  FDataIndexCOL: integer = 1;

  SXTAG: integer = 0;
  SATAG: integer = 1;
  SHTAG: integer = 2;
  SNTAG: integer = 3;
  TitleTAG: integer = 4;
  BGTAG: integer = 5;
  DNTAG: integer = 6;
  DHTAG: integer = 7;
  DATAG: integer = 8;
  DXTAG: integer = 9;
  GroupItemIndexTAG: integer = 10;
  GDataTitleCOL: integer = 3; //subitem[3]
  GDataIndexCOL: integer = 9; //subitem[9]

implementation

end.
