/********************************************************************
*   Example: Find Listener
*
*   Description: Find all listeners (instruments) on the GPIB bus
*
*   ADLINK Inc. 2006
********************************************************************/	
//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "Unit1.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.dfm"
TForm1 *Form1;
//---------------------------------------------------------------------------
__fastcall TForm1::TForm1(TComponent* Owner)
        : TForm(Owner)
{
}
//---------------------------------------------------------------------------


void __fastcall TForm1::btnFindClick(TObject *Sender)
{
  //Declare variables
  AnsiString DisplayStr;
  Addr4882_t result[31];
  Addr4882_t instruments[32];
  int num_listeners;
  int i,k;
  AnsiString str;

  //Reset the GPIB interface card by sending an interface clear command (SendIFC)
  SendIFC(cmbGPIB->ItemIndex);
  if (ibsta & ERR)
  {
    ShowMessage("Error in executing the SendIFC() command.");
    Close( );
    return;
  }

  for ( k=0 ; k<30 ; k++ )
  {
    instruments[k] = k + 1;
  }
  instruments[30] = NOADDR;

  //Find the listeners (instruments) on the GPIB bus using the FindLstn() command
  FindLstn(cmbGPIB->ItemIndex, instruments, result, 31);
  if (ibsta & ERR)
  {
    ShowMessage("Error in executing the FindLstn() command.");
    Close( );
    return;
  }

  num_listeners = ibcnt;
  result[ibcnt] = NOADDR;

  //List the addresses of listeners stored in the result[] array.
  ListBox1->Clear();
  for ( i=0;i < num_listeners; i++)
  {
    str.sprintf("%d", result[i]);
    ListBox1->Items->Add(str);
  }
  if(i==0)
  {
    ListBox1->Items->Add("None");
  }

  //Offline the GPIB interface card
  ibonl( cmbGPIB->ItemIndex, 0);
  if (ibsta & ERR)
  {
    ShowMessage("Error in offline the GPIB interface card.");
    Close( );
    return;
  }

}
//---------------------------------------------------------------------------
 