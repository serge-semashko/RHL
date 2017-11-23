/********************************************************************
*   Example: Read/Write
*
*   Description: Perform the asynchronous read/write operation.
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

void __fastcall TForm1::btnRWClick(TObject *Sender)
{
  //Declare variables
  AnsiString wrtbuf, Reading;
  char wr_str[100],rdbuf[100];
  int dev;

  //Open and intialize an GPIB instrument
  dev = ibdev(cmbGPIB->ItemIndex, cmbInst->ItemIndex+1, 0, T1s, 1, 0);
  if (ibsta & ERR)
  {
    ShowMessage("Error in initializing the GPIB instrument.");
  }

  //clear a specific device
  ibclr(dev);
  if (ibsta & ERR)
  {
    ShowMessage("Error in clearing the GPIB device.");
    ibonl(dev, 0);
    return;
  }

  wrtbuf = editWrite->Text;
  //Write a string command to a GPIB instrument asynchronously using the ibwrta() command
  ibwrta(dev, wrtbuf.c_str(), wrtbuf.Length());
  if (ibsta & ERR)
  {
    ShowMessage("Error in writing the string command to the GPIB instrument.");
    ibonl(dev, 0);
    return;
  }

  //Wait for the completion of asynchronous write operation
  ibwait(dev, CMPL);
  if (ibsta & ERR)
  {
    ShowMessage("Writing the string command to the GPIB instrument timeout.");
    ibonl(dev, 0);
    return;
  }

  //Read the response string from the GPIB instrument asynchronously using the ibrda() command
  ibrda(dev, rdbuf, 100);
  if (ibsta & ERR)
  {
    ShowMessage("Error in reading the response string from the GPIB instrument.");
    ibonl(dev, 0);
    return;
  }

  //Wait for the completion of asynchronous read operation
  ibwait(dev, CMPL);
  if (ibsta & ERR)
  {
    ShowMessage("Reading the string command to the GPIB instrument timeout.");
    ibonl(dev, 0);
    return;
  }

  rdbuf[ibcnt]=0;

  memoRead->Text = rdbuf;

  //Offline the GPIB interface card
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
