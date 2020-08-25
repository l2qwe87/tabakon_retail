using System;
using System.Collections.Generic;
using System.Text;

namespace Tabakon.Entity
{
    public class RetailDocSelesReport : AbstractDocEntity
    {
        public RetailDocSelesReport() : base() 
        {
            DocType = DocType.SelesReport;
        }
    }
}
