/********************************************************************
*	Example: Query Identification 
*
*	Description: Send a *IDN? string to an instrument and get its identification string.
*
*   ADLINK Inc. 2006
********************************************************************/	
using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using System.Windows.Forms;
using System.Data;
using System.Text;

namespace QueryIdentification
{
	/// <summary>
	/// Summary description for Form1.
	/// </summary>
	public class Form1 : System.Windows.Forms.Form
	{
		private System.Windows.Forms.ComboBox cmbGPIB;
		private System.Windows.Forms.Label label1;
		private System.Windows.Forms.Label label2;
		private System.Windows.Forms.Button btnQuery;
		private System.Windows.Forms.ComboBox cmbInst;
		private System.Windows.Forms.TextBox textBox1;
		private System.Windows.Forms.Label label3;
		/// <summary>
		/// Required designer variable.
		int ibsta, iberr, ibcnt, ibcntl;
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
			this.cmbGPIB = new System.Windows.Forms.ComboBox();
			this.label1 = new System.Windows.Forms.Label();
			this.label2 = new System.Windows.Forms.Label();
			this.btnQuery = new System.Windows.Forms.Button();
			this.cmbInst = new System.Windows.Forms.ComboBox();
			this.textBox1 = new System.Windows.Forms.TextBox();
			this.label3 = new System.Windows.Forms.Label();
			this.SuspendLayout();
			// 
			// cmbGPIB
			// 
			this.cmbGPIB.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
			this.cmbGPIB.Items.AddRange(new object[] {
														 "GPIB0",
														 "GPIB1",
														 "GPIB2",
														 "GPIB3"});
			this.cmbGPIB.Location = new System.Drawing.Point(56, 8);
			this.cmbGPIB.Name = "cmbGPIB";
			this.cmbGPIB.Size = new System.Drawing.Size(56, 20);
			this.cmbGPIB.TabIndex = 0;
			// 
			// label1
			// 
			this.label1.Location = new System.Drawing.Point(16, 10);
			this.label1.Name = "label1";
			this.label1.Size = new System.Drawing.Size(40, 16);
			this.label1.TabIndex = 1;
			this.label1.Text = "GPIB:";
			// 
			// label2
			// 
			this.label2.Location = new System.Drawing.Point(128, 10);
			this.label2.Name = "label2";
			this.label2.Size = new System.Drawing.Size(104, 16);
			this.label2.TabIndex = 2;
			this.label2.Text = "Instrument Address:";
			// 
			// btnQuery
			// 
			this.btnQuery.Location = new System.Drawing.Point(304, 8);
			this.btnQuery.Name = "btnQuery";
			this.btnQuery.Size = new System.Drawing.Size(72, 24);
			this.btnQuery.TabIndex = 3;
			this.btnQuery.Text = "Query";
			this.btnQuery.Click += new System.EventHandler(this.btnQuery_Click);
			// 
			// cmbInst
			// 
			this.cmbInst.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
			this.cmbInst.Items.AddRange(new object[] {
														 "1",
														 "2",
														 "3",
														 "4",
														 "5",
														 "6",
														 "7",
														 "8",
														 "9",
														 "10",
														 "11",
														 "12",
														 "13",
														 "14",
														 "15",
														 "16",
														 "17",
														 "18",
														 "19",
														 "20",
														 "21",
														 "22",
														 "23",
														 "24",
														 "25",
														 "26",
														 "27",
														 "28",
														 "29",
														 "30"});
			this.cmbInst.Location = new System.Drawing.Point(232, 8);
			this.cmbInst.Name = "cmbInst";
			this.cmbInst.Size = new System.Drawing.Size(56, 20);
			this.cmbInst.TabIndex = 4;
			this.cmbInst.SelectedIndexChanged += new System.EventHandler(this.comboBox1_SelectedIndexChanged);
			// 
			// textBox1
			// 
			this.textBox1.AutoSize = false;
			this.textBox1.Location = new System.Drawing.Point(8, 56);
			this.textBox1.Name = "textBox1";
			this.textBox1.Size = new System.Drawing.Size(376, 208);
			this.textBox1.TabIndex = 5;
			this.textBox1.Text = "";
			// 
			// label3
			// 
			this.label3.Location = new System.Drawing.Point(8, 40);
			this.label3.Name = "label3";
			this.label3.Size = new System.Drawing.Size(48, 16);
			this.label3.TabIndex = 6;
			this.label3.Text = "Result:";
			// 
			// Form1
			// 
			this.AutoScaleBaseSize = new System.Drawing.Size(5, 15);
			this.ClientSize = new System.Drawing.Size(392, 273);
			this.Controls.Add(this.label3);
			this.Controls.Add(this.textBox1);
			this.Controls.Add(this.cmbInst);
			this.Controls.Add(this.btnQuery);
			this.Controls.Add(this.label2);
			this.Controls.Add(this.label1);
			this.Controls.Add(this.cmbGPIB);
			this.Name = "Form1";
			this.Text = "Query Identification";
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

		private void comboBox1_SelectedIndexChanged(object sender, System.EventArgs e)
		{
		
		}

		private void btnQuery_Click(object sender, System.EventArgs e)
		{
			//Declare variables
			string strWrite;
			StringBuilder  strRead = new StringBuilder(100);
			char[] wrtbuf = new char[100];
			char[] rdbuf = new char[100];
			int dev;

			//Open and intialize an GPIB instrument
			dev = GPIB.ibdev(cmbGPIB.SelectedIndex, cmbInst.SelectedIndex+1, 0, (int)GPIB.gpib_timeout.T10s, 1, 0);
			GPIB.gpib_get_globals (out ibsta, out iberr, out ibcnt, out ibcntl);
			if ((ibsta & (int)GPIB.ibsta_bits.ERR )!= 0 )
			{
				MessageBox.Show("Error in initializing the GPIB instrument.");
				Close( );
				return;
			}

			//clear the specific GPIB instrument
			GPIB.ibclr(dev);
			GPIB.gpib_get_globals (out ibsta, out iberr, out ibcnt, out ibcntl);
			if ((ibsta & (int)GPIB.ibsta_bits.ERR )!= 0 )
			{
				MessageBox.Show("Error in clearing the GPIB device.");
				Close( );
				return;
			}

			strWrite = "*IDN?";
			//write a "*IDN?" string to the GPIB instrument
			GPIB.ibwrt (dev, strWrite, 5);
			GPIB.gpib_get_globals (out ibsta, out iberr, out ibcnt, out ibcntl);
			if ((ibsta & (int)GPIB.ibsta_bits.ERR )!= 0 )
			{
				MessageBox.Show("Error in writing *IDN? string to the instrument.");
				Close( );
				return;
			}

			//Read the returned identification string from the instrument
			GPIB.ibrd (dev, strRead, 100);
			GPIB.gpib_get_globals (out ibsta, out iberr, out ibcnt, out ibcntl);
			if ((ibsta & (int)GPIB.ibsta_bits.ERR )!= 0 )
			{
				MessageBox.Show("Error in reading identification string from the instrument.");
				Close( );
				return;
			}

			textBox1.Text = strRead.ToString();

			//Offline the GPIB instrument
			GPIB.ibonl(dev, 0);
			GPIB.gpib_get_globals (out ibsta, out iberr, out ibcnt, out ibcntl);
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
			cmbInst.SelectedIndex = 7;

		}

	}
}
