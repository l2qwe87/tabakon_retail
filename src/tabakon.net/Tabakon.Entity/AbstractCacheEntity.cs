using Newtonsoft.Json.Linq;
using System;
using System.Collections;
using System.Globalization;
using System.Linq;
using System.Linq.Expressions;

namespace Tabakon.Entity
{

    public enum DocType 
    {
        Unknown = 0,
        SelesReport = 1
    }

    public abstract class AbstractCacheEntity
    {
        
        public DateTime LastCheck { get; set; }

        public string RetailEndpointIdentity { get; set; }

        public string JsonData { get; set; }

        public virtual RetailEndpoint RetailEndpoint { get; set; }


        public AbstractCacheEntity PopulateData(RetailEndpoint RetailEndpoint) 
        {
            this.RetailEndpointIdentity = RetailEndpoint.RetailEndpointIdentity;
            return this;
        }

        public virtual AbstractCacheEntity PopulateData(string json)
        {
            JsonData = json;
            return this;
        }

        public virtual Expression<Func<TSource,bool>> IsEquals<TSource>() where TSource : AbstractCacheEntity
        {
            return (e) =>  e.RetailEndpointIdentity == this.RetailEndpointIdentity;
        }

    }

    public abstract class AbstractDocEntity : AbstractCacheEntity
    {
        public string DocRef { get; set; }
        public DateTime DocDate { get; set; }
        public DocType DocType { get; set; }
        public override AbstractCacheEntity PopulateData(string json)
        {
            base.PopulateData(json);

            var jObject = JObject.Parse(json);
            this.DocRef = jObject.Value<string>("RetailSalesReportRef");
            this.DocDate = DateTime.ParseExact(jObject.Value<string>("RetailSalesReportDate"), "dd.MM.yyyy HH:mm:ss", CultureInfo.InvariantCulture);
            //this.DocDate = jObject.Value<DateTime>("RetailSalesReportDate");

            return this;
        }

        public override Expression<Func<TSource, bool>> IsEquals<TSource>()
        {
            return (e) => (e as AbstractDocEntity).RetailEndpointIdentity == this.RetailEndpointIdentity &&
                 (e as AbstractDocEntity).DocRef == this.DocRef;
        }
    }
}