VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Sync Read/Write"
   ClientHeight    =   3612
   ClientLeft      =   60
   ClientTop       =   348
   ClientWidth     =   6396
   LinkTopic       =   "Form1"
   ScaleHeight     =   3612
   ScaleWidth      =   6396
   StartUpPosition =   3  'Windows Default
   Begin VB.ComboBox cmbGPIB 
      Height          =   315
      ItemData        =   "Form1.frx":0000
      Left            =   720
      List            =   "Form1.frx":0010
      Style           =   2  'Dropdown List
      TabIndex        =   8
      Top             =   120
      Width           =   1095
   End
   Begin VB.ComboBox cmbInst 
      Height          =   315
      ItemData        =   "Form1.frx":0030
      Left            =   3600
      List            =   "Form1.frx":008E
      Style           =   2  'Dropdown List
      TabIndex        =   6
      Top             =   120
      Width           =   975
   End
   Begin VB.TextBox textRead 
      Height          =   1215
      Left            =   120
      TabIndex        =   5
      Top             =   2280
      Width           =   6135
   End
   Begin VB.TextBox textWrite 
      Height          =   1215
      Left            =   120
      TabIndex        =   4
      Text            =   "*IDN?"
      Top             =   720
      Width           =   6135
   End
   Begin VB.CommandButton cmdRW 
      Caption         =   "Write && Read"
      Height          =   375
      Left            =   4920
      TabIndex        =   0
      Top             =   120
      Width           =   1215
   End
   Begin VB.Label Label4 
      Caption         =   "GPIB:"
      Height          =   255
      Left            =   240
      TabIndex        =   7
      Top             =   156
      Width           =   495
   End
   Begin VB.Label Label3 
      Caption         =   "Write:"
      Height          =   255
      Left            =   120
      TabIndex        =   3
      Top             =   480
      Width           =   1335
   End
   Begin VB.Label Label2 
      Caption         =   "Instrument Address:"
      Height          =   252
      Left            =   2040
      TabIndex        =   2
      Top             =   156
      Width           =   1452
   End
   Begin VB.Label Label1 
      Caption         =   "Read:"
      Height          =   255
      Left            =   120
      TabIndex        =   1
      Top             =   2040
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
'   Description: Perform the read/write operation.
'
'   ADLINK Inc. 2006


Private Sub cmdExit_Click()
    End
End Sub

Private Sub cmdRW_Click()
'    Declare variables
    Dim rdbuf As String
    
'    Open and intialize an GPIB instrument
    dev = ildev(cmbGPIB.ListIndex, cmbInst.ListIndex + 1, 0, T1s, 1, 0)
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
    
    wrtbuf$ = textWrite.Text
'    Write a string command to a GPIB instrument using the ibwrt() command
    ilwrt dev, wrtbuf$, Len(wrtbuf$)
    If (ibsta And EERR) Then
        MsgBox "Error in writing the string command to the GPIB instrument.", vbOKOnly + vbExclamation, "Error"
        GoTo Offline
    End If
    
    rdbuf = Space(100)
'    Read the response string from the GPIB instrument using the ibrd() command
    ilrd dev, rdbuf, Len(rdbuf)
    If (ibsta And EERR) Then
        MsgBox "Error in reading the response string from the GPIB instrument.", vbOKOnly + vbExclamation, "Error"
        GoTo Offline
    End If
    
    textRead.Text = rdbuf$
    
Offline:
'    Offline the GPIB interface card
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

