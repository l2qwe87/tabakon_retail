using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using RetailClient;
using System;
using System.Linq;
using Tabakon.Entity;
using Xunit;
using static RetailClient.RetailWSClient;

namespace RetailClient
{
    public class RetailDocSelesReportTest
    {
        [Fact]
        public void GetData_RetailDocSelesReport()
        {
            RetailWSClient ws = new RetailWSClient("localhost", "http://localhost:8080/retail_1");

            //GetRetailDocSelesReportParams pr = new GetRetailDocSelesReportParams(DateTime.Parse("20200731"));
            var docDate = DateTime.Parse("2020/07/31");
            var json = ws.GetRetailDocSelesReport(docDate).Result;

            
            var jArray= JArray.Parse(json);
            var qq = jArray.Select(e =>
            {
                var doc = new RetailDocSelesReport();
                doc.JsonData = e.ToString();

                doc.DocRef = e.Value<string>("RetailSalesReportRef");
                doc.DocDate = docDate;

                return doc;
            }).ToList();

            var rr = qq;
            

        }
    }
}
