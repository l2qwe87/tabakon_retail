using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace TbkIsmpContracts
{
    public interface IMarkirovkaClient
    {
        Task<string> GetAggregated(string cis);

        Task<string> CisesInfo(IEnumerable<string> ciss);
    }

    public static class MarkirovkaExtenion
    {
        public static Task<string> CisesInfo(this IMarkirovkaClient markirovkaClient, string cis)
            => markirovkaClient.CisesInfo(new[] { cis });
    }
}
