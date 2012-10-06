unit FrmBindTool;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, bsSkinData, bsSkinCtrls, StdCtrls, Mask, bsSkinBoxCtrls, ComCtrls;

type
  TFrameBindTool = class(TFrame)
    GroupBoxBg: TbsSkinGroupBox;
    GroupBoxMD5: TbsSkinGroupBox;
    DSkinData: TbsSkinData;
    ButtonChangeBind: TbsSkinButton;
    ButtonFindBind: TbsSkinButton;
    bsSkinGroupBox4: TbsSkinGroupBox;
    ListViewBindList: TbsSkinListView;
    ScrollBarStdItemsBottom: TbsSkinScrollBar;
    ScrollBarStditemsRight: TbsSkinScrollBar;
    LabelUpLog: TbsSkinTextLabel;
    procedure ButtonFindBindClick(Sender: TObject);
    procedure ButtonChangeBindClick(Sender: TObject);
  private
    { Private declarations }
  public
    procedure Open();
    procedure IsLock(boLock: Boolean);
    procedure GetBindList(body: string);
    procedure ChangeBindList(body: string);
  end;

implementation

{$R *.dfm}

uses
  FrmMain, EDCode, SCShare, FShare, Hutil32;

{ TFrameBindTool }

procedure TFrameBindTool.ButtonChangeBindClick(Sender: TObject);
var
  DefMsg: TDefaultMessage;
  Item: TListItem;
  sShowMsg: string;
begin
  if ListViewBindList.ItemIndex = -1 then begin
    FormMain.DMsg.MessageDlg('请先选择要更换绑定的服务器！', mtError, [mbYes], 0);
    Exit;
  end;

  if not g_boConnect then begin
    FormMain.DMsg.MessageDlg('与远程服务器连接断开中，正在重试连接，请稍候..！', mtError, [mbYes], 0);
    Exit;
  end;
  Item := ListViewBindList.Items[ListViewBindList.ItemIndex];
  sShowMsg := '是否确定取消IP[' + Item.SubItems[0] + ']机器名[' + Item.SubItems[1] + ']的绑定状态？'#13#10;
  //sShowMsg := sShowMsg + '该操作成功后不可恢复！'#13#10;
  sShowMsg := sShowMsg + '该操作成功后将取消该服务器的绑定信息，减少一次可更换次数，增加一次可绑定次数！'#13#10#13#10;
  sShowMsg := sShowMsg + '该操作是用于更换服务器绑定状态，如果你不清楚用途请不要使用！否则后果自负！';
  if FormMain.DMsg.MessageDlg(sShowMsg, mtConfirmation, [mbYes, mbNo], 0) = mrYes then begin
    IsLock(True);
    FormMain.ShowHint('正在提交信息给服务器处理，请稍候...');
    DefMsg := MakeDefaultMsg(CM_TOOLS_CHANGEBINDINFO, StrToIntDef(Item.Caption, 0), 0, 0, 0);
    FormMain.SendSocket(EncodeMessage(DefMsg));
  end;
end;

procedure TFrameBindTool.ButtonFindBindClick(Sender: TObject);
var
  DefMsg: TDefaultMessage;
begin
  if not g_boConnect then begin
    FormMain.DMsg.MessageDlg('与远程服务器连接断开中，正在重试连接，请稍候..！', mtError, [mbYes], 0);
    Exit;
  end;
  IsLock(True);
  FormMain.ShowHint('正在查询绑定列表，请稍候...');
  DefMsg := MakeDefaultMsg(CM_TOOLS_GETBINDLIST, 0, 0, 0, 0);
  FormMain.SendSocket(EncodeMessage(DefMsg));
end;

procedure TFrameBindTool.ChangeBindList(body: string);
var
  UserBindInfo: TUserBindInfo;
  sMsg: string;
  Item: TListItem;
begin
  FormMain.DMsg.MessageDlg('更改成功！已减少一次可更换次数，增加一次可绑定次数。', mtInformation, [mbYes], 0);
  IsLock(False);
  ListViewBindList.Items.Clear;
  while True do begin
    if body = '' then break;
    body := GetValidStr3(body, sMsg, ['/']);
    DecodeBuffer(sMsg, @UserBindInfo, SizeOf(UserBindInfo));
    Item := ListViewBindList.Items.Add;
    Item.Caption := IntToStr(UserBindInfo.ID);
    Item.SubItems.Add(UserBindInfo.IPAddres);
    Item.SubItems.Add(UserBindInfo.PCName);
    Item.SubItems.Add(FormatDateTime('YYYY-MM-DD HH:MM:SS', UserBindInfo.CreateTime));
  end;

end;

procedure TFrameBindTool.GetBindList(body: string);
var
  UserBindInfo: TUserBindInfo;
  sMsg: string;
  Item: TListItem;
begin
  IsLock(False);
  ListViewBindList.Items.Clear;
  while True do begin
    if body = '' then break;
    body := GetValidStr3(body, sMsg, ['/']);
    DecodeBuffer(sMsg, @UserBindInfo, SizeOf(UserBindInfo));
    Item := ListViewBindList.Items.Add;
    Item.Caption := IntToStr(UserBindInfo.ID);
    Item.SubItems.Add(UserBindInfo.IPAddres);
    Item.SubItems.Add(UserBindInfo.PCName);
    Item.SubItems.Add(FormatDateTime('YYYY-MM-DD HH:MM:SS', UserBindInfo.CreateTime));
  end;
end;

procedure TFrameBindTool.IsLock(boLock: Boolean);
begin
  FormMain.Lock(boLock);
  ButtonFindBind.Enabled := not boLock;
  ButtonChangeBind.Enabled := not boLock;
  ListViewBindList.Enabled := not boLock;
end;

procedure TFrameBindTool.Open;
begin
  //
end;

end.
