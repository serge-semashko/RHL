// Read WriteDlg.h : header file
//

#if !defined(AFX_READWRITEDLG_H__1BB0A333_B03A_4562_AAFF_C8DF071F0FF5__INCLUDED_)
#define AFX_READWRITEDLG_H__1BB0A333_B03A_4562_AAFF_C8DF071F0FF5__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "..\..\..\Include\VC\Adgpib.h"
/////////////////////////////////////////////////////////////////////////////
// CReadWriteDlg dialog

class CReadWriteDlg : public CDialog
{
// Construction
public:
	CReadWriteDlg(CWnd* pParent = NULL);	// standard constructor

// Dialog Data
	//{{AFX_DATA(CReadWriteDlg)
	enum { IDD = IDD_READWRITE_DIALOG };
	CString	m_str_read;
	CString	m_str_write;
	int		m_istr;
	int		m_gpib;
	//}}AFX_DATA

	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CReadWriteDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:
	HICON m_hIcon;

	// Generated message map functions
	//{{AFX_MSG(CReadWriteDlg)
	virtual BOOL OnInitDialog();
	afx_msg void OnSysCommand(UINT nID, LPARAM lParam);
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	afx_msg void OnButtonRw();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_READWRITEDLG_H__1BB0A333_B03A_4562_AAFF_C8DF071F0FF5__INCLUDED_)
