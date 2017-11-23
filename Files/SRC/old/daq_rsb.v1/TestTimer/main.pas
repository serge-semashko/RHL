unit main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, gpib_user, Adgpib, ComCtrls, ExtCtrls, TeEngine, Series,
  TeeProcs, Chart, Spin, Buttons,mmsystem;

type
  Vrecord = record
    Time : double;
    data : double;
    Counter : int64;
  end;
  TMainForm = class(TForm)
    SpeedButton1: TSpeedButton;
    Memo1: TMemo;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Panel2: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    StartCycle: TSpeedButton;
    cmbGPIB: TComboBox;
    cmbInst: TComboBox;
    Button1: TButton;
    editWrite: TEdit;
    memoRead: TMemo;
    CycBox: TCheckBox;
    DAQlen: TSpinEdit;
    TabSheet2: TTabSheet;
    Panel3: TPanel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    ComComboBox: TComboBox;
    Button2: TButton;
    Edit1: TEdit;
    Memo2: TMemo;
    address: TSpinEdit;
    edCh: TSpinEdit;
    TabSheet3: TTabSheet;
    Panel4: TPanel;
    Label11: TLabel;
    Label12: TLabel;
    Button3: TButton;
    Edit2: TEdit;
    Memo3: TMemo;
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
  TDAQThread = class(TThread)
    Procedure execute;override;
  end;

var
  TimerID :dword;
  MainForm: TMainForm;
  DaqThread : Tdaqthread;
  VoltageChangeTime : double;
  VoltageChangeIndex: INTEGER;
  (*488.2 GPIB global status variables.*)
  ibsta   : Integer;
  iberr   : Integer;
  ibcnt   : Integer;
  ibcntl  : Integer;
  rs485   : thandle = 0;
  iRet, iStatus : Integer;
  iCount        : Integer;
  wRet          : Word ;
   bCfgChg , bComOpen : Boolean ;

  (*488.2 GPIB global status variables.*)
  Vdata   : array of vrecord;
  PrevVindex, Vindex : integer;
  dacval :double;
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

implementation
uses logging, SetMinMax, das_const,i7000,i7000u,dcon_pc ;
{$R *.dfm}
   Procedure CalcStdAndMean(cur, len: integer);

   var
   i  : integer;
   begin
        mean :=0;
        std := 0;
        for i:= cur-len+1 to cur do begin
          mean := mean+ Vdata[i].data;
        end;
        mean := mean / len;
        for i:= cur-len to Vindex do begin
          std := std+ (mean - vdata[i].data)*(mean - vdata[i].data);
        end;
        std := sqrt(std/(len-1));

   end;

procedure TimerProc(uTimerID, uMessage: UINT; dwUser, dw1, dw2: DWORD) stdcall;
var
  curPos: TPoint;
  delta:real;
  wrtbuf, rdbuf: packed array[0..99] of char  ;
  rdstr : string;

begin
   curmtime:=timegettime();
   writeProtocol('#################### DAQ start #####################');
   try

   curtime:=now();
   writeprotocol( 'dstimer callback='+format('%15.13f',[(Curtime-PrevTime)*24*3600*1000]));
   curmtime:=timegettime();
   writeprotocol( 'begin1 dttimer callback=');
//   mainform.Caption:=IntToStr(CurMtime-PrevMTime);
      WriteProtocol('Read counter' );
        wRet := DCON_Read_Counter(gcPort , StrToInt('$' + mainform.Address.Text) , -1 ,StrToInt('$' + mainform.edCh.Text),  0, 200, @cntVal);
        WriteProtocol('check Read counter' );
        If wRet <> 0 Then
        Begin
              writeprotocol('Err: Error reading counter.');
        end else begin
            If (now()-lastCounterTime)*24*3600>20 then begin
                writeprotocol('count std');
                CalcStdAndMean(Vindex-1,10);// vIndex-PrevVindex);
                PrevVIndex := vIndex;
                deltaCounterValue := cntval-lastCounterValue;
                LastCounterValue := cntval;
                LastCounterTime := now();
            end;
        end;

   curmtime:=timegettime();
   writeprotocol( 'counter ok = ');

    strcopy(wrtbuf, pchar('X?'));
    WriteProtocol('ibwrta Write a string command to a GPIB instrument asynchronously using the ibwrta() command');
    ibwrta(dev, @wrtbuf, strlen(wrtbuf));
    WriteProtocol('get globals');

    gpib_get_globals(@ibsta, @iberr, @ibcnt, @ibcntl);
    if (ibsta AND ERR) <> 0 THEN
    begin
      writeprotocol('Err: Error in writing the string command to the GPIB instrument.');
      opError:=true;
      exit;
    end;
    writeprotocol('Answer ok from the GPIB instrument ok. ibcnt = '+IntToStr(ibcnt));
    WriteProtocol('ibWait for the completion of asynchronous write operation' );
    ibwait(dev, CMPL);

    curmtime:=timegettime();
    writeprotocol( 'wait ok = '+IntToStr(CurMtime-PrevMTime));
    WriteProtocol('get globals');

    gpib_get_globals(@ibsta, @iberr, @ibcnt, @ibcntl);
    if (ibsta AND ERR) <> 0 THEN
    begin
      writeprotocol('Err: Writing the string command to the GPIB instrument timeout.');
      opError:=true;
      exit;
    end;
    writeprotocol('Answer ok from the GPIB instrument ok. ibcnt = '+IntToStr(ibcnt));

    WriteProtocol(' //Read the response string from the GPIB instrument asynchronously using the ibrda() command' );
    WriteProtocol('ibrda');
    ibrda(dev, @rdbuf, 100);
    WriteProtocol('get globals');
    gpib_get_globals(@ibsta, @iberr, @ibcnt, @ibcntl);
    if (ibsta AND ERR) <> 0 THEN
    begin
      writeprotocol('Err: Error in reading the response string from the GPIB instrument.');
      opError:=true;
      exit;
    end;
    writeprotocol('Answer ok from the GPIB instrument ok. ibcnt = '+IntToStr(ibcnt));

    WriteProtocol('Wait for the completion of asynchronous read operation');
    ibwait(dev, CMPL);
    WriteProtocol('get globals');
    gpib_get_globals(@ibsta, @iberr, @ibcnt, @ibcntl);
    if (ibsta AND ERR) <> 0 THEN
    begin
      writeprotocol('Err: Reading the string command to the GPIB instrument timeout.');
      opError:=true;
      exit;
    end;
    writeprotocol('Answer ok from the GPIB instrument ok. ibcnt = '+IntToStr(ibcnt));

    rdbuf[ibcnt-1] := chr(0);
    rdstr:=rdbuf+' ';
    rdstr:=system.copy(rdstr,1,pos(' ',rdstr)-1);
    val(rdstr,dacval,resc);
    if resc=0 then Vdata[vIndex].data := dacval
              else Vdata[vIndex].data := -1;;
    rdstr:=rdstr+' '+format(' %8.6f ',[std])+IntToStr(deltaCounterValue)+' '+IntToStr(cntval)+' '+
    intToStr(trunc((now - prevread)*24*3600*1000))+' '+
    StringReplace(floattostr(now), ',', '.',[rfReplaceAll, rfIgnoreCase]);
    prevread := now();
    writetimelog(LogFilename,rdstr);
    writeprotocol(rdstr);
    vdata[vindex+1].counter := cntval;
    vdata[vindex+1].time := now();
    vdata[vindex+1].data := dacval;
    inc(vIndex);
      except
              on E: Exception do begin
                writeprotocol('%%%%%%%%%%%%%%%%% Exceprton on read counter:'+E.Message);
                    mainform.Caption := 'exception!!!!!!!!!!!!!!!!!!!';
                 end;


    end;
    writeProtocol('DAQ end');

   PrevMTime:= CurMTime;
   PrevTime := now;
end;




Procedure TDAQThread.execute;
var
 i: integer;
begin
  while not terminated do begin
   curtime:=now();
   curmtime:=timegettime();
   writelog( 'thread dmtimer ='+IntToStr(CurMtime-PrevMTime)+#10);
   writelog( 'thread dstimer ='+format('%8.6f',[(Curtime-PrevTime)*24*3600*1000])+#10);
   mainform.Caption:=IntToStr(CurMtime-PrevMTime);
   PrevMTime:= CurMTime;
   PrevTime:= CurTime;
    while (timegettime()-PrevMtime)<100 do application.ProcessMessages;
  end;
  mainform.Caption:='terminated';
end;
function timeGetMinPeriod(): DWORD;
var  time: TTimeCaps;
begin
  timeGetDevCaps(Addr(time), SizeOf(time));
  timeGetMinPeriod := time.wPeriodMin;
end;
function timeGetMaxPeriod(): Cardinal;
var time: TTimeCaps;
begin
  timeGetDevCaps(Addr(time), SizeOf(time));
  timeGetMaxPeriod := time.wPeriodMax;
end;
procedure TMainForm.SpeedButton1Click(Sender: TObject);
begin
  Prevmtime := timegettime();
  Timebeginperiod(1);
  memo1.Lines[0]:='Time min period = '+IntToStr(timeGetMinPeriod);
  memo1.Lines.Add('Time max period = '+IntToStr(timeGetMAXPeriod));
  TimerID:=timeSetEvent(100, timeGetMinPeriod, TimerProc, 0, TIME_CALLBACK_FUNCTION or TIME_PERIODIC);

end;

procedure TMainForm.SpeedButton2Click(Sender: TObject);
begin
 daqthread := tdaqthread.Create(true);
 daqthread.Resume;
end;

procedure TMainForm.SpeedButton3Click(Sender: TObject);
begin
 daqthread.Terminate;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
var
 i: integer;
begin
  timeKillEvent(TimerID);
  while (timegettime()-PrevMtime)<500 do application.ProcessMessages;
end;
procedure TMainForm.FormCreate(Sender: TObject);
begin
  cmbGPIB.ItemIndex := 0;
  cmbInst.ItemIndex := 15;
  memoRead.Text := '';
  setlength(vdata,1000000);
     gcDataBit  := Char(8);      // 8 data bit
     gcParity   := Char(0);      // Non Parity
     gcStopBit  := Char(0);      // One Stop Bit
     bCOMOpen   := False;
     bCfgChg    := False;
     gszSend    := StrAlloc( 100 );
     gszReceive := StrAlloc( 100 );
     restorecomponents(self);
 setlength(vdata,1000000);
end;

end.
