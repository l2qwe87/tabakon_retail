using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace TbkIsmpCrpt
{
    public enum CisesInfoType
    {
        Info,
        ShortList
    }

    public interface IIsmpClient
    {
        Task<string> Auth(CancellationToken cancellationToken = default);

        Task<string> CisesInfo(IEnumerable<string> ciss, string token, CisesInfoType type = CisesInfoType.Info, CancellationToken cancellationToken = default);

        Task<string> ProductInfo(string cis, string token, CancellationToken cancellationToken = default);
    }
}
