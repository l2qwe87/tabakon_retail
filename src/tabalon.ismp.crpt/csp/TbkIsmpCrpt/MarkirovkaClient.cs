using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using TbkIsmpContracts;

namespace TbkIsmpCrpt
{
    public class MarkirovkaClient : IMarkirovkaClient
    {
        private Timer _timer;
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
            if (_token == null)
                lock (this)
                    if (_token == null)
                    {
                        var tokenInfo = _markirovkaAuth.GetToken().Result;
                        _token = tokenInfo.Token;

                        var span = TimeSpan.FromSeconds((tokenInfo.ExpiredOn - DateTime.Now).TotalSeconds / 2);
                        SchedscheduleTokenCleanupule(span);
                    }
        }

        private void SchedscheduleTokenCleanupule(TimeSpan timeSpan) 
        {
            _timer?.Dispose();
            _timer = new Timer((_) =>
            {
                lock (this)
                {
                    _token = null;
                }
            },
            null,
            timeSpan,
            timeSpan
            );
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
    }
}
