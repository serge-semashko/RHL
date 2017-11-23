unit main;

interface

uses
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    StdCtrls, gpib_user, Adgpib, ComCtrls, ExtCtrls, TeEngine, Series, TeeProcs,
    Chart, Spin, Buttons, mmsystem, strutils, HTTPSend, blcksock, winsock,
    Synautil, Grids, DB, ADODB, DBGrids, ZAbstractRODataset, ZAbstractDataset,
    ZDataset, ZAbstractConnection, ZConnection;

type
    TDAQThread = class(TThread)
        procedure execute; override;
    end;

    TMainForm = class(TForm)
        Panel1: TPanel;
        PageControl1: TPageControl;
        TabSheet1: TTabSheet;
        Panel5: TPanel;
        Chart1: TChart;
        ch1VoltSeries: TLineSeries;
        Splitter1: TSplitter;
        Chart2: TChart;
        CounterSeries: TLineSeries;
        meanVoltageSeries: TLineSeries;
        STDVoltageSeries: TLineSeries;
        ch1StdSeries: TLineSeries;
        ch1MeanSeries: TLineSeries;
        PageControl2: TPageControl;
        TabSheet4: TTabSheet;
        TabSheet5: TTabSheet;
        Chart3: TChart;
        CountPerVSeries: TPointSeries;
        Series1: TPointSeries;
        Timer1: TTimer;
        StatusBar1: TStatusBar;
        ts1: TTabSheet;
        pnl1: TPanel;
        pnl2: TPanel;
        pnl3: TPanel;
        addbtn: TSpeedButton;
        rembtn: TSpeedButton;
        con1: TADOConnection;
        con2: TZConnection;
        zqry1: TZQuery;
        zqry1num: TLargeintField;
        zqry1LowV: TLargeintField;
        zqry1HighV: TLargeintField;
        zqry1exposition: TLargeintField;
        zqry1Dead_time: TLargeintField;
        ds1: TDataSource;
        dbgrd1: TDBGrid;
        Bottomspn: TSpinEdit;
        Topspn: TSpinEdit;
        expspn: TSpinEdit;
        deadspn: TSpinEdit;
        stepspn: TSpinEdit;
        StaticText2: TStaticText;
        StaticText3: TStaticText;
        StaticText4: TStaticText;
        StaticText5: TStaticText;
        StaticText6: TStaticText;
        Panel3: TPanel;
        Label5: TLabel;
        Label6: TLabel;
        Label9: TLabel;
        ComComboBox: TComboBox;
        address: TSpinEdit;
        edCh: TSpinEdit;
        Panel2: TPanel;
        Label1: TLabel;
        Label2: TLabel;
        StartCycle: TSpeedButton;
        cmbGPIB: TComboBox;
        cmbInst: TComboBox;
        memoRead: TMemo;
        CycBox: TCheckBox;
        dbgrd2: TDBGrid;
        procedure FormCreate(Sender: TObject);
        procedure StartCycleClick(Sender: TObject);
        procedure FormShow(Sender: TObject);
        procedure Chart1DblClick(Sender: TObject);
//    procedure FormClose(Sender: TObject; var Action: TCloseAction);
        procedure Chart2DblClick(Sender: TObject);
        procedure Timer1Timer(Sender: TObject);
        procedure zqry1BeforePost(DataSet: TDataSet);
    private
    { Private declarations }
    public
        function SetVoltage(target: double): boolean;
        function delay(ms: integer): integer;
        function InitCounterAndGPIB: integer;
        procedure CreatedataFileName;
    { Public declarations }
    end;

    Vrecord = record
        time: double;
        data: double;
        counter: int64;
    end;

    Varray = array of vrecord;

var
    daq_mode : integer = 0;
    GPIB_Ready: Boolean = false;
    counter_ready: boolean = false;
    meanVoltage: double = 0;
    LastVoltage: array[0..10] of double = (-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1);
    Stage: integer;
    counter_and_GPIB_ready: boolean = false;
    v_ref: double = 4.9742;
    PortNum: integer = 9090;
    HTTP: THTTPSend = nil;
    StepStartIndex: int64;
    Border_High, Border_low: dword;
    dstep: integer;
    DaqThread: Tdaqthread;
    CurVoltage: double;
    CurControl: int64;
    oldControl: int64;
    MainForm: TMainForm;
    VoltageChangeTime: double;
    TimerID: dword;

  (*488.2 GPIB global status variables.*)
    Vdata: array[0..10000000] of vrecord;
    PrevVindex, Vindex: integer;
    dacval: double;
    ltageChangeIndex: INTEGER;
  (*488.2 GPIB global status variables.*)
    ibsta: Integer;
    iberr: Integer;
    ibcnt: Integer;
    ibcntl: Integer;
    rs485: thandle = 0;
    iRet, iStatus: Integer;
    iCount: Integer;
    wRet: Word;
    bCfgChg, bComOpen: Boolean;
    OpError: boolean;
    prevread: double;
    iConfirm: Integer;
    LastCounterTime: double;
    std, mean: double;
    LastCounterValue: Int64;
    cntVal: DWord;
    DeltaCounterValue: int64;
    PrevVoltageChange: double;
    dev, resc: integer;
    Interval_low: double = 0.1000;
    interval_high: double = 0.1090;
    abs_step: double = 0.0001;
    cur_step: double;
    GettingData: boolean = false;
    step_len: double = 60;
    start_step: double = 0;
    prevVoltage: shortstring = '';

implementation

uses
    math, logging, SetMinMax, das_const, i7000, i7000u, dcon_pc;
{$R *.DFM}
function delay(ms: integer): integer;
var
    st: double;
begin
    st := now;
    while (now - st) * 24 * 3600 < ms do
        application.ProcessMessages;
end;

function V_Convert(v_cur: double): dword;
begin
    result := trunc(1048576.0 * (v_cur) / 5);
end;

function V_revert(d_cur: dword): double;
begin
    result := 5.0 * d_cur / $FFFFF;
end;

function setPotential(U: double): string;
var
    s1, url: string;
begin
    exit;
    if http <> nil then begin
        http.Free;
        http := nil;
    end;
    HTTP := THTTPSend.Create;
    s1 := format('%.10f', [U]);
    s1 := ansiReplaceStr(s1, ',', '.');
    url := 'http://192.168.0.10:8282/set=' + s1;

    HTTP.HTTPMethod('GET', url);
    http.Free;
    http := nil;
end;

function setdPotential(U: dword): string;
var
    s1, url: string;
begin
    if abs(oldControl - U) > (0.01 * $FFFFF / 5) then
        curcontrol := oldcontrol + trunc((0.01 * $FFFFF / 5) * (oldControl - U) / abs(oldControl - U));
    curControl := U;
    oldControl := CurControl;

    if http <> nil then begin
        http.Free;
        http := nil;
    end;
    HTTP := THTTPSend.Create;
    s1 := format('%d', [curControl]);
    s1 := ansiReplaceStr(s1, ',', '.');
    url := 'http://192.168.0.10:8282/setabs=' + s1;

    HTTP.HTTPMethod('GET', url);
    http.Free;
    http := nil;
end;
function CorrectVoltage(target: double): boolean;
var
    tarcontrol: int64;
    startsetTime: double;
begin
    curControl := curControl + trunc((target * 1.0 - meanVoltage * 10000) / (50000 / $FFFFF));
    setDPotential(curControl);
end;
function SetVoltage(target: double): boolean;
var
    tarcontrol: int64;
    startsetTime: double;
begin
    startsetTime := now;
    while ((target * 1.0 - meanVoltage * 10000) > 0.2) and ((now - startsetTime) * 24 * 3600 < 5) do begin
        correctVoltage(target);
        delay(1);
    end;
    if (target * 1.0 - meanVoltage * 10000) > 0.2 then
        result := false
    else
        result := true;
end;
Function SetIntervalBorder(target:double):boolean;
  var
    tarcontrol: int64;
    startsetTime: double;
begin
    startsetTime := now;
    while ((target * 1.0 - meanVoltage * 10000) > 1) and ((now - startsetTime) * 24 * 3600 < 500) do begin
        correctVoltage(target);
        delay(1);
    end;
    if (target * 1.0 - meanVoltage * 10000) > 1 then begin
        result := false;
        exit;
    end;
    result := setVoltage(target);
end;

end;


procedure CalcStdAndMean(cur, len: integer);
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
    for i := cur - (len - 1) to cur do begin
        mean := mean + vdata[i].data;
    end;
    mean := mean / len;
    for i := cur - (len - 1) to cur do begin
        delta := abs(vdata[i].data - mean);
        if delta > 0.0002 then
            vdata[i].data := mean;
    end;
    mean := 0;
    std := 0;

    for i := cur - (len - 1) to cur do begin
        mean := mean + vdata[i].data;
    end;
    mean := mean / len;

    for i := cur - (len - 1) to cur do begin
        std := std + (mean - vdata[i].data) * (mean - vdata[i].data);
    end;
    std := sqrt(std / (len));

end;

function DaqGetdata: boolean;
var
    delta: real;
    wrtbuf, rdbuf: packed array[0..299] of char;
    rdstr: string;
begin
    curmtime := timegettime();
    writeProtocol('1 #################### DAQ start ##################### ' + IntToStr(vindex));
    try

        curtime := now();
        writeprotocol('2 dstimer callback=' + format('%15.13f', [(Curtime - PrevTime) * 24 * 3600 * 1000]));
        curmtime := timegettime();
        writeprotocol('3 begin1 dttimer callback=');
        cntval := 0;
//   mainform.Caption:=IntToStr(CurMtime-PrevMTime);
        if (counter_ready) then begin

            WriteProtocol('Read counter');
            wRet := DCON_Read_Counter(gcPort, StrToInt('$' + mainform.Address.Text), -1, StrToInt('$' + mainform.edCh.Text), 0, 200, @cntVal);
            WriteProtocol('check Read counter = ' + IntToStr(cntval));
            if wRet <> 0 then begin
                writeprotocol('Err: Error reading counter.');
                cntval := 131313;
            end
            else begin
                if cntval > $FFFF then begin
                    cntval := 131313;
                    DCON_Clear_Counter(gcPort, StrToInt('$' + mainform.Address.Text), -1, StrToInt('$' + mainform.edCh.Text), 0, 200);
                    deltaCounterValue := cntval - lastCounterValue;
                end;
                LastCounterValue := cntval;
                LastCounterTime := now();
            end;
        end;

        curmtime := timegettime();
        writeprotocol('counter ok = ' + IntToStr(cntval));

        strcopy(wrtbuf, pchar('X?'));
        WriteProtocol('4 ibwrta Write a string command to a GPIB instrument asynchronously using the ibwrta() command');
        ibwrta(dev, @wrtbuf, strlen(wrtbuf));
        WriteProtocol('5 get globals');

        gpib_get_globals(@ibsta, @iberr, @ibcnt, @ibcntl);
        if (ibsta and ERR) <> 0 then begin
            writeprotocol('6 Err: Error in writing the string command to the GPIB instrument.');
            opError := true;
            exit;
        end;
        writeprotocol('7 Answer ok from the GPIB instrument ok. ibcnt = ' + IntToStr(ibcnt));
        WriteProtocol('8 ibWait for the completion of asynchronous write operation');
        ibwait(dev, CMPL);

        curmtime := timegettime();
        writeprotocol('9 wait ok = ' + IntToStr(CurMtime - PrevMTime));
        WriteProtocol('10 get globals');

        gpib_get_globals(@ibsta, @iberr, @ibcnt, @ibcntl);
        if (ibsta and ERR) <> 0 then begin
            writeprotocol('11 Err: Writing the string command to the GPIB instrument timeout.');
            opError := true;
            exit;
        end;
        writeprotocol('12 Answer ok from the GPIB instrument ok. ibcnt = ' + IntToStr(ibcnt));

        WriteProtocol('13 //Read the response string from the GPIB instrument asynchronously using the ibrda() command');
        WriteProtocol('14 ibrda');
        ibrda(dev, @rdbuf, 100);
        WriteProtocol('15 get globals');
        gpib_get_globals(@ibsta, @iberr, @ibcnt, @ibcntl);
        if (ibsta and ERR) <> 0 then begin
            writeprotocol('16 Err: Error in reading the response string from the GPIB instrument.');
            opError := true;
            exit;
        end;
        writeprotocol('17 Answer ok from the GPIB instrument ok. ibcnt = ' + IntToStr(ibcnt));

        WriteProtocol('18 Wait for the completion of asynchronous read operation');
        ibwait(dev, CMPL);
        WriteProtocol('19 get globals');
    //Получение напряжения
        gpib_get_globals(@ibsta, @iberr, @ibcnt, @ibcntl);
        if (ibsta and ERR) <> 0 then begin
            mainform.caption := FormatdateTime('DD/MM/YYYY HH:NN:SS', now) + 'Err: Reading the string command to the GPIB instrument timeout.';
            writeprotocol('20 Err: Reading the string command to the GPIB instrument timeout.');
            opError := true;
            exit;
        end;
        writeprotocol('21 Answer ok from the GPIB instrument ok. ibcnt = ' + IntToStr(ibcnt));

        rdbuf[ibcnt - 1] := chr(0);
        rdstr := rdbuf;
        rdstr := rdstr + ' ';
        writeprotocol('22 Answer ok from the GPIB instrument ok. ibcnt = ' + IntToStr(ibcnt) + ' str=' + rdstr);

//        if PrevVoltage = rdstr then exit; //У АЦП нет новых данных
        PrevVoltage := rdstr;
        rdstr := system.copy(rdstr, 1, pos(' ', rdstr) - 1);
        val(rdstr, dacval, resc);

        if (dacval < 0.00000000001) or (pos('.', rdstr) = 0) then begin
            PrevMTime := TimeGetTime();
            PrevTime := now;
            writeProtocol('23 ####ZERO ' + rdstr + #10);
            exit;

        end;
        writeprotocol('24');
        rdstr := rdstr + ' ' + format(' %.4d %.6d %.1d %.8d %.8d %.3d', [cntval, curControl, dstep, vindex + 1, stepStartIndex, deltaCounterValue]) + ' ' + intToStr(trunc((timegettime - prevMtime))) + ' ' + StringReplace(floattostr(now), ',', '.', [rfReplaceAll, rfIgnoreCase]);
        writeprotocol('14');
        prevread := now();
        writeprotocol('rdstr: ' + rdstr);
        CurVoltage := dacval;
        if GettingData then begin
            writetimelog(DataDirName + IntToStr(stage), rdstr);
            if resc = 0 then
                vdata[vIndex + 1].data := dacval
            else
                vdata[vIndex + 1].data := -1;
            vdata[vindex + 1].counter := cntval;
            vdata[vindex + 1].time := now();
            vdata[vindex + 1].data := dacval;
            inc(vIndex);
        end
        else if counter_ready then
            wRet := DCON_Clear_Counter(gcPort, StrToInt('$' + mainform.Address.Text), -1, StrToInt('$' + mainform.edCh.Text), 0, 200);

    except
        on E: Exception do begin
            writeprotocol('%%%%%%%%%%%%%%%%% Exceprton on read counter:' + E.Message);
            mainform.Caption := 'exception!!!!!!!!!!!!!!!!!!!';
        end;

    end;

    writeProtocol('26 #######D AQ end ' + IntToStr(vindex));

    PrevMTime := TimeGetTime();
    PrevTime := now;
end;

procedure TDAQThread.execute;
var
    i: integer;
    Curtimel, PrevTimel: double;
    CurMtimel, PrevMTimel: dword;
begin
    while not terminated do begin
        if (gpib_ready) then begin

            DaqGetData;
            for i := 0 to 4 do
                if (LastVoltage[i] < 0) then
                    LastVoltage[i] := CurVoltage
                else
                    LastVoltage[i] := LastVoltage[i + 1];
            LastVoltage[5] := curVoltage;
            meanVoltage := LastVoltage[0];
            for i := 1 to 5 do
                meanVoltage := meanVoltage + LastVoltage[i];
            meanVoltage := meanVoltage / 6.0;
        end;
        sleep(300)
    end;
    mainform.Caption := 'terminated';
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
    i: int64;
begin
    cmbGPIB.ItemIndex := 0;
    cmbInst.ItemIndex := 15;
    memoRead.Text := '';
    gcDataBit := Char(8);      // 8 data bit
    gcParity := Char(0);      // Non Parity
    gcStopBit := Char(0);      // One Stop Bit
    bCOMOpen := False;
    bCfgChg := False;
    gszSend := StrAlloc(100);
    gszReceive := StrAlloc(100);
    InitCounterAndGPIB;
end;

procedure TimerProc(uTimerID, uMessage: UINT; dwUser, dw1, dw2: DWORD) stdcall;
begin
    Daqgetdata;
end;

procedure TMainForm.StartCycleClick(Sender: TObject);

    procedure ClearSeries;
    begin
        ch1StdSeries.clear;
        series1.Clear;
        ch1VoltSeries.clear;
        CountPerVSeries.Clear;
        ch1VoltSeries.clear;
        ch1MeanSeries.clear;
        MEANvOLTAGEseries.clear;
        STDvOLTAGEseries.clear;
        Counterseries.clear;

    end;

var
  //Declare variables
    wrtbuf, rdbuf: packed array[0..399] of char;
    msg, errmess, rdstr: string;
    I1: INTEGER;
    T1, T2: DOUBLE;
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
    CreateDataFileName;

    ClearSeries();
    step_len := expspn.Value;

    border_high := topspn.Value;
    border_low := Bottomspn.Value;
    zqry1.MoveBy(-zqry1.RecNo);
    topspn.Value := zqry1.FieldValues['HighV'];
    bottomspn.Value := zqry1.FieldValues['LowV'];
    expspn.Value := zqry1.FieldValues['exposition'];
    deadspn.Value := zqry1.FieldValues['dead_time'];
    border_high := topspn.Value;
    border_low := Bottomspn.Value;
    step_len := expspn.Value;
    if not SetVoltage(border_low) then begin
        showmessage('Не удается установить начальный уровень = ' + IntToStr(border_low));
        exit;
    end;
    memoread.Lines.Add('Set ok. wait 4 sec');
    start_step := now;

    prevGrIndex := 2;
    LastCounterTime := now;
    LastCounterValue := 0;
    cntval := 0;
    vIndex := 1;
    PrevVIndex := 2;
    PrevVoltageChange := -1;
    StepStartIndex := 4;
    Prevmtime := timegettime();
    start_step := now;
    dstep := 1;
    GettingData := true;

//######################################################################################
//#########################################            #################################
//######################################### main cycle #################################
//#########################################            #################################
//######################################################################################
    Startcycle.Caption := 'Stop measurement';
    while (Startcycle.Caption = 'Stop measurement') do begin
        mainform.Caption := IntToStr(cntval);

        while ch1StdSeries.Count > 6230 do
            ch1StdSeries.Delete(0);
        while ch1VoltSeries.Count > 6230 do
            ch1VoltSeries.Delete(0);
        while ch1MeanSeries.Count > 6230 do
            ch1MeanSeries.Delete(0);
        while MEANvOLTAGEseries.Count > 15300 do
            MEANvOLTAGEseries.Delete(0);
        while STDvOLTAGEseries.Count > 15300 do
            STDvOLTAGEseries.Delete(0);
        while Counterseries.Count > 5300 do
            Counterseries.Delete(0);
        if prevGrIndex = vindex + 1 then
            continue;
        for il1 := prevGrIndex to vindex do begin
            ch1VoltSeries.AddXY(vdata[il1].time, vdata[il1].data);
        end;

        prevGrIndex := vindex + 1;

        if (now - start_step) * 24 * 3600 > step_len then begin

            GettingData := false;
//       while (now-start_Step)*24*3600<0.4 do application.processmessages;

            CounterStep := vdata[vindex].counter;
            dt := (now() - lastCounterTime) * 24 * 3600;
            CalcStdAndMean(Vindex, vindex - StepStartIndex); // vIndex-PrevVindex);
            ch1MeanSeries.AddXY(now, mean);
            ch1stdSeries.AddXY(now, std);
            MeanVoltageSeries.AddXY(now(), mean);
            stdVoltageSeries.AddXY(now(), std);
            countPerVSeries.AddXy(mean, CounterStep);
            series1.AddXY(mean, 1 + random);
            Stepstr := format('%8.6f %8.6f ', [mean, std]);
            Stepstr := Stepstr + ' ' + format(' %.5d %.2d %.8d %.6d %.6d', [CounterStep, curControl, dstep, vindex + 1, stepStartIndex]) + ' ' + StringReplace(floattostr(now), ',', '.', [rfReplaceAll, rfIgnoreCase]);
            Stepstr := StringReplace(Stepstr, ',', '.', [rfReplaceAll, rfIgnoreCase]);
            writetimelog(DataFileName, Stepstr);
            memoread.lines[0] := (DateToStr(now) + ' ' + TimeToStr(now) + '  ' + 'Read ok = ' + rdstr);
    //   writetimelog(rdstr+#10);
            LastCounterTime := now;

            StepStartIndex := vindex + 1;

            newTarget := curTarget + dstep * stepspn.Value;
            curTarget := newTarget;
            if (dstep > 0) then begin
                if newTarget > border_high then begin
                    zqry1.MoveBy(1);
                    if zqry1.Eof then begin
                      if mode

                    end;
                    dstep := -1;
                    Stage := Stage + 1;
                end;
            end
            else begin
                if newTarget < border_low then begin
                    Stage := Stage + 1;
                    dstep := 1;
                end
            end;

            while abs(curTarget * 1.0 - meanVoltage * 10000) > 0.03 do begin
                curControl := curControl + trunc((curTarget * 1.0 - curVoltage * 10000) / (50000 / $FFFFF));
                setdPotential(curControl);

                delay(2);
            end;
            while (now - start_Step) * 24 * 3600 < deadspn.Value - 2 do
                application.processmessages;

            GettingData := true;
            start_step := now;
        end;
        T1 := now;
        while (now - T1) * 24 * 3600 < 1 do begin
            application.ProcessMessages;
            sleep(100);
        end;

    end;
//    timeKillEvent(TimerID);
    daqThread.Terminate;
    PrevMTime := TimegetTime;
    while (timegettime() - PrevMtime) < 1000 do
        application.ProcessMessages;
  //Offline the GPIB interface card
    ibonl(dev, 0);
    gpib_get_globals(@ibsta, @iberr, @ibcnt, @ibcntl);
    if (ibsta and ERR) <> 0 then begin
        memoread.lines[0] := (DateToStr(now) + ' ' + TimeToStr(now) + '  ' + 'Err: Error in offline the GPIB interface card.' + #10);
        writetimelog(DateToStr(now) + ' ' + TimeToStr(now) + '  ' + 'Err: Error in offline the GPIB interface card.' + #10);
    end;
    StartCycle.Enabled := true;
    iRet := close_Com(gcPort);
    if iRet > 0 then begin
        Beep;
        iConfirm := MessageDlg('close_COM Error Code:' + IntToStr(iRet) + #13 + IGetErrorString(iRet) + #13 + 'Quit this demo?', mtConfirmation, [mbYes, mbNo], 0);

    end;

    bComOpen := false;
    bCfgChg := False;
    Startcycle.Caption := 'Start measurement'

end;

procedure TMainForm.FormShow(Sender: TObject);
begin
    if (not GPIB_Ready) then begin
        showmessage('GPIB(цифровой вольметр)недоступен');
//        close;
//        application.terminate;
    end;

end;

procedure TMainForm.Chart1DblClick(Sender: TObject);
begin
// SetMinMaxForm.SetLimits(TChart(sende
    while (timegettime() - PrevMtime) < 500 do
        application.ProcessMessages;
end;

procedure TMainForm.Chart2DblClick(Sender: TObject);
begin
    SetMinMaxForm.SetLimits(TChart(Sender));
end;

function TMainForm.delay(ms: integer): integer;
var
    st: double;
begin
    st := now;
    while (now - st) * 24 * 3600 < ms do
        application.ProcessMessages;
end;

function TMainForm.InitCounterAndGPIB: integer;
var
    errmess: string;
    t1: double;
    wrtbuf: array[0..2000] of char;
begin

    if counter_ready and GPIB_ready then
        exit;
    if (not counter_ready) then begin

        gcPort := Char(ComComboBox.ItemIndex + 1);      // Setting Com Port
        gdwBaudRate := 9600;

        iRet := Open_Com(gcPort, gdwBaudRate, gcDataBit, gcParity, gcStopBit);
        if iRet > 0 then begin
            Beep;
            iConfirm := MessageDlg('OPEN_COM Error Code:' + IntToStr(iRet) + #13 + IGetErrorString(iRet) + #13, mtConfirmation, [], 0);

        end
        else begin
            ;
            wRet := DCON_Clear_Counter(gcPort, StrToInt('$' + Address.Text), -1, StrToInt('$' + edCh.Text), 0, 200);
            if wret <> 0 then begin
                showmessage('Counter not found');
                Close_Com(gcPort);
            end
            else begin
                bComOpen := True;
                bCfgChg := False;
                counter_ready := true;
            end;
        end;
    end;
    if (gpib_ready) then
        exit;

    dev := ibdev(cmbGPIB.ItemIndex, cmbInst.ItemIndex + 1, 0, T1s, 1, 0);
    gpib_get_globals(@ibsta, @iberr, @ibcnt, @ibcntl);
    if (ibsta and ERR) <> 0 then begin
        errmess := GpibError(iberr);
        memoread.lines[0] := (DateToStr(now) + ' ' + TimeToStr(now) + '  ' + 'Err: Error in init the GPIB device.' + errmess + #10);
        showmessage('Err: Error in init the GPIB device.');
        exit;

    end;

  //Open and intialize an GPIB instrument
    OpError := false;
(*
  while CycBox.Checked do begin

    T1 := NOW;
    while (now-t1)*24*3600<0.1 DO BEGIN
      application.ProcessMessages;
    END;
*)
    // process error  in prev operation
    if opError then begin
        t1 := NOW;
        while (now - t1) * 24 * 3600 < 8 do begin
            application.ProcessMessages;
        end;
      (*
       winexec(pansichar(paramstr(0)+' continue'), sw_show);
       CycBox.Checked := false;
       application.terminate;
       break;
       *)
    end;

    opError := false;

    //clear the specific GPIB instrument
    ibclr(dev);
    gpib_get_globals(@ibsta, @iberr, @ibcnt, @ibcntl);
    if (ibsta and ERR) <> 0 then begin
        errmess := GpibError(iberr);
        memoread.lines[0] := (DateToStr(now) + ' ' + TimeToStr(now) + '  ' + 'Err: Error in clearing the GPIB device.' + errmess + #10);
        writetimelog(DateToStr(now) + ' ' + TimeToStr(now) + '  ' + 'Err: Error in clearing the GPIB device.' + errmess + #10);
        showmessage('Err: Error in clearing the GPIB device.');
        exit;
    end;

//**************** clear queue and events*****************
    strcopy(wrtbuf, pchar(#10 + '*cls' + #10));
    //Write a string command to a GPIB instrument asynchronously using the ibwrta() command
    ibwrta(dev, @wrtbuf, strlen(wrtbuf));
    gpib_get_globals(@ibsta, @iberr, @ibcnt, @ibcntl);
    if (ibsta and ERR) <> 0 then begin
        memoread.lines[0] := (DateToStr(now) + ' ' + TimeToStr(now) + '  ' + 'Err: Error in writing *cls command to the GPIB instrument.' + #10);
        writetimelog(DateToStr(now) + ' ' + TimeToStr(now) + '  ' + 'Err: Error in writing *cls command to the GPIB instrument.' + #10);
        showmessage('Err: Error in writing *cls command to the GPIB instrument.');
        exit;
    end;

    //Wait for the completion of asynchronous write operation
    ibwait(dev, CMPL);
    gpib_get_globals(@ibsta, @iberr, @ibcnt, @ibcntl);
    if (ibsta and ERR) <> 0 then begin
        memoread.lines[0] := (DateToStr(now) + ' ' + TimeToStr(now) + '  ' + 'Err: Wait for the completion of asynchronous write operation. *cls ' + #10);
        writetimelog(DateToStr(now) + ' ' + TimeToStr(now) + '  ' + 'Err:  Wait for the completion of asynchronous write operation. *cls ' + #10);
        opError := true;
        showmessage('Err: Wait for the completion of asynchronous write operation. *cls ');
        exit;
    end;


//***********finish configure ******************

//**************** Configure  device 10V resolution 6*****************
//    strcopy(wrtbuf, pchar('dcv 10,resl6'));
//**************** Configure  deice 10V resolution 7*****************
    strcopy(wrtbuf, pchar('dcv 10,resl6'));
    //Write a string command to a GPIB instrument asynchronously using the ibwrta() command
    ibwrta(dev, @wrtbuf, strlen(wrtbuf));
    gpib_get_globals(@ibsta, @iberr, @ibcnt, @ibcntl);
    if (ibsta and ERR) <> 0 then begin
        memoread.lines[0] := (DateToStr(now) + ' ' + TimeToStr(now) + '  ' + 'Err: Error in writing the string command to the GPIB instrument.' + #10);
        writetimelog(DateToStr(now) + ' ' + TimeToStr(now) + '  ' + 'Err: Error in writing the string command to the GPIB instrument.' + #10);
        showmessage('Err: Error in writing the string command to the GPIB instrument.');
        exit;
    end;

    //Wait for the completion of asynchronous write operation
    ibwait(dev, CMPL);
    gpib_get_globals(@ibsta, @iberr, @ibcnt, @ibcntl);
    if (ibsta and ERR) <> 0 then begin
        memoread.lines[0] := (DateToStr(now) + ' ' + TimeToStr(now) + '  ' + 'Err: Writing the string command to the GPIB instrument timeout.' + #10);
        writetimelog(DateToStr(now) + ' ' + TimeToStr(now) + '  ' + 'Err: Writing the string command to the GPIB instrument timeout.' + #10);
        showmessage('Err: Writing the string command to the GPIB instrument timeout.');
        opError := true;
        exit;
    end;
    prevread := now();
    GettingData := false;
    DaqThread := Tdaqthread.Create(true);
    daqthread.Priority := tphigher;
    daqthread.Priority := tphighest;
    LastCounterTime := now;
    daqthread.Priority := tpTimeCritical;
    GettingData := false;

    delay(2500);
    gpib_ready := true;
    curControl := v_convert(meanVoltage);
    oldControl := CurControl;
    bottomspn.Value := trunc(meanVoltage * 10000);
    topspn.Value := trunc(meanVoltage * 10000);

    StartCycle.Enabled := true;

//***********finished configure ******************

end;

procedure TMainForm.Timer1Timer(Sender: TObject);
begin
    statusbar1.Panels[0].Text := format('Ctrl=%.5d U=%8.6f', [curControl, curVoltage]);
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
    Info := FormatDateTime('DD_MMMM_YY HH_NN_SS ', now) + Bottomspn.Text + '-' + TopSpn.Text + ' exp-' + expspn.Text + ' dead-' + deadspn.Text;
    s2 := s1 + '\data\';
    DataDirName := s2;
    CreateDirectory(pchar(s2), nil);

    s2 := s2 + Info;
    DataFileName := s2 + '.txt';
    LogFileName := s2 + ' full.txt';
end;

procedure TMainForm.zqry1BeforePost(DataSet: TDataSet);
begin
    showmessage(DataSet.FieldByName('num').AsString + ' ' + DataSet.FieldByName('lowv').AsString + ' ' + DataSet.FieldByName('highv').AsString + ' ' + DataSet.FieldByName('exposition').AsString + ' ');
end;

function TMainForm.SetVoltage(target: double): boolean;
var
    tarcontrol: int64;
    startsetTime: double;
begin
    tarcontrol := V_Convert(target);
    startsetTime := now;
    while ((Bottomspn.Value * 1.0 - meanVoltage * 10000) > 0.2) and ((now - startsetTime) * 24 * 3600 < 5) do begin
        curControl := curControl + trunc((Bottomspn.Value * 1.0 - meanVoltage * 10000) / (50000 / $FFFFF));
        setDPotential(curControl);
        delay(1);
    end;
    if (Bottomspn.Value * 1.0 - meanVoltage * 10000) > 0.2 then
        result := false
    else
        result := true;

end;

end.

