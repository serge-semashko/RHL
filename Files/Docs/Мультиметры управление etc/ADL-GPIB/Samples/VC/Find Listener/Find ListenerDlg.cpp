/********************************************************************
*	Example: Find Listener 
*
*	Description: Find all listeners (instruments) on the GPIB bus
*
*   ADLINK Inc. 2006
********************************************************************/	
// Find ListenerDlg.cpp : implementation file
//

#include "stdafx.h"
#include "Find Listener.h"
#include "Find ListenerDlg.h"

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
// CFindListenerDlg dialog

CFindListenerDlg::CFindListenerDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CFindListenerDlg::IDD, pParent)
{
	//{{AFX_DATA_INIT(CFindListenerDlg)
	m_gpib = 0;
	//}}AFX_DATA_INIT
	// Note that LoadIcon does not require a subsequent DestroyIcon in Win32
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
}

void CFindListenerDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CFindListenerDlg)
	DDX_Control(pDX, IDC_LIST1, m_list1);
	DDX_CBIndex(pDX, IDC_COMBO_BPIB, m_gpib);
	//}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CFindListenerDlg, CDialog)
	//{{AFX_MSG_MAP(CFindListenerDlg)
	ON_WM_SYSCOMMAND()
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	ON_BN_CLICKED(IDC_BUTTON_FIND, OnButtonFind)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CFindListenerDlg message handlers

BOOL CFindListenerDlg::OnInitDialog()
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

void CFindListenerDlg::OnSysCommand(UINT nID, LPARAM lParam)
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

void CFindListenerDlg::OnPaint() 
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
HCURSOR CFindListenerDlg::OnQueryDragIcon()
{
	return (HCURSOR) m_hIcon;
}

void CFindListenerDlg::OnButtonFind() 
{
	//Declare variables
	CString DisplayStr;
    Addr4882_t result[31];
    Addr4882_t instruments[32];   
	int num_listeners;
	int i,k;
	CString str;

	UpdateData();

    //Reset the GPIB interface card by sending an interface clear command (SendIFC)
	SendIFC(m_gpib);
    if (ibsta & ERR)
	{
        AfxMessageBox("Error in executing the SendIFC() command.");
		OnCancel( );
		return;
    }
    
	//Fill the addresses of listeners into an array 
    for ( k=0 ; k<30 ; k++ )
	{
        instruments[k] = k + 1;
    }
    instruments[30] = NOADDR;

    //Find the listeners (instruments) on the GPIB bus using the FindLstn() command
	FindLstn(m_gpib, instruments, result, 31);
    if (ibsta & ERR) 
	{
        AfxMessageBox("Error in executing the FindLstn() command.");
		OnCancel( );
		return;
    }

    num_listeners = ibcnt;
    result[ibcnt] = NOADDR;
    
	//List the addresses of listeners stored in the result[] array. 
	for ( i=0;i < m_list1.GetCount();i++)
	{
		m_list1.DeleteString( i );
	}
	for ( i=0;i < num_listeners;i++)
	{
		str.Format("%d", result[i]);
        m_list1.AddString(str);
    }
	if(i==0)
	{
		m_list1.AddString("None");
    }
    
	//Offline the GPIB interface card
    ibonl( m_gpib, 0);
    if (ibsta & ERR)
	{
        AfxMessageBox("Error in offline the GPIB interface card.");
		OnCancel( );
		return;
   }
}
