unit main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, gpib_user, Adgpib, ComCtrls, ExtCtrls, TeEngine, Series,
  TeeProcs, Chart, Spin, Buttons, mmsystem, strutils,
  HTTPSend, blcksock, winsock, Synautil, VclTee.TeeGDIPlus;

type
  TDAQThread = class(TThread)
    Procedure execute; override;
  end;

  TMainForm = class(TForm)
    Label1: TLabel;
    cmbGPIB: TComboBox;
    Label2: TLabel;
    cmbInst: TComboBox;
    Button1: TButton;
    Label3: TLabel;
    editWrite: TEdit;
    memoRead: TMemo;
    Panel1: TPanel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    Panel2: TPanel;
    Panel3: TPanel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    ComComboBox: TComboBox;
    Button2: TButton;
    Edit1: TEdit;
    Memo1: TMemo;
    Panel4: TPanel;
    Label11: TLabel;
    Label12: TLabel;
    Button3: TButton;
    Edit2: TEdit;
    Memo2: TMemo;
    Panel5: TPanel;
    Chart1: TChart;
    ch1VoltSeries: TLineSeries;
    address: TSpinEdit;
    StartCycle: TSpeedButton;
    CycBox: TCheckBox;
    Label9: TLabel;
    edCh: TSpinEdit;
    Splitter1: TSplitter;
    Chart2: TChart;
    CounterSeries: TLineSeries;
    meanVoltageSeries: TLineSeries;
    STDVoltageSeries: TLineSeries;
    ch1StdSeries: TLineSeries;
    ch1MeanSeries: TLineSeries;
    DAQlen: TSpinEdit;
    Topspn: TSpinEdit;
    Bottomspn: TSpinEdit;
    expspn: TSpinEdit;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    StaticText4: TStaticText;
    PageControl2: TPageControl;

    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    Chart3: TChart;
    CountPerVSeries: TPointSeries;
    StaticText5: TStaticText;
    deadspn: TSpinEdit;
    Series1: TPointSeries;
    StaticText6: TStaticText;
    stepspn: TSpinEdit;
    TabSheet6: TTabSheet;
    Panel6: TPanel;
    Panel7: TPanel;
    Chart4: TChart;
    DacSeries: TLineSeries;
    startDacbtn: TSpeedButton;
    Timer1: TTimer;
    StatusBar1: TStatusBar;
        procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure StartCycleClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Chart1DblClick(Sender: TObject);
    // procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Chart2DblClick(Sender: TObject);
    procedure startDacbtnClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);

  private
    { Private declarations }
  public

    Function delay(ms: integer): integer;
    Function InitCounterAndGPIB: integer;
    Procedure CreatedataFileName;
    Procedure INITGPIB_UpdateStartInterval;
    { Public declarations }
  end;

  Vrecord = record
    time: double;
    data: double;
    counter: int64;
  end;

  Varray = array of Vrecord;

var
    GPIBReady: Boolean;
  meanVoltage: double = 0;
  LastVoltage: array [0 .. 5] of double = (
    0,
    0,
    0,
    0,
    0,
    0
  );
  Stage: integer;
  counter_Ready : boolean = false;
  GPIB_ready: boolean = false;
  v_ref: double = 4.9742;
  PortNum: integer = 9090;
  HTTP: THTTPSend = nil;
  StepStartIndex: int64;
  Border_High, Border_low: dword;
  dstep: integer;
  DaqThread: TDAQThread;
  CurVoltage: double;
  CurControl: int64;
  oldControl: int64;

  MainForm: TMainForm;
  VoltageChangeTime: double;
  TimerID: dword;

  (* 488.2 GPIB global status variables. *)
  Vdata: array [0 .. 10000000] of Vrecord;
  PrevVindex, Vindex: integer;
  dacval: double;
  ltageChangeIndex: integer;
  (* 488.2 GPIB global status variables. *)
  ibsta: integer;
  iberr: integer;
  ibcnt: integer;
  ibcntl: integer;
  rs485: thandle = 0;
  iRet, iStatus: integer;
  iCount: integer;
  wRet: Word;
  bCfgChg, bComOpen: boolean;
  OpError: boolean;
  prevread: double;
  iConfirm: integer;
  LastCounterTime: double;
  std, mean: double;
  LastCounterValue: int64;
  cntVal: dword;
  DeltaCounterValue: int64;
  PrevVoltageChange: double;
  dev, resc: integer;
  Interval_low: double = 0.1000;
  interval_high: double = 0.1090;
  abs_step: double = 0.0001;
  cur_step: double;
  CollectData: boolean = false;
  step_len: double = 60;
  start_step: double = 0;
  prevVoltage: shortstring = '';

implementation

uses math, logging, SetMinMax, das_const, i7000, i7000u, dcon_pc;
{$R *.DFM}

function V_Convert(v_ref, v_cur: double): dword;
begin
  result := trunc(1048576.0 * (v_cur) / 5);
end;

function V_revert(v_ref: double; d_cur: dword): double;
begin
  result := 5.0 * d_cur / $FFFFF;
end;

fUNCTION setPotential(U: double): string;
var
  s1, url: string;
begin
  exit;
  if HTTP <> nil then
  begin
    HTTP.Free;
    HTTP := nil;
  end;
  HTTP := THTTPSend.Create;
  s1 := format('%.10f', [U]);
  s1 := ansiReplaceStr(s1, ',', '.');
  url := 'http://192.168.0.10:8282/set=' + s1;

  HTTP.HTTPMethod('GET', url);
  HTTP.Free;
  HTTP := nil;
end;

fUNCTION setdPotential(U: dword): string;
var
  s1, url: string;
begin
  if abs(oldControl - U) > (0.01 * $FFFFF / 5) then
    CurControl := oldControl + trunc((0.01 * $FFFFF / 5) * (oldControl - U) /
      abs(oldControl - U));
  CurControl := U;
  oldControl := CurControl;

  if HTTP <> nil then
  begin
    HTTP.Free;
    HTTP := nil;
  end;
  HTTP := THTTPSend.Create;
  s1 := format('%d', [CurControl]);
  s1 := ansiReplaceStr(s1, ',', '.');
  url := 'http://192.168.0.10:8282/setabs=' + s1;

  HTTP.HTTPMethod('GET', url);
  HTTP.Free;
  HTTP := nil;
end;

Procedure CalcStdAndMean(cur, len: integer);

var
  i: integer;
  ov, delta: double;

begin
  mean := 0;
  std := 0;
  if len = 0 then
    exit;
  if (cur - len + 1) < 0 then
    exit;
  for i := cur - (len - 1) to cur do
  begin
    mean := mean + Vdata[i].data;
  end;
  mean := mean / len;
  for i := cur - (len - 1) to cur do
  begin
    delta := abs(Vdata[i].data - mean);
    if delta > 0.0002 then
      Vdata[i].data := mean;
  end;
  mean := 0;
  std := 0;

  for i := cur - (len - 1) to cur do
  begin
    mean := mean + Vdata[i].data;
  end;
  mean := mean / len;

  for i := cur - (len - 1) to cur do
  begin
    std := std + (mean - Vdata[i].data) * (mean - Vdata[i].data);
  end;
  std := sqrt(std / (len));

end;

Function DaqGetdata: boolean;
var
  delta: real;
  wrtbuf, rdbuf: packed array [0 .. 299] of char;
  rdstr: string;

begin
  curmtime := timegettime();
  writeProtocol('1 #################### DAQ start ##################### ' +
    IntToStr(Vindex));
  try

    curtime := now();
    writeProtocol('2 dstimer callback=' + format('%15.13f',
      [(curtime - PrevTime) * 24 * 3600 * 1000]));
    curmtime := timegettime();
    writeProtocol('3 begin1 dttimer callback=');
    cntVal := 0;
    // mainform.Caption:=IntToStr(CurMtime-PrevMTime);
    writeProtocol('Read counter');
    wRet := DCON_Read_Counter(gcPort, StrToInt('$' + MainForm.address.Text), -1,
      StrToInt('$' + MainForm.edCh.Text), 0, 200, @cntVal);
    writeProtocol('check Read counter = ' + IntToStr(cntVal));
    If wRet <> 0 Then
    Begin
      writeProtocol('Err: Error reading counter.');
    end
    else
    begin
      if cntVal > $FFFF then
      begin
        cntVal := 131313;
        DCON_Clear_Counter(gcPort, StrToInt('$' + MainForm.address.Text), -1,
          StrToInt('$' + MainForm.edCh.Text), 0, 200);
        DeltaCounterValue := cntVal - LastCounterValue;
      end;
      LastCounterValue := cntVal;
      LastCounterTime := now();
    end;
    curmtime := timegettime();
    writeProtocol('counter ok = ' + IntToStr(cntVal));

    strcopy(wrtbuf, pchar('X?'));
    writeProtocol
      ('4 ibwrta Write a string command to a GPIB instrument asynchronously using the ibwrta() command');
    ibwrta(dev, @wrtbuf, strlen(wrtbuf));
    writeProtocol('5 get globals');

    gpib_get_globals(@ibsta, @iberr, @ibcnt, @ibcntl);
    if (ibsta AND ERR) <> 0 THEN
    begin
      writeProtocol
        ('6 Err: Error in writing the string command to the GPIB instrument.');
      OpError := true;
      exit;
    end;
    writeProtocol('7 Answer ok from the GPIB instrument ok. ibcnt = ' +
      IntToStr(ibcnt));
    writeProtocol
      ('8 ibWait for the completion of asynchronous write operation');
    ibwait(dev, CMPL);

    curmtime := timegettime();
    writeProtocol('9 wait ok = ' + IntToStr(curmtime - PrevMTime));
    writeProtocol('10 get globals');

    gpib_get_globals(@ibsta, @iberr, @ibcnt, @ibcntl);
    if (ibsta AND ERR) <> 0 THEN
    begin
      writeProtocol
        ('11 Err: Writing the string command to the GPIB instrument timeout.');
      OpError := true;
      exit;
    end;
    writeProtocol('12 Answer ok from the GPIB instrument ok. ibcnt = ' +
      IntToStr(ibcnt));

    writeProtocol
      ('13 //Read the response string from the GPIB instrument asynchronously using the ibrda() command');
    writeProtocol('14 ibrda');
    ibrda(dev, @rdbuf, 100);
    writeProtocol('15 get globals');
    gpib_get_globals(@ibsta, @iberr, @ibcnt, @ibcntl);
    if (ibsta AND ERR) <> 0 THEN
    begin
      writeProtocol
        ('16 Err: Error in reading the response string from the GPIB instrument.');
      OpError := true;
      exit;
    end;
    writeProtocol('17 Answer ok from the GPIB instrument ok. ibcnt = ' +
      IntToStr(ibcnt));

    writeProtocol('18 Wait for the completion of asynchronous read operation');
    ibwait(dev, CMPL);
    writeProtocol('19 get globals');
    // Получение напряжения
    gpib_get_globals(@ibsta, @iberr, @ibcnt, @ibcntl);
    if (ibsta AND ERR) <> 0 THEN
    begin
      MainForm.caption := FormatdateTime('DD/MM/YYYY HH:NN:SS', now) +
        'Err: Reading the string command to the GPIB instrument timeout.';
      writeProtocol
        ('20 Err: Reading the string command to the GPIB instrument timeout.');
      OpError := true;
      exit;
    end;
    writeProtocol('21 Answer ok from the GPIB instrument ok. ibcnt = ' +
      IntToStr(ibcnt));

    rdbuf[ibcnt - 1] := chr(0);
    rdstr := rdbuf;
    rdstr := rdstr + ' ';
    writeProtocol('22 Answer ok from the GPIB instrument ok. ibcnt = ' +
      IntToStr(ibcnt) + ' str=' + rdstr);

    // if PrevVoltage = rdstr then exit; //У АЦП нет новых данных
    prevVoltage := rdstr;
    rdstr := system.copy(rdstr, 1, pos(' ', rdstr) - 1);
    val(rdstr, dacval, resc);

    if (dacval < 0.00000000001) or (pos('.', rdstr) = 0) then
    begin
      PrevMTime := timegettime();
      PrevTime := now;
      writeProtocol('23 ####ZERO ' + rdstr + #10);
      exit;

    end;
    writeProtocol('24');
    rdstr := rdstr + ' ' + format(' %.4d %.6d %.1d %.8d %.8d %.3d',
      [cntVal, CurControl, dstep, Vindex + 1, StepStartIndex, DeltaCounterValue]
      ) + ' ' + IntToStr(trunc((timegettime - PrevMTime))) + ' ' +
      StringReplace(floattostr(now), ',', '.', [rfReplaceAll, rfIgnoreCase]);
    writeProtocol('14');
    prevread := now();
    writeProtocol('rdstr: ' + rdstr);
    CurVoltage := dacval;
    if CollectData then
    begin
      writetimelog(LogFilename, rdstr);
      writetimelog(DataDirName + IntToStr(Stage), rdstr);
      if resc = 0 then
        Vdata[Vindex + 1].data := dacval
      else
        Vdata[Vindex + 1].data := -1;;

      Vdata[Vindex + 1].counter := cntVal;
      Vdata[Vindex + 1].time := now();
      Vdata[Vindex + 1].data := dacval;
      inc(Vindex);
    end
    else
      wRet := DCON_Clear_Counter(gcPort, StrToInt('$' + MainForm.address.Text),
        -1, StrToInt('$' + MainForm.edCh.Text), 0, 200);

  except
    on E: Exception do
    begin
      writeProtocol('%%%%%%%%%%%%%%%%% Exceprton on read counter:' + E.Message);
      MainForm.caption := 'exception!!!!!!!!!!!!!!!!!!!';
    end;

  end;

  writeProtocol('26 #######D AQ end ' + IntToStr(Vindex));

  PrevMTime := timegettime();
  PrevTime := now;
end;

Procedure TDAQThread.execute;
var
  i: integer;
  Curtimel, PrevTimel: double;
  CurMtimel, PrevMTimel: dword;
begin
  timebeginperiod(10);
  while not terminated do
  begin

    DaqGetdata;
    LastVoltage[0] := LastVoltage[1];
    LastVoltage[1] := LastVoltage[2];
    LastVoltage[2] := LastVoltage[3];
    LastVoltage[3] := LastVoltage[4];
    LastVoltage[4] := LastVoltage[5];
    LastVoltage[5] := CurVoltage;
    meanVoltage := LastVoltage[0];
    for i := 1 to 5 do
      meanVoltage := meanVoltage + LastVoltage[i];
    meanVoltage := meanVoltage / 6.0;
    sleep(300)
  end;
  timeendperiod(10);
  MainForm.caption := 'terminated';
end;

procedure TMainForm.Button1Click(Sender: TObject);
var
  // Declare variables
  wrtbuf, rdbuf: packed array [0 .. 199] of char;
  dev: integer;
begin

  gszSend := StrAlloc(100);
  gszReceive := StrAlloc(100);


  // clear the specific GPIB instrument
  ibclr(dev);
  gpib_get_globals(@ibsta, @iberr, @ibcnt, @ibcntl);
  if (ibsta AND ERR) <> 0 THEN
  begin
    ShowMessage(DateToStr(now) + ' ' + TimeToStr(now) + '  ' +
      'Error in clearing the GPIB device.' + #10);
  end;

  strcopy(wrtbuf, pchar(#10 + editWrite.Text + #10));
  // Write a string command to a GPIB instrument asynchronously using the ibwrta() command
  ibwrta(dev, @wrtbuf, strlen(wrtbuf));
  gpib_get_globals(@ibsta, @iberr, @ibcnt, @ibcntl);
  if (ibsta AND ERR) <> 0 THEN
  begin
    ShowMessage(DateToStr(now) + ' ' + TimeToStr(now) + '  ' +
      'Error in writing the string command to the GPIB instrument.' + #10);
  end;

  // Wait for the completion of asynchronous write operation
  ibwait(dev, CMPL);
  gpib_get_globals(@ibsta, @iberr, @ibcnt, @ibcntl);
  if (ibsta AND ERR) <> 0 THEN
  begin
    ShowMessage
      ('Writing the string command to the GPIB instrument timeout.' + #10);
  end;

  // Read the response string from the GPIB instrument asynchronously using the ibrda() command
  ibrda(dev, @rdbuf, 100);
  gpib_get_globals(@ibsta, @iberr, @ibcnt, @ibcntl);
  if (ibsta AND ERR) <> 0 THEN
  begin
    ShowMessage(DateToStr(now) + ' ' + TimeToStr(now) + '  ' +
      'Error in reading the response string from the GPIB instrument.' + #10);
  end;

  // Wait for the completion of asynchronous read operation
  ibwait(dev, CMPL);
  gpib_get_globals(@ibsta, @iberr, @ibcnt, @ibcntl);
  if (ibsta AND ERR) <> 0 THEN
  begin
    ShowMessage
      ('Reading the string command to the GPIB instrument timeout.' + #10);
  end;
  rdbuf[ibcnt] := chr(0);

  memoRead.Text := rdbuf;

end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  i: int64;
begin
  cmbGPIB.ItemIndex := 0;
  cmbInst.ItemIndex := 15;
  memoRead.Text := '';
  gcDataBit := char(8); // 8 data bit
  gcParity := char(0); // Non Parity
  gcStopBit := char(0); // One Stop Bit
  bComOpen := false;
  bCfgChg := false;
  gszSend := StrAlloc(100);
  gszReceive := StrAlloc(100);
  // restorecomponents(self);
 INITGPIB_UpdateStartInterval;
end;

procedure TimerProc(uTimerID, uMessage: UINT; dwUser, dw1, dw2: dword)stdcall;
begin
  DaqGetdata;
end;

procedure TMainForm.StartCycleClick(Sender: TObject);
var
  // Declare variables
  wrtbuf, rdbuf: packed array [0 .. 399] of char;
  msg, errmess, rdstr: string;
  I1: integer;
  T1, T2: double;
var
  dt: double;
  prt: tthreadpriority;
  il1, il2, il3: integer;
  prevGrIndex: integer;
  CounterStep: integer;
  Stepstr: string;
  newTarget, curTarget: double;

begin
  Stage := 1;
  CreatedataFileName;
  PrevMTime := timegettime();
  timebeginperiod(1);
  memoRead.Lines.add('Time min period = ' + IntToStr(timeGetMinPeriod));
  memoRead.Lines.add('Time max period = ' + IntToStr(timeGetMAXPeriod));
  InitCounterAndGPIB();

  DaqThread := TDAQThread.Create(true);
  DaqThread.Priority := tphigher;
  prt := DaqThread.Priority;
  DaqThread.Priority := tphighest;
  prt := DaqThread.Priority;
  LastCounterTime := now;
  DaqThread.Priority := tpTimeCritical;
  prt := DaqThread.Priority;
  CollectData := false;

  // ######################################################################################
  // #########################################            #################################
  // ######################################### main cycle #################################
  // #########################################            #################################
  // ######################################################################################
  start_step := now;
  ch1StdSeries.clear;
  Series1.clear;
  ch1VoltSeries.clear;
  CountPerVSeries.clear;
  ch1VoltSeries.clear;
  ch1MeanSeries.clear;
  meanVoltageSeries.clear;
  STDVoltageSeries.clear;
  CounterSeries.clear;
  step_len := expspn.Value;
  curTarget := Bottomspn.Value;
  CurControl := V_Convert(v_ref, CurVoltage);

  Border_High := V_Convert(v_ref, Bottomspn.Value / 10000);
  Border_low := CurControl;
  if Border_High > Border_low then
    dstep := 1
  else
    dstep := -1;
  while (CurControl < $FFFFF) do
  begin
    if dstep < 0 then
      if CurControl < Border_High then
        break;
    if dstep > 0 then
      if CurControl > Border_High then
        break;
    setdPotential(CurControl);
    delay(1);
    DaqGetdata;
    CurControl := CurControl + dstep * trunc((100.0 * $FFFFF / 50000));
  end;
  delay(3);
  DaqGetdata;
  CurControl := CurControl + trunc((Bottomspn.Value * 1.0 - CurVoltage * 10000)
    / (50000 / $FFFFF));
  setdPotential(CurControl);
  delay(3);
  DaqGetdata;
  CurControl := CurControl + trunc((Bottomspn.Value * 1.0 - CurVoltage * 10000)
    / (50000 / $FFFFF));
  setdPotential(CurControl);
  delay(3);
  DaqGetdata;
  CurControl := CurControl + trunc((Bottomspn.Value * 1.0 - CurVoltage * 10000)
    / (50000 / $FFFFF));
  setdPotential(CurControl);
  delay(3);
  DaqGetdata;
  memoRead.Lines.add('Set ok. wait 4 sec');
  // while (now-start_Step)*24*3600<4 do application.processmessages;
  DaqThread.Resume;
  start_step := now;

  prevGrIndex := 2;
  LastCounterTime := now;
  LastCounterValue := 0;
  cntVal := 0;
  Vindex := 1;
  PrevVindex := 2;
  PrevVoltageChange := -1;
  StepStartIndex := 4;
  dstep := 1;
  CurControl := Border_low;
  CollectData := true;
  Border_High := Topspn.Value;
  Border_low := Bottomspn.Value;
  if Border_High > Border_low then
  begin
    dstep := 1
  end
  else
  begin
    Border_low := Topspn.Value;
    Border_High := Bottomspn.Value;
    dstep := -1;
  END;

  // ######################################################################################
  // #########################################            #################################
  // ######################################### main cycle #################################
  // #########################################            #################################
  // ######################################################################################

  while CycBox.Checked do
  begin
    MainForm.caption := IntToStr(cntVal);

    while ch1StdSeries.Count > 6230 do
      ch1StdSeries.Delete(0);
    while ch1VoltSeries.Count > 6230 do
      ch1VoltSeries.Delete(0);
    while ch1MeanSeries.Count > 6230 do
      ch1MeanSeries.Delete(0);
    while meanVoltageSeries.Count > 15300 do
      meanVoltageSeries.Delete(0);
    while STDVoltageSeries.Count > 15300 do
      STDVoltageSeries.Delete(0);
    while CounterSeries.Count > 5300 do
      CounterSeries.Delete(0);
    if prevGrIndex = Vindex + 1 then
      continue;
    for il1 := prevGrIndex to Vindex do
    begin
      ch1VoltSeries.AddXY(Vdata[il1].time, Vdata[il1].data);
    end;

    prevGrIndex := Vindex + 1;

    if (now - start_step) * 24 * 3600 > step_len then
    begin

      CollectData := false;
      // while (now-start_Step)*24*3600<0.4 do application.processmessages;

      CounterStep := Vdata[Vindex].counter;
      dt := (now() - LastCounterTime) * 24 * 3600;
      CalcStdAndMean(Vindex, Vindex - StepStartIndex); // vIndex-PrevVindex);
      ch1MeanSeries.AddXY(now, mean);
      ch1StdSeries.AddXY(now, std);
      meanVoltageSeries.AddXY(now(), mean);
      STDVoltageSeries.AddXY(now(), std);
      CountPerVSeries.AddXY(mean, CounterStep);
      Series1.AddXY(mean, 1 + random);
      Stepstr := format('%8.6f %8.6f ', [mean, std]);
      Stepstr := Stepstr + ' ' + format(' %.5d %.2d %.8d %.6d %.6d',
        [CounterStep, CurControl, dstep, Vindex + 1, StepStartIndex]) + ' ' +
        StringReplace(floattostr(now), ',', '.', [rfReplaceAll, rfIgnoreCase]);
      Stepstr := StringReplace(Stepstr, ',', '.', [rfReplaceAll, rfIgnoreCase]);
      writetimelog(DataFileName, Stepstr);
      memoRead.Lines[0] := (DateToStr(now) + ' ' + TimeToStr(now) + '  ' +
        'Read ok = ' + rdstr);
      // writetimelog(rdstr+#10);
      LastCounterTime := now;

      StepStartIndex := Vindex + 1;

      newTarget := curTarget + dstep * stepspn.Value;
      if newTarget > Border_High then
      begin
        dstep := -1;
        Stage := Stage + 1;
      end
      else
      begin
        if newTarget < Border_low then
        begin
          Stage := Stage + 1;
          dstep := 1;
        end
        else
          curTarget := newTarget;
      end;
      while abs(curTarget * 1.0 - meanVoltage * 10000) > 0.03 do
      begin
        CurControl := CurControl + trunc((curTarget * 1.0 - CurVoltage * 10000)
          / (50000 / $FFFFF));
        setdPotential(CurControl);

        delay(2);
      end;
      while (now - start_step) * 24 * 3600 < deadspn.Value - 2 do
        application.processmessages;

      CollectData := true;
      start_step := now;
    end;
    T1 := now;
    while (now - T1) * 24 * 3600 < 1 DO
    BEGIN
      application.processmessages;
      sleep(100);
    END;

  end;
  // timeKillEvent(TimerID);
  DaqThread.Terminate;
  PrevMTime := timegettime;
  while (timegettime() - PrevMTime) < 1000 do
    application.processmessages;
  // Offline the GPIB interface card
  ibonl(dev, 0);
  gpib_get_globals(@ibsta, @iberr, @ibcnt, @ibcntl);
  if (ibsta AND ERR) <> 0 THEN
  begin
    memoRead.Lines[0] := (DateToStr(now) + ' ' + TimeToStr(now) + '  ' +
      'Err: Error in offline the GPIB interface card.' + #10);
    writetimelog(DateToStr(now) + ' ' + TimeToStr(now) + '  ' +
      'Err: Error in offline the GPIB interface card.' + #10);
  end;
  StartCycle.Enabled := true;
  iRet := close_Com(gcPort);
  If iRet > 0 Then
  Begin
    Beep;
    iConfirm := MessageDlg('close_COM Error Code:' + IntToStr(iRet) + #13 +
      IGetErrorString(iRet) + #13 + 'Quit this demo?', mtConfirmation,
      [mbYes, mbNo], 0);

  End;

  bComOpen := false;
  bCfgChg := false;

end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  if (not GPIBReady) then begin
    showmessage('Невозможно инициализировать цифровой вольметр');
    close;
 end;

  if paramcount > 0 then
  begin
    if paramstr(1) = 'continue' then
    begin
      caption := 'Continue';
      CycBox.Checked := true;
      StartCycle.Click;

    end;
  end;

end;

procedure TMainForm.Chart1DblClick(Sender: TObject);
begin
  // SetMinMaxForm.SetLimits(TChart(sende
  while (timegettime() - PrevMTime) < 500 do
    application.processmessages;
end;

procedure TMainForm.Chart2DblClick(Sender: TObject);
begin
  SetMinMaxForm.SetLimits(TChart(Sender));
end;

procedure TMainForm.startDacbtnClick(Sender: TObject);
var
  dstep: integer;
begin
  if ansilowercase(startDacbtn.caption) = 'stop' then
  begin
    startDacbtn.caption := 'Start';
    exit;
  end;
  startDacbtn.caption := 'Stop';
  InitCounterAndGPIB();
  CollectData := false;
  Border_High := V_Convert(v_ref, Topspn.Value / 10000);
  Border_low := V_Convert(v_ref, Bottomspn.Value / 10000);

  CurControl := Border_low;
  if Border_High > Border_low then
    dstep := 1
  else
    dstep := -1;
  DacSeries.clear;
  while (CurControl < $FFFFF) and (startDacbtn.caption = 'Stop') do
  begin
    if dstep < 0 then
      if CurControl < Border_High then
        break;
    if dstep > 0 then
      if CurControl > Border_High then
        break;
    setdPotential(CurControl);
    delay(1);
    DaqGetdata;
    // dacseries.AddXY(curControl,curVoltage);
    writetimelog(DataFileName, format('%.5d %9.7f', [CurControl, CurVoltage]));
    CurControl := CurControl + dstep * trunc((100.0 * $FFFFF / 50000));
  end;
  delay(1);
  DaqGetdata;
  if startDacbtn.caption <> 'Stop' then
  begin
  end;
  startDacbtn.caption := 'Start';

  ibonl(dev, 0);
  gpib_get_globals(@ibsta, @iberr, @ibcnt, @ibcntl);
  if (ibsta AND ERR) <> 0 THEN
  begin
    memoRead.Lines[0] := (DateToStr(now) + ' ' + TimeToStr(now) + '  ' +
      'Err: Error in offline the GPIB interface card.' + #10);
    writetimelog(DateToStr(now) + ' ' + TimeToStr(now) + '  ' +
      'Err: Error in offline the GPIB interface card.' + #10);
  end;
  StartCycle.Enabled := true;
  iRet := close_Com(gcPort);
  If iRet > 0 Then
  Begin
    Beep;
    iConfirm := MessageDlg('close_COM Error Code:' + IntToStr(iRet) + #13 +
      IGetErrorString(iRet) + #13 + 'Quit this demo?', mtConfirmation,
      [mbYes, mbNo], 0);

  End;

  bComOpen := false;
  bCfgChg := false;

end;

function TMainForm.delay(ms: integer): integer;
var
  st: double;
begin
  st := now;
  while (now - st) * 24 * 3600 < ms do
    application.processmessages;
end;

function TMainForm.InitCounterAndGPIB: integer;
var

  errmess: string;
  T1: double;
  wrtbuf: array [0 .. 2000] of char;
begin

  if GPIB_ready then
    exit;
  gcPort := char(ComComboBox.ItemIndex + 1); // Setting Com Port
  gdwBaudRate := 9600;

  iRet := Open_Com(gcPort, gdwBaudRate, gcDataBit, gcParity, gcStopBit);
  If iRet > 0 Then
  Begin
    Beep;
    iConfirm := MessageDlg('OPEN_COM Error Code:' + IntToStr(iRet) + #13 +
      IGetErrorString(iRet) + #13 + 'Quit this demo?', mtConfirmation,
      [mbYes, mbNo], 0);
      counter_ready := false;

  End else begin
    counter_ready := true;
    bComOpen := true;
    bCfgChg := false;
  end;


  dev := ibdev(cmbGPIB.ItemIndex, cmbInst.ItemIndex + 1, 0, T1s, 1, 0);
  StartCycle.Enabled := false;
  gpib_get_globals(@ibsta, @iberr, @ibcnt, @ibcntl);
  prevread := now();
  if (ibsta AND ERR) <> 0 THEN
  begin
    errmess := GpibError(iberr);
    memoRead.Lines[0] := (DateToStr(now) + ' ' + TimeToStr(now) + '  ' +
      'Err: Error in init the GPIB device.' + errmess + #10);
    writetimelog(DateToStr(now) + ' ' + TimeToStr(now) + '  ' +
      'Err: Error in init the GPIB device.' + errmess + #10);
    OpError := true;

  end;

  // Open and intialize an GPIB instrument
  OpError := false;
  (*
    while CycBox.Checked do begin

    T1 := NOW;
    while (now-t1)*24*3600<0.1 DO BEGIN
    application.ProcessMessages;
    END;
  *)
  // process error  in prev operation
  If OpError then
  begin
    T1 := now;
    while (now - T1) * 24 * 3600 < 8 DO
    BEGIN
      application.processmessages;
    END;
    (*
      winexec(pansichar(paramstr(0)+' continue'), sw_show);
      CycBox.Checked := false;
      application.terminate;
      break;
    *)
  end;

  OpError := false;
  (*
    ibonl(dev, 1);
    gpib_get_globals(@ibsta, @iberr, @ibcnt, @ibcntl);
    if (ibsta AND ERR) <> 0 THEN
    begin
    memoread.lines[0]:=(DateToStr(now)+' '+TimeToStr(now)+'  '+'Err: Error in online the GPIB interface card.'+#10);
    writetimelog(DateToStr(now)+' '+TimeToStr(now)+'  '+'Err: Error in online the GPIB interface card.'+#10);
    end;
  *)

  // clear the specific GPIB instrument
  ibclr(dev);
  gpib_get_globals(@ibsta, @iberr, @ibcnt, @ibcntl);
  if (ibsta AND ERR) <> 0 THEN
  begin
    errmess := GpibError(iberr);
    memoRead.Lines[0] := (DateToStr(now) + ' ' + TimeToStr(now) + '  ' +
      'Err: Error in clearing the GPIB device.' + errmess + #10);
    writetimelog(DateToStr(now) + ' ' + TimeToStr(now) + '  ' +
      'Err: Error in clearing the GPIB device.' + errmess + #10);
    OpError := true;
    (* continue; *)
    StartCycle.Enabled := true;
    GPIB_ready := true;
  end;

  // **************** clear queue and events*****************
  strcopy(wrtbuf, pchar(#10 + '*cls' + #10));
  // Write a string command to a GPIB instrument asynchronously using the ibwrta() command
  ibwrta(dev, @wrtbuf, strlen(wrtbuf));
  gpib_get_globals(@ibsta, @iberr, @ibcnt, @ibcntl);
  if (ibsta AND ERR) <> 0 THEN
  begin
    memoRead.Lines[0] := (DateToStr(now) + ' ' + TimeToStr(now) + '  ' +
      'Err: Error in writing *cls command to the GPIB instrument.' + #10);
    writetimelog(DateToStr(now) + ' ' + TimeToStr(now) + '  ' +
      'Err: Error in writing *cls command to the GPIB instrument.' + #10);
  end;

  // Wait for the completion of asynchronous write operation
  ibwait(dev, CMPL);
  gpib_get_globals(@ibsta, @iberr, @ibcnt, @ibcntl);
  if (ibsta AND ERR) <> 0 THEN
  begin
    memoRead.Lines[0] := (DateToStr(now) + ' ' + TimeToStr(now) + '  ' +
      'Err: Wait for the completion of asynchronous write operation. *cls ' +
      #10);
    writetimelog(DateToStr(now) + ' ' + TimeToStr(now) + '  ' +
      'Err:  Wait for the completion of asynchronous write operation. *cls ' +
      #10);
    OpError := true;
    (* continue; *)
    StartCycle.Enabled := true;
    exit;
  end;


  // ***********finish configure ******************

  // **************** Configure  device 10V resolution 6*****************
  // strcopy(wrtbuf, pchar('dcv 10,resl6'));
  // **************** Configure  deice 10V resolution 7*****************
  strcopy(wrtbuf, pchar('dcv 10,resl6'));
  // Write a string command to a GPIB instrument asynchronously using the ibwrta() command
  ibwrta(dev, @wrtbuf, strlen(wrtbuf));
  gpib_get_globals(@ibsta, @iberr, @ibcnt, @ibcntl);
  if (ibsta AND ERR) <> 0 THEN
  begin
    memoRead.Lines[0] := (DateToStr(now) + ' ' + TimeToStr(now) + '  ' +
      'Err: Error in writing the string command to the GPIB instrument.' + #10);
    writetimelog(DateToStr(now) + ' ' + TimeToStr(now) + '  ' +
      'Err: Error in writing the string command to the GPIB instrument.' + #10);
  end;

  // Wait for the completion of asynchronous write operation
  ibwait(dev, CMPL);
  gpib_get_globals(@ibsta, @iberr, @ibcnt, @ibcntl);
  if (ibsta AND ERR) <> 0 THEN
  begin
    memoRead.Lines[0] := (DateToStr(now) + ' ' + TimeToStr(now) + '  ' +
      'Err: Writing the string command to the GPIB instrument timeout.' + #10);
    writetimelog(DateToStr(now) + ' ' + TimeToStr(now) + '  ' +
      'Err: Writing the string command to the GPIB instrument timeout.' + #10);
    OpError := true;
    (* continue; *)
    StartCycle.Enabled := true;
    exit;
  end;

  // ***********finished configure ******************
  wRet := DCON_Clear_Counter(gcPort, StrToInt('$' + address.Text), -1,
    StrToInt('$' + edCh.Text), 0, 200);

end;

procedure TMainForm.Timer1Timer(Sender: TObject);
begin
  StatusBar1.Panels[0].Text := format('Ctrl=%.5d U=%8.6f',
    [CurControl, CurVoltage]);
end;

procedure TMainForm.CreatedataFileName;
var
  s1, s2: string;
  r1: dword;
  Info: string;
begin
  r1 := 80;
  getcomputername(@charbuf, r1);
  compname := charbuf;
  s1 := extractfilepath(application.exename);
  Info := FormatdateTime('DD_MMMM_YY HH_NN_SS ', now) + Bottomspn.Text + '-' +
    Topspn.Text + ' exp-' + expspn.Text + ' dead-' + deadspn.Text;
  s2 := s1 + '\data\';
  DataDirName := s2;
  CreateDirectory(pchar(s2), nil);

  s2 := s2 + Info;
  DataFileName := s2 + '.txt';
  LogFilename := s2 + ' full.txt';
end;

procedure TMainForm.INITGPIB_UpdateStartInterval;
var
  dstep: integer;
begin
  CollectData := false;
  InitCounterAndGPIB();
  if (not GPIBReady) then exit;

  delay(deadspn.Value);
  if abs(CurVoltage) > 1000 then
  begin;
  end
  else
  begin;
    Bottomspn.Value := trunc(CurVoltage * 10000);
    Topspn.Value := trunc(CurVoltage * 10000);
  end;
  ibonl(dev, 0);
  gpib_get_globals(@ibsta, @iberr, @ibcnt, @ibcntl);
  if (ibsta AND ERR) <> 0 THEN
  begin
    memoRead.Lines[0] := (DateToStr(now) + ' ' + TimeToStr(now) + '  ' +
      'Err: Error in offline the GPIB interface card.' + #10);
    writetimelog(DateToStr(now) + ' ' + TimeToStr(now) + '  ' +
      'Err: Error in offline the GPIB interface card.' + #10);
  end;
  StartCycle.Enabled := true;
  iRet := close_Com(gcPort);
  If iRet > 0 Then
  Begin
    Beep;
    iConfirm := MessageDlg('close_COM Error Code:' + IntToStr(iRet) + #13 +
      IGetErrorString(iRet) + #13 + 'Quit this demo?', mtConfirmation,
      [mbYes, mbNo], 0);

  End;
  DaqGetdata;
  bComOpen := false;
  bCfgChg := false;

end;

end.
