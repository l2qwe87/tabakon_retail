using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;

namespace TbkIsmpCrpt
{
    public interface IIsmpResponse
    {
        int StatusCode { get; }
        string Body { get; }
    }

    public static class IsmpResponseExtension 
    {
        public static T Body<T>(this IIsmpResponse response)
            => typeof(T) == typeof(string) 
            ? (T)(object)response.Body 
            : JsonConvert.DeserializeObject<T>(response.Body);
    }


    public interface IIsmRequest
    {
        Task<IIsmpResponse> SendAsync();
    }

    public interface IIsmRequestBuilder 
    {
        IIsmRequest Build();
        IIsmRequestBuilder SetRequestUrl(string requestUrl);
        IIsmRequestBuilder AddQueryParam<T>(string key, string value);
        IIsmRequestBuilder AddAuth(string token);
        IIsmRequestBuilder AddBody<T>(T body);
    }

}
