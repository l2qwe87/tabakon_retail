using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

namespace TbkIsmpContracts
{
    public interface IMarkirovkaClient
    {
        Task<string> GetAggregated(string cis, CancellationToken cancellationToken = default);

        Task<string> CisesInfo(IEnumerable<string> ciss, CancellationToken cancellationToken = default);

        Task<string> CisesShortList(IEnumerable<string> ciss, CancellationToken cancellationToken = default);

        Task<string> ProductInfo(string ciss, CancellationToken cancellationToken = default);
    }

    public static class MarkirovkaExtenion
    {
        public static Task<string> CisesInfo(this IMarkirovkaClient markirovkaClient, string cis, CancellationToken cancellationToken = default)
        {
            Console.WriteLine(cis);
            return markirovkaClient.CisesInfo(new[] { cis }, cancellationToken);
        }
    }
}
