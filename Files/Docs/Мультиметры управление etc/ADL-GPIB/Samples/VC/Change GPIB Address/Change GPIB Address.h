// Change GPIB Address.h : main header file for the CHANGE GPIB ADDRESS application
//

#if !defined(AFX_CHANGEGPIBADDRESS_H__9116FFDB_D976_463F_B694_3796B4CE067F__INCLUDED_)
#define AFX_CHANGEGPIBADDRESS_H__9116FFDB_D976_463F_B694_3796B4CE067F__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#ifndef __AFXWIN_H__
	#error include 'stdafx.h' before including this file for PCH
#endif

#include "resource.h"		// main symbols

/////////////////////////////////////////////////////////////////////////////
// CChangeGPIBAddressApp:
// See Change GPIB Address.cpp for the implementation of this class
//

class CChangeGPIBAddressApp : public CWinApp
{
public:
	CChangeGPIBAddressApp();

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CChangeGPIBAddressApp)
	public:
	virtual BOOL InitInstance();
	//}}AFX_VIRTUAL

// Implementation

	//{{AFX_MSG(CChangeGPIBAddressApp)
		// NOTE - the ClassWizard will add and remove member functions here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};


/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_CHANGEGPIBADDRESS_H__9116FFDB_D976_463F_B694_3796B4CE067F__INCLUDED_)
