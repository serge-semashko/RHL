(********************************************************************
*   Example: Query Identification
*
*   Description: Perform the asynchronous read/write operation.
*
*   ADLINK Inc. 2006
********************************************************************)	
unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, gpib_user, Adgpib;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    cmbGPIB: TComboBox;
    Label2: TLabel;
    cmbInst: TComboBox;
    Button1: TButton;
    Label3: TLabel;
    editWrite: TEdit;
    Label4: TLabel;
    memoRead: TMemo;
    Label5: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

  (*488.2 GPIB global status variables.*)
  ibsta  : Integer;
  iberr  : Integer;
  ibcnt  : Integer;
  ibcntl : Integer;

implementation

{$R *.DFM}
uses mmsystem;
procedure TForm1.Button1Click(Sender: TObject);
var
  //Declare variables
  wrtbuf, rdbuf: packed array[0..10299] of char  ;
  st : int64;
  resstr : string;

  dev: integer;
  Procedure msg(mss:string);
  begin
    caption :='ibsta='+IntToStr(ibsta)+' err='+IntToStr(iberr)+' ibcntl='+IntToStr(ibcntl)+' tgt='+IntToStr(timegettime-st);
//      memoRead.lines.add('ibsta='+IntToStr(ibsta)+' err='+IntToStr(iberr)+' ibcntl='+IntToStr(ibcntl)+' tgt='+IntToStr(timegettime-st));
//      memoRead.lines.add(mss);
  end;
  Procedure exec488(cmd:string);
  begin
    st := timegetTime;
    strcopy(wrtbuf, pchar(cmd));
    //Write a string command to a GPIB instrument asynchronously using the ibwrta() command
    ibwrt(dev, @wrtbuf, strlen(wrtbuf));
    gpib_get_globals(@ibsta, @iberr, @ibcnt, @ibcntl);
    msg('CMD='+cmd);
    //Read the response string from the GPIB instrument asynchronously using the ibrda() command
  end;
  var
  i1, i2 : integer;
  r1 : extended;
begin
  memoread.Clear;
  //Open and intialize an GPIB instrument
  dev := ibdev(cmbGPIB.ItemIndex, cmbInst.ItemIndex+1, 0, T10s, 1, 0);
  gpib_get_globals(@ibsta, @iberr, @ibcnt, @ibcntl);
  msg('dev');

  //clear the specific GPIB instrument
  st := timegettime;
  ibclr(dev);
  gpib_get_globals(@ibsta, @iberr, @ibcnt, @ibcntl);
  msg('clr');

  strcopy(wrtbuf, pchar(editWrite.Text));
  //Write a string command to a GPIB instrument asynchronously using the ibwrta() command
  exec488('PRESET NORM');
  exec488('TARM HOLD');
  exec488('MEM LIFO');
  exec488('DCV 10, 1E-10');
  exec488(editwrite.text);
//  exec488('TARM AUTO');
  decimalseparator := '.';
  resstr := rdbuf;
  i2 := pos(#13,resstr);
  i2 := -1;
  for i2 := 0 to 1000000 do begin
//    sleep(10);
    for i1 := 0 to 100 do application.ProcessMessages;
    st := timegettime;

    exec488('TARM SGL');
    ibrd(dev, @rdbuf, 17);
    gpib_get_globals(@ibsta, @iberr, @ibcnt, @ibcntl);
    rdbuf[ibcnt] := chr(0);
    resstr := rdbuf;
    resstr := system.copy(resstr,1,length(resstr)-1);
     if not TextToFloat(PChar(resstr), r1, fvExtended) then r1 := -1;

//    msg(format('  %2.9f',[r1]));
    label5.Caption:=resstr;
    label4.Caption:=format('  %2.9f',[r1])+' time='+IntToStr(timegettime-st)+'ms';
    if (timegettime-st)>400 then
    memoread.lines.add(label4.Caption);
//    msg(rdbuf);

  end;
//  if (i2>0) then begin
//    resstr := system.copy(resstr,1,i2-1);
//
//    r1 := strtofloat(resstr)*10000;
//
//    msg(format('  %2.9f',[r1]));
//    resstr := '123.22E-2';
//  end;
    i1 := 10;
    fillchar(rdbuf,100,0);


  //Offline the GPIB interface card
  ibonl(dev, 0);
  gpib_get_globals(@ibsta, @iberr, @ibcnt, @ibcntl);
  msg('onl');
  memoread.Lines.SaveToFile('f:\home\hist1.txt');
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  cmbGPIB.ItemIndex := 0;
  cmbInst.ItemIndex := 21;
  memoRead.Text := '';

end;

end.
