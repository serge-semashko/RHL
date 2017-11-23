(********************************************************************
*   Example: Query Identification
*
*   Description: Perform the asynchronous read/write operation.
*
*   ADLINK Inc. 2006
********************************************************************)	
unit main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, gpib_user, Adgpib, ComCtrls, ExtCtrls, TeEngine, Series,
  TeeProcs, Chart, Spin, Buttons;

type
  TMainForm = class(TForm)
    Label1: TLabel;
    cmbGPIB: TComboBox;
    Label2: TLabel;
    cmbInst: TComboBox;
    Button1: TButton;
    Label3: TLabel;
    editWrite: TEdit;
    Label4: TLabel;
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
    ComboBox1: TComboBox;
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
    Series1: TLineSeries;
    SpinEdit1: TSpinEdit;
    StartCycle: TSpeedButton;
    CycBox: TCheckBox;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure StartCycleClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Chart1DblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

  (*488.2 GPIB global status variables.*)
  ibsta  : Integer;
  iberr  : Integer;
  ibcnt  : Integer;
  ibcntl : Integer;

implementation
uses logging, SetMinMax, das_const;
{$R *.DFM}
procedure TMainForm.Button1Click(Sender: TObject);
var
  //Declare variables
  wrtbuf, rdbuf: packed array[0..99] of char  ;
  dev: integer;
begin
  //Open and intialize an GPIB instrument
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
begin
  cmbGPIB.ItemIndex := 0;
  cmbInst.ItemIndex := 15;
  memoRead.Text := '';

end;

procedure TMainForm.StartCycleClick(Sender: TObject);
var
  //Declare variables
  wrtbuf, rdbuf: packed array[0..99] of char  ;
  dev,resc: integer;
  msg,errmess,rdstr : string;
  I1 : INTEGER;
  T1,T2 :DOUBLE;
  dacval :double;
  OpError :boolean;
  prevread : double ;
begin
    dev := ibdev(cmbGPIB.ItemIndex, cmbInst.ItemIndex+1, 0, T1s, 1, 0);
    StartCycle.Enabled := false;
    gpib_get_globals(@ibsta, @iberr, @ibcnt, @ibcntl);
    prevread := now();
    if (ibsta AND ERR) <> 0 THEN
    begin
      case iberr of
        0 : Errmess := 'EDVR System error';
        1 : Errmess := 'ECIC Function requires GPIB board to be CIC';
        2 : Errmess := 'ENOL Write function detected no Listeners';
        3 : Errmess := 'EADR Interface board not addressed correctly';
        4 : Errmess := 'EARG Invalid argument to function call';
        5 : Errmess := 'ESAC Function requires GPIB board to be SAC';
        6 : Errmess := 'EABO I/O operation aborted';
        7 : Errmess := 'ENEB Non-existent interface board';
        10: Errmess := 'EOIP I/O operation started before previous operation completed';
        11: Errmess := 'ECAP No capability for intended operation';
        12: Errmess := 'EFSO File system operation error';
        14: Errmess := 'EBUS Command error during device call';
        15: Errmess := 'ESTB Serial poll status byte lost';
        16: Errmess := 'ESRQ SRQ remains asserted';
        20: Errmess := 'ETAB The return buffer is full.';
        23: Errmess := 'EHDL The input handle is invalid';
      end;
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
      case iberr of
        0 : Errmess := 'EDVR System error';
        1 : Errmess := 'ECIC Function requires GPIB board to be CIC';
        2 : Errmess := 'ENOL Write function detected no Listeners';
        3 : Errmess := 'EADR Interface board not addressed correctly';
        4 : Errmess := 'EARG Invalid argument to function call';
        5 : Errmess := 'ESAC Function requires GPIB board to be SAC';
        6 : Errmess := 'EABO I/O operation aborted';
        7 : Errmess := 'ENEB Non-existent interface board';
        10: Errmess := 'EOIP I/O operation started before previous operation completed';
        11: Errmess := 'ECAP No capability for intended operation';
        12: Errmess := 'EFSO File system operation error';
        14: Errmess := 'EBUS Command error during device call';
        15: Errmess := 'ESTB Serial poll status byte lost';
        16: Errmess := 'ESRQ SRQ remains asserted';
        20: Errmess := 'ETAB The return buffer is full.';
        23: Errmess := 'EHDL The input handle is invalid';
      end;
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
  while CycBox.Checked do begin

    T1 := NOW;
//    while (now-t1)*24*3600<0.001 DO BEGIN
//      application.ProcessMessages;
//    END;
//***********execute read data from multimetr ******************

    strcopy(wrtbuf, pchar('X?'+#10));
    //Write a string command to a GPIB instrument asynchronously using the ibwrta() command
    ibwrta(dev, @wrtbuf, strlen(wrtbuf));
    gpib_get_globals(@ibsta, @iberr, @ibcnt, @ibcntl);
    if (ibsta AND ERR) <> 0 THEN
    begin
      memoread.lines[0]:=(DateToStr(now)+' '+TimeToStr(now)+'  '+'Err: Error in writing the string command to the GPIB instrument.'+#10);
            writetimelog(DateToStr(now)+' '+TimeToStr(now)+'  '+'Err: Error in writing the string command to the GPIB instrument.'+#10);
      opError:=true; continue;
    end;

    //Wait for the completion of asynchronous write operation
    ibwait(dev, CMPL);
    gpib_get_globals(@ibsta, @iberr, @ibcnt, @ibcntl);
    if (ibsta AND ERR) <> 0 THEN
    begin
      memoread.lines[0]:=(DateToStr(now)+' '+TimeToStr(now)+'  '+'Err: Writing the string command to the GPIB instrument timeout.'+#10);
            writetimelog(DateToStr(now)+' '+TimeToStr(now)+'  '+'Err: Writing the string command to the GPIB instrument timeout.'+#10);
      opError:=true; continue;
    end;

    //Read the response string from the GPIB instrument asynchronously using the ibrda() command
    ibrda(dev, @rdbuf, 100);
    gpib_get_globals(@ibsta, @iberr, @ibcnt, @ibcntl);
    if (ibsta AND ERR) <> 0 THEN
    begin
      memoread.lines[0]:=(DateToStr(now)+' '+TimeToStr(now)+'  '+'Err: Error in reading the response string from the GPIB instrument.'+#10);
            writetimelog(DateToStr(now)+' '+TimeToStr(now)+'  '+'Err: Error in reading the response string from the GPIB instrument.'+#10);
      opError:=true; continue;
    end;

    //Wait for the completion of asynchronous read operation
    ibwait(dev, CMPL);
    gpib_get_globals(@ibsta, @iberr, @ibcnt, @ibcntl);
    if (ibsta AND ERR) <> 0 THEN
    begin
      memoread.lines[0]:=(DateToStr(now)+' '+TimeToStr(now)+'  '+'Err: Reading the string command to the GPIB instrument timeout.'+#10);
            writetimelog(DateToStr(now)+' '+TimeToStr(now)+'  '+'Err: Reading the string command to the GPIB instrument timeout.'+#10);
      opError:=true; continue;
    end;
    rdbuf[ibcnt-1] := chr(0);
    prevread:=now() - prevread;

    rdstr:=rdbuf+' '+intToStr(trunc(prevread*24*3600*1000))+' '+ StringReplace(floattostr(now), ',', '.',[rfReplaceAll, rfIgnoreCase])+#10;
    prevread := now();
    writetimelog(rdstr);
  //  memoread.lines[0]:=(DateToStr(now)+' '+TimeToStr(now)+'  '+'Read ok = '+rdstr);
    try
      rdstr:=system.copy(rdstr,1,pos(' ',rdstr)-1);
      val(rdstr,dacval,resc);
      if resc=0 then begin
//      while series1.Count>5300 do series1.Delete(0);
//      series1.AddXY(now,dacval);
      end;
    finally
    end;
  end;
  //Offline the GPIB interface card
    ibonl(dev, 0);
    gpib_get_globals(@ibsta, @iberr, @ibcnt, @ibcntl);
    if (ibsta AND ERR) <> 0 THEN
    begin
      memoread.lines[0]:=(DateToStr(now)+' '+TimeToStr(now)+'  '+'Err: Error in offline the GPIB interface card.'+#10);
            writetimelog(DateToStr(now)+' '+TimeToStr(now)+'  '+'Err: Error in offline the GPIB interface card.'+#10);
    end;
        StartCycle.Enabled := true;


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
 SetMinMaxForm.SetLimits(TChart(sender));
end;

end.
