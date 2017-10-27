VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Change GPIB Address"
   ClientHeight    =   4080
   ClientLeft      =   60
   ClientTop       =   348
   ClientWidth     =   4800
   LinkTopic       =   "Form1"
   ScaleHeight     =   4080
   ScaleWidth      =   4800
   StartUpPosition =   3  'Windows Default
   Begin VB.ComboBox cmbGPIB 
      Height          =   315
      ItemData        =   "Form1.frx":0000
      Left            =   1320
      List            =   "Form1.frx":0010
      Style           =   2  'Dropdown List
      TabIndex        =   15
      Top             =   240
      Width           =   1455
   End
   Begin VB.Frame Frame2 
      Caption         =   "Set GPIB address"
      Height          =   1575
      Left            =   120
      TabIndex        =   2
      Top             =   2280
      Width           =   4572
      Begin VB.TextBox textSetCardPad 
         Height          =   285
         Left            =   2160
         TabIndex        =   11
         Text            =   "0"
         Top             =   360
         Width           =   735
      End
      Begin VB.TextBox textSetCardSad 
         Height          =   285
         Left            =   2160
         TabIndex        =   10
         Text            =   "0"
         Top             =   960
         Width           =   735
      End
      Begin VB.CommandButton cmdSet 
         Caption         =   "Set"
         Height          =   495
         Left            =   3120
         TabIndex        =   3
         Top             =   600
         Width           =   1215
      End
      Begin VB.Label Label6 
         Caption         =   "(0,96~126) "
         Height          =   255
         Left            =   480
         TabIndex        =   13
         Top             =   1200
         Width           =   1815
      End
      Begin VB.Label Label5 
         Caption         =   "(0~30)"
         Height          =   255
         Left            =   480
         TabIndex        =   12
         Top             =   600
         Width           =   1335
      End
      Begin VB.Label Label4 
         Caption         =   "Secondary Address:"
         Height          =   252
         Left            =   240
         TabIndex        =   7
         Top             =   996
         Width           =   1812
      End
      Begin VB.Label Label3 
         Caption         =   "Primary Address:"
         Height          =   252
         Left            =   240
         TabIndex        =   6
         Top             =   396
         Width           =   1812
      End
   End
   Begin VB.Frame Frame1 
      Caption         =   "Get GPIB address"
      Height          =   1215
      Left            =   120
      TabIndex        =   0
      Top             =   840
      Width           =   4572
      Begin VB.TextBox textGetCardSad 
         Height          =   285
         Left            =   2160
         TabIndex        =   9
         Text            =   "0"
         Top             =   720
         Width           =   735
      End
      Begin VB.TextBox textGetCardPad 
         Height          =   285
         Left            =   2160
         TabIndex        =   8
         Text            =   "0"
         Top             =   360
         Width           =   735
      End
      Begin VB.CommandButton cmdGet 
         Caption         =   "Get"
         Height          =   495
         Left            =   3120
         TabIndex        =   1
         Top             =   480
         Width           =   1215
      End
      Begin VB.Label Label2 
         Caption         =   "Secondary Address:"
         Height          =   252
         Left            =   240
         TabIndex        =   5
         Top             =   756
         Width           =   1932
      End
      Begin VB.Label Label1 
         Caption         =   "Primary Address:"
         Height          =   255
         Left            =   240
         TabIndex        =   4
         Top             =   390
         Width           =   1335
      End
   End
   Begin VB.Label Label7 
      Caption         =   "GPIB:"
      Height          =   255
      Left            =   720
      TabIndex        =   14
      Top             =   270
      Width           =   495
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'   Example: Change GPIB Address
'
'   Description: Get/set the address of GPIB interface card using ibask/ibpad/ibsad commands.
'
'   ADLINK Inc. 2006

Dim ud As Integer

Private Sub cmbGPIB_Click()
'    Offline the GPIB interface card
    ilonl ud, 0
    
'    Find the GPIB interface card
    ibfind cmbGPIB.Text, ud
    If (ibsta And EERR) Then
        MsgBox "Error in Finding the GPIB interface card", vbOKOnly + vbExclamation, "Error"
    End If


End Sub

Private Sub cmdGet_Click()
'    declare variables
    Dim rval As Integer
    
'    Read the primary GPIB address of GPIB interface card using ibask command
    ibask ud, IbaPAD, rval
    If (ibsta And EERR) Then
        MsgBox "Error in querying the primary address of GPIB interface card.", vbOKOnly + vbExclamation, "Error"
    End If
    textGetCardPad.Text = Str(rval)
    
'    Read the secondary GPIB address of GPIB interface card using ibask command
    ibask ud, IbaSAD, rval
    If (ibsta And EERR) Then
        MsgBox "Error in querying the secondary address of GPIB interface card.", vbOKOnly + vbExclamation, "Error"
    End If
    
    textGetCardSad.Text = Str(rval)
End Sub

Private Sub cmdSet_Click()
    
'    Set the primary GPIB address of GPIB interface card using ibpad command
    ibpad ud, Val(textSetCardPad.Text)
    If (ibsta And EERR) Then
        MsgBox "Error in setting the primary address of GPIB interface card.", vbOKOnly + vbExclamation, "Error"
    End If
    
'    Set the secondary GPIB address of GPIB interface card using ibsad command
    ibsad ud, Val(textSetCardSad.Text)
    If (ibsta And EERR) Then
        MsgBox "Error in setting the secondary address of GPIB interface card.", vbOKOnly + vbExclamation, "Error"
    End If

End Sub

Private Sub Form_Load()
    cmbGPIB.ListIndex = 0
End Sub

Private Sub Form_Unload(Cancel As Integer)
'    Offline the GPIB interface card
    ilonl ud, 0

End Sub

