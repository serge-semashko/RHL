Program SetVoltage669;
Uses DOS,crt;
var
u,i,v,j:integer;
a,q,r,s,t:byte;
p,step669,CalcVal,VD,VD1,VD2,VD7,VD8,VD9: real;
p669,p669e : longint;

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

     { Writeln(gpib,'gpibeos out LF');}    {!!! tova e vjarnoto}

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
 {
        WriteLn('  serbit',j,'=',t);
  }
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
 {
        WriteLn('  serbit',j,'=',t);
 }
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
 {
        WriteLn('  serbit',j,'=',t);
  }
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
      if abs(CalcVal - VD1)>step669 then
                                     begin
                                       if VD1>CalcVal then
                                                        begin
                                                          p669:=p669-1;
                                                          writeln('p669= ',p669);
                                                        end
                                                      else
                                                        begin
                                                          p669:=p669+1;
                                                          writeln('p669= ',p669);
                                                        end;
                                       SetCode669(p669);
                                       delay(u div 5);
                                       VD7:=(VoltsSchlum*10);
                                       VD1:=VD7;
 writeln(CalcVal,'  ',VD1,'  ','p669= ',p669,'  ','Razl= ',CalcVal-VD1);
                                     end;
{until keypressed;}

 until (VD1<(CalcVal+(step669*2))) and (VD1>(CalcVal-(step669*2)));
end; {AdjastSchlum}


(*  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  *)


begin

repeat

  write('Set Voltage(0 - 4999 V): ');
  readln(p);
  u:=32000;
 (*
      SetCode669(0);
      delay(u{ div 10});
      delay(u);
      delay(u);
      delay(u);
      VD8:=VoltsSchlum*10;
      WriteLn(VD8);

      SetCode669(65535);
      delay(u);
      delay(u);
      delay(u);
      delay(u);
      VD9:=VoltsSchlum*10;
      WriteLn(VD9);
      step669:=abs(VD9-VD8)/65535;
      WriteLn('step669= ',step669);
      SetCode669(0);
      delay(u);
 *)
      step669:=76.684214;
      CalcVal:=(p*1000);

      WriteLn('CV= ',CalcVal);
      p669:=Trunc(CalcVal/step669);
      WriteLn('p669Cal= ',p669);

      SetCode669(p669);
      delay(u);
      VD:=(VoltsSchlum*10);

      if abs(CalcVal - VD)>step669 then
                            begin
                              p669e:=Trunc(abs(calcVal - VD)/step669);
        if VD>CalcVal then p669:=p669-p669e else p669:=p669+p669e;
                              SetCode669(p669);
                              delay(u div 5);
                            end;
   WriteLn('Before regulation,first set of voltage:');
      Writeln(CalcVal,'  ','p669= ',p669,'  ','VD1mes= ',VD,'  ','CalV-VD1mes= ',CalcVal-VD);
      WriteLn('AD669 is seted');
      VD2:=VD;
      WriteLn('Start of regulation');

      AdjastSchlum;

{ writeln('Mes1=',voltsdatron,'  ','Mes2=',voltswithsign);}

until keypressed;

end.