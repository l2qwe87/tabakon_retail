using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;

namespace Tabakon.Entity
{

    public class RetailDocCashierCheck : AbstractDocEntity
    {
        public DateTime Date { get; set; }
        public decimal Sum { get; set; }
        public string StoreRef { get; set; }
        public string Operation { get; set; }
        public string OwnerRef { get; set; }
        public string OwnerFriendlyName { get; set; }
        public string SellerRef { get; set; }
        public string SellerFriendlyName { get; set; }
        public bool IsSale { get; set; }

        public decimal SumCash { get; set; }
        public decimal SumTerminal { get; set; }

        public List<PaymentDetail> PaymentDetail { get; set; }
        public List<DiscountDetail> DiscountDetail { get; set; }
        public List<GoodsDetail> GoodsDetail { get; set; }

        public RetailDocCashierCheck() : base()
        {
            DocType = DocType.CashierCheck;
        }

        public override AbstractCacheEntity PopulateData(string json) {
            base.PopulateData(json);

            var jObject = JObject.Parse(json);
            //jObject
            this.DocRef = jObject.Value<string>("CashierCheckReportRef");
            this.StoreRef = jObject.Value<string>("StoreRef");
            this.IsSale = jObject.Value<bool>("CashierCheckReportIsSale");
            this.Sum = jObject.Value<decimal>("CashierCheckReportSum");

            this.Operation = jObject.Value<string>("CashierCheckReportOperation");

            this.OwnerRef = jObject.Value<string>("CashierCheckReportOwnerRef");
            this.OwnerFriendlyName = jObject.Value<string>("CashierCheckReportOwnerFriendlyName");
            this.SellerRef = jObject.Value<string>("CashierCheckReportSellerRef");
            this.SellerFriendlyName = jObject.Value<string>("CashierCheckReportSellerFriendlyName");

            this.PaymentDetail = jObject["CashierCheckPaymentDetail"]?.ToObject<List<PaymentDetail>>();
            this.DiscountDetail = jObject["CashierCheckDiscountDetail"]?.ToObject<List<DiscountDetail>>();
            this.GoodsDetail = jObject["CashierCheckGoodsDetail"]?.ToObject<List<GoodsDetail>>();

            this.SumTerminal = this.PaymentDetail?.Where(p => !p.IsCash).Sum(p => p.Sum) ?? 0;
            this.SumCash = this.PaymentDetail?.Where(p => p.IsCash).Sum(p => p.Sum) ?? 0;
            if (this.SumCash > -this.SumTerminal + this.Sum) {
                this.SumCash = -this.SumTerminal + this.Sum;
            }

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

    public class PaymentDetail {
        public Guid PaymentDetailId { get; set; }
        public bool IsCash { get; set; }
        public decimal Sum { get; set; }
    }

    public class DiscountDetail {
        public Guid DiscountDetailId { get; set; }
        public string Discount { get; set; }
        public decimal Sum { get; set; }
    }

    public class GoodsDetail
    {
        public Guid GoodsDetailId { get; set; }
        public string Goods { get; set; }
        public decimal Count { get; set; }
        public decimal Price { get; set; }
        public decimal Sum { get; set; }
    }
}