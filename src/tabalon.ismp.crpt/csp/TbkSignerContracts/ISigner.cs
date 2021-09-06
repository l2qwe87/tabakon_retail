using System;
using System.Threading.Tasks;

namespace TbkSignerContracts
{
    public interface ISigner
    {
        Task<string> Sign(string thumbprint, string content);
    }
}
