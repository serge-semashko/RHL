VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Query Identification"
   ClientHeight    =   3408
   ClientLeft      =   60
   ClientTop       =   348
   ClientWidth     =   6036
   LinkTopic       =   "Form1"
   ScaleHeight     =   3408
   ScaleWidth      =   6036
   StartUpPosition =   3  'Windows Default
   Begin VB.TextBox textRead 
      Height          =   2295
      Left            =   120
      TabIndex        =   6
      Top             =   960
      Width           =   5775
   End
   Begin VB.ComboBox cmbInst 
      Height          =   315
      ItemData        =   "Form1.frx":0000
      Left            =   3480
      List            =   "Form1.frx":005E
      Style           =   2  'Dropdown List
      TabIndex        =   5
      Top             =   120
      Width           =   855
   End
   Begin VB.ComboBox cmbGPIB 
      Height          =   315
      ItemData        =   "Form1.frx":00D1
      Left            =   720
      List            =   "Form1.frx":00E1
      Style           =   2  'Dropdown List
      TabIndex        =   3
      Top             =   120
      Width           =   855
   End
   Begin VB.CommandButton cmdQuery 
      Caption         =   "*IDN?"
      Height          =   375
      Left            =   4800
      TabIndex        =   0
      Top             =   120
      Width           =   975
   End
   Begin VB.Label Label3 
      Caption         =   "GPIB:"
      Height          =   252
      Left            =   240
      TabIndex        =   4
      Top             =   156
      Width           =   492
   End
   Begin VB.Label Label2 
      Caption         =   "Instrument Address:"
      Height          =   252
      Left            =   1920
      TabIndex        =   2
      Top             =   156
      Width           =   1452
   End
   Begin VB.Label Label1 
      Caption         =   "Result:"
      Height          =   255
      Left            =   120
      TabIndex        =   1
      Top             =   720
      Width           =   2055
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'   Example: Query Identification
'
'   Description: Send a *IDN? string to an instrument and get its identification string.
'
'   ADLINK Inc. 2006

Const GPIB0 = 0

Private Sub cmdQuery_Click()
'    Declare variables
    Dim Reading As String
    Dim iListener As Integer
    
    iListener = cmbInst.ListIndex + 1
    
'    Open and intialize an GPIB instrument
    dev = ildev(cmbGPIB.ListIndex, iListener, _
                0, T10s, 1, 0)
    If (ibsta And EERR) Then
        MsgBox "Error in initializing the GPIB instrument.", vbOKOnly + vbExclamation, "Error"
        GoTo Offline
    End If
    
'    clear the specific GPIB instrument
    ilclr dev
    If (ibsta And EERR) Then
        MsgBox "Error in clearing the GPIB device.", vbOKOnly + vbExclamation, "Error"
        GoTo Offline
    End If
    
    wrtbuf$ = "*IDN?"
'    write a "*IDN?" string to the GPIB instrument
    ilwrt dev, wrtbuf$, Len(wrtbuf$)
    If (ibsta And EERR) Then
        MsgBox "Error in writing *IDN? string to the instrument.", vbOKOnly + vbExclamation, "Error"
        GoTo Offline
    End If
    
'    Read the returned identification string from the instrument
    rdbuf$ = Space$(100)
    ilrd dev, rdbuf$, Len(rdbuf$)
    If (ibsta And EERR) Then
        MsgBox "Error in reading identification string from the instrument.", vbOKOnly + vbExclamation, "Error"
        GoTo Offline
    End If
    
    textRead.Text = rdbuf$
    
Offline:
'    Offline the GPIB instrument
    ilonl dev, 0
    If (ibsta And EERR) Then
        MsgBox "Error in offline the GPIB interface card.", vbOKOnly + vbExclamation, "Error"
        End
    End If
End Sub

Private Sub Form_Load()
    cmbGPIB.ListIndex = 0
    cmbInst.ListIndex = 7
End Sub

