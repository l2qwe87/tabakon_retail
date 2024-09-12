using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using TbkIsmpContracts;

namespace TbkIsmpCrpt
{
    public class MarkirovkaClient : IMarkirovkaClient
    {
        private readonly IIsmpClient _ismpClient;
        private readonly IMarkirovkaAuth _markirovkaAuth;
        public MarkirovkaClient(
            IIsmpClient ismpClient,
            IMarkirovkaAuth markirovkaAuth
            )
        {
            _ismpClient = ismpClient;
            _markirovkaAuth = markirovkaAuth;
        }

        private string _token;
        private void Auth()
        {
            var tokenInfo = _markirovkaAuth.GetToken();
            _token = tokenInfo.Token;
        }

        
        public Task<string> GetAggregated(string cis)
        {
            this.Auth();
            throw new NotImplementedException();
        }


        public async Task<string> CisesInfo(IEnumerable<string> ciss)
        {
            this.Auth();
            return await _ismpClient.CisesInfo(ciss, _token);
        }

        public async Task<string> ProductInfo(string cis)
        {
            this.Auth();
            return await _ismpClient.ProductInfo(cis, _token);
        }
    }
}
