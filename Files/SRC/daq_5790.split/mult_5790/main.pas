unit main;
//26 12 10 53

interface

uses
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    StdCtrls, gpib_user, Adgpib, ComCtrls, ExtCtrls, TeEngine, Series, TeeProcs,
    Chart, Spin, Buttons, mmsystem, strutils, HTTPSend, blcksock, winsock,
    Synautil, Grids, DB, ADODB, DBGrids, ZAbstractRODataset, ZAbstractDataset,
    ZDataset, ZAbstractConnection, ZConnection, ZCompatibility, filectrl,
  Gauges;

const
    sweepmodes: array[0..4] of string = ('UpDown', 'Up', 'Down', 'err', 'Up');

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
        Timer1: TTimer;
        StatusBar1: TStatusBar;
        ts1: TTabSheet;
        pnl1: TPanel;
        pnl2: TPanel;
        pnl3: TPanel;
        addbtn: TSpeedButton;
        rembtn: TSpeedButton;
        con1: TADOConnection;
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
    leconstVolt: TPanel;
        dbgrd2: TDBGrid;
        btn1: TSpeedButton;
        StartCycle: TSpeedButton;
        DescMemo: TMemo;
        Label1: TLabel;
        cmbGPIB: TComboBox;
        cmbInst: TComboBox;
        seSweepCount: TSpinEdit;
        rgSweepMode: TRadioGroup;
        Label2: TLabel;
        Label3: TLabel;
        Label4: TLabel;
        DataDir: TLabeledEdit;
        SpeedButton1: TSpeedButton;
        OpenDialog1: TOpenDialog;
        memoRead: TMemo;
    btn2: TSpeedButton;
    CurU: TLabeledEdit;
    ConstVolt: TLabeledEdit;
    RangeGauge: TGauge;
    SweepLBL: TStaticText;
    Rangelbl: TStaticText;
    StepLBL: TStaticText;
    StepGauge: TGauge;
    TimeInfolbl: TStaticText;
    CurCount: TLabeledEdit;
    SpectrumChart: TChart;
    CountPerVSeries: TPointSeries;
    psFullsp: TPointSeries;
    SelPointCur: TStaticText;
    SelPointSum: TStaticText;
    Panel2: TPanel;
    Panel4: TPanel;
    Splitter2: TSplitter;
    SpeedButton2: TSpeedButton;
    Splitter3: TSplitter;
    SeLowVoltagebtn: TSpeedButton;
    TargetVEdt: TEdit;
        procedure FormCreate(Sender: TObject);
        procedure StartCycleClick(Sender: TObject);
        procedure FormShow(Sender: TObject);
        procedure Chart1DblClick(Sender: TObject);
//    procedure FormClose(Sender: TObject; var Action: TCloseAction);
        procedure Chart2DblClick(Sender: TObject);
        procedure Timer1Timer(Sender: TObject);
        procedure pnl3Click(Sender: TObject);
        procedure rembtnClick(Sender: TObject);
        procedure btn1Click(Sender: TObject);
        procedure FormClose(Sender: TObject; var Action: TCloseAction);
        procedure addressChange(Sender: TObject);
        procedure ComComboBoxChange(Sender: TObject);
        procedure edChChange(Sender: TObject);
        procedure cmbGPIBChange(Sender: TObject);
        procedure cmbInstChange(Sender: TObject);
        procedure SpeedButton1Click(Sender: TObject);
    procedure btn2Click(Sender: TObject);
    procedure dbgrd1CellClick(Column: TColumn);
    procedure SpectrumChartClickSeries(Sender: TCustomChart;
      Series: TChartSeries; ValueIndex: Integer; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure CountPerVSeriesClickPointer(Sender: TCustomSeries;
      ValueIndex, X, Y: Integer);
    procedure psFullspClickPointer(Sender: TCustomSeries; ValueIndex, X,
      Y: Integer);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SeLowVoltagebtnClick(Sender: TObject);
    private
    { Private declarations }
    public
        function SetRegionBorder(target: double): boolean;
        function SetVoltage(target: double): boolean;
        function CorrectVoltage(target: double): boolean;
        function SetRVoltage(target: double): boolean;
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
    lowurl : string = 'http://192.168.0.12:8282/';
    volt_cost : double = 1043960/1000.0;
    Volt_scale : integer = 1000;
    Counter_per_sec : double = 0;
    newTarget, curTarget: double;
    SweepStartTime: double;
    MeasuringStartTime: Double;
    headerstr: string;
    daq_counter: int64 = 0;
    CorrectionTime: double;
    daq_mode: integer = 0;
    GPIB_Ready: Boolean = false;
    counter_ready: boolean = false;
    meanVoltage: double = 0;
    mean3Voltage: double = 0;
    LastVoltage: array[0..10] of double = (-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1);
    Sweep : integer = 0;
    Sweep_duration : double;
    OldSweepNumber: integer;
    counter_and_GPIB_ready: boolean = false;
    v_ref: double = 4.9742;
    PortNum: integer = 9090;
    HTTP: THTTPSend = nil;
    StepStartIndex: int64;
    Border_High, Border_low: dword;
    step_value, dead_value: int64;
    dstep: integer;
    DaqThread: Tdaqthread;
    CurVoltage: double;
    CurControl: int64 = 0;
    oldControl: int64 = 0;
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
    con2: TZConnection;
    zqry1: TZQuery;
    zexe: TZQuery;
    SpectreList : tstringlist;
implementation

uses
    math, logging, SetMinMax, das_const, i7000, i7000u, dcon_pc;
{$R *.DFM}

function delay(ms: integer): integer;
var
    st: double;
begin
    st := now;
    while (now - st) * 24 * 3600 * 1000 < ms do
        application.ProcessMessages;
end;

function V_Convert(v_cur: double): dword;
begin
    result:=trunc(curvoltage*1000*volt_cost);
end;

//function V_revert(d_cur: dword): double;
//begin
//    result := d_cur/20.98843441466855;
//end;

function setdPotential(U: int64): string;
var
    s1, url: string;
begin
    curControl := U;
    if abs(oldControl - U) > (0.01 * $FFFFF / 5) then
        curcontrol := oldcontrol + trunc((0.01 * $FFFFF / 1) * (U - oldcontrol) / abs(oldControl - U));
    if curControl < 0 then
        curcontrol := 0;
    oldControl := CurControl;

    if http <> nil then begin
        http.Free;
        http := nil;
    end;
    HTTP := THTTPSend.Create;
    s1 := format('%d', [curControl]);
    s1 := ansiReplaceStr(s1, ',', '.');
    url := lowurl+'setabs=' + s1;

    HTTP.HTTPMethod('GET', url);
    http.Free;
    http := nil;
end;

function tmainform.CorrectVoltage(target: double): boolean;
var
    tarcontrol: int64;
    startsetTime: double;
    curv :double;
    delta :double;
begin
   if (now - PrevMTime)*24*2600 >1 then begin
     exit;
   end;

//    curControl := curControl + trunc((target * 1.0 - mean3Voltage * 10000) * 20.98843441466855);
    curv := CurVoltage * Volt_scale;

    delta :=  ((target * 1.0 - curvoltage*Volt_scale) * volt_cost);
    curControl := curControl+round(delta);
    setDPotential(curControl);
end;
function CorrectVoltageM(target: double): boolean;
var
    tarcontrol: int64;
    startsetTime: double;
begin
   if (now - PrevMTime)*24*2600 >1 then begin
     exit;
   end;
    curControl := curControl + round((target * 1.0 - CurVoltage * Volt_scale) * volt_cost);
    setDPotential(curControl);
end;

function tmainform.SetVoltage(target: double): boolean;
var
    tarcontrol: int64;
    startsetTime: double;
    diff: double;
    tmpstr: string;
begin
//    tmpstr := format('setvoltage 1 target=%.2f  Cur=%.2f M3=%.2f M5=%.2f  ', [target * 1.0, curVoltage, mean3Voltage * 10000, meanVoltage * 10000]);
//    writetimelog(DataDirName + 'range.txt', tmpstr);
    correctVoltage(target);
    delay(1000);
    diff := mean3Voltage * Volt_scale;
    diff := target * 1.0 - mean3Voltage * Volt_scale;
//    tmpstr := format('setvoltage 2 target=%.2f  Cur=%.2f M3=%.2f M5=%.2f  diff=%.2f', [target * 1.0, curVoltage, mean3Voltage * 10000, meanVoltage * 10000, diff]);
//    writetimelog(DataDirName + 'range.txt', tmpstr);
    if abs(diff) > 0.1 then
        result := false
    else
        result := true;
end;

function tmainform.SetRegionBorder(target: double): boolean;
var
    tarcontrol: int64;
    startsetTime: double;
    Vdiff: double;
begin
    startsetTime := now;
    while (abs((target * 1.0 - curVoltage * Volt_scale)) > 100) and ((now - startsetTime) * 24 * 3600 < 500) do begin
        correctVoltage(target);
        delay(1000);
        Vdiff := abs((target * 1.0 - curVoltage * Volt_scale));
    end;
    if (target <200) and (meanVoltage*Volt_scale<200) then begin
      Result := True;
      Exit;
    end;
    while (abs((target * 1.0 - curVoltage * Volt_scale)) > 1) and ((now - startsetTime) * 24 * 3600 < 120) do begin
        correctVoltage(target);
        delay(1000);
        Vdiff := abs((target * 1.0 - curVoltage * Volt_scale));
    end;

    if (target * 1.0 - curVoltage * Volt_scale) > 1 then begin
        result := false;
    end
    else
        result := true;
    ;
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
        mean := mean + vdata[i].data*Volt_scale;
    end;
    mean := mean / len;
    for i := cur - (len - 1) to cur do begin
        delta := abs(vdata[i].data*Volt_scale - mean);
        if delta > 0.0002 then
            vdata[i].data := mean/Volt_scale;
    end;
    mean := 0;
    std := 0;

    for i := cur - (len - 1) to cur do begin
        mean := mean + vdata[i].data*Volt_scale;
    end;
    mean := mean / len;

    for i := cur - (len - 1) to cur do begin
        std := std + (mean - vdata[i].data*Volt_scale) * (mean - vdata[i].data*Volt_scale);
    end;
    std := sqrt(std / (len));

end;
//
//  ## ##         ###          ## ##
//  ##   ##      ## ##        ##   ##
//  ##   ##     #######       ##   ##
//  ##   ##    #########      ##   ##
//  ##   ##   ##       ##     ##  ###
//  ## ##    ##         ##     ## ###
//                                  ##

function DaqGetdata: boolean;
var
    delta: real;
    wrtbuf, rdbuf: packed array[0..299] of char;
    rdstr: string;
    dtc :double;
begin
    curmtime := timegettime();
//    writeProtocol('1 #################### DAQ start ##################### ' + IntToStr(vindex));
    try

        curtime := now();
//        writeprotocol('2 dstimer callback=' + format('%15.13f', [(Curtime - PrevTime) * 24 * 3600 * 1000]));
        curmtime := timegettime();
//        writeprotocol('3 begin1 dttimer callback=');
        cntval := 0;
//   mainform.Caption:=IntToStr(CurMtime-PrevMTime);
        if (counter_ready) then begin

//            WriteProtocol('Read counter');
            wRet := DCON_Read_Counter(gcPort, StrToInt('$' + mainform.Address.Text), -1, StrToInt('$' + mainform.edCh.Text), 0, 200, @cntVal);
//            WriteProtocol('check Read counter = ' + IntToStr(cntval));
            if wRet <> 0 then begin
                writeprotocol('Err: Error reading counter.');
                cntval := 131313;
            end
            else begin
                deltaCounterValue := cntval - lastCounterValue;
                dtc := now;

                dtc := (dtc - LastCounterTime )*24*3600*1000;
                if  dtc > 100
                      then counter_per_sec := deltaCounterValue* 1000 / dtc
                      else  counter_per_sec := 0;;
                LastCounterValue := cntval;
                LastCounterTime := now();
                if cntval > $F00000 then begin
                    LastCounterValue := 0;
                    DCON_Clear_Counter(gcPort, StrToInt('$' + mainform.Address.Text), -1, StrToInt('$' + mainform.edCh.Text), 0, 200);
                end

            end;
        end;

        curmtime := timegettime();
//        writeprotocol('counter ok = ' + IntToStr(cntval));

        strcopy(wrtbuf, pchar('X?'));
//        WriteProtocol('4 ibwrta Write a string command to a GPIB instrument asynchronously using the ibwrta() command');
        ibwrta(dev, @wrtbuf, strlen(wrtbuf));
//        WriteProtocol('5 get globals');

        gpib_get_globals(@ibsta, @iberr, @ibcnt, @ibcntl);
        if (ibsta and ERR) <> 0 then begin
            writeprotocol('6 Err: Error in writing the string command to the GPIB instrument.');
            opError := true;
            exit;
        end;
//        writeprotocol('7 Answer ok from the GPIB instrument ok. ibcnt = ' + IntToStr(ibcnt));
//        WriteProtocol('8 ibWait for the completion of asynchronous write operation');
        ibwait(dev, CMPL);

        curmtime := timegettime();
//        writeprotocol('9 wait ok = ' + IntToStr(CurMtime - PrevMTime));
//        WriteProtocol('10 get globals');

        gpib_get_globals(@ibsta, @iberr, @ibcnt, @ibcntl);
        if (ibsta and ERR) <> 0 then begin
            writeprotocol('11 Err: Writing the string command to the GPIB instrument timeout.');
            opError := true;
            exit;
        end;
//        writeprotocol('12 Answer ok from the GPIB instrument ok. ibcnt = ' + IntToStr(ibcnt));
        fillchar(rdbuf,100,0);
//        WriteProtocol('13 //Read the response string from the GPIB instrument asynchronously using the ibrda() command');
//        WriteProtocol('14 ibrda');
        ibrda(dev, @rdbuf, 100);
//        WriteProtocol('15 get globals');
        gpib_get_globals(@ibsta, @iberr, @ibcnt, @ibcntl);
        if (ibsta and ERR) <> 0 then begin
            writeprotocol('16 Err: Error in reading the response string from the GPIB instrument.');
            opError := true;
            exit;
        end;
//        writeprotocol('17 Answer ok from the GPIB instrument ok. ibcnt = ' + IntToStr(ibcnt));

//        WriteProtocol('18 Wait for the completion of asynchronous read operation');
        ibwait(dev, CMPL);
//        WriteProtocol('19 get globals');
    //Получение напряжения
        gpib_get_globals(@ibsta, @iberr, @ibcnt, @ibcntl);
        if (ibsta and ERR) <> 0 then begin
            mainform.caption := FormatdateTime('DD/MM/YYYY HH:NN:SS', now) + 'Err: Reading the string command to the GPIB instrument timeout.';
            writeprotocol('20 Err: Reading the string command to the GPIB instrument timeout.');
            opError := true;
            exit;
        end;
//        writeprotocol('21 Answer ok from the GPIB instrument ok. ibcnt = ' + IntToStr(ibcnt));

        rdbuf[ibcnt - 1] := chr(0);
        rdstr := rdbuf;
        rdstr := rdstr + ' ';

//        if PrevVoltage = rdstr then exit; //У АЦП нет новых данных
        PrevVoltage := rdstr;
        rdstr := system.copy(rdstr, 1, pos(' ', rdstr) - 1);
        val(rdstr, dacval, resc);
        dacval := abs(dacval);
        writeprotocol('Answer ok from the GPIB instrument ok. ibcnt = ' + IntToStr(ibcnt) + ' '+format('%.5f',[dacval])+' str=' + rdstr);

        if (pos('.', rdstr) = 0) then begin
            PrevMTime := TimeGetTime();
            PrevTime := now;
            writeProtocol('23 ####ZERO ' + rdstr + #10);
            exit;

        end;
        dacval:=dacval/1000.0;
//        writeprotocol('24');
        rdstr := rdstr + ' ' + format(' %.4d %.6d %.1d %.8d %.8d %.3d', [cntval, curControl, dstep, vindex + 1, stepStartIndex, deltaCounterValue]) + ' ' + intToStr(trunc((timegettime - prevMtime))) + ' ' + StringReplace(floattostr(now), ',', '.', [rfReplaceAll, rfIgnoreCase]);
//        writeprotocol('14');
        prevread := now();
//        writeprotocol('rdstr: ' + rdstr);
        CurVoltage := dacval;
        if GettingData then begin
            writetimelog(DataDirName + IntToStr(Sweep) + '.dat', rdstr);
            if resc = 0 then
                vdata[vIndex + 1].data := dacval
            else
            vdata[vIndex + 1].data := -1;
            vdata[vindex + 1].counter := cntval;
            vdata[vindex + 1].time := now();
            vdata[vindex + 1].data := dacval;
            inc(vIndex);
        end

        else if counter_ready then begin
            wRet := DCON_Clear_Counter(gcPort, StrToInt('$' + mainform.Address.Text), -1, StrToInt('$' + mainform.edCh.Text), 0, 200);
            LastCounterValue := 0;
        end;

    except
        on E: Exception do begin
            writeprotocol('%%%%%%%%%%%%%%%%% Exceprton on read counter:' + E.Message);
            mainform.Caption := 'exception!!!!!!!!!!!!!!!!!!!';
        end;

    end;

//    writeProtocol('26 #######D AQ end ' + IntToStr(vindex));

    PrevMTime := TimeGetTime();
    PrevTime := now;
end;

procedure TDAQThread.execute;
var
    i: integer;
    meant, mean3t,  Curtimel, PrevTimel: double;
    CurMtimel, PrevMTimel: dword;
begin
    while not terminated do begin
     try
        if (gpib_ready) then begin
            DaqGetData;
            inc(Daq_counter);
            for i := 0 to 4 do
                if (LastVoltage[i] < 0) then
                    LastVoltage[i] := CurVoltage
                else
                    LastVoltage[i] := LastVoltage[i + 1];
            LastVoltage[5] := curVoltage;
            meant := LastVoltage[0];
            mean3t := LastVoltage[3];
            for i := 1 to 5 do begin
                meant := meant + LastVoltage[i];
                if i > 3 then
                    mean3t := mean3t + LastVoltage[i];
            end;
            meanVoltage := meant / 6.0;
            mean3Voltage := mean3t / 3.0;
        end;
       except
            writetimelog(DataDirName + IntToStr(Sweep) + '.dat', 'Exception on DAQ GET DATA');
            writetimelog( 'Exception on DAQ GET DATA');

       end;
        sleep(300)
    end;
    mainform.Caption := 'terminated';
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
    i: int64;
begin
    deadspn.Value := 5;
    address.Value := cf.readInteger('hardware', 'counter_addr', 0);
    ComComboBox.ItemIndex := cf.readInteger('hardware', 'counter_port', 0);
    cmbGPIB.ItemIndex := cf.readInteger('hardware', 'gpib', 0);
    cmbInst.ItemIndex := cf.readInteger('hardware', 'gpib_instrument', 0);
    edch.Value := cf.readInteger('hardware', 'counter_channel', 0);
    con2 := TZConnection.Create(self);
    with con2 do begin
        ControlsCodePage := cGET_ACP;
        AutoEncodeStrings := False;
        Port := 0;
        Database := extractfilepath(application.ExeName) + 'exp.db';
        Protocol := 'sqlite-3';
    end;
    zexe := TZQuery.Create(self);
    zexe.Connection := con2;
    zqry1 := TZQuery.Create(self);
    with zqry1 do begin
        Connection := con2;
        sql.Clear;
        sql.Add('select * from seanses order by Ubeg');

    end;
    ds1.DataSet := zqry1;
//    dbgrd1.DataSource := ds
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
    con2.Connect;
    zqry1.Open;
end;

procedure TimerProc(uTimerID, uMessage: UINT; dwUser, dw1, dw2: DWORD) stdcall;
begin
    Daqgetdata;
end;

procedure TMainForm.StartCycleClick(Sender: TObject);
var
  //Declare variables
    wrtbuf, rdbuf: packed array[0..399] of char;
    msg, errmess, rdstr: string;
    I1: INTEGER;
    T1, T2: DOUBLE;
    start_dead: double;
    tmpstr: string;
var
   cur_target_str : string;
    old_counter, c1,c2,c3 : integer;
    old_str : string;
    dt: double;
    prt: tthreadpriority;
    il1, il2, il3: integer;
    prevGrIndex: integer;
    CounterStep: integer;
    Stepstr: string;

    procedure ClearSeries;
    begin
        ch1StdSeries.clear;
        ch1VoltSeries.clear;
        CountPerVSeries.Clear;
        ch1VoltSeries.clear;
        ch1MeanSeries.clear;
        MEANvOLTAGEseries.clear;
        STDvOLTAGEseries.clear;
        Counterseries.clear;
        psFullsp.Clear;
    spectrumchart.RightAxis.Maximum := 100;
    spectrumchart.LeftAxis.Maximum := 100;

    end;

    procedure showerrorRange;
    begin
        showmessage('Program error. mode: ' + IntToStr(daq_mode) + ' Direction:'+ IntToStr(dstep) + ' target: ' + floatToStr(curTarget) + ' Ubeg= ' + intToStr(border_low) + ' Uend= ' + intToStr(border_high) + ' recno: ' + intToStr(zqry1.RecNo));
        halt(1);

    end;

    procedure SetEnablingControl;
    begin
        if (Startcycle.Caption = 'Start measurement') then
            ts1.Enabled := true
        else
            ts1.Enabled := false;

//         fg,gb,b,bvvn
    end;

    procedure setrangeparams;
    begin
        border_low := zqry1.FieldValues['Ubeg'];
        border_high := zqry1.FieldValues['Uend'];
        dead_value := zqry1.FieldValues['dead_time'];
        step_value := zqry1.FieldValues['Ustep'];
        step_len := zqry1.FieldValues['exposition'];

    end;

    function Myround(d: double): double;
    begin
        result := d;
    end;

    procedure BeginSweep;
    var
        tmpstr: string;
    begin
        tmpstr := Format('Region: %d, Sweep= %d, SweepMode= %s', [zqry1.RecordCount, Sweep, sweepmodes[dstep + 3]]) + #10;
        WriteLog(DataDirName + IntToStr(Sweep) + '.txt', tmpstr);
        WriteLog(DataDirName + IntToStr(Sweep) + '.txt', headerstr);
        WriteLog(DataDirName + IntToStr(Sweep) + '.txt', #10);
        WriteLog(DatadirName + IntToStr(Sweep) + '.txt', descmemo.Text+#10);
        countPerVSeries.Clear;
        SweepStartTime := now;
    end;

    procedure FinishSweep;
    var
        tmpstr: string;
        il1 : integer;
        x, y : double;
        s1 :string;
    begin
        psFullsp.Clear;
        for il1 := 0 to SpectreList. Count -1 do begin
          x:=StrToInt(spectreList.Names[il1]) /1000.0;
          s1 := spectreList.values[spectreList.Names[il1]];
          y:=StrToInt(s1)  * 1.0;
          if spectrumChart.LeftAxis.Maximum < y*1.1 then spectrumChart.LeftAxis.Maximum := y*1.1; 
          psFullsp.AddXY(x,y);

        end;
        tmpstr := 'Current date: ' + FormatDateTime('DD.MM.YYYY', now) + ', Begin time:' + FormatDateTime('HH.NN.SS', SweepStartTime) + ', End time:' + FormatDateTime('HH.NN.SS', now);
        WriteLog(DatadirName + IntToStr(OldSweepNumber) + '.txt', tmpstr);
    end;

    function SetNewRegion: boolean;
    var
        tmpstr: string;
    begin
        tmpstr := 'Set range  mode = ' + IntToStr(daq_mode) + ' step = ' + IntToStr(dstep) + ' target= ' + floatToStr(curTarget) + ' Ubeg= ' + intToStr(border_low) + ' Uend= ' + intToStr(border_high) + ' recno= ' + intToStr(zqry1.RecNo);
        writetimelog(DataDirName + 'range.txt', tmpstr);
        writetimelog(' set region ='+tmpstr+#10);


        if daq_mode = 1 then begin
            if dstep < 0 then
                showerrorRange;
            if MyRound(curTarget) < border_low then
                showerrorRange;
        end;

        if (dstep > 0) then begin
            if MyRound(curTarget) < border_low then
                showerrorRange;
            if MyRound(curTarget) > border_high then begin
                zqry1.MoveBy(1);
                setrangeparams;
                if zqry1.Eof then begin
                    if daq_mode = 0 then begin
                        zqry1.Last;
                        setrangeparams;
                        dstep := -1;
                        curTarget := zqry1.FieldValues['Uend'];
                        Sweep := Sweep + 1;
                        exit;
                    end
                    else begin
                        zqry1.first;
                        setrangeparams;
                        zqry1.MoveBy(-zqry1.RecNo);
                        curTarget := zqry1.FieldValues['Ubeg'];
                        Sweep := Sweep + 1;
                        exit;

                    end;
                end
                else begin
                    curTarget := zqry1.FieldValues['Ubeg'];
                end;
                setrangeparams;
                exit;
            end;
        end;
        if (dstep < 0) then begin
            if MyRound(curTarget) > border_high then begin
                showerrorRange;
                exit;
            end;
            if curTarget < border_low then begin
                zqry1.MoveBy(-1);
                setrangeparams;
                if zqry1.bof then begin
                    zqry1.first;
                    setrangeparams;
                    dstep := 1;
                    curTarget := zqry1.FieldValues['Ubeg'];
                    Sweep := Sweep + 1;
                    exit;
                end
                else
                    curTarget := zqry1.FieldValues['Uend'];
                exit;
            end
        end;
        showmessage('set range illegal sutiation');
        showerrorRange;
    end;
var
tmpr,delta :Extended;
Index_in_step : integer;
sum, sumx2 : double;
begin
 if (zqry1.RecordCount <1) then begin
   showmessage('No measurung range');
   exit;
 end;
    spectreList.Clear;
    ClearSeries();

    Application.ProcessMessages;
    daq_mode := rgSweepmode.ItemIndex;
    if (Startcycle.Caption = 'Stop measurement') then begin
        Startcycle.Caption := 'Finishing ....';
        Startcycle.Font.Color := clGreen;
        exit;
    end;
    if (Startcycle.Caption <> 'Start measurement') then begin
        exit;
    end;
    Screen.Cursor := crHourGlass;

    Startcycle.Enabled := false;
    Startcycle.Caption :='Prepare measurement';

    Sweep := 1;
    CreateDataFileName;

    zqry1.MoveBy(-zqry1.RecNo);
    tmpstr := format('Region number: %d, Sweep number: %d,  Sweep mode: %s', [zqry1.RecordCount, seSweepCount.Value, sweepmodes[rgSweepMode.ItemIndex]]);
    Writelog(DataFileName + '.txt', tmpstr + #10);
    Headerstr := '';
    sweep_Duration := 0;
    while not (zqry1.Eof) do begin
        sweep_Duration := sweep_Duration + (zqry1.FieldByName('dead_time').AsInteger+zqry1.FieldByName('exposition').AsInteger)*
         (1+
         (-zqry1.FieldByName('Ubeg').AsInteger + zqry1.FieldByName('Uend').AsInteger) * 1000  div (zqry1.FieldByName('Ustep').AsInteger+1)
         );
        headerstr := headerstr + format('Region %d: Ubeg(V)= %d, Uend(V)= %d, Ustep(V)= %.1f, Exposition(s)= %d, Dead(s)= %d, Channels= %d  ',
             [zqry1.RecNo, zqry1.FieldByName('Ubeg').AsInteger, zqry1.FieldByName('Uend').AsInteger, zqry1.FieldByName('Ustep').AsInteger / 1000.0,
              zqry1.FieldByName('exposition').AsInteger, zqry1.FieldByName('dead_time').AsInteger,
              1+(-zqry1.FieldByName('Ubeg').AsInteger + zqry1.FieldByName('Uend').AsInteger) * 1000  div (zqry1.FieldByName('Ustep').AsInteger+1) ]) + #10;
        zqry1.Next;
    end;
    Sweep_duration := Sweep_duration /(24*3600);
    headerstr := headerstr +'Constant voltage(V)= '+ConstVolt.Text+#10;
    WriteLog(DataFileName + '.txt', headerstr + #10);
    WriteLog(DataFileName + '.txt', descmemo.Text+#10);


    zqry1.MoveBy(-zqry1.RecNo);
    setrangeparams;

    if not SetRegionBorder(border_low) then begin
        showmessage('Не удается установить начальный уровень = ' + IntToStr(border_low));
        Startcycle.Enabled := true;
        Screen.Cursor := crDefault;
        exit;
    end;
    for I1 := 0 to 10 do begin
       delay(1500);
       correctVoltage(border_low);
    end;

    for I1 := 0 to 10 do begin
        if SetVoltage(border_low) then
            break;
        if I1 = 10 then begin
            showmessage('Не удается установить начальный уровень = ' + IntToStr(border_low));
            Startcycle.Caption := 'Start measurement';
            Startcycle.Enabled := true;
            Screen.Cursor := crDefault;
            exit;
        end;
    end;
//    setreg
    memoread.Lines.Add('Set ok. wait 4 sec');

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
    CorrectionTime := now;
    curTarget := Border_low;
    Startcycle.Caption := 'Stop measurement';


    SetEnablingControl;
    MeasuringStartTime := Now;

    BeginSweep;
    countPerVSeries.AddXy(Border_low-0.1, 0);
    countPerVSeries.AddXy(Border_High+0.1, 0);
    TabSheet1.SetFocus;
    PageControl2.ActivePageIndex := 0;
    for i1 := 1 to 10000 do application.ProcessMessages;

//######################################################################################
//
//  ##     ##     ###       ######  ###     ##
//  ###   ###    ## ##        ##    ####    ##
//  #### ####   #######       ##    #####   ##
//  ## ### ##  #########      ##    ### ##  ##
//  ##     ## ##       ##     ##    ###  #####
//  ##     ####         ##  #####   ###    ###
//
//######################################################################################
    Startcycle.Font.Color := clRed;
    Startcycle.Enabled := true;
    Screen.Cursor := crDefault;
    dstep := 1;
    GettingData := true;
    Index_in_step := 0;
    start_step := now;

    while (Startcycle.Caption = 'Stop measurement') do begin
        mainform.Caption := IntToStr(cntval);

        while ch1VoltSeries.Count > 16230 do
            ch1VoltSeries.Delete(0);
        i1 := ch1VoltSeries.Count;
        while ch1MeanSeries.Count > 6230 do
            ch1MeanSeries.Delete(0);
        while MEANvOLTAGEseries.Count > 6563530300 do
            MEANvOLTAGEseries.Delete(0);
        while STDvOLTAGEseries.Count > 65300 do
            STDvOLTAGEseries.Delete(0);
        while Counterseries.Count > 5300 do
            Counterseries.Delete(0);
        if prevGrIndex = vindex + 1 then
            continue;
        inc(index_in_step);
        for il1 := prevGrIndex to vindex do begin
            ch1VoltSeries.AddXY(vdata[il1].time, vdata[il1].data*Volt_scale);
        end;
        IF (ch1VoltSeries.Count>0) AND  (ch1STDSeries.Count>0) THEN  while ch1StdSeries.XValues[0]< ch1VoltSeries.XValues[0]  do         ch1StdSeries.Delete(0);



        prevGrIndex := vindex + 1;

        if (now - start_step) * 24 * 3600 > step_len then begin
            start_dead := now;

            GettingData := false;
//       while (now-start_Step)*24*3600<0.4 do application.processmessages;

            CounterStep := vdata[vindex].counter;
            dt := (now() - lastCounterTime) * 24 * 3600;
            CalcStdAndMean(Vindex, vindex - StepStartIndex); // vIndex-PrevVindex);


//            ch1MeanSeries.AddXY(now, mean);
//            ch1stdSeries.AddXY(now, std);
            MeanVoltageSeries.AddXY(now(), mean);
            stdVoltageSeries.AddXY(now(), std);
            countPerVSeries.AddXy(curtarget, CounterStep);
            if  spectrumchart.RightAxis.Maximum < CounterStep*1.05 then spectrumchart.RightAxis.Maximum := CounterStep*1.1;

           i1 := 0;
           cur_target_str := IntToStr(round(curtarget*1000));
           if (spectreList.Values[cur_target_str]) = '' then
                spectreList.Values[cur_target_str] := IntToStr(CounterStep)
            else begin
                Old_Counter := StrToInt(spectreList.Values[cur_target_str]);
                spectreList.Values[cur_target_str] :=IntToStr(Old_counter +CounterStep);
             end;
            Stepstr := format('%8.6f %8.6f ', [mean, std]);
            Stepstr := Stepstr + ' ' + format(' %.5d %.2d %.8d %.6d %.6d', [CounterStep, curControl, dstep, vindex + 1, stepStartIndex]) + ' ' + StringReplace(floattostr(now), ',', '.', [rfReplaceAll, rfIgnoreCase]);
            Stepstr := StringReplace(Stepstr, ',', '.', [rfReplaceAll, rfIgnoreCase]);
            writetimelog(DataFileName + '.dat', Stepstr+#10);
            memoread.lines[0] := (DateToStr(now) + ' ' + TimeToStr(now) + '  ' + 'Read ok = ' + rdstr);
    //   writetimelog(rdstr+#10);

            LastCounterTime := now;

            StepStartIndex := vindex + 1;
            tmpstr := format('finish %.2f  %.2f  %.2f   %.2f %.2f', [curTarget * 1.0, meanVoltage * Volt_scale, mean3Voltage * Volt_scale, dstep * step_Value / 1000.0, border_low * 1.0]);
            writetimelog(DataDirName + 'range.txt', tmpstr+#10);

            newTarget := curTarget + dstep * step_Value / 1000.0;
            curTarget := newTarget;
            if (curTarget > Border_High) or (curTarget < Border_low) then begin
                OldSweepNumber := Sweep;
                if dstep > 0 then
                     SetNewRegion()
                else
                     SetNewRegion();
                if (seSweepCount.Value > 0) and (Sweep > seSweepCount.Value) then begin
                    FinishSweep;
                    Writelog(DataFileName + '.txt', tmpstr + #10);
                    tmpstr := 'Current date: ' + FormatDateTime('DD.MM.YYYY', now) + ', Begin time:' + FormatDateTime('HH.NN.SS', MeasuringStartTime) + ', End time:' + FormatDateTime('HH.NN.SS', now);
                    WriteLog(DatafileName+'.txt', tmpstr+#10);
                    break;
                end;
                {
                IF THEN ELSE}
                if OldSweepNumber <> Sweep then begin
                    FinishSweep;
                    BeginSweep;
                    SweepStartTime := now;
                end;
                if dstep=1 then curTarget := border_low else curTarget := Border_High;
                SetRegionBorder(curTarget);
                for I1 := 0 to 10 do SetVoltage(curtarget);
                while (now - start_dead) * 24 * 3600 < dead_Value * 2 do begin
                    setVoltage(curTarget);
                end;
                Start_dead := now;
                Index_in_step := 0;
            end
            else begin
                start_dead:=now;
                writetimelog(format('===Begin   cur= %.4f  Step Mean3= %.4f  Target= %.4f ctrl=%d',[curVoltage*Volt_scale, mean3Voltage*Volt_scale, curTarget,curControl])+#10);
                while (now - start_dead) * 24 * 3600 < dead_Value-1 do begin
                    delta :=  ((curtarget * 1.0 - curvoltage*Volt_scale) * volt_cost);
                    curControl := curControl+round(delta);
                    writetimelog('dead='+ IntToStr( trunc((now - start_dead) * 24 * 3600 ) )+format(' Correct cur= %.4f Target= %.4f Ctrl=%d Delta=%f',[curVoltage*Volt_scale, curTarget, curcontrol,delta])+#10);
                    setDPotential(curControl);
                    delay(1200);
                end;
                while (now - start_dead) * 24 * 3600 < dead_Value -0.3 do begin
                    writetimelog(format('wait Step begin= cur= %.2f Target= %.2f',[curVoltage*Volt_scale,  curTarget])+#10);
                    delay(300);
                end;
            end;
            tmpstr := format('start target = %.2f  mean =(%.2f  %.2f  %.2f)   %.2f %.2f', [curTarget * 1.0, CurVoltage * Volt_scale, meanVoltage * Volt_scale, mean3Voltage * Volt_scale, dstep * step_Value / 1000.0, border_low * 1.0]);
            writetimelog(DataDirName + 'range.txt', tmpstr+#10);
            GettingData := true;
            correctionTime := now;
            start_step := now;
            Index_in_step := 0;
        end else begin
          if (index_in_step>2)then begin
            if ((index_in_step>10)) then begin
                sum :=0;
                sumx2 :=0;
                for i1 := ch1Voltseries.Count-10 to  ch1Voltseries.Count-1 do begin
                     tmpr :=  ch1Voltseries.YValues[i1];
                     sum:=sum+tmpr;
                     sumx2 := sumx2++tmpr*+tmpr;
                end;

                mean := sum/10;
                std :=sumx2/10-mean*mean+0.00000001;
                if abs(std)<0.0000000000001 then std := 0.00000001;
                if std<0 then
                  ch1stdSeries.AddXY(now, std);

                std := sqrt(std);
                ch1stdSeries.AddXY(now, std);
            end;
            sum :=0;
            for i1 := ch1Voltseries.Count-2 to  ch1Voltseries.Count-2 do begin
                 sum:=sum+ch1Voltseries.YValues[i1];
                 sumx2 := sumx2+ch1Voltseries.YValues[i1]*ch1Voltseries.YValues[i1];
            end;

              mean := sum/1;


             delta :=  ((curtarget * 1.0 - curvoltage*Volt_scale) * volt_cost);
             writetimelog(format(' StepCorr cur= %.4f Target= %.4f Ctrl=%d Delta=%f',[curVoltage*Volt_scale, curTarget, curcontrol,delta])+#10);

             curcontrol := curcontrol +trunc(delta);
             setdPotential(curcontrol)
          end;
          delay(1000);
        end;
    end;
    GettingData := false;
    StartCycle.Enabled := true;
    Startcycle.Caption := 'Start measurement';
    Startcycle.Font.Color := clBlue;

    SetEnablingControl;

end;

procedure TMainForm.FormShow(Sender: TObject);
begin
 Steplbl.Caption := 'Declared V.';
 Rangelbl.Caption := 'Range';
 StepGauge.Progress :=0;
 RangeGauge.Progress := 0;
    deadspn.Value := 5;
    deadspn.Invalidate;

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
    st, ctime: double;
begin
    st := now;
    while (now - st) * 24 * 3600 * 1000 < ms do
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
    strcopy(wrtbuf, pchar('dcv 1000,resl6'));
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
//    daqthread.Priority := tpTimeCritical;
    GettingData := false;
    gpib_ready := true;
    daqthread.Resume;
    delay(2000);

    curControl := v_convert(meanVoltage);
    oldControl := CurControl;
//    bottomspn.Value := trunc(meanVoltage * 10000);
//    topspn.Value := trunc(meanVoltage * 10000);
    StartCycle.Enabled := true;

//***********finished configure ******************

end;

procedure TMainForm.Timer1Timer(Sender: TObject);
var
 dt, dv,wv: double;
begin
     statusbar1.Panels[2].Text := formatDateTime('HH:NN:SS', now);

 if (now - PrevMTime)*24*3600 >1 then begin
     statusbar1.Panels[1].Text := formatDateTime('Nodata HH:NN:SS', now);
      curU.Text := 'DAQ ERROR!!!';
      curu.Font.Color := clred;
     end
     else begin
        if GettingData then begin
          StatusBar1.Panels[3].Text:='';
          SweepLBL.Caption := 'Sweep :'+IntToStr(Sweep)+' '+sweepmodes[dstep + 3]+' ( '+IntToStr(trunc((now-SweepStartTime)*100/sweep_duration))+'% '+
          format(' %.2dh:%.2dm:%.2ds',[Trunc(Sweep_duration*24), Trunc(Sweep_duration*24*60) mod (60), Trunc(Sweep_duration*24*60*60)  mod 60])+' )';

          dt := Trunc(Sweep_duration*24);
          dt := Trunc(Sweep_duration*24*60);
          dt := Trunc(Sweep_duration*24*60) mod (24*60);
          dt := Trunc(Sweep_duration*24*60*60) mod (24*60*60);

//          TimeInfolbl.Caption := 'Sweep '+IntToStr(Sweep)+
//          '   Length: '+format(' %.2d:%.2d:%.2d',[Trunc(Sweep_duration*24), Trunc(Sweep_duration*24*60) mod (24*60), Trunc(Sweep_duration*24*60*60)  mod 60])+
//          '       Start: '+FormatDateTime('DD/MM/YYYY HH:NN:SS',SweepStartTime)+
//          '   Estimate end: '+formatdatetime('DD/MM/YYYY HH:NN:SS',SweepStartTime+Sweep_duration)+
//          '   Progress: '+IntToStr(trunc((now-SweepStartTime)*100/sweep_duration))+'%' ;
          TimeInfolbl.Caption := 'Start: '+FormatDateTime('DD/MM/YYYY HH:NN:SS',MeasuringStartTime)+ '   Sweep number:' ;
          if seSweepCount.Value = 0
             then begin
                 TimeInfolbl.Caption :=TimeInfolbl.Caption+ ' unlimited,';
             end else begin
                TimeInfolbl.Caption :=TimeInfolbl.Caption+ seSweepCount.Text+
             ',   Length:'+format(' %.2d:%.2d:%.2d',[Trunc(Sweep_duration*seSweepCount.value*24), Trunc(Sweep_duration*seSweepCount.value*24*60) mod (60), Trunc(Sweep_duration*seSweepCount.value*24*60*60)  mod 60]);
              TimeInfolbl.Caption :=TimeInfolbl.Caption+',   Estimate end: '+formatdatetime('DD/MM/YYYY HH:NN:SS',SweepStartTime+Sweep_duration*seSweepCount.Value)+
             ',   Progress: '+IntToStr(trunc((now-MeasuringStartTime)*100/(sweep_duration*seSweepCount.Value)))+'%' ;
           end;

          Rangelbl.Caption := format('Range %dv - %dv',[border_low,Border_High]);
          steplbl.Caption := format('Declared V.: %.1fv Step:%dmv',[curtarget,step_value]);
          dv := curtarget-Border_low;
          if dstep<0
             then dv := abs(curtarget-Border_high)
             else dv := abs(curtarget-Border_low);

          wv := abs(Border_High-Border_low);
           RangeGauge.Progress := trunc(dv*1000/(wv));
          dt := (now - start_step)*24*3600;
          if    (now - start_step)*24*3600>1
             then  stepGauge.Progress := trunc((now - start_step) * 24 * 3600*1000/step_len)
             else   stepGauge.Progress :=0;
          StatusBar1.Panels[3].Text := format('dt=%f dv=%f wv=%f ct=%f bl=%d bh=%d ',[dt,dv,wv, curTarget,Border_low,Border_High]);
        end else begin
        end;
        statusbar1.Panels[1].Text := '';
        statusbar1.Panels[0].Text := format('Ctrl=%.5d U=%.6f', [curControl, curVoltage]);
        curU.Text := format('%8.3f', [ curVoltage*Volt_scale]);
        CurCount.Text := format('%d', [ trunc(Counter_per_sec)]);
  end;
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

    s1 := extractfiledrive(application.exename);
    Info := FormatDateTime('DD_MMMM_YY-HH_NN_SS', now) + Bottomspn.Text + '-' + TopSpn.Text + ' exp-' + expspn.Text + ' dead-' + deadspn.Text;
    s2 := s1 + '\data\';
    CreateDirectory(pchar(s2), nil);
    s2 := s2 + FormatDateTime('DD_MMMM_YY-HH_NN_SS', now) + '\';
    if DirectoryExists(DataDir.Text) then
        s2 := DataDir.Text + '\';
    DataDirName := s2;
    if not DirectoryExists(DataDirName) then
        CreateDirectory(pchar(DataDirName), nil);
    s2 := s2 + Info;
    DataFileName := s2;
    LogFileName := s2 + ' full.txt';
end;

function TMainForm.SetRVoltage(target: double): boolean;
var
    tarcontrol: int64;
    startsetTime: double;
begin
    tarcontrol := V_Convert(target);
    startsetTime := now;
    while ((Bottomspn.Value * 1.0 - meanVoltage * Volt_scale) > 0.2) and ((now - startsetTime) * 24 * 3600 < 5) do begin
        curControl := curControl + trunc((Bottomspn.Value * 1.0 - meanVoltage * Volt_scale) / (50000 / $FFFFF));
        setDPotential(curControl);
        delay(1000);
    end;
    if (Bottomspn.Value * 1.0 - meanVoltage * Volt_scale) > 0.2 then
        result := false
    else
        result := true;

end;

procedure TMainForm.pnl3Click(Sender: TObject);
begin
{
IF THERHEN 


}
    if (Bottomspn.Value >= Topspn.Value) then begin
        showmessage('Error: Нижняя граница должна быть меньше верхней ');
        exit;
    end;
    if  stepspn.Value<>0 then begin
      if ((Topspn.Value - Bottomspn.Value) * 1000 mod stepspn.Value) <> 0 then begin
          showmessage('Error: Ширина интекрвала не кратна шагу');
          exit;
       end;
    end;
    zqry1.Insert;
    zqry1.FieldByName('Ubeg').AsInteger := Bottomspn.Value;
    zqry1.FieldByName('Uend').AsInteger := topspn.Value;
    zqry1.FieldByName('dead_time').AsInteger := deadspn.Value;
    zqry1.FieldByName('exposition').AsInteger := expspn.Value;
    zqry1.FieldByName('Ustep').AsInteger := stepspn.Value;
    zqry1.Post;
    zqry1.Close;
    zqry1.Open;
end;

procedure TMainForm.rembtnClick(Sender: TObject);
var
    Ubeg: int64;
begin
    if zqry1.RecordCount = 0 then
        exit;
    Ubeg := zqry1.fieldbyname('Ubeg').AsInteger;
    zqry1.Close;
    zexe.SQL.Text := 'delete from seanses where Ubeg = ' + IntToStr(Ubeg);
    zexe.ExecSQL;
    zqry1.Open;
end;

procedure TMainForm.btn1Click(Sender: TObject);
begin
    zqry1.Close;
    zexe.SQL.Text := 'delete from seanses';
    zexe.ExecSQL;
    zqry1.Open;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
// DaqThread.Suspend;
// DaqThread.terminate;
  //DaqThread.free;;
end;

procedure TMainForm.addressChange(Sender: TObject);
begin
    cf.WriteInteger('hardware', 'counter_addr', tspinedit(Sender).Value);
end;

procedure TMainForm.ComComboBoxChange(Sender: TObject);
begin
    cf.WriteInteger('hardware', 'counter_port', TComboBox(Sender).ItemIndex);

end;

procedure TMainForm.edChChange(Sender: TObject);
begin
    cf.WriteInteger('hardware', 'counter_channel', tspinedit(Sender).Value);
end;

procedure TMainForm.cmbGPIBChange(Sender: TObject);
begin
    cf.WriteInteger('hardware', 'gpib', TComboBox(Sender).ItemIndex);

end;

procedure TMainForm.cmbInstChange(Sender: TObject);
begin
    cf.WriteInteger('hardware', 'gpib_instrument', TComboBox(Sender).ItemIndex);
end;

procedure TMainForm.SpeedButton1Click(Sender: TObject);
var
    rootdir, dir: string;
begin
    rootdir := extractfiledrive(application.ExeName) + '\';
    if SelectDirectory(dir, [sdAllowCreate, sdPerformCreate, sdPrompt], 0) then
        Label1.Caption := dir;
    datadir.Text := dir;
    DataDirName := dir;
end;

procedure TMainForm.btn2Click(Sender: TObject);
begin
  Screen.Cursor := crHourGlass;
    if not SetRegionBorder(0) then begin
        showmessage('Не удается установить начальный уровень = ' + IntToStr(border_low));
    end;
  Screen.Cursor := crDefault;

end;

procedure TMainForm.dbgrd1CellClick(Column: TColumn);
begin
if trim( dbgrd1.Fields[0].AsString) <> '' then
 bottomspn.Text := dbgrd1.Fields[0].AsString;
if trim( dbgrd1.Fields[1].AsString) <> '' then
 topspn.Text := dbgrd1.Fields[1].AsString;
if trim( dbgrd1.Fields[2].AsString) <> '' then
 expspn.Text := dbgrd1.Fields[2].AsString;
if trim( dbgrd1.Fields[3].AsString) <> '' then
 deadspn.Text := dbgrd1.Fields[3].AsString;
if trim( dbgrd1.Fields[4].AsString) <> '' then
 stepspn.Text := dbgrd1.Fields[4].AsString;
end;
procedure TMainForm.SpectrumChartClickSeries(Sender: TCustomChart;
  Series: TChartSeries; ValueIndex: Integer; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
//   SpectrumChart.Title.Text[0] := 'Spectrum.     Selected: '+SelectedPoint.Caption;
end;

procedure TMainForm.CountPerVSeriesClickPointer(Sender: TCustomSeries;
  ValueIndex, X, Y: Integer);
begin
   selPointCur.Caption := 'V: '+CountPerVseries.XValueToText(CountPerVseries.XValues.Value[ValueIndex])+'v  Counter: '+
   CountPerVseries.YValueToText(CountPerVseries.YValues.Value[ValueIndex]);

end;

procedure TMainForm.psFullspClickPointer(Sender: TCustomSeries; ValueIndex,
  X, Y: Integer);
begin
   selPointSum.Caption := 'V: '+psFullsp.XValueToText(psFullsp.XValues.Value[ValueIndex])+'v  Counter: '+
   psFullsp.YValueToText(psFullsp.YValues.Value[ValueIndex]);

end;

procedure TMainForm.SpeedButton2Click(Sender: TObject);
var
 ctrl1 : integer;
 s1,url:string;
 rstart, rend,mult :integer;
 hist : array[0..100] of double;
begin
mult := 1000;
rstart := 0; rend := 1043960;
ch1Voltseries.Clear;
      HTTP := THTTPSend.Create;
      curcontrol := rstart;
      s1 := format('%d', [curcontrol]);
      s1 := ansiReplaceStr(s1, ',', '.');
      url := lowurl+'setabs=' + s1;
      HTTP.HTTPMethod('GET', url);
      http.Free;
      http := nil;
      delay(5000);

//    for ctrl1 :=310000 div mult to 670000 div mult  do  begin
    for ctrl1 :=rstart div mult to rend div mult  do  begin
      HTTP := THTTPSend.Create;
      curcontrol := ctrl1*mult;
      s1 := format('%d', [curControl]);
      s1 := ansiReplaceStr(s1, ',', '.');
      url := lowurl+'setabs=' + s1;
      HTTP.HTTPMethod('GET', url);
      http.Free;
      http := nil;
      delay(1000);
       writetimelog(DataDirName + 'testadc.dat', IntToStr(CurControl)+' '+format('%.9f',[CurVoltage])+#10);
       ch1VoltSeries.AddXY( CurControl,CurVoltage);

 end;

end;

procedure TMainForm.SeLowVoltagebtnClick(Sender: TObject);
var
  i1,i2,i3 : integer;
  sum, sumx2 :double;
  std,mean,tmp :double;
 ctrl1 : integer;
 str1,s1,url:string;
 rstart, rend,mult :integer;
 hist : array[0..100] of double;
 targetV : double;
 delta : double;
 mnum : int64;
begin
  if TSpeedButton(sender).Caption = 'Stop' then begin
       TSpeedButton(sender).Caption := 'Set Voltage';
       exit;
  end;
    PageControl2.ActivePageIndex := 0;
      delay(1000);
mult := 1000;
rstart := 0; rend := 1043960;
      ch1Voltseries.Clear;
      meanVoltageSeries.clear;
      STDVoltageSeries.Clear;
      ch1StdSeries.Clear;
      HTTP := THTTPSend.Create;
      targetV := strToFloat(TargetVEdt.Text);
      if targetv>0 then targetV:=-targetV;
      curcontrol := trunc(-volt_cost*targetV);
      s1 := format('%d', [curcontrol]);
      s1 := ansiReplaceStr(s1, ',', '.');
      url := lowurl+'setabs=' + s1;
      HTTP.HTTPMethod('GET', url);
      http.Free;
      http := nil;
      delay(2000);
   for i3:=0 to  30 do   begin
      if (ch1Voltseries.Count mod 12)=10 then  begin
        sum :=0;
        sumx2 :=0;
        for i1 := ch1Voltseries.Count-10 to  ch1Voltseries.Count-1 do begin
             sum:=sum+ch1Voltseries.YValues[i1];
             sumx2 := sumx2+ch1Voltseries.YValues[i1]*ch1Voltseries.YValues[i1];
        end;
        mean := sum/10;
        std := sqrt(sumx2/10-mean*mean);
        ch1StdSeries.AddXY(ch1Voltseries.Count ,std);
        delta := (-targetV-mean);
        curcontrol := curcontrol +trunc(delta*volt_cost);
        HTTP := THTTPSend.Create;
        s1 := format('%d', [curControl]);
        s1 := ansiReplaceStr(s1, ',', '.');
        url := lowurl+'setabs=' + s1;
        HTTP.HTTPMethod('GET', url);
        http.Free;
        http := nil;
       end;
        delay(550);
       ch1VoltSeries.AddXY(ch1VoltSeries.Count ,-CurVoltage);
     end;



      ch1Voltseries.Clear;
      ch1StdSeries.Clear;


     mnum :=0;
     TSpeedButton(sender).Caption := 'Stop';
    while (TSpeedButton(sender).Caption = 'Stop') do  begin
      while ch1Voltseries.Count>900 do ch1Voltseries.delete(0);
      while ch1StdSeries.Count>90 do ch1StdSeries.delete(0);
      inc(mnum);
      str1 :='';
      if (mnum >6) and  ((mnum mod 3)=2) then  begin
        sum :=0;
        sumx2 :=0;
        for i1 := ch1Voltseries.Count-5 to  ch1Voltseries.Count-1 do begin
             sum:=sum+ch1Voltseries.YValues[i1];
             sumx2 := sumx2+ch1Voltseries.YValues[i1]*ch1Voltseries.YValues[i1];
             str1:= str1+format('%.5f ',[ch1Voltseries.YValues[i1]]);
        end;
        mean := sum/5;
        str1:= str1+format('%.5f %.5f %.5f ',[mean*mean,sumx2,sumx2/5-mean*mean]);
       writetimelog(DataDirName + 'testadc.dat', str1);
         tmp :=sumx2/5-mean*mean+0.0000000001;
        std := sqrt(tmp);
        ch1StdSeries.AddXY(mnum ,std);
        delta := (-targetV-mean);
        curcontrol := curcontrol +trunc(delta*volt_cost);
        HTTP := THTTPSend.Create;
        s1 := format('%d', [curControl]);
        s1 := ansiReplaceStr(s1, ',', '.');
        url := lowurl+'setabs=' + s1;
        HTTP.HTTPMethod('GET', url);
        http.Free;
        http := nil;
      end;
      if (mnum  mod 21)=20 then  begin
        meanVoltageSeries.addxy(now,mean);
        STDVoltageSeries.addxy(now,std);
      end;
        delay(400);
       writetimelog(DataDirName + 'testadc.dat', IntToStr(CurControl)+' '+format('%.9f',[CurVoltage]));
       ch1VoltSeries.AddXY(mnum ,-CurVoltage);
//       ch1VoltSeries.AddXY(mnum ,-111.00200000);
   end;
  TSpeedButton(sender).Caption := 'Set Voltage';

end;

Initialization
   SpectreList := tstringlist.Create;

end.

