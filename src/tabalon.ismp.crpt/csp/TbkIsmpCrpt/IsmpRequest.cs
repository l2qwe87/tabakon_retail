using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Http;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Threading.Tasks;

namespace TbkIsmpCrpt
{
    public class IsmpRequest : IIsmRequest, IIsmRequestBuilder
    {
        //public IIsmRequestMethod IsmRequestMethod { get; protected set; }
        //public string Body { get; protected set; }



        private IServiceProvider _serviceProvider;
        private IsmpClientConfig _config;

        private IsmpRequest(
            IServiceProvider serviceProvider,
            IsmpClientConfig config
            )
        {
            _serviceProvider = serviceProvider;
            _config = config;
        }


        public static IIsmRequestBuilder Create(IServiceProvider serviceProvider, IsmpClientConfig config)
        {
            return new IsmpRequest(serviceProvider, config);
        }


        private string _body;
        private string _token;
        private string _requestUri;
        private Dictionary<string, string> _queryParms;


        public IIsmRequest Build()
            => this;

        public IIsmRequestBuilder SetRequestUrl(string requestUrl)
        {
            _requestUri = requestUrl;
            return this;
        }

        public IIsmRequestBuilder AddQueryParam(string key, string value)
        {

            if (_queryParms == null)
            {
                _queryParms = new Dictionary<string, string>();
            }
            _queryParms.Add(key, value);
            return this;
        }
        public IIsmRequestBuilder AddAuth(string token)
        {
            _token = token;
            return this;
        }
        public IIsmRequestBuilder AddBody<T>(T body)
        {
            if (typeof(T) == typeof(string))
            {
                _body = (string)(object)body;
            }
            else
            {
                _body = JsonConvert.SerializeObject(body);
            }
            return this;
        }

        public async Task<IIsmpResponse> SendAsync()
        {
            var requestUri = _requestUri;
            if (_queryParms != null)
            {
                requestUri = requestUri + "?" + String.Join("&", _queryParms.Select(q => $"{Uri.EscapeDataString(q.Key)}={Uri.EscapeDataString(q.Value)}"));
            }

            var httpMethod = _body == null ? HttpMethod.Get : HttpMethod.Post;
            using (var scope = _serviceProvider.CreateScope())
            {
                var httpClientFactory = scope.ServiceProvider.GetRequiredService<IHttpClientFactory>();
                var httpClient = httpClientFactory.CreateClient("IsmpClient");

                var ismpClientConfig = scope.ServiceProvider.GetRequiredService<IsmpClientConfig>();
                var urls = new[] { ismpClientConfig.BaseUrlTobacco, ismpClientConfig.BaseUrlOther };
                IsmpResponse result = null;
                string currentBaseUrl = null;
                foreach (var url in urls)
                {
                    if (currentBaseUrl != url)
                    {
                        httpClient.BaseAddress = new Uri(url);
                        currentBaseUrl = url;
                    }
                    var tryCount = _config.RetryCount;
                    while (tryCount > 0)
                    {
                        tryCount--;
                        try
                        {
                            using (var request = new HttpRequestMessage(httpMethod, $"{requestUri}"))
                            {
                                request.Headers.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                                if (this._token != null)
                                {
                                    request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", $"{this._token}");
                                }

                                if (!String.IsNullOrWhiteSpace(_body))
                                {
                                    request.Content = new StringContent(
                                        _body,
                                        Encoding.UTF8,
                                        "application/json");
                                }

                                using (var response = await httpClient.SendAsync(request))
                                {
                                    var jsonText = await response.Content.ReadAsStringAsync();

                                    result = new IsmpResponse
                                    {
                                        StatusCode = (int)response.StatusCode,
                                        Body = jsonText
                                    };
                                    if (result.StatusCode != 403)
                                    {
                                        return result;
                                    }
                                    else
                                    {
                                        var logger = _serviceProvider.GetRequiredService<ILogger<IsmpRequest>>();
                                        logger.LogError($"403 Forbidden on {url}, retry #{_config.RetryCount - tryCount}");
                                        if (tryCount > 0)
                                        {
                                            await Task.Delay(_config.RetryDelayMs);
                                        }
                                    }
                                }

                            }
                        }
                        catch (Exception e)
                        {
                            if (tryCount <= 0)
                                throw;
                            var logger = _serviceProvider.GetRequiredService<ILogger<IsmpRequest>>();
                            logger.LogError($"Timeout on {url}, retry #{_config.RetryCount - tryCount}");
                            await Task.Delay(_config.RetryDelayMs);
                        }
                    }
                }
                return result;
            }
        }

        public class IsmpResponse : IIsmpResponse
        {
            public int StatusCode { get; set; }
            public string Body { get; set; }
        }

    }
}
