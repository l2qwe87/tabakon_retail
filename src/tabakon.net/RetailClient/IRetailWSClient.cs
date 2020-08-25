using System;
using System.Threading.Tasks;

namespace RetailClient
{
    public interface IRetailWSClient
    {
        Task<long> PingAsync();
        Task<string> GetVersionAsync();

        Task<string> GetRetailDocSelesReport(DateTime date);

    }
}
