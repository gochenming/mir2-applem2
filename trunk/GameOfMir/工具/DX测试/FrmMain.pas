unit FrmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TDX9Devices, MyDirect3D9, MyDXBase, TDX9Textures, ExtCtrls;

{$INCLUDE LogoBitemp.inc}

type
  TForm6 = class(TForm)
    MyDevice: TDX9Device;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure MyDeviceInitialize(Sender: TObject; var Success: Boolean; var ErrorMsg: string);
    procedure Timer1Timer(Sender: TObject);
    procedure MyDeviceRender(Sender: TObject);
  private
    FTexture: TDXTexture;
  public
    { Public declarations }
  end;

var
  Form6: TForm6;

implementation

{$R *.dfm}

procedure TForm6.FormActivate(Sender: TObject);
begin
  if not MyDevice.Initialize then begin
    Application.MessageBox(PCHar('失败'), '提示信息', MB_OK + MB_ICONSTOP);

  end;
    //Application.MessageBox(PCHar('成功'), '提示信息', MB_OK + MB_ICONSTOP);
end;

procedure TForm6.FormCreate(Sender: TObject);
begin
  ClientWidth := 800;
  ClientHeight := 600;
  MyDevice.Width := 800;
  MyDevice.Height := 600;
end;

procedure TForm6.MyDeviceInitialize(Sender: TObject; var Success: Boolean; var ErrorMsg: string);
  procedure DestroyLogoSurface();
  begin
    if FTexture <> nil then FTexture.Free;
    FTexture := nil;
  end;

  procedure CreateLogoSurface();
  var
    Access: TDXAccessInfo;
    WriteBuffer, ReadBuffer: PChar;
    Y: Integer;
  begin
    DestroyLogoSurface();
    FTexture := TDXImageTexture.Create(MyDevice.Canvas);
    FTexture.Size := Point(256, 128);
    FTexture.PatternSize := Point(LogoWidth, LogoHeight);
    FTexture.Format := D3DFMT_A4R4G4B4;
    FTexture.Active := True;
    if FTexture.Active then begin
      if FTexture.Lock(lfWriteOnly, Access) then begin
        Try
          for Y := 0 to LogoHeight - 1 do begin
            ReadBuffer := @LogoBuffer[Y * LogoWidth * 2];
            WriteBuffer := Pointer(Integer(Access.Bits) + (Access.Pitch * Y));
            Move(ReadBuffer^, WriteBuffer^, LogoWidth * 2);
          end;
        Finally
          FTexture.Unlock;
        End;
      end;
    end else begin
      FTexture.Free;
      FTexture := nil;
    end;
  end;
begin
 { FTexture := TDXTexture.Create;
  FTexture.Size := Point(800, 600);
  FTexture.Behavior := tbUnmanaged;
  FTexture.PatternSize := Point(800, 600);
  FTexture.Format := D3DFMT_A4R4G4B4;
  FTexture.Active := True;   }
 { FTexture := TDXImageTexture.Create(MyDevice.Canvas);
  FTexture.Size := Point(244, 116);
  FTexture.PatternSize := Point(244, 116);
  FTexture.Format := D3DFMT_A4R4G4B4;
  FTexture.Active := True;   }
  CreateLogoSurface();
  Success := FTexture.Active;
  if not Success then begin
    FTexture.Free;
    FTexture := nil;
  end else Timer1.Enabled := True;
end;

procedure TForm6.MyDeviceRender(Sender: TObject);
begin
  MyDevice.Canvas.Draw(0, 0, FTexture.ClientRect, FTexture, True);

end;

procedure TForm6.Timer1Timer(Sender: TObject);
begin
  MyDevice.Render(0, True);
  MyDevice.Flip;
end;

end.
