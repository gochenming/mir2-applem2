program ENProject;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  Windows,
  Classes,
  RSA,
  MD5Unit in '..\..\Common\MD5Unit.pas',
  Share in 'Share.pas';

var
  sFileName: string;
  sFileMD5: string;
  sFileRSA: string;
  nFileSize: Int64;
  nRSALen, nBeginLen, nEndLen: Integer;
  FileStream: TFileStream;
  RSA: TRSA;
  ENProjectInfo: TENProjectInfo;
  I: Integer;
begin
  try
    { TODO -oUser -cConsole Main : Insert code here }
    sFileName := ParamStr(1);
    Randomize;
    if FileExists(sFileName) then begin
      sFileMD5 := FileToMD5Text(sFileName);
      FileStream := TFileStream.Create(sFileName, fmOpenWrite);
      RSA := TRSA.Create(nil);
      RSA.CommonalityMode := '177737455755753069016434453859';
      RSA.PrivateKey := '159592629991458107999879128157';
      RSA.Server := True;
      Try
        nFileSize := FileStream.Size;
        sFileMD5 := GetMD5Text(sFileMD5 + IntToStr(nFileSize));
        sFileRSA := RSA.EncryptStr(sFileMD5);
        FillChar(ENProjectInfo, SizeOf(ENProjectInfo), #0);
        nRSALen := Length(sFileRSA);
        if nRSALen <= High(ENProjectInfo) then begin
          nBeginLen := Random(High(ENProjectInfo) - nRSALen);
          nEndLen := nBeginLen + nRSALen;
          for I := Low(ENProjectInfo) to High(ENProjectInfo) do begin
            if I < nBeginLen then ENProjectInfo[I] := (Random(32) + 1) XOR XORPARAM
            else if I > nEndLen then ENProjectInfo[I] := (Random(32) + 1) XOR XORPARAM
            else ENProjectInfo[I] := Integer(Byte(sFileRSA[I - nBeginLen + 1])) XOR XORPARAM;
          end;
          //ENProjectInfo[0] := ENProjectInfo[0] XOR XORPARAM;
          FileStream.Seek(0, soEnd);
          FileStream.Write(ENProjectInfo[0], SizeOf(ENProjectInfo));
        end else begin
          Writeln(sFileName);
          Writeln(sFileMD5);
          Writeln(sFileRSA);
          Writeln(IntToStr(nFileSize));
          Writeln(IntToStr(ENProjectInfo[0]));
          MessageBox(0, '错误', '信息框', MB_OK + MB_ICONINFORMATION);
          Exit;
        end;
      Finally
        RSA.Free;
        FileStream.Free;
      End;
      Writeln(sFileName);
      Writeln(sFileMD5);
      Writeln(sFileRSA);
      Writeln(IntToStr(nFileSize));
      //MessageBox(0, 'OK', '信息框', MB_OK + MB_ICONINFORMATION);
    end;
  except
    on E:Exception do
      Writeln(E.Classname, ': ', E.Message);
  end;
end.
