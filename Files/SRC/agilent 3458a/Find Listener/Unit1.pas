(********************************************************************
*   Example: Find Listener
*
*   Description: Find all listeners (instruments) on the GPIB bus
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
    cmbGPIB: TComboBox;
    ListBox1: TListBox;
    btnFind: TButton;
    Label1: TLabel;
    Label2: TLabel;
    procedure btnFindClick(Sender: TObject);
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

procedure TForm1.btnFindClick(Sender: TObject);
var
  DisplayStr: AnsiString;
  result: array[0..30] of Addr4882_t;
  instruments: array[0..31] of Addr4882_t ;
  num_listeners : integer ;
  i,k: integer ;
  str: AnsiString ;

begin
  //Reset the GPIB interface card by sending an interface clear command (SendIFC)
  SendIFC(cmbGPIB.ItemIndex);
  gpib_get_globals(@ibsta, @iberr, @ibcnt, @ibcntl);
  if (ibsta and ERR <> 0) then
  begin
    MessageDlg('Error in executing the SendIFC() command.', mtError, [mbOK], 0);
    Close( );
  end;

  for k:=0 to 29 do
  begin
    instruments[k] := k + 1;
  end;
  instruments[30] := NOADDR;

  //Find the listeners (instruments) on the GPIB bus using the FindLstn() command
  FindLstn(cmbGPIB.ItemIndex, @instruments, @result, 31);
  gpib_get_globals(@ibsta, @iberr, @ibcnt, @ibcntl);
  if (ibsta and ERR <> 0) then
  begin
    MessageDlg('Error in executing the FindLstn() command.', mtError, [mbOK], 0);
    Close( );
  end;

  num_listeners := ibcnt;
  result[ibcnt] := NOADDR;

  //List the addresses of listeners stored in the result[] array.
  ListBox1.Clear();
  for  i:=0 to num_listeners -1 do
  begin
    str := format('%d', [result[i]]);
    ListBox1.Items.Add(str);
  end;
  gpib_get_globals(@ibsta, @iberr, @ibcnt, @ibcntl);
  if(num_listeners = 0) then
  begin
    ListBox1.Items.Add('None');
  end;

  //Offline the GPIB interface card
  ibonl( cmbGPIB.ItemIndex, 0);
  gpib_get_globals(@ibsta, @iberr, @ibcnt, @ibcntl);
  if (ibsta and ERR <> 0) then
  begin
    MessageDlg('Error in offline the GPIB interface card.', mtError, [mbOK], 0);
    Close( );
  end;


end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  cmbGPIB.ItemIndex := 0;

end;

end.
