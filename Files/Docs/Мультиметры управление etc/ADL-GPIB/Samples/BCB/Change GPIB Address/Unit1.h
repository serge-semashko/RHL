//---------------------------------------------------------------------------

#ifndef Unit1H
#define Unit1H
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>

#include "../../../include/BCB/Adgpib_bc.h"
//---------------------------------------------------------------------------
class TForm1 : public TForm
{
__published:	// IDE-managed Components
        TLabel *Label1;
        TComboBox *cmbGPIB;
        TGroupBox *GroupBox1;
        TGroupBox *GroupBox2;
        TButton *btnSet;
        TButton *btnGet;
        TLabel *Label2;
        TLabel *Label3;
        TLabel *Label4;
        TLabel *Label5;
        TEdit *EditPadSet;
        TEdit *EditSadSet;
        TEdit *EditPadGet;
        TEdit *EditSadGet;
        TLabel *Label6;
        TLabel *Label7;
        void __fastcall btnGetClick(TObject *Sender);
        void __fastcall btnSetClick(TObject *Sender);
        void __fastcall cmbGPIBClick(TObject *Sender);
private:	// User declarations
        int ud;

public:		// User declarations
        __fastcall TForm1(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TForm1 *Form1;
//---------------------------------------------------------------------------
#endif
