using System.Text.RegularExpressions;

namespace TbkQRParser.Specifications
{
    public class CommonSpecifications
    {
        /// <summary>
        /// Общие спецификации AI для всех товарных групп
        /// </summary>
        public static AISpecification GTIN => new AISpecification
        {
            AI = "01",
            Description = "GTIN (Global Trade Item Number)",
            DataLength = 14,
            MinDataLength = 0, // фиксированная длина
            IsRequired = true,
            Order = 1,
            ValidationPattern = @"^\d{14}$"
        };

        /// <summary>
        /// Спецификация для серийного номера
        /// </summary>
        public static AISpecification SerialNumber => new AISpecification
        {
            AI = "21",
            Description = "Серийный номер",
            DataLength = -1, // переменная длина
            MinDataLength = 6, // минимальная длина 6 символов
            IsRequired = true,
            Order = 2,
            ValidationPattern = @"^[A-Za-z0-9+/=?\-\._]{1,20}$"
        };

        /// <summary>
        /// Спецификация для кода криптозащиты
        /// </summary>
        public static AISpecification CryptoCode => new AISpecification
        {
            AI = "93",
            Description = "Код криптозащиты",
            DataLength = 4,
            MinDataLength = 0, // фиксированная длина
            IsRequired = false,
            Order = 3,
            ValidationPattern = @"^[A-Za-z0-9+/=]{4}$"
        };

        /// <summary>
        /// Спецификация для идентификатора компании
        /// </summary>
        public static AISpecification CompanyIdentifier => new AISpecification
        {
            AI = "91",
            Description = "Идентификатор компании",
            DataLength = -1, // переменная длина
            MinDataLength = 1, // минимальная длина 1 символ
            IsRequired = false,
            Order = 4,
            ValidationPattern = @"^[A-Za-z0-9+/=]{1,30}$"
        };

        /// <summary>
        /// Спецификация для внутреннего кода организации
        /// </summary>
        public static AISpecification InternalCode => new AISpecification
        {
            AI = "92",
            Description = "Внутренний код организации",
            DataLength = -1, // переменная длина
            MinDataLength = 1, // минимальная длина 1 символ
            IsRequired = false,
            Order = 5,
            ValidationPattern = @"^[A-Za-z0-9+/=]{1,30}$"
        };

        /// <summary>
        /// Спецификация для максимальной розничной цены
        /// </summary>
        public static AISpecification MaxRetailPrice => new AISpecification
        {
            AI = "8005",
            Description = "Максимальная розничная цена",
            DataLength = 6,
            MinDataLength = 0, // фиксированная длина
            IsRequired = false,
            Order = 6,
            ValidationPattern = @"^\d{6}$"
        };

        /// <summary>
        /// Спецификация для минимальной розничной цены
        /// </summary>
        public static AISpecification MinRetailPrice => new AISpecification
        {
            AI = "8005",
            Description = "Минимальная розничная цена",
            DataLength = 6,
            MinDataLength = 0, // фиксированная длина
            IsRequired = false,
            Order = 6,
            ValidationPattern = @"^\d{6}$"
        };
    }
}