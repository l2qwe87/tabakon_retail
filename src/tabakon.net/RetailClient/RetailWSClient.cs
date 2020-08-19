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
            int timeout = 5;
            Ping pingSender = new Ping();            
            
            var reply = await pingSender.SendPingAsync(host, timeout);
            if (reply.Status == IPStatus.Success)
            {
                totalTime += reply.RoundtripTime;
                return totalTime;
            }
            else
            {
                throw new Exception(Enum.GetName(typeof(IPStatus), reply.Status));  
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
