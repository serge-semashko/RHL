unit DAS_Const;

interface

uses controls, classes, windows, inifiles, stdctrls, comctrls, extctrls,
  sysutils,
  forms, grids, spin, TeEngine, Series, TeeProcs, Graphics, jpeg, adodb,
  mmsystem;

Const
  MaxPointsInChart = 400;
  ChColors: array [0 .. 8] of tcolor = (clFuchsia, clGreen, clBlack, clOlive,
    clRed, clBlue, clPurple, clMaroon, clNavy);
function decodepassword(psw: string): string;
function encodepassword(psw: string): string;
procedure WriteprofileToDB(dbname: string; q1: tadoquery; msTime: int64;
  ChamberSumm, Summx, SummY, SummC, CurBuncher, napBuncher: double;
  channels: array of double; startXScan, CountXScan, StartyScan,
  CountYScan: integer; ara1, ara2: double);
procedure WriteOLDAMPToDB(dbname: string; q1: tadoquery; fk12: double;
  channels: array of double; chCount, lamelStart, LamelCount: integer);
Function GPIBError(iberr: integer): string;
Function OpenPort(comport: string): thandle; overload;
Function OpenPort(comport, baud: string): thandle; overload;
procedure SetAxisMax(Axis: tchartAxis; ser: tchartseries);
Procedure SaveComponents(Component: TComponent);
Procedure RestoreComponents(Component: TComponent);

Function SpinByName(Component: TComponent; name: string): TSpinEdit;
Procedure WriteLog(LogName, LogData: String); overload;
Procedure WriteLog(LogData: String); overload;
Procedure WriteTimeLog(LogName, LogData: String); overload;
Procedure WriteTimeLog(LogData: String); overload;
Procedure WriteProtocol(LogData: String);
Function ChangeChar(const str: string; SrcChar, DstChar: Char): String;
Function ConvertFloat(str: string; var Newval: double): boolean;
Function ElapshedTime: double;
Function ExecCommand485(rs: thandle; CMD: string): string;
Procedure SaveToJPG(bitmap: tbitmap; afile: string);
Procedure WriteToFile(LogName, LogData: String);
Function HexToInt(str: string; var Val: int64): boolean;
pROCEDURE MySleep(dl: integer);
function timeGetMinPeriod(): DWORD;
function timeGetMaxPeriod(): Cardinal;
// Procedure  FillVacuumGrid(vg:qcomctrls.Tlistview);overload;

// Function   Parce(n:integer;str:string;def array])
var
  vacname: string = 'Vacuum.dat';
  lnrname: string = 'LNRdata.dat';
  charbuf: array [0 .. 100] of Char;
  compname: string;
  Titls: array [0 .. 35] of string;
  DasProcess: boolean = false;
  VacuumAlarmSound: boolean = false;
  DasTime: integer = -1;
  CONNSTRing: STRING = '';
  Boosts: array [0 .. 17] of byte;
  CF: TIniFile;
  ConfigFilename: string;
  DataFileName: string = '';
  LNRDataFileName: string = '';
  AmpDataFileName: string = '';
  BoostDataFileName: string = '';
  DataDirName: string;
  VacuumDataFileName: string;
  CyclotrolJournalFileName: string;
  FfDas: TFileStream;
  LogFileName: string;
  BeamLogFileName: string;
  ResetFilmCounter: boolean = false;
  GlobalLengthCounter: integer = 0;
  dcb: TDcB;
  Writen, nread: DWORD;
  stat: TComStat;
  commErrors: DWORD;
  CommErrorMessage: string;
  Comm485: thandle;
  Comm3_485: thandle;
  BPDV_485: thandle = 0;
  buf: array [0 .. 20000] of Char;
  PrevMTime: DWORD;
  CurMTime: DWORD;
  PrevTime: double;
  CurTime: double;

implementation

uses types;

var
  str1: tStringlist;
  StElapshedTime: double = -1;
  fs: TFormatSettings;

pROCEDURE MySleep(dl: integer);
var
  sttime: double;
begin
  sttime := now;
  while (now - sttime) * 24.0 * 3600.0 * 1000.0 < dl do
  begin
    sleep(1);
    application.ProcessMessages;
  end;
end;

Function HexToInt(str: string; var Val: int64): boolean;
var
  i: integer;
  char1: Char;
begin
  result := false;
  Val := 0;
  for i := 1 to length(str) do
  begin
    char1 := upcase(str[i]);
    case char1 of
      '0' .. '9':
        Val := Val * 16 + ord(char1) - 48;
      'A' .. 'F':
        Val := Val * 16 + ord(char1) - 55;
    else
      exit;
    end;
  end;
  result := true;
end;

procedure SetAxisMax;
var
  MaxVal: double;
  i1: integer;
begin
  MaxVal := 0;
  for i1 := 0 to ser.Count - 1 do
    if MaxVal <= ser.YValue[i1] then
      MaxVal := ser.YValue[i1];
  if Axis.Maximum < MaxVal * 1.5 then
    Axis.Maximum := MaxVal * 1.5;
end;

Procedure SaveToJPG(bitmap: tbitmap; afile: string);
var
  JpegIM: TJpegImage;
begin
  BitBlt(bitmap.Handle, 0, 0, bitmap.Width, bitmap.Height, GetDC(0), 0,
    0, SRCCOPY);
  JpegIM := TJpegImage.Create;
  JpegIM.Assign(bitmap);
  JpegIM.CompressionQuality := 20;
  JpegIM.Compress;
  JpegIM.SaveToFile(afile);
  JpegIM.Destroy;
end;

Function OpenPort(comport: string): thandle;
var
  InSTR: string;
  i1: integer;
begin

  if 0 = 0 then
  begin

    result := CreateFile(pchar('\\.\' + comport), GENERIC_READ or GENERIC_WRITE,
      { access attributes }
      0, { no sharing }
      nil, { no security }
      OPEN_EXISTING, { creation action }
      FILE_ATTRIBUTE_NORMAL, { attributes }
      0); { no template }
    if result = INVALID_HANDLE_VALUE then
      exit
    else
    begin
      if not SetupComm(result, 4000, 4000) then
        RaiseLastwin32error;
      // If not EscapeCommFunction(result,5) then RaiseLastwin32error;
      If not EscapeCommFunction(result, CLRRTS) then
        RaiseLastwin32error;
      fillchar(dcb, sizeof(dcb), 0);
      dcb.DCBlength := sizeof(dcb);
      if not BuildCommDCB('baud=9600 parity=N data=8 stop=1 dtr=on', dcb) then
        RaiseLastwin32error;
      // dcb.Flags := 17;
      if not SetCommState(result, dcb) then
        RaiseLastwin32error;
      if not PurgeComm(result, PURGE_TXCLEAR or PURGE_RXCLEAR) then
        RaiseLastwin32error;
    end;
  end;
end;

Function OpenPort(comport, baud: string): thandle;
var
  InSTR: string;
  i1: integer;
  dcbparm: ansistring;
begin

  if 0 = 0 then
  begin

    result := CreateFile(pchar('\\.\' + comport), GENERIC_READ or GENERIC_WRITE,
      { access attributes }
      0, { no sharing }
      nil, { no security }
      OPEN_EXISTING, { creation action }
      FILE_ATTRIBUTE_NORMAL, { attributes }
      0); { no template }
    if result = INVALID_HANDLE_VALUE then
      exit
    else
    begin
      if not SetupComm(result, 4000, 4000) then
        RaiseLastwin32error;
      // If not EscapeCommFunction(result,5) then RaiseLastwin32error;
      If not EscapeCommFunction(result, CLRRTS) then
        RaiseLastwin32error;
      fillchar(dcb, sizeof(dcb), 0);
      dcb.DCBlength := sizeof(dcb);
      dcbparm := 'baud=' + baud + ' parity=N data=8 stop=1 dtr=on';
      if not BuildCommDCB(pchar(dcbparm), dcb) then
        RaiseLastwin32error;
      // dcb.Flags := 17;
      if not SetCommState(result, dcb) then
        RaiseLastwin32error;
      if not PurgeComm(result, PURGE_TXCLEAR or PURGE_RXCLEAR) then
        RaiseLastwin32error;
    end;
  end;
end;

Function ExecCommand485(rs: thandle; CMD: string): string;
var
  InSTR: string;
  i1: integer;
  Writen, nread: DWORD;
  stat: TComStat;
  commErrors: DWORD;
  buf: array [0 .. 1000] of Char;
begin
  InSTR := CMD + #13;
  if not writefile(rs, InSTR[1], length(InSTR), Writen, nil) then
    RaiseLastwin32error;
  for i1 := 0 to 10 do
  begin
    sleep(10);
    application.ProcessMessages;
    if not ClearCommError(rs, commErrors, @stat) then
      RaiseLastwin32error;
    If stat.cbInQue >= 72 Then
      Break;
  end;
  if commErrors <> 0 then
  begin
    Case commErrors of
      CE_BREAK:
        CommErrorMessage := 'The hardware detected a break condition.';
      CE_DNS:
        CommErrorMessage :=
          'Windows 95 only: A parallel device is not selected.';
      CE_FRAME:
        CommErrorMessage := 'The hardware detected a framing error.';
      CE_IOE:
        CommErrorMessage :=
          'An I/O error occurred during communications with the device.';
      CE_MODE:
        CommErrorMessage :=
          'The requested mode is not supported, or the hFile parameter is invalid. If this value is specified, it is the only valid error.';
      CE_OOP:
        CommErrorMessage :=
          'Windows 95 only: A parallel device signaled that it is out of paper.';
      CE_OVERRUN:
        CommErrorMessage :=
          'A character-buffer overrun has occurred. The next character is lost.';
      CE_PTO:
        CommErrorMessage :=
          'Windows 95 only: A time-out occurred on a parallel device.';
      CE_RXOVER:
        CommErrorMessage :=
          'An input buffer overflow has occurred. There is either no room in the input buffer, or a character was received after the end-of-file (EOF) character.';
      CE_RXPARITY:
        CommErrorMessage := 'The hardware detected a parity error.';
      CE_TXFULL:
        CommErrorMessage :=
          'The application tried to transmit a character, but the output buffer was full.';
    end;
    WriteTimeLog(LogFileName + '.dbg', 'Error> 485 ' + CommErrorMessage + #13);
    PurgeComm(rs, PURGE_TXCLEAR or PURGE_RXCLEAR);
  end
  else if stat.cbInQue >= 1 then
  begin
    sleep(20);
    fillchar(buf, 200, 0);
    if stat.cbInQue > 200 then
      stat.cbInQue := 200;
    readfile(rs, buf, stat.cbInQue, nread, nil);
    result := buf;
    result := system.copy(result, 1, length(result) - 1);
  end
  else
    result := '';
end;

Function ElapshedTime: double;
begin
  If StElapshedTime < 0 Then
    StElapshedTime := now;
  result := (now - StElapshedTime) * 24 * 3600;
  StElapshedTime := now;
end;

Function ConvertFloat(str: string; var Newval: double): boolean;
var
  i1: integer;
  res: integer;
begin
  for i1 := 1 to length(str) do
    if str[i1] = ',' then
      str[i1] := '.';
  Val(str, Newval, res);
  result := res = 0;
end;

Procedure WriteLog(LogName, LogData: String);
var
  ff: TFileStream;
begin
  try
    If FileExists(LogName) then
      ff := TFileStream.Create(LogName, fmOpenWrite or fmShareDenyNone)
    else
      ff := TFileStream.Create(LogName, fmCreate or fmShareDenyNone);
    ff.seek(0, soFromEnd);
    ff.write(LogData[1], length(LogData));
    ff.free;
  except
  end;
end;

Procedure WriteToFile(LogName, LogData: String);
var
  ff: TFileStream;
begin

  try
    If FileExists(LogName) then
      ff := TFileStream.Create(LogName, fmOpenWrite or fmShareDenyNone)
    else
      ff := TFileStream.Create(LogName, fmCreate or fmShareDenyNone);
    ff.write(LogData[1], length(LogData));
    ff.free;
  except
  end;
end;

Procedure WriteLog(LogData: String);
var
  ff: TFileStream;
  log1: string;
  tname: string;
begin
  try
    tname := formatdatetime('yyyy-mm-dd', now) + '.dat';
    If FileExists(tname) then
      ff := TFileStream.Create(tname, fmOpenWrite or fmShareDenyNone)
    else
      ff := TFileStream.Create(tname, fmCreate or fmShareDenyNone);
    ff.seek(0, soFromEnd);
    log1 := LogData;
    ff.write(log1[1], length(log1));
    ff.free;
  except
  end;
end;

Procedure WriteProtocol(LogData: String);
var
  ff: TFileStream;
  log1: string;
  tname: string;
begin
  exit;
  try
    tname := 'Protocol ' + formatdatetime('yyyy-mm-dd', now) + '.dat';
    If FileExists(tname) then
      ff := TFileStream.Create(tname, fmOpenWrite or fmShareDenyNone)
    else
      ff := TFileStream.Create(tname, fmCreate or fmShareDenyNone);
    ff.seek(0, soFromEnd);
    log1 := formatdatetime('DD/MM/YYYY HH:NN:SS ', now) +
      format('%.8d ', [TimegetTime() - PrevMTime]) + LogData + #10;
    ff.write(log1[1], length(log1));
    ff.free;
  except
  end;
end;

Procedure WriteTimeLog(LogData: String);
begin
  WriteLog(formatdatetime('DD/MM/YYYY HH:NN:SS', now) + ' ' + LogData);
end;

Procedure WriteTimeLog(LogName, LogData: String);
begin
  WriteLog(LogName, formatdatetime(#10 + 'DD/MM/YYYY HH:NN:SS', now) + ' '
    + LogData);
end;

Function ChangeChar(const str: string; SrcChar, DstChar: Char): String;
var
  i1: integer;
begin
  result := str;
  for i1 := 1 to length(result) do
    if result[i1] = SrcChar then
      result[i1] := DstChar;
end;

Function SpinByName;
var
  i1, i2, i3: integer;
  SCon: TComponent;
begin
  result := nil;
  for i1 := 0 to Component.ComponentCount - 1 do
  begin
    SCon := TComponent(Component.Components[i1]);
    if SCon is TSpinEdit then
    begin
      if ansilowercase(TSpinEdit(SCon).name) <> ansilowercase(name) then
        continue;
      result := TSpinEdit(SCon);
      exit;
    end;
    if SCon is tpanel then
      SpinByName(SCon, name);
    if SCon is tPageControl then
      SpinByName(SCon, name);
    if SCon is tTabSheet then
      SpinByName(SCon, name);
  end;
end;

Procedure RestoreComponents;
var
  cl, i1, i2, i3: integer;
  SCon: TComponent;
  Clr: tcolor;
begin
  for i1 := 0 to Component.ComponentCount - 1 do
  begin
    SCon := TComponent(Component.Components[i1]);
    if SCon is tTrackBar then
      tTrackBar(SCon).Position := CF.ReadInteger('Components', SCon.name, 0);
    if SCon is tedit then
      tedit(SCon).text := CF.ReadString('Components', SCon.name, '');
    if SCon is TLabelededit then
      TLabelededit(SCon).text := CF.ReadString('Components', SCon.name, '');
    if SCon is TSpinEdit then
      TSpinEdit(SCon).value := CF.ReadInteger('Components', SCon.name, 0);
    if SCon is tCheckBox then
    begin
      tCheckBox(SCon).checked := CF.Readbool('Components', SCon.name, true);
      Clr := CF.ReadInteger('Components_color', SCon.name, clWhite);
      cl := CF.ReadInteger('Components_color', SCon.name, clWhite);
      tCheckBox(SCon).Font.Color := Clr;
    end;
    if SCon is tcombobox then
    begin
      tcombobox(SCon).itemindex := tcombobox(SCon)
        .items.IndexOf(CF.ReadString('Components', SCon.name, ''));
      if tcombobox(SCon).itemindex < 0 then
      begin
        tcombobox(SCon).text := '';
      end;
    end;
    if SCon is tpanel then
      RestoreComponents(SCon);
    if SCon is tPageControl then
      RestoreComponents(SCon);
    if SCon is tTabSheet then
      RestoreComponents(SCon);
    if SCon is tRadioGroup then
      tRadioGroup(SCon).itemindex := CF.ReadInteger('Components', SCon.name, 0);

  end;
end;

Procedure SaveComponents;
var
  i1, i2, i3: integer;
  SCon: TComponent;
begin
  for i1 := 0 to Component.ComponentCount - 1 do
  begin
    SCon := TComponent(Component.Components[i1]);
    if SCon.name = '' then
      continue;
    if SCon is tTrackBar then
      CF.WriteInteger('Components', SCon.name, tTrackBar(SCon).Position);
    if SCon is tedit then
      CF.WriteString('Components', SCon.name, tedit(SCon).text);
    if SCon is TLabelededit then
      CF.WriteString('Components', SCon.name, TLabelededit(SCon).text);
    if SCon is tcombobox then
      CF.WriteString('Components', SCon.name, tcombobox(SCon).text);
    if SCon is tedit then
      CF.WriteString('Components', SCon.name, tedit(SCon).text);
    if SCon is tCheckBox then
      CF.Writebool('Components', SCon.name, tCheckBox(SCon).checked);
    if SCon is TSpinEdit then
      CF.WriteInteger('Components', SCon.name, TSpinEdit(SCon).value);
    if SCon is tRadioGroup then
      CF.WriteInteger('Components', SCon.name, tRadioGroup(SCon).itemindex);
    if SCon is tpanel then
      SaveComponents(SCon);
    if SCon is tPageControl then
      SaveComponents(SCon);
    if SCon is tTabSheet then
      SaveComponents(SCon);
  end;
end;

Function GPIBError(iberr: integer): string;
begin
  case iberr of
    0:
      result := 'EDVR System error';
    1:
      result := 'ECIC Function requires GPIB board to be CIC';
    2:
      result := 'ENOL Write function detected no Listeners';
    3:
      result := 'EADR Interface board not addressed correctly';
    4:
      result := 'EARG Invalid argument to function call';
    5:
      result := 'ESAC Function requires GPIB board to be SAC';
    6:
      result := 'EABO I/O operation aborted';
    7:
      result := 'ENEB Non-existent interface board';
    10:
      result := 'EOIP I/O operation started before previous operation completed';
    11:
      result := 'ECAP No capability for intended operation';
    12:
      result := 'EFSO File system operation error';
    14:
      result := 'EBUS Command error during device call';
    15:
      result := 'ESTB Serial poll status byte lost';
    16:
      result := 'ESRQ SRQ remains asserted';
    20:
      result := 'ETAB The return buffer is full.';
    23:
      result := 'EHDL The input handle is invalid';
  end;
end;

function timeGetMinPeriod(): DWORD;
var
  time: TTimeCaps;
begin
  timeGetDevCaps(Addr(time), sizeof(time));
  timeGetMinPeriod := time.wPeriodMin;
end;

function timeGetMaxPeriod(): Cardinal;
var
  time: TTimeCaps;
begin
  timeGetDevCaps(Addr(time), sizeof(time));
  timeGetMaxPeriod := time.wPeriodMax;
end;

function decodepassword(psw: string): string;
var
  i, k: integer;
  s: string;
begin
  s := '';
  for i := 1 to length(psw) do
  begin
    if i > 21 then
      k := i mod 21
    else
      k := i;
    s := s + chr(ord(psw[i]) + k);
  end;
  result := s;
end;

function encodepassword(psw: string): string;
var
  i, k: integer;
  s: string;
begin
  s := '';
  for i := 1 to length(psw) do
  begin
    if i > 21 then
      k := i mod 21
    else
      k := i;
    s := s + chr(ord(psw[i]) - k);
  end;
  result := s;
end;

procedure WriteprofileToDB(dbname: string; q1: tadoquery; msTime: int64;
  ChamberSumm, Summx, SummY, SummC, CurBuncher, napBuncher: double;
  channels: array of double; startXScan, CountXScan, StartyScan,
  CountYScan: integer; ara1, ara2: double);
var
  sql: string;
  i1, i2: integer;
begin
  sql := 'insert ' + dbname +
    ' (msTime,ChamberSumm,summX,SummY,SummCTRL,ctrl,nap,ara1,ara2,';
  fs.decimalseparator := '.';
  for i1 := 1 to CountXScan do
    sql := sql + 'x' + IntToStr(i1) + ',';
  for i1 := 1 to CountYScan do
  begin
    sql := sql + 'y' + IntToStr(i1) + ','
  end;
  sql[length(sql)] := ')';

  sql := sql + ' values(';
  sql := sql + format('%d', [msTime]) + ', ';
  sql := sql + format('%.4f', [ChamberSumm]) + ', ';
  sql := sql + format('%.4f', [Summx]) + ', ';
  sql := sql + format('%.4f', [SummY]) + ', ';
  sql := sql + format('%.4f', [SummC]) + ', ';
  sql := sql + format('%.4f', [CurBuncher]) + ', ';
  sql := sql + format('%.4f', [napBuncher]) + ', ';
  sql := sql + format('%.4f', [ara1]) + ', ';
  sql := sql + format('%.4f', [ara2]) + ', ';
  fs.decimalseparator := '.';
  for i1 := 1 to CountXScan do
    sql := sql + format('%.4f', [channels[startXScan + i1]]) + ', ';
  for i1 := 1 to CountYScan do
    sql := sql + format('%.4f', [channels[StartyScan + i1]]) + ', ';
  sql[length(sql) - 1] := ')';

  if q1.active then
    q1.close;
  q1.sql.Clear;
  q1.sql.Add(sql);
  q1.ExecSQL;

end;

procedure WriteOLDAMPToDB;
var
  sql: string;
  i1, i2: integer;
begin
  sql := 'insert ' + dbname + ' (fk12,';
  fs.decimalseparator := '.';
  for i1 := 1 to chCount do
    sql := sql + 'CH' + IntToStr(i1) + ',';
  for i1 := 1 to LamelCount do
  begin
    sql := sql + 'L' + IntToStr(i1) + ','
  end;
  sql[length(sql)] := ')';

  sql := sql + ' values(';
  sql := sql + format('%.4f', [fk12]) + ', ';
  fs.decimalseparator := '.';
  for i1 := 0 to chCount - 1 do
    sql := sql + format('%e', [channels[i1]]) + ', ';
  for i1 := 0 to LamelCount - 1 do
    sql := sql + format('%e', [channels[lamelStart - 1 + i1]]) + ', ';
  sql[length(sql) - 1] := ')';

  if q1.active then
    q1.close;
  q1.sql.Clear;
  q1.sql.Add(sql);
  q1.ExecSQL;

end;

var
  s1, s2: string;
  r1: DWORD;

Initialization

r1 := 80;
getcomputername(@charbuf, r1);
compname := charbuf;
s1 := extractfilepath(application.exename);
s2 := s1 + '\data\';
CreateDirectory(pchar(s2), nil);
DataFileName := s1 + '\data\' + formatdatetime('DD_MMMM_YYYY HH_NN_SS', now);
ConfigFilename := s1 + 'es50.ini';
LogFileName := s1 + formatdatetime('DD_MMMM_YYYY HH_NN_SS', now);
CF := TIniFile.Create(ConfigFilename);
CF.WriteString('General', 'Start',
  formatdatetime('DD DDDD MMMM YYYY HH:NN:SS', now));
LNRDataFileName := CF.ReadString('general', 'LnrDataFileName',
  'm:\lnrdata.dat');
AmpDataFileName := CF.ReadString('general', 'AMPDataFileName',
  'm:\AMPDATA.dat');
str1 := tStringlist.Create;
WriteTimeLog('Начало работы программы' + #10);

finalization

WriteTimeLog('Завершение работы программы' + #10);

end.
