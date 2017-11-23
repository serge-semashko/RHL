// Read Write.h : main header file for the READ WRATE application
//

#if !defined(AFX_READWRITE_H__3B35F36D_9426_47D4_98A5_589FA2352365__INCLUDED_)
#define AFX_READWRITE_H__3B35F36D_9426_47D4_98A5_589FA2352365__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#ifndef __AFXWIN_H__
	#error include 'stdafx.h' before including this file for PCH
#endif

#include "resource.h"		// main symbols

/////////////////////////////////////////////////////////////////////////////
// CReadWriteApp:
// See Read Write.cpp for the implementation of this class
//

class CReadWriteApp : public CWinApp
{
public:
	CReadWriteApp();

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CReadWriteApp)
	public:
	virtual BOOL InitInstance();
	//}}AFX_VIRTUAL

// Implementation

	//{{AFX_MSG(CReadWriteApp)
		// NOTE - the ClassWizard will add and remove member functions here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};


/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_READWRITE_H__3B35F36D_9426_47D4_98A5_589FA2352365__INCLUDED_)
