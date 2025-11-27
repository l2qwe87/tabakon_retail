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
        public void ParseFull_ShouldGenerateCorrectCIS()
        {
            // Arrange
            string qrCode = "010101010101212121XYZ";

            // Act
            var result = _parser.ParseFull(qrCode);

            // Assert
            Assert.IsTrue(result.IsSuccess, "Парсинг должен быть успешным");
            Assert.AreEqual("0101010101010121212121XYZ", result.CIS, "CIS должен соответствовать ожидаемому значению");
        }

        [TestMethod]
        public void ParseFull_WithAICode_ShouldGenerateCorrectCIS()
        {
            // Arrange
            string qrCode = "010541462278007621CimGms8C9swPomtz";

            // Act
            var result = _parser.ParseFull(qrCode);

            // Assert
            Assert.IsTrue(result.IsSuccess, "Парсинг должен быть успешным");
            Assert.AreEqual("010541462278007621CimGms8C9swPomtz", result.CIS, "CIS должен соответствовать ожидаемому значению");
        }

        [TestMethod]
        public void ParseFull_WithSpecialFormat_ShouldGenerateCorrectCIS()
        {
            // Arrange
            string qrCode = "04640030090709DYBLHiyACoA";

            // Act
            var result = _parser.ParseFull(qrCode);

            // Assert
            Assert.IsTrue(result.IsSuccess, "Парсинг должен быть успешным");
            Assert.AreEqual("010464003009070921DYBLHiy", result.CIS, "CIS должен соответствовать ожидаемому значению");
        }
    }
}