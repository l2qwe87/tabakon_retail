using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace tabakon.launcher
{
    public partial class Launcher : Form
    {
        public Launcher()
        {
            InitializeComponent();
        }

        private void Launcher_Load(object sender, EventArgs e)
        {
            string user = "Админ";
            //string pas = "159753";
            string pas = "";
            string file = "D:\\1CBases\\retail_1\\retail";
            dynamic result;
            dynamic refer;
            
            V83.COMConnector com1s = new V83.COMConnector();


            com1s.PoolCapacity = 10;
            com1s.PoolTimeout = 60;
            com1s.MaxConnections = 2;
            result = com1s.Connect("File='" + file + "';Usr='" + user + "';pwd='" + pas + "';");
            refer = result.Справочники.Пользователи.Выбрать();

            //foreach (dynamic login in refer) 
            while (refer.Следующий())
            {
                this.comboBox1.Items.Add(refer.ИдентификаторПользователяИБ);
            }

        }
    }
}
