using System;
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
        public void GetCIS(string qr, string cis )
        {
            var qrPa = new QRParser(qr);
            Assert.Equal(cis, qrPa.CIS);
        }
    }
}
