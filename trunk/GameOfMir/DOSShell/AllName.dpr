program AllName;

{$APPTYPE CONSOLE}

uses
  //Forms,
  //Windows,
  SysUtils;

{$R *.RES}
var
  sInput: string;
  nInteger: Integer;
  nInput: Integer;
Label
  Error1;
Label
  Error2;
Label
  Error3;
begin
  //Application.Initialize;

  try
    Randomize;
    Writeln('程序无法运行，请先选择回答下列问题！');
    Error1:
    Writeln('1、判断数值大小');
    Writeln('2、脑筋急转弯');
    Writeln('3、退出程序');
    Readln(sInput);
    if sInput = '1' then begin
      nInteger := Random(100);
      Writeln('你选择了判断数值大小，请输入一个0~100之间的整数！');
      Error2:
      Readln(sInput);
      nInput := StrToIntDef(sInput, -1);
      if nInput = nInteger then begin
        Writeln('恭喜你回答正确，但程序还是无法运行，请继续答题！');
        Goto Error1;
      end else
      if nInput > nInteger then begin
        Writeln('你输入的数值比正确答案要大，请继续输入！');
        Goto Error2;
      end else
      if nInput < nInteger then begin
        Writeln('你输入的数值比正确答案要小，请继续输入！');
        Goto Error2;
      end;
    end else
    if sInput = '2' then begin
      Error3:
      Writeln('冬瓜、黄瓜、西瓜、南瓜都能吃，什么瓜不能吃？');
      Readln(sInput);
      if sInput = '傻瓜' then begin
        Writeln('恭喜你回答正确，但程序还是无法运行，请继续答题！');
        Goto Error1;
      end else begin
        Writeln('回答错误，请继续答题！');
        Goto Error3;
      end;

    end else
    if sInput = '3' then begin
      Exit;
    end else begin
      Writeln('输入错误，请重新输入选择！');
      Goto Error1;
    end;
    { TODO -oUser -cConsole Main : Insert code here }
  except
    on E:Exception do
      Writeln(E.Classname, ': ', E.Message);
  end;
end.
