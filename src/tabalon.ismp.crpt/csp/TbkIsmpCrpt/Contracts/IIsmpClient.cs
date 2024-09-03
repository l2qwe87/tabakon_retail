using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TbkIsmpCrpt
{
    public interface IIsmpClient
    {
        Task<string> Auth();

        Task<string> CisesInfo(IEnumerable<string> ciss, string token);

        Task<string> ProductInfo(string cis, string token);
    }
}
