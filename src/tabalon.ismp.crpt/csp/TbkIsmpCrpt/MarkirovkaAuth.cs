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
    public class MarkirovkaAuth : IMarkirovkaAuth
    {
        private readonly IIsmpClient _ismpClient;
        private readonly ReaderWriterLockSlim _lock = new ReaderWriterLockSlim();
        private Timer _timer;
        private TokenInfo _tokenInfo = null;

        public MarkirovkaAuth(
            IIsmpClient ismpClient
            )
        {
            _ismpClient = ismpClient;
            //SchedscheduleTokenCleanupule(TimeSpan.FromSeconds(1));
        }
        public TokenInfo GetToken()
        {
            _lock.EnterReadLock();
            try
            {
                var expiredOn = _tokenInfo?.ExpiredOn ?? DateTime.MinValue;
                var utcNow = DateTime.UtcNow;
                if (expiredOn > utcNow)
                {
                    return _tokenInfo;
                }


            }
            finally
            {
                _lock.ExitReadLock();
            }
            return RenewToken();
        }

        private TokenInfo RenewToken()
        {
            _lock.EnterWriteLock();
            try
            {
                var token = _ismpClient.Auth().Result;
                var hand = new JwtSecurityTokenHandler();
                var tokenS = hand.ReadJwtToken(token);

                _tokenInfo = new()
                {
                    Token = token,
                    ExpiredOn = tokenS.ValidTo
                };
                var span = TimeSpan.FromSeconds((_tokenInfo.ExpiredOn - DateTime.Now).TotalSeconds / 2);
                SchedscheduleTokenCleanupule(span);

            }
            finally
            {
                _lock.ExitWriteLock();
            }
            return _tokenInfo;
        }

        private void SchedscheduleTokenCleanupule(TimeSpan timeSpan)
        {
            lock (this)
            {
                _timer?.Dispose();
                _timer = new Timer((_) =>
                {
                    RenewToken();
                },
                null,
                timeSpan,
                timeSpan
                );
            }
        }
    }
}
