
Program ELSTAT_COLLEC_DISPLAY_SPEC_RATIO_SAVE_1139_DATRON_NORMAL_EXP;

{***************************************************************************}
{                     P.A.Petev, V.T.Sidorov                                }
{         AUTOMATION OF ELECTROSTATIC BETA-SPECTROMETER (ver.2.1)           }
{    This programme realizes collection, visualization and saving of the    }
{ electrostatic BETA-spectrometer spectrum. It controls two voltages (slow- }
{ ing down U and analysing u) independent and in ratio throut the paralell  }
{ interface of IBM PC and two independent DACs (AD1139 and AD669) and gives }
{ information about the basic parameters of the experiment and the remainder}
{ of experiment time.                                                       }
{***************************************************************************}

{$M 16384,10000,30000}

uses UStC3969,tpCRT,TPEdit,TPInLine,DOS, tpString,
     TpWindow,FileProc,BGIDriv,graph;

const
 BufArraySize            = 4095;
 FullBufLen              = BufArraySize+400;
 Iflag     : byte        = 0;
 flag      : byte        = 0;
 flag1     : byte        = 0;
 Waitflag  : byte        = 0;
 Regflag   : byte        = 0;
 RealFlag  : byte        = 0;
var
 OldExit,OldInt1C,OldInt28                                    : pointer;
 uper,RemMinPr,Time,MesTime,DeadTime,WriteTime,Interval,WTime,
 RegInterval,RegTime,CCh,RealT,RealTime,Hrono                 : longint;
 SpectrumSaved, MeasuringState,StopMeasuring,OperInt,Removed,
 alter                                                        : boolean;
 a                                                            : char;
 i,za                                                         : integer;

const
 x0=0; y0=62; xlen=400; dx=404; dy=280;
 F1      = #59;
 ALTF1   = #104;
 CTRLF1  = #94;
 CTRLF2  = #95;
 F2      = #60;
 CTRLF3  = #96;
 F3      = #61;
 F4      = #62;
 CTRLF4  = #97;
 F5      = #63;
 F7      = #65;
 F9      = #67;
 CTRLF5  = #98;
 PgUpKey = #73;
 PgDnKey = #81;
 CTRLPgUpKey = #132;
 CTRLPgDnKey = #118;
 CTRLLeftKey = #115;
 CTRLRightKey= #116;
 LeftKey     = #75;
 RightKey    = #77;
 DEL         = #83;

var
 op                                             : fillpatterntype;
 vp                                             : viewportType;
 SBuf                                           : array[0..450] of longint;
 s                                              : string;
 GraphDriver,GraphMode,x,y,mx,my,W0,
 MaxChannels,ibc                                : integer;
 FulHour, FulMin,ii,RemHour,Mtim,Dtim,RemMin    : longint;
 SMark,SxMark,WxMark,SpectrumLength,Wlen,
 dySP,dyWIN,WindowStep, SpMaxYmult,WinMaxYmult,
 WinPixelColor,SpPixelColor,l,r,step            : word;
 SpLog,WinLog,SpectrumOn,WindowOn,
 bak,HelpDisp,InfWinDisp,InitInfDisp            : boolean;
 Spectrum,Swindow,MarkSpStep,MarkWindStep,
 SpectrumShift,WindowShift,SpectrumMult,
 WindowMult,SpYmask,WinYmask,SpXStep,
 SpectrumGraphColor,WindowGraphColor,
 SpectrumMarkerColor,WindowMarkerColor,
 SpWinColor,TeColor,DataColor,MenuColor         : byte;


var
 textbuf                              : array[0..511] of char;
 Buf                                  : array [0..FullBufLen] of longint;
 Te                                   : array[1..20] of string;
 Increasing,RelYes,VarU,SFopen                                 : boolean;
 FulTim,Rel,ubeg,u,Mtime,Dtime,
 TempTicks,WrTime,RemTim,tmpw,RegInt,code1,code2               : real;
 Crate,CtrlAttr                                                : byte;
 tdat,ChannelsToMeasure,Base, NKA1, NKA2, NKS,
 A0F0,A0F1,A0F2,A0F8,A0F9,A0F10,A0F16,A0F17,A0F24,A0F25,A0F26,
 A1F0,A1F1,A1F2,A1F8,A1F9,A1F10,A1F16,A1F17,A1F24,A1F25,A1F26,
 A2F0,A2F1,A2F2,A2F8,A2F9,A2F10,A2F16,A2F17,A2F24,A2F25,A2F26,
 A3F0,A3F1,A3F2,A3F8,A3F9,A3F10,A3F16,A3F17,A3F24,A3F25,A3F26,
 written,RTim,WrTim,Wrt,RunningWrt,CurrentChannel             : word;
 SpectrumFileName                                             : string;
 SpectrumFile                                                 : file;


Function SetCAMACinterface: boolean;
begin
 A0F0:=  0;                A1F0:=  64;
 A0F1:=  2;                A1F1:=  64+ 2;
 A0F8:=  8*2;              A1F8:=  64+ 8*2;
 A0F9:=  9*2;              A1F9:=  64+ 9*2;
 A0F10:= 10*2;             A1F10:= 64+10*2;
 A0F16:= 16*2;             A1F16:= 64+16*2;
 A0F17:= 17*2;             A1F17:= 64+17*2;
 A0F24:= 24*2;             A1F24:= 64+24*2;
 A0F25:= 25*2;             A1F25:= 64+25*2;
 A0F26:= 26*2;             A1F26:= 64+26*2;
 mem[Base:Crate*16+4]:=1;                        {init crate}
 mem[Base:Crate*16+2]:=1;                        {select  crate}
 {
 if ((mem[Base:Crate*16+5] and 1) = 0) then
   begin
    writeln('   Can''t select Crate ');
    SetCAMACinterface:=false
   end
    else
 }
   SetCAMACinterface:=true;
 mem[Base:$79]:=0;                             { Mult. Crate CAMAC Z }
end; {SetCAMACinterface}

Procedure CAMZ;
begin
 mem[Base:$79]:=0;                             { Mult. Crate CAMAC Z }
end; {CAMZ}

Procedure ResetCAMACInhibit;
begin
 mem[Base:$7F]:=0;
end; {ResetCAMACInhibit}

Procedure SetCAMACInhibit;
begin
 mem[Base:$7D]:=0;
end; {SetCAMACInhibit}


Procedure GetConfigFile(Name: string);
const
 ParamName: array[1..5] of string=
 ('CRATE=','BASE=','NKA110A=','NKA110B=','NCOUNTER=');
var
 OK: boolean; f: text; i: byte;
 CFG: array [1..5] of string;
 Param: array[1..5] of word;

Procedure CFGerror;
begin
 writeln('Config file Error !!!'); writeln;
 writeln(' It must consists of 5 lines with such format:');
 WriteLn(' CRATE=0');
 WriteLn(' BASE=$D000');
 WriteLn(' NKA110A=5');
 WriteLn(' NKA110B=6');
 WriteLn(' NCounter=12');
 Halt(1);
end;{CFGerror}

Procedure GetParam(ParCount: byte);
var
 b,j: byte; s: string;
 code: word;
begin
 Ok:=true;
 for j:=1 to ParCount do
 begin
  i:=0;
  Repeat inc(i);
   b:=pos(ParamName[j],CFG[i]);
  Until (b<>0) or (i=ParCount);
  if (b=0) and (i=ParCount) then OK:=false else
   begin
    s:=copy(CFG[i],b+Length(ParamName[j]),
       Length(CFG[i])-b-Length(ParamName[j])+1);
    val(s,Param[j],code);
    if code<>0 then OK:=false;
   end;
 end;
 if not OK then CFGerror;
end;{GetParam}

begin
 if not FileExists(Name) then
  begin
   Writeln(' Config file ',Name,' not found');
   Halt(1);
  end;
 Assign(F,Name);
 Reset(F);
 i:=0;
 Repeat
  inc(i);
  Readln(f,CFG[i]);
  CFG[i]:=StUpCase(CFG[i]);
 Until (i=5) or EOF(F);
 Close(F);
 if i<5 then CFGerror;
 GetParam(5);
 Crate:=Lo(Param[1]); Base:=Param[2];
 NKA1:=$400*Param[3]; NKA2:=$400*Param[4]; NKS:=$400*Param[5];
end;{GetConfigFile}

Function TimeIsOver: boolean;
begin
 TimeIsOver:=(Iflag<>0);
end;{Function TimeIsOver}

Function CounterCode: longint;
var
 l: longint;
begin
 SetCAMACinhibit;
 l:=memw[Base:NKS+A1F0] * 65536;
 l:=l+memw[Base:NKS+A0F0];
 tdat:=mem[Base:NKS+A0F9];
 tdat:=mem[Base:NKS+A1F9];
 CounterCode:=l;
end;{CounterCode}

Procedure InitCAMAC;
begin
 CAMZ;
 tdat:=memw[Base:NKS+A0F26];
 tdat:=memw[Base:NKS+A1F26];
 tdat:=mem[Base:NKS+A0F9];     {Clear Counter}
 tdat:=mem[Base:NKS+A1F9];
end;{InitCAMAC}

Function OpenFile(var F:file; RecSize:word; Name:string): boolean;
begin
 Assign (F,Name);
 {$I-} Rewrite (F,RecSize); {$I+}
 If IOResult <> 0 then
  begin
   Writeln ('Can''t create file  ',Name);
   OpenFile:=false;
  end
   else OpenFile:=true;
end;{OpenFile}

Function FileNameReady(Name: string): boolean;
var y: boolean;
begin
 y:=true;
 if FileExists(Name) then
  begin
   Sound(500); delay(100); NoSound;
    if not YesOrNo('File already exists! OverWrite ?',
                whereY,whereX,LightGreen,'N')
     then y:=false;
   WriteLn;
  end;
 FileNameReady:=y;
end;{FileNameReady}


Procedure TinyEd(lines: byte);
  var
   x,y,i,b       : byte;
   l             : word;
   escaped       : boolean;
   s             : string[80];
   s1,s2,s3,s4   : string[6];
  begin
    for i:=1 to 20 do te[i]:='';
    TextBackGround(black);
    ClearFirstChar:=false;
    str(Ibeg:7:2,s1); str(Iend:7:2,s2);str(Istep:3:2,s3);
    Te[1]:='Channels(volts): Start='+ s1 + ', End='+ s2 + ', Step='+ s3 + ',';
       FastWrite(Te[1],5,4,yellow);
    str(u:4:2,s1); str(ChannelsToMeasure,s2); str(Rel,s3);
    if RelYes=false then
      Te[2]:='Constant voltage='+ s1 + ', Channels to measure='+ s2
     else Te[2]:='Ratio='+ s3 + ', Channels to measure='+ s2 ;
       FastWrite(Te[2],6,4,yellow);
    str(Mtime:4:1,s1); str(Dtime:4:1,s2); str(FulHour,s3); str(FulMin,s4);
    Te[3]:='Experiment time: Exposition='+s1+'s, Dead='+s2+
                                   's, Full time= '+s3+'h.'+s4+'min.';
       FastWrite(Te[3],7,4,yellow);

    Repeat
     y:=4;
      Repeat
       str(y:2,s);
       ReadString('Line '+s+': ',21,4,49,red,yellow,white,escaped,Te[y]);
       FastWrite('                                     '+
             '                              ',y+4,4,cyan);
       FastWrite(Te[y],y+4,4,yellow);
       L:=0;
       for i:=1 to 20 do
         begin
           inc(L,Length(Te[i]));
           if Length(Te[i])>0 then inc(l,2);
         end;
       str(l:4,s);
       FastWrite('Symbols: '+s,lines+5,24,red*16+white);
       inc(y);
      Until (Escaped) or (y=lines+1);
       FastFill(80,' ',23,1,lightcyan);
    Until (YesOrNo('Is it OK(must be <=512 symbols) ?',
               17,5,White,'n')and (L<=512));
     for i:=1 to 20 do
       begin
         if Length(Te[i])>0 then Te[i]:=Te[i]+#13+#10;
       end;
  end;{TinyEd}

Procedure SetAbout;
const
 PAttr=LightCyan; SAttr= yellow;
 CTRLF10=$6700; CTRLC=$2E03;
var
 b,escaped: boolean;
 p:pointer;
 i,i1: word;
 l,l1: byte;
 Y: boolean;
 sti: string[16];
begin
 TextBackGround(LightGray); clrscr;
 gotoXY(50,23);write('P.Petev,V.Sidorov(okt.1996)');

 Shadow:=True; Explode:=True; ExplodeDelay:=25; SoundFlagW:=False;
 b:=MakeWindow(p,2,2,77,22,True,True,False,Blue,Blue*16+White,Red*16+White,
          '***  ELECTROSTATIC SPECTROMETER CONTROL PROGRAMME v3.1  ***');
 b:=DisplayWindow(p);
         TextColor(Yellow);
         gotoxy(1,6);
 Writeln('            AUTOMATION OF ELECTROSTATIC BETA-SPECTROMETER (ver.3.1)');
 Writeln('    This programme realizes collection, visualization  and saving of the');
 Writeln(' electrostatic BETA-spectrometer spectrum.It controls two voltages (slow-');
 Writeln(' ing down U and analysing u) independent and in ratio throut the paralell');
 Writeln(' interface of the IBM PC and two independent DACs (AD1139 and AD669) and');
 Writeln(' gives information about  the basic parameters  of the experiment and the');
 Writeln(' remainder of the experiment time.');
 Writeln('    To begin the experiment you have to ramp up/down the initial voltage ');
 Writeln(' to the start value and to set the basic parameters and conditions of the');
 Writeln(' experiment and spectrum.');
 Writeln('');
 Writeln('                     Press any key to continu...');
 repeat
 until  keypressed;
 Delay(300);
 KillWindow(p);
 Delay(500);
 TextBackGround(BLack);
 clrscr;
end;


Procedure Warn1;
var escaped:boolean;
begin
  TextColor(LightRed);
  gotoxy(2,6);
  Writeln('Please wait ');
  CurrentCode:=Ibeg;
  if Increasing then
             begin
               repeat
                  CurrentCode:=CurrentCode+Istep;
                  if CurrentCode<=45000 then
                         begin
                            gotoxy(2,7);
                            Writeln(CurrentCode:5:0);
                            SetChannelCode10(CurrentCode);
                            Delay(5000);
                            if Keypressed then Halt(1);
                         end
                            else Halt(1);
              until CurrentCode>=Iend
             end
          else
             begin
               repeat
                  if CurrentCode>=100 then
                                        CurrentCode:=CurrentCode-Istep
                                    else
                                        CurrentCode:=CurrentCode-10;
                  gotoxy(2,7);
                  if CurrentCode>=10 then
                                      begin
                                       SetChannelCode10(CurrentCode);
                                       Writeln(CurrentCode:5:2);
                                      end
                                     else
                                      begin
                                        CurrentCode:=5;
                                        SetChannelCode10(CurrentCode);
                                      end;
                  if CurrentCode>=100 then Delay(12500) else Delay(5000);
                  if Keypressed then Halt(1);
               until (CurrentCode<=Iend) or (CurrentCode=5);
             end;
end; {Warn1}

Procedure Warn2;
var escaped:boolean;
begin
  TextColor(LightRed);
  gotoxy(2,13);
  Writeln('Please wait ');
  CurrentCode:=Ibeg;
  if Increasing then
             begin
               repeat
                  CurrentCode:=CurrentCode+Istep;
                  if CurrentCode<=45000 then
                                          begin
                                            gotoxy(2,14);
                                            Writeln(CurrentCode:5:0);
                                            SetChannelCode20(CurrentCode);
                                            Delay(5000);
                                            if Keypressed then Halt(1);
                                          end
                                        else Halt(1);
              until CurrentCode>=Iend
             end
          else
           begin
             repeat
               if CurrentCode>=100 then
                                     CurrentCode:=CurrentCode-Istep
                                   else
                                     CurrentCode:=CurrentCode-5;
               gotoxy(2,14);
               if CurrentCode>=10 then
                                   begin
                                    SetChannelCode20(CurrentCode);
                                    Writeln(CurrentCode:5:2);
                                   end
                                  else
                                      begin
                                        CurrentCode:=5;
                                        SetChannelCode20(CurrentCode);
                                      end;
               if CurrentCode>=100 then Delay(12500) else Delay(5000);
               if Keypressed then Halt(1);
               until (CurrentCode<=Iend) or (CurrentCode=5);
          end;
end; {Warn2}


Procedure SetInitHV;
const
 PAttr=LightCyan; SAttr= yellow;
 CTRLF10=$6700; CTRLC=$2E03;
var
 b,escaped: boolean;
 w: word;
 p:pointer;
 i,i1: word;
 l,l1: byte;
 Y: boolean;
 sti: string[16];
begin
 TextBackGround(LightGray); clrscr;
 gotoXY(50,23);write('P.Petev,V.Sidorov(okt.1996)');
 Shadow:=True; Explode:=True; ExplodeDelay:=25; SoundFlagW:=False;
 b:=MakeWindow(p,2,2,77,22,True,True,False,Blue,Blue*16+White,Red*16+White,
          '***   INITIALIZATION OF THE SYSTEM  ***');
 b:=DisplayWindow(p);
  if YesOrNo('Did you chack config file and High voltage(must be turn on)? (Y/N)',3,4,Yellow,'n') then
 begin
  repeat
  clrscr;
if YesOrNo('Will you initialize the Slowing-Down voltage?(Y/N)',3,4,Yellow,'n') then
     begin
      repeat
        ReadReal('Currunt value of the Slowing-down Voltage (Ubeg) (V <0..49999>): ',
               4,4,5,PAttr,SAttr,4,0.0,49999.0,escaped,Ibeg);
        if Escaped then Halt(1);
        ReadReal('Start value of the Slowing-down Voltage (Uend) (V <0..49999>): ',
              5,4,5,PAttr,SAttr,4,0.0,49999.0,escaped,Iend);
        if Escaped then Halt(1);
        ReadReal('Ramp up/down step (Ustep) (V <1..5000>): ',
               6,4,4,PAttr,SAttr,4,1.0,5000.0,escaped,Istep);
        if Escaped then Halt(1);
        Increasing:=(Iend>=Ibeg);
      Until YesOrNo('OK ?(Y/N)',7,4,PAttr or White,'n');
     Warn1;
     Ibeg:=Iend;
    end;
      Until YesOrNo('OK ?(Y/N)',10,4,PAttr or White,'n');
    repeat

if YesOrNo('Will you initialize the Analysing voltage?(Y/N)',10,4,Yellow,'n') then
      begin
       repeat
        ReadReal('Currunt value of the Analysing Voltage (ubeg) (V <0..4999>): ',
               11,4,5,PAttr,SAttr,4,0.0,4999.0,escaped,Ibeg);
        if Escaped then Halt(1);
        ReadReal('Start value of the Analysing Voltage (uend) (V <0..4999>): ',
              12,4,5,PAttr,SAttr,4,0.0,4999.0,escaped,Iend);
        if Escaped then Halt(1);
        ReadReal('Ramp up/down step (ustep) (V <1..100>): ',
               13,4,3,PAttr,SAttr,4,1.0,100.0,escaped,Istep);
        if Escaped then Halt(1);
        Increasing:=(Iend>=Ibeg);
      Until YesOrNo('OK ?(Y/N)',14,4,PAttr or White,'n');
     Warn2;
    end;
       Until YesOrNo('OK ?(Y/N)',17,4,PAttr or White,'n');
     end
   else Halt(1);
 Delay(300);
 KillWindow(p);
 Delay(500);
 TextBackGround(BLack);
 clrscr;
end;{SetInitHV}

Procedure KillHV;
const
 PAttr=LightCyan; SAttr= yellow;
 CTRLF10=$6700; CTRLC=$2E03;
var
 b,escaped: boolean;
 w: word;
 p:pointer;
 i,i1: word;
 l,l1: byte;
 Y: boolean;
 sti: string[16];
begin
 TextBackGround(LightGray); clrscr;
 gotoXY(50,23);write('P.Petev,V.Sidorov(okt.1996)');
 Shadow:=True; Explode:=True; ExplodeDelay:=25; SoundFlagW:=False;
 b:=MakeWindow(p,2,2,77,22,True,True,False,Blue,Blue*16+White,Red*16+White,
          '***   FINAL OPERATIONS  ***');
 b:=DisplayWindow(p);
  if YesOrNo('Will you kill the Slowing-Down voltage?(Y/N)',3,3,Yellow,'n') then
     begin
      repeat
        ReadReal('Currunt value of the Slowing-down Voltage (Ubeg) (V <0..49999>): ',
               4,3,7,PAttr,SAttr,1,0.0,49999.0,escaped,Ibeg);
        if Escaped then Halt(1);
        ReadReal('Target value of the Slowing-down Voltage (Uend) (V <0..49999>): ',
              5,3,7,PAttr,SAttr,1,0.0,49999.0,escaped,Iend);
        if Escaped then Halt(1);
        ReadReal('Ramp up/down step (Ustep) (V <1..500>): ',
               6,3,7,PAttr,SAttr,1,1.0,500.0,escaped,Istep);
        if Escaped then Halt(1);
        Increasing:=(Iend>=Ibeg);
      Until YesOrNo('OK ?(Y/N)',7,3,PAttr or White,'n');
     Warn1;
    end;

      if YesOrNo('Will you kill the Analysing voltage?(Y/N)',10,3,Yellow,'n') then
      begin
       repeat
        ReadReal('Currunt value of the Analysing Voltage (ubeg) (V <0..4999>): ',
               11,3,5,PAttr,SAttr,1,0.0,4999.0,escaped,Ibeg);
        if Escaped then Halt(1);
        ReadReal('Target value of the Analysing Voltage (uend) (V <0..4999>): ',
              12,3,5,PAttr,SAttr,1,0.0,4999.0,escaped,Iend);
        if Escaped then Halt(1);
        ReadReal('Ramp up/down step (ustep) (V <1..100>): ',
               13,3,3,PAttr,SAttr,1,1.0,100.0,escaped,Istep);
        if Escaped then Halt(1);
        Increasing:=(Iend>=Ibeg);
      Until YesOrNo('OK ?(Y/N)',14,4,PAttr or White,'n');
     Warn2;
    end;
 Delay(300);
 KillWindow(p);
 Delay(500);
 TextBackGround(BLack);
 clrscr;
end;{KillHV}

Procedure Dialog;
const
 PAttr=LightCyan; SAttr= yellow;
 CTRLF10=$6700; CTRLC=$2E03;
var
 b,escaped: boolean;
 w: word;
 p:pointer;
 i,i1: word;
 l,l1: byte;
 Y: boolean;

begin
 TextBackGround(LightGray); clrscr;
 gotoXY(50,23);write('P.Petev,V.Sidorov(nov.1996)');
 Shadow:=True; Explode:=True; ExplodeDelay:=25; SoundFlagW:=False;
 b:=MakeWindow(p,2,2,77,22,True,True,False,Blue,Blue*16+White,Red*16+White,
          '***  EXPERIMENT PARAMETERS  ***');
 b:=DisplayWindow(p);
    Repeat
     Repeat
      clrscr;

      if YesOrNo('Varying the slowing-down voltage U ? (Y/N)',
                               4,4,PAttr or White,'n') then
       begin
        VarU:=True;
        ReadReal('Start Slowing-down Voltage (Ubeg) (V <0.1...49999>): ',
               4,4,7,PAttr,SAttr,1,0.1,49999.0,escaped,Ibeg);
        if Escaped then Halt(1);
        ReadReal('End Slowing-down Voltage (Uend) (V <0.1..49999>): ',
              5,4,7,PAttr,SAttr,1,0.1,49999.0,escaped,Iend);
        if Escaped then Halt(1);
        ReadReal('Step (Ustep) (V <0.1..500>): ',
               6,4,5,PAttr,SAttr,2,0.1,500.0,escaped,Istep);
        if Escaped then Halt(1);
        if YesOrNo('Ratio U/u ? (Y/N)',7,4,PAttr or White,'n') then
          begin
             ReadReal('Ratio U/u ( <0.0001..10000>): ',
             7,4,7,PAttr,SAttr,4,0.0001,10000.0,escaped,Rel);
             if Escaped then Halt(1);
             RelYes:= true;
             ubeg:=Trunc(Ibeg/Rel);
          end
        else
          begin
            RelYes:= false;
            ReadReal('Analysing Voltage (u) (V <0.1...1000>): ',
               7,4,5,PAttr,SAttr,1,0.1,4999.0,escaped,u);
            ubeg:=u;
            if Escaped then Halt(1);
          end
       end
   else
       begin
        VarU:=False;
        ReadReal('Start Analysing Voltage (ubeg) (V <5..1000>): ',
               4,4,5,PAttr,SAttr,1,5.0,1000.0,escaped,Ibeg);
        if Escaped then Halt(1);
        ReadReal('End Analysing Voltage (uend) (V <5..1000>): ',
               5,4,5,PAttr,SAttr,1,5.0,1000.0,escaped,Iend);
        if Escaped then Halt(1);
        ReadReal('Step (ustep) (V <0.1..10>): ',
               6,4,3,PAttr,SAttr,1,1.0,10.0,escaped,Istep);
        if Escaped then Halt(1);
        if YesOrNo('Ratio U/u ? (Y/N)',7,4,PAttr or White,'n') then
          begin
             ReadReal('Ratio U/u ( <0.0001..10000>): ',
             7,4,7,PAttr,SAttr,4,0.0001,10000.0,escaped,Rel);
             if Escaped then Halt(1);
             RelYes:= true;
             Ubeg:=Trunc(Ibeg/Rel);
          end
        else
          begin
            RelYes:= false;
            ReadReal('Slowing-down Voltage (U) (V <0..49999>): ',
               7,4,7,PAttr,SAttr,1,0.1,49999.0,escaped,U);
            Ubeg:=U;
            if Escaped then Halt(1);
          end
      end;

   Increasing:=(Iend>=Ibeg);
   if Increasing then ChannelsToMeasure:=Round((Iend-Ibeg)/Istep)+1
      else  ChannelsToMeasure:=Round((Ibeg-Iend)/Istep)+1;

   if VarU then
      begin
         TextColor(LightRed);
         gotoxy(1,6);
         Writeln('     Ubeg  - ',Ibeg:7:1,' V');
         Writeln('     Uend   - ',Iend:7:1,' V');
         Writeln('     Step   - ',Istep:3:1,' V');
         Write('     Alteration - ');
         if Increasing then writeln('Up') else writeln('Down');
         Writeln('     Channels - ',ChannelsToMeasure);
         if RelYes then Writeln('     Ratio - ',Rel:4:4)
         else Writeln('     u - ',u:4:1,' V');
       end
    else
       begin
         TextColor(Yellow);
         gotoxy(1,6);
         Writeln('     ubeg  - ',Ibeg:7:1,' V');
         Writeln('     uend   - ',Iend:7:1,' V');
         Writeln('     Step   - ',Istep:3:1,' V');
         Write('     Alteration - ');
         if Increasing then writeln('Up') else writeln('Down');
         Writeln('     Channels - ',ChannelsToMeasure);
         if RelYes then Writeln('     Ratio - ',Rel:4:4)
         else Writeln('     U - ',U:7:1,' V');
       end;

  Until YesOrNo('OK ?(Y/N)',14,4,PAttr or White,'n');

   ReadReal('Exposition time for channel(sec<0.01 to 200000>: ',
               14,4,9,PAttr,SAttr,2,0.01,200000.0,escaped,MTime);
   writeln;
   TempTicks:=(MTime/65536)*1193180;
   MesTime:=Round(TempTicks);

   ReadReal('Dead time for channel(sec < 0.01 to 200000>: ',
               15,4,10,PAttr,SAttr,2,0.01,200000.0,escaped,DTime);
   TempTicks:=(DTime/65536)*1193180;
   DeadTime:=Round(TempTicks);
   FulTim:=(MTime+DTime)*ChannelsToMeasure;   {Seconds to measure}

   TextColor(LightRed);
   GotoXY(3,14);

   Write(' Full time for this measure will be about ');
   TextColor(Yellow);
   FulHour:=Trunc(FulTim/3600);
   FulMin:=Round((FulTim-Trunc(FulTim/3600)*3600)/60);
   WriteLn(FulHour,' h. ', FulMin ,' min.');


  Until YesOrNo('Continue ?(Y/N)',17,4,PAttr or White,'n');
 Writeln('========================================================');
  Repeat
   Repeat
    TextColor(Lightcyan);clrscr;
    ReadString('Spectrum file Name: ',3,4,12,lightcyan,
                       yellow,white,escaped,SpectrumFileName);
 y:=true;
 if FileExists(SpectrumFileName) then
  begin
   Sound(500); delay(100); NoSound;
    if not YesOrNo('File already exists! OverWrite ?',
                whereY+3,whereX+3,LightGreen,'N')
     then y:=false;
  end;
  Until y;
 Until OpenFile(SpectrumFile,1,SpectrumFileName);
   SFopen:=true;
   gotoXY(2,2);
   Write('Write spectrum description text(up to 512 symbols): ');
   TinyED(10);
   for i:=0 to 511 do textbuf[i]:=' '; i:=0;
   for l:=1 to 10 do
    begin
     if Te[l]<>'' then
      for l1:=1 to Length(Te[l]) do
       begin
        textbuf[i]:=Te[l][l1];
        inc(i);
       end;
    end;
 clrscr;

 ReadReal('In how much minutes must save spectrum (min<1..300>): ',
               4,4,5,PAttr,SAttr,2,1.0,300.0,escaped,WrTime);
 if Escaped then Halt(1);
 TempTicks:=(WrTime*60/65536)*1193180;
 WriteTime:=Round(TempTicks);

 ReadReal('In how much seconds must realize regulation(sec<1..60>): ',
               5,4,4,PAttr,SAttr,2,1.0,60.0,escaped,RegInt);
 if Escaped then Halt(1);
 TempTicks:=(RegInt/65536)*1193180;
 RegInterval:=Round(TempTicks);

 WriteLn;
 Writeln;
 Writeln;
 TextColor(LightRed);
 Write(' CHACK THE HIGH VOLTAGE AND THEN PRESS ');
 TextColor(yellow); Write('CTRL/F10');
 Repeat w:=ReadKeyWord; until (w=CTRLF10) or (w=CTRLC);
 if w=CtrlC then Halt(1);
 if not YesOrNo('Let us start ?(Y/N)',7,4,PAttr or White,'n')
    then Halt(1);
 Delay(300);
 KillWindow(p);
 Delay(500);
 TextBackGround(BLack);
 clrscr;
end;{Dialog}

Procedure WriteFile;
var y:boolean;
begin
  assign(SpectrumFile,SpectrumFileName);
 {$I-} Rewrite (SpectrumFile,1); {$I+}
  if not(IOResult=0) then rewrite(SpectrumFile);
   BlockWrite(SpectrumFile, textBuf,512+4096*4,Written);
   Y:=(Written=512+4096*4);
   if not Y then Writeln('Disk full - file not written !!!');
   SpectrumSaved:=true;
   close(SpectrumFile);
end;{WriteFile}


Procedure FullViewPort;
begin
 SetViewPort(x0+2,y0+1,x0+dx-1,y0+dy-1,ClipOn);
end;{FullViewPort}

Procedure ClearMarker(Where: Char);
begin
 if Where='W' then
  begin
   mx:=WxMark*(Xlen div Wlen);
   if WinLog then
    begin
     if Buf[W0+WxMark]=0 then my:=dyWIN
      else my:=dyWIN-(Trunc(Ln(Buf[W0+WxMark])*WindowMult));
    end
     else my:=dyWIN-((Buf[W0+WxMark] shr WindowShift) and WinYmask);
  end
   else
  begin
   mx:=SxMark;
   if SpLog then
    begin
     if SBuf[SxMark]=0 then my:=dySP
      else my:=dySP-(Trunc(Ln(SBuf[SxMark])*SpectrumMult));
    end
     else my:=dySP-((SBuf[SxMark] shr SpectrumShift) and SpYmask);
  end;
  PutPixel(mx,my-1,Black);
  PutPixel(mx,my+1,Black);
  if Where='W' then PutPixel(mx,my,WinPixelColor) else PutPixel(mx,my,SpPixelColor);
end;{ClearMarker}
{>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>}
Procedure WindowMarkerText;
begin
 TextColor(DataColor);
 if Increasing then tmpw:=Ibeg + Istep*(W0+WxMark) else
                       tmpw:=Ibeg - Istep*(W0+WxMark);
 gotoXY(60,9);
 write(W0+WxMark:4,'(',tmpw:5:1,'V)=',Buf[W0+WxMark]:7);
end;{WindowMarkerText}

Procedure SpectrumMarkerText;
begin
 TextColor(DataColor);
 gotoXY(60,17);
 if Increasing then tmpw:=Ibeg + Istep*SMark else
                       tmpw:=Ibeg - Istep*SMark;
 write(SMark:4,'(',tmpw:5:1,'V)=',Buf[SMark]:7);
end;{SpectrumMarkerText}
{<<<<<<<<<<<<<<<<<<<<<<<<<<}
Procedure SetMarker(Where: Char);
var mColor: byte;
begin
 if Where='W' then
  begin
   mx:=WxMark*(Xlen div Wlen);
   if WinLog then
    begin
     if Buf[W0+WxMark]=0 then my:=dyWIN
      else my:=dyWIN-(Trunc(Ln(Buf[W0+WxMark])*WindowMult));
    end else
     my:=dyWIN-((Buf[W0+WxMark] shr WindowShift) and WinYmask);
   WindowMarkerText;
  end
   else
  begin
   mx:=SxMark;
   if SpLog then
    begin
     if SBuf[SxMark]=0 then my:=dySP
      else my:=dySP-(Trunc(Ln(SBuf[SxMark])*SpectrumMult));
    end else
     my:=dySP-((SBuf[SxMark] shr SpectrumShift) and SpYmask);
   SpectrumMarkerText;
  end;
  if Where='W' then
   begin
    mColor:=WindowMarkerColor;
    WinPixelColor:=GetPixel(mx,my);
   end
    else
     begin
      mColor:=SpectrumMarkerColor;
      SpPixelColor:=GetPixel(mx,my);
     end;
  PutPixel(mx,my-1,mColor);
  PutPixel(mx,my,mColor);
  PutPixel(mx,my+1,mColor);
end;{SetMarker}

Procedure RedrawSpectrum;
begin
 if Spectrum=0 then exit;
 if SWindow=1 then SetViewPort(x0+2,y0+dySP-128,x0+2+Xlen,y0+dySP,Clipon);
 ClearViewPort;
 FullViewPort;
 for x:=0 to xlen+45 do
  begin
   SBuf[x]:=0;
   for i:=0 to SpXStep-1 do SBuf[x]:=SBuf[x]+Buf[x*SpXStep+i];
   SBuf[x]:=SBuf[x] div SpXStep;
  end;
 if SpLog then
  begin
  for x:=0 to Xlen-1 do
   begin
    if SBuf[x]=0 then PutPixel(x,dySP,SpectrumGraphColor) else
     PutPixel(x,dySP-(Trunc(Ln(SBuf[x])*SpectrumMult)),
                         SpectrumGraphColor);
   end;
   if SWindow=1 then for x:=W0 div SPxStep to
          (W0 div SPxStep)+(Wlen div SPxStep) do
    if SBuf[x]=0 then PutPixel(x,dySP,SpWinColor) else
         PutPixel(x,dySP-(Trunc(Ln(SBuf[x])*SpectrumMult)),SpWinColor);
   end
 else
  begin
   for x:=0 to xlen do PutPixel(x,dySP-((SBuf[x] shr SpectrumShift)
                                    and SpYmask),SpectrumGraphColor);
   if SWindow=1 then for x:=W0 div SPxStep to
          (W0 div SPxStep)+(Wlen div SPxStep) do            {!}
     PutPixel(x,dySP-((SBuf[x] shr SpectrumShift) and SpYmask),SpWinColor);
  end;
 SetMarker('S');
end;{RedrawSpectrum}

Procedure RedrawWindow;
begin
 if dyWIN=0 then exit;
 if Spectrum=1 then SetViewPort(x0+2,y0+1,x0+2+Xlen,y0+2+dyWIN,ClipOn);
 ClearViewPort;
 FullViewPort;
 if WinLog then
  for x:=0 to Wlen-1 do
   if Buf[W0+x]=0 then PutPixel((x*(Xlen div Wlen)),dyWIN,WindowGraphColor)
    else PutPixel((x*(Xlen div Wlen)),dyWIN-(Trunc(Ln(Buf[W0+x])*WindowMult)),WindowGraphColor)
 else
  for x:=0 to Wlen-1 do PutPixel((x*(Xlen div Wlen)),dyWin-((Buf[x+W0] shr WindowShift)
                                   and WinYmask),WindowGraphColor);
 SetMarker('W');
end;{RedrawWindow}

Procedure RedrawDisplay;               { q    Sp   Win }
var q: byte;                           { 0 -  off  off }
begin                                  { 1 -  on   off }
 q:= Spectrum + SWindow*2;             { 2 -  off  on  }
 case q of                             { 3 -  on   on  }
  0: begin dyWIN:=0; dySP:=0; FullViewPort; ClearViewPort; end;
  1: begin dyWIN:=0; dySP:=dy-3; SpYmask:=255; RedrawSpectrum; end;
  2: begin dyWIN:=dy-3; dySP:=0; WinYmask:=255; RedrawWindow; end;
  3: begin
      dySP:=dy-3; dyWIN:=dy-5-128; WinYmask:=127; SpYmask:=127;
      RedrawWindow; RedrawSpectrum;
     end;
 end;
end;{RedrawDisplay}

Procedure Spectrum_On;
begin
 if Spectrum=0 then Spectrum:=1 else Spectrum:=0;
 RedrawDisplay;
end;{Spectrum_On}

Procedure SetWindowChannels(On_Off: byte);
begin
 gotoXY(1,3);
  if On_Off=1 then
    begin
      TextColor(WindowGraphColor);
      write(W0:4);
      gotoXY(48,3);
      write((W0+Wlen):4);
    end
   else write('                                                   ');
end;{SetWindowChannels}

Procedure Window_On;
begin
 if SWindow=0 then SWindow:=1 else SWindow:=0;
 RedrawDisplay;
 SetWindowChannels(SWindow);
end;{Window_On}

Procedure ChangeWindowScale;
begin
 WinLog:=not WinLog;
 TextColor(DataColor);
 gotoXY(60,10); if WinLog then Write('LOG') else Write('LIN');
 RedrawWindow;
end;{ChangeWindowScale}

Procedure ChangeSpectrumScale;
begin
 SpLog:=not SpLog;
 TextColor(DataColor);
 gotoXY(60,18);
 if SpLog then Write('LOG') else Write('LIN');
 RedrawSpectrum;
end;{ChangeWindowScale}

Procedure ChangeWindowMarkerStep;
begin
 if MarkWindStep=1 then MarkWindStep:=10 else
 if MarkWindStep=10 then MarkWindStep:=100 else MarkWindStep:=1;
 TextColor(DataColor);
 gotoXY(66,8); Write(MarkWindStep,'  ');
end;{ChangeWindowScale}

Procedure ChangeSpectrumMarkerStep;
begin
 if MarkSpStep=1 then MarkSpStep:=10 else
 if MarkSpStep=10 then MarkSpStep:=100 else MarkSpStep:=1;
 TextColor(DataColor);
 gotoXY(66,16); Write(MarkSpStep,'  ');
end;{ChangeWindowScale}

Procedure ChangeWindowStep;
begin
 if WindowStep=10 then WindowStep:=100 else
 if WindowStep=100 then WindowStep:=1000 else WindowStep:=10;
 TextColor(DataColor);
 gotoXY(74,7); Write(WindowStep:4);
end;{ChangeWindowStep}

Procedure ChangeWindowLength;
begin
 if WLen=50 then WLen:=100 else
 if WLen=100 then WLen:=200 else
 if WLen=200 then WLen:=400 else WLen:=50;
 SetWindowChannels(1);
 TextColor(DataColor);
 gotoXY(74,6); Write(WLen:4);
 RedrawWindow;
end;{ChangeWindowLength}

Procedure WindowLeft;
begin
 if W0>0 then
  begin
   dec(W0,WindowStep); if W0<0 then W0:=0;
   RedrawWindow;
   SetWindowChannels(1);
   RedrawSpectrum;
  end;
end;{WindowLeft}

Procedure WindowRight;
begin
 if W0<SpectrumLength-Wlen then
  begin
   inc(W0,WindowStep);
   if W0>SpectrumLength-Wlen then W0:=SpectrumLength-Wlen;
   RedrawWindow;
   SetWindowChannels(1);
   RedrawSpectrum;
  end;
end;{WindowRight}

Procedure UpSpectrumLength;
begin
 if SpectrumLength<MaxChannels then
 begin
  ClearMarker('S');
  inc(SpectrumLength,xLen); inc(SpXstep);
  RedrawSpectrum;
  TextColor(DataColor);
  gotoXY(62,15); write(SpectrumLength:4);
  gotoXY(52,22); write(SpectrumLength:4);
 end;
end;{UpSpectrumLength}

Procedure DownSpectrumLength;
begin
 if SpectrumLength>xlen then
 begin
  dec(SpectrumLength,xLen); dec(SpXstep);
  RedrawSpectrum;
  TextColor(DataColor);
  gotoXY(62,15); write(SpectrumLength:4);
  gotoXY(52,22); write(SpectrumLength:4);
 end;
end;{DownSpectrumLength}

Procedure WinYup;
begin
 if WinLog then
  begin
   if WindowMult<WinMaxYmult then
    begin inc(WindowMult); RedrawWindow; end;
  end
 else if WindowShift<23 then
  begin inc(WindowShift); RedrawWindow; end;
end;

Procedure WinYdn;
begin
 if WinLog then
  begin
   if WindowMult>1 then
    begin dec(WindowMult); RedrawWindow; end;
  end
 else if WindowShift>0 then
  begin dec(WindowShift); RedrawWindow; end;
end;

Procedure SpYup;
begin
 if SpLog then
  begin
   if SpectrumMult<SpMaxYmult then
    begin inc(SpectrumMult); RedrawSpectrum; end;
  end
 else if SpectrumShift<23 then
  begin inc(SpectrumShift); RedrawSpectrum; end;
end;

Procedure SpYdn;
begin
 if SpLog then
  begin
   if SpectrumMult>1 then
    begin dec(SpectrumMult); RedrawSpectrum; end;
  end
 else if SpectrumShift>0 then
  begin dec(SpectrumShift); RedrawSpectrum; end;
end;

Procedure WinMarkLeft;
begin
 if WxMark>MarkWindStep-1 then
  begin
   ClearMarker('W');
   dec(WxMark,MarkWindStep);
   SetMarker('W');
  end;
end;

Procedure  WinMarkRight;
begin
 if WxMark<xlen-MarkWindStep then
  begin
   ClearMarker('W');
   inc(WxMark,MarkWindStep);
   SetMarker('W');
  end;
end;

Procedure  SpMarkLeft;
begin
 if SMark>MarkSpStep-1 then
  begin
   ClearMarker('S');
   dec(SMark,MarkSpStep);
   SxMark:=SMark div SPxStep;
   SetMarker('S');
  end;
end;

Procedure SpMarkRight;
begin
{ if SxMark*SpXstep<xlen-MarkSpStep-1 then
  begin
   ClearMarker('S');
   inc(SxMark,MarkSpStep);
   SetMarker('S');
  end;   }
 if SMark<SpectrumLength-MarkSpStep-1 then
  begin
   ClearMarker('S');
   inc(SMark,MarkSpStep);
   SxMark:=SMark div SPxStep;
   SetMarker('S');
  end;
end;{SpMarkRight}


Procedure InitScreen;
begin
 if RegisterBGIdriver(@EGAVGADriverProc) < 0 then
   begin Writeln('EGAVGA driver not found'); Halt(1); end;
 GraphDriver := Detect;
 InitGraph(GraphDriver,GraphMode,'');
  if GraphResult<> grOk then
   begin
    sound(500);Writeln('Must be EGA videocard');delay(2000);
    nosound; Halt(1); end;
 SetGraphMode(egahi);
 DirectVideo:=false;
end;{InitScreen}

Procedure Settings;
begin
 W0:=0; MaxChannels:=BufArraySize; SpectrumLength:=1200;
 SpXStep:=SpectrumLength div xLen;
 if (SpectrumLength Mod xLen)>0 then inc(SpXStep);
 SpLog:=false; WinLog:=false;
 SpectrumGraphColor:=lightred; WindowGraphColor:=green;
 SpectrumMarkerColor:=white; WindowMarkerColor:=yellow;
 TeColor:=LightCyan; MenuColor:=White; DataColor:=Yellow;
 SpWinColor:=Green;
 WinPixelColor:=WindowGraphColor; SpPixelColor:=SpectrumGraphColor;
 SpectrumShift:=0; WindowShift:=0; SpectrumMult:=10; WindowMult:=10;
 SpYmask:=$3f; WinYmask:=$7f;
 SpMaxYmult:=20; WinMaxYmult:=20; MarkSpStep:=1; MarkWindStep:=1;
 SMark:=0; SxMark:=0; WxMark:=0;
 Spectrum:=0; SWindow:=0;
 WindowStep:=10;WLen:=50;
end;{Settings}

Procedure InitInform;
BEGIN
 InitInfDisp:= True;
 HelpDisp:=False;
 InfWinDisp:=False;
 SetViewPort(0,0,639,22,true);
 SetFillPattern(op,LightGray);SetColor(Black);
 Bar(0,0,639,11);
 OutTextXY(0,2,
' F1 - Help of operation    ALTF1 - Experiment condition window     ESC-exit');
 SetColor(Red);
 OutTextXY(0,2,
' F1                        ALTF1                                   ESC     ');
FullViewPort ;
end; {InitInform}


Procedure SetScreen;
var
s1,s2,s3,s4,s5,s6       : string;
aa                      :char;
begin
 TextColor(WindowGraphColor);
 gotoXY(53,6); Write('Window: length     =   50');
 gotoXY(53,7); Write('      : chift step =   10');
 gotoXY(53,8); Write('Marker step= 1');
 gotoXY(53,9); Write('Marker: 0(0)');
 gotoXY(53,10); Write('Scale: LIN');
 TextColor(SpectrumGraphColor);
 gotoXY(53,15); Write('Spectrum:',SpectrumLength:4,' channels');
 gotoXY(53,16); Write('Marker step= 1');
 gotoXY(53,17); Write('Marker: 0(0)');
 gotoXY(53,18); Write('Scale: LIN');
 gotoXY(52,22); write(SpectrumLength:4);
 TextColor(MenuColor);
 SetColor(Red);
 GetFillPattern(op);
 InitInform;
 SetColor(Yellow);
 SetViewPort(0,0,639,349,true);
 Rectangle(x0,y0,x0+dx,y0+dy);
 RedrawDisplay;
 Spectrum_On;
end;{SetScreen}


Procedure HelpOperation;
BEGIN
  InfWinDisp:=False;
  InitInfDisp:=False;
  HelpDisp:= True;
  SetViewPort(0,0,639,41,clipon);
  ClearViewPort;
  TextColor(MenuColor);
  SetColor(Red);
  GetFillPattern(op);
  SetFillPattern(op,Blue);
  Bar(0,0,639,41);
  SetViewPort(0,2,639,41,clipon);

  SetColor(LightRed); OutTextXY(2,0,
 'SPECTRUM:F2-On/Off F4-Lin/Log PgUp/Dn-Y F5/CtrlF5-Length Marker:'+chr(26)+
 'Shift F3-Step');
  SetColor(LightCyan); OutTextXY(2,0,
 '            On/Off    Lin/Log         Y           Length          Shift    Step');
  SetColor(LightGreen); OutTextXY(2,10,
 'WINDOW(all with CTRL): F2-On/Off F4-Lin/Log PgUp/Dn-Y    Marker:'+chr(26)+
 'Shift F3-Step');
  SetColor(Cyan); OutTextXY(2,10,
 '       all with CTRL      On/Off    Lin/Log         Y           '+
 '  Shift    Step');
  SetColor(White); OutTextXY(2,20,
 'OTHER: -/+ Window shift  F7- Window shift step  F9- Window spectrum length');
  OutTextXY(2,30,
 '       P- Pause    Del- Erase spectrum buffer     ESC- Write spectrum, exit');
  SetColor(LightGray); OutTextXY(2,20,
 '           Window shift      Window shift step      Window spectrum length');
  OutTextXY(2,30,
 '          Pause         Erase spectrum buffer          Write spectrum, exit');
FullViewPort;
END; {HelpOperation}

{---------------------------------------------------------------------------}

Procedure InformWindow;
var
s1,s2,s3,s4,s5,s6       : string;
aa                      :char;
BEGIN
 HelpDisp:=False;
 InitInfDisp:=False;
 InfWinDisp:=True;
 SetViewPort(0,0,639,22,false);
  ClearViewPort;

 SetFillPattern(op,LightGray); SetColor(Black);
 Bar(0,0,639,11);
 OutTextXY(0,2,
' Channels(V): Start=        End=        Step=                   ; Channels:');
 str(Ibeg:7:1,s1); str(Iend:7:1,s2); str(Istep:5:1,s3); str(ChannelsToMeasure,s4);
 if Increasing then aa:='+' else aa:='-';
 if RelYes=true then  OutTextXY(0,2,
'                                                    Ratio=                ')
      else OutTextXY(0,2,
'                                                    Const=                ');
 SetColor(Yellow);
 OutTextXY(20*8+2,2,s1); OutTextXY(32*8+2,2,s2); OutTextXY(45*8+2,2,aa+s3);
 OutTextXY(75*8+3,2,s4);

 str(Rel:5:4,s5); str(u:4:1,s6);
 SetColor(Yellow);
 if RelYes=true then  OutTextXY(58*8,2,s5) else OutTextXY(59*8,2,s6);

 SetViewPort(0,0,639,22,false);
  SetColor(Black);
  Bar(0,11,639,22);
  OutTextXY(0,13,
' Time: Expos.(s)=      Dead(s)=    Full:    h.   min.  Remainder:    h.   min.');
  SetColor(lightred);
  OutTextXY(0,13,
'                                                       Remainder:    h.   min.');

  FulHour:=Trunc(FulTim/3600);
  FulMin:=Round((FulTim-Trunc(FulTim/3600)*3600)/60);
  RemHour:=Trunc(RemTim/3600);
  RemMin:=Round((RemTim-Trunc(RemTim/3600)*3600)/60);
  MTim:=Round(Mtime);DTim:=Round(Dtime);
  str(FulHour,s1); str(FulMin,s2); str(RemHour,s3); str(RemMin,s4);
  str(Mtim,s5); str(Dtim,s6);
  SetColor(Yellow);
  OutTextXY(40*8-2,13,s1); OutTextXY(46*8+2,13,s2); OutTextXY(65*8,13,s3);
  OutTextXY(71*8+4,13,s4); OutTextXY(17*8,13,s5); OutTextXY(31*8,13,s6);
  FullViewPort;
END; {InformWindow}

Procedure SaveSpectrum(Save: boolean);Forward;

{$F+}
Procedure StartMeasure;
begin
 MeasuringState:=True;
  gotoXY(64,4); TextColor(LightRed); Write('лл EXPOSITION лл');
  Sound(1000);delay(1200);nosound;
 ResetCAMACinhibit;

 Iflag:=0; Time:=0;  RegTime:=0;

 Interval:=MesTime;
end;{Startmeasure}
{$F-}

{$F+}
Procedure StopMeasure;
var
 lll: longint;
begin
   Sound(700);delay(1200);nosound;
   gotoXY(64,4); TextColor(White); Write('лл DEAD TIME  лл');
{ Inc(Cch);}
 lll:=CounterCode{CCh};
 Buf[CurrentChannel]:=lll;
 MeasuringState:=False;
 RedrawDisplay;
 RemTim:=RemTim-(MTime+DTime);
 Inc(CurrentChannel);
 if Increasing then CurrentCode:=CurrentCode+Istep
               else CurrentCode:=CurrentCode-Istep;
 gotoXY(1,4); TextColor(White); Write(CurrentCode:5:2);

 Iflag:=0; Time:=0;

 Interval:=DeadTime;
 if VarU then
      begin
        SetChannelCode1(CurrentCode);
        if RelYes then
           begin
             uper:=Trunc(CurrentCode/Rel);
             SetChannelCode2(uper);
           end
       end
    else
      begin
        SetChannelCode2(CurrentCode);
        if RelYes then
           begin
             uper:=Trunc(CurrentCode/Rel);
             SetChannelCode1(uper);
           end
       end;
 StopMeasuring:=(CurrentChannel=ChannelsToMeasure);
 if StopMeasuring then
  begin
     gotoXY(54,21); write('MEASURING IS OVER !!!');
       flag:=1;
       delay(500);Sound(1000);delay(1000);nosound;
  end;
end;{StopMeasure}
{$F-}

{$F+}
Procedure IntervalTest;
begin
 if TimeIsOver then if MeasuringState then StopMeasure else StartMeasure;
end;{IntervalTest}
{$F-}

Procedure InitCAMACmodules;
begin
 CurrentChannel:=0; StopMeasuring:=false; MeasuringState:=false;
 InitCAMAC;
 Ibeg:=0;Iend:=1000;Istep:=0.2;
 Mtime:=10;Dtime:=10;Rel:=1;u:=200;
 WrTime:=10;RegInt:=5;
     VarU:=True;
     RelYes:= false;
     Increasing:=(Iend>=Ibeg);
     ChannelsToMeasure:=Round((Iend-Ibeg)/Istep)+1;
     TempTicks:=(MTime/65536)*1193180;
     MesTime:=Round(TempTicks);
     TempTicks:=(DTime/65536)*1193180;
     DeadTime:=Round(TempTicks);
     FulTim:=(MTime+DTime)*ChannelsToMeasure;   {Seconds to measure}
     FulHour:=Trunc(FulTim/3600);
     FulMin:=Round((FulTim-Trunc(FulTim/3600)*3600)/60);
     TempTicks:=(WrTime*60/65536)*1193180;
     WriteTime:=Round(TempTicks);
     WrTim:=1;
     SpectrumFileName:='petev';
     p1139beg:=36676;
     step1139:=19.054;
     step669:=76.791;
     PrelDif:=3.7;

end;{InitCAMACmodules}



Procedure ClearBuffer;
begin
 Clrscr;
 For i:=0 to FullBufLen do Buf[i]:=0;
end;{ClearBuffer}


{$F+}
Procedure Timer; interrupt;
begin
  asm
    pushf
    call OldInt1C
  end;
  If not StopMeasuring and not OperInt then
    begin
      inc(Time);
      if Time>=Interval then Iflag:=1;
       if Iflag=0 then
                     begin
                       inc(RealT);
                       if RealT>=RealTime then
                                            begin
                                              Realflag:=1;
                                              gotoXY(59,4);
                                              TextColor(White);
                                              Write(Hrono);
                                              Hrono:=Hrono+1;
                                              TempTicks:=(Hrono/65536)*1193180;
                                              RealTime:=Round(TempTicks);
                                             end;
                          end
                   else
                      begin
                        Hrono:=1;
                        TempTicks:=(Hrono/65536)*1193180;
                        RealTime:=Round(TempTicks);
                        RealT:=0;
                        gotoXY(59,4);
                        TextColor(Black);
                        Write('    ');
                      end;

  if not MeasuringState then
                         begin
                           inc(WaitTime);
                           if WaitTime>=WaitInterval then WaitFlag:=1;
                           NewRegion:=False;
                         end;
     if MeasuringState then
                        begin
                          inc(RegTime);
                          if RegTime>=RegInterval then RegFlag:=1;
                        end;
     inc(WTime);
     if WTime>=WriteTime then flag:=1;
    end;
end;
{$F-}

{$F+}
procedure Int28H; interrupt;
begin
    asm
      pushf
      call OldInt28
    end;
    if flag=1 then
       begin
         WriteFile;
         flag:=0; WTime:=0;
       end;
end;
{$F-}

Procedure GiveBackIntVec( var Removed: Boolean );
begin
      SetIntVec( $1C, OldInt1C );
      SetIntVec( $28, OldInt28 );
      Sound(200);Delay(100);Nosound;
      Exit;
end; {GiveBackIntVec}

Procedure ChangeIntVec;
begin
 asm
  cli
 end;
   GetIntVec($1C,OldInt1C);
   SetIntVec($1C,@Timer);
   GetIntVec($28,OldInt28);
   SetIntVec($28,@Int28H);
 asm
  sti
 end;
end;

{$F+}
Procedure MyExit;
begin

{ SaveSpectrum(False);}

 if SfOpen then Close(SpectrumFile);
 if ErrorAddr<>Nil then
  begin
   ErrorAddr:=Nil;
   writeln(' Abnormal end of programm.......... Exit with ',ExitCode);
  end;
 ExitProc:=OldExit;
end;{MyExit}
{$F-}

Procedure ScreenLoop;Forward;

Procedure SaveSpectrum(Save: boolean);
var
 i,i1        : word;
 l,l1        : byte;
 Y           : boolean;
 s1,s2,s3,s4 : string[6];

begin
 closegraph; OperInt:=True;
   TextColor(White); TextBackGround(Black);
  if not YesOrNo('Do you want to exit?(Y/N)',3,1,White,'y') then
        begin
          OperInt:=False;
          a:=' ';
          Screenloop;
        end
else
  if YesOrNo('Are you sure?(Y/N)',4,1,Yellow,'n') then
       begin
         writefile;
         delay(200);
         writeln('The spectrum is saved');
         GiveBackIntVec(Removed);
       end
   else
       begin
         OperInt:=False;
         a:=' ';
         Screenloop;
       end;
end;{SaveSpectrum}

Procedure ScreenLoop;
var
s1,s2,s3,s4 : string;
begin
 InitScreen;
 Settings;
 SetScreen;
 gotoXY(1,4); TextColor(White); Write(CurrentCode:5:2);
  Repeat
  if keypressed then
   begin
    a:=UpCase(ReadKey);
    case a of
     '+': WindowRight;
     '-': WindowLeft;
     'P': begin
           gotoxy(55,18); TextColor(LightRed);
           write('....... Pause .......');
           a:=readkey;
           gotoxy(55,18); TextColor(White);
           write('                         ');
          end;
      #0 : begin
          a:=ReadKey;
          case a of
            F1    :  if not helpdisp then HelpOperation
                       else
                         begin
                           SetViewPort(0,0,639,41,clipon);
                           ClearViewPort;
                           InitInform;
                           if SWindow=1 then
                              begin
                                SetWindowChannels(1);
                                TextColor(DataColor);
                                gotoXY(74,6); Write(WLen:4);
                              end;
                           FullViewPort;
                         end;
            AltF1 :  if not InfWinDisp then InformWindow
                      else
                         begin
                           SetViewPort(0,0,639,22,clipon);
                           ClearViewPort;
                           InitInform;
                           FullViewPort;
                        end;
            CTRLF2:  Window_On;
            F4:      ChangeSpectrumScale;
            CTRLF4:  ChangeWindowScale;
            F3:      ChangeSpectrumMarkerStep;
            CTRLF3:  ChangeWindowMarkerStep;
            F2:      Spectrum_On;
            F5:      UpSpectrumLength;
            F7:      ChangeWindowStep;
            F9:      ChangeWindowLength;
            CTRLF5: DownSpectrumLength;
            PgUpKey: SpYup;
            PgDnKey: SpYdn;
            CTRLPgUpKey: WinYup;
            CTRLPgDnKey: WinYdn;
            CTRLLeftKey: if SWindow>0 then WinMarkLeft;
            CTRLRightKey:if SWindow>0 then WinMarkRight;
            LeftKey: if Spectrum>0 then SpMarkLeft;
            RightKey:if Spectrum>0 then SpMarkRight;
            DEL     : begin
                        for i:=0 to 4095 do buf[i]:=0;
                        RedrawDisplay;
                      end;
            end;
        end;
      end;
   end;

 if not HelpDisp and not InitInfDisp then
   begin
     RemMin:=Round((RemTim-Trunc(RemTim/3600)*3600)/60);
     if RemMin<>RemMinPr then
        begin
           GetViewSettings(vp);
           SetViewPort(0,0,639,349,true);
           SetColor(LightGray);
           RemHour:=Trunc(RemTim/3600);
           str(RemHour:3,s3); str(RemMin:2,s4);
           OutTextXY(65*8,13,'ллл');OutTextXY(71*8+4,13,'лл');
           SetColor(Yellow);OutTextXY(65*8,13,s3);OutTextXY(71*8+4,13,s4);
           with vp do SetViewPort(x1,y1,x2,y2,clip);
           RemMinPr:=RemMin;
           FullViewPort;
        end;
    end;
    if IFlag=1 then
               begin
                 IntervalTest;
               end;

    if WaitFlag=1 then
                    begin
                    { Adjast;  }
                     WaitFlag:=0; WaitTime:=0;
                    end;

    if RegFlag=1 then
                    begin
                      Adjast;{AdjastSchlum;}
                      RegFlag:=0; RegTime:=0;
                    end;
   Until (a=#27);
  SaveSpectrum(False);
end;{ScreenLoop}

begin
{  OldExit:=ExitProc; ExitProc:=@MyExit; }
  SfOpen:=false; SpectrumSaved:=false;
  GetConfigFile('Elstrln.cfg');
  if not SetCamacInterface then Halt(1);
  InitCAMACmodules;
  SpectrumFileName:='            ';
  SetAbout;

  SetInitHV;

  Dialog;

writeln('*****PLEASE WAIT*****');
step1139:= 19.058001111;            { Opredeljane na step1139 }
SetChannelCodeT(Ibeg);
p1139beg:=p1139;
code1:=pp;
writeln('code1=',code1);
writeln('p1139beg=',p1139);
SetChannelCodeT(Iend);
p1139end:=p1139;
code2:=pp;
writeln('code2=',code2);
writeln('p1139end=',p1139);
step1139:=abs((Iend*100) - (Ibeg*100))/abs(p1139end - p1139beg);
writeln('step1139=',step1139);
PrelDif:=(code1 + code2)/2;
writeln('PrelDif=',PrelDif);
SetChannelCodeT(Ibeg);


      za:=32000;             { Opredeljane na step669 }
      SetCode669(0);
      delay(za);
      delay(za);
      VD8:=VoltsSchlum*10;
      WriteLn(VD8);

      SetCode669(65535);
      delay(za);
      delay(za);
      VD9:=VoltsSchlum*10;
      WriteLn(VD9);
      step669:=abs(VD9-VD8)/65535;
      WriteLn('step669= ',step669);
      SetCode669(0);
      delay(za);

(*
 p1139beg:=36729;
 step1139:=19.054;
 step758:=2.56;
 SetCode1139(p1139beg);
 step669:=76.693369955;
*)

 TestStep758;           { Opredeljane na step758 }
(*
 step1139:=19.0511651143;
 step758:=2.5577533578;
 step669:=76.693369955;
 SetChannelCodeB(Ibeg);
 p1139beg:=p1139;
*)
 TestZero1139;          { Opredeljane na Zero1139}

  ClearBuffer;
  CurrentCode:=Ibeg;
  RemMinPr:=Round((FulTim-Trunc(FulTim/3600)*3600)/60);
  Time:=0; WTime:=0; WaitTime:=0; RegTime:=0; OldCalcVal:=0;
  RemTim:=FulTim; CCh:=0; Alter:=False; WaitInterval:=1;  NewRegion:=True;
  HelpDisp:=False;
  InfWinDisp:=False;
  InitInfDisp:=False;
  OperInt:=False;
  Hrono:=1; RealT:=0;
  TempTicks:=(Hrono/65536)*1193180;
  RealTime:=Round(TempTicks);
   if VarU then
     begin
       SetChannelCode1(CurrentCode);
       SetChannelCode2(ubeg);
     end
   else
     begin
       SetChannelCode1(Ubeg);
       SetChannelCode2(CurrentCode);
     end;
  Interval:=DeadTime;
  ChangeIntVec;
  ScreenLoop;
  KillHV;

end.


