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
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure StartCycleClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Chart1DblClick(Sender: TObject);
//    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Chart2DblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

Vrecord = record
  time : double;
  data : double;
  counter : int64;
end;
Varray = array of vrecord;
var
  v_ref :double =4.9742;
  PortNum :integer = 9090;
  HTTP: THTTPSend = nil;
  StepStartIndex : int64;
  Border_High, Border_low,cur_val : word;
  dstep : integer;
  DaqThread : Tdaqthread;

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
   LastCounterValue : Integer;
   cntVal:DWord;
   DeltaCounterValue : integer;
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
 fUNCTION setPotential(U: double):string;
 var
  s1,url: string;
 begin
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
 begin
     if http<>nil then begin
       http.Free;
       http:= nil;
     end;
     HTTP := THTTPSend.Create;
    s1:=format('%d',[u]);
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
            deltaCounterValue := cntval-lastCounterValue;
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
    [ cntval, cur_val,dstep,vindex+1,stepStartIndex,deltaCounterValue]) +' '+
    intToStr(trunc((timegettime - prevMtime)))+' '+
    StringReplace(floattostr(now), ',', '.',[rfReplaceAll, rfIgnoreCase]);
    writeprotocol('14');
    prevread := now();
    writeprotocol('rdstr: '+rdstr);
    if GettingData then begin
      writetimelog(LogFilename,rdstr);
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
//   mainform.Caption:=IntToStr(CurMtimel-PrevMTimel);
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
   Procedure InitCounterAndGPIB;
   begin
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
    strcopy(wrtbuf, pchar('dcv 1,resl6'));
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
   function V_Convert(v_ref,v_cur:double) : dword;
   begin
     result := trunc(v_cur / 0.756784301346);
   end;
   function V_revert(v_ref:double;d_cur:dword) : double;
   begin
     result :=0.756784301346 * d_cur;
   end;
var
 dt : double;
 prt :tthreadpriority;
 il1,il2,il3 : integer;
 prevGrIndex : integer ;
 CounterStep : integer;
 Stepstr : string;
begin
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
     daqthread.Resume;


//######################################################################################
//#########################################            #################################
//######################################### main cycle #################################
//#########################################            #################################
//######################################################################################
start_step:=now;
ch1StdSeries.clear;
ch1VoltSeries.clear;
ch1MeanSeries.clear;
MEANvOLTAGEseries.clear;
STDvOLTAGEseries.clear;
Counterseries.clear;
step_len := expspn.Value;
border_high := v_convert(v_ref,topspn.Value);
border_low := v_convert(v_ref,bottomspn.Value);
cur_val := border_low-1;
setdPotential(cur_val);
start_step:=now;
while (now-start_Step)*24*3600<9 do application.processmessages;
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
cur_val := border_low-1;
GettingData := true;

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
    prevGRindex := vindex+1;

    if (now-start_step)*24*3600>step_len then begin
       cur_val := cur_val + dstep;
       if cur_val > border_high then begin
          dstep := -1;
       end else if cur_val < border_low then begin
          dstep := 1;
       end;

       GettingData := false;
       start_step:=now;
       while (now-start_Step)*24*3600<0.2 do application.processmessages;
       setdPotential(cur_val);
       start_step:=now;
       while (now-start_Step)*24*3600<2 do application.processmessages;
       CounterStep := vdata[vindex].counter;
       dt := (now()-lastCounterTime) * 24*3600;
       CalcStdAndMean(Vindex,vindex-StepStartIndex);// vIndex-PrevVindex);
      for il1:= StepStartIndex to vindex do begin
         ch1VoltSeries.AddXY(vdata[il1].time,vdata[il1].data);
      end;
       ch1MeanSeries.AddXY(now,mean);
       ch1stdSeries.AddXY(now,std);
       MeanVoltageSeries.AddXY(now(),mean);
       stdVoltageSeries.AddXY(now(),std);

       StepStr := format('%8.6f %8.6f ',[mean, std]);
    StepStr:=StepStr+' '+
    format(' %.5d %.2d %.8d %.6d %.6d',[CounterStep , cur_val,dstep,vindex+1,stepStartIndex])+' '+
    StringReplace(floattostr(now), ',', '.',[rfReplaceAll, rfIgnoreCase]);
    StepStr := StringReplace(StepStr, ',', '.',[rfReplaceAll, rfIgnoreCase]);
    writetimelog(DataFileName,stepStr);
       memoread.lines[0]:=(DateToStr(now)+' '+TimeToStr(now)+'  '+'Read ok = '+rdstr);
    //   writetimelog(rdstr+#10);
       LastCounterTime:=now;

       StepStartIndex:= vindex+1;
//       wRet := DCON_Clear_Counter(gcPort , StrToInt('$' + Address.Text) , -1 ,StrToInt('$' + edCh.Text),  0, 200);

       GettingData := true;
       start_step := now;
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

end.
