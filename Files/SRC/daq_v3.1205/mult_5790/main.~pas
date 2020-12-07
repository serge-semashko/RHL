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
    url_rasp_agilent58a = 'http://192.168.0.10:8282/setabs=';
    url_rasp_wavetek271 = 'http://192.168.0.12:8282/setabs=';
type
    TDAQ_1271 = class(TThread)
        procedure execute; override;
    end;
    TDAQ_58a = class(TThread)
        procedure execute; override;
    end;
    TDAQ_all = class(TThread)
        procedure execute; override;
    end;


    TMainForm = class(TForm  )
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
    cmbGPIB1271: TComboBox;
    cmbInst1271: TComboBox;
        seSweepCount: TSpinEdit;
        rgSweepMode: TRadioGroup;
        Label2: TLabel;
        Label3: TLabel;
        Label4: TLabel;
        DataDir: TLabeledEdit;
        SpeedButton1: TSpeedButton;
        OpenDialog1: TOpenDialog;
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
    Label7: TLabel;
    cmbGPIB58: TComboBox;
    Label8: TLabel;
    cmbInst58: TComboBox;
    SpeedButton2: TSpeedButton;
    ControlGRP: TRadioGroup;
    memoread: TMemo;
    set1271edit: TEdit;
    set58aedit: TEdit;
    set1271btn: TSpeedButton;
    set58abtn: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
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
        procedure cmbGPIB_agilentChange(Sender: TObject);
        procedure cmbInst1271Change(Sender: TObject);
        procedure SpeedButton1Click(Sender: TObject);
    procedure down58a(Sender: TObject);
    procedure dbgrd1CellClick(Column: TColumn);
    procedure SpectrumChartClickSeries(Sender: TCustomChart;
      Series: TChartSeries; ValueIndex: Integer; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure CountPerVSeriesClickPointer(Sender: TCustomSeries;
      ValueIndex, X, Y: Integer);
    procedure psFullspClickPointer(Sender: TCustomSeries; ValueIndex, X,
      Y: Integer);
    procedure ControlGRPClick(Sender: TObject);
    procedure down1271(Sender: TObject);
    procedure set1271btnClick(Sender: TObject);
    procedure set58abtnClick(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    private
    { Private declarations }
    public
        function SetRegionBorder(target: double): boolean;
        function SetVoltage(target: double): boolean;
        function CorrectVoltage(target: double): boolean;
        function CorrectVoltage58a(target: double): boolean;
        function CorrectVoltage1271(target: double): boolean;
        function delay(ms: integer): integer;
        function InitCounter: integer;
        function InitGPIB1271: integer;
        function InitGPIB_agilent: integer;
        procedure CreatedataFileName;
    { Public declarations }
    end;

    Vrecord = record
        time: double;
        data: double;
        data58a: double;
        data1271: double;
        counter: int64;
    end;

    Varray = array of vrecord;
     function get_WAVETEK_data:boolean;
        function get_agilent_data:boolean;

function exec488(dev488:integer;cmd:string):boolean;

var
    setup1271, setup58a : double;
    mult_cntl :double = 0;
    rasp_url :string = '';
    selected_control : integer = -1;
    Counter_per_sec : double = 0;
    newTarget, curTarget: double;
    SweepStartTime: double;
    MeasuringStartTime: Double;
    headerstr: string;
    daq_counter: int64 = 0;
    CorrectionTime: double;
    daq_mode: integer = 0;
    GPIB_1271_Ready: Boolean = false;
    GPIB_agilent_Ready: Boolean = false;
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
    Daq_all: Tdaq_all;
    Daq_58a: Tdaq_58a;
    Daq_1271: Tdaq_1271;
    CurVoltage: double;
    CurControl: int64 = 0;
    CurControl58a: int64 = 0;
    CurControl1271: int64 = 0;
    oldControl: int64 = 0;
    oldControl1271: int64 = 0;
    oldControl58a: int64 = 0;

    MainForm: TMainForm;
    VoltageChangeTime: double;
    TimerID: dword;

  (*488.2 GPIB global status variables.*)
    Vdata: array[0..10000000] of vrecord;
    PrevVindex, Vindex: integer;
    dacval: double;
    dacval1271: double;
    dacval58: double;
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
    dev1271 : integer;
    dev58a: integer;
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
    math, logging, SetMinMax, das_const, i7000, i7000u, dcon_pc, trends;
{$R *.DFM}

function delay(ms: integer): integer;
var
    st: double;
begin
    st := now;
    while (now - st) * 24 * 3600 * 1000 < ms do
        application.ProcessMessages;
end;

//function V_Convert(v_cur: double): dword;
//begin
//    if selected_control = 0
//       then   result:=round(v_cur*10000*20.98843441466855)
//       else      result:=abs(round(v_cur*1043));
//    result := trunc(1048576.0 * (v_cur) / 5);
//end;


function V_Convert_58a(v_cur: double): dword;
begin
if v_cur<0.000001 then v_cur:=0;
result:=round(v_cur*10000*20.98843441466855)
end;
function V_Convert_1271(v_cur: double): dword;
begin
if v_cur<0.000001 then v_cur:=0;
result:=abs(round(v_cur*1043));
end;

function V_revert(d_cur: dword): double;
begin
    result := d_cur/20.98843441466855;
end;
function exec488(dev488:integer;cmd:string):boolean;

var

 wrtbuf : array[0..1000] of char;
 rdbuf : array[0..1000] of char;
 st : double;
  begin
    st := now;
    strcopy(wrtbuf, pchar(cmd));
    //Write a string command to a GPIB instrument asynchronously using the ibwrta() command
    ibwrt(dev488, @wrtbuf, strlen(wrtbuf));
    gpib_get_globals(@ibsta, @iberr, @ibcnt, @ibcntl);
    result := true;
    if (ibsta and $8000)<>0
        then result := false
end;

function setdPotential(var curControl:int64): string;
var
    s1, url: string;
begin
if curControl>40000 then begin
    //  exit;    

end;
    if rasp_url = '' then begin
      showmessage('не установлен управляющий аольтметр');
      halt;
    end;
    if (curControl > $FFFFF) then curControl := $FFFFF;
    if selected_control = 0 then begin
        curControl58a := curControl;
        if abs(oldControl58a - curControl58a) > (0.01 * $FFFFF / 5) then
            curcontrol58a := oldcontrol58a + trunc((0.01 * $FFFFF / 5) * (curControl58a - oldcontrol58a) / abs(oldControl58a - curControl58a));
        oldControl58a := CurControl58a;
    end;
    if selected_control = 1 then begin
        curControl1271 := curControl;
        if abs(oldControl1271 - curControl1271) > (0.1 * $FFFFF ) then
            curcontrol1271 := oldcontrol1271 + trunc((0.1 * $FFFFF) * (curControl1271 - oldcontrol1271) / abs(oldControl1271 - curControl1271));
        if curControl1271 < 0 then
            curcontrol1271 := 0;
        oldControl1271 := CurControl1271;
    end;
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
    url := rasp_url + s1;
    HTTP.HTTPMethod('GET', url);
    http.Free;
    http := nil;
end;

function tmainform.CorrectVoltage(target: double): boolean;
var
    tarcontrol: int64;
    startsetTime: double;
    r1: double ;
begin
   if (now - PrevMTime)*24*2600 >1 then begin
     exit;
   end;
   case selected_control of
     0: CorrectVoltage58a(target);
     1: CorrectVoltage1271(target);
   end;
   exit;

//    if selected_control = 0 then begin
//        r1 :=CurVoltage * 10000;
//        curControl := curControl + round((target * 1.0 - r1) * 26.98843441466855);
//    end else begin
//        r1 :=CurVoltage ;
//        curControl := curControl + round((target * 1.0 - r1) * 1050);
//    end;
//    setDPotential(curControl);

end;
//function CorrectVoltageM(target: double): boolean;
//var
//    tarcontrol: int64;
//    startsetTime: double;
//begin
//   if (now - PrevMTime)*24*2600 >1 then begin
//     exit;
//   end;
//    curControl := curControl + round((target * 1.0 - CurVoltage * 10000) * 20.98843441466855);
//    setDPotential(curControl);
//end;

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
    delay(1200);
    diff := mean3Voltage * mult_cntl;
    diff := target * 1.0 - mean3Voltage * mult_cntl;
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
    if selected_control = 0 then mult_cntl := 10000 else mult_cntl := 1;

    while (abs((target * 1.0 - curVoltage * mult_cntl)) > 100) and ((now - startsetTime) * 24 * 3600 < 500) do begin
        correctVoltage(target);
        delay(3000);
        Vdiff := abs((target * 1.0 - curVoltage * mult_cntl));
    end;
    if (selected_control = 0) and (target <200) and (meanVoltage*mult_cntl<200) then begin
      Result := True;
      Exit;
    end;
    while (abs((target * 1.0 - curVoltage * mult_cntl)) > 1) and ((now - startsetTime) * 24 * 3600 < 120) do begin
        correctVoltage(target);
        delay(3000);
        Vdiff := abs((target * 1.0 - curVoltage * mult_cntl));
    end;

    if (target * 1.0 - curVoltage * mult_cntl) > 1 then begin
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
//
//  ## ##         ###          ## ##
//  ##   ##      ## ##        ##   ##
//  ##   ##     #######       ##   ##
//  ##   ##    #########      ##   ##
//  ##   ##   ##       ##     ##  ###
//  ## ##    ##         ##     ## ###
//                                  ##
function DaqGetCounter: boolean;
var
    delta: real;
    wrtbuf, rdbuf: packed array[0..299] of char;
    rdstr: string;
    dtc :double;
    resstr : string;

begin
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
                if GettingData
                    then
                    else if counter_ready then begin
                        wRet := DCON_Clear_Counter(gcPort, StrToInt('$' + mainform.Address.Text), -1, StrToInt('$' + mainform.edCh.Text), 0, 200);
                        LastCounterValue := 0;
                    end;
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

end;

function DaqGetdata58: boolean;
var
    delta: real;
    wrtbuf, rdbuf: packed array[0..10299] of char;
    rdstr: string;
    dtc :double;
    resstr : string;
    i1,i2,i3, resc : integer;
begin
    curmtime := now;
    writeProtocol('1 #################### DAQ58 start ##################### ' + IntToStr(vindex));
    try

        curtime := now();
        writeprotocol('2 dstimer callback=' + format('%15.13f', [(Curtime - PrevTime) * 24 * 3600 * 1000]));
        curmtime := now;
//        writeprotocol('3 begin1 dttimer callback=');
//   mainform.Caption:=IntToStr(CurMtime-PrevMTime);

        curmtime := now;
        exec488(dev58a,'TARM SGL');
        ibrd(dev58a, @rdbuf, 17);
        gpib_get_globals(@ibsta, @iberr, @ibcnt, @ibcntl);
        if (ibsta and $8000)<>0
          then dacval58 := -1
          else begin
            rdbuf[ibcnt] := chr(0);
            resstr := rdbuf;
            resstr := system.copy(resstr,1,length(resstr)-1);
            decimalseparator := '.';
            val(resstr,dacval58,i1);
            if dacval58<0.0000001 then dacval58 := 0;
            if i1<>0  then dacval58 := -1;
          end;

        curmtime := now;


        if (dacval58 < 0) then begin
            PrevMTime := now;
            PrevTime := now;
            writeProtocol('Error read AGILENT ' + rdstr + #10);
            resstr :='AGILENT error';
        end;
//        writeprotocol('24');
//        resstr := resstr + ' ' + format(' %.4d %.6d %.1d %.8d %.8d %.3d', [cntval, curControl, dstep, vindex + 1, stepStartIndex, deltaCounterValue]) + ' ' + intToStr(trunc((timegettime - prevMtime))) + ' ' + StringReplace(floattostr(now), ',', '.', [rfReplaceAll, rfIgnoreCase]);
//        writeprotocol('14');
        prevread := now();
//        writeprotocol('rdstr: ' + rdstr);
//      CurVoltage := dacval58;

    except
        on E: Exception do begin
            writeprotocol('%%%%%%%%%%%%%%%%% Exceprton on read counter:' + E.Message);
            mainform.Caption := 'exception!!!!!!!!!!!!!!!!!!!';
        end;

    end;

    writeProtocol('26 #######D AQ end ' + IntToStr(vindex));

    PrevMTime :=   now;
    PrevTime := now;
end;


function DaqGetdata1271: boolean;
var
    delta: real;
    wrtbuf, rdbuf: packed array[0..10299] of char;
    rdstr: string;
    dtc :double;
    resc : integer;
begin
    curmtime := now;
    writeProtocol('1 #################### DAQ start ##################### ' + IntToStr(vindex));
    try

        curtime := now();
//        writeprotocol('2 dstimer callback=' + format('%15.13f', [(Curtime - PrevTime) * 24 * 3600 * 1000]));
        curmtime := now;
        writeprotocol('3 begin1 dttimer callback=');

        curmtime := timegettime();
//        writeprotocol('counter ok = ' + IntToStr(cntval));

        strcopy(wrtbuf, pchar('X?'));
//        WriteProtocol('4 ibwrta Write a string command to a GPIB instrument asynchronously using the ibwrta() command');
        ibwrta(dev1271, @wrtbuf, strlen(wrtbuf));
//        WriteProtocol('5 get globals');

        gpib_get_globals(@ibsta, @iberr, @ibcnt, @ibcntl);
        if (ibsta and ERR) <> 0 then begin
            writeprotocol('6 Err: Error in writing the string command to the GPIB instrument.');
            opError := true;
            exit;
        end;
        ibwait(dev1271, CMPL);

        curmtime := now();

        gpib_get_globals(@ibsta, @iberr, @ibcnt, @ibcntl);
        if (ibsta and ERR) <> 0 then begin
            writeprotocol('11 Err: Writing the string command to the GPIB instrument timeout.');
            opError := true;
            exit;
        end;
        writeprotocol('12 Answer ok from the GPIB instrument ok. ibcnt = ' + IntToStr(ibcnt));

        ibrda(dev1271, @rdbuf, 100);
        gpib_get_globals(@ibsta, @iberr, @ibcnt, @ibcntl);
        if (ibsta and ERR) <> 0 then begin
            writeprotocol('16 Err: Error in reading the response string from the GPIB instrument.');
            opError := true;
            exit;
        end;
//        WriteProtocol('18 Wait for the completion of asynchronous read operation');
        ibwait(dev1271, CMPL);
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
//        writeprotocol('22 Answer ok from the GPIB instrument ok. ibcnt = ' + IntToStr(ibcnt) + ' str=' + rdstr);

//        if PrevVoltage = rdstr then exit; //У АЦП нет новых данных
        PrevVoltage := rdstr;
        rdstr := system.copy(rdstr, 1, pos(' ', rdstr) - 1);
        val(rdstr, dacval1271, resc);
        dacval1271 := abs(dacval1271);

        if  pos('.', rdstr) = 0  then begin
            dacval1271 := -131313;
            writeProtocol('23 ####ZERO ' + rdstr + #10);
            exit;

        end;
//        writeprotocol('24');
//        rdstr := rdstr + ' ' + format(' %.4d %.6d %.1d %.8d %.8d %.3d', [cntval, curControl, dstep, vindex + 1, stepStartIndex, deltaCounterValue]) + ' ' + intToStr(trunc((now - prevMtime))) + ' ' + StringReplace(floattostr(now), ',', '.', [rfReplaceAll, rfIgnoreCase]);
//        writeprotocol('14');
        prevread := now();
//        writeprotocol('rdstr: ' + rdstr);


    except
        on E: Exception do begin
            writeprotocol('%%%%%%%%%%%%%%%%% Exceprton on read counter:' + E.Message);
            mainform.Caption := 'exception!!!!!!!!!!!!!!!!!!!';
        end;

    end;

    writeProtocol('26 #######D AQ end ' + IntToStr(vindex));

end;


procedure TMainForm.FormCreate(Sender: TObject);
var
    i: int64;
begin
    deadspn.Value := 5;
    address.Value := cf.readInteger('hardware', 'counter_addr', 0);
    ControlGRP.ItemIndex := cf.readInteger('hardware', 'selected-control', 0);
    ControlGRPClick(self);
    ComComboBox.ItemIndex := cf.readInteger('hardware', 'counter_port', 0);
    edch.Value := cf.readInteger('hardware', 'counter_channel', 0);
    cmbGPIB1271.ItemIndex := cf.readInteger('instrument', 'gpib_1271', 0);
    cmbInst1271.ItemIndex := cf.readInteger('instrument', 'mult_1271', 0);
    cmbGPIB58.ItemIndex   := cf.readInteger('instrument', 'gpib_58', 0);
    cmbInst58.ItemIndex   := cf.readInteger('instrument', 'mult_58', 0);

    //edch.Value := cf.readInteger('instrument', 'counter_channel', 0)-1;
    //edch.Value := cf.readInteger('instrument', 'counter_channel', 0)-1;
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
    memoRead.Text := '';
    gcDataBit := Char(8);      // 8 data bit
    gcParity := Char(0);      // Non Parity
    gcStopBit := Char(0);      // One Stop Bit
    bCOMOpen := False;
    bCfgChg := False;
    gszSend := StrAlloc(100);
    gszReceive := StrAlloc(100);
    LastCounterTime := now;
    InitCounter;
    InitGPIB1271;
    InitGPIB_agilent;

    con2.Connect;
    zqry1.Open;

    GettingData := false;
    prevread := now();
{
    Daq_1271 := Tdaq_1271.Create(true);
    daq_1271.Priority := tphighest;
    gpib_1271_ready := true;
    daq_1271.Resume;

    Daq_58a := Tdaq_58a.Create(true);
    daq_58a.Priority := tphigher;
    daq_58a.Priority := tphighest;
    gpib_agilent_ready := true;
    daq_58a.Resume;
}
    Daq_all := Tdaq_all.Create(true);
    daq_all.Priority := tphigher;
    daq_all.Priority := tphighest;
    daq_all.Resume;



    delay(2000);

    curControl58a := v_convert_58a(dacval58);
    curControl1271 := v_convert_1271(dacval1271);
    oldControl58a := curControl58a;
    oldControl1271 := curControl1271;
    StartCycle.Enabled := true;
    controlGrp.Enabled := Startcycle.Enabled;


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
                        dstep := -1;
                        curTarget := zqry1.FieldValues['Uend'];
                        Sweep := Sweep + 1;
                        exit;

                    end
                    else begin
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
delta, tmp1, tmp_t :double;
begin
 if (zqry1.RecordCount <1) then begin
   showmessage('No measurung range');
   exit;
 end;
    TabSheet1.SetFocus;
    PageControl2.ActivePageIndex := 0;
    delay(100);
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
    controlGrp.Enabled := false;
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
         (-zqry1.FieldByName('Ubeg').AsInteger + zqry1.FieldByName('Uend').AsInteger) * 1000  div zqry1.FieldByName('Ustep').AsInteger
         );
        headerstr := headerstr + format('Region %d: Ubeg(V)= %d, Uend(V)= %d, Ustep(V)= %.1f, Exposition(s)= %d, Dead(s)= %d, Channels= %d  ',
             [zqry1.RecNo, zqry1.FieldByName('Ubeg').AsInteger, zqry1.FieldByName('Uend').AsInteger, zqry1.FieldByName('Ustep').AsInteger / 1000.0,
              zqry1.FieldByName('exposition').AsInteger, zqry1.FieldByName('dead_time').AsInteger,
              1+(-zqry1.FieldByName('Ubeg').AsInteger + zqry1.FieldByName('Uend').AsInteger) * 1000  div zqry1.FieldByName('Ustep').AsInteger ]) + #10;
        zqry1.Next;
    end;
    Sweep_duration := Sweep_duration /(24*3600);
    headerstr := headerstr +'Constant voltage(V)= '+ConstVolt.Text+#10;
    WriteLog(DataFileName + '.txt', headerstr + #10);
    WriteLog(DataFileName + '.txt', descmemo.Text+#10);


    zqry1.MoveBy(-zqry1.RecNo);
    setrangeparams;
    memoread.Lines.Add('Set (1)');

    if not SetRegionBorder(border_low) then begin
        showmessage('(1) Не удается установить начальный уровень = ' + IntToStr(border_low));

        Startcycle.Enabled := true;
        controlGrp.Enabled := Startcycle.Enabled;
        Startcycle.Caption := 'Start measurement';
        Screen.Cursor := crDefault;
        exit;
    end;
    memoread.Lines.Add('correct (2)');

    for I1 := 0 to 10 do begin
       delay(1500);
       correctVoltage(border_low);
    end;

    memoread.Lines.Add('correct (3)');
    for I1 := 0 to 10 do begin
        if SetVoltage(border_low) then
            break;
        if I1 = 10 then begin
            showmessage('(3) Не удается установить начальный уровень = ' + IntToStr(border_low));
            Startcycle.Enabled := true;
            controlGrp.Enabled := Startcycle.Enabled;
            Screen.Cursor := crDefault;
            Startcycle.Caption := 'Start measurement';
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
    Prevmtime := now();
    start_step := now;
    dstep := 1;
    CorrectionTime := now;
    curTarget := Border_low;
    Startcycle.Caption := 'Stop measurement';


    SetEnablingControl;
    MeasuringStartTime := Now;
    start_step := now;

    BeginSweep;
    countPerVSeries.AddXy(Border_low-0.1, 0);
    countPerVSeries.AddXy(Border_High+0.1, 0);

    for i1 := 1 to 100000 do application.ProcessMessages;

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
    controlGrp.Enabled := Startcycle.Enabled;
    Screen.Cursor := crDefault;
    dstep := 1;
    GettingData := true;
    while (Startcycle.Caption = 'Stop measurement') do begin
        mainform.Caption := IntToStr(cntval);

        while ch1StdSeries.Count > 6230 do
            ch1StdSeries.Delete(0);
        while ch1VoltSeries.Count > 6230 do
            ch1VoltSeries.Delete(0);
        while ch1MeanSeries.Count > 6230 do
            ch1MeanSeries.Delete(0);
        while MEANvOLTAGEseries.Count > 65300 do
            MEANvOLTAGEseries.Delete(0);
        while STDvOLTAGEseries.Count > 65300 do
            STDvOLTAGEseries.Delete(0);
        while Counterseries.Count > 5300 do
            Counterseries.Delete(0);


        if prevGrIndex = vindex + 1 then
            continue;

        for il1 := prevGrIndex to vindex do begin
            if selected_control = 0
                then      tmp1 := vdata[il1].data*mult_cntl
                else      tmp1 := vdata[il1].data;
            tmp_t := vdata[il1].time;
            writetimelog( format('================== %f %f ',[vdata[il1].time, vdata[il1].data])+#13);

            ch1VoltSeries.AddXY(tmp_t, tmp1);
            writetimelog( '=============ok==== '+#13);
        end;

        for il1 := prevGrIndex to vindex do begin
            if selected_control = 0
                then             tmp1 :=vdata[il1].data*mult_cntl
                else             tmp1 :=vdata[il1].data
        end;
        prevGrIndex := vindex + 1;

        if (now - start_step) * 24 * 3600 > step_len then begin
            start_dead := now;

            GettingData := false;
//       while (now-start_Step)*24*3600<0.4 do application.processmessages;

            CounterStep := vdata[vindex].counter;
            dt := (now() - lastCounterTime) * 24 * 3600;
            CalcStdAndMean(Vindex, vindex - StepStartIndex); // vIndex-PrevVindex);
            if selected_control = 0 then begin
                ch1MeanSeries.AddXY(now, mean*mult_cntl);
                ch1stdSeries.AddXY(now, std*mult_cntl);
            end else begin
                ch1MeanSeries.AddXY(now, mean);
                ch1stdSeries.AddXY(now, std);
            end;

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
            writetimelog(DataFileName + '.dat', Stepstr);
            memoread.lines[0] := (DateToStr(now) + ' ' + TimeToStr(now) + '  ' + 'Read ok = ' + rdstr);
    //   writetimelog(rdstr+#10);
            LastCounterTime := now;

            StepStartIndex := vindex + 1;
            tmpstr := format('finish %.2f  %.2f  %.2f   %.2f %.2f', [curTarget * 1.0, meanVoltage * mult_cntl, mean3Voltage * mult_cntl, dstep * step_Value / 1000.0, border_low * 1.0]);
            writetimelog(DataDirName + 'range.txt', tmpstr);

            newTarget := curTarget + dstep * (step_Value / 1000.0);
            curTarget := newTarget;
            if (curTarget > Border_High) or (curTarget < Border_low) then begin
                OldSweepNumber := Sweep;
                SetNewRegion();
                if (seSweepCount.Value > 0) and (Sweep > seSweepCount.Value) then begin
                    FinishSweep;
                    Writelog(DataFileName + '.txt', tmpstr + #10);
                    tmpstr := 'Current date: ' + FormatDateTime('DD.MM.YYYY', now) + ', Begin time:' + FormatDateTime('HH.NN.SS', MeasuringStartTime) + ', End time:' + FormatDateTime('HH.NN.SS', now);
                    WriteLog(DatafileName+'.txt', tmpstr);
                  break;
                end;
                if OldSweepNumber <> Sweep then begin
                    FinishSweep;
                    BeginSweep;
                    SweepStartTime := now;
                end;
                SetRegionBorder(curTarget);
                for I1 := 0 to 10 do SetVoltage(border_low);
                Start_dead := now;
                while (now - start_dead) * 24 * 3600 < dead_Value * 2 do begin
                    setVoltage(curTarget);
                end;
            end
            else begin
                writetimelog(format('beg Step Mean3= %.2f cur= %.2f Target= %.2f',[curVoltage*mult_cntl, mean3Voltage*mult_cntl, curTarget])+#10);
                setVoltage(curTarget);
                delay(2000);
                while (now - start_dead) * 24 * 3600 < dead_Value-2 do begin
                    writetimelog(IntToStr( trunc((now - start_dead) * 24 * 3600 ) )+format(' Set Step Mean3= %.2f cur= %.2f Target= %.2f',[curVoltage*mult_cntl, mean3Voltage*mult_cntl, curTarget])+#10);
                    setVoltage(curTarget);

                end;
                while (now - start_dead) * 24 * 3600 < dead_Value -0.3 do begin
                    writetimelog(format('wait Step Mean3= %.2f cur= %.2f Target= %.2f',[curVoltage*mult_cntl, mean3Voltage*mult_cntl, curTarget])+#10);

                    delay(300);
                end;
            end;
            tmpstr := format('start target = %.2f  mean =(%.2f  %.2f  %.2f)   %.2f %.2f', [curTarget * 1.0, CurVoltage * mult_cntl, meanVoltage * mult_cntl, mean3Voltage * mult_cntl, dstep * step_Value / 1000.0, border_low * 1.0]);
            writetimelog(DataDirName + 'range.txt', tmpstr);
            GettingData := true;
            correctionTime := now;
            start_step := now;
        end
        else if (now - CorrectionTime) * 24 * 3600 > 2 then begin
            CorrectVoltage(curTarget);
            correctionTime := now;
        end;
        T1 := now;
        while (now - T1) * 24 * 3600 < 1 do begin
            application.ProcessMessages;
            sleep(100);
        end;

    end;
    GettingData := false;
    StartCycle.Enabled := true;
    controlGrp.Enabled := Startcycle.Enabled;
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

    if (not GPIB_1271_Ready) then begin
        showmessage('GPIB(цифровой вольметр WAVETEK1271 )недоступен');
//        close;
//        application.terminate;
    end;
    if (not GPIB_agilent_Ready) then begin
        showmessage('GPIB(цифровой вольметр AGILENT )недоступен');
//        close;
//        application.terminate;
    end;
    statusbar1.Font.Size := 12;
        CreateDataFileName;


end;

procedure TMainForm.Chart1DblClick(Sender: TObject);
begin
// SetMinMaxForm.SetLimits(TChart(sende
//    while (now() - PrevMtime) < 500 do
//        application.ProcessMessages;
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

function TMainForm.InitGPIB1271: integer;
var
    errmess: string;
    t1: double;
    wrtbuf: array[0..2000] of char;
begin
    gpib_1271_ready := false;
    dev1271 := ibdev(cmbGPIB1271.ItemIndex, cmbInst1271.ItemIndex , 0, T1s, 1, 0);
    gpib_get_globals(@ibsta, @iberr, @ibcnt, @ibcntl);
    if (ibsta and ERR) <> 0 then begin
        errmess := GpibError(iberr);
        memoread.lines[0] := (DateToStr(now) + ' ' + TimeToStr(now) + '  ' + 'Err: Error in init the GPIB device.' + errmess + #10);
        showmessage('Err: Error in init the GPIB device.');
        exit;

    end;

  //Open and intialize an GPIB instrument
    OpError := false;
    // process error  in prev operation
    if opError then begin
        t1 := NOW;
        while (now - t1) * 24 * 3600 < 8 do begin
            application.ProcessMessages;
        end;
    end;

    opError := false;

    //clear the specific GPIB instrument
    ibclr(dev1271);
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
    ibwrta(dev1271, @wrtbuf, strlen(wrtbuf));
    gpib_get_globals(@ibsta, @iberr, @ibcnt, @ibcntl);
    if (ibsta and ERR) <> 0 then begin
        memoread.lines[0] := (DateToStr(now) + ' ' + TimeToStr(now) + '  ' + 'Err: Error in writing *cls command to the GPIB instrument.' + #10);
        writetimelog(DateToStr(now) + ' ' + TimeToStr(now) + '  ' + 'Err: Error in writing *cls command to the GPIB instrument.' + #10);
        showmessage('Err: Error in writing *cls command to the GPIB instrument.');
        exit;
    end;

    //Wait for the completion of asynchronous write operation
    ibwait(dev1271, CMPL);
    gpib_get_globals(@ibsta, @iberr, @ibcnt, @ibcntl);
    if (ibsta and ERR) <> 0 then begin
        memoread.lines[0] := (DateToStr(now) + ' ' + TimeToStr(now) + '  ' + 'Err: Wait for the completion of asynchronous write operation. *cls ' + #10);
        writetimelog(DateToStr(now) + ' ' + TimeToStr(now) + '  ' + 'Err:  Wait for the completion of asynchronous write operation. *cls ' + #10);
        opError := true;
        showmessage('Err: Wait for the completion of asynchronous write operation. *cls ');
        exit;
    end;


//***********finish configure ******************
//**************** Configure  deice 10V resolution 6*****************
    strcopy(wrtbuf, pchar('dcv 1000,resl6'));
    //Write a string command to a GPIB instrument asynchronously using the ibwrta() command
    ibwrta(dev1271, @wrtbuf, strlen(wrtbuf));
    gpib_get_globals(@ibsta, @iberr, @ibcnt, @ibcntl);
    if (ibsta and ERR) <> 0 then begin
        memoread.lines[0] := (DateToStr(now) + ' ' + TimeToStr(now) + '  ' + 'Err: Error in writing the string command to the GPIB instrument.' + #10);
        writetimelog(DateToStr(now) + ' ' + TimeToStr(now) + '  ' + 'Err: Error in writing the string command to the GPIB instrument.' + #10);
        showmessage('Err: Error in writing the string command to the GPIB instrument.');
        exit;
    end;

    //Wait for the completion of asynchronous write operation
    ibwait(dev1271, CMPL);
    gpib_get_globals(@ibsta, @iberr, @ibcnt, @ibcntl);
    if (ibsta and ERR) <> 0 then begin
        memoread.lines[0] := (DateToStr(now) + ' ' + TimeToStr(now) + '  ' + 'Err: Writing the string command to the GPIB instrument timeout.' + #10);
        writetimelog(DateToStr(now) + ' ' + TimeToStr(now) + '  ' + 'Err: Writing the string command to the GPIB instrument timeout.' + #10);
        showmessage('Err: Writing the string command to the GPIB instrument timeout.');
        opError := true;
        exit;
    end;
//***********finished configure ******************
    gpib_1271_ready := true;

end;
function TMainForm.InitCounter: integer;
var
    errmess: string;
    t1: double;
    wrtbuf: array[0..2000] of char;
begin

    if counter_ready then
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

end;

procedure TMainForm.Timer1Timer(Sender: TObject);
var
 dt, dv,wv: double;
begin
        if FormTrends <> nil then begin
            FormTrends.w1271ser.AddXY(now,dacval1271);
            while (FormTrends.w1271ser.Count>800) do FormTrends.w1271ser.Delete(0);

        end;

//     statusbar1.Panels[0].Text := inttostr(curcontrol);
     statusbar1.Panels[0].Text := format('Управление:Wavetek=%d Agilent=%d',[curControl1271,curControl58a]);
        if GPIB_1271_Ready
            then statusbar1.Panels[4].Text := format('Wavetek= %.7f ', [ dacval1271, dacval58])
            else statusbar1.Panels[4].Text := format('Wavetek=NaN', [ dacval1271]);
        if GPIB_agilent_Ready
            then statusbar1.Panels[5].Text := format('Agilent=%.6f', [ dacval58])
            else statusbar1.Panels[5].Text := format('Agilent=NaN', [  dacval58]);
     


     statusbar1.Panels[2].Text := formatDateTime('HH:NN:SS', now);
 if (now - PrevMTime*1.0)*24*3600 >1 then begin
     statusbar1.Panels[1].Text := formatDateTime('Nodata HH:NN:SS', now);
      curU.Text := 'DAQ ERROR!!!';
      curu.Font.Color := clred;
     end
     else begin
        if GettingData then begin
          StatusBar1.Panels[3].Text:='';
          if (Sweep_duration >0) then begin
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
           end;
          Rangelbl.Caption := format('Range %dv - %dv',[border_low,Border_High]);
          steplbl.Caption := format('Declared V.: %.1fv Step:%dmv',[curtarget,step_value]);
          dv := curtarget-Border_low;
          if dstep<0
             then dv := abs(curtarget-Border_high)            
             else dv := abs(curtarget-Border_low);

          wv := abs(Border_High-Border_low);
          if abs(wv)>0.1 then
           RangeGauge.Progress := trunc(dv*1000/(wv));
          dt := (now - start_step)*24*3600;
          if    ((now - start_step)*24*3600>1) and (((now - start_step)*24*3600)<1000000)
             then  stepGauge.Progress := trunc((now - start_step) * 24 * 3600*1000/step_len)
             else   stepGauge.Progress :=0;
          StatusBar1.Panels[3].Text := format('dt=%f dv=%f wv=%f ct=%f bl=%d bh=%d ',[dt,dv,wv, curTarget,Border_low,Border_High]);
        end else begin
        end;
        statusbar1.Panels[1].Text := '';

        curU.Text := format('%.5f ', [ curvoltage*mult_cntl]);
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


procedure TMainForm.pnl3Click(Sender: TObject);
begin
    if (Bottomspn.Value >= Topspn.Value) then begin
        showmessage('Error: Нижняя граница должна быть меньше верхней ');
        exit;
    end;
    if ((Topspn.Value - Bottomspn.Value) * 1000 mod stepspn.Value) <> 0 then begin
        showmessage('Error: Ширина интекрвала не кратна шагу');
        exit;
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

procedure TMainForm.cmbGPIB_agilentChange(Sender: TObject);
begin
    cf.WriteInteger('instrument', 'mult_58', cmbInst58.ItemIndex);
    cf.WriteInteger('instrument', 'gpib_58', cmbgpib58.ItemIndex);
    InitGPIB_agilent;
end;

procedure TMainForm.cmbInst1271Change(Sender: TObject);
begin
    cf.WriteInteger('instrument', 'mult_1271', cmbInst1271.ItemIndex);
    cf.WriteInteger('instrument', 'gpib_1271', cmbgpib1271.ItemIndex);
    InitGPIB1271;

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

procedure TMainForm.down58a(Sender: TObject);
var
old_selected_control: integer;
begin
  old_selected_control := selected_control;
  ControlGRP.Enabled := false;
  Screen.Cursor := crHourGlass;
  selected_control := 0;
  ControlGRP.ItemIndex := selected_control;
  ControlGRPClick(self);
  delay(700);
    if not SetRegionBorder(0) then begin
        showmessage('Не удается установить начальный уровень = ' + IntToStr(border_low));
    end;
  Screen.Cursor := crDefault;
 selected_control := old_selected_control;
 ControlGRP.ItemIndex := selected_control;
 ControlGRPClick(self);
  ControlGRP.Enabled := true;

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

Function TMainForm.InitGPIB_agilent;
var
    wrtbuf : array[0..1000] of char;
    errmess: string;
    t1: double;
    ibnum, devnum, i1 : integer;
begin
    gpib_agilent_ready := false;
    StartCycle.Enabled := false;
    controlGrp.Enabled := Startcycle.Enabled;
    memoread.lines.Add('');
    dev58a := ibdev(cmbGPIB58.ItemIndex, cmbInst58.ItemIndex , 0, T1s, 1, 0);
    gpib_get_globals(@ibsta, @iberr, @ibcnt, @ibcntl);
    if (ibsta and ERR) <> 0 then begin
        errmess := GpibError(iberr);
        memoread.lines[0] := (DateToStr(now) + ' ' + TimeToStr(now) + '  ' + 'Err: Error in init the GPIB device.' + errmess + #10);
        showmessage('Err: Error in init the GPIB device.');
        exit;
    end;

    ibclr(dev58a);
    gpib_get_globals(@ibsta, @iberr, @ibcnt, @ibcntl);

    if not exec488(dev58a,'PRESET NORM') then begin
        errmess := GpibError(iberr);
        memoread.lines[0] := (DateToStr(now) + ' ' + TimeToStr(now) + '  ' + 'Err: Error in init the GPIB device.' + errmess + #10);
        showmessage('Err: Error in init the GPIB device.');
        exit;
    end;;
    exec488(dev58a,'TARM HOLD');
    exec488(dev58a,'MEM LIFO');
    exec488(dev58a,'DCV 10, 1E-10');
    exec488(dev58a,'aper.1');
   gpib_agilent_ready := true;

//***********finished configure ******************
end;

function get_agilent_data: boolean;
begin

end;

function get_WAVETEK_data: boolean;
begin

end;

procedure TMainForm.ControlGRPClick(Sender: TObject);
begin
  cf.writeInteger('hardware', 'selected-control', ControlGRP.ItemIndex);
 selected_control := ControlGRP.ItemIndex;
 case ControlGRP.ItemIndex of
    0:begin
        rasp_url := url_rasp_agilent58a;
        mult_cntl := 10000
      end;
    1:begin
        rasp_url := url_rasp_wavetek271;
        mult_cntl := 1;
      end;
    else rasp_url:='';
 end;

end;

procedure TMainForm.down1271(Sender: TObject);
var
old_selected_control: integer;
begin
  old_selected_control := selected_control;
  ControlGRP.Enabled := false;
  Screen.Cursor := crHourGlass;
  selected_control := 1;
  ControlGRP.ItemIndex := selected_control;
  ControlGRPClick(self);
  delay(700);
    if not SetRegionBorder(0) then begin
        showmessage('Не удается установить начальный уровень = ' + IntToStr(border_low));
    end;
  Screen.Cursor := crDefault;
 selected_control := old_selected_control;
 ControlGRP.ItemIndex := selected_control;
 ControlGRPClick(self);
  ControlGRP.Enabled := true;

end;

procedure TMainForm.set1271btnClick(Sender: TObject);
var
old_selected_control: integer;
r1 :double;
i1,i2 : integer;
begin
  val(set1271edit.text,r1,i1);
  DecimalSeparator := '.';
  set1271edit.text := StringReplace(set1271edit.text,',','.',[rfReplaceAll]);
  if i1>0 then begin
    showmessage('Некорректное плавающее значение :'+set1271edit.text);
    exit;
  end;
  setup1271 := r1;
  old_selected_control := selected_control;
  ControlGRP.Enabled := false;
  Screen.Cursor := crHourGlass;
  selected_control := 1;
  ControlGRP.ItemIndex := selected_control;
  ControlGRPClick(self);
  delay(700);
    if not SetRegionBorder(setup1271) then begin
        showmessage('1.Не удается установить начальный уровень = ' + set1271edit.text);
    end;
    for I1 := 0 to 10 do begin
        if SetVoltage(setup1271) then
            break;
        if I1 = 10 then begin
            showmessage('2.Не удается установить начальный уровень = ' + set1271edit.text);
            Screen.Cursor := crDefault;
        end;
    end;

 Screen.Cursor := crDefault;
 selected_control := old_selected_control;
 ControlGRP.ItemIndex := selected_control;
 ControlGRPClick(self);
 ControlGRP.Enabled := true;

end;

procedure TMainForm.set58abtnClick(Sender: TObject);
var
old_selected_control: integer;
r1 :double;
i1,i2 : integer;
begin
  val(set58aedit.text,r1,i1);
  DecimalSeparator := '.';
  set58aedit.text := StringReplace(set58aedit.text,',','.',[rfReplaceAll]);
  if i1>0 then begin
    showmessage('Некорректное плавающее значение :'+set58aedit.text);
    exit;
  end;
  setup58a := r1;
  old_selected_control := selected_control;
  ControlGRP.Enabled := false;
  Screen.Cursor := crHourGlass;
  selected_control := 0;
  ControlGRP.ItemIndex := selected_control;
  ControlGRPClick(self);
  delay(700);
  memoread.Lines.Add('correct SetRegionBorder');

    if not SetRegionBorder(setup58a) then begin
        showmessage('1.Не удается установить начальный уровень = ' + set58aedit.text);
    end;
   memoread.Lines.Add('set voltage');
    for I1 := 0 to 10 do begin
        if SetVoltage(setup58a) then
            break;
        if I1 = 10 then begin
            showmessage('2.Не удается установить начальный уровень = ' + set58aedit.text);
            Screen.Cursor := crDefault;
        end;
    end;

 Screen.Cursor := crDefault;
 selected_control := old_selected_control;
 ControlGRP.ItemIndex := selected_control;
 ControlGRPClick(self);
 ControlGRP.Enabled := true;

end;

function TMainForm.CorrectVoltage1271(target: double): boolean;
var
    tarcontrol: int64;
    startsetTime: double;
    r1: double ;
begin
   if (now - PrevMTime*1.0)*24*2600 >1 then begin
     exit;
   end;
   r1 :=abs(dacval1271);
   curControl1271 := curControl1271 + round((target * 1.0 - r1) * 1050);
   memoread.Lines.add (format('T=%f Cur=%f OldCTR = %d CTR = %d',[target,r1, oldcontrol,curControl1271]));
   setDPotential(curControl1271);
   memoread.Lines.add (format('After set POTD T=%f Cur=%f OldCTR = %d CTR = %d',[target,r1, oldcontrol,curControl1271]));

end;

function TMainForm.CorrectVoltage58a(target: double): boolean;
var
    tarcontrol: int64;
    startsetTime: double;
    r1: double ;
begin
   if (now - PrevMTime)*24*2600 >1 then begin
     exit;
   end;
   r1 :=dacval58 * 10000;
   curControl58a := curControl58a + round((target * 1.0 - r1) * 20.9760563);
   setDPotential(curControl58a);

end;


procedure TDAQ_all.execute;
var
    i: integer;
    meant, mean3t: double;
    resstr :string;
begin
    while not terminated do begin
           PrevMTime := now();
           cntval := 13000000;
           DaqGetcounter;
           try
            if gpib_1271_ready then
               DaqGetData1271;
           except
            writetimelog(DataDirName + IntToStr(Sweep) + '.dat', 'Exception on DAQ 1271 GET DATA');
            writetimelog( 'Exception on DAQ GET DATA 1271');

           end;

           try
            if gpib_agilent_ready then
               DaqGetData58;
           except
            writetimelog(DataDirName + IntToStr(Sweep) + '.dat', 'Exception on DAQ 58a GET DATA');
            writetimelog( 'Exception on DAQ GET DATA 58a');

           end;

            case selected_control of
                1 : CurVoltage := abs(dacval1271);
                0 : CurVoltage := abs(dacval58);
                else CurVoltage :=  -131313;
            end;
//         writetimelog( ' GettingData = '+IntToStr(integer(GettingData))+' vindex='+IntToStr(vindex)+#13);

        if GettingData then begin
            resstr :=  format('%.7f %.4d %.6d %.1d %.8d %.8d %.3d',
            [CurVoltage,cntval, curControl, dstep, vindex + 1, stepStartIndex, deltaCounterValue]) + ' ' + intToStr(trunc((now - prevMtime))) + ' ' + StringReplace(floattostr(now), ',', '.', [rfReplaceAll, rfIgnoreCase]);
             writetimelog(DataDirName + IntToStr(Sweep) + '.dat', resstr);
            vdata[vindex + 1].counter := cntval;
            vdata[vindex + 1].time := now();
            vdata[vindex + 1].data1271 := dacval1271;
            vdata[vindex + 1].data58a := dacval58;
            vdata[vindex + 1].data := CurVoltage;
            inc(vindex);
        end;


            for i := 0 to 4 do
                if (LastVoltage[i] < 0) then
                    LastVoltage[i] := curVoltage
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
            inc(Daq_counter);

        sleep(100)
    end;
    mainform.Caption := 'terminated';
end;


procedure TDAQ_1271.execute;
var
    i: integer;
    meant, mean3t: double;
begin
    while not terminated do begin
     try
            DaqGetcounter;
            if gpib_1271_ready then DaqGetData1271;
            if gpib_agilent_ready then DaqGetData58;
            case selected_control of
                1 : CurVoltage := abs(dacval1271);
                0 : CurVoltage := abs(dacval58);
                else CurVoltage :=  -131313;
            end;

            for i := 0 to 4 do
                if (LastVoltage[i] < 0) then
                    LastVoltage[i] := curVoltage
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
            if gettingData then begin
                vdata[vIndex + 1].data := CurVoltage;
                vdata[vindex + 1].time := now();
                inc(vIndex);
            end;
            inc(Daq_counter);
       except
            writetimelog(DataDirName + IntToStr(Sweep) + '.dat', 'Exception on DAQ GET DATA');
            writetimelog( 'Exception on DAQ GET DATA');

       end;
        sleep(300)
    end;
    mainform.Caption := 'terminated';
end;
procedure TDAQ_58a.execute;
var
    i: integer;
    meant, mean3t: double;
begin
{
    while not terminated do begin
     try
            DaqGetcounter;
            if gpib_1271_ready then DaqGetData1271;
            if gpib_agilent_ready then DaqGetData58;
            case selected_control of
                1 : CurVoltage := abs(dacval1271);
                0 : CurVoltage := abs(dacval58);
                else CurVoltage :=  -131313;
            end;

            for i := 0 to 4 do
                if (LastVoltage[i] < 0) then
                    LastVoltage[i] := curVoltage
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
            if gettingData then begin
                vdata[vIndex + 1].data := CurVoltage;
                vdata[vindex + 1].time := now();
//                inc(vIndex);
            end;
            inc(Daq_counter);
       except
            writetimelog(DataDirName + IntToStr(Sweep) + '.dat', 'Exception on DAQ GET DATA');
            writetimelog( 'Exception on DAQ GET DATA');

       end;
        sleep(300)
    end;
    mainform.Caption := 'terminated';
}
end;

procedure TMainForm.SpeedButton3Click(Sender: TObject);
begin
 close;
end;

procedure TMainForm.SpeedButton4Click(Sender: TObject);
begin
 formtrends.show;
end;

Initialization
   SpectreList := tstringlist.Create;

end.

