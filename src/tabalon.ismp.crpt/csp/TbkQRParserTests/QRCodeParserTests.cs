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
        public void ParseFull_WithSimpleCode_ShouldParseCorrectly()
        {
            // Arrange - код длиной 21 символ (простой формат без AI)
            string qrCode = "010101010101212121XYZ";

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

            // Проверка значений полей для простого формата (21 символ)
            Assert.AreEqual("01010101010121", result.GTIN, "GTIN должен быть первые 14 символов");
            Assert.AreEqual("2121XYZ", result.SerialNumber, "Серийный номер должен быть следующие 7 символов");

            // Проверка определения товарной группы
            Assert.IsNotNull(result.ProductGroup, "Товарная группа должна быть определена");
            
            // Проверка флага особого формата (должен быть false для обычного формата)
            Assert.IsFalse(result.IsSpecialFormatWithoutAI, "Флаг особого формата должен быть false для обычного формата");
        }

        [TestMethod]
        public void ParseFull_WithEmptyCode_ShouldReturnError()
        {
            // Arrange
            string qrCode = "";

            // Act
            var result = _parser.ParseFull(qrCode);

            // Assert
            Assert.IsFalse(result.IsSuccess, "Парсинг пустого кода должен быть неуспешным");
            Assert.IsNotNull(result.ErrorMessage, "Должно быть сообщение об ошибке");
            Assert.IsTrue(result.ErrorMessage.Contains("пустым"), "Ошибка должна упоминать пустой код");
        }

        [TestMethod]
        public void ParseFull_WithSpecialFormat_ShouldParseCorrectly()
        {
            // Arrange - реальный кейс особого формата без AI
            string qrCode = "04640030090709DYBLHiyACoA";

            // Act
            var result = _parser.ParseFull(qrCode);

            // Assert
            Assert.IsTrue(result.IsSuccess, $"Парсинг должен быть успешным. Ошибка: {result.ErrorMessage}");
            Assert.IsNull(result.ErrorMessage, "Не должно быть ошибки");
            Assert.AreEqual(qrCode, result.OriginalQR, "Исходный код должен сохраниться");

            // Проверка наличия полей
            Assert.IsNotNull(result.ParsedFields, "Поля должны быть разобраны");
            Assert.IsTrue(result.ParsedFields.ContainsKey("01"), "Должно содержаться поле GTIN (01)");
            Assert.IsTrue(result.ParsedFields.ContainsKey("21"), "Должно содержаться поле серийного номера (21)");
            Assert.IsTrue(result.ParsedFields.ContainsKey("8005"), "Должно содержаться поле цены (8005)");

            // Проверка значений полей для особого формата
            Assert.AreEqual("04640030090709", result.GTIN, "GTIN должен быть первые 14 символов");
            Assert.AreEqual("DYBLHiy", result.SerialNumber, "Серийный номер должен быть следующие 7 символов");
            Assert.AreEqual("ACoA", result.Price, "Цена должна быть следующие 4 символа");

            // Проверка определения товарной группы
            Assert.IsNotNull(result.ProductGroup, "Товарная группа должна быть определена");
            Assert.AreEqual(ProductGroup.CigarettesWithFilter, result.ProductGroup, "Должна быть определена группа сигарет с фильтром");
            
            // Проверка флага особого формата
            Assert.IsTrue(result.IsSpecialFormatWithoutAI, "Должен быть установлен флаг особого формата без AI");
        }

        [TestMethod]
        public void ParseFull_WithNullCode_ShouldReturnError()
        {
            // Arrange
            string qrCode = null;

            // Act
            var result = _parser.ParseFull(qrCode);

            // Assert
            Assert.IsFalse(result.IsSuccess, "Парсинг null кода должен быть неуспешным");
            Assert.IsNotNull(result.ErrorMessage, "Должно быть сообщение об ошибке");
        }

        [TestMethod]
        public void ParseFull_WithSpecialFormatWithAI_ShouldParseCorrectly()
        {
            // Arrange - особый формат с AI полями (реальный кейс)
            string qrCode = "010541462278007621CimGms8C9swPomtz";

            // Act
            var result = _parser.ParseFull(qrCode);

            // Assert
            Assert.IsTrue(result.IsSuccess, $"Парсинг должен быть успешным. Ошибка: {result.ErrorMessage}");
            Assert.IsNull(result.ErrorMessage, "Не должно быть ошибки");
            Assert.AreEqual(qrCode, result.OriginalQR, "Исходный код должен сохраниться");

            // Проверка наличия полей
            Assert.IsNotNull(result.ParsedFields, "Поля должны быть разобраны");
            Assert.IsTrue(result.ParsedFields.ContainsKey("01"), "Должно содержаться поле GTIN (01)");
            Assert.IsTrue(result.ParsedFields.ContainsKey("21"), "Должно содержаться поле серийного номера (21)");

            // Проверка значений полей для особого формата с AI
            Assert.AreEqual("05414622780076", result.GTIN, "GTIN должен быть первые 14 символов после AI");
            Assert.AreEqual("CimGms8C9swPomtz", result.SerialNumber, "Серийный номер должен быть оставшаяся часть");

            // Проверка определения товарной группы
            Assert.IsNotNull(result.ProductGroup, "Товарная группа должна быть определена");
            Assert.AreEqual(ProductGroup.CigarettesWithFilter, result.ProductGroup, "Должна быть определена группа сигарет с фильтром");
            
            // Проверка флага особого формата
            Assert.IsTrue(result.IsSpecialFormatWithoutAI, "Должен быть установлен флаг особого формата без AI");
        }
    }
}