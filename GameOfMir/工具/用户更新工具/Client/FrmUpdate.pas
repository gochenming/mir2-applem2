unit FrmUpdate;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BusinessSkinForm, bsSkinData, bsSkinCtrls, StdCtrls, JSocket, ExtCtrls;

const
  DOWNFILENAME = 'Update.361Tool';

type
  TFormUpdate = class(TForm)
    DForm: TbsBusinessSkinForm;
    DSkinData: TbsSkinData;
    Gauge: TbsSkinGauge;
    LBHint: TbsSkinStdLabel;
    bsSkinStdLabel1: TbsSkinStdLabel;
    bsSkinStdLabel3: TbsSkinStdLabel;
    LBTime: TbsSkinStdLabel;
    LBSpeed: TbsSkinStdLabel;
    DSocket: TClientSocket;
    Timer1: TTimer;
    TimerSpeed: TTimer;
    procedure DSocketConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure DSocketDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure DSocketError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure DSocketRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TimerSpeedTimer(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    FDownUrl: string;
    FReadStr: string;
    FUrlHost: string;
    FFileSize: Integer;
    FFileWriteSize: Integer;
    FOldFileWriteSize: Integer;
    FDownSpeed: Integer;
    FFileStream: TFileStream;
    FboHeader: Boolean;
  public
    procedure Open(DownUrl: string);
  end;

var
  FormUpdate: TFormUpdate;

implementation

{$R *.dfm}

uses
  FrmMain, Hutil32, FShare, ShellAPI;

{ TFormUpdate }

procedure TFormUpdate.DSocketConnect(Sender: TObject; Socket: TCustomWinSocket);
begin
  LBHint.Caption := '连接更新服务器成功，正在创建下载文件...';
  FReadStr := '';
  FboHeader := False;
  TimerSpeed.Enabled := True;
  DSocket.Socket.SendText(FDownUrl);
end;

procedure TFormUpdate.DSocketDisconnect(Sender: TObject; Socket: TCustomWinSocket);
begin
  TimerSpeed.Enabled := False;
end;

procedure TFormUpdate.DSocketError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
  LBHint.Caption := '连接更新地址失败...';
  ErrorCode := 0;
end;

procedure TFormUpdate.DSocketRead(Sender: TObject; Socket: TCustomWinSocket);
const
  MAX_DOWNSIZE = 8192;
var
  Buffer: array[0..MAX_DOWNSIZE] of Char;
  nReadLength, nStrLength, nPos, nCode, nMaxLength: Integer;
  sHeaderStr, sStr, sDownPath: string;
begin
  nReadLength := Socket.ReceiveBuf(Buffer, MAX_DOWNSIZE);
  if not FboHeader then begin
    Buffer[nReadLength] := #0;
    nStrLength := Length(FReadStr);
    FReadStr := FReadStr + strpas(Buffer);
    nPos := pos(#13#10#13#10, FReadStr);
    if nPos > 0 then begin
      sHeaderStr := Copy(FReadStr, 1, nPos + 3);
      nMaxLength := Length(sHeaderStr);
      nCode := 0;
      while (sHeaderStr <> '') do begin
        sHeaderStr := GetValidStr3(sHeaderStr, sStr, [#13, #10]);
        if sStr = '' then break;
        if CompareLStr(sStr, 'HTTP/', Length('HTTP/')) then begin
          ArrestStringEx(sStr, ' ', ' ', sStr);
          nCode := StrToIntDef(sStr, 0);
        end;
        case nCode of
          302: begin
              LBHint.Caption := '更新已重定向，准备重新启动更新进程...';
              if CompareLStr(sStr, 'Location:', Length('Location:')) then begin
                sDownPath := GetValidStr3(sStr, sStr, [' ']);
                FDownUrl := 'http://' + FUrlHost + sDownPath;
                Timer1.Enabled := True;
                Socket.Close;
                Exit;
              end;
            end;
          200: begin
              if CompareLStr(sStr, 'Content-Length:', Length('Content-Length:')) then begin
                sStr := GetValidStr3(sStr, sDownPath, [' ']);
                FFileSize := StrToIntDef(sStr, 0);
                FFileWriteSize := 0;
                if FFileStream <> nil then FFileStream.Free;
                if FileExists(g_CurrentDir + DOWNFILENAME) then DeleteFile(g_CurrentDir + DOWNFILENAME);
                FFileStream := TFileStream.Create(g_CurrentDir + DOWNFILENAME, fmCreate);
                FFileStream.Seek(FFileSize - 1, soBeginning);
                FFileStream.Write(Buffer[nReadLength], 1);
                FFileStream.Seek(0, soBeginning);
                if nReadLength > (nMaxLength - nStrLength) then begin
                  FFileWriteSize := nReadLength - (nMaxLength - nStrLength);
                  FFileStream.Write(Buffer[nMaxLength - nStrLength], FFileWriteSize);
                end;
                FDownSpeed := 0;
                FOldFileWriteSize := 0;
                FboHeader := True;
                LBHint.Caption := '正在更新 ' + ExtractFileName(g_RunFileName);
              end;
            end;
        end;
      end;
    end;
  end else begin
    Inc(FFileWriteSize, nReadLength);
    if FFileStream <> nil then begin
      FFileStream.Write(Buffer, nReadLength);
      if FFileWriteSize = FFileSize then begin
        FboHeader := False;
        FReadStr := '';
        FFileStream.Free;
        FFileStream := nil;
        LBHint.Caption := '更新已完成，准备替换文件...';
        Socket.Close;
        Gauge.Value := 100;
        Caption := '下载完成';
        Application.Title := '下载完成';
        LBTime.Caption := '已完成';

        if FileExists(g_RunFileName + '.bak') then DeleteFile(PChar(g_RunFileName + '.bak'));
        RenameFile(g_RunFileName, g_RunFileName + '.bak');
        CopyFile(PChar(g_CurrentDir + DOWNFILENAME), PChar(g_RunFileName), False);
        DeleteFile(PChar(g_CurrentDir + DOWNFILENAME));
        PostMessage(Handle, WM_CLOSE, 0, 0);
        ShellExecute(0, 'open', PChar(g_RunFileName), '', nil, SW_SHOW);

      end;
    end;
  end;
end;

procedure TFormUpdate.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if FboHeader then begin
    if FormMain.DMsg.MessageDlg('正在更新，是否确认退出程序？', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      CanClose := True
    else
      CanClose := False;
  end;
end;

procedure TFormUpdate.FormCreate(Sender: TObject);
begin
  FFileStream := nil;
  DSkinData.SkinList := FormMain.CompressedSkinList;
end;

procedure TFormUpdate.Open(DownUrl: string);
begin
  FDownUrl := DownUrl;
  ClientHeight := 90;
  ClientWidth := 378;
  Gauge.StartProgressAnimation;
  Gauge.Value := 0;
  FboHeader := False;
  Timer1.Enabled := True;
  LBHint.Caption := '正在准备更新...';
  LBTime.Caption := '未知';
  LBSpeed.Caption := '0.00KB/秒';
  Caption := '自动更新';
  Application.Title := Caption;
  ShowModal;
end;

procedure TFormUpdate.Timer1Timer(Sender: TObject);
var
  sDownUrl, sDownPath, sUrlHost, sPort, sHost: string;
begin
  Timer1.Enabled := False;
  FboHeader := False;
  FReadStr := '';
  if CompareLStr(FDownUrl, 'HTTP://', Length('HTTP://')) then begin
    sDownUrl := Copy(FDownUrl, 8, Length(FDownUrl));
    sDownPath := '/' + GetValidStr3(sDownUrl, sUrlHost, ['/', '\']);
    if (sUrlHost <> '') and (sDownPath <> '') then begin
      if Pos(':', sUrlHost) > 0 then begin
        sPort := GetValidStr3(sUrlHost, sHost, [':']);
        DSocket.Port := StrToIntDef(sPort, 0);
      end else begin
        sHost := sUrlHost;
        DSocket.Port := 80;
      end;
      DSocket.Host := sHost;
      LBHint.Caption := '正在连接更新服务器...';
      DSocket.Active := True;
      FUrlHost := sUrlHost;
      FDownUrl := 'GET ' + sDownPath + ' HTTP/1.1' + #13#10;
      FDownUrl := FDownUrl + 'Accept: */*' + #13#10;
      FDownUrl := FDownUrl + 'UA-CPU: x86' + #13#10;
      FDownUrl := FDownUrl + 'Accept-Language: zh-cn' + #13#10;
      FDownUrl := FDownUrl + 'Accept-Encoding: gzip, deflate' + #13#10;
      FDownUrl := FDownUrl + 'User-Agent: Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; .NET CLR 2.0.50727)' + #13#10;
      FDownUrl := FDownUrl + 'Host: ' + sUrlHost + #13#10;
      FDownUrl := FDownUrl + 'Connection: Keep-Alive' + #13#10;
      FDownUrl := FDownUrl + #13#10;

      Exit;
    end;
    LBHint.Caption := '更新地址错误，更新失败...';
  end;
end;

procedure TFormUpdate.TimerSpeedTimer(Sender: TObject);
  function FormatValue(nValue: Integer): string;
  begin
    if nValue > 1024 * 800 then begin
      Result := Format('%.2f', [nValue / 1024 / 1024]) + 'M';
    end else
    if nValue > 800 then begin
      Result := Format('%.2f', [nValue / 1024]) + 'KB';
    end else begin
      Result := IntToStr(nValue) + 'B';
    end;
  end;
var
  nSpeed, nDownSize, nReadSize, nReadTime, nHour, nMin, nSec: Integer;
  sTime: string;
begin
  if FboHeader then begin
    Try
      nDownSize := FFileWriteSize - FOldFileWriteSize;
      LBSpeed.Caption := FormatValue(nDownSize) + '/秒';
      FOldFileWriteSize := FFileWriteSize;
      nSpeed := Round(FFileWriteSize / FFileSize * 100);
      if nSpeed <> FDownSpeed then begin
        FDownSpeed := nSpeed;
        Gauge.Value := FDownSpeed;
        Caption := '已完成 ' + IntToStr(FDownSpeed) + '%';
        Application.Title := '已完成 ' + IntToStr(FDownSpeed) + '%';
      end;
      nReadSize := FFileSize - FFileWriteSize;
      nReadTime := Round(nReadSize / (nDownSize));
      nHour := nReadTime div 60 div 60;
      nMin := nReadTime div 60 mod 60;
      nSec := nReadTime mod 60;
      sTime := '';
      if nHour > 0 then sTime := IntToStr(nHour) + '小时';
      if nMin > 0 then sTime := sTime + IntToStr(nMin) + '分';
      sTime := sTime + IntToStr(nSec) + '秒';
      LBTime.Caption := sTime + ' (已下载 ' + FormatValue(FFileWriteSize) + ' 总共 ' + FormatValue(FFileSize) + ')';

    Except
    end;
  end;
end;

end.
