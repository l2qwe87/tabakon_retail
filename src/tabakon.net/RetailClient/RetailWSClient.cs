using Newtonsoft.Json;
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
            using (Ping pingSender = new Ping())
            {

                IPStatus? beastStatus = null;
                var count = 5;
                for (var i = 0; i < count; i++)
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
        }
        public async Task<string> GetVersionAsync()
        {
            await this.PingAsync();
            using (var ws = GetWSClient(url))
            using (OperationContextScope ocs = new OperationContextScope(ws.InnerChannel))
            {
                var requestProp = new HttpRequestMessageProperty();
                requestProp.Headers["Authorization"] = "Basic 0JDQtNC80LjQvToxNTk3NTM=";
                OperationContext.Current.OutgoingMessageProperties[HttpRequestMessageProperty.Name] = requestProp;
                //var version = await ws.GetVersionAsync();

                var version = ws.GetVersionAsync().Result;
                return await Task.FromResult(version.Body.@return);

            }
        }

        public async Task<string> SetExtConfigurationAsync(string extConfiguration)
        { 
            await this.PingAsync();

            var method = "SetExtConfiguration";
            var @params =  new { Configuration = extConfiguration} ;
            var @paramStr = JsonConvert.SerializeObject(@params);
            return Post(method, @paramStr).Replace("\"", "");
        }

        public async Task<string> Run_exRetailOle()
        {
            await this.PingAsync();

            var method = "Run_exRetailOle";
            var @paramStr = "{}";
            return Post(method, @paramStr);
        }

        public async Task<string> Run_apply_cfe()
        {
            await this.PingAsync();

            var method = "Run_apply_cfe";
            var @paramStr = "{}";
            return Post(method, @paramStr);
        }

        public async Task<string> GetExtConfigurationAsync()
        {
            await this.PingAsync();

            var method = "GetExtConfiguration";
            var @params = "{}";
            return Get(method, @params).Replace("\"", "");
        }

        public async Task<string> GetStoreBalanceAsync()
        {
            await this.PingAsync();

            var method = "GetStoreBalance";
            var @params = "{}";
            return Get(method, @params);
        }       


        public struct GetPeriodReportParams
        {
            private readonly DateTime _date;
            public GetPeriodReportParams(DateTime date) {
                _date = date;
            }
            public string DateFrom => _date.ToString("yyyyMMdd");
            public string DateTo => _date.ToString("yyyyMMdd");
        }

        public async Task<string> GetRetailDocSelesReport(DateTime date)
        {

            GetPeriodReportParams pr = new GetPeriodReportParams(date);
            var method = "DailySelesReport";
            var @params = JsonConvert.SerializeObject(pr);
            await this.PingAsync();
            return Get(method, @params);
        }

        public async Task<string> GetRetailDocSelesReport_NEW(DateTime date)
        {

            GetPeriodReportParams pr = new GetPeriodReportParams(date);
            var method = "DailySelesReport_NEW";
            var @params = JsonConvert.SerializeObject(pr);
            await this.PingAsync();
            return Get(method, @params);
        }

        public async Task<string> GetRetailDocCashierCheck(DateTime date)
        {

            GetPeriodReportParams pr = new GetPeriodReportParams(date);
            var method = "CashierCheck";
            var @params = JsonConvert.SerializeObject(pr);
            await this.PingAsync();
            return Get(method, @params);
        }


        private string Post(string method, string @paramStr)
        {
            using (var ws = GetWSClient(url))
            using (OperationContextScope ocs = new OperationContextScope(ws.InnerChannel))
            {
                var requestProp = new HttpRequestMessageProperty();
                requestProp.Headers["Authorization"] = "Basic 0JDQtNC80LjQvToxNTk3NTM=";
                OperationContext.Current.OutgoingMessageProperties[HttpRequestMessageProperty.Name] = requestProp;
                var response = ws.PostAsync(method, @paramStr).Result;
                return response.Body.@return;
            }
        }

        private string Get(string method, string @paramStr)
        {
            using (var ws = GetWSClient(url))
            using (OperationContextScope ocs = new OperationContextScope(ws.InnerChannel))
            {
                var requestProp = new HttpRequestMessageProperty();
                requestProp.Headers["Authorization"] = "Basic 0JDQtNC80LjQvToxNTk3NTM=";
                OperationContext.Current.OutgoingMessageProperties[HttpRequestMessageProperty.Name] = requestProp;
                var task = ws.GetAsync(method, @paramStr);
                Task.WaitAll(task);
                var response = task.Result;
                return response.Body.@return;
            }
        }

        private ws_tbkPortTypeClient GetWSClient(string url) {
            ws_tbkPortTypeClient ws = new ws_tbkPortTypeClient(EndpointConfiguration.ws_tbkSoap12, url + "/ws/ws_tbk.1cws");
            return ws;
        }
    }
}
