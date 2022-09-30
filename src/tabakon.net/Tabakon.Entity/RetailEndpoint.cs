using System;

namespace Tabakon.Entity
{
    public class RetailEndpoint
    {
        public string RetailEndpointIdentity {get;set;}
        public string RetailEndpointName {get;set;}
        public string RetailEndpointHost {get;set;}
        public string RetailEndpointUrl {get;set;}
        public bool MarkAsDeleted { get; set; }
        public string StoreRef { get; set; }
    }
}
