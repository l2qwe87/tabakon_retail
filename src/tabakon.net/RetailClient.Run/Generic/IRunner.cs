using System;
using System.Linq.Expressions;
using System.Threading.Tasks;
using Tabakon.Entity;

namespace RetailClient.Run.Generic {
    public interface IRunner{
        Task Run(Expression<Func<RetailEndpoint, bool>> predicat = null);
    }
}
