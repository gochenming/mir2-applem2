unit LAShare;

interface

uses
  Messages, Classes;

const

  MAPNAME = 'jbjb'; //给客户时要修改                   // http://hi.baidu.com/mir2k_updata/rss
  //LISTURL1 = 'AdrSuefH34P0BM7U5EQ0kzJa9pVneVNCziBoQkgczkIz3izPRd8'; //http://hi.baidu.com/update_list
  LISTURL1 = 'aOlZZB7mSDsgE6CMUjjfCT477P51bdbhExDzIjUr4gvS=GH2x6c';
  LISTURL2 = 'AWXS+C+atOJcaeDx8IGkykSywxQHY=zmShSfXxLfIXeq3xQj5Bg'; //http://list.mir2k.com/ServerList.txt
  SAVEFILENAME = '.\Resource\' + MAPNAME + 'List.xml';
  CLIENTNAME = '.\2KClient.dat';
  //CLIENTNAME = '.\mir2.exe';
  UPDATADIR = '.\' + MAPNAME + 'UpData\';
  DOWNFILEEXT = '.down';
  TITLENAME = 'jbjb';

type
  TDownCheckType = (dct_var, dct_exists, dct_pack, dct_md5);
  TPPercent = 0..100;

  pTUpDataInfo = ^TUpDataInfo;
  TUpDataInfo = packed record
    sHint: string[60];
    sSaveDir: string[100];
    sFileName: string[40];
    sDownUrl: string[100];
    boZip: Boolean;
    boBaiduDown: Boolean;
    nDate: Integer;
    nVar: Integer;
    sMD5: string[32];
    sID: string[32];
    CheckType: TDownCheckType;
  end;

var
  g_DownList: TList;
  g_SelfName: string;
  g_SelfPath: string;
  g_boSQL: Boolean = False;
  g_LoginframeUrl: string = '';
  g_GMUrl: string = '';
  g_PayUrl: string = '';
  g_RegUrl: string = '';
  g_ChangePassUrl: string = '';
  g_LostPassUrl: string = '';

implementation



end.

