library Encrypt;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

uses
  SysUtils,
  DLLMain in 'DLLMain.pas',
  MD5Unit in '..\..\Common\MD5Unit.pas',
  Share in 'Share.pas';

{$R *.res}

const
  BITMASKS = $AA;

procedure Decode6BitBuf(sSource: PChar; pbuf: PChar; nSrcLen, nBufLen: Integer); stdcall
const
  Masks: array[2..6] of byte = ($FC, $F8, $F0, $E0, $C0);
var
  i, nBitPos, nMadeBit, nBufPos: Integer;
  btCh, btTmp, btByte, btXor: byte;
begin
  Try
    nBitPos := 2;
    nMadeBit := 0;
    nBufPos := 0;
    btTmp := 0;
    btCh := 0;
    for i := 0 to nSrcLen - 1 do begin
      if Integer(sSource[i]) - $3C >= 0 then
        btCh := byte(sSource[i]) - $3C
      else begin
        nBufPos := 0;
        break;
      end;
      if nBufPos >= nBufLen then
        break;
      if (nMadeBit + 6) >= 8 then begin
        btByte := byte(btTmp or ((btCh and $3F) shr (6 - nBitPos)));

        btXor := BITMASKS;
        Inc(btXor, nBufPos);
        btByte := btByte xor btXor;

        pbuf[nBufPos] := Char(btByte);
        Inc(nBufPos);
        nMadeBit := 0;
        if nBitPos < 6 then
          Inc(nBitPos, 2)
        else begin
          nBitPos := 2;
          continue;
        end;
      end;
      btTmp := byte(byte(btCh shl nBitPos) and Masks[nBitPos]);
      Inc(nMadeBit, 8 - nBitPos);
    end;
    pbuf[nBufPos] := #0;
  Except
  End;
end;

procedure Encode6BitBuf(pSrc, PDest: PChar; nSrcLen, nDestLen: Integer); stdcall
var
  i: Integer;
  nRestCount: Integer;
  nDestPos: Integer;
  btMade: byte;
  btCh: byte;
  btRest: byte;
  btXor: Byte;
begin
  Try
    nRestCount := 0;
    btRest := 0;
    nDestPos := 0;
    for i := 0 to nSrcLen - 1 do begin
      if nDestPos >= nDestLen then
        break;
      btCh := byte(pSrc[i]);

      btXor := BITMASKS;
      Inc(btXor, i);
      btCh := btCh xor btXor;

      btMade := byte((btRest or (btCh shr (2 + nRestCount))) and $3F);
      btRest := byte(((btCh shl (8 - (2 + nRestCount))) shr 2) and $3F);
      Inc(nRestCount, 2);

      if nRestCount < 6 then begin
        PDest[nDestPos] := Char(btMade + $3C);
        Inc(nDestPos);
      end
      else begin
        if nDestPos < nDestLen - 1 then begin
          PDest[nDestPos] := Char(btMade + $3C);
          PDest[nDestPos + 1] := Char(btRest + $3C);
          Inc(nDestPos, 2);
        end
        else begin
          PDest[nDestPos] := Char(btMade + $3C);
          Inc(nDestPos);
        end;
        nRestCount := 0;
        btRest := 0;
      end;
    end;
    if nRestCount > 0 then begin
      PDest[nDestPos] := Char(btRest + $3C);
      Inc(nDestPos);
    end;
    PDest[nDestPos] := #0;
  Except
  End;
end;

exports
  Decode6BitBuf, Encode6BitBuf;

begin
end.

