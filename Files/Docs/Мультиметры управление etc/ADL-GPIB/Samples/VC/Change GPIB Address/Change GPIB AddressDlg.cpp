/********************************************************************
*	Example: Change GPIB Address
*
*	Description: Get/set the address of GPIB interface card using ibask/ibpad/ibsad commands.
*
*   ADLINK Inc. 2006
********************************************************************/	
// Change GPIB AddressDlg.cpp : implementation file
//

#include "stdafx.h"
#include "Change GPIB Address.h"
#include "Change GPIB AddressDlg.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CAboutDlg dialog used for App About

class CAboutDlg : public CDialog
{
public:
	CAboutDlg();

// Dialog Data
	//{{AFX_DATA(CAboutDlg)
	enum { IDD = IDD_ABOUTBOX };
	//}}AFX_DATA

	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CAboutDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:
	//{{AFX_MSG(CAboutDlg)
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

CAboutDlg::CAboutDlg() : CDialog(CAboutDlg::IDD)
{
	//{{AFX_DATA_INIT(CAboutDlg)
	//}}AFX_DATA_INIT
}

void CAboutDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CAboutDlg)
	//}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CAboutDlg, CDialog)
	//{{AFX_MSG_MAP(CAboutDlg)
		// No message handlers
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CChangeGPIBAddressDlg dialog

CChangeGPIBAddressDlg::CChangeGPIBAddressDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CChangeGPIBAddressDlg::IDD, pParent)
{
	//{{AFX_DATA_INIT(CChangeGPIBAddressDlg)
	m_gpib = 0;
	m_pad_set = _T("0");
	m_sad_set = _T("0");
	m_pad_get = _T("0");
	m_sad_get = _T("0");
	//}}AFX_DATA_INIT
	// Note that LoadIcon does not require a subsequent DestroyIcon in Win32
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
}

void CChangeGPIBAddressDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CChangeGPIBAddressDlg)
	DDX_CBIndex(pDX, IDC_COMBO_GPIB, m_gpib);
	DDX_Text(pDX, IDC_EDIT_PAD_SET, m_pad_set);
	DDX_Text(pDX, IDC_EDIT_SAD_SET, m_sad_set);
	DDX_Text(pDX, IDC_EDIT_PAD_GET, m_pad_get);
	DDX_Text(pDX, IDC_EDIT_SAD_GET, m_sad_get);
	//}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CChangeGPIBAddressDlg, CDialog)
	//{{AFX_MSG_MAP(CChangeGPIBAddressDlg)
	ON_WM_SYSCOMMAND()
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	ON_BN_CLICKED(IDC_BUTTON_SET, OnButtonSet)
	ON_BN_CLICKED(IDC_BUTTON_GET, OnButtonGet)
	ON_CBN_EDITCHANGE(IDC_COMBO_GPIB, OnEditchangeComboGpib)
	ON_CBN_SELCHANGE(IDC_COMBO_GPIB, OnSelchangeComboGpib)
	ON_WM_CLOSE()
	ON_WM_CREATE()
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CChangeGPIBAddressDlg message handlers

BOOL CChangeGPIBAddressDlg::OnInitDialog()
{
	CDialog::OnInitDialog();

	// Add "About..." menu item to system menu.

	// IDM_ABOUTBOX must be in the system command range.
	ASSERT((IDM_ABOUTBOX & 0xFFF0) == IDM_ABOUTBOX);
	ASSERT(IDM_ABOUTBOX < 0xF000);

	CMenu* pSysMenu = GetSystemMenu(FALSE);
	if (pSysMenu != NULL)
	{
		CString strAboutMenu;
		strAboutMenu.LoadString(IDS_ABOUTBOX);
		if (!strAboutMenu.IsEmpty())
		{
			pSysMenu->AppendMenu(MF_SEPARATOR);
			pSysMenu->AppendMenu(MF_STRING, IDM_ABOUTBOX, strAboutMenu);
		}
	}

	// Set the icon for this dialog.  The framework does this automatically
	//  when the application's main window is not a dialog
	SetIcon(m_hIcon, TRUE);			// Set big icon
	SetIcon(m_hIcon, FALSE);		// Set small icon
	
	// TODO: Add extra initialization here
	
	return TRUE;  // return TRUE  unless you set the focus to a control
}

void CChangeGPIBAddressDlg::OnSysCommand(UINT nID, LPARAM lParam)
{
	if ((nID & 0xFFF0) == IDM_ABOUTBOX)
	{
		CAboutDlg dlgAbout;
		dlgAbout.DoModal();
	}
	else
	{
		CDialog::OnSysCommand(nID, lParam);
	}
}

// If you add a minimize button to your dialog, you will need the code below
//  to draw the icon.  For MFC applications using the document/view model,
//  this is automatically done for you by the framework.

void CChangeGPIBAddressDlg::OnPaint() 
{
	if (IsIconic())
	{
		CPaintDC dc(this); // device context for painting

		SendMessage(WM_ICONERASEBKGND, (WPARAM) dc.GetSafeHdc(), 0);

		// Center icon in client rectangle
		int cxIcon = GetSystemMetrics(SM_CXICON);
		int cyIcon = GetSystemMetrics(SM_CYICON);
		CRect rect;
		GetClientRect(&rect);
		int x = (rect.Width() - cxIcon + 1) / 2;
		int y = (rect.Height() - cyIcon + 1) / 2;

		// Draw the icon
		dc.DrawIcon(x, y, m_hIcon);
	}
	else
	{
		CDialog::OnPaint();
	}
}

// The system calls this to obtain the cursor to display while the user drags
//  the minimized window.
HCURSOR CChangeGPIBAddressDlg::OnQueryDragIcon()
{
	return (HCURSOR) m_hIcon;
}

void CChangeGPIBAddressDlg::OnButtonGet() 
{
	//declare variables
    int rval;
	CString str;
    
	UpdateData();

	str.Format("GPIB%d", m_gpib);
	//Find the GPIB interface card
    ud = ibfind(str);
    
	//Read the primary GPIB address of GPIB interface card using ibask command 
    ibask (ud, IbaPAD, &rval);
    if (ibsta & ERR)
	{
        AfxMessageBox("Error in querying the primary address of GPIB interface card.");
    }

    m_pad_get.Format("%d",rval);
    
	//Read the secondary GPIB address of GPIB interface card using ibask command
    ibask (ud, IbaSAD, &rval);
    if (ibsta & ERR)
	{
        AfxMessageBox("Error in querying the secondary address of GPIB interface card.");
    }
    m_sad_get.Format("%d",rval);

	UpdateData(false);
}

void CChangeGPIBAddressDlg::OnButtonSet() 
{
	//declare variables
	CString str;
    
	UpdateData();

	str.Format("GPIB%d", m_gpib);
	//Find the GPIB interface card
    ud = ibfind(str);

	//Set the primary GPIB address of GPIB interface card using ibpad command 
    ibpad(ud, atoi(m_pad_set));
    if (ibsta & ERR)
	{
        AfxMessageBox("Error in setting the primary address of GPIB interface card.");
    }

	//Set the secondary GPIB address of GPIB interface card using ibsad command 
    ibsad(ud, atoi(m_sad_set));
    if (ibsta & ERR)
	{
        AfxMessageBox("Error in setting the secondary address of GPIB interface card.");
    }

}


void CChangeGPIBAddressDlg::OnEditchangeComboGpib() 
{
	// TODO: Add your control notification handler code here
	
}

void CChangeGPIBAddressDlg::OnSelchangeComboGpib() 
{
	// TODO: Add your control notification handler code here
	CString str;
    
	UpdateData();
    //Offline the GPIB interface card
    ibonl( ud, 0);

	str.Format("GPIB%d", m_gpib);
	//Find the GPIB interface card
    ud = ibfind(str);
    if ( ud<0 )
	{
        AfxMessageBox("Error in finding the GPIB interface card.");
    }
	
}

void CChangeGPIBAddressDlg::OnClose() 
{
	// TODO: Add your message handler code here and/or call default
    //Offline the GPIB interface card
    ibonl( ud, 0);
	
	CDialog::OnClose();
}

int CChangeGPIBAddressDlg::OnCreate(LPCREATESTRUCT lpCreateStruct) 
{
	if (CDialog::OnCreate(lpCreateStruct) == -1)
		return -1;
	
	// TODO: Add your specialized creation code here
	ud = 0;
	
	return 0;
}
