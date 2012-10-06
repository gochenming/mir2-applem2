unit MapShare;

interface

uses
  SysUtils, Windows;

const
  XORWORD = $AA38;
  NEWMAPTITLE = 'Map 2010 Ver 1.0';
  WRITEIMAGEFILENAME = 'ConversionData.dat';

type
  PRGBQuads = ^TRGBQuads;
  TRGBQuads = array[0..255] of TRGBQuad;


  pTImageTag = ^TImageTag;
  TImageTag = array[0..$7FFF] of Boolean;

  TMapHeader = packed record
    wWidth: Word;
    wHeight: Word;
    sTitle: string[16];
    UpdateDate: TDateTime;
    Reserved: array[0..22] of Char;
  end;

  pTMapInfo = ^TMapInfo;
  TMapInfo = packed record
    wBkImg: Word;
    wMidImg: Word;
    wFrImg: Word;
    btDoorIndex: byte;
    btDoorOffset: byte;
    btAniFrame: byte;
    btAniTick: byte;
    btArea: byte;
    btLight: byte;
  end;

  TENMapHeader = packed record
    Title: string[16];
    Reserved: LongWord;
    Width: Word;
    Not1: Word;
    Height: Word;
    Not2: Word;
    Reserved2: array[0..24] of char;
  end;

  PTENMapInfo = ^TENMapInfo;
  TENMapInfo = packed record
    BkImg: Word;
    BkImgNot: word;
    MidImg: word;
    FrImg: word;
    DoorIndex: byte;
    DoorOffset: byte;
    AniFrame: byte;
    AniTick: byte;
    Area: byte;
    light: byte;
    btNot: byte;
  end;

  pTWriteImageInfo = ^TWriteImageInfo;
  TWriteImageInfo = packed record
    Objects: Byte;
    Images: Word;
  end;

var
  DefMainPalette: TRgbQuads;
  MapHeader: TMapHeader;
  MapData: array[0..1000 * 1000 - 1] of TMapInfo;

  UseImages: array[0..29] of TImageTag;
  Tiles: TImageTag;
//  SmTiles: TImageTag;
  UseObject: array[0..29] of Boolean;

  WriteImages: array[Low(UseImages)..High(UseImages), Low(TImageTag)..High(TImageTag)] of TWriteImageInfo;
  boUseTile: Boolean;
  //boUseSmTile: Boolean;

  function GetObjectsName(nIdx: Integer): string;

implementation

function GetObjectsName(nIdx: Integer): string;
begin
  case nIdx of
    0: Result := 'Objects.wil';
    1..29: Result := 'Objects' + IntToStr(nIdx + 1) + '.wil';
    //30..39: Result := 'Objects' + IntToStr(nIdx - 29) + '.pak';
    else Result := '未知(' + IntToStr(nIdx) + ')';
  end;
end;

end.

