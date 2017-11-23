// Find Listener.h : main header file for the FIND LISTENER application
//

#if !defined(AFX_FINDLISTENER_H__F4FAC60E_6BDD_433C_835C_96F10EF189B5__INCLUDED_)
#define AFX_FINDLISTENER_H__F4FAC60E_6BDD_433C_835C_96F10EF189B5__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#ifndef __AFXWIN_H__
	#error include 'stdafx.h' before including this file for PCH
#endif

#include "resource.h"		// main symbols

/////////////////////////////////////////////////////////////////////////////
// CFindListenerApp:
// See Find Listener.cpp for the implementation of this class
//

class CFindListenerApp : public CWinApp
{
public:
	CFindListenerApp();

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CFindListenerApp)
	public:
	virtual BOOL InitInstance();
	//}}AFX_VIRTUAL

// Implementation

	//{{AFX_MSG(CFindListenerApp)
		// NOTE - the ClassWizard will add and remove member functions here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};


/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_FINDLISTENER_H__F4FAC60E_6BDD_433C_835C_96F10EF189B5__INCLUDED_)
