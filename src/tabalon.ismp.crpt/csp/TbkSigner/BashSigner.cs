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
    public class BashSigner : ISigner
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

            //csptest -sfsign -sign -in c:\src\in.txt -out c:\src\out.txt -my 3B5AFA9635BD5EA7B1C3F847A543BBF214BEE297 -detached -base64 -add -display_content
            args.Append("-sfsign -sign");
            args.Append($" -in {tmpFileIn}");
            args.Append($" -out {tmpFileOut}");
            args.Append($" -my {thumbprint}");
            //args.Append($" -detached -base64 -add");
            args.Append($" -detached -add");


            await File.WriteAllBytesAsync(tmpFileIn, Encoding.ASCII.GetBytes(content));


            await bash.Run(@"C:\Program Files\Crypto Pro\CSP\csptest.exe", args.ToString());


            //var signatre = await File.ReadAllTextAsync(tmpFileOut);
            var signatreBytes = await File.ReadAllBytesAsync(tmpFileOut);

            var signatre = Convert.ToBase64String(signatreBytes);


            File.Delete(tmpFileIn);
            File.Delete(tmpFileOut);

            return signatre;
        }
    }
}
