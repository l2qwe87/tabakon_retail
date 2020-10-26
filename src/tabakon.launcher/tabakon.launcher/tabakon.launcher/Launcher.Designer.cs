namespace tabakon.launcher
{
    partial class Launcher
    {
        /// <summary>
        ///  Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        ///  Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        ///  Required method for Designer support - do not modify
        ///  the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.panel_logo = new System.Windows.Forms.Panel();
            this.panel_header = new System.Windows.Forms.Panel();
            this.panel_login = new System.Windows.Forms.Panel();
            this.comboBox1 = new System.Windows.Forms.ComboBox();
            this.label_login = new System.Windows.Forms.Label();
            this.panel_login.SuspendLayout();
            this.SuspendLayout();
            // 
            // panel_logo
            // 
            this.panel_logo.Dock = System.Windows.Forms.DockStyle.Left;
            this.panel_logo.Location = new System.Drawing.Point(0, 0);
            this.panel_logo.Name = "panel_logo";
            this.panel_logo.Size = new System.Drawing.Size(130, 181);
            this.panel_logo.TabIndex = 0;
            // 
            // panel_header
            // 
            this.panel_header.Dock = System.Windows.Forms.DockStyle.Top;
            this.panel_header.Location = new System.Drawing.Point(130, 0);
            this.panel_header.Name = "panel_header";
            this.panel_header.Size = new System.Drawing.Size(334, 43);
            this.panel_header.TabIndex = 1;
            // 
            // panel_login
            // 
            this.panel_login.Controls.Add(this.comboBox1);
            this.panel_login.Controls.Add(this.label_login);
            this.panel_login.Dock = System.Windows.Forms.DockStyle.Fill;
            this.panel_login.Location = new System.Drawing.Point(130, 43);
            this.panel_login.Margin = new System.Windows.Forms.Padding(10);
            this.panel_login.Name = "panel_login";
            this.panel_login.Padding = new System.Windows.Forms.Padding(10);
            this.panel_login.Size = new System.Drawing.Size(334, 138);
            this.panel_login.TabIndex = 2;
            // 
            // comboBox1
            // 
            this.comboBox1.Dock = System.Windows.Forms.DockStyle.Top;
            this.comboBox1.Font = new System.Drawing.Font("Segoe UI", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point);
            this.comboBox1.FormattingEnabled = true;
            this.comboBox1.Location = new System.Drawing.Point(10, 31);
            this.comboBox1.Margin = new System.Windows.Forms.Padding(10);
            this.comboBox1.Name = "comboBox1";
            this.comboBox1.Size = new System.Drawing.Size(314, 29);
            this.comboBox1.TabIndex = 1;
            // 
            // label_login
            // 
            this.label_login.AutoSize = true;
            this.label_login.Dock = System.Windows.Forms.DockStyle.Top;
            this.label_login.Font = new System.Drawing.Font("Segoe UI", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point);
            this.label_login.Location = new System.Drawing.Point(10, 10);
            this.label_login.Margin = new System.Windows.Forms.Padding(10);
            this.label_login.Name = "label_login";
            this.label_login.Size = new System.Drawing.Size(158, 21);
            this.label_login.TabIndex = 0;
            this.label_login.Text = "Имя пользователя";
            // 
            // Launcher
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(7F, 15F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(464, 181);
            this.Controls.Add(this.panel_login);
            this.Controls.Add(this.panel_header);
            this.Controls.Add(this.panel_logo);
            this.MaximizeBox = false;
            this.MaximumSize = new System.Drawing.Size(480, 220);
            this.MinimizeBox = false;
            this.MinimumSize = new System.Drawing.Size(480, 220);
            this.Name = "Launcher";
            this.ShowIcon = false;
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Введите имя пользовател и пароль";
            this.Load += new System.EventHandler(this.Launcher_Load);
            this.panel_login.ResumeLayout(false);
            this.panel_login.PerformLayout();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Panel panel_logo;
        private System.Windows.Forms.Panel panel_header;
        private System.Windows.Forms.Panel panel_login;
        private System.Windows.Forms.ComboBox comboBox1;
        private System.Windows.Forms.Label label_login;
    }
}

