/********************************************************************
*   Example: Query Identification
*
*   Description: Send a *IDN? string to an instrument and get its identification string.
*
*   ADLINK Inc. 2006
********************************************************************/
///---------------------------------------------------------------------------

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
void __fastcall TForm1::btnQueryClick(TObject *Sender)
{
  //Declare variables
  AnsiString wrtbuf, Reading;
  char rdbuf[100];
  int dev;

  //Open and intialize an GPIB instrument
  dev = ibdev(cmbGPIB->ItemIndex, cmbInst->ItemIndex+1, 0, T10s, 1, 0);
  if (ibsta & ERR)
  {
    ShowMessage("Error in initializing the GPIB instrument.");
    return;
  }

  //clear the specific GPIB instrument
  ibclr(dev);
  if (ibsta & ERR)
  {
    ShowMessage("Error in clearing the GPIB device.");
    ibonl(dev, 0);
    return;
  }

  wrtbuf = "*IDN?";
  //write a "*IDN?" string to the GPIB instrument
  ibwrt (dev, wrtbuf.c_str(), wrtbuf.Length());
  if (ibsta & ERR)
  {
    ShowMessage("Error in writing *IDN? string to the instrument.");
    ibonl(dev, 0);
    return;
  }

  //Read the returned identification string from the instrument
  ibrd (dev, rdbuf, 100);
  if (ibsta & ERR)
  {
    ShowMessage("Error in reading identification string from the instrument.");
    ibonl(dev, 0);
    return;
  }
  rdbuf[ibcnt]=0;

  memoRead->Text = rdbuf;

  //Offline the GPIB instrument
  ibonl(dev, 0);
  if (ibsta & ERR)
  {
    ShowMessage("Error in offline the GPIB interface card.");
  }

}
//---------------------------------------------------------------------------
void __fastcall TForm1::FormCreate(TObject *Sender)
{
  memoRead->Text = "";

}
//---------------------------------------------------------------------------

