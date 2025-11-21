using System.Collections.Generic;

namespace TbkQRParser
{
    /// <summary>
    /// Результат парсинга QR-кода/марки
    /// </summary>
    public class QRParseResult
    {
        /// <summary>
        /// Исходная строка QR-кода
        /// </summary>
        public string OriginalQR { get; set; }

        /// <summary>
        /// Определенная товарная группа
        /// </summary>
        public ProductGroup? ProductGroup { get; set; }

        /// <summary>
        /// CIS (Consumer Identification System)
        /// </summary>
        public string CIS { get; set; }

        /// <summary>
        /// Разобранные AI поля со значениями
        /// </summary>
        public Dictionary<string, string> ParsedFields { get; set; }

        /// <summary>
        /// Успешность парсинга
        /// </summary>
        public bool IsSuccess { get; set; }

        /// <summary>
        /// Флаг особого формата без AI полей
        /// </summary>
        public bool IsSpecialFormatWithoutAI { get; set; }

        /// <summary>
        /// Сообщение об ошибке (если парсинг не удался)
        /// </summary>
        public string ErrorMessage { get; set; }

        /// <summary>
        /// Длина исходного кода
        /// </summary>
        public int CodeLength => OriginalQR?.Length ?? 0;

        /// <summary>
        /// GTIN (Global Trade Item Number)
        /// </summary>
        public string GTIN => ParsedFields?.ContainsKey("01") == true ? ParsedFields["01"] : null;

        /// <summary>
        /// Серийный номер
        /// </summary>
        public string SerialNumber => ParsedFields?.ContainsKey("21") == true ? ParsedFields["21"] : null;

        /// <summary>
        /// Код криптозащиты
        /// </summary>
        public string CryptoCode => ParsedFields?.ContainsKey("93") == true ? ParsedFields["93"] : null;

        /// <summary>
        /// Вес товара в граммах
        /// </summary>
        public string Weight => ParsedFields?.ContainsKey("3103") == true ? ParsedFields["3103"] : null;

        /// <summary>
        /// Цена товара
        /// </summary>
        public string Price => ParsedFields?.ContainsKey("8005") == true ? ParsedFields["8005"] : null;

        /// <summary>
        /// Идентификатор компании
        /// </summary>
        public string CompanyId => ParsedFields?.ContainsKey("91") == true ? ParsedFields["91"] : null;

        /// <summary>
        /// Внутренний код организации
        /// </summary>
        public string InternalOrgCode => ParsedFields?.ContainsKey("92") == true ? ParsedFields["92"] : null;
    }
}