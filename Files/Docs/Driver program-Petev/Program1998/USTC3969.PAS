Unit UStC3969;

Interface
Uses DOS,tpcrt;
const
 step1139prel : real     = 19.054001111;
{
 step758  : real     = 2.5606837607;
 zero1139 : longint  = 3110;
}

var
 z0,z1,z2,z3,z,h                                : longint;

var
 x                                                        : string;
 u,i,v,j                                                  : integer;
 a,q,r,s,t                                                : byte;
 step1,step2,step3,p,prob,CalcVal,CalcCode,
 g,VD,VD1,VD2,VD3,VD7,VD8,VD9,VS1,razl,RazlCalc,OldCalcVal,WInt,
 TempTicks,step669,step1139,Step758,Ibeg,Iend,Istep,code,pp,
 PrelDif, CurrentCode                                     : real;
 w,p1139,p1139e,p758,p758e,WaitTime,WaitInterval,WaitInt,
 p669,p669e,p1139beg,p1139end,p1139old,y,Zero1139                    : longint;
 NewRegion,StopAdj                                           : Boolean;


Function VoltsSchlum:real;
Function VoltsWithSignSchlum:Real;
Procedure SetCode669(cod:longint);
Procedure AdjastSchlum;
Function VoltsWithSign: Real;
Procedure SetCode758(cod:longint);
Procedure SetCode1139(cod:longint);
Procedure WaitInter;
Procedure SetChannelCode1(code: real);
Procedure Adjast;
Procedure SetChannelCodeT(code: real);
Procedure SetChannelCode10(code: real);
Procedure SetChannelCode20(code: real);
Procedure SetChannelCode2(code: real);
Procedure TestStep669;
Procedure TestStep758;
Procedure TestZero1139;

Implementation

Function VoltsSchlum:real;
var
  gpib: text;
  data: string[16];
  code: integer;
  s1,s2,s3: string[20];
  n3: longint;
begin
      Assign(gpib,'gpib0');                           { Open device GPIB0 }
      Rewrite(gpib);
      Writeln(gpib, 'ABORT');                { Reset and configure board }
      Writeln(gpib, 'RESET');
      Writeln(gpib, 'REMOTE 4');            { Place device in remote mode }
      Writeln(gpib, 'OUTPUT 4;U0 N1 M0 R3 I4 Q1 T1');
                                            { Send data to device }
      Rewrite(gpib);                        { Get data from device }
      Writeln(gpib,'gpibeos in LF');  {!!!Tova e vjarnoto}
      Writeln(gpib,'ENTER 4');
      Reset(gpib);
      Readln(gpib, data);
      s1:=copy(data,3,1);
      s2:=copy(data,5,6);
      s3:=concat(s1,s2);
      val(s3,n3,code);
      if code<>0 then writeln(code);
      Close(gpib);
  VoltsSchlum:=n3;
end;{VoltsSchlum}


Function VoltsWithSignSchlum:Real;
var
  gpib: text;
  data: string[255];
  s1,s2,s3,status: string[20];
  code,spoll: integer;
  n3:real;
begin
      Assign(gpib,'gpib0');   { Open device GPIB0 }
      Rewrite(gpib);
      Writeln(gpib, 'ABORT');    { Reset and configure board }
      Writeln(gpib, 'OUTPUT 4; U0 N1 M0 R3 I4 Q1 T1 ');     { Send data to device }
      Rewrite(gpib);                         { Get data from device }

      Writeln(gpib,'gpibeos in LF');  {!!!Tova e vjarnoto}

      Writeln(gpib, 'ENTER 4');
      Reset(gpib);
      Readln(gpib, data);
      s1:=copy(data,1,12);
      val(s1,n3,code);
      if code<>0 then writeln(code);
      Close(gpib);
      delay(8000);
      VoltsWithSignSchlum:=n3*1000000;
end; {VoltsWithSignSchlum}

Procedure SetCode669(cod:longint);
begin
 cod:=cod+1572864;
 q:=Lo(cod);
 r:=Hi(cod);
 v:=cod shr 16;
 a:=Lo(v);
 j:=20;
 for i:=3 to 7 do
     begin
        s:=a shl i;
        t:=s shr 7;
        if t=0 then t:=1 else t:=0;
        port[$378]:=t;
        j:=j-1;
        delay (4);
        port[$37a]:=1;
        delay (1);
        port[$37a]:=0;
        delay(10);
     end;
   j:=15;
 for i:=0 to 7 do
     begin
        s:=r shl i;
        t:=s shr 7;
        if t=0 then t:=1 else t:=0;
        port[$378]:=t;
        j:=j-1;
        delay (4);
        port[$37a]:=1;
        delay (1);
        port[$37a]:=0;
        delay(10);
     end;
  j:=7;
 for i:=0 to 7 do
      begin
        s:=q shl i;
        t:=s shr 7;
        if t=0 then t:=1 else t:=0;
        port[$378]:=t;
        j:=j-1;
        delay (4);
        port[$37a]:=1;
        delay (1);
        port[$37a]:=0;
        delay(10);
     end;
        delay(4);
        port[$37a]:=5;
        delay(1);
        port[$37a]:=1;
        delay(10);
end;{SetCode669}

Procedure AdjastSchlum;
begin
  repeat
  delay(u*3);

      VD1:=(VoltsSchlum*10);
      if abs(CalcVal -VD1)>step669 then
                                     begin
                                       if VD1>CalcVal then
                                                        begin
                                                          p669:=p669-1;
                                                        end
                                                      else
                                                        begin
                                                          p669:=p669+1;
                                                        end;
                                       SetCode669(p669);
                                       delay(u div 5);
                                       VD7:=(VoltsSchlum*10);
                                       VD1:=VD7;
                                     end;
{until keypressed;}

 until (VD1<(CalcVal+(step669*2))) and (VD1>(CalcVal-(step669*2)));
end; {AdjastSchlum}

Function VoltsWithSign: Real;
var
  gpib: text;
  data: string[16];
  code: integer;
  s1,s2,s3: string[20];
  n3: real;
 begin
      Assign(gpib,'gpib0');                           { Open device GPIB0 }
      Rewrite(gpib);
      Writeln(gpib, 'ABORT');                { Reset and configure board }
      Writeln(gpib, 'RESET');
      Writeln(gpib, 'REMOTE 8');            { Place device in remote mode }
      Writeln(gpib, 'OUTPUT 8;DCV 10,RESL7,filt_on,fast_off;x?');
                                            { Send data to device }
      Rewrite(gpib);                        { Get data from device }
      Writeln(gpib,'ENTER 8');
      Reset(gpib);
      Readln(gpib, data);
      s1:=copy(data,1,13);
      val(s1,n3,code);
      if code<>0 then writeln(code);
      Close(gpib);
  VoltsWithSign:=n3*1000000;
end;{VoltsWithSign}

Procedure SetCode758(cod:longint);
begin
 cod:=cod+1310720;
 q:=Lo(cod);
 r:=Hi(cod);
 v:=cod shr 16;
 a:=Lo(v);
 j:=20;
 for i:=3 to 7 do
     begin
        s:=a shl i;
        t:=s shr 7;
        if t=0 then t:=1 else t:=0;
        port[$378]:=t;
        j:=j-1;
        delay (1);
        port[$37a]:=1;
        delay (1);
        port[$37a]:=0;
        delay(1);
     end;
   j:=15;
 for i:=0 to 7 do
     begin
        s:=r shl i;
        t:=s shr 7;
        if i<>4 then if t=0 then t:=1 else t:=0;
        port[$378]:=t;
        j:=j-1;
        delay (1);
        port[$37a]:=1;
        delay (1);
        port[$37a]:=0;
        delay(1);
     end;
  j:=7;
 for i:=0 to 7 do
      begin
        s:=q shl i;
        t:=s shr 7;
        if t=0 then t:=1 else t:=0;
        port[$378]:=t;
        j:=j-1;
        delay (1);
        port[$37a]:=1;
        delay (1);
        port[$37a]:=0;
        delay(1);
     end;
        delay(1);
        port[$37a]:=5;
        delay(1);
        port[$37a]:=1;
        delay(1);

    j:=0;
 for i:=0 to 23 do
      begin
        t:=1;
        port[$378]:=t;
        j:=j+1;
        delay (1);
        port[$37a]:=1;
        delay (1);
        port[$37a]:=0;
        delay(1);
      end;
        port[$378]:=0;

end;{SetCode758}

Procedure SetCode1139(cod:longint);
begin
 cod:=cod+786432;
 q:=Lo(cod);
 r:=Hi(cod);
 v:=cod shr 16;
 a:=Lo(v);
 j:=20;
 for i:=3 to 7 do
      begin
        s:=a shl i;
        t:=s shr 7;
        if t=0 then t:=1 else t:=0;
        port[$378]:=t;
        j:=j-1;
        delay (1);
        port[$37a]:=1;
        delay (1);
        port[$37a]:=0;
        delay(1);
     end;
   j:=15;
 for i:=0 to 7 do
     begin
        s:=r shl i;
        t:=s shr 7;
        if t=0 then t:=1 else t:=0;
        port[$378]:=t;
        j:=j-1;
        delay (1);
        port[$37a]:=1;
        delay (1);
        port[$37a]:=0;
        delay(1);
     end;
  j:=7;
 for i:=0 to 7 do
      begin
        s:=q shl i;
        t:=s shr 7;
        if t=0 then t:=1 else t:=0;
        port[$378]:=t;
        j:=j-1;
        delay (1);
        port[$37a]:=1;
        delay (1);
        port[$37a]:=0;
        delay(1);
     end;
        delay(1);
        port[$37a]:=5;
        delay(1);
        port[$37a]:=1;
        delay(1);
    j:=0;
 for i:=0 to 23 do
      begin
        t:=1;
        port[$378]:=t;
        j:=j+1;
        delay (1);
        port[$37a]:=1;
        delay (1);
        port[$37a]:=0;
        delay(1);
     end;
        port[$378]:=0;

end;{SetCode1139}

Procedure WaitInter;
begin
  if NewRegion then
          begin
            RazlCalc:=((CurrentCode*100) - OldCalcVal)/100;
            WInt:=abs(RazlCalc)/500 + 2;    {[sec] pri ramp up/down 500V/sec}
            TempTicks:=(WInt/65536)*1193180;
            WaitInt:=Round(TempTicks);
            WaitInterval:=WaitInt ;
            OldCalcVal:=CurrentCode*100;
          end
       else
         begin
           WInt:=3;
           TempTicks:=(WInt/65536)*1193180;
           WaitInt:=Round(TempTicks);
           WaitInterval:=WaitInt ;
         end;
end; {WaitInter}



Procedure SetChannelCode1(code: real);
begin
  StopAdj:=False;
  CalcCode:=((Code - Ibeg)*100)/step1139;
  p1139e:=Trunc(CalcCode);
  p1139:=p1139beg + p1139e;
  SetCode1139(p1139);
  p758e:=Round(((CalcCode*step1139)-(p1139e*step1139))/step758);
  p758:=Zero1139+p758e;
  SetCode758(p758);
  WaitInter;
  Adjast;
end;{SetChannelCode1}


Procedure Adjast;
begin
 sound(3000);Delay(1000);Nosound;
 Razl:=(CurrentCode*100)-VoltsWithSign;
 if abs(Razl)<3 then StopAdj:=True;
 if not StopAdj then
                  begin
  if abs(Razl)>step1139 then
                          begin
                            p1139e:=Round(abs(Razl)/step1139);
                            if Razl>0 then
                                        begin
                                          p1139:=p1139+p1139e;
                                          SetCode1139(p1139);
                                        end;
                            if Razl<0 then
                                        begin
                                          p1139:=p1139-p1139e;
                                          SetCode1139(p1139);
                                        end;
                         end;
                 end;

  waitInter;
 Razl:=(CurrentCode*100)-VoltsWithSign;
 if abs(Razl)<3 then StopAdj:=True;
 if not StopAdj then
                  begin

  if abs(Razl)<step1139 then
                         begin
          {               sound(3000);Delay(1000);Nosound;}
    p758e:=Round(abs(Razl)/step758);
                            if Razl>0 then
                                      begin
                                       p758:=Zero1139 - p758e;
                                       SetCode758(p758);
                                      end;
                          if Razl<0 then
                                     begin
                                      p758:=Zero1139 + p758e;
                                      SetCode758(p758);
                                     end;

                         end;

                 end;

{
  if abs(Razl)<step1139 then
                         begin
                           repeat
                             if Razl>0 then
                                         begin
                                           p758:=p758-1;
                                           SetCode758(p758);
                                         end;
                             if Razl<0 then
                                         begin
                                           p758:=p758+1;
                                           SetCode758(p758);
                                         end;

}
WaitInter;
end;{Adjast}




Procedure SetChannelCodeT(code: real);
begin
{
  write('Set Voltage(0 - 49999 V): ');
  readln(code);
}
  CalcVal:=(code*100);
  VD1:=VoltsWithSign;
  RazlCalc:=(CalcVal - VD1)/100;
  p1139:=Round(CalcVal/step1139);
  SetCode1139(p1139);
  h:=Round(abs(RazlCalc)/1000*5000);          {1000V/sec}
   if h > 65535 then
                begin
                  z0:=h div 65535;
                  if z0 =1 then
                             begin
                               z1:=h - 65535; z2:=0; z3:=0;
                             end;
                  if z0 =2 then
                             begin
                               z1:=65535; z2:=h - 131070; z3:=0;
                             end;
                  if z0 =3 then
                             begin
                               z1:=65535; z2:=65535; z3:=h - 196605;
                             end;
                  if z0 =4 then
                             begin
                               z1:=65535; z2:=65535; z3:=65535;
                             end;
                end;
  if h>65535 then
              begin
                delay(65535);
                delay(z1);
                delay(z2);
                delay(z3);
                writeln('dylgo=',(65535+z1+z2+z3));
              end
            else
              begin
                if h>10000 then z:=h else z:=20000;
                delay(z);
              end;
  VD1:=VoltsWithSign;
  delay(z);
  Razl:=CalcVal-VD1;
  pp:=Razl;
repeat
  if abs(Razl)>step1139 then
                         begin
                          repeat
                           p1139e:=Round(abs(Razl)/step1139);
                           h:=Round(((p1139e*step1139)/50000)*5000);
                           if h>6000 then z:=h else z:=6000;
                           if Razl>0 then
                                      begin
                                       p1139:=p1139+p1139e;
                                       SetCode1139(p1139);
                                       delay(z );
                                       VD7:=VoltsWithSign;
                                      end;
                          if Razl<0 then
                                     begin
                                      p1139:=p1139-p1139e;
                                      SetCode1139(p1139);
                                       delay(z );
                                       VD7:=VoltsWithSign;
                                     end;
                             Razl:=CalcVal-VD7;
                             VD1:=VD7;
                             delay(z);
                          if keypressed then Halt(1);
                          until Abs(Razl)<10{step1139} ;
                         end;
  until abs(Razl)<step1139;
end;


Procedure SetChannelCode10(code: real);
begin

      z:=32000;
      CalcVal:=(code*100);
      prob:=CalcVal/step1139;
      p1139:=Round(prob);
      SetCode1139(p1139);
    {  VD:=CalcVal-(step1139*p1139);
      p758:=Round(VD/step758);
      p758:=Zero1139 - p758;
      SetCode758(p758);
     }
      delay(10000);

end;

Procedure SetChannelCodeB(code: real);
begin
      CalcVal:=(code*100);
      prob:=CalcVal/step1139;
      p1139:=Round(prob);
      SetCode1139(p1139);
      delay(2000);
end;

Procedure SetChannelCode2(code: real);
begin
      u:=1000;
      CalcVal:=(code*1000);
      p669:=Trunc(CalcVal/step669);
      SetCode669(p669);
      delay(u);
      VD:=(VoltsSchlum*10);

      if abs(CalcVal -VD)>step669 then
                            begin
                              p669e:=Trunc(abs(calcVal - VD)/step669);
        if VD>CalcVal then p669:=p669-p669e else p669:=p669+p669e;
                              SetCode669(p669);
                              delay(u div 5);
                            end;
        VD2:=VD;
end;{SetChannelCode2}

Procedure TestStep669;
begin
      SetCode669(0);
      delay(z{ div 10});

      VD8:=VoltsSchlum*10;
      WriteLn(VD8);

      SetCode669(65535);
      delay(z);
      VD9:=VoltsSchlum*10;
      WriteLn(VD9);
      step669:=abs(VD9-VD8)/65435;
      WriteLn('step669= ',step669);
      SetCode669(0);
      delay(z);
end; {TestStep669}

Procedure SetChannelCode20(code: real);
begin
      CalcVal:=(code*1000);
      p669:=Trunc(CalcVal/step669);
      SetCode669(p669);
      delay(10000);
end; {SetChannelCode20}

Procedure TestStep758;
begin
 setcode1139(p1139beg);
 setcode758(0);
 delay(32000);
 VD1:=VoltsWithSign;
 setcode758(4095);
 delay(32000);
 VD2:=VoltsWithSign;
 step758:=(VD2-VD1)/4095;
 writeln('step758=',step758);
end;

Procedure TestZero1139;
begin
  p758:=2048;
  SetCode758(p758);
  delay(32000 );
  VS1:=VoltswithSign - (Ibeg*100);
repeat
  if VS1>0 then
              begin
                p758:=p758+Trunc(VS1/step758);
                SetCode758(p758);
              end;
  if VS1<0 then
               begin
                p758:=p758-Trunc(VS1/step758);
                SetCode758(p758);
              end;
              writeln('VS1=',VS1,'     p758=',p758);
  delay(32000);
  VS1:=VoltswithSign - (Ibeg*100);
  if (p758<1900) and (p758>2200) then
                                   begin
                                     writeln('The system is not correct!');
                                     Halt(1);
                                   end;
  if keypressed then
                                   begin
                                     writeln('Operator stop.');
                                     Halt(1);
                                   end;
until abs(VS1)<4;
 Zero1139:=p758;
 WriteLn(' Zero1139= ',zero1139);
 SetCode758(Zero1139);
 delay(32000);
end;

begin
end.