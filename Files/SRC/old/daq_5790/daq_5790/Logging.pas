unit Logging;

interface

Procedure WriteToFile(LogName, LogData: String);

var
  prefix: string = '';

implementation

uses classes, sysutils;

Procedure WriteToFile;
var
  ff: TFileStream;
begin

  try
    If FileExists(LogName) then
      ff := TFileStream.create(LogName, fmOpenWrite or fmShareDenyNone)
    else
      ff := TFileStream.create(LogName, fmCreate or fmShareDenyNone);
    ff.write(LogData[1], length(LogData));
    ff.free;
  except
  end;
end;

end.
