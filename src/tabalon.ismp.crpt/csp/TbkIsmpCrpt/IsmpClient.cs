using Microsoft.Extensions.DependencyInjection;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Dynamic;
using System.Linq;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Threading;
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
        public string BaseUrlTobacco { get; set; }
        public string BaseUrlOther { get; set; }
        public string Thumbprint { get; set; }
        public int HttpTimeoutInSeconds { get; set; }
        public int RetryCount { get; set; }
        public int RetryDelayMs { get; set; }
    }


    public class IsmpClient : IIsmpClient
    {
        private readonly IIsmpRequestFactory _requestFactory;
        private readonly IServiceProvider _serviceProvider;

        private string _lastToken;

        public IsmpClient(IIsmpRequestFactory requestFactory, IServiceProvider serviceProvider)
        {
            _requestFactory = requestFactory;
            _serviceProvider = serviceProvider;
        }
        public async Task<string> Auth(CancellationToken cancellationToken = default)
        {

            var getAuthResponse = await _requestFactory.Create()
                .SetRequestUrl("api/v3/auth/cert/key")
                .Build()
                .SendAsync(cancellationToken);

            var tokenRequest = getAuthResponse.Body<TokenRequest>();

            var data = tokenRequest.data;

            var signer = _serviceProvider.GetRequiredService<ISigner>();
            var config = _serviceProvider.GetRequiredService<IsmpClientConfig>();
            var signature = await signer.Sign(config.Thumbprint, data);

            tokenRequest.data = signature;

            var tokenResponse = await _requestFactory.Create()
                .SetRequestUrl("api/v3/auth/cert/")
                .AddBody(tokenRequest)
                .Build()
                .SendAsync(cancellationToken);

            var q = tokenResponse.Body<TokenResponse>();
            return q.token;
        }

        public async Task<string> CisesInfo(IEnumerable<string> ciss, string token, CisesInfoType type = CisesInfoType.Info, CancellationToken cancellationToken = default)
        {
            var url = type switch
            {
                CisesInfoType.Info => "api/v3/true-api/cises/info",
                CisesInfoType.ShortList => "api/v3/true-api/cises/short/list",
                _ => "api/v3/true-api/cises/info"
            };

            var tokenResponse = await _requestFactory.Create()
                .SetRequestUrl(url)
                .AddAuth(token)
                .AddBody(ciss)
                .Build()
                .SendAsync(cancellationToken);

            return tokenResponse.Body<string>();
        }

        public async Task<string> ProductInfo(string cis, string token, CancellationToken cancellationToken = default)
        {
            var tokenResponse = await _requestFactory.Create()
               .SetRequestUrl("api/v3/true-api/products/info")
               .AddAuth(token)
               .AddQueryParam("cis", cis)
               .Build()
               .SendAsync(cancellationToken);

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
