using System.Text.RegularExpressions;

namespace TbkQRParser.Specifications
{
    public class CigaretteSpecifications
    {
        /// <summary>
        /// Спецификации AI для сигарет
        /// </summary>
        public static AISpecification GTIN => CommonSpecifications.GTIN;

        /// <summary>
        /// Спецификация для серийного номера сигарет (7 символов)
        /// </summary>
        public static AISpecification SerialNumber7 => new AISpecification
        {
            AI = "21",
            Description = "Серийный номер сигарет (7 символов)",
            DataLength = 7,
            MinDataLength = 0, // фиксированная длина
            IsRequired = true,
            Order = 2,
            ValidationPattern = @"^[A-Za-z0-9+/=]{7}$"
        };

        /// <summary>
        /// Спецификация для серийного номера сигарет (переменная длина)
        /// </summary>
        public static AISpecification SerialNumberVariable => new AISpecification
        {
            AI = "21",
            Description = "Серийный номер сигарет (переменная длина)",
            DataLength = -1,
            MinDataLength = 6, // минимальная длина 6 символов
            IsRequired = true,
            Order = 2,
            ValidationPattern = @"^[A-Za-z0-9+/=]+$"
        };

        /// <summary>
        /// Спецификация для кода криптозащиты (4 символа)
        /// </summary>
        public static AISpecification CryptoCode4 => new AISpecification
        {
            AI = "93",
            Description = "Код криптозащиты (4 символа)",
            DataLength = 4,
            MinDataLength = 0, // фиксированная длина
            IsRequired = false,
            Order = 3,
            ValidationPattern = @"^[A-Za-z0-9+/=]{4}$"
        };
    }
}