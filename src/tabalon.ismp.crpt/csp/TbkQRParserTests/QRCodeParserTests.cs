using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Linq;
using TbkQRParser;

namespace TbkQRParserTests
{
    [TestClass]
    public class QRCodeParserTests
    {
        private QRCodeParser _parser;

        [TestInitialize]
        public void Setup()
        {
            _parser = new QRCodeParser();
        }

        [TestMethod]
        [DataRow("", false, "пустым")]
        [DataRow(null, false, null)]
        public void ParseFull_WithInvalidCodes_ShouldReturnError(string qrCode, bool expectedSuccess, string expectedErrorContains)
        {
            // Act
            var result = _parser.ParseFull(qrCode);

            // Assert
            Assert.AreEqual(expectedSuccess, result.IsSuccess, $"Парсинг кода '{qrCode}' должен быть {(expectedSuccess ? "успешным" : "неуспешным")}");
            
            if (!expectedSuccess)
            {
                Assert.IsNotNull(result.ErrorMessage, "Должно быть сообщение об ошибке");
                if (expectedErrorContains != null)
                {
                    Assert.IsTrue(result.ErrorMessage.Contains(expectedErrorContains), $"Ошибка должна содержать '{expectedErrorContains}'");
                }
            }
        }

        [TestMethod]
        [DataRow("010101010101212121XYZ", "01010101010121", "2121XYZ", null, false)]
        [DataRow("04640030090709DYBLHiyACoA", "04640030090709", "DYBLHiy", "ACoA", true)]
        [DataRow("010541462278007621CimGms8C9swPomtz", "05414622780076", "CimGms8C9swPomtz", null, false)]

        public void ParseFull_WithValidCodes_ShouldParseCorrectly(string qrCode, string expectedGtin, string expectedSerial, string expectedPrice, bool expectedSpecialFormat)
        {
            // Act
            var result = _parser.ParseFull(qrCode);

            // Assert
            Assert.IsTrue(result.IsSuccess, $"Парсинг должен быть успешным. Ошибка: {result.ErrorMessage}");
            Assert.IsNull(result.ErrorMessage, "Не должно быть ошибки");
            Assert.AreEqual(qrCode, result.OriginalQR, "Исходный код должен сохраниться");

            // Проверка наличия обязательных полей
            Assert.IsNotNull(result.ParsedFields, "Поля должны быть разобраны");
            Assert.IsTrue(result.ParsedFields.ContainsKey("01"), "Должно содержаться поле GTIN (01)");
            Assert.IsTrue(result.ParsedFields.ContainsKey("21"), "Должно содержаться поле серийного номера (21)");

            // Проверка значений полей
            Assert.AreEqual(expectedGtin, result.GTIN, "GTIN должен соответствовать ожидаемому значению");
            Assert.AreEqual(expectedSerial, result.SerialNumber, "Серийный номер должен соответствовать ожидаемому значению");

            // Проверка цены (если ожидается)
            if (expectedPrice != null)
            {
                Assert.IsTrue(result.ParsedFields.ContainsKey("8005"), "Должно содержаться поле цены (8005)");
                Assert.AreEqual(expectedPrice, result.Price, "Цена должна соответствовать ожидаемому значению");
            }
            


            // Проверка определения товарной группы
            Assert.IsNotNull(result.ProductGroup, "Товарная группа должна быть определена");
            
            // Проверка флага особого формата
            Assert.AreEqual(expectedSpecialFormat, result.IsSpecialFormatWithoutAI, "Флаг особого формата должен соответствовать ожидаемому значению");
        }
    }
}