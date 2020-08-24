using System;
using System.Net.NetworkInformation;
using System.ServiceModel;
using System.ServiceModel.Channels;
using System.Threading.Tasks;
using WS_TBK;
using static WS_TBK.ws_tbkPortTypeClient;

namespace RetailClient
{
    public class RetailWSClient : IRetailWSClient
    {

        private readonly string host;
        private readonly string url;
        public RetailWSClient(string host, string url)
        {
            this.host = host;
            this.url = url;
        }
        public async Task<long> PingAsync(){

            long totalTime = 0;
            int timeout = 5000;
            Ping pingSender = new Ping();            
            
            IPStatus? beastStatus = null;
            var count = 5;
            for (var i =0; i< count; i++)
            {
                var reply = await pingSender.SendPingAsync(host, timeout);
                totalTime += reply.RoundtripTime;
                beastStatus = (reply.Status == IPStatus.Success)
                    ? reply.Status 
                    : beastStatus ?? reply.Status;
            }

            if (beastStatus == IPStatus.Success)
            {
                return totalTime / count;
            }
            else
            {
                throw new Exception(Enum.GetName(typeof(IPStatus), beastStatus));  
            }
        }
        public async Task<string> GetVersionAsync()
        {
            await this.PingAsync();
            ws_tbkPortTypeClient ws = new ws_tbkPortTypeClient(EndpointConfiguration.ws_tbkSoap12, url+"/ws/ws_tbk.1cws"); 
            using (OperationContextScope ocs=new OperationContextScope(ws.InnerChannel))
            {
                var requestProp = new HttpRequestMessageProperty();
                requestProp.Headers["Authorization"] = "Basic 0JDQtNC80LjQvToxNTk3NTM=";
                OperationContext.Current.OutgoingMessageProperties[HttpRequestMessageProperty.Name] = requestProp;
                //var version = await ws.GetVersionAsync();
                
                var version = ws.GetVersionAsync().Result;
                return await Task.FromResult(version.Body.@return);
                
            }            
        }

    }
}
