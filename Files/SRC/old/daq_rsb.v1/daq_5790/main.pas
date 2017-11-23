unit main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, gpib_user, Adgpib, ComCtrls, ExtCtrls, TeEngine, Series,
  TeeProcs, Chart, Spin, Buttons,mmsystem,strutils,
  HTTPSend,  blcksock, winsock, Synautil;

type
  TDAQThread = class(TThread)
    Procedure execute;override;
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
//    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Chart2DblClick(Sender: TObject);
    procedure startDacbtnClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
   Function delay(ms:integer):integer;
   Function InitCounterAndGPIB:integer;
   Procedure CreatedataFileName;
   Procedure UpdateStartInterval;
    { Public declarations }
  end;

Vrecord = record
  time : double;
  data : double;
  counter : int64;
end;
Varray = array of vrecord;
var
 correctionTime : double;
 meanVoltage : double = 0;
 LastVoltage : array [0..5] of double = (0,0,0,0,0,0);
 Stage : integer;
 counter_and_GPIB_ready : boolean = false;
  v_ref :double =4.9742;
  PortNum :integer = 9090;
  HTTP: THTTPSend = nil;
  StepStartIndex : int64;
  Border_High, Border_low: dword;
  dstep : integer;
  DaqThread : Tdaqthread;
  CurVoltage : double;
  CurControl : int64;
  oldControl : int64;

  MainForm: TMainForm;
  VoltageChangeTime : double;
  TimerID :dword;

  (*488.2 GPIB global status variables.*)
  Vdata   : array[0..10000000] of vrecord;
  PrevVindex, Vindex : integer;
  dacval :double;               ltageChangeIndex: INTEGER;
  (*488.2 GPIB global status variables.*)
  ibsta   : Integer;
  iberr   : Integer;
  ibcnt   : Integer;
  ibcntl  : Integer;
  rs485   : thandle = 0;
  iRet, iStatus : Integer;
  iCount        : Integer;
  wRet          : Word ;
   bCfgChg , bComOpen : Boolean;
  OpError :boolean;
  prevread : double ;
   iConfirm : Integer ;
   LastCounterTime: double;
   std, mean : double;
   LastCounterValue : Int64;
   cntVal:DWord;
   DeltaCounterValue : int64;
   PrevVoltageChange : double;
  dev,resc: integer;
  Interval_low : double =  0.1000;
  interval_high : double = 0.1090;
  abs_step : double = 0.0001;
  cur_step : double;
  GettingData :boolean = false;
  step_len  : double = 60;
  start_step :double = 0;
   prevVoltage : shortstring = '';
implementation
uses math,logging, SetMinMax, das_const,i7000,i7000u,dcon_pc ;
{$R *.DFM}
   function V_Convert(v_cur:double) : dword;
   begin
     result:= trunc(1048576.0*(V_cur) / 5);
   end;
   function V_revert(d_cur:dword) : double;
   begin
     result := 5.0*d_cur/$FFFFF;
   end;

 fUNCTION setPotential(U: double):string;
 var
  s1,url: string;
 begin
 exit;
     if http<>nil then begin
       http.Free;
       http:= nil;
     end;
     HTTP := THTTPSend.Create;
    s1:=format('%.10f',[u]);
    s1 := ansiReplaceStr(s1,',','.');
    url:='http://192.168.0.10:8282/set='+s1;

    HTTP.HTTPMethod('GET', url);
    http.Free;
    http:=nil;
 end;
 fUNCTION setdPotential(U: dword):string;
 var
  s1,url: string;
  maxStep : int64;
  newU : int64;
 begin

      newU := U;
      curControl := newU;
      maxStep := trunc(0.011*$FFFFF/5);
//      maxstep:=1000;
     if abs(oldControl-curControl)>(maxStep)
        then curcontrol:= oldcontrol-trunc(maxstep*(oldControl-curControl)/abs(oldControl-curControl));
     oldControl := CurControl;

     if http<>nil then begin
       http.Free;
       http:= nil;
     end;
     HTTP := THTTPSend.Create;
    s1:=format('%d',[curControl]);
    s1 := ansiReplaceStr(s1,',','.');
    url:='http://192.168.0.10:8282/setabs='+s1;

    HTTP.HTTPMethod('GET', url);
    http.Free;
    http:=nil;
 end;
   Procedure CalcStdAndMean(cur, len: integer);

   var
   i  : integer;
   ov,delta : double;

   begin
        mean :=0;
        std := 0;
        if len=0 then exit;
        if (cur-len+1) <0 then exit;
        for i:= cur-(len-1) to cur do begin
          mean := mean+ vdata[i].data;
        end;
        mean := mean / len;
        for i:= cur-(len-1) to cur do begin
          delta :=abs(vdata[i].data-mean);
          if delta >0.0002 then
                vdata[i].data:=mean;
        end;
        mean :=0;
        std := 0;

        for i:= cur-(len-1) to cur do begin
          mean := mean+ vdata[i].data;
        end;
        mean := mean / len;

        for i:= cur-(len-1) to cur do begin
          std := std+ (mean - vdata[i].data)*(mean - vdata[i].data);
        end;
        std := sqrt(std/(len));

   end;
 Function DaqGetdata :boolean;
var
  delta:real;
  wrtbuf, rdbuf: packed array[0..299] of char  ;
  rdstr : string;


begin
   curmtime:=timegettime();
   writeProtocol('1 #################### DAQ start ##################### '+IntToStr(vindex));
   try

   curtime:=now();
   writeprotocol( '2 dstimer callback='+format('%15.13f',[(Curtime-PrevTime)*24*3600*1000]));
   curmtime:=timegettime();
   writeprotocol( '3 begin1 dttimer callback=');
   cntval := 0;
//   mainform.Caption:=IntToStr(CurMtime-PrevMTime);
   WriteProtocol('Read counter' );
   wRet := DCON_Read_Counter(gcPort , StrToInt('$' + mainform.Address.Text) , -1 ,StrToInt('$' + mainform.edCh.Text),  0, 200, @cntVal);
   WriteProtocol('check Read counter = '+IntToStr(cntval) );
   If wRet <> 0 Then
        Begin
              writeprotocol('Err: Error reading counter.');
        end else begin
            if cntval>$FFFF then begin
              cntval := 131313;
              DCON_Clear_Counter(gcPort , StrToInt('$' + mainform.Address.Text) , -1 ,StrToInt('$' + mainform.edCh.Text),  0, 200);            deltaCounterValue := cntval-lastCounterValue;
            end;
            LastCounterValue := cntval;
            LastCounterTime := now();
        end;
   curmtime:=timegettime();
   writeprotocol( 'counter ok = '+IntToStr(cntval));


    strcopy(wrtbuf, pchar('X?'));
    WriteProtocol('4 ibwrta Write a string command to a GPIB instrument asynchronously using the ibwrta() command');
    ibwrta(dev, @wrtbuf, strlen(wrtbuf));
    WriteProtocol('5 get globals');

    gpib_get_globals(@ibsta, @iberr, @ibcnt, @ibcntl);
    if (ibsta AND ERR) <> 0 THEN
    begin
      writeprotocol('6 Err: Error in writing the string command to the GPIB instrument.');
      opError:=true;
      exit;
    end;
    writeprotocol('7 Answer ok from the GPIB instrument ok. ibcnt = '+IntToStr(ibcnt));
    WriteProtocol('8 ibWait for the completion of asynchronous write operation' );
    ibwait(dev, CMPL);

    curmtime:=timegettime();
    writeprotocol( '9 wait ok = '+IntToStr(CurMtime-PrevMTime));
    WriteProtocol('10 get globals');

    gpib_get_globals(@ibsta, @iberr, @ibcnt, @ibcntl);
    if (ibsta AND ERR) <> 0 THEN
    begin
      writeprotocol('11 Err: Writing the string command to the GPIB instrument timeout.');
      opError:=true;
      exit;
    end;
    writeprotocol('12 Answer ok from the GPIB instrument ok. ibcnt = '+IntToStr(ibcnt));

    WriteProtocol('13 //Read the response string from the GPIB instrument asynchronously using the ibrda() command' );
    WriteProtocol('14 ibrda');
    ibrda(dev, @rdbuf, 100);
    WriteProtocol('15 get globals');
    gpib_get_globals(@ibsta, @iberr, @ibcnt, @ibcntl);
    if (ibsta AND ERR) <> 0 THEN
    begin
      writeprotocol('16 Err: Error in reading the response string from the GPIB instrument.');
      opError:=true;
      exit;
    end;
    writeprotocol('17 Answer ok from the GPIB instrument ok. ibcnt = '+IntToStr(ibcnt));

    WriteProtocol('18 Wait for the completion of asynchronous read operation');
    ibwait(dev, CMPL);
    WriteProtocol('19 get globals');
    //Получение напряжения
    gpib_get_globals(@ibsta, @iberr, @ibcnt, @ibcntl);
    if (ibsta AND ERR) <> 0 THEN
    begin
      mainform.caption :=FormatdateTime('DD/MM/YYYY HH:NN:SS',now)+'Err: Reading the string command to the GPIB instrument timeout.';
      writeprotocol('20 Err: Reading the string command to the GPIB instrument timeout.');
      opError:=true;
      exit;
    end;
    writeprotocol('21 Answer ok from the GPIB instrument ok. ibcnt = '+IntToStr(ibcnt));

    rdbuf[ibcnt-1] := chr(0);
    rdstr := rdbuf;
    rdstr:=rdstr+' ';
    writeprotocol('22 Answer ok from the GPIB instrument ok. ibcnt = '+IntToStr(ibcnt)+' str='+rdstr);

//    if PrevVoltage = rdstr then exit; //У АЦП нет новых данных
    PrevVoltage := rdstr;
    rdstr:=system.copy(rdstr,1,pos(' ',rdstr)-1);
    val(rdstr,dacval,resc);

    if (dacval <0.00000000001) or ( pos('.',rdstr)=0 ) then begin
       PrevMTime:= TimeGetTime();
       PrevTime := now;
       writeProtocol('23 ####ZERO '+rdstr+#10);
       exit;

    end;
    writeprotocol('24');
    rdstr:=rdstr+' '+format(' %.4d %.6d %.1d %.8d %.8d %.3d',
    [ cntval, curControl,dstep,vindex+1,stepStartIndex,deltaCounterValue]) +' '+
    intToStr(trunc((timegettime - prevMtime)))+' '+
    StringReplace(floattostr(now), ',', '.',[rfReplaceAll, rfIgnoreCase]);
    writeprotocol('14');
    prevread := now();
    writeprotocol('rdstr: '+rdstr);
    CurVoltage := dacval;
    if GettingData then begin
      writetimelog(LogFilename,rdstr);
      writetimelog(DataDirName+IntToStr(stage),rdstr);
      if resc=0 then vdata[vIndex+1].data := dacval
                else vdata[vIndex+1].data := -1;;

      vdata[vindex+1].counter := cntval;
      vdata[vindex+1].time := now();
      vdata[vindex+1].data := dacval;
      inc(vIndex);
    end else wRet := DCON_Clear_Counter(gcPort , StrToInt('$' + mainform.Address.Text) , -1 ,StrToInt('$' + mainform.edCh.Text),  0, 200);

      except
              on E: Exception do begin
                writeprotocol('%%%%%%%%%%%%%%%%% Exceprton on read counter:'+E.Message);
                    mainform.Caption := 'exception!!!!!!!!!!!!!!!!!!!';
                 end;


    end;

    writeProtocol('26 #######D AQ end '+IntToStr(vindex));

   PrevMTime:= TimeGetTime();
   PrevTime := now;
end;

Procedure TDAQThread.execute;
var
 i: integer;
 Curtimel, PrevTimel :double;
 CurMtimel, PrevMTimel :dword;
begin
 timebeginperiod(10);
  while not terminated do begin

   DaqGetData;
   LastVoltage[0] := LastVoltage[1];
   LastVoltage[1] := LastVoltage[2];
   LastVoltage[2] := LastVoltage[3];
   LastVoltage[3] := LastVoltage[4];
   LastVoltage[4] := LastVoltage[5];
   LastVoltage[5] := curVoltage;
   meanVoltage :=LastVoltage[0];
   for i:=1 to 5 do meanVoltage := meanVoltage+LastVoltage[i];
   meanVoltage:=meanVoltage /6.0;
   sleep(300)
  end;
 timeendperiod(10);
  mainform.Caption:='terminated';
end;

procedure TMainForm.Button1Click(Sender: TObject);
var
  //Declare variables
  wrtbuf, rdbuf: packed array[0..199] of char  ;
  dev: integer;
begin
  //Open and intialize an GPIB instrument
     gcDataBit  := Char(8);      // 8 data bit
     gcParity   := Char(0);      // Non Parity
     gcStopBit  := Char(0);      // One Stop Bit
     bCOMOpen   := False;
     bCfgChg    := False;
     gszSend    := StrAlloc( 100 );
     gszReceive := StrAlloc( 100 );

  dev := ibdev(cmbGPIB.ItemIndex, cmbInst.ItemIndex+1, 0, T1s, 1, 0);
  gpib_get_globals(@ibsta, @iberr, @ibcnt, @ibcntl);
  if (ibsta AND ERR) <> 0 THEN
  begin
    ShowMessage(DateToStr(now)+' '+TimeToStr(now)+'  '+'Error in initializing the GPIB instrument.'+#10);
  end;

  //clear the specific GPIB instrument
  ibclr(dev);
  gpib_get_globals(@ibsta, @iberr, @ibcnt, @ibcntl);
  if (ibsta AND ERR) <> 0 THEN
  begin
    ShowMessage(DateToStr(now)+' '+TimeToStr(now)+'  '+'Error in clearing the GPIB device.'+#10);
  end;

  strcopy(wrtbuf, pchar(#10+editWrite.Text+#10));
  //Write a string command to a GPIB instrument asynchronously using the ibwrta() command
  ibwrta(dev, @wrtbuf, strlen(wrtbuf));
  gpib_get_globals(@ibsta, @iberr, @ibcnt, @ibcntl);
  if (ibsta AND ERR) <> 0 THEN
  begin
    ShowMessage(DateToStr(now)+' '+TimeToStr(now)+'  '+'Error in writing the string command to the GPIB instrument.'+#10);
  end;

  //Wait for the completion of asynchronous write operation
  ibwait(dev, CMPL);
  gpib_get_globals(@ibsta, @iberr, @ibcnt, @ibcntl);
  if (ibsta AND ERR) <> 0 THEN
  begin
    ShowMessage('Writing the string command to the GPIB instrument timeout.'+#10);
  end;

  //Read the response string from the GPIB instrument asynchronously using the ibrda() command
  ibrda(dev, @rdbuf, 100);
  gpib_get_globals(@ibsta, @iberr, @ibcnt, @ibcntl);
  if (ibsta AND ERR) <> 0 THEN
  begin
    ShowMessage(DateToStr(now)+' '+TimeToStr(now)+'  '+'Error in reading the response string from the GPIB instrument.'+#10);
  end;

  //Wait for the completion of asynchronous read operation
  ibwait(dev, CMPL);
  gpib_get_globals(@ibsta, @iberr, @ibcnt, @ibcntl);
  if (ibsta AND ERR) <> 0 THEN
  begin
    ShowMessage('Reading the string command to the GPIB instrument timeout.'+#10);
  end;
  rdbuf[ibcnt] := chr(0);

  memoRead.Text := rdbuf;

  //Offline the GPIB interface card
  ibonl(dev, 0);
  gpib_get_globals(@ibsta, @iberr, @ibcnt, @ibcntl);
  if (ibsta AND ERR) <> 0 THEN
  begin
    ShowMessage(DateToStr(now)+' '+TimeToStr(now)+'  '+'Error in offline the GPIB interface card.'+#10);
  end;

end;

procedure TMainForm.FormCreate(Sender: TObject);
var
 i : int64;
begin
  cmbGPIB.ItemIndex := 0;
  cmbInst.ItemIndex := 15;
  memoRead.Text := '';
     gcDataBit  := Char(8);      // 8 data bit
     gcParity   := Char(0);      // Non Parity
     gcStopBit  := Char(0);      // One Stop Bit
     bCOMOpen   := False;
     bCfgChg    := False;
     gszSend    := StrAlloc( 100 );
     gszReceive := StrAlloc( 100 );
//     restorecomponents(self);
  UpdateStartInterval;
  


end;
procedure TimerProc(uTimerID, uMessage: UINT; dwUser, dw1, dw2: DWORD) stdcall;
begin
 Daqgetdata;
end;
procedure TMainForm.StartCycleClick(Sender: TObject);
var
  //Declare variables
  wrtbuf, rdbuf: packed array[0..399] of char  ;
  msg,errmess,rdstr : string;
  I1 : INTEGER;
  T1,T2 :DOUBLE;
var
 dt : double;
 prt :tthreadpriority;
 il1,il2,il3 : integer;
 prevGrIndex : integer ;
 CounterStep : integer;
 Stepstr : string;
 newTarget, curTarget : double;

begin
     Stage := 1;
  CreateDataFileName;
  Prevmtime := timegettime();
  Timebeginperiod(1);
  memoread.Lines.add('Time min period = '+IntToStr(timeGetMinPeriod));
  memoread.Lines.Add('Time max period = '+IntToStr(timeGetMAXPeriod));
    InitCounterAndGPIB();

    DaqThread := Tdaqthread.Create(true);
    daqthread.Priority := tphigher ;
     prt := daqthread.Priority;
    daqthread.Priority := tphighest ;
     prt := daqthread.Priority;
    LastCounterTime :=now;
    daqthread.Priority := tpTimeCritical ;
     prt := daqthread.Priority;
     GettingData := false;


//######################################################################################
//#########################################            #################################
//######################################### main cycle #################################
//#########################################            #################################
//######################################################################################
start_step:=now;
ch1StdSeries.clear;
series1.Clear;
ch1VoltSeries.clear;
CountPerVSeries.Clear;
ch1VoltSeries.clear;
ch1MeanSeries.clear;
MEANvOLTAGEseries.clear;
STDvOLTAGEseries.clear;
Counterseries.clear;
step_len := expspn.Value;
curTarget := bottomspn.Value;
curControl := v_convert(curVoltage);

  border_high := v_convert(Bottomspn.Value/10000);
  border_low := curControl;
  if border_high > border_low then dstep:=1 else dstep:=-1;
  while (curControl < $FFFFF)  do begin
    if dstep <0 then
       if curControl< border_high then break;
    if dstep > 0 then
       if curControl > border_high then break;
    setDPotential(curControl);
    delay(1);
    daqGetdata;
    curControl := curControl + dstep*trunc((100.0*$FFFFF/50000));
  end;
    delay(3);
    daqGetdata;
    curControl := curControl+trunc((Bottomspn.Value*1.0-curVoltage*10000)/(50000/$FFFFF));
    setDPotential(curControl);
    delay(3);
    daqGetdata;
    curControl := curControl+trunc((bottomspn.Value*1.0-curVoltage*10000)/(50000/$FFFFF));
    setDPotential(curControl);
    delay(3);
    daqGetdata;
    curControl := curControl+trunc((bottomspn.Value*1.0-curVoltage*10000)/(50000/$FFFFF));
    setDPotential(curControl);
    delay(3);
    daqGetdata;
    CorrectionTime := now;
    memoread.Lines.Add('Set ok. wait 4 sec');
while (now-start_Step)*24*3600<4 do application.processmessages;
daqthread.Resume;
start_step:=now;

    prevGrIndex := 2;
    LastCounterTime := now;
    LastCounterValue := 0;
    cntval := 0;
    vIndex := 1;
    PrevVIndex:=2;
    PrevVoltageChange := -1;
    StepStartIndex := 4;
    dstep :=1;
    GettingData := true;
    border_high := topspn.Value;
    border_low := Bottomspn.Value;
    if border_high > border_low then
    begin
         dstep:=1
    end else begin
        border_low := topspn.Value;
        border_high := Bottomspn.Value;
        dstep:=-1;
    END;

//######################################################################################
//#########################################            #################################
//######################################### main cycle #################################
//#########################################            #################################
//######################################################################################

  while CycBox.Checked do begin
     mainform.Caption:=IntToStr(cntval);

    while ch1StdSeries.Count>6230 do ch1StdSeries.Delete(0);
    while ch1VoltSeries.Count>6230 do ch1VoltSeries.Delete(0);
    while ch1MeanSeries.Count>6230 do ch1MeanSeries.Delete(0);
    while MEANvOLTAGEseries.Count>15300 do MEANvOLTAGEseries.Delete(0);
    while STDvOLTAGEseries.Count>15300 do STDvOLTAGEseries.Delete(0);
    while Counterseries.Count>5300 do Counterseries.Delete(0);
   if prevGRindex = vindex+1 then continue;
   for il1:= prevGRindex to vindex do begin
       ch1VoltSeries.AddXY(vdata[il1].time,vdata[il1].data);
   end;

    prevGRindex := vindex+1;

    if (now-start_step)*24*3600>step_len then begin

       GettingData := false;
//       while (now-start_Step)*24*3600<0.4 do application.processmessages;

       CounterStep := vdata[vindex].counter;
       dt := (now()-lastCounterTime) * 24*3600;
       CalcStdAndMean(Vindex,vindex-StepStartIndex);// vIndex-PrevVindex);
       ch1MeanSeries.AddXY(now,mean);
       ch1stdSeries.AddXY(now,std);
       MeanVoltageSeries.AddXY(now(),mean);
       stdVoltageSeries.AddXY(now(),std);
       countPerVSeries.AddXy(mean,CounterStep);
       series1.AddXY(mean,1+random);
       StepStr := format('%8.6f %8.6f ',[mean, std]);
       StepStr:=StepStr+' '+
       format(' %.5d %.2d %.8d %.6d %.6d',[CounterStep , curControl,dstep,vindex+1,stepStartIndex])+' '+
       StringReplace(floattostr(now), ',', '.',[rfReplaceAll, rfIgnoreCase]);
       StepStr := StringReplace(StepStr, ',', '.',[rfReplaceAll, rfIgnoreCase]);
       writetimelog(DataFileName,stepStr);
       memoread.lines[0]:=(DateToStr(now)+' '+TimeToStr(now)+'  '+'Read ok = '+rdstr);
    //   writetimelog(rdstr+#10);
       LastCounterTime:=now;

       StepStartIndex:= vindex+1;

       newTarget := curTarget+ dstep*stepspn.Value/10.0;
       if newTarget > border_high then begin
          dstep := -1;
          Stage := Stage+1;
       end else begin
         if newTarget < border_low then
            begin
                 Stage := Stage+1;
                 dstep := 1;
            end else curTarget :=newTarget;
       end;
       curControl := curControl+trunc((curtarget*1.0-curVoltage*10000)/(50000/$FFFFF));
       setdPotential(curControl);
       start_step := now;
       while (now-start_Step)*24*3600<deadspn.Value do application.processmessages;
       GettingData := true;
       start_step := now;
       correctionTime := now;
    end else  if (now-CorrectionTime )*24*3600>5 then begin
       curControl := curControl+trunc((curtarget*1.0-meanVoltage*10000)/(50000/$FFFFF));
       setdPotential(curControl);
       correctionTime := now;
    end;

    t1 := now;
    while (now-t1)*24*3600<1 DO BEGIN
     application.ProcessMessages;
     sleep(100);
    END;

  end;
//    timeKillEvent(TimerID);
    daqThread.Terminate;
    PrevMTime := TimegetTime;
    while (timegettime()-PrevMtime)<1000 do application.ProcessMessages;
  //Offline the GPIB interface card
    ibonl(dev, 0);
    gpib_get_globals(@ibsta, @iberr, @ibcnt, @ibcntl);
    if (ibsta AND ERR) <> 0 THEN
    begin
      memoread.lines[0]:=(DateToStr(now)+' '+TimeToStr(now)+'  '+'Err: Error in offline the GPIB interface card.'+#10);
       writetimelog(DateToStr(now)+' '+TimeToStr(now)+'  '+'Err: Error in offline the GPIB interface card.'+#10);
    end;
        StartCycle.Enabled := true;
    iRet := close_Com(gcPort);
    If iRet > 0 Then
    Begin
        Beep;
        iConfirm := MessageDlg('close_COM Error Code:' + IntToStr(iRet) + #13 + IGetErrorString(iRet) + #13 + 'Quit this demo?'
                               , mtConfirmation , [mbYes,mbNo] , 0 );

    End;

    bComOpen := false;
    bCfgChg  := False;


end;

procedure TMainForm.FormShow(Sender: TObject);
begin
 if paramcount>0 then begin
    if paramstr(1) = 'continue' then begin
      caption := 'Continue';
      cycBox.Checked := true;
      StartCycle.Click;

    end;
 end;
end;

procedure TMainForm.Chart1DblClick(Sender: TObject);
begin
// SetMinMaxForm.SetLimits(TChart(sende
  while (timegettime()-PrevMtime)<500 do application.ProcessMessages;
end;

procedure TMainForm.Chart2DblClick(Sender: TObject);
begin
 SetMinMaxForm.SetLimits(TChart(sender));
end;

procedure TMainForm.startDacbtnClick(Sender: TObject);
var
 dstep : integer;
begin
  if ansilowercase(startdacbtn.Caption) = 'stop' then begin
     startdacbtn.Caption := 'Start';
     exit;
  end;
  startdacbtn.Caption := 'Stop';
  InitCounterAndGPIB();
  gettingData := false;
  border_high := v_convert(topspn.Value/10000);
  border_low := v_convert(bottomspn.Value/10000);

  curControl := border_low;
  if border_high > border_low then dstep:=1 else dstep:=-1;
      dacseries.Clear;
  while (curControl < $FFFFF) and (startdacbtn.Caption = 'Stop') do begin
    if dstep <0 then
       if curControl< border_high then break;
    if dstep > 0 then
       if curControl > border_high then break;
    setDPotential(curControl);
    delay(1);
    daqGetdata;
//    dacseries.AddXY(curControl,curVoltage);
    writetimelog(dataFileName,format('%.5d %9.7f',[curControl, curVoltage]));
    curControl := curControl + dstep*trunc((100.0*$FFFFF/50000));
  end;
    delay(1);
    daqGetdata;
    if startdacbtn.Caption <> 'Stop' then begin
    end;
    startdacbtn.Caption := 'Start';

    ibonl(dev, 0);
    gpib_get_globals(@ibsta, @iberr, @ibcnt, @ibcntl);
    if (ibsta AND ERR) <> 0 THEN
    begin
      memoread.lines[0]:=(DateToStr(now)+' '+TimeToStr(now)+'  '+'Err: Error in offline the GPIB interface card.'+#10);
       writetimelog(DateToStr(now)+' '+TimeToStr(now)+'  '+'Err: Error in offline the GPIB interface card.'+#10);
    end;
        StartCycle.Enabled := true;
    iRet := close_Com(gcPort);
    If iRet > 0 Then
    Begin
        Beep;
        iConfirm := MessageDlg('close_COM Error Code:' + IntToStr(iRet) + #13 + IGetErrorString(iRet) + #13 + 'Quit this demo?'
                               , mtConfirmation , [mbYes,mbNo] , 0 );

    End;

    bComOpen := false;
    bCfgChg  := False;

end;

function TMainForm.delay(ms: integer): integer;
var
 st:double;
begin
 st :=now;
 while (now-st)*24*3600 < ms do application.ProcessMessages;
end;

function TMainForm.InitCounterAndGPIB: integer;
var

errmess : string;
t1 : double;
wrtbuf : array[0..2000] of char;
   begin

   if counter_and_GPIB_ready then exit;
        gcPort := Char(ComComboBox.ItemIndex + 1 );      // Setting Com Port
     gdwBaudRate := 9600;

    iRet := Open_Com(gcPort, gdwBaudRate, gcDataBit, gcParity, gcStopBit);
    If iRet > 0 Then
    Begin
        Beep;
        iConfirm := MessageDlg('OPEN_COM Error Code:' + IntToStr(iRet) + #13 + IGetErrorString(iRet) + #13 + 'Quit this demo?'
                               , mtConfirmation , [mbYes,mbNo] , 0 );

    End;

    bComOpen := True;
    bCfgChg  := False;
   wRet := DCON_Read_Counter(gcPort , StrToInt('$' + mainform.Address.Text) , -1 ,StrToInt('$' + mainform.edCh.Text),  0, 200, @cntVal);
   If wRet <> 0 Then
        Begin
           writeprotocol('Err: Error reading counter.');
           showmessage('Counter read error');
        end else begin
           cntval := 131313;
           DCON_Clear_Counter(gcPort , StrToInt('$' + mainform.Address.Text) , -1 ,StrToInt('$' + mainform.edCh.Text),  0, 200);            deltaCounterValue := cntval-lastCounterValue;
           LastCounterValue := cntval;
           LastCounterTime := now();
        end;

    dev := ibdev(cmbGPIB.ItemIndex, cmbInst.ItemIndex+1, 0, T1s, 1, 0);
    StartCycle.Enabled := false;
    gpib_get_globals(@ibsta, @iberr, @ibcnt, @ibcntl);
    prevread := now();
    if (ibsta AND ERR) <> 0 THEN
    begin
      ErrMess:=GpibError(iberr);
      memoread.lines[0]:=(DateToStr(now)+' '+TimeToStr(now)+'  '+'Err: Error in init the GPIB device.'+errmess+#10);
      writetimelog(DateToStr(now)+' '+TimeToStr(now)+'  '+'Err: Error in init the GPIB device.'+errmess+#10);
      opError:=true;

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
    If opError then begin
      T1 := NOW;
      while (now-t1)*24*3600<8 DO BEGIN
        application.ProcessMessages;
      END;
      (*
       winexec(pansichar(paramstr(0)+' continue'), sw_show);
       CycBox.Checked := false;
       application.terminate;
       break;
       *)
    end;

    opError := false;
(*
      ibonl(dev, 1);
      gpib_get_globals(@ibsta, @iberr, @ibcnt, @ibcntl);
      if (ibsta AND ERR) <> 0 THEN
      begin
        memoread.lines[0]:=(DateToStr(now)+' '+TimeToStr(now)+'  '+'Err: Error in online the GPIB interface card.'+#10);
              writetimelog(DateToStr(now)+' '+TimeToStr(now)+'  '+'Err: Error in online the GPIB interface card.'+#10);
      end;
*)

    //clear the specific GPIB instrument
    ibclr(dev);
    gpib_get_globals(@ibsta, @iberr, @ibcnt, @ibcntl);
    if (ibsta AND ERR) <> 0 THEN
    begin
      ErrMess:=GpibError(iberr);
      memoread.lines[0]:=(DateToStr(now)+' '+TimeToStr(now)+'  '+'Err: Error in clearing the GPIB device.'+errmess+#10);
            writetimelog(DateToStr(now)+' '+TimeToStr(now)+'  '+'Err: Error in clearing the GPIB device.'+errmess+#10);
      opError:=true;
      (*continue;*)
      StartCycle.Enabled := true;
      counter_and_GPIB_ready := true;
      exit;
    end;

//**************** clear queue and events*****************
    strcopy(wrtbuf, pchar(#10+'*cls'+#10));
    //Write a string command to a GPIB instrument asynchronously using the ibwrta() command
    ibwrta(dev, @wrtbuf, strlen(wrtbuf));
    gpib_get_globals(@ibsta, @iberr, @ibcnt, @ibcntl);
    if (ibsta AND ERR) <> 0 THEN
    begin
      memoread.lines[0]:=(DateToStr(now)+' '+TimeToStr(now)+'  '+'Err: Error in writing *cls command to the GPIB instrument.'+#10);
            writetimelog(DateToStr(now)+' '+TimeToStr(now)+'  '+'Err: Error in writing *cls command to the GPIB instrument.'+#10);
    end;

    //Wait for the completion of asynchronous write operation
    ibwait(dev, CMPL);
    gpib_get_globals(@ibsta, @iberr, @ibcnt, @ibcntl);
    if (ibsta AND ERR) <> 0 THEN
    begin
      memoread.lines[0]:=(DateToStr(now)+' '+TimeToStr(now)+'  '+'Err: Wait for the completion of asynchronous write operation. *cls '+#10);
            writetimelog(DateToStr(now)+' '+TimeToStr(now)+'  '+'Err:  Wait for the completion of asynchronous write operation. *cls '+#10);
      opError:=true;
      (*continue;*)
      StartCycle.Enabled := true;
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
    if (ibsta AND ERR) <> 0 THEN
    begin
      memoread.lines[0]:=(DateToStr(now)+' '+TimeToStr(now)+'  '+'Err: Error in writing the string command to the GPIB instrument.'+#10);
            writetimelog(DateToStr(now)+' '+TimeToStr(now)+'  '+'Err: Error in writing the string command to the GPIB instrument.'+#10);
    end;

    //Wait for the completion of asynchronous write operation
    ibwait(dev, CMPL);
    gpib_get_globals(@ibsta, @iberr, @ibcnt, @ibcntl);
    if (ibsta AND ERR) <> 0 THEN
    begin
      memoread.lines[0]:=(DateToStr(now)+' '+TimeToStr(now)+'  '+'Err: Writing the string command to the GPIB instrument timeout.'+#10);
            writetimelog(DateToStr(now)+' '+TimeToStr(now)+'  '+'Err: Writing the string command to the GPIB instrument timeout.'+#10);
      opError:=true;
      (*continue;*)
      StartCycle.Enabled := true;
      exit;
    end;


//***********finished configure ******************
    wRet := DCON_Clear_Counter(gcPort , StrToInt('$' + Address.Text) , -1 ,StrToInt('$' + edCh.Text),  0, 200);

   end;

procedure TMainForm.Timer1Timer(Sender: TObject);
begin
 statusbar1.Panels[0].Text := format('Ctrl=%.5d U=%8.6f',[curControl, curVoltage]);
end;

procedure TMainForm.CreatedataFileName;
  var
    s1,s2 :string;
    r1               : dword;
    Info :string;
begin
  r1:=80;
  getcomputername(@charbuf,r1);
  compname:=charbuf;
  s1:=extractfilepath(application.exename);
  Info:=FormatDateTime('DD_MMMM_YY HH_NN_SS ',now)+Bottomspn.Text+'-'+TopSpn.Text+' exp-'+expspn.Text+' dead-'+deadspn.Text;
  s2:=s1+'\data\';
  CreateDirectory(pchar(s2),nil);
  s2:=s2+FormatDateTime('DD_MMMM_YY HH_NN_SS ',now)+'\';
  CreateDirectory(pchar(s2),nil);
  DataDirName := s2;
  s2:=s2+info;
  DataFileName :=s2+'.txt';
  LogFileName :=s2+' full.txt';
end;
procedure TMainForm.UpdateStartInterval;
var
 dstep : integer;
begin
  InitCounterAndGPIB();
  gettingData := false;
    delay(deadspn.Value);
    daqGetdata;
    if abs(curvoltage)>1000 then begin
      ;
    end else begin;
      Bottomspn.Value:= trunc(curVoltage*10000);
      Topspn.Value:= trunc(curVoltage*10000);
      curControl := V_convert(curVoltage);
      oldControl := curControl;
    end;
    ibonl(dev, 0);
    gpib_get_globals(@ibsta, @iberr, @ibcnt, @ibcntl);
    if (ibsta AND ERR) <> 0 THEN
    begin
      memoread.lines[0]:=(DateToStr(now)+' '+TimeToStr(now)+'  '+'Err: Error in offline the GPIB interface card.'+#10);
       writetimelog(DateToStr(now)+' '+TimeToStr(now)+'  '+'Err: Error in offline the GPIB interface card.'+#10);
    end;
        StartCycle.Enabled := true;
    iRet := close_Com(gcPort);
    If iRet > 0 Then
    Begin
        Beep;
        iConfirm := MessageDlg('close_COM Error Code:' + IntToStr(iRet) + #13 + IGetErrorString(iRet) + #13 + 'Quit this demo?'
                               , mtConfirmation , [mbYes,mbNo] , 0 );

    End;
    Daqgetdata;
    bComOpen := false;
    bCfgChg  := False;

end;

end.
