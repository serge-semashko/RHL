unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons,mmsystem, StdCtrls;

type
  Vrecord = record
    Time : double;
    Value : double;
    Counter : int64;
  end;
  TMainForm = class(TForm)
    SpeedButton1: TSpeedButton;
    Memo1: TMemo;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
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
  PrevMTime :dword;
  CurMTime :dword;
  PrevTime :double;
  CurTime :double;
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
  Vdata   : array of vrecord;
  Vindex : integer;

implementation
uses das_const,CommonConstants;
{$R *.dfm}

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
procedure TimerProc(uTimerID, uMessage: UINT; dwUser, dw1, dw2: DWORD) stdcall;
var curPos: TPoint;
  delta:real;
begin
   curtime:=now();
   curmtime:=timegettime();
   writelog( 'dttimer callback='+IntToStr(CurMtime-PrevMTime)+#10);
   writelog( 'dstimer callback='+format('%15.13f',[(Curtime-PrevTime)*24*3600*1000])+#10);
   mainform.Caption:=IntToStr(CurMtime-PrevMTime);
   PrevMTime:= CurMTime;
   PrevTime := CurTime;
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
 setlength(vdata,1000000);
end;

end.
