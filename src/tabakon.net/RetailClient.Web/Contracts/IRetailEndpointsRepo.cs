using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Tabakon.Entity;

namespace RetailClient.Web.Contracts
{
    public interface IRetailEndpointsRepo
    {
        IQueryable<RetailEndpoint> GetRetailEndpoints();

        IQueryable<RetailDocCashierCheck> GetRetailCashierCheck();

        IQueryable<RetailVersion> GetRetailEndpointsVersion();

        IQueryable<RetailExtConfiguration> GetRetailExtConfiguration();

        
    }
}
