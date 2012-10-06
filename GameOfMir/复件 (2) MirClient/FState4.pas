unit FState4;

interface

uses
  Windows, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, HGE, MNShare,   
  MShare, HGEGUI, WIL, HGETextures, Grobal2, Grids, Share, WMFile;

type
  TFrmDlg4 = class(TForm)
    DTopMsg: TDWindow;
    DWndItemRemove: TDWindow;
    DItemRemoveClose: TDButton;
    DItemRemoveArm: TDButton;
    DItemRemoveClose2: TDButton;
    DItemRemoveItems: TDGrid;
    DWndMagicKey: TDWindow;
    DMagicKeyF1: TDButton;
    DMagicKeyF2: TDButton;
    DMagicKeyF3: TDButton;
    DMagicKeyF4: TDButton;
    DMagicKeyF5: TDButton;
    DMagicKeyF6: TDButton;
    DMagicKeyF7: TDButton;
    DMagicKeyF8: TDButton;
    DMagicKeyF9: TDButton;
    DMagicKeyF10: TDButton;
    DMagicKeyF11: TDButton;
    DMagicKeyF12: TDButton;
    DMagicKeyF13: TDButton;
    DMagicKeyF14: TDButton;
    DMagicKeyF15: TDButton;
    DMagicKeyF16: TDButton;
    DMagicKeyNone: TDButton;
    DMagicKeyClose: TDButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure DTopMsgInRealArea(Sender: TObject; X, Y: Integer; var IsRealArea: Boolean);
    procedure DTopMsgDirectPaint(Sender: TObject; dsurface: TDXTexture);
    procedure DTopMsgVisible(Sender: TObject; boVisible: Boolean);
    procedure DItemRemoveCloseDirectPaint(Sender: TObject; dsurface: TDXTexture);
    procedure DItemRemoveCloseClickSound(Sender: TObject; Clicksound: TClickSound);
    procedure DItemRemoveCloseClick(Sender: TObject; X, Y: Integer);
    procedure DWndItemRemoveDirectPaint(Sender: TObject; dsurface: TDXTexture);
    procedure DWndItemRemoveVisible(Sender: TObject; boVisible: Boolean);
    procedure DItemRemoveArmDirectPaint(Sender: TObject; dsurface: TDXTexture);
    procedure DItemRemoveArmClick(Sender: TObject; X, Y: Integer);
    procedure DItemRemoveArmMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure DItemRemoveItemsGridPaint(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState; dsurface: TDXTexture);
    procedure DItemRemoveItemsGridMouseMove(Sender: TObject; X, Y, ACol, ARow: Integer; Shift: TShiftState);
    procedure DItemRemoveItemsGridSelect(Sender: TObject; X, Y, ACol, ARow: Integer; Shift: TShiftState);
    procedure DWndMagicKeyDirectPaint(Sender: TObject; dsurface: TDXTexture);
    procedure DMagicKeyF1DirectPaint(Sender: TObject; dsurface: TDXTexture);
    procedure DMagicKeyF1Click(Sender: TObject; X, Y: Integer);
    procedure DMagicKeyCloseClick(Sender: TObject; X, Y: Integer);
  private

  public
    FRemoveStoneLock: Boolean;
    FRemoveStoneItem: TMovingItem;
    FRemoveStoneShowEffect: Boolean;
    FRemoveStoneShowEffectIdx: Integer;
    FRemoveStoneIndex: Integer;
    FRemoveStoneIdx: Byte;
    FMagicKeyIndex: Byte;
    FMagidID: Integer;

    m_TopMsgList: TStringList;
    procedure Initialize;
    procedure InitializeEx();
    function CanItemRemoveStoneAdd(Item: pTNewClientItem): Boolean;
    procedure ItemRemoveStoneAdd(nItemIndex: Integer);
  end;

var
  FrmDlg4: TFrmDlg4;

implementation

uses
  SoundUtil, ClMain, DrawScrn, ClFunc, HUtil32, FState, HGEBase;

{$R *.dfm}

function TFrmDlg4.CanItemRemoveStoneAdd(Item: pTNewClientItem): Boolean;
var
  I: Integer;
begin
  Result := False;
  if FRemoveStoneLock or g_boItemMoving then exit;
  if sm_ArmingStrong in Item.s.StdModeEx then begin
    for I := 0 to Item.UserItem.Value.btFluteCount - 1 do begin
      if Item.UserItem.Value.wFlute[I] > 0 then begin
        Result := True;
        Break;
      end;
    end;
  end;
end;

procedure TFrmDlg4.DItemRemoveArmClick(Sender: TObject; X, Y: Integer);
var
  I: Integer;
begin
  if FRemoveStoneLock then exit;
  if not g_boItemMoving then begin
    if FRemoveStoneItem.Item.s.Name <> '' then
      AddItemBag(FRemoveStoneItem.Item, FRemoveStoneItem.Index2);
    SafeFillChar(FRemoveStoneItem, SizeOf(FRemoveStoneItem), #0);
  end
  else if g_boItemMoving and (g_MovingItem.ItemType = mtBagItem) and (g_MovingItem.Item.s.Name <> '') then begin
    if sm_ArmingStrong in g_MovingItem.Item.s.StdModeEx then begin
      if g_MovingItem.Item.UserItem.Value.btFluteCount > 0 then begin
        for I := 0 to g_MovingItem.Item.UserItem.Value.btFluteCount - 1 do begin
          if g_MovingItem.Item.UserItem.Value.wFlute[I] > 0 then begin
            if FRemoveStoneItem.Item.s.Name <> '' then
              AddItemBag(FRemoveStoneItem.Item, FRemoveStoneItem.Index2);
            FRemoveStoneItem := g_MovingItem;
            g_boItemMoving := False;
            g_MovingItem.Item.s.Name := '';
            Exit;
          end;
        end;
        FrmDlg.CancelItemMoving;
        FrmDlg.DMessageDlg('该件装备没有可以卸下的宝石.', []);
      end else begin
        FrmDlg.CancelItemMoving;
        FrmDlg.DMessageDlg('该件装备没有凹槽.', []);
      end;
    end
    else begin
      FrmDlg.CancelItemMoving;
    end;
  end;
end;

procedure TFrmDlg4.DItemRemoveArmDirectPaint(Sender: TObject; dsurface: TDXTexture);
var
  d: TDXTexture;
  ax, ay{, px, py}: integer;
  pRect: TRect;
begin
  with Sender as TDButton do begin
    ax := SurfaceX(Left);
    ay := SurfaceY(Top);
    if FRemoveStoneItem.Item.s.Name <> '' then begin
      d := GetBagItemImg(FRemoveStoneItem.Item.S.looks);
      pRect.Left := ax;
      pRect.Top := ay;
      pRect.Right := ax + Width + 1;
      pRect.Bottom := ay + Height;
      if d <> nil then
        FrmDlg.RefItemPaint(dsurface, d, //人物背包栏
          ax + (Width - d.Width) div 2,
          ay + (Height - d.Height) div 2,
          Width,
          Height,
          @FRemoveStoneItem.Item, False, [pmShowLevel], @pRect);
    end;{
    else if g_boItemMoving and (g_MovingItem.ItemType = mtBagItem) and (g_MovingItem.Item.S.name <> '') then begin
      if (sm_ArmingStrong in g_MovingItem.Item.s.StdModeEx) and
        CheckByteStatus(g_MovingItem.Item.UserItem.btBindMode2, Ib2_Unknown) then begin
        d := g_WMain3Images.Images[600 + (gettickcount - AppendTick) div 200 mod 2];
        if d <> nil then
          DrawBlend(dsurface, SurfaceX(Left) - 12, SurfaceY(Top) - 11, d, 1);
      end;
    end;
    if FUnsealShowEffect then begin
      if GetTickCount >= FUnSealShowTick then begin
        FUnSealShowTick := GetTickCount + 80;
        Inc(FUnsealShowIndex);
      end;
      d := g_WMain99Images.GetCachedImage(1188 + FUnsealShowIndex, px, py);
      if d <> nil then
        dsurface.Draw(ax + px - 113, ay + py - 113, d.ClientRect, d, True);

      if FUnsealShowIndex >= 29 then begin
        FUnsealLock := False;
        FUnsealShowEffect := False;
      end;
    end;  }
  end;
end;

procedure TFrmDlg4.DItemRemoveArmMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  nLocalX, nLocalY: Integer;
  nHintX, nHintY: Integer;
begin
  with Sender as TDButton do begin
    nLocalX := LocalX(X - Left);
    nLocalY := LocalY(Y - Top);
    nHintX := SurfaceX(Left) + DParent.SurfaceX(DParent.Left) + nLocalX + 30;
    nHintY := SurfaceY(Top) + DParent.SurfaceY(DParent.Top) + nLocalY + 30;
    if FRemoveStoneItem.Item.s.Name <> '' then
      DScreen.ShowHint(nHintX, nHintY, ShowItemInfo(FRemoveStoneItem.Item, [mis_ArmStrengthen], []),
        clwhite, False, Tag, True);
  end;
end;

procedure TFrmDlg4.DItemRemoveCloseClick(Sender: TObject; X, Y: Integer);
begin
  if FRemoveStoneLock then exit;
  DWndItemRemove.Visible := False;
end;

procedure TFrmDlg4.DItemRemoveCloseClickSound(Sender: TObject; Clicksound: TClickSound);
begin
  case Clicksound of
    csNorm: PlaySound(s_norm_button_click);
    csStone: PlaySound(s_rock_button_click);
    csGlass: PlaySound(s_glass_button_click);
  end;
end;

procedure TFrmDlg4.DItemRemoveCloseDirectPaint(Sender: TObject; dsurface: TDXTexture);
var
  d: TDXTexture;
{$IF Var_Interface = Var_Default}
  idx: integer;
{$IFEND}
begin
{$IF Var_Interface = Var_Mir2}
  with Sender as TDButton do begin
    if WLib <> nil then begin
      if Downed then begin
        d := WLib.Images[FaceIndex];
        if d <> nil then
          dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);
      end;
    end;
  end;
{$ELSE}
  with Sender as TDButton do begin
    if WLib <> nil then begin
      idx := 0;
      if Downed then begin
        inc(idx, 2)
      end
      else if MouseEntry = msIn then begin
        Inc(idx, 1)
      end;
      d := WLib.Images[FaceIndex + idx];
      if d <> nil then
        dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);
    end;
  end;
{$IFEND}
end;

procedure TFrmDlg4.DItemRemoveItemsGridMouseMove(Sender: TObject; X, Y, ACol, ARow: Integer; Shift: TShiftState);
var
  idx: Integer;
  Item: TNewClientItem;
begin
  with Sender as TDGrid do begin
    idx := ACol + ARow * ColCount;
    if idx >= FRemoveStoneItem.Item.UserItem.Value.btFluteCount then Exit;
    if idx in [Low(FRemoveStoneItem.Item.UserItem.Value.wFlute)..High(FRemoveStoneItem.Item.UserItem.Value.wFlute)] then begin
      if (FRemoveStoneItem.Item.S.name <> '') and (FRemoveStoneItem.Item.UserItem.Value.wFlute[idx] > 0) then begin
        Fillchar(Item, SizeOf(Item), #0);
        Item.s := GetStditem(FRemoveStoneItem.Item.UserItem.Value.wFlute[idx]);
        Item.UserItem.MakeIndex := 0;
        Item.UserItem.wIndex := FRemoveStoneItem.Item.UserItem.Value.wFlute[idx];

        DScreen.ShowHint(SurfaceX(Left + (x - left)) + 30, SurfaceY(Top + (y - Top) + 30),
          ShowItemInfo(Item, [], []), clwhite, False, idx, True);
      end;
    end;
  end;
end;

procedure TFrmDlg4.DItemRemoveItemsGridPaint(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState; dsurface: TDXTexture);
var
  d: TDXTexture;
  idx: Integer;
  Item: TNewClientItem;
begin
  with Sender as TDGrid do begin
    idx := ACol + ARow * ColCount;
    if idx >= FRemoveStoneItem.Item.UserItem.Value.btFluteCount then Exit;
    if idx in [Low(FRemoveStoneItem.Item.UserItem.Value.wFlute)..High(FRemoveStoneItem.Item.UserItem.Value.wFlute)] then begin
      if (FRemoveStoneItem.Item.S.name <> '') and (FRemoveStoneItem.Item.UserItem.Value.wFlute[idx] > 0) then begin

        Fillchar(Item, SizeOf(Item), #0);
        Item.s := GetStditem(FRemoveStoneItem.Item.UserItem.Value.wFlute[idx]);
        Item.UserItem.MakeIndex := 0;
        Item.UserItem.wIndex := FRemoveStoneItem.Item.UserItem.Value.wFlute[idx];
        if Item.S.Name <> '' then begin
          d := GetBagItemImg(Item.S.looks);
          if d <> nil then begin
            FrmDlg.RefItemPaint(dsurface, d, //人物背包栏
              SurfaceX(Rect.Left + (ColWidth - d.Width) div 2 { - 1}),
              SurfaceY(Rect.Top + (RowHeight - d.Height) div 2 { + 1}),
              SurfaceX(Rect.Right),
              SurfaceY(Rect.Bottom) - 12,
              @Item);
          end;
        end;

        if FRemoveStoneShowEffect and (idx = FRemoveStoneIdx) then begin
          if (GetTickCount - DItemRemoveItems.AppendTick) > 54 then begin
            DItemRemoveItems.AppendTick := GetTickCount;
            Inc(FRemoveStoneShowEffectIdx);
            if FRemoveStoneShowEffectIdx >= 25 then begin
              FRemoveStoneShowEffect := False;
              DelItemBag(g_SendRemoveStoneItem.UserItem.wIndex, g_SendRemoveStoneItem.UserItem.MakeIndex);
              AddNewItemToBagByIdx(FRemoveStoneItem.Item.UserItem.Value.wFlute[FRemoveStoneIdx], FRemoveStoneIndex);
              FRemoveStoneItem.Item.UserItem.Value.wFlute[FRemoveStoneIdx] := 0;
              FRemoveStoneLock := False;
              g_SendRemoveStoneItem.s.name := '';
            end;
          end;
          d := g_WMain99Images.Images[1459 + FRemoveStoneShowEffectIdx mod 7];
          if d <> nil then begin
            dsurface.Draw(SurfaceX(Rect.Left) + 1, SurfaceY(Rect.Top) + 1, d.ClientRect, d, True);
          end;
        end;
      end; { else
      if g_boItemMoving and (g_MovingItem.ItemType = mtBagItem) and (g_MovingItem.Item.S.name <> '') then begin
        if (tm_MakeStone = g_MovingItem.Item.s.StdMode) and (g_MovingItem.Item.s.Shape in [1, 2]) then begin
          d := g_WMain3Images.Images[600 + (gettickcount - AppendTick) div 200 mod 2];
          if d <> nil then
            DrawBlend(dsurface, SurfaceX(Rect.Left) - 11, SurfaceY(Rect.Top) - 11, d, 1);
        end;
      end; }
    end;
  end;
end;

procedure TFrmDlg4.DItemRemoveItemsGridSelect(Sender: TObject; X, Y, ACol, ARow: Integer; Shift: TShiftState);
var
  idx: Integer;
begin
  if FRemoveStoneLock then exit;
  with Sender as TDGrid do begin
    idx := ACol + ARow * ColCount;
    if idx >= FRemoveStoneItem.Item.UserItem.Value.btFluteCount then Exit;
    if idx in [Low(FRemoveStoneItem.Item.UserItem.Value.wFlute)..High(FRemoveStoneItem.Item.UserItem.Value.wFlute)] then begin
      if not g_boItemMoving then begin
        if (FRemoveStoneItem.Item.S.name <> '') and (FRemoveStoneItem.Item.UserItem.Value.wFlute[idx] > 0) then begin
          if (g_CursorMode = cr_Srepair) and (g_RemoveStoneItem.s.Name <> '') and (g_SendRemoveStoneItem.s.name = '') then begin
            g_SendRemoveStoneItem := g_RemoveStoneItem;
            FRemoveStoneLock := True;
            FrmMain.SendClientMessage(CM_REMOVESTONE, g_RemoveStoneItem.UserItem.MakeIndex,
              LoWord(FRemoveStoneItem.Item.UserItem.MakeIndex),
              HiWord(FRemoveStoneItem.Item.UserItem.MakeIndex), idx, '');
            {g_CursorMode := cr_None;
            Cursor := crMyNone; }

          end else
            FrmDlg.DMessageDlg('请先使用卸下宝石的道具.', []);
        end;
      end;
    end;
  end;
end;

procedure TFrmDlg4.DMagicKeyCloseClick(Sender: TObject; X, Y: Integer);
var
  I: Integer;
begin
  if FMagicKeyIndex > 0 then begin

    for I := Low(g_MyMagicArry) to High(g_MyMagicArry) do
      if g_MyMagicArry[I].btKey = FMagicKeyIndex then begin
        g_MyMagicArry[I].btKey := 0;
        FrmMain.SendClientMessage(CM_SETMAGICKEY, I, 0, 0, 0, '');
      end;
  end;
      
  g_MyMagicArry[FMagidID].btKey := FMagicKeyIndex;
  FrmMain.SendClientMessage(CM_SETMAGICKEY, FMagidID, FMagicKeyIndex, 0, 0, '');
  DWndMagicKey.Visible := False;
end;

procedure TFrmDlg4.DMagicKeyF1Click(Sender: TObject; X, Y: Integer);
begin
  with Sender as TDButton do begin
    FMagicKeyIndex := Tag;
  end;
end;

procedure TFrmDlg4.DMagicKeyF1DirectPaint(Sender: TObject; dsurface: TDXTexture);
var
  d: TDXTexture;
begin
  with Sender as TDButton do begin
    if WLib <> nil then begin
      d := nil;
      if FMagicKeyIndex = Tag then begin
        d := WLib.Images[FaceIndex + 1];
      end else
      if Downed then begin
        d := WLib.Images[FaceIndex];
      end;
      if d <> nil then
        dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);
    end;
  end;
end;

procedure TFrmDlg4.DTopMsgDirectPaint(Sender: TObject; dsurface: TDXTexture);
var
  ax, ay: integer;
  nParam: Integer;
  wFontWidth: Word;
  wIndex: Word;
  nLeft: Integer;
  WideStr: WideString;
  I: Integer;
  tStr, AddStr, cmdstr, sbcolor, sfcolor: string;
  boBeginColor: Boolean;
  nFColor, nBColor: TColor;
begin
  with Sender as TDWindow do begin
    if Surface = nil then Exit;

    ax := SurfaceX(Left);
    ay := SurfaceY(Top);
    g_DXCanvas.FillRect(ax, ay, Width, Height, $99080808);
    if m_TopMsgList.Count > 0 then begin
      WideStr := m_TopMsgList[0];
      nParam := Integer(m_TopMsgList.Objects[0]);
      if nParam = 0 then begin
        wFontWidth := g_DXCanvas.TextWidth(m_TopMsgList[0]) + 4 + Width;
        wIndex := 0;
        AppendTick := 0;
      end else begin
        wFontWidth := LoWord(nParam);
        wIndex := HiWord(nParam);
      end;
      if GetTickCount > AppendTick then begin
        AppendTick := GetTickCount + 20;
        Surface.Clear;
        Inc(wIndex);
        if wIndex > (wFontWidth * 2) then begin
          m_TopMsgList.Delete(0);
          Exit;
        end;
        m_TopMsgList.Objects[0] := TObject(MakeLong(wFontWidth, wIndex));
        nLeft := Width - (wIndex mod wFontWidth);
        boBeginColor := False;
        AddStr := '';
        cmdstr := '';
        nFColor := $CCFFFF;
        nBColor := 0;

        for I := 1 to Length(WideStr) do begin
          tStr := WideStr[i];
          if boBeginColor then begin
            if tstr = #6 then begin
              boBeginColor := False;
              sbcolor := GetValidStr3(cmdstr, sfcolor, ['/']);
              nFColor := StrToIntDef('$' + sfcolor, $CCFFFF);
              nBColor := StrToIntDef('$' + sbcolor, 0);
              cmdstr := '';
            end else cmdstr := cmdstr + tstr;
          end else begin
            if tstr = #6 then begin
              boBeginColor := True;
              Surface.TextOutEx(nLeft, 2, AddStr, nFColor, nBColor);
              Inc(nLeft, g_DXCanvas.TextWidth(AddStr));
              AddStr := '';
              cmdstr := '';
            end else
            if tstr = #5 then begin
              Surface.TextOutEx(nLeft, 2, AddStr, nFColor, nBColor);
              Inc(nLeft, g_DXCanvas.TextWidth(AddStr));
              AddStr := '';
              cmdstr := '';
              nFColor := $CCFFFF;
              nBColor := 0;
            end else AddStr := AddStr + tstr;
          end;
        end;
        if AddStr <> '' then begin
          Surface.TextOutEx(nLeft, 2, AddStr, nFColor, nBColor);
        end;
      end;
      dsurface.Draw(ax, ay, Surface.ClientRect, Surface, fxBlend);
    end else Visible := False;
  end;

end;

procedure TFrmDlg4.DTopMsgInRealArea(Sender: TObject; X, Y: Integer; var IsRealArea: Boolean);
begin
  IsRealArea := False;
end;

procedure TFrmDlg4.DTopMsgVisible(Sender: TObject; boVisible: Boolean);
begin
  DTopMsg.Surface.Clear;
end;

procedure TFrmDlg4.DWndItemRemoveDirectPaint(Sender: TObject; dsurface: TDXTexture);
var
  d: TDXTexture;
  ax, ay: integer;
begin
  with Sender as TDWindow do begin
    ax := SurfaceX(Left);
    ay := SurfaceY(Top);
    d := WLib.Images[FaceIndex];
    if d <> nil then
      DrawWindow(dsurface, ax, ay, d);

{$IF Var_Interface = Var_Default}
    with g_DXCanvas do begin
      TextOut(ax + Width div 2 - TextWidth(Caption) div 2, ay + 12, $B1D2B7, Caption);
    end;
{$IFEND}
    {DItemUnsealClose2.Enabled := not FUnsealLock;
    DItemUnsealOK.Enabled := (FUnsealItem.Item.s.Name <> '') and (not FUnsealLock) and
      CheckByteStatus(FUnsealItem.Item.UserItem.btBindMode2, Ib2_Unknown);  }
    {FUnsealLock := True;
    FUnsealShowEffect := True;
    FUnsealShowIndex := 0;
    FUnSealShowTick := GetTickCount; }
  end;
end;

procedure TFrmDlg4.DWndItemRemoveVisible(Sender: TObject; boVisible: Boolean);
begin
  if FRemoveStoneItem.Item.s.Name <> '' then
    AddItemBag(FRemoveStoneItem.Item, FRemoveStoneItem.Index2);
  FRemoveStoneItem.Item.s.Name := '';
  g_SendRemoveStoneItem.s.Name := '';
  FRemoveStoneLock := False;
  FRemoveStoneShowEffect := False;
  FrmDlg.LastestClickTime := GetTickCount;
  if boVisible then begin
    FrmDlg.DItemBag.Visible := True;
    FrmDlg.DMerchantDlg.Visible := False;
  end
  else begin
    FrmDlg.DItemBag.Visible := FrmDlg.boOpenItemBag;
    //FrmDlg.DMerchantDlg.Visible := FrmDlg.MDlgVisible;
  end;
end;

procedure TFrmDlg4.DWndMagicKeyDirectPaint(Sender: TObject; dsurface: TDXTexture);
var
  d: TDXTexture;
  ax, ay: integer;
  Magic: TClientDefMagic;
begin
  with Sender as TDWindow do begin
    ax := SurfaceX(Left);
    ay := SurfaceY(Top);
    d := WLib.Images[FaceIndex];
    if d <> nil then
      DrawWindow(dsurface, ax, ay, d);
    Magic := GetMagicInfo(FMagidID);
    if Magic.Magic.sMagicName <> '' then begin
    
      if Magic.Magic.wMagicIcon > 30000 then d := g_WMagIconImages.Images[Magic.Magic.wMagicIcon - 30000]
      else if Magic.Magic.wMagicIcon > 20000 then d := g_WDefMagIcon2Images.Images[Magic.Magic.wMagicIcon - 20000]
      else if Magic.Magic.wMagicIcon > 10000 then d := g_WDefMagIconImages.Images[Magic.Magic.wMagicIcon - 10000]
      else d := GetDefMagicIcon(@Magic);
      
      if d <> nil then begin
        dsurface.Draw(ax + 49, ay + 29, d.ClientRect, d, False);
      end;
    end;
  end;
end;

procedure TFrmDlg4.FormCreate(Sender: TObject);
begin
  m_TopMsgList := TStringList.Create;
  FMagicKeyIndex := 0;
  FMagidID := 0;
end;

procedure TFrmDlg4.FormDestroy(Sender: TObject);
begin
  m_TopMsgList.Free;
end;

procedure TFrmDlg4.Initialize;
var
  d: TDirectDrawSurface;
  i: Integer;
  dcon: TDControl;
begin
  for i := 0 to ComponentCount - 1 do begin
    if (Components[i] is TDWindow) or (Components[i] is TDPopUpMemu) then begin
      dcon := TDControl(Components[i]);
      if dcon.DParent = nil then begin
        dcon.DParent := FrmDlg.DBackground;
        FrmDlg.DBackground.AddChild(dcon);
      end;
    end;
  end;

  //顶部公告
{$IF Var_Interface = Var_Mir2}
  DTopMsg.Left := 260;
  DTopMsg.Top := 0;
  DTopMsg.Width := 280;
  DTopMsg.Height := 16;
{$ELSE}
  DTopMsg.Left := 224;
  DTopMsg.Top := 37;
  DTopMsg.Width := 280;
  DTopMsg.Height := 16;
{$IFEND}


  //装备宝石取下
{$IF Var_Interface = Var_Mir2}
  d := g_WMain99Images.Images[1706];
  if d <> nil then begin
    DWndItemRemove.SetImgIndex(g_WMain99Images, 1706);
    DWndItemRemove.Left := 0;
    DWndItemRemove.Top := 60;
  end;
  DItemRemoveClose.SetImgIndex(g_WMainImages, 64);
  DItemRemoveClose.Left := 262;
  DItemRemoveClose.Top := 24;

  DItemRemoveArm.Top := 36;
  DItemRemoveArm.Left := 130;
  DItemRemoveArm.Width := 33;
  DItemRemoveArm.Height := 31;

  DItemRemoveItems.Top := 173;
  DItemRemoveItems.Left := 57;
  DItemRemoveItems.Width := 179;
  DItemRemoveItems.Height := 31;
  DItemRemoveItems.ColWidth := 33;
  DItemRemoveItems.Coloffset := 40;
  DItemRemoveItems.RowHeight := 31;

  DItemRemoveClose2.SetImgIndex(g_WMain99Images, 1711);
  DItemRemoveClose2.Left := 111;
  DItemRemoveClose2.Top := 224;
  DItemRemoveClose2.OnDirectPaint := DItemRemoveCloseDirectPaint;
{$ELSE}
  d := g_WMain99Images.Images[1458];
  if d <> nil then begin
    DWndItemRemove.SetImgIndex(g_WMain99Images, 1458);
    DWndItemRemove.Left := 0;
    DWndItemRemove.Top := 90;
  end;
  DItemRemoveClose.SetImgIndex(g_WMain99Images, 133);
  DItemRemoveClose.Left := DWndItemRemove.Width - 20;
  DItemRemoveClose.Top := 8 + 4;

  DItemRemoveArm.Top := 62;
  DItemRemoveArm.Left := 135;
  DItemRemoveArm.Width := 36;
  DItemRemoveArm.Height := 36;

  DItemRemoveItems.Top := 198;
  DItemRemoveItems.Left := 55;
  DItemRemoveItems.Width := 196;
  DItemRemoveItems.Height := 36;

  DItemRemoveClose2.SetImgIndex(g_WMain99Images, 156);
  DItemRemoveClose2.Left := (DWndItemRemove.Width - DItemRemoveClose2.Width) div 2;
  DItemRemoveClose2.Top := 288;  
{$IFEND}

  //技能快捷键

  d := g_WMain3Images.Images[126];
  if d <> nil then begin
    DWndMagicKey.SetImgIndex(g_WMain3Images, 126);
    DWndMagicKey.Left := (SCREENWIDTH - d.Width) div 2;
    DWndMagicKey.Top := (SCREENHEIGHT - d.Height) div 2;
  end;

  DMagicKeyF1.SetImgIndex(g_WMainImages, 232);
  DMagicKeyF1.Left := 25;
  DMagicKeyF1.Top := 78;
  DMagicKeyF2.SetImgIndex(g_WMainImages, 234);
  DMagicKeyF2.Left := 57;
  DMagicKeyF2.Top := 78;
  DMagicKeyF3.SetImgIndex(g_WMainImages, 236);
  DMagicKeyF3.Left := 89;
  DMagicKeyF3.Top := 78;
  DMagicKeyF4.SetImgIndex(g_WMainImages, 238);
  DMagicKeyF4.Left := 121;
  DMagicKeyF4.Top := 78;

  DMagicKeyF5.SetImgIndex(g_WMainImages, 240);
  DMagicKeyF5.Left := 160;
  DMagicKeyF5.Top := 78;
  DMagicKeyF6.SetImgIndex(g_WMainImages, 242);
  DMagicKeyF6.Left := 192;
  DMagicKeyF6.Top := 78;
  DMagicKeyF7.SetImgIndex(g_WMainImages, 244);
  DMagicKeyF7.Left := 224;
  DMagicKeyF7.Top := 78;
  DMagicKeyF8.SetImgIndex(g_WMainImages, 246);
  DMagicKeyF8.Left := 256;
  DMagicKeyF8.Top := 78;

  DMagicKeyF9.SetImgIndex(g_WMain3Images, 132);
  DMagicKeyF9.Left := 25;
  DMagicKeyF9.Top := 120;
  DMagicKeyF10.SetImgIndex(g_WMain3Images, 134);
  DMagicKeyF10.Left := 57;
  DMagicKeyF10.Top := 120;
  DMagicKeyF11.SetImgIndex(g_WMain3Images, 136);
  DMagicKeyF11.Left := 89;
  DMagicKeyF11.Top := 120;
  DMagicKeyF12.SetImgIndex(g_WMain3Images, 138);
  DMagicKeyF12.Left := 121;
  DMagicKeyF12.Top := 120;

  DMagicKeyF13.SetImgIndex(g_WMain3Images, 140);
  DMagicKeyF13.Left := 160;
  DMagicKeyF13.Top := 120;
  DMagicKeyF14.SetImgIndex(g_WMain3Images, 142);
  DMagicKeyF14.Left := 192;
  DMagicKeyF14.Top := 120;
  DMagicKeyF15.SetImgIndex(g_WMain3Images, 144);
  DMagicKeyF15.Left := 224;
  DMagicKeyF15.Top := 120;
  DMagicKeyF16.SetImgIndex(g_WMain3Images, 146);
  DMagicKeyF16.Left := 256;
  DMagicKeyF16.Top := 120;

  DMagicKeyNone.SetImgIndex(g_WMain3Images, 129);
  DMagicKeyNone.Left := 296;
  DMagicKeyNone.Top := 78;

  DMagicKeyClose.SetImgIndex(g_WMain3Images, 127);
  DMagicKeyClose.Left := 295;
  DMagicKeyClose.Top := 118;
end;

procedure TFrmDlg4.InitializeEx;
begin
  DTopMsg.CreateSurface(nil);
end;

procedure TFrmDlg4.ItemRemoveStoneAdd(nItemIndex: Integer);
var
  I: Integer;
begin
  if FRemoveStoneLock or g_boItemMoving then exit;
  if g_ItemArr[nItemIndex].UserItem.Value.btFluteCount > 0 then begin
    for I := 0 to g_ItemArr[nItemIndex].UserItem.Value.btFluteCount - 1 do begin
      if g_ItemArr[nItemIndex].UserItem.Value.wFlute[I] > 0 then begin
        g_boItemMoving := True;
        g_MovingItem.Index2 := nItemIndex;
        g_MovingItem.Item := g_ItemArr[nItemIndex];
        g_MovingItem.ItemType := mtBagItem;
        DelItemBagByIdx(nItemIndex);
        ItemClickSound(g_ItemArr[nItemIndex].S);
        DItemRemoveArmClick(DItemRemoveArm, 0, 0);
        Exit;
      end;
    end;
  end;
end;

end.
