using System;
using System.Net.NetworkInformation;
using System.Threading.Tasks;

namespace RetailClient
{
    public class RetailWSClient : IRetailWSClient
    {

        private string host;
        public RetailWSClient()
        {

        }
        public async Task<long> PingAsync(){

            long totalTime = 0;
            int timeout = 5;
            Ping pingSender = new Ping();            
            
            var reply = await pingSender.SendPingAsync(host, timeout);
            if (reply.Status == IPStatus.Success)
            {
                totalTime += reply.RoundtripTime;
            }
        
            return totalTime;
        }
        public Task<string> GetVersionAsync(){
            throw new NotImplementedException();
        }

    }
}
