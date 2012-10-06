unit Unit18;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, XMLIntf, XMLDoc,
  Dialogs, ExtCtrls, StdCtrls, xmldom, msxmldom, oxmldom;

type
  TAsciiIndex = packed record
    TextureIdx: Byte;
    Rect: TRect;
  end;

  TForm18 = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    FAsciiIndex: array[Low(Word)..High(Word)] of TAsciiIndex;
  end;

var
  Form18: TForm18;

implementation

{$R *.dfm}

var
  ChrBuff: PChar;

procedure BoldTextOutEx(Canvas: TCanvas; x, y, fcolor, bcolor: integer; str: string);
var
  nLen: Integer;
begin
  if Trim(str) = '' then
    Exit;
  nLen := Length(Trim(str));
  Move(str[1], ChrBuff^, nlen);
  Canvas.Font.Color := bcolor;
  TextOut(Canvas.Handle, x, y - 1, ChrBuff, nlen);
  TextOut(Canvas.Handle, x, y + 1, ChrBuff, nlen);
  TextOut(Canvas.Handle, x - 1, y, ChrBuff, nlen);
  TextOut(Canvas.Handle, x + 1, y, ChrBuff, nlen);
  TextOut(Canvas.Handle, x - 1, y - 1, ChrBuff, nlen);
  TextOut(Canvas.Handle, x + 1, y + 1, ChrBuff, nlen);
  TextOut(Canvas.Handle, x - 1, y + 1, ChrBuff, nlen);
  TextOut(Canvas.Handle, x + 1, y - 1, ChrBuff, nlen);
  Canvas.Font.Color := fcolor;
  TextOut(Canvas.Handle, x, y, ChrBuff, nlen);
end;

procedure TForm18.Button1Click(Sender: TObject);
var
  str: WideString;
  sstr: string;
  i, nX, nY, nF, nOldF: integer;
  nHeight, nWidth: Integer;
  Bitmap: TBitmap;
  Rect: TRect;
  index: Word;
  FileStream: TFileStream;
begin
  str := Memo1.Lines.GetText;
  str := Trim(str);
  FillChar(FAsciiIndex, SizeOf(FAsciiIndex), #0);
  nHeight := 0;
  nWidth := 0;
  Bitmap := TBitmap.Create;
  Bitmap.PixelFormat := pf32bit;
  Bitmap.Width := 512;
  Bitmap.Height := 512;
  Bitmap.Canvas.Brush.Color := clRed;
  Rect.Top := 0;
  Rect.Left := 0;
  Rect.Right := Bitmap.Width;
  Rect.Bottom := Bitmap.Height;
  Bitmap.Canvas.FillRect(Rect);
  Bitmap.Canvas.Font.Name := 'ËÎÌו';
  Bitmap.Canvas.Font.Size := 9;
  SetBkMode(Bitmap.Canvas.Handle, TRANSPARENT);
  DeleteFile('d:\Font\Index.dat');
  FileStream := TFileStream.Create('d:\Font\Index.dat', fmCreate);
  nOldF := 0;
  nF := 0;
  for I := 0 to length(str) - 1 do
  begin
    sstr := str[i + 1];
    nF := I div (36 * 36);
    if nF <> nOldF then
    begin
      Bitmap.SaveToFile('d:\Font\Font_' + format('%.2d', [nOldF]) + '.bmp');
      nOldF := nF;
      Bitmap.Canvas.Brush.Color := clRed;
      Bitmap.Canvas.FillRect(Rect);
      SetBkMode(Bitmap.Canvas.Handle, TRANSPARENT);
    end;
    nWidth := Bitmap.Canvas.TextWidth(sstr);
    nX := I mod 36 * 14;
    nY := I div 36 * 14 - (nF * (36 * 14));
    BoldTextOutEx(Bitmap.Canvas, nX + 1, nY + 1, clWhite, clBlack, sstr);
    Move(str[i + 1], index, 2);
    FAsciiIndex[index].TextureIdx := nF;
    FAsciiIndex[index].Rect.Left := nX;
    FAsciiIndex[index].Rect.Top := nY;
    FAsciiIndex[index].Rect.Right := nX + nWidth + 2;
    FAsciiIndex[index].Rect.Bottom := nY + 14;
    {if Length(sstr) = 1 then aChrnode.SetAttribute('Ascii', IntToStr(Byte(sstr[1])))
    else aChrnode.SetAttribute('Ascii', IntToStr(MakeWord(Byte(sstr[1]), Byte(sstr[2]))));
    FAsciiIndex[]
    aChrNode := aNode.AddChild('Item');
    if Length(sstr) = 1 then aChrnode.SetAttribute('Ascii', IntToStr(Byte(sstr[1])))
    else aChrnode.SetAttribute('Ascii', IntToStr(MakeWord(Byte(sstr[1]), Byte(sstr[2]))));
    aChrnode.SetAttribute('Top', IntToStr(nY));
    aChrnode.SetAttribute('Left', IntToStr(nX));
    aChrnode.SetAttribute('Width', IntToStr(nWidth + 2));
    aChrnode.SetAttribute('Height', '14');   }
  end;
  Bitmap.SaveToFile('d:\Font\Font_' + format('%.2d', [nF]) + '.bmp');
  //xmlDoc.SaveToFile('d:\Font\Font_' + format('%.2d', [nF]) + '.xml');
  //image1.Picture.Bitmap := Bitmap;
  FileStream.Write(FAsciiIndex[0], SizeOf(FAsciiIndex));
  FileStream.Free;
  Bitmap.Free;
end;

procedure TForm18.Button2Click(Sender: TObject);
var
  str: WideString;
  sstr: string;
begin
  str := Memo1.Lines.GetText;
  str := Trim(str);
  showmessage(inttostr(length(str)));
end;

initialization
  begin
    GetMem(ChrBuff, 2048);
  end;

finalization
  begin
    FreeMem(ChrBuff);
  end;

end.

