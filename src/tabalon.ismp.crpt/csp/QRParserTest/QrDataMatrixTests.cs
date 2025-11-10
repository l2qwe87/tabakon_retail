using System;
using TbkIsmpCrptApi;
using TbkIsmpCrptApi.Controllers;
using Xunit;

namespace QRParserTest
{
    public class QrDataMatrixTests
    {
        [Theory]
        [InlineData("010541462278007621CimGms8C9swPomtz", "010541462278007621CimGms8C9swPomtz")]
        [InlineData("0104640030090754210001%ix800515000093vRdW", "0104640030090754210001%ix")]
        [InlineData("010290005275769421a?RI7ZL93X9NA", "010290005275769421a?RI7ZL")]
        [InlineData("00000046198488X?io+qCABm8wAYa", "00000046198488X?io+qC")]
        [InlineData("04640030090709DYBLHiyACoA", "04640030090709DYBLHiy")]
        [InlineData("010468012799555521fGHwsVi", "010468012799555521fGHwsVi")]
        [InlineData("(01)04680127995555(21)fGHwsVi", "010468012799555521fGHwsVi")]
        [InlineData("01230000211093s)pTKjQAAAAHwvf", "01230000211093s)pTKjQ")]
        [InlineData("010600179201211421LABtf,B 93gJWU", "010600179201211421LABtf,B")]
        public void GetCIS(string qr, string cis)
        {
            var qrPa = new QRParser(qr);
            Assert.Equal(cis, qrPa.CIS);
        }

        // ClothesCIS converted to Theory with InlineData (qr and expected passed via InlineData)
        [Theory]
        [InlineData("0104610541730272215pnKT'RwId);*91EE1192PFY/37fDDABcSYnthTvZ9i90lB04JHGgCGsBDGie0uM=", "0104610541730272215pnKT'RwId);*")]
        public void ClothesCIS(string qr, string expected)
        {
            var qrPa = new QRParser(qr);
            Assert.Equal(expected, qrPa.CIS);
        }
    }
}
