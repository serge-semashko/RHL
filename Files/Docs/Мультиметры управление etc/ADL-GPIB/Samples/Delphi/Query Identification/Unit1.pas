(********************************************************************
*   Example: Query Identification
*
*   Description: Send a *IDN? string to an instrument and get its identification string.
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
    btnQuery: TButton;
    Label4: TLabel;
    memoRead: TMemo;
    procedure btnQueryClick(Sender: TObject);
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

procedure TForm1.btnQueryClick(Sender: TObject);
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
    ShowMessage('Error in initializing the GPIB instrument.');
  end;

  //clear the specific GPIB instrument
  ibclr(dev);
  gpib_get_globals(@ibsta, @iberr, @ibcnt, @ibcntl);
  if (ibsta AND ERR) <> 0 THEN
  begin
    ShowMessage('Error in clearing the GPIB device.');
  end;

  strcopy(wrtbuf, pchar('*IDN?'));
  //write a "*IDN?" string to the GPIB instrument
  ibwrt(dev, @wrtbuf, strlen(wrtbuf));
  gpib_get_globals(@ibsta, @iberr, @ibcnt, @ibcntl);
  if (ibsta AND ERR) <> 0 THEN
  begin
    ShowMessage('Error in writing *IDN? string to the instrument.');
  end;

  //Read the returned identification string from the instrument
  ibrd(dev, @rdbuf, 100);
  gpib_get_globals(@ibsta, @iberr, @ibcnt, @ibcntl);
  if (ibsta AND ERR) <> 0 THEN
  begin
    ShowMessage('Error in reading identification string from the instrument.');
  end;

  rdbuf[ibcnt] := chr(0);

  memoRead.Text := rdbuf;

  //Offline the GPIB instrument
  ibonl(dev, 0);
  gpib_get_globals(@ibsta, @iberr, @ibcnt, @ibcntl);
  if (ibsta AND ERR) <> 0 THEN
  begin
    ShowMessage('Error in offline the GPIB interface card.');
  end;

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  cmbGPIB.ItemIndex := 0;
  cmbInst.ItemIndex := 7;
  memoRead.Text := '';
end;

end.
