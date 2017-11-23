// Query IdentificationDlg.h : header file
//

#if !defined(AFX_QUERYIDENTIFICATIONDLG_H__0E62A40D_3698_4B56_88EE_1F9248FB598B__INCLUDED_)
#define AFX_QUERYIDENTIFICATIONDLG_H__0E62A40D_3698_4B56_88EE_1F9248FB598B__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "..\..\..\Include\VC\Adgpib.h"
/////////////////////////////////////////////////////////////////////////////
// CQueryIdentificationDlg dialog

class CQueryIdentificationDlg : public CDialog
{
// Construction
public:
	CQueryIdentificationDlg(CWnd* pParent = NULL);	// standard constructor

// Dialog Data
	//{{AFX_DATA(CQueryIdentificationDlg)
	enum { IDD = IDD_QUERYIDENTIFICATION_DIALOG };
	int		m_GPIB;
	int		m_INST;
	CString	m_str_read;
	//}}AFX_DATA

	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CQueryIdentificationDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:
	HICON m_hIcon;

	// Generated message map functions
	//{{AFX_MSG(CQueryIdentificationDlg)
	virtual BOOL OnInitDialog();
	afx_msg void OnSysCommand(UINT nID, LPARAM lParam);
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	afx_msg void OnButtonQuery();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_QUERYIDENTIFICATIONDLG_H__0E62A40D_3698_4B56_88EE_1F9248FB598B__INCLUDED_)
