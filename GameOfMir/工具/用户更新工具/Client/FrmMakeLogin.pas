unit FrmMakeLogin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, GraphicEx, Controls, Forms, Share, JPEG, ZLIB,  
  Dialogs, bsSkinData, bsSkinCtrls, StdCtrls, Mask, bsSkinBoxCtrls, ExtCtrls, bsPngImageList, EzRgnBtn, RzStatus, RzLabel, bsColorCtrls, Graphics;

type
  TFrameMakeLogin = class(TFrame)
    DSkinData: TbsSkinData;
    GroupBoxBg: TbsSkinGroupBox;
    bsSkinGroupBox3: TbsSkinGroupBox;
    bsSkinGroupBox1: TbsSkinGroupBox;
    bsSkinGroupBox2: TbsSkinGroupBox;
    bsSkinGroupBox4: TbsSkinGroupBox;
    ButtonSave: TbsSkinButton;
    bsSkinButton1: TbsSkinButton;
    ScrollBarRight: TbsSkinScrollBar;
    ScrollBoxBg: TbsSkinScrollBox;
    ScrollBarBottom: TbsSkinScrollBar;
    imgBG: TImage;
    ComboBoxDBList: TbsSkinComboBox;
    bsSkinStdLabel10: TbsSkinStdLabel;
    imgServerList: TImage;
    imgServerListMark: TImage;
    bsSkinButton2: TbsSkinButton;
    imgIE: TImage;
    imgIEMark: TImage;
    LabelLog: TRzLabel;
    ProgressNow: TRzProgressStatus;
    ProgressAll: TRzProgressStatus;
    LabelNow: TRzLabel;
    LabelAll: TRzLabel;
    BtnPlay: TEzRgnBtn;
    BtnSetup: TEzRgnBtn;
    BtnUpdating: TEzRgnBtn;
    EzRgnBtn1: TEzRgnBtn;
    EzRgnBtn2: TEzRgnBtn;
    BtnExit: TEzRgnBtn;
    EzRgnBtn4: TEzRgnBtn;
    EzRgnBtn3: TEzRgnBtn;
    BtnMin: TEzRgnBtn;
    BtnClose: TEzRgnBtn;
    LabelVar: TRzLabel;
    GroupBoxSetupBG: TbsSkinGroupBox;
    bsSkinStdLabel1: TbsSkinStdLabel;
    BGImgLoad: TbsSkinButton;
    bsSkinStdLabel2: TbsSkinStdLabel;
    BGTransparentColor: TbsSkinColorButton;
    BGTransparent: TbsSkinCheckRadioBox;
    GroupBoxSetupServerList: TbsSkinGroupBox;
    bsSkinStdLabel3: TbsSkinStdLabel;
    EditServerListWidth: TbsSkinSpinEdit;
    bsSkinStdLabel4: TbsSkinStdLabel;
    EditServerListHeight: TbsSkinSpinEdit;
    EditServerListLeft: TbsSkinSpinEdit;
    bsSkinStdLabel5: TbsSkinStdLabel;
    bsSkinStdLabel6: TbsSkinStdLabel;
    EditServerListTop: TbsSkinSpinEdit;
    GroupBoxSetupIE: TbsSkinGroupBox;
    bsSkinStdLabel7: TbsSkinStdLabel;
    bsSkinStdLabel8: TbsSkinStdLabel;
    bsSkinStdLabel9: TbsSkinStdLabel;
    bsSkinStdLabel11: TbsSkinStdLabel;
    EditIEWidth: TbsSkinSpinEdit;
    EditIEHeight: TbsSkinSpinEdit;
    EditIELeft: TbsSkinSpinEdit;
    EditIETop: TbsSkinSpinEdit;
    GroupBoxSetupVar: TbsSkinGroupBox;
    bsSkinStdLabel14: TbsSkinStdLabel;
    bsSkinStdLabel15: TbsSkinStdLabel;
    VarLeft: TbsSkinSpinEdit;
    VarTop: TbsSkinSpinEdit;
    VarShow: TbsSkinCheckRadioBox;
    GroupBoxSetupHint: TbsSkinGroupBox;
    bsSkinStdLabel12: TbsSkinStdLabel;
    bsSkinStdLabel13: TbsSkinStdLabel;
    EditHintLeft: TbsSkinSpinEdit;
    EditHintTop: TbsSkinSpinEdit;
    GroupBoxSetupProgressNow: TbsSkinGroupBox;
    bsSkinStdLabel16: TbsSkinStdLabel;
    bsSkinStdLabel17: TbsSkinStdLabel;
    bsSkinStdLabel18: TbsSkinStdLabel;
    bsSkinStdLabel19: TbsSkinStdLabel;
    EditPressWidth: TbsSkinSpinEdit;
    EditPressHeight: TbsSkinSpinEdit;
    EditPressLeft: TbsSkinSpinEdit;
    EditPressTop: TbsSkinSpinEdit;
    bsSkinStdLabel20: TbsSkinStdLabel;
    ColorPress1: TbsSkinColorButton;
    bsSkinStdLabel21: TbsSkinStdLabel;
    ColorPress2: TbsSkinColorButton;
    GroupBoxSetupProgressAll: TbsSkinGroupBox;
    bsSkinStdLabel22: TbsSkinStdLabel;
    bsSkinStdLabel23: TbsSkinStdLabel;
    bsSkinStdLabel24: TbsSkinStdLabel;
    bsSkinStdLabel25: TbsSkinStdLabel;
    bsSkinStdLabel26: TbsSkinStdLabel;
    ColorPressAll1: TbsSkinColorButton;
    bsSkinStdLabel27: TbsSkinStdLabel;
    ColorPressAll2: TbsSkinColorButton;
    EditPressAllWidth: TbsSkinSpinEdit;
    EditPressAllHeight: TbsSkinSpinEdit;
    EditPressAllLeft: TbsSkinSpinEdit;
    EditPressAllTop: TbsSkinSpinEdit;
    GroupBoxSetupNowHint: TbsSkinGroupBox;
    bsSkinStdLabel28: TbsSkinStdLabel;
    bsSkinStdLabel29: TbsSkinStdLabel;
    EditPressHintLeft: TbsSkinSpinEdit;
    EditPressHintTop: TbsSkinSpinEdit;
    GroupBoxSetupAllHint: TbsSkinGroupBox;
    bsSkinStdLabel30: TbsSkinStdLabel;
    bsSkinStdLabel31: TbsSkinStdLabel;
    EditPressAllHintLeft: TbsSkinSpinEdit;
    EditPressAllHintTop: TbsSkinSpinEdit;
    GroupBoxSetupBStart: TbsSkinGroupBox;
    bsSkinStdLabel32: TbsSkinStdLabel;
    bsSkinStdLabel33: TbsSkinStdLabel;
    EditStartLeft: TbsSkinSpinEdit;
    EditStartTop: TbsSkinSpinEdit;
    bsSkinStdLabel34: TbsSkinStdLabel;
    BStartIdleLoad: TbsSkinButton;
    bsSkinStdLabel35: TbsSkinStdLabel;
    bsSkinStdLabel36: TbsSkinStdLabel;
    BStartMoveLoad: TbsSkinButton;
    bsSkinStdLabel37: TbsSkinStdLabel;
    BStartDownLoad: TbsSkinButton;
    bsSkinStdLabel38: TbsSkinStdLabel;
    BStartDsbldLoad: TbsSkinButton;
    GroupBoxSetupReg: TbsSkinGroupBox;
    bsSkinStdLabel39: TbsSkinStdLabel;
    bsSkinStdLabel40: TbsSkinStdLabel;
    bsSkinStdLabel41: TbsSkinStdLabel;
    bsSkinStdLabel42: TbsSkinStdLabel;
    bsSkinStdLabel43: TbsSkinStdLabel;
    bsSkinStdLabel44: TbsSkinStdLabel;
    bsSkinStdLabel45: TbsSkinStdLabel;
    EditRegLeft: TbsSkinSpinEdit;
    EditRegTop: TbsSkinSpinEdit;
    BRegIdleLoad: TbsSkinButton;
    BRegMoveLoad: TbsSkinButton;
    BRegDownLoad: TbsSkinButton;
    BRegDsbldLoad: TbsSkinButton;
    CheckBoxReg: TbsSkinCheckRadioBox;
    GroupBoxSetupChangePass: TbsSkinGroupBox;
    bsSkinStdLabel46: TbsSkinStdLabel;
    bsSkinStdLabel47: TbsSkinStdLabel;
    bsSkinStdLabel48: TbsSkinStdLabel;
    bsSkinStdLabel49: TbsSkinStdLabel;
    bsSkinStdLabel50: TbsSkinStdLabel;
    bsSkinStdLabel51: TbsSkinStdLabel;
    bsSkinStdLabel52: TbsSkinStdLabel;
    EditChangePassLeft: TbsSkinSpinEdit;
    EditChangePassTop: TbsSkinSpinEdit;
    BChangePassIdleLoad: TbsSkinButton;
    BChangePassMoveLoad: TbsSkinButton;
    BChangePassDownLoad: TbsSkinButton;
    BChangePassDsbldLoad: TbsSkinButton;
    CheckBoxChangePass: TbsSkinCheckRadioBox;
    GroupBoxSetupLostPass: TbsSkinGroupBox;
    bsSkinStdLabel53: TbsSkinStdLabel;
    bsSkinStdLabel54: TbsSkinStdLabel;
    bsSkinStdLabel55: TbsSkinStdLabel;
    bsSkinStdLabel56: TbsSkinStdLabel;
    bsSkinStdLabel57: TbsSkinStdLabel;
    bsSkinStdLabel58: TbsSkinStdLabel;
    bsSkinStdLabel59: TbsSkinStdLabel;
    EditLostPassLeft: TbsSkinSpinEdit;
    EditLostPassTop: TbsSkinSpinEdit;
    BLostPassIdleLoad: TbsSkinButton;
    BLostPassMoveLoad: TbsSkinButton;
    BLostPassDownLoad: TbsSkinButton;
    BLostPassDsbldLoad: TbsSkinButton;
    CheckBoxLostPass: TbsSkinCheckRadioBox;
    GroupBoxSetupSetup: TbsSkinGroupBox;
    bsSkinStdLabel60: TbsSkinStdLabel;
    bsSkinStdLabel61: TbsSkinStdLabel;
    bsSkinStdLabel62: TbsSkinStdLabel;
    bsSkinStdLabel63: TbsSkinStdLabel;
    bsSkinStdLabel64: TbsSkinStdLabel;
    bsSkinStdLabel65: TbsSkinStdLabel;
    EditSetupLeft: TbsSkinSpinEdit;
    EditSetupTop: TbsSkinSpinEdit;
    BSetupIdleLoad: TbsSkinButton;
    BSetupMoveLoad: TbsSkinButton;
    BSetupDownLoad: TbsSkinButton;
    CheckBoxSetup: TbsSkinCheckRadioBox;
    GroupBoxSetupHome: TbsSkinGroupBox;
    bsSkinStdLabel66: TbsSkinStdLabel;
    bsSkinStdLabel67: TbsSkinStdLabel;
    bsSkinStdLabel68: TbsSkinStdLabel;
    bsSkinStdLabel69: TbsSkinStdLabel;
    bsSkinStdLabel70: TbsSkinStdLabel;
    bsSkinStdLabel71: TbsSkinStdLabel;
    EditHomeLeft: TbsSkinSpinEdit;
    EditHomeTop: TbsSkinSpinEdit;
    BHomeIdleLoad: TbsSkinButton;
    BHomeMoveLoad: TbsSkinButton;
    BHomeDownLoad: TbsSkinButton;
    CheckBoxHome: TbsSkinCheckRadioBox;
    GroupBoxSetupPay: TbsSkinGroupBox;
    bsSkinStdLabel72: TbsSkinStdLabel;
    bsSkinStdLabel73: TbsSkinStdLabel;
    bsSkinStdLabel74: TbsSkinStdLabel;
    bsSkinStdLabel75: TbsSkinStdLabel;
    bsSkinStdLabel76: TbsSkinStdLabel;
    bsSkinStdLabel77: TbsSkinStdLabel;
    EditPayLeft: TbsSkinSpinEdit;
    EditPayTop: TbsSkinSpinEdit;
    BPayIdleLoad: TbsSkinButton;
    BPayMoveLoad: TbsSkinButton;
    BPayDownLoad: TbsSkinButton;
    CheckBoxPay: TbsSkinCheckRadioBox;
    GroupBoxSetupExit: TbsSkinGroupBox;
    bsSkinStdLabel78: TbsSkinStdLabel;
    bsSkinStdLabel79: TbsSkinStdLabel;
    bsSkinStdLabel80: TbsSkinStdLabel;
    bsSkinStdLabel81: TbsSkinStdLabel;
    bsSkinStdLabel82: TbsSkinStdLabel;
    bsSkinStdLabel83: TbsSkinStdLabel;
    EditExitLeft: TbsSkinSpinEdit;
    EditExitTop: TbsSkinSpinEdit;
    bsSkinButton55: TbsSkinButton;
    bsSkinButton57: TbsSkinButton;
    bsSkinButton59: TbsSkinButton;
    CheckBoxExit: TbsSkinCheckRadioBox;
    GroupBoxSetupMin: TbsSkinGroupBox;
    bsSkinStdLabel84: TbsSkinStdLabel;
    bsSkinStdLabel85: TbsSkinStdLabel;
    bsSkinStdLabel86: TbsSkinStdLabel;
    bsSkinStdLabel87: TbsSkinStdLabel;
    bsSkinStdLabel88: TbsSkinStdLabel;
    bsSkinStdLabel89: TbsSkinStdLabel;
    EditMinLeft: TbsSkinSpinEdit;
    EditMinTop: TbsSkinSpinEdit;
    bsSkinButton61: TbsSkinButton;
    bsSkinButton63: TbsSkinButton;
    bsSkinButton65: TbsSkinButton;
    CheckBoxMin: TbsSkinCheckRadioBox;
    GroupBoxSetupClose: TbsSkinGroupBox;
    bsSkinStdLabel90: TbsSkinStdLabel;
    bsSkinStdLabel91: TbsSkinStdLabel;
    bsSkinStdLabel92: TbsSkinStdLabel;
    bsSkinStdLabel93: TbsSkinStdLabel;
    bsSkinStdLabel94: TbsSkinStdLabel;
    bsSkinStdLabel95: TbsSkinStdLabel;
    EditCloseLeft: TbsSkinSpinEdit;
    EditCloseTop: TbsSkinSpinEdit;
    bsSkinButton67: TbsSkinButton;
    bsSkinButton69: TbsSkinButton;
    bsSkinButton71: TbsSkinButton;
    CheckBoxClose: TbsSkinCheckRadioBox;
    bsSkinStdLabel96: TbsSkinStdLabel;
    ColorVar: TbsSkinColorButton;
    bsSkinStdLabel97: TbsSkinStdLabel;
    ColorPressNow: TbsSkinColorButton;
    ColorPressAll: TbsSkinColorButton;
    bsSkinStdLabel98: TbsSkinStdLabel;
    procedure imgBGMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure imgServerListMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure imgServerListMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ComboBoxDBListChange(Sender: TObject);
    procedure BGTransparentClick(Sender: TObject);
    procedure BGImgLoadClick(Sender: TObject);
    procedure EditServerListWidthChange(Sender: TObject);
    procedure EditServerListLeftChange(Sender: TObject);
    procedure EditIETopChange(Sender: TObject);
    procedure EditIEWidthChange(Sender: TObject);
    procedure VarLeftChange(Sender: TObject);
    procedure VarShowClick(Sender: TObject);
    procedure EditHintTopChange(Sender: TObject);
    procedure ColorPress1ChangeColor(Sender: TObject);
    procedure ColorPress2ChangeColor(Sender: TObject);
    procedure EditPressWidthChange(Sender: TObject);
    procedure EditPressLeftChange(Sender: TObject);
    procedure EditPressAllWidthChange(Sender: TObject);
    procedure EditPressAllLeftChange(Sender: TObject);
    procedure ColorPressAll1ChangeColor(Sender: TObject);
    procedure EditPressHintLeftChange(Sender: TObject);
    procedure EditPressAllHintTopChange(Sender: TObject);
    procedure EditStartLeftChange(Sender: TObject);
    procedure BStartIdleLoadClick(Sender: TObject);
    procedure BStartMoveLoadClick(Sender: TObject);
    procedure BStartDownLoadClick(Sender: TObject);
    procedure BStartDsbldLoadClick(Sender: TObject);
    procedure CheckBoxRegClick(Sender: TObject);
    procedure EditRegLeftChange(Sender: TObject);
    procedure BRegIdleLoadClick(Sender: TObject);
    procedure BRegMoveLoadClick(Sender: TObject);
    procedure BRegDownLoadClick(Sender: TObject);
    procedure BRegDsbldLoadClick(Sender: TObject);
    procedure BChangePassIdleLoadClick(Sender: TObject);
    procedure BChangePassMoveLoadClick(Sender: TObject);
    procedure BChangePassDownLoadClick(Sender: TObject);
    procedure BChangePassDsbldLoadClick(Sender: TObject);
    procedure CheckBoxChangePassClick(Sender: TObject);
    procedure EditChangePassLeftChange(Sender: TObject);
    procedure CheckBoxLostPassClick(Sender: TObject);
    procedure EditLostPassLeftChange(Sender: TObject);
    procedure BLostPassIdleLoadClick(Sender: TObject);
    procedure BLostPassMoveLoadClick(Sender: TObject);
    procedure BLostPassDownLoadClick(Sender: TObject);
    procedure BLostPassDsbldLoadClick(Sender: TObject);
    procedure CheckBoxSetupClick(Sender: TObject);
    procedure EditSetupLeftChange(Sender: TObject);
    procedure BSetupIdleLoadClick(Sender: TObject);
    procedure BSetupMoveLoadClick(Sender: TObject);
    procedure BSetupDownLoadClick(Sender: TObject);
    procedure CheckBoxHomeClick(Sender: TObject);
    procedure EditHomeLeftChange(Sender: TObject);
    procedure BHomeIdleLoadClick(Sender: TObject);
    procedure BHomeMoveLoadClick(Sender: TObject);
    procedure BHomeDownLoadClick(Sender: TObject);
    procedure CheckBoxPayClick(Sender: TObject);
    procedure EditPayLeftChange(Sender: TObject);
    procedure BPayIdleLoadClick(Sender: TObject);
    procedure BPayMoveLoadClick(Sender: TObject);
    procedure BPayDownLoadClick(Sender: TObject);
    procedure CheckBoxExitClick(Sender: TObject);
    procedure EditExitLeftChange(Sender: TObject);
    procedure bsSkinButton55Click(Sender: TObject);
    procedure bsSkinButton57Click(Sender: TObject);
    procedure bsSkinButton59Click(Sender: TObject);
    procedure CheckBoxMinClick(Sender: TObject);
    procedure EditMinLeftChange(Sender: TObject);
    procedure bsSkinButton61Click(Sender: TObject);
    procedure bsSkinButton63Click(Sender: TObject);
    procedure bsSkinButton65Click(Sender: TObject);
    procedure CheckBoxCloseClick(Sender: TObject);
    procedure EditCloseLeftChange(Sender: TObject);
    procedure bsSkinButton67Click(Sender: TObject);
    procedure bsSkinButton69Click(Sender: TObject);
    procedure bsSkinButton71Click(Sender: TObject);
    procedure ColorVarChangeColor(Sender: TObject);
    procedure ColorPressNowChangeColor(Sender: TObject);
    procedure ColorPressAllChangeColor(Sender: TObject);
    procedure bsSkinButton1Click(Sender: TObject);
    procedure ButtonSaveClick(Sender: TObject);
    procedure bsSkinButton2Click(Sender: TObject);
  private
    FSpotX: Integer;
    FSpotY: Integer;
    FSpotTag: Integer;
    FSpotControl: TControl;
    FGroupBox: array[0..18] of TbsSkinGroupBox; 
    procedure ChangeServerListBG(nWidth, nHeight: Integer);
    procedure ChangeIEBG(nWidth, nHeight: Integer);
    procedure InitSetup(SkinInfo: pTLoginSkinInfo; Buffer: PChar);
    function MakeSaveInfo(const MemoryStream: TMemoryStream): Boolean;
  public
    procedure Open();
  end;

implementation

{$R *.dfm}

uses
  FrmMain, DIB, FrmLoginPreview;

var
  boFrist: Boolean = False;
  g_LoginSkinInfo: TLoginSkinInfo = (
    BG_boTransparent: True;
    BG_TransparentColor: $636363;
    BG_Bitmap: (Offset: -1; Size: -1);
    ServerList_Rect: (Left: 34; Top: 216; Width: 194; Height: 230);
    IE_Rect: (Left: 238; Top: 199; Width: 448; Height: 246);
    Var_boShow: True;
    Var_Pos: (Left: 259; Top: 165);
    Var_Color: clBlack;
    Hint_Pos: (Left: 115; Top: 470);
    ProgressNow_Rect: (Left: 105; Top: 492; Width: 130; Height: 16);
    ProgressNow_Color1: clBlack;
    ProgressNow_Color2: clGreen;
    ProgressAll_Rect: (Left: 105; Top: 517; Width: 130; Height: 16);
    ProgressAll_Color1: clBlack;
    ProgressAll_Color2: clRed;
    ProgressNowHint_Pos: (Left: 235; Top: 494);
    ProgressNowHint_Color: clBlue;
    ProgressAllHint_Pos: (Left: 235; Top: 520);
    ProgressAllHint_Color: clBlue;
    Start_Pos: (Left: 282; Top: 463);
    Start_Bitmap_Idle: (Offset: -1; Size: -1);
    Start_Bitmap_Move: (Offset: -1; Size: -1);
    Start_Bitmap_Down: (Offset: -1; Size: -1);
    Start_Bitmap_Dsbld: (Offset: -1; Size: -1);
    Reg_boShow: True;
    Reg_Pos: (Left: 385; Top: 463);
    Reg_Bitmap_Idle: (Offset: -1; Size: -1);
    Reg_Bitmap_Move: (Offset: -1; Size: -1);
    Reg_Bitmap_Down: (Offset: -1; Size: -1);
    Reg_Bitmap_Dsbld: (Offset: -1; Size: -1);
    ChangePass_boShow: True;
    ChangePass_Pos: (Left: 488; Top: 463);
    ChangePass_Bitmap_Idle: (Offset: -1; Size: -1);
    ChangePass_Bitmap_Move: (Offset: -1; Size: -1);
    ChangePass_Bitmap_Down: (Offset: -1; Size: -1);
    ChangePass_Bitmap_Dsbld: (Offset: -1; Size: -1);
    LostPass_boShow: True;
    LostPass_Pos: (Left: 591; Top: 463);
    LostPass_Bitmap_Idle: (Offset: -1; Size: -1);
    LostPass_Bitmap_Move: (Offset: -1; Size: -1);
    LostPass_Bitmap_Down: (Offset: -1; Size: -1);
    LostPass_Bitmap_Dsbld: (Offset: -1; Size: -1);
    Setup_boShow: True;
    Setup_Pos: (Left: 282; Top: 505);
    Setup_Bitmap_Idle: (Offset: -1; Size: -1);
    Setup_Bitmap_Move: (Offset: -1; Size: -1);
    Setup_Bitmap_Down: (Offset: -1; Size: -1);
    Home_boShow: True;
    Home_Pos: (Left: 385; Top: 505);
    Home_Bitmap_Idle: (Offset: -1; Size: -1);
    Home_Bitmap_Move: (Offset: -1; Size: -1);
    Home_Bitmap_Down: (Offset: -1; Size: -1);
    Pay_boShow: True;
    Pay_Pos: (Left: 488; Top: 505);
    Pay_Bitmap_Idle: (Offset: -1; Size: -1);
    Pay_Bitmap_Move: (Offset: -1; Size: -1);
    Pay_Bitmap_Down: (Offset: -1; Size: -1);
    Exit_boShow: True;
    Exit_Pos: (Left: 591; Top: 505);
    Exit_Bitmap_Idle: (Offset: -1; Size: -1);
    Exit_Bitmap_Move: (Offset: -1; Size: -1);
    Exit_Bitmap_Down: (Offset: -1; Size: -1);
    Min_boShow: True;
    Min_Pos: (Left: 653; Top: 165);
    Min_Bitmap_Idle: (Offset: -1; Size: -1);
    Min_Bitmap_Move: (Offset: -1; Size: -1);
    Min_Bitmap_Down: (Offset: -1; Size: -1);
    Close_boShow: True;
    Close_Pos: (Left: 669; Top: 165);
    Close_Bitmap_Idle: (Offset: -1; Size: -1);
    Close_Bitmap_Move: (Offset: -1; Size: -1);
    Close_Bitmap_Down: (Offset: -1; Size: -1);
  );
{ TFrameMakeLogin }


procedure TFrameMakeLogin.imgBGMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ComboBoxDBList.ItemIndex := TControl(Sender).Tag;
  FSpotX := X;
  FSpotY := Y;
  FSpotTag := TControl(Sender).Tag;
  FSpotControl := TControl(Sender);
end;

procedure TFrameMakeLogin.imgServerListMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  al, at: integer;
begin
  if (FSpotTag > 0) and (FSpotControl <> nil) then begin
    if (FSpotX <> X) or (FSpotY <> Y) then begin
      with FSpotControl do begin
        al := Left + (X - FSpotX);
        at := Top + (Y - FSpotY);
        if al < 0 then al := 0;
        if at < 0 then at := 0;
        if al + Width > imgBG.Width then 
          al := imgBG.Width - Width;
        if at + Height > imgBG.Height then
          at := imgBG.Height - Height;
        Left := al;
        Top := at;
        boFrist := False;
        Try
          case Tag of
            1: begin
                EditServerListLeft.Value := Left;
                EditServerListTop.Value := Top;
              end;
            2: begin
                EditIELeft.Value := Left;
                EditIETop.Value := Top;
              end;
            3: begin
                VarLeft.Value := LabelVar.Left;
                VarTop.Value := LabelVar.Top;
              end;
            4: begin
                EditHintLeft.Value := LabelLog.Left;
                EditHintTop.Value := LabelLog.Top;
              end;
            5: begin
                EditPressLeft.Value := ProgressNow.Left;
                EditPressTop.Value := ProgressNow.Top;
              end;
            6: begin
                EditPressAllLeft.Value := ProgressAll.Left;
                EditPressAllTop.Value := ProgressAll.Top;
              end;
            7: begin
                EditPressHintLeft.Value := LabelNow.Left;
                EditPressHintTop.Value := LabelNow.Top;
              end;
            8: begin
                EditPressAllHintLeft.Value := LabelAll.Left;
                EditPressAllHintTop.Value := LabelAll.Top;
              end;
            9: begin
                EditStartLeft.Value := btnPlay.Left;
                EditStartTop.Value := btnPlay.Top;
              end;
            10: begin
                EditRegLeft.Value := BtnUpdating.Left;
                EditRegTop.Value := BtnUpdating.Top;
              end;
            11: begin
                EditChangePassLeft.Value := EzRgnbtn1.Left;
                EditChangePassTop.Value := EzRgnbtn1.Top;
              end;
            12: begin
                EditLostPassLeft.Value := EzRgnbtn2.Left;
                EditLostPassTop.Value := EzRgnbtn2.Top;
              end;
            13: begin
                EditSetupLeft.Value := btnSetup.Left;
                EditSetupTop.Value := btnSetup.Top;
              end;
            14: begin
                EditHomeLeft.Value := EzRgnBtn3.Left;
                EditHomeTop.Value := EzRgnBtn3.Top;
              end;
            15: begin
                EditPayLeft.Value := EzRgnBtn4.Left;
                EditPayTop.Value := EzRgnBtn4.Top;
              end;
            16: begin
                EditExitLeft.Value := btnExit.Left;
                EditExitTop.Value := btnExit.Top;
              end;
            17: begin
                EditMinLeft.Value := btnMin.Left;
                EditMinTop.Value := btnMin.Top;
              end;
            18: begin
                EditCloseLeft.Value := btnClose.Left;
                EditCloseTop.Value := btnMin.Top;
              end;
          end;
        Finally
          boFrist := True;
        End;
      end;
    end;
  end;
end;

procedure TFrameMakeLogin.imgServerListMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FSpotControl := nil;
  FSpotTag := -1;
  //
end;

procedure TFrameMakeLogin.InitSetup(SkinInfo: pTLoginSkinInfo; Buffer: PChar);
var
  MemoryStream: TMemoryStream;
  JPG: TJPEGImage;
  Bitmap: TBitmap;
begin
  MemoryStream := nil;
  Try
    if (Buffer <> nil) then begin
      MemoryStream := TMemoryStream.Create;
    end;
    BGTransparent.Checked := SKinInfo.BG_boTransparent;
    BGTransparentColor.ColorValue := SkinInfo.BG_TransparentColor;
    if (Buffer <> nil) and (SkinInfo.BG_Bitmap.Offset >= 0) and (SkinInfo.BG_Bitmap.Size > 0) then begin
      MemoryStream.Clear;
      MemoryStream.Write(Buffer[SkinInfo.BG_Bitmap.Offset], SkinInfo.BG_Bitmap.Size);
      MemoryStream.Position := 0;
      if SkinInfo.BG_ImageType = it_Jpeg then begin
        JPG := TJPEGImage.Create;
        Try
          imgBG.Picture.Graphic := JPG;
          imgBG.Picture.Graphic.LoadFromStream(MemoryStream);
        Finally
          JPG.Free;
        End;
      end else begin
        Bitmap := TBitmap.Create;
        Try
          imgBG.Picture.Graphic := Bitmap;
          imgBG.Picture.Graphic.LoadFromStream(MemoryStream);
        Finally
          Bitmap.Free;
        End;
      end;
    end;

    imgServerList.Left := SkinInfo.ServerList_Rect.Left;
    imgServerList.Top := SkinInfo.ServerList_Rect.Top;
    ChangeServerListBG(SkinInfo.ServerList_Rect.Width, SkinInfo.ServerList_Rect.Height);
    EditServerListLeft.Value := SkinInfo.ServerList_Rect.Left;
    EditServerListTop.Value := SkinInfo.ServerList_Rect.Top;
    EditServerListWidth.Value := SkinInfo.ServerList_Rect.Width;
    EditServerListHeight.Value := SkinInfo.ServerList_Rect.Height;

    imgIE.Left := SkinInfo.IE_Rect.Left;
    imgIE.Top := SkinInfo.IE_Rect.Top;
    ChangeIEBG(SkinInfo.IE_Rect.Width, SkinInfo.IE_Rect.Height);
    EditIELeft.Value := SkinInfo.IE_Rect.Left;
    EditIETop.Value := SkinInfo.IE_Rect.Top;
    EditIEWidth.Value := SkinInfo.IE_Rect.Width;
    EditIEHeight.Value := SkinInfo.IE_Rect.Height;

    LabelVar.Visible := SkinInfo.Var_boShow;
    LabelVar.Left := SkinInfo.Var_Pos.Left;
    LabelVar.Top := SkinInfo.Var_Pos.Top;
    LabelVar.Font.Color := SkinInfo.Var_Color;
    VarShow.Checked := SkinInfo.Var_boShow;
    VarLeft.Value := SkinInfo.Var_Pos.Left;
    VarTop.Value := SkinInfo.Var_Pos.Top;
    ColorVar.ColorValue := SkinInfo.Var_Color;

    LabelLog.Left := SkinInfo.Hint_Pos.Left;
    LabelLog.Top := SkinInfo.Hint_Pos.Top;
    EditHintLeft.Value := SkinInfo.Hint_Pos.Left;
    EditHintTop.Value := SkinInfo.Hint_Pos.Top;

    ProgressNow.Left := SkinInfo.ProgressNow_Rect.Left;
    ProgressNow.Top := SkinInfo.ProgressNow_Rect.Top;
    ProgressNow.Width := SkinInfo.ProgressNow_Rect.Width;
    ProgressNow.Height := SKinInfo.ProgressNow_Rect.Height;
    ProgressNow.BarColor := SkinInfo.ProgressNow_Color1;
    ProgressNow.BarColorStop := SkinInfo.ProgressNow_Color2;
    EditPressLeft.Value := SkinInfo.ProgressNow_Rect.Left;
    EditPressTop.Value := SkinInfo.ProgressNow_Rect.Top;
    EditPressWidth.Value := SkinInfo.ProgressNow_Rect.Width;
    EditPressHeight.Value := SKinInfo.ProgressNow_Rect.Height;
    ColorPress1.ColorValue := SkinInfo.ProgressNow_Color1;
    ColorPress2.ColorValue := SkinInfo.ProgressNow_Color2;

    ProgressAll.Left := SkinInfo.ProgressAll_Rect.Left;
    ProgressAll.Top := SkinInfo.ProgressAll_Rect.Top;
    ProgressAll.Width := SkinInfo.ProgressAll_Rect.Width;
    ProgressAll.Height := SKinInfo.ProgressAll_Rect.Height;
    ProgressAll.BarColor := SkinInfo.ProgressAll_Color1;
    ProgressAll.BarColorStop := SkinInfo.ProgressAll_Color2;
    EditPressallLeft.Value := SkinInfo.ProgressAll_Rect.Left;
    EditPressAllTop.Value := SkinInfo.ProgressAll_Rect.Top;
    EditPressAllWidth.Value := SkinInfo.ProgressAll_Rect.Width;
    EditPressAllHeight.Value := SKinInfo.ProgressAll_Rect.Height;
    ColorPressAll1.ColorValue := SkinInfo.ProgressAll_Color1;
    ColorPressAll2.ColorValue := SkinInfo.ProgressAll_Color2;


    LabelNow.Left := SkinInfo.ProgressNowHint_Pos.Left;
    LabelNow.Top := SkinInfo.ProgressNowHint_Pos.Top;
    LabelNow.Font.Color := SkinInfo.ProgressNowHint_Color;
    EditPressHintLeft.Value := SkinInfo.ProgressNowHint_Pos.Left;
    EditPressHintTop.Value := SkinInfo.ProgressNowHint_Pos.Top;
    ColorPressNow.ColorValue := SkinInfo.ProgressNowHint_Color;

    LabelAll.Left := SkinInfo.ProgressAllHint_Pos.Left;
    LabelAll.Top := SkinInfo.ProgressAllHint_Pos.Top;
    LabelAll.Font.Color := SKinInfo.ProgressAllHint_Color;
    EditPressAllHintLeft.Value := SkinInfo.ProgressAllHint_Pos.Left;
    EditPressAllHintTop.Value := SkinInfo.ProgressAllHint_Pos.Top;
    ColorPressAll.ColorValue := SKinInfo.ProgressAllHint_Color;

    btnPlay.Left := SKinInfo.Start_Pos.Left;
    btnPlay.Top := SkinInfo.Start_Pos.Top;
    EditStartLeft.Value := SKinInfo.Start_Pos.Left;
    EditStartTop.Value := SKinInfo.Start_Pos.Top;
    if (Buffer <> nil) and (SkinInfo.Start_Bitmap_Idle.Offset >= 0) and (SkinInfo.Start_Bitmap_Idle.Size > 0) then begin
      MemoryStream.Clear;
      MemoryStream.Write(Buffer[SkinInfo.Start_Bitmap_Idle.Offset], SkinInfo.Start_Bitmap_Idle.Size);
      MemoryStream.Position := 0;
      btnPlay.PicIdle.Bitmap.LoadFromStream(MemoryStream);
    end;
    if (Buffer <> nil) and (SkinInfo.Start_Bitmap_Move.Offset >= 0) and (SkinInfo.Start_Bitmap_Move.Size > 0) then begin
      MemoryStream.Clear;
      MemoryStream.Write(Buffer[SkinInfo.Start_Bitmap_Move.Offset], SkinInfo.Start_Bitmap_Move.Size);
      MemoryStream.Position := 0;
      btnPlay.PicUp.Bitmap.LoadFromStream(MemoryStream);
    end;
    if (Buffer <> nil) and (SkinInfo.Start_Bitmap_Down.Offset >= 0) and (SkinInfo.Start_Bitmap_Down.Size > 0) then begin
      MemoryStream.Clear;
      MemoryStream.Write(Buffer[SkinInfo.Start_Bitmap_Down.Offset], SkinInfo.Start_Bitmap_Down.Size);
      MemoryStream.Position := 0;
      btnPlay.PicDown.Bitmap.LoadFromStream(MemoryStream);
    end;
    if (Buffer <> nil) and (SkinInfo.Start_Bitmap_Dsbld.Offset >= 0) and (SkinInfo.Start_Bitmap_Dsbld.Size > 0) then begin
      MemoryStream.Clear;
      MemoryStream.Write(Buffer[SkinInfo.Start_Bitmap_Dsbld.Offset], SkinInfo.Start_Bitmap_Dsbld.Size);
      MemoryStream.Position := 0;
      btnPlay.PicDsbld.Bitmap.LoadFromStream(MemoryStream);
    end;

    btnUpdating.Visible := SkinInfo.Reg_boShow;
    btnUpdating.Left := SkinInfo.Reg_Pos.Left;
    btnUpdating.Top := SkinInfo.Reg_Pos.Top;
    EditRegLeft.Value := SKinInfo.Reg_Pos.Left;
    EditRegTop.Value := SKInInfo.Reg_Pos.Top;
    CheckBoxReg.Checked := SkinInfo.Reg_boShow;
    if (Buffer <> nil) and (SkinInfo.Reg_Bitmap_Idle.Offset >= 0) and (SkinInfo.Reg_Bitmap_Idle.Size > 0) then begin
      MemoryStream.Clear;
      MemoryStream.Write(Buffer[SkinInfo.Reg_Bitmap_Idle.Offset], SkinInfo.Reg_Bitmap_Idle.Size);
      MemoryStream.Position := 0;
      btnUpdating.PicIdle.Bitmap.LoadFromStream(MemoryStream);
    end;
    if (Buffer <> nil) and (SkinInfo.Reg_Bitmap_Move.Offset >= 0) and (SkinInfo.Reg_Bitmap_Move.Size > 0) then begin
      MemoryStream.Clear;
      MemoryStream.Write(Buffer[SkinInfo.Reg_Bitmap_Move.Offset], SkinInfo.Reg_Bitmap_Move.Size);
      MemoryStream.Position := 0;
      btnUpdating.PicUp.Bitmap.LoadFromStream(MemoryStream);
    end;
    if (Buffer <> nil) and (SkinInfo.Reg_Bitmap_Down.Offset >= 0) and (SkinInfo.Reg_Bitmap_Down.Size > 0) then begin
      MemoryStream.Clear;
      MemoryStream.Write(Buffer[SkinInfo.Reg_Bitmap_Down.Offset], SkinInfo.Reg_Bitmap_Down.Size);
      MemoryStream.Position := 0;
      btnUpdating.PicDown.Bitmap.LoadFromStream(MemoryStream);
    end;
    if (Buffer <> nil) and (SkinInfo.Reg_Bitmap_Dsbld.Offset >= 0) and (SkinInfo.Reg_Bitmap_Dsbld.Size > 0) then begin
      MemoryStream.Clear;
      MemoryStream.Write(Buffer[SkinInfo.Reg_Bitmap_Dsbld.Offset], SkinInfo.Reg_Bitmap_Dsbld.Size);
      MemoryStream.Position := 0;
      btnUpdating.PicDsbld.Bitmap.LoadFromStream(MemoryStream);
    end;

    EzRgnbtn1.Visible := SkinInfo.ChangePass_boShow;
    EzRgnbtn1.Left := SkinInfo.ChangePass_Pos.Left;
    EzRgnbtn1.Top := SkinInfo.ChangePass_Pos.Top;
    EditChangePassLeft.Value := SKinInfo.ChangePass_Pos.Left;
    EditChangePassTop.Value := SKInInfo.ChangePass_Pos.Top;
    CheckBoxChangePass.Checked := SkinInfo.ChangePass_boShow;
    if (Buffer <> nil) and (SkinInfo.ChangePass_Bitmap_Idle.Offset >= 0) and (SkinInfo.ChangePass_Bitmap_Idle.Size > 0) then begin
      MemoryStream.Clear;
      MemoryStream.Write(Buffer[SkinInfo.ChangePass_Bitmap_Idle.Offset], SkinInfo.ChangePass_Bitmap_Idle.Size);
      MemoryStream.Position := 0;
      EzRgnbtn1.PicIdle.Bitmap.LoadFromStream(MemoryStream);
    end;
    if (Buffer <> nil) and (SkinInfo.ChangePass_Bitmap_Move.Offset >= 0) and (SkinInfo.ChangePass_Bitmap_Move.Size > 0) then begin
      MemoryStream.Clear;
      MemoryStream.Write(Buffer[SkinInfo.ChangePass_Bitmap_Move.Offset], SkinInfo.ChangePass_Bitmap_Move.Size);
      MemoryStream.Position := 0;
      EzRgnbtn1.PicUp.Bitmap.LoadFromStream(MemoryStream);
    end;
    if (Buffer <> nil) and (SkinInfo.ChangePass_Bitmap_Down.Offset >= 0) and (SkinInfo.ChangePass_Bitmap_Down.Size > 0) then begin
      MemoryStream.Clear;
      MemoryStream.Write(Buffer[SkinInfo.ChangePass_Bitmap_Down.Offset], SkinInfo.ChangePass_Bitmap_Down.Size);
      MemoryStream.Position := 0;
      EzRgnbtn1.PicDown.Bitmap.LoadFromStream(MemoryStream);
    end;
    if (Buffer <> nil) and (SkinInfo.ChangePass_Bitmap_Dsbld.Offset >= 0) and (SkinInfo.ChangePass_Bitmap_Dsbld.Size > 0) then begin
      MemoryStream.Clear;
      MemoryStream.Write(Buffer[SkinInfo.ChangePass_Bitmap_Dsbld.Offset], SkinInfo.ChangePass_Bitmap_Dsbld.Size);
      MemoryStream.Position := 0;
      EzRgnbtn1.PicDsbld.Bitmap.LoadFromStream(MemoryStream);
    end;

    EzRgnbtn2.Visible := SkinInfo.LostPass_boShow;
    EzRgnbtn2.Left := SkinInfo.LostPass_Pos.Left;
    EzRgnbtn2.Top := SkinInfo.LostPass_Pos.Top;
    EditLostPassLeft.Value := SKinInfo.LostPass_Pos.Left;
    EditLostPassTop.Value := SKInInfo.LostPass_Pos.Top;
    CheckBoxLostPass.Checked := SkinInfo.LostPass_boShow;
    if (Buffer <> nil) and (SkinInfo.LostPass_Bitmap_Idle.Offset >= 0) and (SkinInfo.LostPass_Bitmap_Idle.Size > 0) then begin
      MemoryStream.Clear;
      MemoryStream.Write(Buffer[SkinInfo.LostPass_Bitmap_Idle.Offset], SkinInfo.LostPass_Bitmap_Idle.Size);
      MemoryStream.Position := 0;
      EzRgnbtn2.PicIdle.Bitmap.LoadFromStream(MemoryStream);
    end;
    if (Buffer <> nil) and (SkinInfo.LostPass_Bitmap_Move.Offset >= 0) and (SkinInfo.LostPass_Bitmap_Move.Size > 0) then begin
      MemoryStream.Clear;
      MemoryStream.Write(Buffer[SkinInfo.LostPass_Bitmap_Move.Offset], SkinInfo.LostPass_Bitmap_Move.Size);
      MemoryStream.Position := 0;
      EzRgnbtn2.PicUp.Bitmap.LoadFromStream(MemoryStream);
    end;
    if (Buffer <> nil) and (SkinInfo.LostPass_Bitmap_Down.Offset >= 0) and (SkinInfo.LostPass_Bitmap_Down.Size > 0) then begin
      MemoryStream.Clear;
      MemoryStream.Write(Buffer[SkinInfo.LostPass_Bitmap_Down.Offset], SkinInfo.LostPass_Bitmap_Down.Size);
      MemoryStream.Position := 0;
      EzRgnbtn2.PicDown.Bitmap.LoadFromStream(MemoryStream);
    end;
    if (Buffer <> nil) and (SkinInfo.LostPass_Bitmap_Dsbld.Offset >= 0) and (SkinInfo.LostPass_Bitmap_Dsbld.Size > 0) then begin
      MemoryStream.Clear;
      MemoryStream.Write(Buffer[SkinInfo.LostPass_Bitmap_Dsbld.Offset], SkinInfo.LostPass_Bitmap_Dsbld.Size);
      MemoryStream.Position := 0;
      EzRgnbtn2.PicDsbld.Bitmap.LoadFromStream(MemoryStream);
    end;

    btnSetup.Visible := SkinInfo.Setup_boShow;
    btnSetup.Left := SkinInfo.Setup_Pos.Left;
    btnSetup.Top := SkinInfo.Setup_Pos.Top;
    EditSetupLeft.Value := SKinInfo.Setup_Pos.Left;
    EditSetupTop.Value := SKInInfo.Setup_Pos.Top;
    CheckBoxSetup.Checked := SkinInfo.Setup_boShow;
    if (Buffer <> nil) and (SkinInfo.Setup_Bitmap_Idle.Offset >= 0) and (SkinInfo.Setup_Bitmap_Idle.Size > 0) then begin
      MemoryStream.Clear;
      MemoryStream.Write(Buffer[SkinInfo.Setup_Bitmap_Idle.Offset], SkinInfo.Setup_Bitmap_Idle.Size);
      MemoryStream.Position := 0;
      btnSetup.PicIdle.Bitmap.LoadFromStream(MemoryStream);
    end;
    if (Buffer <> nil) and (SkinInfo.Setup_Bitmap_Move.Offset >= 0) and (SkinInfo.Setup_Bitmap_Move.Size > 0) then begin
      MemoryStream.Clear;
      MemoryStream.Write(Buffer[SkinInfo.Setup_Bitmap_Move.Offset], SkinInfo.Setup_Bitmap_Move.Size);
      MemoryStream.Position := 0;
      btnSetup.PicUp.Bitmap.LoadFromStream(MemoryStream);
    end;
    if (Buffer <> nil) and (SkinInfo.Setup_Bitmap_Down.Offset >= 0) and (SkinInfo.Setup_Bitmap_Down.Size > 0) then begin
      MemoryStream.Clear;
      MemoryStream.Write(Buffer[SkinInfo.Setup_Bitmap_Down.Offset], SkinInfo.Setup_Bitmap_Down.Size);
      MemoryStream.Position := 0;
      btnSetup.PicDown.Bitmap.LoadFromStream(MemoryStream);
    end;

    EzRgnbtn3.Visible := SkinInfo.Home_boShow;
    EzRgnbtn3.Left := SkinInfo.Home_Pos.Left;
    EzRgnbtn3.Top := SkinInfo.Home_Pos.Top;
    EditHomeLeft.Value := SKinInfo.Home_Pos.Left;
    EditHomeTop.Value := SKInInfo.Home_Pos.Top;
    CheckBoxHome.Checked := SkinInfo.Home_boShow;
    if (Buffer <> nil) and (SkinInfo.Home_Bitmap_Idle.Offset >= 0) and (SkinInfo.Home_Bitmap_Idle.Size > 0) then begin
      MemoryStream.Clear;
      MemoryStream.Write(Buffer[SkinInfo.Home_Bitmap_Idle.Offset], SkinInfo.Home_Bitmap_Idle.Size);
      MemoryStream.Position := 0;
      EzRgnbtn3.PicIdle.Bitmap.LoadFromStream(MemoryStream);
    end;
    if (Buffer <> nil) and (SkinInfo.Home_Bitmap_Move.Offset >= 0) and (SkinInfo.Home_Bitmap_Move.Size > 0) then begin
      MemoryStream.Clear;
      MemoryStream.Write(Buffer[SkinInfo.Home_Bitmap_Move.Offset], SkinInfo.Home_Bitmap_Move.Size);
      MemoryStream.Position := 0;
      EzRgnbtn3.PicUp.Bitmap.LoadFromStream(MemoryStream);
    end;
    if (Buffer <> nil) and (SkinInfo.Home_Bitmap_Down.Offset >= 0) and (SkinInfo.Home_Bitmap_Down.Size > 0) then begin
      MemoryStream.Clear;
      MemoryStream.Write(Buffer[SkinInfo.Home_Bitmap_Down.Offset], SkinInfo.Home_Bitmap_Down.Size);
      MemoryStream.Position := 0;
      EzRgnbtn3.PicDown.Bitmap.LoadFromStream(MemoryStream);
    end;

    EzRgnbtn4.Visible := SkinInfo.Pay_boShow;
    EzRgnbtn4.Left := SkinInfo.Pay_Pos.Left;
    EzRgnbtn4.Top := SkinInfo.Pay_Pos.Top;
    EditPayLeft.Value := SKinInfo.Pay_Pos.Left;
    EditPayTop.Value := SKInInfo.Pay_Pos.Top;
    CheckBoxPay.Checked := SkinInfo.Pay_boShow;
    if (Buffer <> nil) and (SkinInfo.Pay_Bitmap_Idle.Offset >= 0) and (SkinInfo.Pay_Bitmap_Idle.Size > 0) then begin
      MemoryStream.Clear;
      MemoryStream.Write(Buffer[SkinInfo.Pay_Bitmap_Idle.Offset], SkinInfo.Pay_Bitmap_Idle.Size);
      MemoryStream.Position := 0;
      EzRgnbtn4.PicIdle.Bitmap.LoadFromStream(MemoryStream);
    end;
    if (Buffer <> nil) and (SkinInfo.Pay_Bitmap_Move.Offset >= 0) and (SkinInfo.Pay_Bitmap_Move.Size > 0) then begin
      MemoryStream.Clear;
      MemoryStream.Write(Buffer[SkinInfo.Pay_Bitmap_Move.Offset], SkinInfo.Pay_Bitmap_Move.Size);
      MemoryStream.Position := 0;
      EzRgnbtn4.PicUp.Bitmap.LoadFromStream(MemoryStream);
    end;
    if (Buffer <> nil) and (SkinInfo.Pay_Bitmap_Down.Offset >= 0) and (SkinInfo.Pay_Bitmap_Down.Size > 0) then begin
      MemoryStream.Clear;
      MemoryStream.Write(Buffer[SkinInfo.Pay_Bitmap_Down.Offset], SkinInfo.Pay_Bitmap_Down.Size);
      MemoryStream.Position := 0;
      EzRgnbtn4.PicDown.Bitmap.LoadFromStream(MemoryStream);
    end;

    btnExit.Visible := SkinInfo.Exit_boShow;
    btnExit.Left := SkinInfo.Exit_Pos.Left;
    btnExit.Top := SkinInfo.Exit_Pos.Top;
    EditExitLeft.Value := SKinInfo.Exit_Pos.Left;
    EditExitTop.Value := SKInInfo.Exit_Pos.Top;
    CheckBoxExit.Checked := SkinInfo.Exit_boShow;
    if (Buffer <> nil) and (SkinInfo.Exit_Bitmap_Idle.Offset >= 0) and (SkinInfo.Exit_Bitmap_Idle.Size > 0) then begin
      MemoryStream.Clear;
      MemoryStream.Write(Buffer[SkinInfo.Exit_Bitmap_Idle.Offset], SkinInfo.Exit_Bitmap_Idle.Size);
      MemoryStream.Position := 0;
      btnExit.PicIdle.Bitmap.LoadFromStream(MemoryStream);
    end;
    if (Buffer <> nil) and (SkinInfo.Exit_Bitmap_Move.Offset >= 0) and (SkinInfo.Exit_Bitmap_Move.Size > 0) then begin
      MemoryStream.Clear;
      MemoryStream.Write(Buffer[SkinInfo.Exit_Bitmap_Move.Offset], SkinInfo.Exit_Bitmap_Move.Size);
      MemoryStream.Position := 0;
      btnExit.PicUp.Bitmap.LoadFromStream(MemoryStream);
    end;
    if (Buffer <> nil) and (SkinInfo.Exit_Bitmap_Down.Offset >= 0) and (SkinInfo.Exit_Bitmap_Down.Size > 0) then begin
      MemoryStream.Clear;
      MemoryStream.Write(Buffer[SkinInfo.Exit_Bitmap_Down.Offset], SkinInfo.Exit_Bitmap_Down.Size);
      MemoryStream.Position := 0;
      btnExit.PicDown.Bitmap.LoadFromStream(MemoryStream);
    end;

    btnMin.Visible := SkinInfo.Min_boShow;
    btnMin.Left := SkinInfo.Min_Pos.Left;
    btnMin.Top := SkinInfo.Min_Pos.Top;
    EditMinLeft.Value := SKinInfo.Min_Pos.Left;
    EditMinTop.Value := SKInInfo.Min_Pos.Top;
    CheckBoxMin.Checked := SkinInfo.Min_boShow;
    if (Buffer <> nil) and (SkinInfo.Min_Bitmap_Idle.Offset >= 0) and (SkinInfo.Min_Bitmap_Idle.Size > 0) then begin
      MemoryStream.Clear;
      MemoryStream.Write(Buffer[SkinInfo.Min_Bitmap_Idle.Offset], SkinInfo.Min_Bitmap_Idle.Size);
      MemoryStream.Position := 0;
      btnMin.PicIdle.Bitmap.LoadFromStream(MemoryStream);
    end;
    if (Buffer <> nil) and (SkinInfo.Min_Bitmap_Move.Offset >= 0) and (SkinInfo.Min_Bitmap_Move.Size > 0) then begin
      MemoryStream.Clear;
      MemoryStream.Write(Buffer[SkinInfo.Min_Bitmap_Move.Offset], SkinInfo.Min_Bitmap_Move.Size);
      MemoryStream.Position := 0;
      btnMin.PicUp.Bitmap.LoadFromStream(MemoryStream);
    end;
    if (Buffer <> nil) and (SkinInfo.Min_Bitmap_Down.Offset >= 0) and (SkinInfo.Min_Bitmap_Down.Size > 0) then begin
      MemoryStream.Clear;
      MemoryStream.Write(Buffer[SkinInfo.Min_Bitmap_Down.Offset], SkinInfo.Min_Bitmap_Down.Size);
      MemoryStream.Position := 0;
      btnMin.PicDown.Bitmap.LoadFromStream(MemoryStream);
    end;

    btnClose.Visible := SkinInfo.Close_boShow;
    btnClose.Left := SkinInfo.Close_Pos.Left;
    btnClose.Top := SkinInfo.Close_Pos.Top;
    EditCloseLeft.Value := SKinInfo.Close_Pos.Left;
    EditCloseTop.Value := SKInInfo.Close_Pos.Top;
    CheckBoxClose.Checked := SkinInfo.Close_boShow;
    if (Buffer <> nil) and (SkinInfo.Close_Bitmap_Idle.Offset >= 0) and (SkinInfo.Close_Bitmap_Idle.Size > 0) then begin
      MemoryStream.Clear;
      MemoryStream.Write(Buffer[SkinInfo.Close_Bitmap_Idle.Offset], SkinInfo.Close_Bitmap_Idle.Size);
      MemoryStream.Position := 0;
      btnClose.PicIdle.Bitmap.LoadFromStream(MemoryStream);
    end;
    if (Buffer <> nil) and (SkinInfo.Close_Bitmap_Move.Offset >= 0) and (SkinInfo.Close_Bitmap_Move.Size > 0) then begin
      MemoryStream.Clear;
      MemoryStream.Write(Buffer[SkinInfo.Close_Bitmap_Move.Offset], SkinInfo.Close_Bitmap_Move.Size);
      MemoryStream.Position := 0;
      btnClose.PicUp.Bitmap.LoadFromStream(MemoryStream);
    end;
    if (Buffer <> nil) and (SkinInfo.Close_Bitmap_Down.Offset >= 0) and (SkinInfo.Close_Bitmap_Down.Size > 0) then begin
      MemoryStream.Clear;
      MemoryStream.Write(Buffer[SkinInfo.Close_Bitmap_Down.Offset], SkinInfo.Close_Bitmap_Down.Size);
      MemoryStream.Position := 0;
      btnClose.PicDown.Bitmap.LoadFromStream(MemoryStream);
    end;
  Finally
    if MemoryStream <> nil then MemoryStream.Free;
  End;
end;

function TFrameMakeLogin.MakeSaveInfo(const MemoryStream: TMemoryStream): Boolean;
var
  SkinInfo: TLoginSkinInfo;
  TempMemoryStream: TMemoryStream;
  WriteBuffer: Pointer;
  WriteSize: Integer;
  SkinHeader: TLoginSkinHeader;
begin
  Result := False;
  TempMemoryStream := TMemoryStream.Create;
  Try
    FillChar(SkinInfo, SizeOf(SkinInfo), #0);
    SkinInfo.BG_boTransparent := BGTransparent.Checked;
    SkinInfo.BG_TransparentColor := BGTransparentColor.ColorValue;
    TempMemoryStream.Clear;
    imgBG.Picture.Graphic.SaveToStream(TempMemoryStream);
    if imgBG.Picture.Graphic is TJPEGImage then SkinInfo.BG_ImageType := it_Jpeg
    else SkinInfo.BG_ImageType := it_Bitmap;
    SkinInfo.BG_Bitmap.Offset := 0;
    SkinInfo.BG_Bitmap.Size := TempMemoryStream.Size;
    MemoryStream.CopyFrom(TempMemoryStream, 0);


    SkinInfo.ServerLIST_Rect.Left := Trunc(EditServerListLeft.Value);
    SkinInfo.ServerLIST_Rect.Top := Trunc(EditServerListTop.Value);
    SkinInfo.ServerLIST_Rect.Width := Trunc(EditServerListWidth.Value);
    SkinInfo.ServerLIST_Rect.Height := Trunc(EditServerListHeight.Value);

    SkinInfo.IE_Rect.Left := Trunc(EditIELeft.Value);
    SkinInfo.IE_Rect.Top := Trunc(EditIETop.Value);
    SkinInfo.IE_Rect.Width := Trunc(EditIEWidth.Value);
    SkinInfo.IE_Rect.Height := Trunc(EditIEHeight.Value);

    SkinInfo.Var_boShow := VarShow.Checked;
    SkinInfo.Var_Pos.Top := Trunc(VarTop.Value);
    SkinInfo.Var_Pos.Left := Trunc(VarLeft.Value);
    SkinInfo.Var_Color := ColorVar.ColorValue;

    SkinInfo.Hint_Pos.Top := Trunc(EditHintTop.Value);
    SkinInfo.Hint_Pos.Left := Trunc(EditHintLeft.Value);

    SkinInfo.ProgressNow_Rect.Left := Trunc(EditPressLeft.Value);
    SkinInfo.ProgressNow_Rect.Top := Trunc(EditPressTop.Value);
    SkinInfo.ProgressNow_Rect.Width := Trunc(EditPressWidth.Value);
    SkinInfo.ProgressNow_Rect.Height := Trunc(EditPressHeight.Value);
    SkinInfo.ProgressNow_Color1 := ColorPress1.ColorValue;
    SkinInfo.ProgressNow_Color2 := ColorPress2.ColorValue;

    SkinInfo.ProgressAll_Rect.Left := Trunc(EditPressAllLeft.Value);
    SkinInfo.ProgressAll_Rect.Top := Trunc(EditPressAllTop.Value);
    SkinInfo.ProgressAll_Rect.Width := Trunc(EditPressAllWidth.Value);
    SkinInfo.ProgressAll_Rect.Height := Trunc(EditPressAllHeight.Value);
    SkinInfo.ProgressAll_Color1 := ColorPressAll1.ColorValue;
    SkinInfo.ProgressAll_Color2 := ColorPressAll2.ColorValue;

    SkinInfo.ProgressNowHint_Pos.Top := Trunc(EditPressHintTop.Value);
    SkinInfo.ProgressNowHint_Pos.Left := Trunc(EditPressHintLeft.Value);
    SkinInfo.ProgressNowHint_Color := ColorPressNow.ColorValue;

    SkinInfo.ProgressAllHint_Pos.Top := Trunc(EditPressAllHintTop.Value);
    SkinInfo.ProgressAllHint_Pos.Left := Trunc(EditPressAllHintLeft.Value);
    SkinInfo.ProgressAllHint_Color := ColorPressAll.ColorValue;

    SkinInfo.Start_Pos.Top := Trunc(EditStartTop.Value);
    SkinInfo.Start_Pos.Left := Trunc(EditStartLeft.Value);
    TempMemoryStream.Clear;
    BtnPlay.PicIdle.Bitmap.SaveToStream(TempMemoryStream);
    SkinInfo.Start_Bitmap_Idle.Offset := MemoryStream.Position;
    SkinInfo.Start_Bitmap_Idle.Size := TempMemoryStream.Size;
    MemoryStream.CopyFrom(TempMemoryStream, 0);
    TempMemoryStream.Clear;
    BtnPlay.PicUp.Bitmap.SaveToStream(TempMemoryStream);
    SkinInfo.Start_Bitmap_Move.Offset := MemoryStream.Position;
    SkinInfo.Start_Bitmap_Move.Size := TempMemoryStream.Size;
    MemoryStream.CopyFrom(TempMemoryStream, 0);
    TempMemoryStream.Clear;
    BtnPlay.PicDown.Bitmap.SaveToStream(TempMemoryStream);
    SkinInfo.Start_Bitmap_Down.Offset := MemoryStream.Position;
    SkinInfo.Start_Bitmap_Down.Size := TempMemoryStream.Size;
    MemoryStream.CopyFrom(TempMemoryStream, 0);
    TempMemoryStream.Clear;
    BtnPlay.PicDsbld.Bitmap.SaveToStream(TempMemoryStream);
    SkinInfo.Start_Bitmap_Dsbld.Offset := MemoryStream.Position;
    SkinInfo.Start_Bitmap_Dsbld.Size := TempMemoryStream.Size;
    MemoryStream.CopyFrom(TempMemoryStream, 0);


    SkinInfo.Reg_boShow := CheckBoxReg.Checked;
    SkinInfo.Reg_Pos.Top := Trunc(EditRegTop.Value);
    SkinInfo.Reg_Pos.Left := Trunc(EditRegLeft.Value);
    if SkinInfo.Reg_boShow then begin
      TempMemoryStream.Clear;
      BtnUpdating.PicIdle.Bitmap.SaveToStream(TempMemoryStream);
      SkinInfo.Reg_Bitmap_Idle.Offset := MemoryStream.Position;
      SkinInfo.Reg_Bitmap_Idle.Size := TempMemoryStream.Size;
      MemoryStream.CopyFrom(TempMemoryStream, 0);
      TempMemoryStream.Clear;
      BtnUpdating.PicUp.Bitmap.SaveToStream(TempMemoryStream);
      SkinInfo.Reg_Bitmap_Move.Offset := MemoryStream.Position;
      SkinInfo.Reg_Bitmap_Move.Size := TempMemoryStream.Size;
      MemoryStream.CopyFrom(TempMemoryStream, 0);
      TempMemoryStream.Clear;
      BtnUpdating.PicDown.Bitmap.SaveToStream(TempMemoryStream);
      SkinInfo.Reg_Bitmap_Down.Offset := MemoryStream.Position;
      SkinInfo.Reg_Bitmap_Down.Size := TempMemoryStream.Size;
      MemoryStream.CopyFrom(TempMemoryStream, 0);
      TempMemoryStream.Clear;
      BtnUpdating.PicDsbld.Bitmap.SaveToStream(TempMemoryStream);
      SkinInfo.Reg_Bitmap_Dsbld.Offset := MemoryStream.Position;
      SkinInfo.Reg_Bitmap_Dsbld.Size := TempMemoryStream.Size;
      MemoryStream.CopyFrom(TempMemoryStream, 0);
    end;

    SkinInfo.ChangePass_boShow := CheckBoxChangePass.Checked;
    SkinInfo.ChangePass_Pos.Top := Trunc(EditChangePassTop.Value);
    SkinInfo.ChangePass_Pos.Left := Trunc(EditChangePassLeft.Value);
    if SkinInfo.ChangePass_boShow then begin
      TempMemoryStream.Clear;
      EzRgnBtn1.PicIdle.Bitmap.SaveToStream(TempMemoryStream);
      SkinInfo.ChangePass_Bitmap_Idle.Offset := MemoryStream.Position;
      SkinInfo.ChangePass_Bitmap_Idle.Size := TempMemoryStream.Size;
      MemoryStream.CopyFrom(TempMemoryStream, 0);
      TempMemoryStream.Clear;
      EzRgnBtn1.PicUp.Bitmap.SaveToStream(TempMemoryStream);
      SkinInfo.ChangePass_Bitmap_Move.Offset := MemoryStream.Position;
      SkinInfo.ChangePass_Bitmap_Move.Size := TempMemoryStream.Size;
      MemoryStream.CopyFrom(TempMemoryStream, 0);
      TempMemoryStream.Clear;
      EzRgnBtn1.PicDown.Bitmap.SaveToStream(TempMemoryStream);
      SkinInfo.ChangePass_Bitmap_Down.Offset := MemoryStream.Position;
      SkinInfo.ChangePass_Bitmap_Down.Size := TempMemoryStream.Size;
      MemoryStream.CopyFrom(TempMemoryStream, 0);
      TempMemoryStream.Clear;
      EzRgnBtn1.PicDsbld.Bitmap.SaveToStream(TempMemoryStream);
      SkinInfo.ChangePass_Bitmap_Dsbld.Offset := MemoryStream.Position;
      SkinInfo.ChangePass_Bitmap_Dsbld.Size := TempMemoryStream.Size;
      MemoryStream.CopyFrom(TempMemoryStream, 0);
    end;

    SkinInfo.LostPass_boShow := CheckBoxLostPass.Checked;
    SkinInfo.LostPass_Pos.Top := Trunc(EditLostPassTop.Value);
    SkinInfo.LostPass_Pos.Left := Trunc(EditLostPassLeft.Value);
    if SkinInfo.LostPass_boShow then begin
      TempMemoryStream.Clear;
      EzRgnBtn2.PicIdle.Bitmap.SaveToStream(TempMemoryStream);
      SkinInfo.LostPass_Bitmap_Idle.Offset := MemoryStream.Position;
      SkinInfo.LostPass_Bitmap_Idle.Size := TempMemoryStream.Size;
      MemoryStream.CopyFrom(TempMemoryStream, 0);
      TempMemoryStream.Clear;
      EzRgnBtn2.PicUp.Bitmap.SaveToStream(TempMemoryStream);
      SkinInfo.LostPass_Bitmap_Move.Offset := MemoryStream.Position;
      SkinInfo.LostPass_Bitmap_Move.Size := TempMemoryStream.Size;
      MemoryStream.CopyFrom(TempMemoryStream, 0);
      TempMemoryStream.Clear;
      EzRgnBtn2.PicDown.Bitmap.SaveToStream(TempMemoryStream);
      SkinInfo.LostPass_Bitmap_Down.Offset := MemoryStream.Position;
      SkinInfo.LostPass_Bitmap_Down.Size := TempMemoryStream.Size;
      MemoryStream.CopyFrom(TempMemoryStream, 0);
      TempMemoryStream.Clear;
      EzRgnBtn2.PicDsbld.Bitmap.SaveToStream(TempMemoryStream);
      SkinInfo.LostPass_Bitmap_Dsbld.Offset := MemoryStream.Position;
      SkinInfo.LostPass_Bitmap_Dsbld.Size := TempMemoryStream.Size;
      MemoryStream.CopyFrom(TempMemoryStream, 0);
    end;

    SkinInfo.Setup_boShow := CheckBoxSetup.Checked;
    SkinInfo.Setup_Pos.Top := Trunc(EditSetupTop.Value);
    SkinInfo.Setup_Pos.Left := Trunc(EditSetupLeft.Value);
    if SkinInfo.Setup_boShow then begin
      TempMemoryStream.Clear;
      BtnSetup.PicIdle.Bitmap.SaveToStream(TempMemoryStream);
      SkinInfo.Setup_Bitmap_Idle.Offset := MemoryStream.Position;
      SkinInfo.Setup_Bitmap_Idle.Size := TempMemoryStream.Size;
      MemoryStream.CopyFrom(TempMemoryStream, 0);
      TempMemoryStream.Clear;
      BtnSetup.PicUp.Bitmap.SaveToStream(TempMemoryStream);
      SkinInfo.Setup_Bitmap_Move.Offset := MemoryStream.Position;
      SkinInfo.Setup_Bitmap_Move.Size := TempMemoryStream.Size;
      MemoryStream.CopyFrom(TempMemoryStream, 0);
      TempMemoryStream.Clear;
      BtnSetup.PicDown.Bitmap.SaveToStream(TempMemoryStream);
      SkinInfo.Setup_Bitmap_Down.Offset := MemoryStream.Position;
      SkinInfo.Setup_Bitmap_Down.Size := TempMemoryStream.Size;
      MemoryStream.CopyFrom(TempMemoryStream, 0);
    end;

    SkinInfo.Home_boShow := CheckBoxHome.Checked;
    SkinInfo.Home_Pos.Top := Trunc(EditHomeTop.Value);
    SkinInfo.Home_Pos.Left := Trunc(EditHomeLeft.Value);
    if SkinInfo.Home_boShow then begin
      TempMemoryStream.Clear;
      EzRgnBtn3.PicIdle.Bitmap.SaveToStream(TempMemoryStream);
      SkinInfo.Home_Bitmap_Idle.Offset := MemoryStream.Position;
      SkinInfo.Home_Bitmap_Idle.Size := TempMemoryStream.Size;
      MemoryStream.CopyFrom(TempMemoryStream, 0);
      TempMemoryStream.Clear;
      EzRgnBtn3.PicUp.Bitmap.SaveToStream(TempMemoryStream);
      SkinInfo.Home_Bitmap_Move.Offset := MemoryStream.Position;
      SkinInfo.Home_Bitmap_Move.Size := TempMemoryStream.Size;
      MemoryStream.CopyFrom(TempMemoryStream, 0);
      TempMemoryStream.Clear;
      EzRgnBtn3.PicDown.Bitmap.SaveToStream(TempMemoryStream);
      SkinInfo.Home_Bitmap_Down.Offset := MemoryStream.Position;
      SkinInfo.Home_Bitmap_Down.Size := TempMemoryStream.Size;
      MemoryStream.CopyFrom(TempMemoryStream, 0);
    end;

    SkinInfo.Pay_boShow := CheckBoxPay.Checked;
    SkinInfo.Pay_Pos.Top := Trunc(EditPayTop.Value);
    SkinInfo.Pay_Pos.Left := Trunc(EditPayLeft.Value);
    if SkinInfo.Pay_boShow then begin
      TempMemoryStream.Clear;
      EzRgnBtn4.PicIdle.Bitmap.SaveToStream(TempMemoryStream);
      SkinInfo.Pay_Bitmap_Idle.Offset := MemoryStream.Position;
      SkinInfo.Pay_Bitmap_Idle.Size := TempMemoryStream.Size;
      MemoryStream.CopyFrom(TempMemoryStream, 0);
      TempMemoryStream.Clear;
      EzRgnBtn4.PicUp.Bitmap.SaveToStream(TempMemoryStream);
      SkinInfo.Pay_Bitmap_Move.Offset := MemoryStream.Position;
      SkinInfo.Pay_Bitmap_Move.Size := TempMemoryStream.Size;
      MemoryStream.CopyFrom(TempMemoryStream, 0);
      TempMemoryStream.Clear;
      EzRgnBtn4.PicDown.Bitmap.SaveToStream(TempMemoryStream);
      SkinInfo.Pay_Bitmap_Down.Offset := MemoryStream.Position;
      SkinInfo.Pay_Bitmap_Down.Size := TempMemoryStream.Size;
      MemoryStream.CopyFrom(TempMemoryStream, 0);
    end;

    SkinInfo.Exit_boShow := CheckBoxExit.Checked;
    SkinInfo.Exit_Pos.Top := Trunc(EditExitTop.Value);
    SkinInfo.Exit_Pos.Left := Trunc(EditExitLeft.Value);
    if SkinInfo.Exit_boShow then begin
      TempMemoryStream.Clear;
      BtnExit.PicIdle.Bitmap.SaveToStream(TempMemoryStream);
      SkinInfo.Exit_Bitmap_Idle.Offset := MemoryStream.Position;
      SkinInfo.Exit_Bitmap_Idle.Size := TempMemoryStream.Size;
      MemoryStream.CopyFrom(TempMemoryStream, 0);
      TempMemoryStream.Clear;
      BtnExit.PicUp.Bitmap.SaveToStream(TempMemoryStream);
      SkinInfo.Exit_Bitmap_Move.Offset := MemoryStream.Position;
      SkinInfo.Exit_Bitmap_Move.Size := TempMemoryStream.Size;
      MemoryStream.CopyFrom(TempMemoryStream, 0);
      TempMemoryStream.Clear;
      BtnExit.PicDown.Bitmap.SaveToStream(TempMemoryStream);
      SkinInfo.Exit_Bitmap_Down.Offset := MemoryStream.Position;
      SkinInfo.Exit_Bitmap_Down.Size := TempMemoryStream.Size;
      MemoryStream.CopyFrom(TempMemoryStream, 0);
    end;

    SkinInfo.Min_boShow := CheckBoxMin.Checked;
    SkinInfo.Min_Pos.Top := Trunc(EditMinTop.Value);
    SkinInfo.Min_Pos.Left := Trunc(EditMinLeft.Value);
    if SkinInfo.Min_boShow then begin
      TempMemoryStream.Clear;
      BtnMin.PicIdle.Bitmap.SaveToStream(TempMemoryStream);
      SkinInfo.Min_Bitmap_Idle.Offset := MemoryStream.Position;
      SkinInfo.Min_Bitmap_Idle.Size := TempMemoryStream.Size;
      MemoryStream.CopyFrom(TempMemoryStream, 0);
      TempMemoryStream.Clear;
      BtnMin.PicUp.Bitmap.SaveToStream(TempMemoryStream);
      SkinInfo.Min_Bitmap_Move.Offset := MemoryStream.Position;
      SkinInfo.Min_Bitmap_Move.Size := TempMemoryStream.Size;
      MemoryStream.CopyFrom(TempMemoryStream, 0);
      TempMemoryStream.Clear;
      BtnMin.PicDown.Bitmap.SaveToStream(TempMemoryStream);
      SkinInfo.Min_Bitmap_Down.Offset := MemoryStream.Position;
      SkinInfo.Min_Bitmap_Down.Size := TempMemoryStream.Size;
      MemoryStream.CopyFrom(TempMemoryStream, 0);
    end;

    SkinInfo.Close_boShow := CheckBoxClose.Checked;
    SkinInfo.Close_Pos.Top := Trunc(EditCloseTop.Value);
    SkinInfo.Close_Pos.Left := Trunc(EditCloseLeft.Value);
    if SkinInfo.Close_boShow then begin
      TempMemoryStream.Clear;
      BtnClose.PicIdle.Bitmap.SaveToStream(TempMemoryStream);
      SkinInfo.Close_Bitmap_Idle.Offset := MemoryStream.Position;
      SkinInfo.Close_Bitmap_Idle.Size := TempMemoryStream.Size;
      MemoryStream.CopyFrom(TempMemoryStream, 0);
      TempMemoryStream.Clear;
      BtnClose.PicUp.Bitmap.SaveToStream(TempMemoryStream);
      SkinInfo.Close_Bitmap_Move.Offset := MemoryStream.Position;
      SkinInfo.Close_Bitmap_Move.Size := TempMemoryStream.Size;
      MemoryStream.CopyFrom(TempMemoryStream, 0);
      TempMemoryStream.Clear;
      BtnClose.PicDown.Bitmap.SaveToStream(TempMemoryStream);
      SkinInfo.Close_Bitmap_Down.Offset := MemoryStream.Position;
      SkinInfo.Close_Bitmap_Down.Size := TempMemoryStream.Size;
      MemoryStream.CopyFrom(TempMemoryStream, 0);
    end;
    MemoryStream.Write(SkinInfo, SizeOf(SkinInfo));
    CompressBuf(MemoryStream.Memory, MemoryStream.Size, WriteBuffer, WriteSize);
    if WriteSize > 0 then begin
      MemoryStream.Clear;
      SkinHeader.sTitle := LOGINSKININFOTITLE;
      SkinHeader.nVar := LOGINSKININFOVAR;
      SkinHeader.nSize := WriteSize;
      MemoryStream.Write(SkinHeader, SizeOf(SkinHeader));
      MemoryStream.Write(WriteBuffer^, WriteSize);
      FreeMem(WriteBuffer);
      Result := True;
    end;
  Finally
    TempMemoryStream.Free;
  End;
end;

procedure TFrameMakeLogin.BChangePassDownLoadClick(Sender: TObject);
begin
  if FormMain.OpenPictureDialog.Execute then begin
    if FileExists(FormMain.OpenPictureDialog.FileName) then begin
      EzRgnBtn1.PicDown.LoadFromFile(FormMain.OpenPictureDialog.FileName);
    end;
  end;
end;

procedure TFrameMakeLogin.BChangePassDsbldLoadClick(Sender: TObject);
begin
  if FormMain.OpenPictureDialog.Execute then begin
    if FileExists(FormMain.OpenPictureDialog.FileName) then begin
      EzRgnBtn1.PicDsbld.LoadFromFile(FormMain.OpenPictureDialog.FileName);
    end;
  end;
end;

procedure TFrameMakeLogin.BChangePassIdleLoadClick(Sender: TObject);
begin
  if FormMain.OpenPictureDialog.Execute then begin
    if FileExists(FormMain.OpenPictureDialog.FileName) then begin
      EzRgnBtn1.PicIdle.LoadFromFile(FormMain.OpenPictureDialog.FileName);
    end;
  end;
end;

procedure TFrameMakeLogin.BChangePassMoveLoadClick(Sender: TObject);
begin
  if FormMain.OpenPictureDialog.Execute then begin
    if FileExists(FormMain.OpenPictureDialog.FileName) then begin
      EzRgnBtn1.PicUp.LoadFromFile(FormMain.OpenPictureDialog.FileName);
    end;
  end;
end;

procedure TFrameMakeLogin.BGImgLoadClick(Sender: TObject);
var
  DIB: TDIB;
  OldFilter: string;
  //JPG: TJPEGImage;
begin
  OldFilter := FormMain.OpenPictureDialog.Filter;
  FormMain.OpenPictureDialog.Filter := 'Bitmaps (*.bmp)|*.bmp|JPEG (*.JPG;*.JPEG)|*.jpg;*.jpeg';
  //JPG := TJPEGImage.Create;
  Try
    if FormMain.OpenPictureDialog.Execute then begin
      if FileExists(FormMain.OpenPictureDialog.FileName) then begin  //TJPEGImage
        //imgBG.Picture.Graphic := JPG;
        imgBG.Picture.LoadFromFile(FormMain.OpenPictureDialog.FileName);
        DIB := TDIB.Create;
        Try
          DIB.Assign(imgBG.Picture);
          BGTransparentColor.ColorValue := TColor(DIB.Pixels[0, 0]);
        Finally
          DIB.Free;
        End;
      end;
    end;
  Finally
    //JPG.Free;
    FormMain.OpenPictureDialog.Filter := OldFilter;
  End;
end;

procedure TFrameMakeLogin.BGTransparentClick(Sender: TObject);
begin
  BGTransparentColor.Enabled := BGTransparent.Checked;
end;

procedure TFrameMakeLogin.BHomeDownLoadClick(Sender: TObject);
begin
  if FormMain.OpenPictureDialog.Execute then begin
    if FileExists(FormMain.OpenPictureDialog.FileName) then begin
      EzRgnbtn3.PicDown.LoadFromFile(FormMain.OpenPictureDialog.FileName);
    end;
  end;
end;

procedure TFrameMakeLogin.BHomeIdleLoadClick(Sender: TObject);
begin
  if FormMain.OpenPictureDialog.Execute then begin
    if FileExists(FormMain.OpenPictureDialog.FileName) then begin
      EzRgnbtn3.PicIdle.LoadFromFile(FormMain.OpenPictureDialog.FileName);
    end;
  end;
end;

procedure TFrameMakeLogin.BHomeMoveLoadClick(Sender: TObject);
begin
  if FormMain.OpenPictureDialog.Execute then begin
    if FileExists(FormMain.OpenPictureDialog.FileName) then begin
      EzRgnbtn3.PicUp.LoadFromFile(FormMain.OpenPictureDialog.FileName);
    end;
  end;
end;

procedure TFrameMakeLogin.BLostPassDownLoadClick(Sender: TObject);
begin
  if FormMain.OpenPictureDialog.Execute then begin
    if FileExists(FormMain.OpenPictureDialog.FileName) then begin
      EzRgnbtn2.PicDown.LoadFromFile(FormMain.OpenPictureDialog.FileName);
    end;
  end;
end;

procedure TFrameMakeLogin.BLostPassDsbldLoadClick(Sender: TObject);
begin
  if FormMain.OpenPictureDialog.Execute then begin
    if FileExists(FormMain.OpenPictureDialog.FileName) then begin
      EzRgnbtn2.PicDsbld.LoadFromFile(FormMain.OpenPictureDialog.FileName);
    end;
  end;
end;

procedure TFrameMakeLogin.BLostPassIdleLoadClick(Sender: TObject);
begin
  if FormMain.OpenPictureDialog.Execute then begin
    if FileExists(FormMain.OpenPictureDialog.FileName) then begin
      EzRgnbtn2.PicIdle.LoadFromFile(FormMain.OpenPictureDialog.FileName);
    end;
  end;
end;

procedure TFrameMakeLogin.BLostPassMoveLoadClick(Sender: TObject);
begin
  if FormMain.OpenPictureDialog.Execute then begin
    if FileExists(FormMain.OpenPictureDialog.FileName) then begin
      EzRgnbtn2.PicUp.LoadFromFile(FormMain.OpenPictureDialog.FileName);
    end;
  end;
end;

procedure TFrameMakeLogin.BPayDownLoadClick(Sender: TObject);
begin
  if FormMain.OpenPictureDialog.Execute then begin
    if FileExists(FormMain.OpenPictureDialog.FileName) then begin
      EzRgnBtn4.PicDown.LoadFromFile(FormMain.OpenPictureDialog.FileName);
    end;
  end;
end;

procedure TFrameMakeLogin.BPayIdleLoadClick(Sender: TObject);
begin
  if FormMain.OpenPictureDialog.Execute then begin
    if FileExists(FormMain.OpenPictureDialog.FileName) then begin
      EzRgnBtn4.PicIdle.LoadFromFile(FormMain.OpenPictureDialog.FileName);
    end;
  end;
end;

procedure TFrameMakeLogin.BPayMoveLoadClick(Sender: TObject);
begin
  if FormMain.OpenPictureDialog.Execute then begin
    if FileExists(FormMain.OpenPictureDialog.FileName) then begin
      EzRgnBtn4.PicUp.LoadFromFile(FormMain.OpenPictureDialog.FileName);
    end;
  end;
end;

procedure TFrameMakeLogin.BRegDownLoadClick(Sender: TObject);
begin
  if FormMain.OpenPictureDialog.Execute then begin
    if FileExists(FormMain.OpenPictureDialog.FileName) then begin
      BtnUpdating.PicDown.LoadFromFile(FormMain.OpenPictureDialog.FileName);
    end;
  end;
end;

procedure TFrameMakeLogin.BRegDsbldLoadClick(Sender: TObject);
begin
  if FormMain.OpenPictureDialog.Execute then begin
    if FileExists(FormMain.OpenPictureDialog.FileName) then begin
      BtnUpdating.PicDsbld.LoadFromFile(FormMain.OpenPictureDialog.FileName);
    end;
  end;
end;

procedure TFrameMakeLogin.BRegIdleLoadClick(Sender: TObject);
begin
  if FormMain.OpenPictureDialog.Execute then begin
    if FileExists(FormMain.OpenPictureDialog.FileName) then begin
      BtnUpdating.PicIdle.LoadFromFile(FormMain.OpenPictureDialog.FileName);
    end;
  end;
end;

procedure TFrameMakeLogin.BRegMoveLoadClick(Sender: TObject);
begin
  if FormMain.OpenPictureDialog.Execute then begin
    if FileExists(FormMain.OpenPictureDialog.FileName) then begin
      BtnUpdating.PicUp.LoadFromFile(FormMain.OpenPictureDialog.FileName);
    end;
  end;
end;

procedure TFrameMakeLogin.BSetupDownLoadClick(Sender: TObject);
begin
  if FormMain.OpenPictureDialog.Execute then begin
    if FileExists(FormMain.OpenPictureDialog.FileName) then begin
      btnSetup.PicDown.LoadFromFile(FormMain.OpenPictureDialog.FileName);
    end;
  end;
end;

procedure TFrameMakeLogin.BSetupIdleLoadClick(Sender: TObject);
begin
  if FormMain.OpenPictureDialog.Execute then begin
    if FileExists(FormMain.OpenPictureDialog.FileName) then begin
      btnSetup.PicIdle.LoadFromFile(FormMain.OpenPictureDialog.FileName);
    end;
  end;
end;

procedure TFrameMakeLogin.BSetupMoveLoadClick(Sender: TObject);
begin
  if FormMain.OpenPictureDialog.Execute then begin
    if FileExists(FormMain.OpenPictureDialog.FileName) then begin
      btnSetup.PicUp.LoadFromFile(FormMain.OpenPictureDialog.FileName);
    end;
  end;
end;

procedure TFrameMakeLogin.bsSkinButton1Click(Sender: TObject);
var
  SaveStream: TMemoryStream;
begin
  FormMain.SaveDialog.FileName := '';
  if FormMain.SaveDialog.Execute then begin
    if FileExists(FormMain.SaveDialog.FileName) then begin
      if FormMain.DMsg.MessageDlg('该文件已经存在，是否替换该文件？', mtConfirmation, [mbYes, mbNo], 0) <> mrYes then begin
        Exit;
      end;
    end;
    SaveStream := TMemoryStream.Create;
    Try
      if MakeSaveInfo(SaveStream) then begin
        SaveStream.SaveToFile(FormMain.SaveDialog.FileName);
        FormMain.DMsg.MessageDlg('保存皮肤信息成功！', mtInformation, [mbYes], 0);
      end else
        FormMain.DMsg.MessageDlg('保存皮肤信息失败！', mtError, [mbYes], 0);
    Finally
      SaveStream.Free;
    End;
  end;
end;

procedure TFrameMakeLogin.bsSkinButton2Click(Sender: TObject);
begin
  FormMain.Hide;
  Try
    FormPreview := TFormPreview.Create(Owner);
    FormPreview.Open();
    FormPreview.Free;
  Finally
    FormMain.Show;
  End;
end;

procedure TFrameMakeLogin.bsSkinButton55Click(Sender: TObject);
begin
  if FormMain.OpenPictureDialog.Execute then begin
    if FileExists(FormMain.OpenPictureDialog.FileName) then begin
      btnExit.PicIdle.LoadFromFile(FormMain.OpenPictureDialog.FileName);
    end;
  end;
end;

procedure TFrameMakeLogin.bsSkinButton57Click(Sender: TObject);
begin
  if FormMain.OpenPictureDialog.Execute then begin
    if FileExists(FormMain.OpenPictureDialog.FileName) then begin
      btnExit.PicUp.LoadFromFile(FormMain.OpenPictureDialog.FileName);
    end;
  end;
end;

procedure TFrameMakeLogin.bsSkinButton59Click(Sender: TObject);
begin
  if FormMain.OpenPictureDialog.Execute then begin
    if FileExists(FormMain.OpenPictureDialog.FileName) then begin
      btnExit.PicDown.LoadFromFile(FormMain.OpenPictureDialog.FileName);
    end;
  end;
end;

procedure TFrameMakeLogin.bsSkinButton61Click(Sender: TObject);
begin
  if FormMain.OpenPictureDialog.Execute then begin
    if FileExists(FormMain.OpenPictureDialog.FileName) then begin
      btnMin.PicIdle.LoadFromFile(FormMain.OpenPictureDialog.FileName);
    end;
  end;
end;

procedure TFrameMakeLogin.bsSkinButton63Click(Sender: TObject);
begin
  if FormMain.OpenPictureDialog.Execute then begin
    if FileExists(FormMain.OpenPictureDialog.FileName) then begin
      btnMin.PicUp.LoadFromFile(FormMain.OpenPictureDialog.FileName);
    end;
  end;
end;

procedure TFrameMakeLogin.bsSkinButton65Click(Sender: TObject);
begin
  if FormMain.OpenPictureDialog.Execute then begin
    if FileExists(FormMain.OpenPictureDialog.FileName) then begin
      btnMin.PicDown.LoadFromFile(FormMain.OpenPictureDialog.FileName);
    end;
  end;
end;

procedure TFrameMakeLogin.bsSkinButton67Click(Sender: TObject);
begin
  if FormMain.OpenPictureDialog.Execute then begin
    if FileExists(FormMain.OpenPictureDialog.FileName) then begin
      btnClose.PicIdle.LoadFromFile(FormMain.OpenPictureDialog.FileName);
    end;
  end;
end;

procedure TFrameMakeLogin.bsSkinButton69Click(Sender: TObject);
begin
  if FormMain.OpenPictureDialog.Execute then begin
    if FileExists(FormMain.OpenPictureDialog.FileName) then begin
      btnClose.PicUp.LoadFromFile(FormMain.OpenPictureDialog.FileName);
    end;
  end;
end;

procedure TFrameMakeLogin.bsSkinButton71Click(Sender: TObject);
begin
  if FormMain.OpenPictureDialog.Execute then begin
    if FileExists(FormMain.OpenPictureDialog.FileName) then begin
      btnClose.PicDown.LoadFromFile(FormMain.OpenPictureDialog.FileName);
    end;
  end;
end;

procedure TFrameMakeLogin.BStartDownLoadClick(Sender: TObject);
begin
  if FormMain.OpenPictureDialog.Execute then begin
    if FileExists(FormMain.OpenPictureDialog.FileName) then begin
      btnPlay.PicDown.LoadFromFile(FormMain.OpenPictureDialog.FileName);
    end;
  end;
end;

procedure TFrameMakeLogin.BStartDsbldLoadClick(Sender: TObject);
begin
  if FormMain.OpenPictureDialog.Execute then begin
    if FileExists(FormMain.OpenPictureDialog.FileName) then begin
      btnPlay.PicDsbld.LoadFromFile(FormMain.OpenPictureDialog.FileName);
    end;
  end;
end;

procedure TFrameMakeLogin.BStartIdleLoadClick(Sender: TObject);
begin
  if FormMain.OpenPictureDialog.Execute then begin
    if FileExists(FormMain.OpenPictureDialog.FileName) then begin
      btnPlay.PicIdle.LoadFromFile(FormMain.OpenPictureDialog.FileName);
    end;
  end;
end;

procedure TFrameMakeLogin.BStartMoveLoadClick(Sender: TObject);
begin
  if FormMain.OpenPictureDialog.Execute then begin
    if FileExists(FormMain.OpenPictureDialog.FileName) then begin
      btnPlay.PicUp.LoadFromFile(FormMain.OpenPictureDialog.FileName);
    end;
  end;
end;

procedure TFrameMakeLogin.ButtonSaveClick(Sender: TObject);
var
  OldFilter: string;
  FileStream: TFileStream;
  SkinHeader: TLoginSkinHeader;
  Buffer: PChar;
  GetBuffer: Pointer;
  GetSize: Integer;
  SkinInfo: TLoginSkinInfo;
begin
  OldFilter := FormMain.OpenDialog.Filter;
  FormMain.OpenDialog.Filter := '361M2专用皮肤文件 (*.361Skin)|*.361Skin';
  Try
    if FormMain.OpenDialog.Execute then begin
      if FileExists(FormMain.OpenDialog.FileName) then begin
        FileStream := TFileStream.Create(FormMain.OpenDialog.FileName, fmOpenRead);
        Try
          if FileStream.Read(SkinHeader, SizeOf(SkinHeader)) = SizeOf(SkinHeader) then begin
            if (SkinHeader.sTitle = LOGINSKININFOTITLE) and (SkinHeader.nVar = LOGINSKININFOVAR) and (SkinHeader.nSize > 0) then begin
              GetMem(Buffer, SkinHeader.nSize);
              Try
                if FileStream.Read(Buffer^, SkinHeader.nSize) = SkinHeader.nSize then begin
                  DecompressBuf(Buffer, SkinHeader.nSize, 0, GetBuffer, GetSize);
                  if GetSize > 0 then begin
                    Move(PChar(GetBuffer)[GetSize - SizeOf(SkinInfo)], SkinInfo, SizeOf(SkinInfo));
                    InitSetup(@SkinInfo, GetBuffer);
                    Exit;
                  end;
                  FreeMem(GetBuffer);
                end;
              Finally
                FreeMem(Buffer);
              End;
            end;
            FormMain.DMsg.MessageDlg('加载皮肤失败，皮肤版本不符合要求！', mtError, [mbYes], 0);
          end;
        Finally
          FileStream.Free;
        End;
      end;
    end;
  Finally
    FormMain.OpenDialog.Filter := OldFilter;
  End;
end;

procedure TFrameMakeLogin.ChangeIEBG(nWidth, nHeight: Integer);
var
  Bitmap: TBitmap;
  Rect, RDest: TRect;
begin
  imgIE.Width := nWidth;
  imgIE.Height := nHeight;
  Bitmap := TBitmap.Create;
  Try
    Bitmap.PixelFormat := imgIEMark.Picture.Bitmap.PixelFormat;
    Bitmap.Width := nWidth;
    Bitmap.Height := nHeight;
    Rect.Left := 0;
    Rect.Top := 0;
    Rect.Right := nWidth;
    Rect.Bottom := nHeight;
    Bitmap.Canvas.Brush.Color := clBlack;
    Bitmap.Canvas.FillRect(Rect);
    RDest.Left := 0;
    RDest.Top := 0;
    RDest.Right := imgIEMark.Picture.Bitmap.Width;
    RDest.Bottom := imgIEMark.Picture.Bitmap.Height;
    Bitmap.Canvas.CopyRect(RDest, imgIEMark.Picture.Bitmap.Canvas, RDest);
    imgIE.Picture.Bitmap := Bitmap;
  Finally
    Bitmap.Free;
  End;
end;

procedure TFrameMakeLogin.ChangeServerListBG(nWidth, nHeight: Integer);
var
  Bitmap: TBitmap;
  Rect, RDest: TRect;
begin
  imgServerList.Width := nWidth;
  imgServerList.Height := nHeight;
  Bitmap := TBitmap.Create;
  Try
    Bitmap.PixelFormat := pf8bit;
    Bitmap.Width := nWidth;
    Bitmap.Height := nHeight;
    Rect.Left := 0;
    Rect.Top := 0;
    Rect.Right := nWidth;
    Rect.Bottom := nHeight;
    Bitmap.Canvas.Brush.Color := clBlack;
    Bitmap.Canvas.FillRect(Rect);
    RDest.Left := 0;
    RDest.Top := 0;
    RDest.Right := imgServerListMark.Picture.Bitmap.Width;
    RDest.Bottom := imgServerListMark.Picture.Bitmap.Height;
    Bitmap.Canvas.CopyRect(RDest, imgServerListMark.Picture.Bitmap.Canvas, RDest);
    imgServerList.Picture.Bitmap := Bitmap;
  Finally
    Bitmap.Free;
  End;
end;

procedure TFrameMakeLogin.CheckBoxChangePassClick(Sender: TObject);
begin
  EzRgnbtn1.Visible := CheckBoxChangePass.Checked;
end;

procedure TFrameMakeLogin.CheckBoxCloseClick(Sender: TObject);
begin
  btnClose.Visible := CheckBoxClose.Checked;
end;

procedure TFrameMakeLogin.CheckBoxExitClick(Sender: TObject);
begin
  BtnExit.Visible := CheckBoxExit.Checked;
end;

procedure TFrameMakeLogin.CheckBoxHomeClick(Sender: TObject);
begin
  EzRgnBtn3.Visible := CheckBoxHome.Checked;
end;

procedure TFrameMakeLogin.CheckBoxLostPassClick(Sender: TObject);
begin
  EzRgnbtn2.Visible := CheckBoxLostPass.Checked;
end;

procedure TFrameMakeLogin.CheckBoxMinClick(Sender: TObject);
begin
  btnMin.Visible := CheckBoxMin.Checked;
end;

procedure TFrameMakeLogin.CheckBoxPayClick(Sender: TObject);
begin
  EzRgnBtn4.Visible := CheckBoxPay.Checked;
end;

procedure TFrameMakeLogin.CheckBoxRegClick(Sender: TObject);
begin
  BtnUpdating.Visible := CheckBoxReg.Checked;
end;

procedure TFrameMakeLogin.CheckBoxSetupClick(Sender: TObject);
begin
  btnSetup.Visible := CheckBoxSetup.Checked;
end;

procedure TFrameMakeLogin.ColorPress1ChangeColor(Sender: TObject);
begin
  if boFrist then
    ProgressNow.BarColor := ColorPress1.ColorValue;
end;

procedure TFrameMakeLogin.ColorPress2ChangeColor(Sender: TObject);
begin
  if boFrist then
    ProgressNow.BarColorStop := ColorPress2.ColorValue;
end;

procedure TFrameMakeLogin.ColorPressAll1ChangeColor(Sender: TObject);
begin
  ProgressAll.BarColor := ColorPressAll1.ColorValue;
  ProgressAll.BarColorStop := ColorPressAll2.ColorValue;
end;

procedure TFrameMakeLogin.ColorPressAllChangeColor(Sender: TObject);
begin
  LabelAll.Font.Color := ColorPressAll.ColorValue;
end;

procedure TFrameMakeLogin.ColorPressNowChangeColor(Sender: TObject);
begin
  LabelNow.Font.Color := ColorPressNow.ColorValue;
end;

procedure TFrameMakeLogin.ColorVarChangeColor(Sender: TObject);
begin
  LabelVar.Font.Color := ColorVar.ColorValue;
end;

procedure TFrameMakeLogin.ComboBoxDBListChange(Sender: TObject);
var
  I: Integer;
begin
  for I := Low(FGroupBox) to High(FGroupBox) do begin
    FGroupBox[I].Visible := False;
  end;

  if (ComboBoxDBList.ItemIndex in [Low(FGroupBox)..High(FGroupBox)]) then begin
    FGroupBox[ComboBoxDBList.ItemIndex].Visible := True;
  end;
end;

procedure TFrameMakeLogin.EditChangePassLeftChange(Sender: TObject);
begin
  if boFrist then begin
    EzRgnbtn1.Left := Trunc(EditChangePassLeft.Value);
    EzRgnbtn1.Top := Trunc(EditChangePassTop.Value);
  end;
end;

procedure TFrameMakeLogin.EditCloseLeftChange(Sender: TObject);
begin
  if boFrist then begin
    BtnClose.Left := Trunc(EditCloseLeft.Value);
    BtnClose.Top := Trunc(EditCloseTop.Value);
  end;
end;

procedure TFrameMakeLogin.EditExitLeftChange(Sender: TObject);
begin
  if boFrist then begin
    BtnExit.Left := Trunc(EditExitLeft.Value);
    BtnExit.Top := Trunc(EditExitTop.Value);
  end;
end;

procedure TFrameMakeLogin.EditHintTopChange(Sender: TObject);
begin
  if boFrist then begin
    LabelLog.Left := Trunc(EditHintLeft.Value);
    LabelLog.Top := Trunc(EditHintTop.Value);
  end;
end;

procedure TFrameMakeLogin.EditHomeLeftChange(Sender: TObject);
begin
  if boFrist then begin
    EzRgnBtn3.Left := Trunc(EditHomeLeft.Value);
    EzRgnBtn3.Top := Trunc(EditHomeTop.Value);
  end;
end;

procedure TFrameMakeLogin.EditIETopChange(Sender: TObject);
begin
  if boFrist then begin
    imgIE.Left := Trunc(EditIELeft.Value);
    imgIE.Top := Trunc(EditIETop.Value);
  end;
end;

procedure TFrameMakeLogin.EditIEWidthChange(Sender: TObject);
begin
  if boFrist then begin
    ChangeIEBG(Trunc(EditIEWidth.Value), Trunc(EditIEHeight.Value));
  end;
end;

procedure TFrameMakeLogin.EditLostPassLeftChange(Sender: TObject);
begin
  if boFrist then begin
    EzRgnbtn2.Left := Trunc(EditLostPassLeft.Value);
    EzRgnbtn2.Top := Trunc(EditLostPassTop.Value);
  end;
end;

procedure TFrameMakeLogin.EditMinLeftChange(Sender: TObject);
begin
  if boFrist then begin
    BtnMin.Left := Trunc(EditMinLeft.Value);
    BtnMin.Top := Trunc(EditMinTop.Value);
  end;
end;

procedure TFrameMakeLogin.EditPayLeftChange(Sender: TObject);
begin
  if boFrist then begin
    EzRgnBtn4.Left := Trunc(EditPayLeft.Value);
    EzRgnBtn4.Top := Trunc(EditPayTop.Value);
  end;
end;

procedure TFrameMakeLogin.EditPressAllHintTopChange(Sender: TObject);
begin
  if boFrist then begin
    LabelAll.Left := Trunc(EditPressAllHintLeft.Value);
    LabelAll.Top := Trunc(EditPressAllHintTop.Value);
  end;
end;

procedure TFrameMakeLogin.EditPressAllLeftChange(Sender: TObject);
begin
  if boFrist then begin
    ProgressAll.Left := Trunc(EditPressAllLeft.Value);
    ProgressAll.Top := Trunc(EditPressAllTop.Value);
  end;
end;

procedure TFrameMakeLogin.EditPressAllWidthChange(Sender: TObject);
begin
  if boFrist then begin
    ProgressAll.Width := Trunc(EditPressAllWidth.Value);
    ProgressAll.Height := Trunc(EditPressAllHeight.Value);
  end;
end;

procedure TFrameMakeLogin.EditPressHintLeftChange(Sender: TObject);
begin
  if boFrist then begin
    LabelNow.Left := Trunc(EditPressHintLeft.Value);
    LabelNow.Top := Trunc(EditPressHintTop.Value);
  end;
end;

procedure TFrameMakeLogin.EditPressLeftChange(Sender: TObject);
begin
  if boFrist then begin
    ProgressNow.Left := Trunc(EditPressLeft.Value);
    ProgressNow.Top := Trunc(EditPressTop.Value);
  end;
end;

procedure TFrameMakeLogin.EditPressWidthChange(Sender: TObject);
begin
  if boFrist then begin
    ProgressNow.Width := Trunc(EditPressWidth.Value);
    ProgressNow.Height := Trunc(EditPressHeight.Value);
  end;
end;

procedure TFrameMakeLogin.EditRegLeftChange(Sender: TObject);
begin
  if boFrist then begin
    BtnUpdating.Left := Trunc(EditRegLeft.Value);
    BtnUpdating.Top := Trunc(EditRegTop.Value);
  end;
end;

procedure TFrameMakeLogin.EditServerListLeftChange(Sender: TObject);
begin
  if boFrist then begin
    imgServerList.Left := Trunc(EditServerListLeft.Value);
    imgServerList.Top := Trunc(EditServerListTop.Value);
  end;
end;

procedure TFrameMakeLogin.EditServerListWidthChange(Sender: TObject);
begin
  if boFrist then begin
    ChangeServerListBG(Trunc(EditServerListWidth.Value), Trunc(EditServerListHeight.Value));
  end;
end;

procedure TFrameMakeLogin.EditSetupLeftChange(Sender: TObject);
begin
  if boFrist then begin
    BtnSetup.Left := Trunc(EditSetupLeft.Value);
    BtnSetup.Top := Trunc(EditSetupTop.Value);
  end;
end;

procedure TFrameMakeLogin.EditStartLeftChange(Sender: TObject);
begin
  if boFrist then begin
    BtnPlay.Left := Trunc(EditStartLeft.Value);
    BtnPlay.Top := Trunc(EditStartTop.Value);
  end;
end;

procedure TFrameMakeLogin.Open;
begin
  FSpotTag := -1;
  FSpotControl := nil;
  FGroupBox[0] := GroupBoxSetupBG;
  FGroupBox[1] := GroupBoxSetupServerList;
  FGroupBox[2] := GroupBoxSetupIE;
  FGroupBox[3] := GroupBoxSetupVar;
  FGroupBox[4] := GroupBoxSetupHint;
  FGroupBox[5] := GroupBoxSetupProgressNow;
  FGroupBox[6] := GroupBoxSetupProgressAll;
  FGroupBox[7] := GroupBoxSetupNowHint;
  FGroupBox[8] := GroupBoxSetupAllHint;
  FGroupBox[9] := GroupBoxSetupBStart;
  FGroupBox[10] := GroupBoxSetupReg;
  FGroupBox[11] := GroupBoxSetupChangePass;
  FGroupBox[12] := GroupBoxSetupLostPass;
  FGroupBox[13] := GroupBoxSetupSetup;
  FGroupBox[14] := GroupBoxSetupHome;
  FGroupBox[15] := GroupBoxSetupPay;
  FGroupBox[16] := GroupBoxSetupExit;
  FGroupBox[17] := GroupBoxSetupMin;
  FGroupBox[18] := GroupBoxSetupClose;
  FormMain.OpenPictureDialog.Filter := 'Bitmaps (*.bmp)|*.bmp';
  FormMain.SaveDialog.Filter := '361M2登录器皮肤文件|*.361Skin';
  if not boFrist then begin
    imgBG.Left := 0;
    imgBG.Top := 0;
    ComboBoxDBList.ItemIndex := ComboBoxDBList.Items.Count - 1;
    ComboBoxDBList.Items.Delete(ComboBoxDBList.Items.Count - 1);

    InitSetup(@g_LoginSkinInfo, nil);
    boFrist := True;
  end;
//$636363
  //imgBG.Picture.LoadFromFile('D:\11.bmp');
end;

procedure TFrameMakeLogin.VarLeftChange(Sender: TObject);
begin
  if boFrist then begin
    LabelVar.Left := Trunc(VarLeft.Value);
    LabelVar.Top := Trunc(VarTop.Value);
  end;
end;

procedure TFrameMakeLogin.VarShowClick(Sender: TObject);
begin
  LabelVar.Visible := VarShow.Checked;
end;

end.
