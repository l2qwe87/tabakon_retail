using System;

namespace Tabakon.Entity
{
    public abstract class AbstractCacheEntity
    {
        
        public DateTime LastCheck { get; set; }

        public string RetailEndpointIdentity { get; set; }

        public string JsonData { get; set; }

        public virtual RetailEndpoint RetailEndpoint { get; set; }
    }
}