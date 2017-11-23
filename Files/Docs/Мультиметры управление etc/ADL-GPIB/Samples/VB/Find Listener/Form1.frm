VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Find Listener"
   ClientHeight    =   2625
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   3870
   LinkTopic       =   "Form1"
   ScaleHeight     =   2625
   ScaleWidth      =   3870
   StartUpPosition =   3  'Windows Default
   Begin VB.ComboBox cmbGPIB 
      Height          =   315
      ItemData        =   "Form1.frx":0000
      Left            =   720
      List            =   "Form1.frx":0010
      Style           =   2  'Dropdown List
      TabIndex        =   0
      Top             =   120
      Width           =   1095
   End
   Begin VB.ListBox List1 
      Height          =   1620
      Left            =   120
      TabIndex        =   2
      Top             =   840
      Width           =   3615
   End
   Begin VB.CommandButton cmdFind 
      Caption         =   "Find"
      Height          =   375
      Left            =   2760
      TabIndex        =   1
      Top             =   120
      Width           =   855
   End
   Begin VB.Label Label2 
      Caption         =   "GPIB:"
      Height          =   255
      Left            =   240
      TabIndex        =   4
      Top             =   150
      Width           =   495
   End
   Begin VB.Label Label1 
      Caption         =   "Instrument Address:"
      Height          =   255
      Left            =   120
      TabIndex        =   3
      Top             =   600
      Width           =   2055
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'   Example: Find Listener
'
'   Description: Find all listeners (instruments) on the GPIB bus
'
'   ADLINK Inc. 2006

Private Sub cmdFind_Click()
'    Declare variables
    Dim DisplayStr As String
    ReDim result(30) As Integer
    ReDim instruments(31) As Integer
    
'    Reset the GPIB interface card by sending an interface clear command (SendIFC)
    Call SendIFC(cmbGPIB.ListIndex)
    If (ibsta And EERR) Then
        MsgBox "Error in executing the SendIFC() command.", vbOKOnly + vbExclamation, "Error"
        End
    End If
    
    For k = 0 To 29
        instruments%(k) = k + 1
    Next k
    instruments(30) = NOADDR

'    Find the listeners (instruments) on the GPIB bus using the FindLstn() command
    Call FindLstn(cmbGPIB.ListIndex, instruments(), result(), 31)
    If (ibsta And EERR) Then
        MsgBox "Error in executing the FindLstn() command.", vbOKOnly + vbExclamation, "Error"
        End
    End If

    num_listeners = ibcnt
    result%(ibcntl) = NOADDR
    
'    List the addresses of listeners stored in the result[] array.
    List1.Clear
    For i = 0 To num_listeners - 1
        List1.AddItem result(i)
    Next i
    If i = 0 Then
        List1.AddItem "None"
    End If
    
'    Offline the GPIB interface card
    ilonl GPIB0, 0
    If (ibsta And EERR) Then
        MsgBox "Error in offline the GPIB interface card.", vbOKOnly + vbExclamation, "Error"
        End
    End If
End Sub

Private Sub Form_Load()
    cmbGPIB.ListIndex = 0
End Sub
