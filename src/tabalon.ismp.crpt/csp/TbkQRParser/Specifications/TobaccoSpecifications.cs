using System.Text.RegularExpressions;

namespace TbkQRParser.Specifications
{
    public class TobaccoSpecifications
    {
        /// <summary>
        /// Спецификации AI для табачной продукции
        /// </summary>
        public static AISpecification GTIN => CommonSpecifications.GTIN;

        /// <summary>
        /// Спецификация для серийного номера табачной продукции
        /// </summary>
        public static AISpecification SerialNumber => CommonSpecifications.SerialNumber;

        /// <summary>
        /// Спецификация для кода криптозащиты табачной продукции
        /// </summary>
        public static AISpecification CryptoCode => CommonSpecifications.CryptoCode;

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