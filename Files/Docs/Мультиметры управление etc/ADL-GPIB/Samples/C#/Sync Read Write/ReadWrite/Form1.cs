/********************************************************************
*	Example: Query Identification 
*
*	Description: Perform the read/write operation.
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

namespace ReadWrite
{
	/// <summary>
	/// Summary description for Form1.
	/// </summary>
	public class Form1 : System.Windows.Forms.Form
	{
		private System.Windows.Forms.Label label1;
		private System.Windows.Forms.ComboBox cmbGPIB;
		private System.Windows.Forms.Label label2;
		private System.Windows.Forms.Button button1;
		private System.Windows.Forms.TextBox textWrite;
		private System.Windows.Forms.TextBox textRead;
		private System.Windows.Forms.Label label3;
		private System.Windows.Forms.Label label4;
		/// <summary>
		/// Required designer variable.
		int ibsta, iberr, ibcnt, ibcntl;
		private System.Windows.Forms.ComboBox cmbInst;
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
			this.label2 = new System.Windows.Forms.Label();
			this.cmbInst = new System.Windows.Forms.ComboBox();
			this.button1 = new System.Windows.Forms.Button();
			this.textWrite = new System.Windows.Forms.TextBox();
			this.textRead = new System.Windows.Forms.TextBox();
			this.label3 = new System.Windows.Forms.Label();
			this.label4 = new System.Windows.Forms.Label();
			this.SuspendLayout();
			// 
			// label1
			// 
			this.label1.Location = new System.Drawing.Point(8, 10);
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
			this.cmbGPIB.Location = new System.Drawing.Point(48, 8);
			this.cmbGPIB.Name = "cmbGPIB";
			this.cmbGPIB.Size = new System.Drawing.Size(64, 20);
			this.cmbGPIB.TabIndex = 1;
			// 
			// label2
			// 
			this.label2.Location = new System.Drawing.Point(128, 10);
			this.label2.Name = "label2";
			this.label2.Size = new System.Drawing.Size(104, 16);
			this.label2.TabIndex = 2;
			this.label2.Text = "Instrument Address:";
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
			this.cmbInst.Size = new System.Drawing.Size(72, 20);
			this.cmbInst.TabIndex = 3;
			// 
			// button1
			// 
			this.button1.Location = new System.Drawing.Point(320, 8);
			this.button1.Name = "button1";
			this.button1.Size = new System.Drawing.Size(88, 24);
			this.button1.TabIndex = 4;
			this.button1.Text = "Write && Read";
			this.button1.Click += new System.EventHandler(this.button1_Click);
			// 
			// textWrite
			// 
			this.textWrite.Location = new System.Drawing.Point(8, 56);
			this.textWrite.Name = "textWrite";
			this.textWrite.Size = new System.Drawing.Size(400, 22);
			this.textWrite.TabIndex = 5;
			this.textWrite.Text = "*IDN?";
			// 
			// textRead
			// 
			this.textRead.AutoSize = false;
			this.textRead.Location = new System.Drawing.Point(8, 104);
			this.textRead.Name = "textRead";
			this.textRead.Size = new System.Drawing.Size(400, 152);
			this.textRead.TabIndex = 6;
			this.textRead.Text = "";
			// 
			// label3
			// 
			this.label3.Location = new System.Drawing.Point(8, 40);
			this.label3.Name = "label3";
			this.label3.Size = new System.Drawing.Size(48, 16);
			this.label3.TabIndex = 7;
			this.label3.Text = "Write:";
			// 
			// label4
			// 
			this.label4.Location = new System.Drawing.Point(8, 88);
			this.label4.Name = "label4";
			this.label4.Size = new System.Drawing.Size(64, 16);
			this.label4.TabIndex = 8;
			this.label4.Text = "Read:";
			// 
			// Form1
			// 
			this.AutoScaleBaseSize = new System.Drawing.Size(5, 15);
			this.ClientSize = new System.Drawing.Size(424, 273);
			this.Controls.Add(this.label4);
			this.Controls.Add(this.label3);
			this.Controls.Add(this.textRead);
			this.Controls.Add(this.textWrite);
			this.Controls.Add(this.button1);
			this.Controls.Add(this.cmbInst);
			this.Controls.Add(this.label2);
			this.Controls.Add(this.cmbGPIB);
			this.Controls.Add(this.label1);
			this.Name = "Form1";
			this.Text = "Write & Read";
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

		private void button1_Click(object sender, System.EventArgs e)
		{
			//Declare variables
			string strWrite;
			StringBuilder  strRead = new StringBuilder(100);
			char[] wrtbuf = new char[100];
			char[] rdbuf = new char[100];
			int dev;

			//Open and intialize an GPIB instrument
			dev = GPIB.ibdev(cmbGPIB.SelectedIndex, cmbInst.SelectedIndex+1, 0, (int)GPIB.gpib_timeout.T1s, 1, 0);
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

			strWrite = textWrite.Text;
			//Write a string command to a GPIB instrument using the ibwrt() command
			GPIB.ibwrt (dev, strWrite, strWrite.Length);
			GPIB.gpib_get_globals (out ibsta, out iberr, out ibcnt, out ibcntl);
			if ((ibsta & (int)GPIB.ibsta_bits.ERR )!= 0 )
			{
				MessageBox.Show("Error in writing the string command to the GPIB instrument.");
				Close( );
				return;
			}

			//Read the response string from the GPIB instrument using the ibrd() command
			GPIB.ibrd (dev, strRead, 100);
			GPIB.gpib_get_globals (out ibsta, out iberr, out ibcnt, out ibcntl);
			if ((ibsta & (int)GPIB.ibsta_bits.ERR )!= 0 )
			{
				MessageBox.Show("Error in reading the response string from the GPIB instrument.");
				Close( );
				return;
			}


			textRead.Text = strRead.ToString();

			//Offline the GPIB interface card
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
