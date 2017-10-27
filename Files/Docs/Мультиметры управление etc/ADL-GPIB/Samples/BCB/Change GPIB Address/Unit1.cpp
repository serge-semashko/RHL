/********************************************************************
*   Example: Change GPIB Address
*
*   Description: Get/set the address of GPIB interface card using ibask/ibpad/ibsad commands.
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


void __fastcall TForm1::btnGetClick(TObject *Sender)
{
  //declare variables
  int rval;
  AnsiString str;

  //Read the primary GPIB address of GPIB interface card using ibask command
  ibask (ud, IbaPAD, &rval);
  if (ibsta & ERR)
  {
    ShowMessage("Error in querying the primary address of GPIB interface card.");
  }

  str.sprintf("%d", rval);
  EditPadGet->Text=str;

  //Read the secondary GPIB address of GPIB interface card using ibask command
  ibask (ud, IbaSAD, &rval);
  if (ibsta & ERR)
  {
    ShowMessage("Error in querying the secondary address of GPIB interface card.");
  }
  str.sprintf("%d", rval);
  EditSadGet->Text=str;

}
//---------------------------------------------------------------------------
void __fastcall TForm1::btnSetClick(TObject *Sender)
{

  //Set the primary GPIB address of GPIB interface card using ibpad command
  ibpad(ud, atoi(EditPadSet->Text.c_str()));
  if (ibsta & ERR)
  {
    ShowMessage("Error in setting the primary address of GPIB interface card.");
  }

  //Set the secondary GPIB address of GPIB interface card using ibsad command
  ibsad(ud, atoi(EditSadSet->Text.c_str()));
  if (ibsta & ERR)
  {
    ShowMessage("Error in setting the secondary address of GPIB interface card.");
  }

}
//---------------------------------------------------------------------------
void __fastcall TForm1::cmbGPIBClick(TObject *Sender)
{
  //declare variables
  AnsiString str;

//    Offline the GPIB interface card
  ibonl( ud, 0);

  str.sprintf("GPIB%d", cmbGPIB->ItemIndex);
  //Find the GPIB interface card
  ud = ibfind(str.c_str());
  if (ibsta & ERR)
  {
    ShowMessage("Error in finding the GPIB interface card.");
  }

}
//---------------------------------------------------------------------------

