// Change GPIB AddressDlg.h : header file
//

#if !defined(AFX_CHANGEGPIBADDRESSDLG_H__8F713D2D_9160_4871_B7C1_DF5F2861F030__INCLUDED_)
#define AFX_CHANGEGPIBADDRESSDLG_H__8F713D2D_9160_4871_B7C1_DF5F2861F030__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "..\..\..\Include\VC\Adgpib.h"
/////////////////////////////////////////////////////////////////////////////
// CChangeGPIBAddressDlg dialog

class CChangeGPIBAddressDlg : public CDialog
{
// Construction
public:
    int ud;
	CChangeGPIBAddressDlg(CWnd* pParent = NULL);	// standard constructor

// Dialog Data
	//{{AFX_DATA(CChangeGPIBAddressDlg)
	enum { IDD = IDD_CHANGEGPIBADDRESS_DIALOG };
	int		m_gpib;
	CString	m_pad_set;
	CString	m_sad_set;
	CString	m_pad_get;
	CString	m_sad_get;
	//}}AFX_DATA

	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CChangeGPIBAddressDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:
	HICON m_hIcon;

	// Generated message map functions
	//{{AFX_MSG(CChangeGPIBAddressDlg)
	virtual BOOL OnInitDialog();
	afx_msg void OnSysCommand(UINT nID, LPARAM lParam);
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	afx_msg void OnButtonSet();
	afx_msg void OnButtonGet();
	afx_msg void OnEditchangeComboGpib();
	afx_msg void OnSelchangeComboGpib();
	afx_msg void OnClose();
	afx_msg int OnCreate(LPCREATESTRUCT lpCreateStruct);
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_CHANGEGPIBADDRESSDLG_H__8F713D2D_9160_4871_B7C1_DF5F2861F030__INCLUDED_)
