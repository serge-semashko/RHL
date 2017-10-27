/********************************************************************
*	Example: Change GPIB Address  
*
*	Description: Get/set the address of GPIB interface card using ibask/ibpad/ibsad commands.
*
*   ADLINK Inc. 2006
********************************************************************/	
using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using System.Windows.Forms;
using System.Data;

namespace ChangeGPIBAddress
{
	/// <summary>
	/// Summary description for Form1.
	/// </summary>
	public class Form1 : System.Windows.Forms.Form
	{
		private System.Windows.Forms.Label label1;
		private System.Windows.Forms.ComboBox cmbGPIB;
		private System.Windows.Forms.GroupBox groupBox1;
		private System.Windows.Forms.Label label2;
		private System.Windows.Forms.Label label3;
		private System.Windows.Forms.TextBox textPadGet;
		private System.Windows.Forms.TextBox textSadGet;
		private System.Windows.Forms.Button btnGet;
		private System.Windows.Forms.GroupBox groupBox2;
		private System.Windows.Forms.Button btnSet;
		private System.Windows.Forms.TextBox textSadSet;
		private System.Windows.Forms.TextBox textPadSet;
		private System.Windows.Forms.Label label4;
		private System.Windows.Forms.Label label5;
		private System.Windows.Forms.Label label6;
		private System.Windows.Forms.Label label7;
		/// <summary>
		/// Required designer variable.
		int ibsta, iberr, ibcnt, ibcntl;
		int ud;
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
			this.groupBox1 = new System.Windows.Forms.GroupBox();
			this.btnGet = new System.Windows.Forms.Button();
			this.textSadGet = new System.Windows.Forms.TextBox();
			this.textPadGet = new System.Windows.Forms.TextBox();
			this.label3 = new System.Windows.Forms.Label();
			this.label2 = new System.Windows.Forms.Label();
			this.groupBox2 = new System.Windows.Forms.GroupBox();
			this.label7 = new System.Windows.Forms.Label();
			this.label6 = new System.Windows.Forms.Label();
			this.btnSet = new System.Windows.Forms.Button();
			this.textSadSet = new System.Windows.Forms.TextBox();
			this.textPadSet = new System.Windows.Forms.TextBox();
			this.label4 = new System.Windows.Forms.Label();
			this.label5 = new System.Windows.Forms.Label();
			this.groupBox1.SuspendLayout();
			this.groupBox2.SuspendLayout();
			this.SuspendLayout();
			// 
			// label1
			// 
			this.label1.Location = new System.Drawing.Point(96, 10);
			this.label1.Name = "label1";
			this.label1.Size = new System.Drawing.Size(40, 16);
			this.label1.TabIndex = 0;
			this.label1.Text = "GPIB:";
			// 
			// cmbGPIB
			// 
			this.cmbGPIB.Items.AddRange(new object[] {
														 "GPIB0",
														 "GPIB1",
														 "GPIB2",
														 "GPIB3"});
			this.cmbGPIB.Location = new System.Drawing.Point(144, 8);
			this.cmbGPIB.Name = "cmbGPIB";
			this.cmbGPIB.Size = new System.Drawing.Size(80, 20);
			this.cmbGPIB.TabIndex = 1;
			this.cmbGPIB.Text = "comboBox1";
			this.cmbGPIB.SelectedValueChanged += new System.EventHandler(this.cmbGPIB_SelectedValueChanged);
			this.cmbGPIB.Click += new System.EventHandler(this.cmbGPIB_Click);
			this.cmbGPIB.SelectedIndexChanged += new System.EventHandler(this.cmbGPIB_SelectedIndexChanged);
			// 
			// groupBox1
			// 
			this.groupBox1.Controls.Add(this.btnGet);
			this.groupBox1.Controls.Add(this.textSadGet);
			this.groupBox1.Controls.Add(this.textPadGet);
			this.groupBox1.Controls.Add(this.label3);
			this.groupBox1.Controls.Add(this.label2);
			this.groupBox1.Location = new System.Drawing.Point(8, 40);
			this.groupBox1.Name = "groupBox1";
			this.groupBox1.Size = new System.Drawing.Size(328, 96);
			this.groupBox1.TabIndex = 2;
			this.groupBox1.TabStop = false;
			this.groupBox1.Text = "Get GPIB Address";
			// 
			// btnGet
			// 
			this.btnGet.Location = new System.Drawing.Point(256, 40);
			this.btnGet.Name = "btnGet";
			this.btnGet.Size = new System.Drawing.Size(56, 24);
			this.btnGet.TabIndex = 4;
			this.btnGet.Text = "Get";
			this.btnGet.Click += new System.EventHandler(this.btnGet_Click);
			// 
			// textSadGet
			// 
			this.textSadGet.Location = new System.Drawing.Point(144, 56);
			this.textSadGet.Name = "textSadGet";
			this.textSadGet.Size = new System.Drawing.Size(48, 22);
			this.textSadGet.TabIndex = 3;
			this.textSadGet.Text = "0";
			// 
			// textPadGet
			// 
			this.textPadGet.Location = new System.Drawing.Point(144, 24);
			this.textPadGet.Name = "textPadGet";
			this.textPadGet.Size = new System.Drawing.Size(48, 22);
			this.textPadGet.TabIndex = 2;
			this.textPadGet.Text = "0";
			// 
			// label3
			// 
			this.label3.Location = new System.Drawing.Point(32, 58);
			this.label3.Name = "label3";
			this.label3.Size = new System.Drawing.Size(100, 16);
			this.label3.TabIndex = 1;
			this.label3.Text = "Sedondary Address:";
			// 
			// label2
			// 
			this.label2.Location = new System.Drawing.Point(32, 26);
			this.label2.Name = "label2";
			this.label2.Size = new System.Drawing.Size(112, 16);
			this.label2.TabIndex = 0;
			this.label2.Text = "Primary Address:";
			// 
			// groupBox2
			// 
			this.groupBox2.Controls.Add(this.label7);
			this.groupBox2.Controls.Add(this.label6);
			this.groupBox2.Controls.Add(this.btnSet);
			this.groupBox2.Controls.Add(this.textSadSet);
			this.groupBox2.Controls.Add(this.textPadSet);
			this.groupBox2.Controls.Add(this.label4);
			this.groupBox2.Controls.Add(this.label5);
			this.groupBox2.Location = new System.Drawing.Point(8, 152);
			this.groupBox2.Name = "groupBox2";
			this.groupBox2.Size = new System.Drawing.Size(328, 96);
			this.groupBox2.TabIndex = 3;
			this.groupBox2.TabStop = false;
			this.groupBox2.Text = "Set GPIB Address";
			// 
			// label7
			// 
			this.label7.Location = new System.Drawing.Point(192, 58);
			this.label7.Name = "label7";
			this.label7.Size = new System.Drawing.Size(56, 16);
			this.label7.TabIndex = 6;
			this.label7.Text = "(0,96~126)";
			// 
			// label6
			// 
			this.label6.Location = new System.Drawing.Point(192, 26);
			this.label6.Name = "label6";
			this.label6.Size = new System.Drawing.Size(64, 16);
			this.label6.TabIndex = 5;
			this.label6.Text = "(0~30)";
			// 
			// btnSet
			// 
			this.btnSet.Location = new System.Drawing.Point(256, 40);
			this.btnSet.Name = "btnSet";
			this.btnSet.Size = new System.Drawing.Size(56, 24);
			this.btnSet.TabIndex = 4;
			this.btnSet.Text = "Set";
			this.btnSet.Click += new System.EventHandler(this.btnSet_Click);
			// 
			// textSadSet
			// 
			this.textSadSet.Location = new System.Drawing.Point(144, 56);
			this.textSadSet.Name = "textSadSet";
			this.textSadSet.Size = new System.Drawing.Size(48, 22);
			this.textSadSet.TabIndex = 3;
			this.textSadSet.Text = "0";
			// 
			// textPadSet
			// 
			this.textPadSet.Location = new System.Drawing.Point(144, 24);
			this.textPadSet.Name = "textPadSet";
			this.textPadSet.Size = new System.Drawing.Size(48, 22);
			this.textPadSet.TabIndex = 2;
			this.textPadSet.Text = "0";
			// 
			// label4
			// 
			this.label4.Location = new System.Drawing.Point(32, 58);
			this.label4.Name = "label4";
			this.label4.Size = new System.Drawing.Size(100, 16);
			this.label4.TabIndex = 1;
			this.label4.Text = "Sedondary Address:";
			// 
			// label5
			// 
			this.label5.Location = new System.Drawing.Point(32, 26);
			this.label5.Name = "label5";
			this.label5.Size = new System.Drawing.Size(112, 16);
			this.label5.TabIndex = 0;
			this.label5.Text = "Primary Address:";
			// 
			// Form1
			// 
			this.AutoScaleBaseSize = new System.Drawing.Size(5, 15);
			this.ClientSize = new System.Drawing.Size(344, 261);
			this.Controls.Add(this.groupBox2);
			this.Controls.Add(this.groupBox1);
			this.Controls.Add(this.cmbGPIB);
			this.Controls.Add(this.label1);
			this.Name = "Form1";
			this.Text = "Change GPIB Address";
			this.Load += new System.EventHandler(this.Form1_Load);
			this.Closed += new System.EventHandler(this.Form1_Closed);
			this.groupBox1.ResumeLayout(false);
			this.groupBox2.ResumeLayout(false);
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

		private void btnGet_Click(object sender, System.EventArgs e)
		{
			//declare variables
			int rval=0;
			string str;
    
			//Read the primary GPIB address of GPIB interface card using ibask command
			GPIB.ibask (ud, (int)GPIB.ibask_option.IbaPAD, ref rval);
			GPIB.gpib_get_globals (out ibsta, out iberr, out ibcnt, out ibcntl);
			if ((ibsta & (int)GPIB.ibsta_bits.ERR )!= 0 )
			{
				MessageBox.Show("Error in querying the primary address of GPIB interface card.");
			}

			textPadGet.Text=string.Format("{0}",rval);
    
			//Read the secondary GPIB address of GPIB interface card using ibask command
			GPIB.ibask (ud, (int)GPIB.ibask_option.IbaSAD, ref rval);
			GPIB.gpib_get_globals (out ibsta, out iberr, out ibcnt, out ibcntl);
			if ((ibsta & (int)GPIB.ibsta_bits.ERR )!= 0 )
			{
				MessageBox.Show("Error in querying the secondary address of GPIB interface card.");
			}
			textSadGet.Text=string.Format("{0}",rval);

		}

		private void Form1_Load(object sender, System.EventArgs e)
		{
			cmbGPIB.SelectedIndex = 0;

		}

		private void Form1_Closed(object sender, System.EventArgs e)
		{
		}

		private void btnSet_Click(object sender, System.EventArgs e)
		{
			//declare variables
			string str;
    
			//Set the primary GPIB address of GPIB interface card using ibpad command
			GPIB.ibpad(ud, int.Parse(textPadSet.Text));
			GPIB.gpib_get_globals (out ibsta, out iberr, out ibcnt, out ibcntl);
			if ((ibsta & (int)GPIB.ibsta_bits.ERR )!= 0 )
			{
				MessageBox.Show("Error in setting the primary address of GPIB interface card.");
			}

			//Set the secondary GPIB address of GPIB interface card using ibsad command 
			GPIB.ibsad(ud, int.Parse(textSadSet.Text));
			GPIB.gpib_get_globals (out ibsta, out iberr, out ibcnt, out ibcntl);
			if ((ibsta & (int)GPIB.ibsta_bits.ERR )!= 0 )
			{
				MessageBox.Show("Error in setting the secondary address of GPIB interface card.");
			}
		}

		private void cmbGPIB_SelectedIndexChanged(object sender, System.EventArgs e)
		{
		}

		private void cmbGPIB_Click(object sender, System.EventArgs e)
		{
		}

		private void cmbGPIB_SelectedValueChanged(object sender, System.EventArgs e)
		{
			string str;

			//    Offline the GPIB interface card
			GPIB.ibonl( ud, 0);

			str=string.Format("GPIB{0}", cmbGPIB.SelectedIndex);
			//Find the GPIB interface card
			ud = GPIB.ibfind(str);
			GPIB.gpib_get_globals (out ibsta, out iberr, out ibcnt, out ibcntl);
			if ((ibsta & (int)GPIB.ibsta_bits.ERR )!= 0 )
			{
				MessageBox.Show("Error in finding the GPIB interface card.");
			}
			
		}
	}
}
