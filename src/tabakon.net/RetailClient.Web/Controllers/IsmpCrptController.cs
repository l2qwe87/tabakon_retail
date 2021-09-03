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

namespace RetailClientTests.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class IsmpCrptController : ControllerBase
    {
        private readonly  IConfiguration _configuration;
        private readonly HttpClient _httpClient; 

        public IsmpCrptController(
            IConfiguration configuration,
            HttpClient httpClient
            )
        {
            _configuration = configuration;
            _httpClient = httpClient;
        }

        [HttpGet("Info")]
        public async Task<string> InfoGet([FromQuery] IEnumerable<string> ciss)
            => await InfoInternal(ciss);

        [HttpPost("Info")]
        public async Task<string> InfoPost([FromBody] IEnumerable<string> ciss)
            => await InfoInternal(ciss);


        private async Task<string> InfoInternal(IEnumerable<string> ciss)
        {
            string resp = null;
            var url = _configuration.GetSection("IsmpCrpt").GetValue<string>("Host") + "api/IsmpCrpt/Info";
            using (var request = new HttpRequestMessage(HttpMethod.Post, url)) {
                request.Headers.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                request.Content = new StringContent( 
                    JsonConvert.SerializeObject(ciss),
                    Encoding.UTF8,
                    "application/json");

                using (var r = await _httpClient.SendAsync(request))
                {
                    resp = await r.Content.ReadAsStringAsync();
                }
            }
            return resp;
        }
    }
}
