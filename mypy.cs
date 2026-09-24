using System;
using System.Diagnostics;
using System.IO;
using System.Windows.Forms;

namespace PythonIDE
{
    public partial class Form1 : Form
    {
        TextBox txtCode;
        TextBox txtOutput;
        Button btnRun;

        public Form1()
        {
            InitializeComponent();
            CreateUI();
        }

        private void CreateUI()
        {
            this.Text = "Python IDE";
            this.Width = 1000;
            this.Height = 700;

            txtCode = new TextBox();
            txtCode.Multiline = true;
            txtCode.ScrollBars = ScrollBars.Both;
            txtCode.Font = new System.Drawing.Font("Consolas", 11);
            txtCode.SetBounds(10, 10, 960, 450);

            btnRun = new Button();
            btnRun.Text = "Run Python";
            btnRun.SetBounds(10, 470, 120, 35);
            btnRun.Click += BtnRun_Click;

            txtOutput = new TextBox();
            txtOutput.Multiline = true;
            txtOutput.ScrollBars = ScrollBars.Both;
            txtOutput.ReadOnly = true;
            txtOutput.Font = new System.Drawing.Font("Consolas", 10);
            txtOutput.SetBounds(10, 520, 960, 130);

            Controls.Add(txtCode);
            Controls.Add(btnRun);
            Controls.Add(txtOutput);
        }

        private void BtnRun_Click(object sender, EventArgs e)
        {
            try
            {
                string tempFile = Path.Combine(
                    Path.GetTempPath(),
                    "temp_python_script.py");

                File.WriteAllText(tempFile, txtCode.Text);

                ProcessStartInfo psi = new ProcessStartInfo
                {
                    FileName = "python",
                    Arguments = $"\"{tempFile}\"",
                    RedirectStandardOutput = true,
                    RedirectStandardError = true,
                    UseShellExecute = false,
                    CreateNoWindow = true
                };

                Process process = new Process();
                process.StartInfo = psi;
                process.Start();

                string output = process.StandardOutput.ReadToEnd();
                string error = process.StandardError.ReadToEnd();

                process.WaitForExit();

                txtOutput.Text = output + Environment.NewLine + error;
            }
            catch (Exception ex)
            {
                txtOutput.Text = ex.Message;
            }
        }
    }
}
