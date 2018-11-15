(********************************************************************
*   Example:Change GPIB Address
*
*   Description: Get/set the address of GPIB interface card using ibask/ibpad/ibsad commands.
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
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    editPadGet: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    editPadSet: TEdit;
    editSadGet: TEdit;
    editSadSet: TEdit;
    btnGet: TButton;
    btnSet: TButton;
    Label6: TLabel;
    Label7: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnGetClick(Sender: TObject);
    procedure btnSetClick(Sender: TObject);
    procedure cmbGPIBClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
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
  
  ud: Integer;

implementation

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
var
  str: AnsiString ;

begin
  cmbGPIB.ItemIndex := 0;
  str := Format('GPIB%d', [cmbGPIB.ItemIndex]);
  //Find the GPIB interface card
  ud := ibfind(PChar(str));
  gpib_get_globals(@ibsta, @iberr, @ibcnt, @ibcntl);
  if (ibsta and ERR <> 0) Then
  begin
    MessageDlg('Error in finding the GPIB interface card.', mtError, [mbOK], 0);
  end;

end;

procedure TForm1.btnGetClick(Sender: TObject);
var
  //declare variables
  rval: integer ;
  str: AnsiString ;

begin

  //Read the primary GPIB address of GPIB interface card using ibask command
  ibask (ud, IbaPAD, @rval);
  gpib_get_globals(@ibsta, @iberr, @ibcnt, @ibcntl);
  if (ibsta and ERR <> 0) Then
  begin
    MessageDlg('Error in querying the primary address of GPIB interface card.', mtError, [mbOK], 0);
  end;

  str := Format('%d', [rval]);
  EditPadGet.Text := str;

  //Read the secondary GPIB address of GPIB interface card using ibask command
  ibask (ud, IbaSAD, @rval);
  gpib_get_globals(@ibsta, @iberr, @ibcnt, @ibcntl);
  if (ibsta and ERR <> 0) then
  Begin
    MessageDlg('Error in querying the secondary address of GPIB interface card.', mtError, [mbOK], 0);
  end;
  str := format('%d', [rval]);
  EditSadGet.Text := str;

end;

procedure TForm1.btnSetClick(Sender: TObject);
var
  //declare variables
  ud, rval: integer ;
  str: AnsiString ;
begin
  str := Format('GPIB%d', [cmbGPIB.ItemIndex]);
  //Find the GPIB interface card
  ud := ibfind(PChar(str));

  //Set the primary GPIB address of GPIB interface card using ibpad command
  ibPad(ud, StrToInt(EditpadSet.Text));
  gpib_get_globals(@ibsta, @iberr, @ibcnt, @ibcntl);
  if (ibsta and ERR <> 0) Then
  begin
    MessageDlg('Error in setting the primary address of GPIB interface card.', mtError, [mbOK], 0);
  end;


  //Set the secondary GPIB address of GPIB interface card using ibsad command
  ibsad(ud, StrToInt(EditSadSet.Text));
  gpib_get_globals(@ibsta, @iberr, @ibcnt, @ibcntl);
  if (ibsta and ERR <> 0) then
  Begin
    MessageDlg('Error in setting the secondary address of GPIB interface card.', mtError, [mbOK], 0);
  end;


end;

procedure TForm1.cmbGPIBClick(Sender: TObject);
var
  str: AnsiString ;

begin

  //    Offline the GPIB interface card
  ibonl( ud, 0);

  str := Format('GPIB%d', [cmbGPIB.ItemIndex]);
  //Find the GPIB interface card
  ud := ibfind(PChar(str));
  gpib_get_globals(@ibsta, @iberr, @ibcnt, @ibcntl);
  if (ibsta and ERR <> 0) Then
  begin
    MessageDlg('Error in finding the GPIB interface card.', mtError, [mbOK], 0);
  end;

end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //    Offline the GPIB interface card
  ibonl( ud, 0);

end;

end.
