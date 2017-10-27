// Query Identification.h : main header file for the QUERY IDENTIFICATION application
//

#if !defined(AFX_QUERYIDENTIFICATION_H__5D2C2138_1644_48D8_8B98_95F02D14677E__INCLUDED_)
#define AFX_QUERYIDENTIFICATION_H__5D2C2138_1644_48D8_8B98_95F02D14677E__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#ifndef __AFXWIN_H__
	#error include 'stdafx.h' before including this file for PCH
#endif

#include "resource.h"		// main symbols

/////////////////////////////////////////////////////////////////////////////
// CQueryIdentificationApp:
// See Query Identification.cpp for the implementation of this class
//

class CQueryIdentificationApp : public CWinApp
{
public:
	CQueryIdentificationApp();

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CQueryIdentificationApp)
	public:
	virtual BOOL InitInstance();
	//}}AFX_VIRTUAL

// Implementation

	//{{AFX_MSG(CQueryIdentificationApp)
		// NOTE - the ClassWizard will add and remove member functions here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};


/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_QUERYIDENTIFICATION_H__5D2C2138_1644_48D8_8B98_95F02D14677E__INCLUDED_)
