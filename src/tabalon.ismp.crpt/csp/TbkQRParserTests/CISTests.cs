using Microsoft.VisualStudio.TestTools.UnitTesting;
using TbkQRParser;

namespace TbkQRParserTests
{
    [TestClass]
    public class CISTests
    {
        private QRCodeParser _parser;

        [TestInitialize]
        public void Setup()
        {
            _parser = new QRCodeParser();
        }

        [TestMethod]
        [DataRow("010101010101212121XYZ", "0101010101010121212121XYZ")]
        [DataRow("010541462278007621CimGms8C9swPomtz", "010541462278007621CimGms8C9swPomtz")]
        [DataRow("04640030090709DYBLHiyACoA", "04640030090709DYBLHiyACoA")]
        [DataRow("00000046198488X?io+qCABm8wAYa", "00000046198488X?io+qC")]
        public void ParseFull_ShouldGenerateCorrectCIS(string qrCode, string expectedCIS)
        {
            // Act
            var result = _parser.ParseFull(qrCode);

            // Assert
            Assert.IsTrue(result.IsSuccess, $"Парсинг должен быть успешным для кода: {qrCode}");
            Assert.AreEqual(expectedCIS, result.CIS, $"CIS должен соответствовать ожидаемому значению для кода: {qrCode}");
        }
    }
}