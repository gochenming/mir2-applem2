unit Share;

interface

uses
  MSHTML, ActiveX, Variants, SysUtils, Graphics, Windows, ShlObj, ComObj, DateUtils;

const
  XML_MASTERNODE = 'XMLSetup';
  XML_SERVER_MASTERNODE = 'ServerList';
  XML_SERVER_GROUP = 'Group';
  XML_SERVER_SERVER = 'Server';
  XML_SERVER_NAME = 'Name';
  XML_SERVER_NODE_ADDRS = 'Addrs';
  XML_SERVER_NODE_PORT = 'Port';
  XML_SERVER_NODELIST = 'Child';
  XML_URL_MASTERNODE = 'Url';
  //XML_URL_HOME = 'Home';
  XML_URL_LFRAME = 'Loginframe';
  XML_URL_CONTACTGM = 'ContactGM';
  XML_URL_PAYMENT = 'Payment';
  XML_URL_REGISTER = 'Register';
  XML_URL_CHANGEPASS = 'ChangePass';
  XML_URL_LostPASS = 'LostPass';
  XML_UPDATE_MASTERNODE = 'UpDate';
  XML_CONFIG = 'Config';
  XML_UPDATE_SAVEDIR = 'SDir';
  XML_UPDATE_FILENAME = 'FName';
  XML_UPDATE_DOWNPATH = 'DUrl';
  XML_UPDATE_ZIP = 'ZIP';
  XML_UPDATE_CHECK = 'Check';
  XML_UPDATE_DOWNTYPE = 'DType';
  XML_UPDATE_DATE = 'Date';
  XML_UPDATE_VAR = 'VAR';
  XML_UPDATE_MD5 = 'MD5';
  XML_UPDATE_ID = 'ID';

  XML_ZIP_NO = '0';
  XML_ZIP_YES = '1';

  XML_CHECK_VAR = '0';
  XML_CHECK_EXISTS = '1';
  XML_CHECK_PACK = '2';
  XML_CHECK_MD5 = '3';

  XML_DOWNTYPE_DEF = '0';
  XML_DOWNTYPE_BAIDU = '1';

  BMP_PART_SIZE = $7CCF0;
  BMP_MAX_SIZE = $7CD2E;

type
  TBmpPartBuffer = array[0..BMP_PART_SIZE - 1] of Char;

  TBmpPartInfo = packed record
    BitmapFileHeader: TBitmapFileHeader;
    BitmapInfoHeader: TBitmapInfoHeader;
    nFileSize: Integer;
    nDataSize: Integer;
    //Data: TBmpPartBuffer;
  end;

function HtmlToText(HtmlText: WideString): WideString;
procedure CreateShortCut(FilePath: string; sName: string);

implementation

function HtmlToText(HtmlText: WideString): WideString;
var
  V: OleVariant;
  Document: IHTMLDocument2;
begin
  Result := HtmlText;
  if HtmlText = '' then
    Exit;
  CoInitialize(nil);
  Document := CoHTMLDocument.Create as IHtmlDocument2;
  try
    V := VarArrayCreate([0, 0], varVariant);
    V[0] := HtmlText;
    Document.Write(PSafeArray(TVarData(v).VArray));
    Document.Close;
    Result := Trim(Document.body.outerText);
  finally
    Document := nil;
    CoUninitialize;
  end;
end;

procedure CreateShortCut(FilePath: string; sName: string); //创建快捷方式
var
  tmpObject: IUnknown;
  tmpSLink: IShellLink;
  tmpPFile: IPersistFile;
  PIDL: PItemIDList;
  StartupDirectory: array[0..MAX_PATH] of Char;
  LinkFilename: WideString;
  Name: string;
begin
  try
    tmpObject := CreateComObject(CLSID_ShellLink); //创建建立快捷方式的外壳扩展
    tmpSLink := tmpObject as IShellLink; //取得接口
    tmpPFile := tmpObject as IPersistFile; //用来储存*.lnk文件的接口
    tmpSLink.SetPath(pChar(FilePath)); //设定notepad.exe所在路径
    tmpSLink.SetWorkingDirectory(pChar(ExtractFilePath(FilePath))); //设定工作目录
    SHGetSpecialFolderLocation(0, CSIDL_DESKTOPDIRECTORY, PIDL); //获得桌面的Itemidlist
    SHGetPathFromIDList(PIDL, StartupDirectory); //获得桌面路径
    Name := '\' + sName + '.lnk';
    LinkFilename := StartupDirectory + Name;
    tmpPFile.Save(pWChar(LinkFilename), FALSE); //保存*.lnk文件
  except
  end;
end;

//时间转换为GMT格式

function DateTimeToGMT(const DateTime: TDateTime): string;
begin
  Result := FormatDateTime('ddd, dd mmm yyyy hh:mm:ss', IncHour(DateTime, -8));
  Result := StringReplace(Result, '一月', 'Jan', [rfReplaceAll]);
  Result := StringReplace(Result, '二月', 'Feb', [rfReplaceAll]);
  Result := StringReplace(Result, '三月', 'Mar', [rfReplaceAll]);
  Result := StringReplace(Result, '四月', 'Apr', [rfReplaceAll]);
  Result := StringReplace(Result, '五月', 'May', [rfReplaceAll]);
  Result := StringReplace(Result, '六月', 'Jun', [rfReplaceAll]);
  Result := StringReplace(Result, '七月', 'Jul', [rfReplaceAll]);
  Result := StringReplace(Result, '八月', 'Aug', [rfReplaceAll]);
  Result := StringReplace(Result, '九月', 'Sep', [rfReplaceAll]);
  Result := StringReplace(Result, '十月', 'Oct', [rfReplaceAll]);
  Result := StringReplace(Result, '十一月', 'Nov', [rfReplaceAll]);
  Result := StringReplace(Result, '十二月', 'Dec', [rfReplaceAll]);
  Result := StringReplace(Result, '星期日', 'Sun', [rfReplaceAll]);
  Result := StringReplace(Result, '星期一', 'Mon', [rfReplaceAll]);
  Result := StringReplace(Result, '星期二', 'Tue', [rfReplaceAll]);
  Result := StringReplace(Result, '星期三', 'Wed', [rfReplaceAll]);
  Result := StringReplace(Result, '星期四', 'Thu', [rfReplaceAll]);
  Result := StringReplace(Result, '星期五', 'Fri', [rfReplaceAll]);
  Result := StringReplace(Result, '星期六', 'Sat', [rfReplaceAll]);
  Result := Result + ' GMT';
end;

initialization
  OleInitialize(nil);

finalization
  try
    OleUninitialize;
  except
  end;

end.

