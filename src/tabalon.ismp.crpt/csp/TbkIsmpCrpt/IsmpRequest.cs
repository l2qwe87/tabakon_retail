using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Http;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using Polly;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Threading;
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

        public async Task<IIsmpResponse> SendAsync(CancellationToken cancellationToken = default)
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
                var logger = _serviceProvider.GetRequiredService<ILogger<IsmpRequest>>();

                var ismpClientConfig = scope.ServiceProvider.GetRequiredService<IsmpClientConfig>();
                var urls = new[] { ismpClientConfig.BaseUrlTobacco, ismpClientConfig.BaseUrlOther };

                IsmpResponse lastResponse = null;

                for (int urlIndex = 0; urlIndex < urls.Length; urlIndex++)
                {
                    var url = urls[urlIndex];
                    var fullUrl = $"{url.TrimEnd('/')}/{requestUri.TrimStart('/')}";
                    
                    // Create retry policy for this URL
                    // Polly's WaitAndRetryAsync includes initial attempt, so we subtract 1 to match original behavior
                    var retryCount = Math.Max(0, _config.RetryCount - 1);
                    var retryPolicy = Policy
                        .Handle<HttpRequestException>()
                        .Or<TaskCanceledException>()
                        .OrResult<HttpResponseMessage>(response => response.StatusCode == HttpStatusCode.Forbidden)
                        .WaitAndRetryAsync(
                            retryCount,
                            retryAttempt => TimeSpan.FromMilliseconds(_config.RetryDelayMs),
                            onRetry: (outcome, timespan, retryAttempt, context) =>
                            {
                                if (outcome.Exception != null)
                                {
                                    logger.LogError($"Request failed with exception: {outcome.Exception.Message}. Retrying in {timespan.TotalMilliseconds}ms... (Attempt {retryAttempt + 1}/{_config.RetryCount})");
                                }
                                else
                                {
                                    logger.LogError($"Request failed with status code {outcome.Result.StatusCode}. Retrying in {timespan.TotalMilliseconds}ms... (Attempt {retryAttempt + 1}/{_config.RetryCount})");
                                }
                            });

                    try
                    {
                        var response = await retryPolicy.ExecuteAsync(
                            async (token) =>
                            {
                                using (var request = new HttpRequestMessage(httpMethod, fullUrl))
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

                                    return await httpClient.SendAsync(request, token);
                                }
                            },
                            cancellationToken);

                        var jsonText = await response.Content.ReadAsStringAsync(cancellationToken);

                        lastResponse = new IsmpResponse
                        {
                            StatusCode = (int)response.StatusCode,
                            Body = jsonText
                        };

                        // If we get a non-403 response, return it immediately
                        if (lastResponse.StatusCode != 403)
                        {
                            return lastResponse;
                        }
                        
                        // If this is the last URL and we got 403, return the response
                        if (urlIndex == urls.Length - 1)
                        {
                            return lastResponse;
                        }
                        
                        // Otherwise, continue to next URL
                    }
                    catch (TaskCanceledException)
                    {
                        // For TaskCanceledException, throw immediately (don't try other URLs)
                        throw;
                    }
                    catch (HttpRequestException)
                    {
                        // For HttpRequestException, throw immediately (don't try other URLs)
                        throw;
                    }
                }

                // This should not be reached, but just in case
                throw new HttpRequestException("All base URLs failed after retries");
            }
        }

        public class IsmpResponse : IIsmpResponse
        {
            public int StatusCode { get; set; }
            public string Body { get; set; }
        }

    }
}
