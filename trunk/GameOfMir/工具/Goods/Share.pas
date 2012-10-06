unit Share;

interface
uses
ComCtrls, Classes, Grobal2;

type
  pTGoodsStditem = ^TGoodsStditem;
  TGoodsStditem = packed record
    sItemname: string[14];
    isshow: Boolean;
    Filtrate: TClientItemFiltrate;
    sDesc: string[255];
  end;

  pTGoodsMagic = ^TGoodsMagic;
  TGoodsMagic = packed record
    sMagID: Word;
    isshow: Boolean;
    sDesc: string[255];
  end;

  pTItemStditem = ^TItemStditem;
  TItemStditem = packed record
    Item: TListItem;
    StdItem: TStdItem;
    Bind: LongWord;
    //isshow: Boolean;
    //Filtrate: TClientItemFiltrate;
    sDesc: string[255];
    boChange: Boolean;
  end;


  pTItemMagic = ^TItemMagic;
  TItemMagic = packed record
    Item: TListItem;
    Magic: TMagic;
    isshow: Boolean;
    sDesc: string[255];
    boChange: Boolean;
  end;

var
  DBNAME  : String = '';
  DBList: TList;
  MagicList: TList;
  SaveList: TList;
  SaveMagicList: TList;
  boStdItemSelect: Boolean = False;
  boStdItemBack: Boolean = False;
  boChange: Boolean = False;
  boMagicBack: Boolean = False;
  boMagicSelect: Boolean = False;
  DescStr: string;

implementation

initialization
begin
  DBList := TList.Create;
  MagicList := TList.Create;
  SaveList := TList.Create;
  SaveMagicList := TList.Create;
end;

finalization
begin
  MagicList.Free;
  DBList.Free;
  SaveList.Free;
  SaveMagicList.Free;
end;



end.
