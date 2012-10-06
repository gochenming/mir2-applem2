unit FrmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DropGroupPas;

const
  MAXX = 1000;
  MAXY = 1000;

type
  TMapInfo = record
    BkImg: word;
    MidImg: word;
    FrImg: word;
    DoorIndex: byte; //$80 (¹®Â¦), ¹®ÀÇ ½Äº° ÀÎµ¦½º
    DoorOffset: byte; //´ÝÈù ¹®ÀÇ ±×¸²ÀÇ »ó´ë À§Ä¡, $80 (¿­¸²/´ÝÈû(±âº»))
    AniFrame: byte; //$80(Åõ¸í)  ÇÁ·¡ÀÓ ¼ö
    AniTick: byte; //¸î¹ø¿¡ Æ½¸¶´Ù ÇÑ ÇÁ·¡ÀÓ¾¿ ¿òÁ÷ÀÌ´Â°¡
    Area: byte; //Object.WIL ¹øÈ£
    light: byte; //0..1..4 ±¤¿ø È¿°ú
  end;
  PTMapInfo = ^TMapInfo;

  TNewMapInfo = packed record
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
  PTNewMapInfo = ^TNewMapInfo;

  TMapHeader = packed record
    Width: word;
    Height: word;
    Title: string[15];
    UpdateDate: TDateTime;
    Reserved: array[0..23] of char;
  end;

  TNewMapHeader = packed record
    Title: string[16];
    Reserved: LongWord;
    Width: Word;
    Not1: Word;
    Height: Word;
    Not2: Word;
    Reserved2: array[0..24] of char;
  end;

  TFormMain = class(TForm)
    DropFileGroupBox1: TDropFileGroupBox;
    lst1: TListBox;
    btn1: TButton;
    btn2: TButton;
    procedure btn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure DropFileGroupBox1DropFile(Sender: TObject);
    procedure btn2Click(Sender: TObject);
  private
    { Private declarations }
  public
    FileList: TStringList;
    MArr: array[0..MAXX + 10, 0..MAXY + 10] of TMapInfo;
  end;

var
  FormMain: TFormMain;

implementation

{$R *.dfm}

procedure TFormMain.btn1Click(Sender: TObject);
begin
  lst1.Items.Clear;
  FileList.Clear;
end;

procedure TFormMain.btn2Click(Sender: TObject);
const
  XORWORD = $AA38;
  NEWMAPTITLE = 'Map 2010 Ver 1.0';
  TITLEHEADER = 'Legend of mir';
var
  I, k, j: Integer;
  sFileName: string;
  aMapFile: TFileStream;
  ENMapHeader: TNewMapHeader;
  boENMap: Boolean;
  header: TMapHeader;
  MapWidth, MapHeight: Integer;
  ENMapData: array of array of TNewMapInfo;
begin
  btn1.Enabled := False;
  btn2.Enabled := False;
  try
    for I := 0 to FileList.Count - 1 do begin
      sFileName := FileList[I];
      if FileExists(sFileName) then begin
        aMapFile := TFileStream.Create(sFileName, fmOpenRead or fmShareDenyNone);
        try
          aMapFile.Read(ENMapHeader, Sizeof(TNewMapHeader));
          boENMap := (ENMapHeader.Title = NEWMAPTITLE);
          if boENMap then begin
            header.Width := ENMapHeader.Width xor XORWORD;
            header.Height := ENMapHeader.Height xor XORWORD;
            header.Title := TITLEHEADER;
            header.UpdateDate := Now;

            MapWidth := header.Width;
            MapHeight := header.Height;
            if (MapWidth <= 1000) and (MapHeight <= 1000) then begin
              SetLength(ENMapData, MapWidth, MapHeight);
              for k := 0 to MapWidth - 1 do begin
                aMapFile.Read(ENMapData[k, 0], SizeOf(TNewMapInfo) * MapHeight);
                for j := 0 to MapHeight - 1 do begin
                  MArr[k, j].BkImg := ENMapData[k, j].BkImg xor XORWORD;
                  if (ENMapData[k, j].BkImgNot xor $AA38) = $2000 then
                    MArr[k, j].BkImg := MArr[k, j].BkImg or $8000;
                  MArr[k, j].MidImg := ENMapData[k, j].MidImg xor XORWORD;
                  MArr[k, j].FrImg := ENMapData[k, j].FrImg xor XORWORD;
                  MArr[k, j].DoorIndex := ENMapData[k, j].DoorIndex;
                  MArr[k, j].DoorOffset := ENMapData[k, j].DoorOffset;
                  MArr[k, j].AniFrame := ENMapData[k, j].AniFrame;
                  MArr[k, j].AniTick := ENMapData[k, j].AniTick;
                  MArr[k, j].Area := ENMapData[k, j].Area;
                  MArr[k, j].light := ENMapData[k, j].light;
                end;
              end;
              ENMapData := nil;
              aMapFile.Free;
              aMapFile := TFileStream.Create(sFileName, fmOpenWrite or fmShareDenyNone);
              aMapFile.Write(header, SizeOf(header));
              for k := 0 to MapWidth - 1 do
                aMapFile.Write(MArr[k, 0], Sizeof(TMapInfo) * MapHeight);
            end;
          end;
        finally
          aMapFile.Free;
        end;
      end;
    end;
    Application.MessageBox('È«²¿×ª»»Íê³É£¡', '', MB_OK + MB_ICONINFORMATION);

  finally
    btn1.Enabled := True;
    btn2.Enabled := True;
  end;
end;

procedure TFormMain.DropFileGroupBox1DropFile(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to DropFileGroupBox1.Files.Count - 1 do begin
    lst1.Items.Add(ExtractFileName(DropFileGroupBox1.Files[I]));
    FileList.Add(DropFileGroupBox1.Files[I]);
  end;
end;

procedure TFormMain.FormCreate(Sender: TObject);
begin
  FileList := TStringList.Create;
end;

procedure TFormMain.FormDestroy(Sender: TObject);
begin
  FileList.Free;
end;

end.

