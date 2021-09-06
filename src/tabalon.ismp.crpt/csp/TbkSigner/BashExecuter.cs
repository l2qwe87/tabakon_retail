using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Text;
using System.Threading.Tasks;

namespace TbkSigner
{
    public class BashExecuter
    {
        public async Task<string> Run(string cmd, string args)
        {
            var psi = new ProcessStartInfo
            {
                FileName = cmd,
                Arguments = args,
                UseShellExecute = false,
                RedirectStandardOutput = true,
                RedirectStandardError = true
            };

            var proc = new Process
            {
                StartInfo = psi
            };

            proc.Start();


            var result = new StringBuilder();

            await Task.WhenAll(Task.Run(() =>
            {
                while (!proc.StandardOutput.EndOfStream)
                {
                    result.AppendLine(proc.StandardOutput.ReadLine());
                }
            }), Task.Run(() =>
            {
                while (!proc.StandardError.EndOfStream)
                {
                    result.AppendLine(proc.StandardError.ReadLine());
                }
            }));


            await proc.WaitForExitAsync();
            return result.ToString();
        }
    }
}
