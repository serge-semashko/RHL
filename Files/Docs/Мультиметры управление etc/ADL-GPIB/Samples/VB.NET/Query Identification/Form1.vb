'   Example: Query Identification
'
'   Description: Send a *IDN? string to an instrument and get its identification string.
'
'   ADLINK Inc. 2006
Option Strict Off
Option Explicit On 
Friend Class Form1
    Inherits System.Windows.Forms.Form
#Region "Windows Form Designer generated code "
    Public Sub New()
        MyBase.New()
        If m_vb6FormDefInstance Is Nothing Then
            If m_InitializingDefInstance Then
                m_vb6FormDefInstance = Me
            Else
                Try
                    'For the start-up form, the first instance created is the default instance.
                    If System.Reflection.Assembly.GetExecutingAssembly.EntryPoint.DeclaringType Is Me.GetType Then
                        m_vb6FormDefInstance = Me
                    End If
                Catch
                End Try
            End If
        End If
        'This call is required by the Windows Form Designer.
        InitializeComponent()
    End Sub
    'Form overrides dispose to clean up the component list.
    Protected Overloads Overrides Sub Dispose(ByVal Disposing As Boolean)
        If Disposing Then
            If Not components Is Nothing Then
                components.Dispose()
            End If
        End If
        MyBase.Dispose(Disposing)
    End Sub
    'Required by the Windows Form Designer
    Private components As System.ComponentModel.IContainer
    Public ToolTip1 As System.Windows.Forms.ToolTip
    Public WithEvents textRead As System.Windows.Forms.TextBox
    Public WithEvents cmbInst As System.Windows.Forms.ComboBox
    Public WithEvents cmbGPIB As System.Windows.Forms.ComboBox
    Public WithEvents cmdQuery As System.Windows.Forms.Button
    Public WithEvents Label3 As System.Windows.Forms.Label
    Public WithEvents Label2 As System.Windows.Forms.Label
    Public WithEvents Label1 As System.Windows.Forms.Label
    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.
    'Do not modify it using the code editor.
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.components = New System.ComponentModel.Container
        Me.ToolTip1 = New System.Windows.Forms.ToolTip(Me.components)
        Me.textRead = New System.Windows.Forms.TextBox
        Me.cmbInst = New System.Windows.Forms.ComboBox
        Me.cmbGPIB = New System.Windows.Forms.ComboBox
        Me.cmdQuery = New System.Windows.Forms.Button
        Me.Label3 = New System.Windows.Forms.Label
        Me.Label2 = New System.Windows.Forms.Label
        Me.Label1 = New System.Windows.Forms.Label
        Me.SuspendLayout()
        '
        'textRead
        '
        Me.textRead.AcceptsReturn = True
        Me.textRead.AutoSize = False
        Me.textRead.BackColor = System.Drawing.SystemColors.Window
        Me.textRead.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.textRead.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.textRead.ForeColor = System.Drawing.SystemColors.WindowText
        Me.textRead.Location = New System.Drawing.Point(8, 64)
        Me.textRead.MaxLength = 0
        Me.textRead.Name = "textRead"
        Me.textRead.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.textRead.Size = New System.Drawing.Size(385, 153)
        Me.textRead.TabIndex = 6
        Me.textRead.Text = ""
        '
        'cmbInst
        '
        Me.cmbInst.BackColor = System.Drawing.SystemColors.Window
        Me.cmbInst.Cursor = System.Windows.Forms.Cursors.Default
        Me.cmbInst.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cmbInst.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.cmbInst.ForeColor = System.Drawing.SystemColors.WindowText
        Me.cmbInst.Items.AddRange(New Object() {"1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30"})
        Me.cmbInst.Location = New System.Drawing.Point(232, 8)
        Me.cmbInst.Name = "cmbInst"
        Me.cmbInst.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.cmbInst.Size = New System.Drawing.Size(57, 22)
        Me.cmbInst.TabIndex = 5
        '
        'cmbGPIB
        '
        Me.cmbGPIB.BackColor = System.Drawing.SystemColors.Window
        Me.cmbGPIB.Cursor = System.Windows.Forms.Cursors.Default
        Me.cmbGPIB.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cmbGPIB.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.cmbGPIB.ForeColor = System.Drawing.SystemColors.WindowText
        Me.cmbGPIB.Items.AddRange(New Object() {"GPIB0", "GPIB1", "GPIB2", "GPIB3"})
        Me.cmbGPIB.Location = New System.Drawing.Point(40, 8)
        Me.cmbGPIB.Name = "cmbGPIB"
        Me.cmbGPIB.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.cmbGPIB.Size = New System.Drawing.Size(57, 22)
        Me.cmbGPIB.TabIndex = 3
        '
        'cmdQuery
        '
        Me.cmdQuery.BackColor = System.Drawing.SystemColors.Control
        Me.cmdQuery.Cursor = System.Windows.Forms.Cursors.Default
        Me.cmdQuery.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.cmdQuery.ForeColor = System.Drawing.SystemColors.ControlText
        Me.cmdQuery.Location = New System.Drawing.Point(320, 8)
        Me.cmdQuery.Name = "cmdQuery"
        Me.cmdQuery.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.cmdQuery.Size = New System.Drawing.Size(65, 25)
        Me.cmdQuery.TabIndex = 0
        Me.cmdQuery.Text = "*IDN?"
        '
        'Label3
        '
        Me.Label3.BackColor = System.Drawing.SystemColors.Control
        Me.Label3.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label3.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label3.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label3.Location = New System.Drawing.Point(8, 10)
        Me.Label3.Name = "Label3"
        Me.Label3.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label3.Size = New System.Drawing.Size(33, 17)
        Me.Label3.TabIndex = 4
        Me.Label3.Text = "GPIB:"
        '
        'Label2
        '
        Me.Label2.BackColor = System.Drawing.SystemColors.Control
        Me.Label2.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label2.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label2.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label2.Location = New System.Drawing.Point(128, 10)
        Me.Label2.Name = "Label2"
        Me.Label2.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label2.Size = New System.Drawing.Size(104, 17)
        Me.Label2.TabIndex = 2
        Me.Label2.Text = "Instrument Address:"
        '
        'Label1
        '
        Me.Label1.BackColor = System.Drawing.SystemColors.Control
        Me.Label1.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label1.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label1.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label1.Location = New System.Drawing.Point(8, 48)
        Me.Label1.Name = "Label1"
        Me.Label1.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label1.Size = New System.Drawing.Size(137, 17)
        Me.Label1.TabIndex = 1
        Me.Label1.Text = "Result:"
        '
        'Form1
        '
        Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
        Me.BackColor = System.Drawing.SystemColors.Control
        Me.ClientSize = New System.Drawing.Size(402, 227)
        Me.Controls.Add(Me.textRead)
        Me.Controls.Add(Me.cmbInst)
        Me.Controls.Add(Me.cmbGPIB)
        Me.Controls.Add(Me.cmdQuery)
        Me.Controls.Add(Me.Label3)
        Me.Controls.Add(Me.Label2)
        Me.Controls.Add(Me.Label1)
        Me.Cursor = System.Windows.Forms.Cursors.Default
        Me.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Location = New System.Drawing.Point(4, 23)
        Me.Name = "Form1"
        Me.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Text = "Query Identification"
        Me.ResumeLayout(False)

    End Sub
#End Region
#Region "Upgrade Support "
    Private Shared m_vb6FormDefInstance As Form1
    Private Shared m_InitializingDefInstance As Boolean
    Public Shared Property DefInstance() As Form1
        Get
            If m_vb6FormDefInstance Is Nothing OrElse m_vb6FormDefInstance.IsDisposed Then
                m_InitializingDefInstance = True
                m_vb6FormDefInstance = New Form1
                m_InitializingDefInstance = False
            End If
            DefInstance = m_vb6FormDefInstance
        End Get
        Set(ByVal Value As Form1)
            m_vb6FormDefInstance = Value
        End Set
    End Property
#End Region

    Const GPIB0 As Short = 0

    Private Sub cmdQuery_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles cmdQuery.Click
        '    Declare variables
        Dim rdbuf As String
        Dim wrtbuf As String
        Dim dev As Object
        Dim Reading As String
        Dim iListener As Short

        iListener = cmbInst.SelectedIndex + 1

        '    Open and intialize an GPIB instrument
        dev = ildev(cmbGPIB.SelectedIndex, iListener, 0, T1s, 1, 0)
        If (ibsta And EERR) Then
            MsgBox("Error in initializing the GPIB instrument.", MsgBoxStyle.OKOnly + MsgBoxStyle.Exclamation, "Error")
            GoTo Offline
        End If

        '    clear the specific GPIB instrument
        ilclr(dev)
        If (ibsta And EERR) Then
            MsgBox("Error in clearing the GPIB device.", MsgBoxStyle.OKOnly + MsgBoxStyle.Exclamation, "Error")
            GoTo Offline
        End If

        wrtbuf = "*IDN?"
        '    write a "*IDN?" string to the GPIB instrument
        ilwrt(dev, wrtbuf, Len(wrtbuf))
        If (ibsta And EERR) Then
            MsgBox("Error in writing *IDN? string to the instrument.", MsgBoxStyle.OKOnly + MsgBoxStyle.Exclamation, "Error")
            GoTo Offline
        End If

        rdbuf = Space(100)
        '    Read the returned identification string from the instrument
        ilrd(dev, rdbuf, Len(rdbuf))
        If (ibsta And EERR) Then
            MsgBox("Error in reading identification string from the instrument.", MsgBoxStyle.OKOnly + MsgBoxStyle.Exclamation, "Error")
            GoTo Offline
        End If

        textRead.Text = rdbuf

Offline:
        '    Offline the GPIB instrument
        ilonl(dev, 0)
        If (ibsta And EERR) Then
            MsgBox("Error in offline the GPIB interface card.", MsgBoxStyle.OKOnly + MsgBoxStyle.Exclamation, "Error")
            End
        End If
    End Sub

    Private Sub Form1_Load(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles MyBase.Load
        cmbGPIB.SelectedIndex = 0
        cmbInst.SelectedIndex = 7
    End Sub
End Class