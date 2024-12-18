﻿using Microsoft.Extensions.DependencyInjection;
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
        
        private IsmpRequest(
            IServiceProvider serviceProvider
            )
        {
            _serviceProvider = serviceProvider;
        }


        public static IIsmRequestBuilder Create(IServiceProvider serviceProvider) 
        {
            return new IsmpRequest(serviceProvider);
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
                requestUri = requestUri + "?" + String.Join("&", _queryParms.Select(q => $"{q.Key}={q.Value}"));
            }

            var httpMethod = _body == null ? HttpMethod.Get : HttpMethod.Post;
            using (var scope = _serviceProvider.CreateScope())
            {
                var httpClient = scope.ServiceProvider.GetRequiredService<HttpClient>();

                var ismpClientConfig = scope.ServiceProvider.GetRequiredService<IsmpClientConfig>();
                var urls = new[] { ismpClientConfig.BaseUrlTobacco, ismpClientConfig.BaseUrlOther };
                IsmpResponse result = null;
                foreach ( var url in urls ) {
                    httpClient.BaseAddress = new Uri(url);
                    var tryCount = 10;
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
                                }

                            }
                        } catch (Exception e)
                        {
                            if (tryCount <= 0)
                                throw;
                            var logger = _serviceProvider.GetRequiredService<ILogger<IsmpRequest>>();
                            logger.LogError($"Timeout on {url}, retry #{10 - tryCount}");
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
