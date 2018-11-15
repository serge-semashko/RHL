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
    Memo1: TMemo;
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

procedure TForm1.Button1Click(Sender: TObject);
var
  //Declare variables
  wrtbuf, rdbuf: packed array[0..99] of char  ;
  dev: integer;
  sta : integer;
  Procedure msg(mss:string);
  begin
      memoRead.lines.add(mss+' ibsta='+IntToStr(ibsta)+' err='+IntToStr(iberr)+' ibcntl='+IntToStr(ibcntl));
  end;
begin
  //Open and intialize an GPIB instrument
  dev := ibdev(cmbGPIB.ItemIndex, cmbInst.ItemIndex+1, 0, T1s, 1, 0);
  gpib_get_globals(@ibsta, @iberr, @ibcnt, @ibcntl);
  msg('ibdev');
  //clear the specific GPIB instrument
  ibclr(dev);
  gpib_get_globals(@ibsta, @iberr, @ibcnt, @ibcntl);
  msg('ibclr');

  strcopy(wrtbuf, pchar(editWrite.Text));
  //Write a string command to a GPIB instrument asynchronously using the ibwrta() command
  ibwrta(dev, @wrtbuf, strlen(wrtbuf));
  gpib_get_globals(@ibsta, @iberr, @ibcnt, @ibcntl);
  msg('ibwrt');

  //Wait for the completion of asynchronous write operation
  ibwait(dev, CMPL);
  gpib_get_globals(@ibsta, @iberr, @ibcnt, @ibcntl);
//  if (ibsta AND ERR) <> 0 THEN
  msg('ibwait');

  //Read the response string from the GPIB instrument asynchronously using the ibrda() command
  ibrda(dev, @rdbuf, 100);
  msg('ibrda');

  //Wait for the completion of asynchronous read operation
//  sleep(1000);
  ibwait(dev, CMPL);
  msg('ibwait');
  rdbuf[ibcnt] := chr(0);

  memoRead.lines.add(rdbuf);

  ibonl(dev, 0);
  gpib_get_globals(@ibsta, @iberr, @ibcnt, @ibcntl);
  msg('ibonl');

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  cmbGPIB.ItemIndex := 0;
  cmbInst.ItemIndex := 21;
  memoRead.Text := '';

end;

end.
