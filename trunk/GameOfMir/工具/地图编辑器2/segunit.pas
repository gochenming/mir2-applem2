unit segunit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Grids, HUtil32;

type
  TFrmSegment = class(TForm)
    SegGrid: TStringGrid;
    BtnNew: TButton;
    BtnSave: TButton;
    BtnOpen: TButton;
    EdIdent: TEdit;
    Label1: TLabel;
    EdCol: TEdit;
    EdRow: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    BtnEdit: TButton;
    BtnCancel: TButton;
    SaveDialog1: TSaveDialog;
    OpenDialog1: TOpenDialog;
    BtnSaveSegs: TButton;
    procedure BtnNewClick(Sender: TObject);
    procedure BtnSaveClick(Sender: TObject);
    procedure BtnOpenClick(Sender: TObject);
    procedure BtnEditClick(Sender: TObject);
    procedure BtnCancelClick(Sender: TObject);
    procedure BtnSaveSegsClick(Sender: TObject);
  private
    procedure ClearSegGrid;
    procedure InitSegment (ident: string; col, row: integer);
    function  SaveToFile (flname: string): Boolean;
    function  LoadFromFile (flname: string): Boolean;
    procedure GetCurrentSegment;
  public
    SegPath: string;
    CurSegs: array[0..2, 0..2] of string;
    OffsX, OffsY: integer;
    procedure ShiftLeftSegment;
    procedure ShiftRightSegment;
    procedure ShiftUpSegment;
    procedure ShiftDownSegment;
  end;

var
  FrmSegment: TFrmSegment;

implementation

uses
   edmain;

{$R *.DFM}


procedure TFrmSegment.ClearSegGrid;
var
   i, j: integer;
begin
   for i:=0 to SegGrid.Col-1 do
      for j:=0 to SegGrid.Row-1 do begin
         SegGrid.Cells[i, j] := '';
      end;
end;

procedure TFrmSegment.InitSegment (ident: string; col, row: integer);
var
   i, j: integer;
begin
   SegGrid.ColCount := col;
   SegGrid.RowCount := row;
   for i:=0 to col-1 do
      for j:=0 to row-1 do begin
         SegGrid.Cells[i, j] := ident + IntToStr(100 + j) + IntToStr(100 + i);
      end;
end;

procedure TFrmSegment.BtnNewClick(Sender: TObject);
var
   colcount, rowcount: integer;
begin
   colcount := Str_ToInt (EdCol.Text, 0);
   rowcount := Str_ToInt (EdRow.Text, 0);
   if (colcount > 0) and (rowcount > 0) then begin
      SegGrid.ColCount := colcount;
      SegGrid.RowCount := rowcount;
      SegPath := '';
      ClearSegGrid;
      InitSegment (Trim (EdIdent.Text), colcount, rowcount);
   end;
end;

function  TFrmSegment.SaveToFile (flname: string): Boolean;
var
   mapprj: TMapPrjInfo;
   fhandle: integer;
begin
   Result := FALSE;
   mapprj.Ident := Trim(EdIdent.Text);
   mapprj.ColCount := Str_ToInt (EdCol.Text, 0);
   mapprj.RowCount := Str_ToInt (EdRow.Text, 0);
   if FileExists (flname) then
      fhandle := FileOpen (flname, fmOpenWrite)
   else fhandle := FileCreate (flname);
   if fhandle > 0 then begin
      FileWrite (fhandle, mapprj, sizeof(TMapPrjInfo));
      FileClose (fhandle);
      Result := TRUE;
   end;
end;

function  TFrmSegment.LoadFromFile (flname: string): Boolean;
var
   mapprj: TMapPrjInfo;
   fhandle: integer;
begin
   Result := FALSE;
   if FileExists (flname) then begin
      fhandle := FileOpen (flname, fmOpenRead or fmShareDenyNone);
      if handle > 0 then begin
         FileRead (fhandle, mapprj, sizeof(TMapPrjInfo));
         FileClose (fhandle);
         EdIdent.Text := mapprj.Ident;
         EdCol.Text := IntToStr(mapprj.ColCount);
         EdRow.Text := IntToStr(mapprj.RowCount);
         Result := TRUE;
      end;
   end;
end;

procedure TFrmSegment.BtnSaveClick(Sender: TObject);
begin
   with SaveDialog1 do begin
      if Execute then begin
         SegPath := ExtractFilePath (FileName);
         SaveToFile (FileName);
      end;
   end;
end;

procedure TFrmSegment.BtnOpenClick(Sender: TObject);
var
   colcount, rowcount: integer;
begin
   with OpenDialog1 do begin
      if Execute then begin
         LoadFromFile (FileName);
         SegPath := ExtractFilePath (FileName);
         colcount := Str_ToInt (EdCol.Text, 0);
         rowcount := Str_ToInt (EdRow.Text, 0);
         InitSegment (Trim(EdIdent.Text), colcount, rowcount);
      end;
   end;
end;

procedure TFrmSegment.GetCurrentSegment;
var
   i, j: integer;
begin
   for i:=0 to 2 do
      for j:=0 to 2 do
         CurSegs[i, j] := '';
   with SegGrid do begin
      for i:=0 to 2 do begin
         if (i+TopRow) >= RowCount then break;
         for j:=0 to 2 do begin
            if (j+LeftCol) >= ColCount then break;
            CurSegs[j, i] := Cells[j+LeftCol, i+TopRow];
         end;
      end;
   end;
end;

procedure TFrmSegment.BtnEditClick(Sender: TObject);
var
   r: integer;
begin
   OffsX := SegGrid.LeftCol * SEGX;
   OffsY := SegGrid.TopRow * SEGY;
   if FrmMain.Edited then begin
      r := MessageDlg ('작업중인 맵을 저장하시겠습니까?',
                       mtWarning,
                       mbYesNoCancel,
                       0);
      if r = mrYes then
         FrmMain.DoSaveSegments;
   end;
   GetCurrentSegment;
   FrmMain.DoEditSegment;
   if SegPath <> '' then
      Close;
end;

procedure TFrmSegment.BtnCancelClick(Sender: TObject);
begin
   FrmMain.SegmentMode := FALSE;
   Close;
end;

procedure TFrmSegment.BtnSaveSegsClick(Sender: TObject);
begin
   if SegPath <> '' then FrmMain.DoSaveSegments
   else ShowMessage ('취소 되었습니다');
end;

procedure TFrmSegment.ShiftLeftSegment;
begin
   if SegGrid.LeftCol > 0 then SegGrid.LeftCol := SegGrid.LeftCol - 1;
   BtnEditClick (self);
end;

procedure TFrmSegment.ShiftRightSegment;
begin
   with SegGrid do
      if LeftCol + 2 < ColCount-1 then
         LeftCol := LeftCol + 1;
   BtnEditClick (self);
end;

procedure TFrmSegment.ShiftUpSegment;
begin
   with SegGrid do
      if TopRow > 0 then
         TopRow := TopRow - 1;
   BtnEditClick (self);
end;

procedure TFrmSegment.ShiftDownSegment;
begin
   with SegGrid do
      if TopRow + 2 < RowCount-1 then
         TopRow := TopRow + 1;
   BtnEditClick (self);
end;



end.
