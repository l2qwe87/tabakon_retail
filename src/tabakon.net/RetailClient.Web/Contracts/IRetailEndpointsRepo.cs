using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Tabakon.Entity;

namespace RetailClient.Web.Contracts
{
    public interface IRetailEndpointsRepo
    {
        Task<IEnumerable<RetailEndpoint>> GetRetailEndpointsAsync();

        Task<IEnumerable<RetailVersion>> GetRetailEndpointsVersionAsync();
    }
}
