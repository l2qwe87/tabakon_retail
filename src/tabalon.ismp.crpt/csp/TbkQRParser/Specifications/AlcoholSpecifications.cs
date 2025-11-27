    using System.Text.RegularExpressions;

namespace TbkQRParser.Specifications
{
    public class AlcoholSpecifications
    {
        /// <summary>
        /// Спецификации AI для алкогольной продукции
        /// </summary>
        public static AISpecification GTIN => CommonSpecifications.GTIN;

        /// <summary>
        /// Спецификация для серийного номера алкогольной продукции
        /// </summary>
        public static AISpecification SerialNumber => CommonSpecifications.SerialNumber;

        /// <summary>
        /// Спецификация для кода криптозащиты алкогольной продукции
        /// </summary>
        public static AISpecification CryptoCode => CommonSpecifications.CryptoCode;
    }



    public class PerfumerySpecifications
    {
        /// <summary>
        /// Спецификации AI для парфюмерной продукции
        /// </summary>
        public static AISpecification GTIN => CommonSpecifications.GTIN;

        /// <summary>
        /// Спецификация для серийного номера парфюмерной продукции
        /// </summary>
        public static AISpecification SerialNumber => CommonSpecifications.SerialNumber;

        /// <summary>
        /// Спецификация для кода криптозащиты парфюмерной продукции
        /// </summary>
        public static AISpecification CryptoCode => CommonSpecifications.CryptoCode;
    }

    public class MedicineSpecifications
    {
        /// <summary>
        /// Спецификации AI для медицинской продукции
        /// </summary>
        public static AISpecification GTIN => CommonSpecifications.GTIN;

        /// <summary>
        /// Спецификация для серийного номера медицинской продукции
        /// </summary>
        public static AISpecification SerialNumber => CommonSpecifications.SerialNumber;

        /// <summary>
        /// Спецификация для кода криптозащиты медицинской продукции
        /// </summary>
        public static AISpecification CryptoCode => CommonSpecifications.CryptoCode;

        /// <summary>
        /// Спецификация для номера серии медицинской продукции
        /// </summary>
        public static AISpecification MedicalSerialNumber => new AISpecification
        {
            AI = "21",
            Description = "Номер серии медицинской продукции",
            DataLength = -1,
            MinDataLength = 1, // минимальная длина 1 символ
            IsRequired = true,
            Order = 2,
            ValidationPattern = @"^[A-Za-z0-9]{1,20}$"
        };

        /// <summary>
        /// Спецификация для даты истечения срока годности
        /// </summary>
        public static AISpecification ExpirationDate => new AISpecification
        {
            AI = "17",
            Description = "Дата истечения срока годности",
            DataLength = 6,
            MinDataLength = 0, // фиксированная длина
            IsRequired = false,
            Order = 10,
            ValidationPattern = @"^\d{6}$"
        };
    }
}