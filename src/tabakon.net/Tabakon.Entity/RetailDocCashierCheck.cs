using Newtonsoft.Json.Linq;
using System;
using System.Globalization;

namespace Tabakon.Entity
{
    public class RetailDocCashierCheck : AbstractDocEntity
    {
        public decimal Sum { get; set; }
        public string StoreRef { get; set; }
        public RetailDocCashierCheck() : base()
        {
            DocType = DocType.CashierCheck;
        }

        public override AbstractCacheEntity PopulateData(string json) {
            base.PopulateData(json);

            var jObject = JObject.Parse(json);
            this.DocRef = jObject.Value<string>("CashierCheckReportRef");
            this.StoreRef = jObject.Value<string>("StoreRef");
            this.Sum = jObject.Value<decimal>("CashierCheckReportSum");
            try
            {
                this.DocDate = DateTime.ParseExact(jObject.Value<string>("CashierCheckReportDate"), "dd/MM/yyyy HH:mm:ss", CultureInfo.InvariantCulture);
            }
            catch
            {
                try
                {
                    this.DocDate = DateTime.ParseExact(jObject.Value<string>("CashierCheckReportDate"), "MM/dd/yyyy HH:mm:ss", CultureInfo.InvariantCulture);
                }
                catch
                {
                }
            }

            return this;
        }
    }
}