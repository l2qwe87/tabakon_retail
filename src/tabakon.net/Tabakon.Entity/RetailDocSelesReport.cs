using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Text;

namespace Tabakon.Entity
{
    public class RetailDocSelesReport : AbstractDocEntity
    {
        public RetailDocSelesReport() : base() 
        {
            DocType = DocType.SelesReport;
        }


        public override AbstractCacheEntity PopulateData(string json)
        {
            base.PopulateData(json);

            var jObject = JObject.Parse(json);
            this.DocRef = jObject.Value<string>("RetailSalesReportRef");
            try
            {
                this.DocDate = DateTime.ParseExact(jObject.Value<string>("RetailSalesReportDate"), "dd/MM/yyyy HH:mm:ss", CultureInfo.InvariantCulture);
            }
            catch
            {
                try
                {
                    this.DocDate = DateTime.ParseExact(jObject.Value<string>("RetailSalesReportDate"), "MM/dd/yyyy HH:mm:ss", CultureInfo.InvariantCulture);
                }
                catch
                {
                }
            }
            //this.DocDate = jObject.Value<DateTime>("RetailSalesReportDate");

            return this;
        }
    }
}
