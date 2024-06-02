using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TbkIsmpContracts;

namespace TbkIsmpCrpt
{
    public class MarkirovkaAuth : IMarkirovkaAuth
    {
        private readonly IIsmpClient _ismpClient;

        public MarkirovkaAuth(
            IIsmpClient ismpClient
            )
        {
            _ismpClient = ismpClient;
        }
        public async Task<TokenInfo> GetToken()
        {
            var token = await _ismpClient.Auth();

            var hand = new JwtSecurityTokenHandler();
            var tokenS = hand.ReadJwtToken(token);

            return new()
            {
                Token = token,
                ExpiredOn = tokenS.ValidTo
            };
        }
    }
}
