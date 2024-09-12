using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TbkIsmpContracts
{
    public class TokenInfo{
        public string Token { get; set; }
        public DateTime ExpiredOn { get; set; }
    }
    public interface IMarkirovkaAuth
    {
        TokenInfo GetToken();
    }
}
