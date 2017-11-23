'   Example: Change GPIB Address
'
'   Description: Get/set the address of GPIB interface card using ibask/ibpad/ibsad commands.
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
    Public WithEvents textSetCardPad As System.Windows.Forms.TextBox
    Public WithEvents textSetCardSad As System.Windows.Forms.TextBox
    Public WithEvents cmdSet As System.Windows.Forms.Button
    Public WithEvents Label6 As System.Windows.Forms.Label
    Public WithEvents Label5 As System.Windows.Forms.Label
    Public WithEvents Label4 As System.Windows.Forms.Label
    Public WithEvents Label3 As System.Windows.Forms.Label
    Public WithEvents Frame2 As System.Windows.Forms.GroupBox
    Public WithEvents Label2 As System.Windows.Forms.Label
    Public WithEvents Label1 As System.Windows.Forms.Label
    Public WithEvents Frame1 As System.Windows.Forms.GroupBox
    Public WithEvents Label7 As System.Windows.Forms.Label
    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.
    'Do not modify it using the code editor.
    Public WithEvents cmdGet As System.Windows.Forms.Button
    Public WithEvents textGetCardSad As System.Windows.Forms.TextBox
    Public WithEvents textGetCardPad As System.Windows.Forms.TextBox
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.components = New System.ComponentModel.Container
        Me.ToolTip1 = New System.Windows.Forms.ToolTip(Me.components)
        Me.cmbGPIB = New System.Windows.Forms.ComboBox
        Me.Frame2 = New System.Windows.Forms.GroupBox
        Me.textSetCardPad = New System.Windows.Forms.TextBox
        Me.textSetCardSad = New System.Windows.Forms.TextBox
        Me.cmdSet = New System.Windows.Forms.Button
        Me.Label6 = New System.Windows.Forms.Label
        Me.Label5 = New System.Windows.Forms.Label
        Me.Label4 = New System.Windows.Forms.Label
        Me.Label3 = New System.Windows.Forms.Label
        Me.Frame1 = New System.Windows.Forms.GroupBox
        Me.textGetCardSad = New System.Windows.Forms.TextBox
        Me.textGetCardPad = New System.Windows.Forms.TextBox
        Me.cmdGet = New System.Windows.Forms.Button
        Me.Label2 = New System.Windows.Forms.Label
        Me.Label1 = New System.Windows.Forms.Label
        Me.Label7 = New System.Windows.Forms.Label
        Me.Frame2.SuspendLayout()
        Me.Frame1.SuspendLayout()
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
        Me.cmbGPIB.Location = New System.Drawing.Point(88, 16)
        Me.cmbGPIB.Name = "cmbGPIB"
        Me.cmbGPIB.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.cmbGPIB.Size = New System.Drawing.Size(97, 22)
        Me.cmbGPIB.TabIndex = 15
        '
        'Frame2
        '
        Me.Frame2.BackColor = System.Drawing.SystemColors.Control
        Me.Frame2.Controls.Add(Me.textSetCardPad)
        Me.Frame2.Controls.Add(Me.textSetCardSad)
        Me.Frame2.Controls.Add(Me.cmdSet)
        Me.Frame2.Controls.Add(Me.Label6)
        Me.Frame2.Controls.Add(Me.Label5)
        Me.Frame2.Controls.Add(Me.Label4)
        Me.Frame2.Controls.Add(Me.Label3)
        Me.Frame2.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Frame2.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Frame2.Location = New System.Drawing.Point(8, 152)
        Me.Frame2.Name = "Frame2"
        Me.Frame2.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Frame2.Size = New System.Drawing.Size(265, 105)
        Me.Frame2.TabIndex = 2
        Me.Frame2.TabStop = False
        Me.Frame2.Text = "Set GPIB address"
        '
        'textSetCardPad
        '
        Me.textSetCardPad.AcceptsReturn = True
        Me.textSetCardPad.AutoSize = False
        Me.textSetCardPad.BackColor = System.Drawing.SystemColors.Window
        Me.textSetCardPad.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.textSetCardPad.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.textSetCardPad.ForeColor = System.Drawing.SystemColors.WindowText
        Me.textSetCardPad.Location = New System.Drawing.Point(112, 24)
        Me.textSetCardPad.MaxLength = 0
        Me.textSetCardPad.Name = "textSetCardPad"
        Me.textSetCardPad.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.textSetCardPad.Size = New System.Drawing.Size(49, 19)
        Me.textSetCardPad.TabIndex = 11
        Me.textSetCardPad.Text = "0"
        '
        'textSetCardSad
        '
        Me.textSetCardSad.AcceptsReturn = True
        Me.textSetCardSad.AutoSize = False
        Me.textSetCardSad.BackColor = System.Drawing.SystemColors.Window
        Me.textSetCardSad.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.textSetCardSad.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.textSetCardSad.ForeColor = System.Drawing.SystemColors.WindowText
        Me.textSetCardSad.Location = New System.Drawing.Point(112, 64)
        Me.textSetCardSad.MaxLength = 0
        Me.textSetCardSad.Name = "textSetCardSad"
        Me.textSetCardSad.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.textSetCardSad.Size = New System.Drawing.Size(49, 19)
        Me.textSetCardSad.TabIndex = 10
        Me.textSetCardSad.Text = "0"
        '
        'cmdSet
        '
        Me.cmdSet.BackColor = System.Drawing.SystemColors.Control
        Me.cmdSet.Cursor = System.Windows.Forms.Cursors.Default
        Me.cmdSet.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.cmdSet.ForeColor = System.Drawing.SystemColors.ControlText
        Me.cmdSet.Location = New System.Drawing.Point(168, 40)
        Me.cmdSet.Name = "cmdSet"
        Me.cmdSet.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.cmdSet.Size = New System.Drawing.Size(81, 33)
        Me.cmdSet.TabIndex = 3
        Me.cmdSet.Text = "Set"
        '
        'Label6
        '
        Me.Label6.BackColor = System.Drawing.SystemColors.Control
        Me.Label6.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label6.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label6.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label6.Location = New System.Drawing.Point(32, 80)
        Me.Label6.Name = "Label6"
        Me.Label6.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label6.Size = New System.Drawing.Size(121, 17)
        Me.Label6.TabIndex = 13
        Me.Label6.Text = "(0,96~126) "
        '
        'Label5
        '
        Me.Label5.BackColor = System.Drawing.SystemColors.Control
        Me.Label5.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label5.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label5.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label5.Location = New System.Drawing.Point(40, 40)
        Me.Label5.Name = "Label5"
        Me.Label5.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label5.Size = New System.Drawing.Size(40, 17)
        Me.Label5.TabIndex = 12
        Me.Label5.Text = "(0~30)"
        '
        'Label4
        '
        Me.Label4.BackColor = System.Drawing.SystemColors.Control
        Me.Label4.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label4.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label4.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label4.Location = New System.Drawing.Point(8, 66)
        Me.Label4.Name = "Label4"
        Me.Label4.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label4.Size = New System.Drawing.Size(104, 17)
        Me.Label4.TabIndex = 7
        Me.Label4.Text = "Secondary Address:"
        '
        'Label3
        '
        Me.Label3.BackColor = System.Drawing.SystemColors.Control
        Me.Label3.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label3.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label3.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label3.Location = New System.Drawing.Point(8, 26)
        Me.Label3.Name = "Label3"
        Me.Label3.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label3.Size = New System.Drawing.Size(89, 17)
        Me.Label3.TabIndex = 6
        Me.Label3.Text = "Primary Address:"
        '
        'Frame1
        '
        Me.Frame1.BackColor = System.Drawing.SystemColors.Control
        Me.Frame1.Controls.Add(Me.textGetCardSad)
        Me.Frame1.Controls.Add(Me.textGetCardPad)
        Me.Frame1.Controls.Add(Me.cmdGet)
        Me.Frame1.Controls.Add(Me.Label2)
        Me.Frame1.Controls.Add(Me.Label1)
        Me.Frame1.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Frame1.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Frame1.Location = New System.Drawing.Point(8, 56)
        Me.Frame1.Name = "Frame1"
        Me.Frame1.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Frame1.Size = New System.Drawing.Size(265, 81)
        Me.Frame1.TabIndex = 0
        Me.Frame1.TabStop = False
        Me.Frame1.Text = "Get GPIB address"
        '
        'textGetCardSad
        '
        Me.textGetCardSad.AcceptsReturn = True
        Me.textGetCardSad.AutoSize = False
        Me.textGetCardSad.BackColor = System.Drawing.SystemColors.Window
        Me.textGetCardSad.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.textGetCardSad.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.textGetCardSad.ForeColor = System.Drawing.SystemColors.WindowText
        Me.textGetCardSad.Location = New System.Drawing.Point(112, 48)
        Me.textGetCardSad.MaxLength = 0
        Me.textGetCardSad.Name = "textGetCardSad"
        Me.textGetCardSad.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.textGetCardSad.Size = New System.Drawing.Size(49, 19)
        Me.textGetCardSad.TabIndex = 9
        Me.textGetCardSad.Text = "0"
        '
        'textGetCardPad
        '
        Me.textGetCardPad.AcceptsReturn = True
        Me.textGetCardPad.AutoSize = False
        Me.textGetCardPad.BackColor = System.Drawing.SystemColors.Window
        Me.textGetCardPad.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.textGetCardPad.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.textGetCardPad.ForeColor = System.Drawing.SystemColors.WindowText
        Me.textGetCardPad.Location = New System.Drawing.Point(112, 24)
        Me.textGetCardPad.MaxLength = 0
        Me.textGetCardPad.Name = "textGetCardPad"
        Me.textGetCardPad.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.textGetCardPad.Size = New System.Drawing.Size(49, 19)
        Me.textGetCardPad.TabIndex = 8
        Me.textGetCardPad.Text = "0"
        '
        'cmdGet
        '
        Me.cmdGet.BackColor = System.Drawing.SystemColors.Control
        Me.cmdGet.Cursor = System.Windows.Forms.Cursors.Default
        Me.cmdGet.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.cmdGet.ForeColor = System.Drawing.SystemColors.ControlText
        Me.cmdGet.Location = New System.Drawing.Point(168, 32)
        Me.cmdGet.Name = "cmdGet"
        Me.cmdGet.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.cmdGet.Size = New System.Drawing.Size(81, 33)
        Me.cmdGet.TabIndex = 1
        Me.cmdGet.Text = "Get"
        '
        'Label2
        '
        Me.Label2.BackColor = System.Drawing.SystemColors.Control
        Me.Label2.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label2.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label2.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label2.Location = New System.Drawing.Point(8, 50)
        Me.Label2.Name = "Label2"
        Me.Label2.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label2.Size = New System.Drawing.Size(104, 17)
        Me.Label2.TabIndex = 5
        Me.Label2.Text = "Secondary Address:"
        '
        'Label1
        '
        Me.Label1.BackColor = System.Drawing.SystemColors.Control
        Me.Label1.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label1.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label1.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label1.Location = New System.Drawing.Point(8, 26)
        Me.Label1.Name = "Label1"
        Me.Label1.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label1.Size = New System.Drawing.Size(89, 17)
        Me.Label1.TabIndex = 4
        Me.Label1.Text = "Primary Address:"
        '
        'Label7
        '
        Me.Label7.BackColor = System.Drawing.SystemColors.Control
        Me.Label7.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label7.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label7.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label7.Location = New System.Drawing.Point(48, 18)
        Me.Label7.Name = "Label7"
        Me.Label7.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label7.Size = New System.Drawing.Size(33, 17)
        Me.Label7.TabIndex = 14
        Me.Label7.Text = "GPIB:"
        '
        'Form1
        '
        Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
        Me.BackColor = System.Drawing.SystemColors.Control
        Me.ClientSize = New System.Drawing.Size(286, 272)
        Me.Controls.Add(Me.cmbGPIB)
        Me.Controls.Add(Me.Frame2)
        Me.Controls.Add(Me.Frame1)
        Me.Controls.Add(Me.Label7)
        Me.Cursor = System.Windows.Forms.Cursors.Default
        Me.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Location = New System.Drawing.Point(4, 23)
        Me.Name = "Form1"
        Me.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Text = "Change GPIB Address"
        Me.Frame2.ResumeLayout(False)
        Me.Frame1.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub
#End Region
#Region "Upgrade Support "
    Private Shared m_vb6FormDefInstance As Form1
    Private Shared m_InitializingDefInstance As Boolean
    Dim ud As Short

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

    Private Sub cmdGet_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles cmdGet.Click
        '    declare variables
        Dim rval As Short

        '    Read the primary GPIB address of GPIB interface card using ibask command
        ibask(ud, IbaPAD, rval)
        If (ibsta And EERR) Then
            MsgBox("Error in querying the primary address of GPIB interface card.", MsgBoxStyle.OKOnly + MsgBoxStyle.Exclamation, "Error")
        End If
        textGetCardPad.Text = Str(rval)

        '    Read the secondary GPIB address of GPIB interface card using ibask command
        ibask(ud, IbaSAD, rval)
        If (ibsta And EERR) Then
            MsgBox("Error in querying the secondary address of GPIB interface card.", MsgBoxStyle.OKOnly + MsgBoxStyle.Exclamation, "Error")
        End If
        textGetCardSad.Text = Str(rval)
    End Sub

    Private Sub cmdSet_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles cmdSet.Click

        '    Set the primary GPIB address of GPIB interface card using ibpad command
        ibpad(ud, Val(textSetCardPad.Text))
        If (ibsta And EERR) Then
            MsgBox("Error in setting the primary address of GPIB interface card.", MsgBoxStyle.OKOnly + MsgBoxStyle.Exclamation, "Error")
        End If

        '    Set the secondary GPIB address of GPIB interface card using ibsad command 
        ibsad(ud, Val(textSetCardSad.Text))
        If (ibsta And EERR) Then
            MsgBox("Error in setting the secondary address of GPIB interface card.", MsgBoxStyle.OKOnly + MsgBoxStyle.Exclamation, "Error")
        End If

    End Sub

    Private Sub Form1_Load(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles MyBase.Load
        cmbGPIB.SelectedIndex = 0
    End Sub

    Private Sub Form1_Closed(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles MyBase.Closed
        ilonl(ud, 0)
        If (ibsta And EERR) Then
            MsgBox("Error offlineing the GPIB interface card.", MsgBoxStyle.OKOnly + MsgBoxStyle.Exclamation, "Error")
            End
        End If

    End Sub

    Private Sub cmbGPIB_SelectedIndexChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmbGPIB.SelectedIndexChanged
        '    Offline the GPIB interface card
        ilonl(ud, 0)

        '    Find the GPIB interface card
        ibfind(cmbGPIB.Text, ud)
        If (ibsta And EERR) Then
            MsgBox("Error in finding the GPIB interface card.", MsgBoxStyle.OKOnly + MsgBoxStyle.Exclamation, "Error")
            End
        End If

    End Sub
End Class