using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using RetailClient.Web.Contracts;
using Tabakon.DAL;
using Tabakon.Entity;

namespace RetailClient.Web.Controllers {
    [ApiController]
    [Route("api/[controller]")]
    public class IsmpCrptController : ControllerBase {
        private readonly IsmpCrptApiClient _ismpCrptApiClient;

        public IsmpCrptController(
            IsmpCrptApiClient ismpCrptApiClient
            ) {
            _ismpCrptApiClient = ismpCrptApiClient;
        }

        [HttpGet("Info")]
        public async Task<string> InfoGet([FromQuery] IEnumerable<string> ciss)
            => await _ismpCrptApiClient.Info(ciss);

        [HttpPost("Info")]
        public async Task<string> InfoPost([FromBody] IEnumerable<string> ciss)
            => await _ismpCrptApiClient.Info(ciss);

    }


    public class IsmpCrptApiClient {
        private readonly HttpClient _httpClient;
        public IsmpCrptApiClient(
            HttpClient httpClient
            ) {
            _httpClient = httpClient;
        }
        public async Task<string> Info(IEnumerable<string> ciss) {
            var url = "/api/IsmpCrpt/Info";
            var request = new HttpRequestMessage(HttpMethod.Post, url);
            request.Content = new StringContent(
                JsonConvert.SerializeObject(ciss),
                Encoding.UTF8,
                "application/json");

            var r = await _httpClient.SendAsync(request).ConfigureAwait(false);
            return await r.Content.ReadAsStringAsync();
        }
    }
}
