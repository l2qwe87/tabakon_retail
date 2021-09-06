using Microsoft.Extensions.DependencyInjection;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Dynamic;
using System.Linq;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Threading.Tasks;
using System.Xml;
using System.Xml.Linq;
using TbkIsmpContracts;
using TbkIsmpCrpt.Contracts;
using TbkSignerContracts;

namespace TbkIsmpCrpt
{
    public class IsmpClientConfig
    {
        public string BaseUrl { get; set; }
        public string Thumbprint { get; set; }
    }


    public class IsmpClient : IIsmpClient
    {
        //private readonly string baeUrl = "https://ismp.crpt.ru";
        //private readonly string baeUrl = "https://markirovka.crpt.ru";
        //private readonly string baeUrl = "https://ismotp.crptech.ru";

        private readonly IServiceProvider _serviceProvider;
        private readonly IsmpClientConfig _ismpClientConfig;


        private string _lastToken;


        public IsmpClient(
            IsmpClientConfig ismpClientConfig,
            IServiceProvider serviceProvider
            )
        {

            _ismpClientConfig = ismpClientConfig;
            _serviceProvider = serviceProvider;
        }
        public async Task<string> Auth()
        {

            var getAuthResponse = await IsmpRequest.Create(_serviceProvider)
                .SetRequestUrl("api/v3/auth/cert/key")
                .Build()
                .SendAsync();

            var tokenRequest = getAuthResponse.Body<TokenRequest>();

            var data = tokenRequest.data;

            var signer = _serviceProvider.GetRequiredService<ISigner>();
            var signature = await signer.Sign(_ismpClientConfig.Thumbprint, data);

            tokenRequest.data = signature;

            var tokenResponse = await IsmpRequest.Create(_serviceProvider)
                .SetRequestUrl("api/v3/auth/cert/")
                .AddBody(tokenRequest)
                .Build()
                .SendAsync();

            var q = tokenResponse.Body<TokenResponse>();
            return q.token;
        }

        public async Task<string> CisesInfo(IEnumerable<string> ciss, string token)
        {
            var tokenResponse = await IsmpRequest.Create(_serviceProvider)
                //.SetRequestUrl("api/v3/true-api/cises/short/list")
                .SetRequestUrl("api/v3/true-api/cises/info")
                //.SetRequestUrl("api/v4/facade/cis/cis_list?childrenPaging=true&childrenPage=1&childrenLimit=50")
                .AddAuth(token)
                //.AddBody(new { cises = ciss })
                .AddBody(ciss)
                .Build()
                .SendAsync(); 

            return tokenResponse.Body<string>(); ;
        }

        public async Task<string> _CisesInfo(IEnumerable<string> ciss, string token) 
        {
            var tokenResponse = await IsmpRequest.Create(_serviceProvider)
                //.SetRequestUrl("api/v3/true-api/cises/info/")
                .SetRequestUrl("api/v3/true-api/cises/short/list")
                .AddAuth(token)
                .AddBody(ciss)
                .Build()
                .SendAsync(); ;

            return tokenResponse.Body<string>(); ;
        }


        class TokenResponse
        {
            public string token { get; set; }
        }

        class TokenRequest
        {
            public string uuid { get; set; }
            public string data { get; set; }
        }
    }
}
