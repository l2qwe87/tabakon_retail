
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;
using TbkSignerContracts;

namespace TbkSigner
{
    public class BashFrameworkSigner : ISigner
    {

        public async Task<string> Sign(string thumbprint, string content)
        {


            var bash = new BashExecuter();

            string tmpFoledr = Path.GetFullPath(Assembly.GetExecutingAssembly().Location);
            tmpFoledr = Path.GetDirectoryName(tmpFoledr);
            tmpFoledr = Path.Combine(tmpFoledr, "tmp");

            Directory.CreateDirectory(tmpFoledr);

            var tmpFileIn = Path.Combine(tmpFoledr, Guid.NewGuid().ToString());
            var tmpFileOut = Path.Combine(tmpFoledr, Guid.NewGuid().ToString());

            var args = new StringBuilder();


            args.Append($" -i {tmpFileIn}");
            args.Append($" -o {tmpFileOut}");
            args.Append($" -t {thumbprint}");


            await File.WriteAllBytesAsync(tmpFileIn, Encoding.ASCII.GetBytes(content));

            await bash.Run(@"C:\Public\csp.framework\csp.framework.exe ", args.ToString());

            var signatre = await File.ReadAllTextAsync(tmpFileOut);


            File.Delete(tmpFileIn);
            File.Delete(tmpFileOut);

            return signatre;
        }
    }
}
