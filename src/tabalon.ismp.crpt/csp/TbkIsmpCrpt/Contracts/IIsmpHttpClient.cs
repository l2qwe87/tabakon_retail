using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TbkIsmpCrpt.Contracts
{
    public interface IIsmpHttpClient
    {
        Task<IIsmpResponse> SendAsync(IIsmRequest request);
    }

}
