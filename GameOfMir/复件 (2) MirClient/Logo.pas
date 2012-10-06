unit Logo;

interface
uses
  Windows, SysUtils, Classes, Graphics, HGETextures, HGEBase, DirectXGraphics, HGECanvas, Grobal2;

{$IF Var_Free = 1}
  {$INCLUDE LogoBitempFree.inc}
{$ELSE}
  {$INCLUDE LogoBitemp.inc}
{$IFEND}

var
  g_LogoSurface: TDirectDrawSurface = nil;

procedure CreateLogoSurface();
procedure DestroyLogoSurface();

implementation
uses
  CLMain;

procedure CreateLogoSurface();
var
  Access: TDXAccessInfo;
  WriteBuffer, ReadBuffer: PChar;
  Y: Integer;
begin
  DestroyLogoSurface();
  g_LogoSurface := TDXImageTexture.Create(g_DXCanvas);
  g_LogoSurface.Size := Point(LogoWidth, LogoHeight);
  g_LogoSurface.PatternSize := Point(LogoWidth, LogoHeight);
  g_LogoSurface.Format := D3DFMT_A4R4G4B4;
  g_LogoSurface.Active := True;
  if g_LogoSurface.Active then begin
    if g_LogoSurface.Lock(lfWriteOnly, Access) then begin
      Try
        for Y := 0 to LogoHeight - 1 do begin
          ReadBuffer := @LogoBuffer[Y * LogoWidth * 2];
          WriteBuffer := Pointer(Integer(Access.Bits) + (Access.Pitch * Y));
          Move(ReadBuffer^, WriteBuffer^, LogoWidth * 2);
        end;
      Finally
        g_LogoSurface.Unlock;
      End;
    end; 
  end else begin
    g_LogoSurface.Free;
    g_LogoSurface := nil;
  end;
end;

procedure DestroyLogoSurface();
begin
  if g_LogoSurface <> nil then g_LogoSurface.Free;
  g_LogoSurface := nil;
end;

end.
