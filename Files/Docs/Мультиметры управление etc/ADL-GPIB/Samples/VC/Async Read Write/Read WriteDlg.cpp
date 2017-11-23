/********************************************************************
*	Example: Read/Write Operation 
*
*	Description: Perform the asynchronous read/write operation.
*
*   ADLINK Inc. 2006
********************************************************************/	
// Read WriteDlg.cpp : implementation file
//

#include "stdafx.h"
#include "Read Write.h"
#include "Read WriteDlg.h"

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
// CReadWriteDlg dialog

CReadWriteDlg::CReadWriteDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CReadWriteDlg::IDD, pParent)
{
	//{{AFX_DATA_INIT(CReadWriteDlg)
	m_str_read = _T("");
	m_str_write = _T("*IDN?");
	m_istr = 7;
	m_gpib = 0;
	//}}AFX_DATA_INIT
	// Note that LoadIcon does not require a subsequent DestroyIcon in Win32
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
}

void CReadWriteDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CReadWriteDlg)
	DDX_Text(pDX, IDC_EDIT_READ, m_str_read);
	DDX_Text(pDX, IDC_EDIT_WRITE, m_str_write);
	DDX_CBIndex(pDX, IDC_COMBO_ISTR, m_istr);
	DDX_CBIndex(pDX, IDC_COMBO_GPIB, m_gpib);
	//}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CReadWriteDlg, CDialog)
	//{{AFX_MSG_MAP(CReadWriteDlg)
	ON_WM_SYSCOMMAND()
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	ON_BN_CLICKED(IDC_BUTTON_RW, OnButtonRw)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CReadWriteDlg message handlers

BOOL CReadWriteDlg::OnInitDialog()
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

void CReadWriteDlg::OnSysCommand(UINT nID, LPARAM lParam)
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

void CReadWriteDlg::OnPaint() 
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
HCURSOR CReadWriteDlg::OnQueryDragIcon()
{
	return (HCURSOR) m_hIcon;
}

void CReadWriteDlg::OnButtonRw() 
{
	//Declare variables
    CString wrtbuf, Reading;
	char rdbuf[100];
    int dev;

	UpdateData();
 
	//Open and intialize an GPIB instrument
    dev = ibdev(m_gpib, m_istr+1, 0, T1s, 1, 0);
    if (ibsta & ERR)
	{
        AfxMessageBox("Error in initializing the GPIB instrument.");
		return;
    }

	//clear the specific GPIB instrument
	ibclr(dev);
    if (ibsta & ERR)
	{
        AfxMessageBox("Error in clearing the GPIB device.");
		ibonl(dev, 0);
		return;
    }

    wrtbuf = m_str_write;
	//Write a string command to a GPIB instrument asynchronously using the ibwrta() command
    ibwrta(dev, wrtbuf, wrtbuf.GetLength());
    if (ibsta & ERR)
	{
        AfxMessageBox("Error in writing the string command to the GPIB instrument.");
		ibonl(dev, 0);
		return;
    }

	//Wait for the completion of asynchronous write operation
    ibwait(dev, CMPL);
    if (ibsta & ERR)
	{
        AfxMessageBox("Writing the string command to the GPIB instrument timeout.");
		ibonl(dev, 0);
		return;
    }

    //Read the response string from the GPIB instrument asynchronously using the ibrda() command
	ibrda(dev, rdbuf, 100);
    if (ibsta & ERR)
	{
        AfxMessageBox("Error in reading the response string from the GPIB instrument.");
		ibonl(dev, 0);
		return;
    }

	//Wait for the completion of asynchronous read operation
	ibwait(dev, CMPL);
    if (ibsta & ERR)
	{
        AfxMessageBox("Reading the response string from the GPIB instrument timeout.");
		ibonl(dev, 0);
		return;
    }

	rdbuf[ibcnt]=0;

	m_str_read = rdbuf;

	//Offline the GPIB interface card
	ibonl(dev, 0);
    if (ibsta & ERR)
	{
        AfxMessageBox("Error in offline the GPIB interface card.");
    }
	
	UpdateData(false);
	
}
