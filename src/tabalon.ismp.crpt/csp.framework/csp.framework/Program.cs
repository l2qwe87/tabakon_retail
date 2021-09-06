using CommandLine;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Security.Cryptography.X509Certificates;
using System.Text;
using System.Threading.Tasks;

namespace csp.framework
{

    public class Options
    {
        [Option('t', "thumbprint", Required = false, HelpText = "Certificate Thumbprint")]
        public string Thumbprint { get; set; }
        [Option('i', "input", Required = false, HelpText = "Input File Path - byte[]")]
        public string InputFile { get; set; }
        [Option('o', "output", Required = false, HelpText = "Output File Path - string")]
        public string OutputFile { get; set; }
    }

    class Program
    {
        static void Main(string[] args)
        {
#if DEBUG
            var debug = true;
#else
            var debug = false;
#endif
            if (debug) 
            {
                var content = Encoding.ASCII.GetBytes("XWTSPVUBCUBMXKUEPLKLZRPPGVBTBM");
                var cert = FindCertificate("B2CE2E0BB37ABA5EDE06ACF0FD70841B8F113BAE");
                var signature = GostCryptoHelpers.ComputeAttachedSignature(cert, content);


                Console.WriteLine($"{signature}");
                Console.WriteLine($"Press any key ...");
                Console.ReadKey();
            }
            else
            {


                Parser.Default.ParseArguments<Options>(args)
                    .WithParsed<Options>(o =>
                    {
                        try
                        {
                            var content = File.ReadAllBytes(o.InputFile);
                            var cert = FindCertificate(o.Thumbprint);
                            var signature = GostCryptoHelpers.ComputeAttachedSignature(cert, content);
                            File.WriteAllText(o.OutputFile, signature);
                        }
                        catch (Exception e)
                        {
                            File.WriteAllText(o.OutputFile, e.ToString());
                        }


                    });
            }
        }

        private static X509Certificate2 FindCertificate(string cnameOrThumbprint) 
        {
            var storeNames = new[] { StoreName.My, StoreName.TrustedPeople, StoreName.CertificateAuthority, StoreName.AddressBook, StoreName.Root };
            var storeLocations = new[] { StoreLocation.CurrentUser, StoreLocation.LocalMachine };

            foreach (var storeLocation in storeLocations)
            {
                foreach (var storeName in storeNames)
                {
                    var cert = GostCryptoHelpers.FindCertificate(cnameOrThumbprint, storeName, storeLocation);
                    if (cert != null)
                    {
                        return cert;
                    }
                }
            }

            return null;
        }
    }
}
