// Find ListenerDlg.h : header file
//

#if !defined(AFX_FINDLISTENERDLG_H__C0108CC4_26F3_4773_B2D3_37AC19D8F1B1__INCLUDED_)
#define AFX_FINDLISTENERDLG_H__C0108CC4_26F3_4773_B2D3_37AC19D8F1B1__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "..\..\..\Include\VC\Adgpib.h"

/////////////////////////////////////////////////////////////////////////////
// CFindListenerDlg dialog

class CFindListenerDlg : public CDialog
{
// Construction
public:
	CFindListenerDlg(CWnd* pParent = NULL);	// standard constructor

// Dialog Data
	//{{AFX_DATA(CFindListenerDlg)
	enum { IDD = IDD_FINDLISTENER_DIALOG };
	CListBox	m_list1;
	int		m_gpib;
	//}}AFX_DATA

	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CFindListenerDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:
	HICON m_hIcon;

	// Generated message map functions
	//{{AFX_MSG(CFindListenerDlg)
	virtual BOOL OnInitDialog();
	afx_msg void OnSysCommand(UINT nID, LPARAM lParam);
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	afx_msg void OnButtonFind();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_FINDLISTENERDLG_H__C0108CC4_26F3_4773_B2D3_37AC19D8F1B1__INCLUDED_)
