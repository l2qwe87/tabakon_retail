using System;

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
    }

    public abstract class AbstractDocEntity : AbstractCacheEntity 
    {
        public string DocRef { get; set; }
        public DateTime DocDate { get; set; }
        public DocType DocType { get; set; }
    }
}