using System.Collections.Generic;
using System.Linq;

namespace TbkQRParser
{
    /// <summary>
    /// Спецификация длины кода для товарной группы
    /// </summary>
    public class ProductGroupCodeLength
    {
        /// <summary>
        /// Товарная группа
        /// </summary>
        public ProductGroup ProductGroup { get; set; }

        /// <summary>
        /// Минимальная длина кода
        /// </summary>
        public int MinLength { get; set; }

        /// <summary>
        /// Максимальная длина кода
        /// </summary>
        public int MaxLength { get; set; }

        /// <summary>
        /// Стандартная длина кода (наиболее распространенная)
        /// </summary>
        public int StandardLength { get; set; }

        /// <summary>
        /// Описание формата кода
        /// </summary>
        public string Description { get; set; }

        /// <summary>
        /// Возможные варианты длин кода
        /// </summary>
        public List<int> PossibleLengths { get; set; }

        /// <summary>
        /// Проверяет, соответствует ли длина кода спецификации
        /// </summary>
        /// <param name="codeLength">Длина кода для проверки</param>
        /// <returns>True, если длина соответствует спецификации</returns>
        public bool IsValidLength(int codeLength)
        {
            return PossibleLengths.Contains(codeLength);
        }
    }

    /// <summary>
    /// Словарь соответствия товарных групп и длин кодов
    /// </summary>
    public static class ProductGroupCodeLengthDictionary
    {
        /// <summary>
        /// Словарь длин кодов для всех товарных групп
        /// </summary>
        private static readonly Dictionary<ProductGroup, ProductGroupCodeLength> _codeLengths;

        static ProductGroupCodeLengthDictionary()
        {
            _codeLengths = new Dictionary<ProductGroup, ProductGroupCodeLength>();

            // Сигареты с фильтром
            _codeLengths[ProductGroup.CigarettesWithFilter] = new ProductGroupCodeLength
            {
                ProductGroup = ProductGroup.CigarettesWithFilter,
                MinLength = 21,
                MaxLength = 68,
                StandardLength = 25,
                Description = "GTIN(14) + Серийный номер(7) + Опционально: Цена(4-6) + Криптозащита(4)",
                PossibleLengths = new List<int> { 21, 25, 29, 31, 34, 35, 39, 43, 47, 51, 55, 59, 63, 67, 68 }
            };

            // Сигареты без фильтра
            _codeLengths[ProductGroup.CigarettesWithoutFilter] = new ProductGroupCodeLength
            {
                ProductGroup = ProductGroup.CigarettesWithoutFilter,
                MinLength = 21,
                MaxLength = 68,
                StandardLength = 25,
                Description = "GTIN(14) + Серийный номер(7) + Опционально: Цена(4-6) + Криптозащита(4)",
                PossibleLengths = new List<int> { 21, 25, 29, 31, 34, 35, 39, 43, 47, 51, 55, 59, 63, 67, 68 }
            };

            // Сигариллы
            _codeLengths[ProductGroup.Cigarillos] = new ProductGroupCodeLength
            {
                ProductGroup = ProductGroup.Cigarillos,
                MinLength = 21,
                MaxLength = 68,
                StandardLength = 25,
                Description = "GTIN(14) + Серийный номер(7) + Опционально: Цена(4-6) + Криптозащита(4)",
                PossibleLengths = new List<int> { 21, 25, 29, 31, 35, 39, 43, 47, 51, 55, 59, 63, 67, 68 }
            };

            // Сигары
            _codeLengths[ProductGroup.Cigars] = new ProductGroupCodeLength
            {
                ProductGroup = ProductGroup.Cigars,
                MinLength = 21,
                MaxLength = 68,
                StandardLength = 25,
                Description = "GTIN(14) + Серийный номер(7) + Опционально: Цена(4-6) + Криптозащита(4)",
                PossibleLengths = new List<int> { 21, 25, 29, 31, 35, 39, 43, 47, 51, 55, 59, 63, 67, 68 }
            };

            // Курительный табак (включает вес)
            _codeLengths[ProductGroup.SmokingTobacco] = new ProductGroupCodeLength
            {
                ProductGroup = ProductGroup.SmokingTobacco,
                MinLength = 31,
                MaxLength = 78,
                StandardLength = 35,
                Description = "GTIN(14) + Серийный номер(7) + Вес(6) + Опционально: Цена(4-6) + Криптозащита(4)",
                PossibleLengths = new List<int> { 31, 35, 39, 41, 45, 49, 53, 57, 61, 65, 69, 73, 77, 78 }
            };

            // Трубочный табак (включает вес)
            _codeLengths[ProductGroup.PipeTobacco] = new ProductGroupCodeLength
            {
                ProductGroup = ProductGroup.PipeTobacco,
                MinLength = 31,
                MaxLength = 78,
                StandardLength = 35,
                Description = "GTIN(14) + Серийный номер(7) + Вес(6) + Опционально: Цена(4-6) + Криптозащита(4)",
                PossibleLengths = new List<int> { 31, 35, 39, 41, 45, 49, 53, 57, 61, 65, 69, 73, 77, 78 }
            };

            // Насвайный табак (включает вес)
            _codeLengths[ProductGroup.NaswayTobacco] = new ProductGroupCodeLength
            {
                ProductGroup = ProductGroup.NaswayTobacco,
                MinLength = 31,
                MaxLength = 78,
                StandardLength = 35,
                Description = "GTIN(14) + Серийный номер(7) + Вес(6) + Опционально: Цена(4-6) + Криптозащита(4)",
                PossibleLengths = new List<int> { 31, 35, 39, 41, 45, 49, 53, 57, 61, 65, 69, 73, 77, 78 }
            };

            // Электронные системы доставки никотина
            _codeLengths[ProductGroup.ElectronicNicotineDeliverySystems] = new ProductGroupCodeLength
            {
                ProductGroup = ProductGroup.ElectronicNicotineDeliverySystems,
                MinLength = 21,
                MaxLength = 68,
                StandardLength = 25,
                Description = "GTIN(14) + Серийный номер(7) + Опционально: Цена(4-6) + Криптозащита(4)",
                PossibleLengths = new List<int> { 21, 25, 29, 31, 35, 39, 43, 47, 51, 55, 59, 63, 67, 68 }
            };

            // Жидкости для электронных систем доставки никотина (включает вес)
            _codeLengths[ProductGroup.LiquidsForElectronicNicotineDeliverySystems] = new ProductGroupCodeLength
            {
                ProductGroup = ProductGroup.LiquidsForElectronicNicotineDeliverySystems,
                MinLength = 31,
                MaxLength = 78,
                StandardLength = 35,
                Description = "GTIN(14) + Серийный номер(7) + Вес(6) + Опционально: Цена(4-6) + Криптозащита(4)",
                PossibleLengths = new List<int> { 31, 35, 39, 41, 45, 49, 53, 57, 61, 65, 69, 73, 77, 78 }
            };

            // Прочая табачная продукция
            _codeLengths[ProductGroup.OtherTobaccoProducts] = new ProductGroupCodeLength
            {
                ProductGroup = ProductGroup.OtherTobaccoProducts,
                MinLength = 21,
                MaxLength = 78,
                StandardLength = 25,
                Description = "GTIN(14) + Серийный номер(7) + Опционально: Вес(6) + Цена(4-6) + Криптозащита(4)",
                PossibleLengths = new List<int> { 21, 25, 29, 31, 35, 39, 41, 43, 45, 47, 49, 51, 53, 55, 57, 59, 61, 63, 65, 67, 68, 69, 73, 77, 78 }
            };
        }

        /// <summary>
        /// Получает спецификацию длины кода для товарной группы
        /// </summary>
        /// <param name="productGroup">Товарная группа</param>
        /// <returns>Спецификация длины кода</returns>
        public static ProductGroupCodeLength GetCodeLength(ProductGroup productGroup)
        {
            return _codeLengths.TryGetValue(productGroup, out var codeLength) ? codeLength : null;
        }

        /// <summary>
        /// Получает все доступные спецификации длин кодов
        /// </summary>
        /// <returns>Словарь всех спецификаций</returns>
        public static Dictionary<ProductGroup, ProductGroupCodeLength> GetAllCodeLengths()
        {
            return new Dictionary<ProductGroup, ProductGroupCodeLength>(_codeLengths);
        }

        /// <summary>
        /// Проверяет, является ли длина кода допустимой для товарной группы
        /// </summary>
        /// <param name="productGroup">Товарная группа</param>
        /// <param name="codeLength">Длина кода для проверки</param>
        /// <returns>True, если длина допустима</returns>
        public static bool IsValidCodeLength(ProductGroup productGroup, int codeLength)
        {
            var spec = GetCodeLength(productGroup);
            return spec?.IsValidLength(codeLength) ?? false;
        }

        /// <summary>
        /// Получает возможные товарные группы для указанной длины кода
        /// </summary>
        /// <param name="codeLength">Длина кода</param>
        /// <returns>Список возможных товарных групп</returns>
        public static List<ProductGroup> GetPossibleProductGroups(int codeLength)
        {
            return _codeLengths
                .Where(kvp => kvp.Value.IsValidLength(codeLength))
                .Select(kvp => kvp.Key)
                .ToList();
        }

        /// <summary>
        /// Получает стандартную длину кода для товарной группы
        /// </summary>
        /// <param name="productGroup">Товарная группа</param>
        /// <returns>Стандартная длина кода</returns>
        public static int GetStandardLength(ProductGroup productGroup)
        {
            var spec = GetCodeLength(productGroup);
            return spec?.StandardLength ?? 25; // значение по умолчанию
        }

        /// <summary>
        /// Получает диапазон длин кодов для товарной группы
        /// </summary>
        /// <param name="productGroup">Товарная группа</param>
        /// <returns>Кортеж с минимальной и максимальной длиной</returns>
        public static (int Min, int Max) GetLengthRange(ProductGroup productGroup)
        {
            var spec = GetCodeLength(productGroup);
            return spec != null ? (spec.MinLength, spec.MaxLength) : (21, 78);
        }
    }
}