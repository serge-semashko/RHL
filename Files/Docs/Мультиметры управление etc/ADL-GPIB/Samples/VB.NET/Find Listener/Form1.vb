'   Example: Find Listener
'
'   Description: Find all listeners (instruments) on the GPIB bus
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
    Public WithEvents cmbGPIB As System.Windows.Forms.ComboBox
    Public WithEvents List1 As System.Windows.Forms.ListBox
    Public WithEvents cmdFind As System.Windows.Forms.Button
    Public WithEvents Label2 As System.Windows.Forms.Label
    Public WithEvents Label1 As System.Windows.Forms.Label
    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.
    'Do not modify it using the code editor.
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.components = New System.ComponentModel.Container
        Me.ToolTip1 = New System.Windows.Forms.ToolTip(Me.components)
        Me.cmbGPIB = New System.Windows.Forms.ComboBox
        Me.List1 = New System.Windows.Forms.ListBox
        Me.cmdFind = New System.Windows.Forms.Button
        Me.Label2 = New System.Windows.Forms.Label
        Me.Label1 = New System.Windows.Forms.Label
        Me.SuspendLayout()
        '
        'cmbGPIB
        '
        Me.cmbGPIB.BackColor = System.Drawing.SystemColors.Window
        Me.cmbGPIB.Cursor = System.Windows.Forms.Cursors.Default
        Me.cmbGPIB.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cmbGPIB.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.cmbGPIB.ForeColor = System.Drawing.SystemColors.WindowText
        Me.cmbGPIB.Items.AddRange(New Object() {"GPIB0", "GPIB1", "GPIB2", "GPIB3"})
        Me.cmbGPIB.Location = New System.Drawing.Point(48, 8)
        Me.cmbGPIB.Name = "cmbGPIB"
        Me.cmbGPIB.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.cmbGPIB.Size = New System.Drawing.Size(73, 22)
        Me.cmbGPIB.TabIndex = 0
        '
        'List1
        '
        Me.List1.BackColor = System.Drawing.SystemColors.Window
        Me.List1.Cursor = System.Windows.Forms.Cursors.Default
        Me.List1.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.List1.ForeColor = System.Drawing.SystemColors.WindowText
        Me.List1.ItemHeight = 14
        Me.List1.Location = New System.Drawing.Point(8, 56)
        Me.List1.Name = "List1"
        Me.List1.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.List1.Size = New System.Drawing.Size(241, 102)
        Me.List1.TabIndex = 2
        '
        'cmdFind
        '
        Me.cmdFind.BackColor = System.Drawing.SystemColors.Control
        Me.cmdFind.Cursor = System.Windows.Forms.Cursors.Default
        Me.cmdFind.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.cmdFind.ForeColor = System.Drawing.SystemColors.ControlText
        Me.cmdFind.Location = New System.Drawing.Point(184, 8)
        Me.cmdFind.Name = "cmdFind"
        Me.cmdFind.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.cmdFind.Size = New System.Drawing.Size(57, 25)
        Me.cmdFind.TabIndex = 1
        Me.cmdFind.Text = "Find"
        '
        'Label2
        '
        Me.Label2.BackColor = System.Drawing.SystemColors.Control
        Me.Label2.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label2.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label2.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label2.Location = New System.Drawing.Point(16, 10)
        Me.Label2.Name = "Label2"
        Me.Label2.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label2.Size = New System.Drawing.Size(33, 16)
        Me.Label2.TabIndex = 4
        Me.Label2.Text = "GPIB:"
        '
        'Label1
        '
        Me.Label1.BackColor = System.Drawing.SystemColors.Control
        Me.Label1.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label1.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label1.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label1.Location = New System.Drawing.Point(8, 40)
        Me.Label1.Name = "Label1"
        Me.Label1.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label1.Size = New System.Drawing.Size(137, 17)
        Me.Label1.TabIndex = 3
        Me.Label1.Text = "Instrument Address:"
        '
        'Form1
        '
        Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
        Me.BackColor = System.Drawing.SystemColors.Control
        Me.ClientSize = New System.Drawing.Size(258, 165)
        Me.Controls.Add(Me.cmbGPIB)
        Me.Controls.Add(Me.List1)
        Me.Controls.Add(Me.cmdFind)
        Me.Controls.Add(Me.Label2)
        Me.Controls.Add(Me.Label1)
        Me.Cursor = System.Windows.Forms.Cursors.Default
        Me.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Location = New System.Drawing.Point(4, 23)
        Me.Name = "Form1"
        Me.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Text = "Find Listener"
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

    Private Sub cmdFind_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles cmdFind.Click
        '    Declare variables
        Dim i As Integer
        Dim num_listeners As Integer
        Dim k As Integer
        Dim DisplayStr As String
        Dim result(30) As Short
        Dim instruments(31) As Short

        '    Reset the GPIB interface card by sending an interface clear command (SendIFC)
        Call SendIFC(cmbGPIB.SelectedIndex)
        If (ibsta And EERR) Then
            MsgBox("Error in executing the SendIFC() command.", MsgBoxStyle.OKOnly + MsgBoxStyle.Exclamation, "Error")
            End
        End If

        For k = 0 To 29
            instruments(k) = k + 1
        Next k
        instruments(30) = NOADDR

        '    Find the listeners (instruments) on the GPIB bus using the FindLstn() command
        Call FindLstn(cmbGPIB.SelectedIndex, instruments, result, 31)
        If (ibsta And EERR) Then
            MsgBox("Error in executing the FindLstn() command.", MsgBoxStyle.OKOnly + MsgBoxStyle.Exclamation, "Error")
            End
        End If

        num_listeners = ibcnt
        result(ibcntl) = NOADDR

        '    List the addresses of listeners stored in the result[] array.
        List1.Items.Clear()
        For i = 0 To num_listeners - 1
            List1.Items.Add(CStr(result(i)))
        Next i
        If i = 0 Then
            List1.Items.Add("None")
        End If

        '    Offline the GPIB interface card
        ilonl(cmbGPIB.SelectedIndex, 0)
        If (ibsta And EERR) Then
            MsgBox("Error in offline the GPIB interface card.", MsgBoxStyle.OKOnly + MsgBoxStyle.Exclamation, "Error")
            End
        End If
    End Sub

    Private Sub Form1_Load(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles MyBase.Load
        cmbGPIB.SelectedIndex = 0
    End Sub

 End Class