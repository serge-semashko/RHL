/********************************************************************
*	Example: Find Listener 
*
*	Description: Find all listeners (instruments) on the GPIB bus
*
*   ADLINK Inc. 2006
********************************************************************/	
using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using System.Windows.Forms;
using System.Data;

namespace WindowsApplication1
{
	/// <summary>
	/// Summary description for Form1.
	/// </summary>
	public class Form1 : System.Windows.Forms.Form
	{
		private System.Windows.Forms.Label label1;
		private System.Windows.Forms.ComboBox cmbGPIB;
		private System.Windows.Forms.ListBox listBox1;
		private System.Windows.Forms.Button btnFind;

		int ibsta, iberr, ibcnt, ibcntl;
		private System.Windows.Forms.Label label2;
		/// <summary>
		/// Required designer variable.
		/// </summary>
		private System.ComponentModel.Container components = null;

		public Form1()
		{
			//
			// Required for Windows Form Designer support
			//
			InitializeComponent();

			//
			// TODO: Add any constructor code after InitializeComponent call
			//
		}

		/// <summary>
		/// Clean up any resources being used.
		/// </summary>
		protected override void Dispose( bool disposing )
		{
			if( disposing )
			{
				if (components != null) 
				{
					components.Dispose();
				}
			}
			base.Dispose( disposing );
		}

		#region Windows Form Designer generated code
		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{
			this.label1 = new System.Windows.Forms.Label();
			this.cmbGPIB = new System.Windows.Forms.ComboBox();
			this.listBox1 = new System.Windows.Forms.ListBox();
			this.btnFind = new System.Windows.Forms.Button();
			this.label2 = new System.Windows.Forms.Label();
			this.SuspendLayout();
			// 
			// label1
			// 
			this.label1.Location = new System.Drawing.Point(24, 18);
			this.label1.Name = "label1";
			this.label1.Size = new System.Drawing.Size(40, 16);
			this.label1.TabIndex = 0;
			this.label1.Text = "GPIB:";
			// 
			// cmbGPIB
			// 
			this.cmbGPIB.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
			this.cmbGPIB.Items.AddRange(new object[] {
														 "GPIB0",
														 "GPIB1",
														 "GPIB2",
														 "GPIB3"});
			this.cmbGPIB.Location = new System.Drawing.Point(64, 16);
			this.cmbGPIB.Name = "cmbGPIB";
			this.cmbGPIB.Size = new System.Drawing.Size(64, 20);
			this.cmbGPIB.TabIndex = 1;
			this.cmbGPIB.SelectedIndexChanged += new System.EventHandler(this.cmbGPIB_SelectedIndexChanged);
			// 
			// listBox1
			// 
			this.listBox1.ItemHeight = 12;
			this.listBox1.Location = new System.Drawing.Point(16, 64);
			this.listBox1.Name = "listBox1";
			this.listBox1.Size = new System.Drawing.Size(264, 184);
			this.listBox1.TabIndex = 2;
			// 
			// btnFind
			// 
			this.btnFind.Location = new System.Drawing.Point(176, 16);
			this.btnFind.Name = "btnFind";
			this.btnFind.Size = new System.Drawing.Size(80, 24);
			this.btnFind.TabIndex = 3;
			this.btnFind.Text = "Find";
			this.btnFind.Click += new System.EventHandler(this.btnFind_Click);
			// 
			// label2
			// 
			this.label2.Location = new System.Drawing.Point(16, 48);
			this.label2.Name = "label2";
			this.label2.Size = new System.Drawing.Size(100, 16);
			this.label2.TabIndex = 4;
			this.label2.Text = "Instrument Address:";
			// 
			// Form1
			// 
			this.AutoScaleBaseSize = new System.Drawing.Size(5, 15);
			this.ClientSize = new System.Drawing.Size(292, 273);
			this.Controls.Add(this.label2);
			this.Controls.Add(this.btnFind);
			this.Controls.Add(this.listBox1);
			this.Controls.Add(this.cmbGPIB);
			this.Controls.Add(this.label1);
			this.Name = "Form1";
			this.Text = "Find Listener";
			this.Load += new System.EventHandler(this.Form1_Load);
			this.ResumeLayout(false);

		}
		#endregion

		/// <summary>
		/// The main entry point for the application.
		/// </summary>
		[STAThread]
		static void Main() 
		{
			Application.Run(new Form1());
		}

		private void cmbGPIB_SelectedIndexChanged(object sender, System.EventArgs e)
		{
		
		}

		private void btnFind_Click(object sender, System.EventArgs e)
		{
			//Declare variables
			ushort[] result = new ushort[30];
			ushort[] instruments = new ushort[31];   
			int num_listeners;
			ushort i,k;
			string str;

			//Reset the GPIB interface card by sending an interface clear command (SendIFC)
			GPIB.SendIFC(cmbGPIB.SelectedIndex);
			GPIB.gpib_get_globals (out ibsta, out iberr, out ibcnt, out ibcntl);
			if ((ibsta & (int)GPIB.ibsta_bits.ERR )!= 0 )
			{
				MessageBox.Show("Error in executing the SendIFC() command.");
				Close( );
				return;
			}
    
			for ( k=0 ; k<30 ; k++ )
			{
				instruments[k] = (ushort)(k + 1);
			}
			instruments[30] = GPIB.NOADDR;

			//Find the listeners (instruments) on the GPIB bus using the FindLstn() command
			GPIB.FindLstn(0, instruments, result, 31);
			GPIB.gpib_get_globals (out ibsta, out iberr, out ibcnt, out ibcntl);
			if ((ibsta & (int)GPIB.ibsta_bits.ERR )!= 0 )
			{
				MessageBox.Show("Error in executing the FindLstn() command.");
				Close( );
				return;
			}

			num_listeners = ibcnt;
    
			//List the addresses of listeners stored in the result[] array.
			listBox1.Items.Clear();
			for ( i=0;i < num_listeners;i++)
			{
				str = string.Format("{0}", result[i]);				
				listBox1.Items.Add(str);
			}
			if(i==0)
			{
				listBox1.Items.Add("None");
			}
    
			//Offline the GPIB interface card
			GPIB.ibonl( cmbGPIB.SelectedIndex, 0);
			if ((ibsta & (int)GPIB.ibsta_bits.ERR )!= 0 )
			{
				MessageBox.Show("Error in offline the GPIB interface card.");
				Close( );
				return;
			}
		
		}

		private void Form1_Load(object sender, System.EventArgs e)
		{
			cmbGPIB.SelectedIndex = 0;

		}

	}
}
