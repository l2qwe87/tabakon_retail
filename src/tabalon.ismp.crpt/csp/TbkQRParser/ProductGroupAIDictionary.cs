using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;

namespace TbkQRParser
{
    /// <summary>
    /// Описание параметров Application Identifier (AI)
    /// </summary>
    public class AISpecification
    {
        /// <summary>
        /// Код AI (например, "01", "21", "93")
        /// </summary>
        public string AI { get; set; }

        /// <summary>
        /// Описание AI
        /// </summary>
        public string Description { get; set; }

        /// <summary>
        /// Фиксированная длина данных (-1 для переменной длины)
        /// </summary>
        public int DataLength { get; set; }

        /// <summary>
        /// Обязательный ли AI для данной товарной группы
        /// </summary>
        public bool IsRequired { get; set; }

        /// <summary>
        /// Порядковый номер в структуре DataMatrix
        /// </summary>
        public int Order { get; set; }

        /// <summary>
        /// Регулярное выражение для валидации данных
        /// </summary>
        public string ValidationPattern { get; set; }
    }

    /// <summary>
    /// Структура AI для конкретной товарной группы
    /// </summary>
    public class ProductGroupAIStructure
    {
        /// <summary>
        /// Товарная группа
        /// </summary>
        public ProductGroup ProductGroup { get; set; }

        /// <summary>
        /// Список спецификаций AI в правильном порядке
        /// </summary>
        public List<AISpecification> AISpecifications { get; set; }

        /// <summary>
        /// Получает спецификации AI в правильном порядке
        /// </summary>
        /// <returns>Упорядоченный список спецификаций AI</returns>
        public List<AISpecification> GetOrderedSpecifications()
        {
            return AISpecifications.OrderBy(spec => spec.Order).ToList();
        }

        /// <summary>
        /// Получает обязательные AI для данной товарной группы
        /// </summary>
        /// <returns>Список обязательных AI</returns>
        public List<AISpecification> GetRequiredSpecifications()
        {
            return AISpecifications.Where(spec => spec.IsRequired).OrderBy(spec => spec.Order).ToList();
        }

        /// <summary>
        /// Получает спецификацию AI по коду
        /// </summary>
        /// <param name="ai">Код AI</param>
        /// <returns>Спецификация AI или null</returns>
        public AISpecification GetSpecificationByAI(string ai)
        {
            return AISpecifications.FirstOrDefault(spec => spec.AI == ai);
        }
    }

    /// <summary>
    /// Словарь соответствия товарных групп и структур AI
    /// </summary>
    public static class ProductGroupAIDictionary
    {
        /// <summary>
        /// Словарь структур AI для всех товарных групп
        /// </summary>
        private static readonly Dictionary<ProductGroup, ProductGroupAIStructure> _structures;

        static ProductGroupAIDictionary()
        {
            _structures = new Dictionary<ProductGroup, ProductGroupAIStructure>();

            // Общие спецификации AI
            var commonSpecs = new List<AISpecification>
            {
                new AISpecification
                {
                    AI = "01",
                    Description = "GTIN (Global Trade Item Number)",
                    DataLength = 14,
                    IsRequired = true,
                    Order = 1,
                    ValidationPattern = @"^\d{14}$"
                },
                new AISpecification
                {
                    AI = "21",
                    Description = "Серийный номер",
                    DataLength = -1, // переменная длина
                    IsRequired = true,
                    Order = 2,
                    ValidationPattern = @"^[A-Za-z0-9+/=]{1,20}$"
                },
                new AISpecification
                {
                    AI = "93",
                    Description = "Код криптозащиты",
                    DataLength = 4,
                    IsRequired = false,
                    Order = 3,
                    ValidationPattern = @"^[A-Za-z0-9+/=]{4}$"
                },
                new AISpecification
                {
                    AI = "91",
                    Description = "Идентификатор компании",
                    DataLength = -1, // переменная длина
                    IsRequired = false,
                    Order = 4,
                    ValidationPattern = @"^[A-Za-z0-9+/=]{1,30}$"
                },
                new AISpecification
                {
                    AI = "92",
                    Description = "Внутренний код организации",
                    DataLength = -1, // переменная длина
                    IsRequired = false,
                    Order = 5,
                    ValidationPattern = @"^[A-Za-z0-9+/=]{1,30}$"
                },
                new AISpecification
                {
                    AI = "8005",
                    Description = "Цена товара",
                    DataLength = 6,
                    IsRequired = false,
                    Order = 6,
                    ValidationPattern = @"^\d{6}$"
                },
                new AISpecification
                {
                    AI = "3103",
                    Description = "Вес товара (нетто) в граммах",
                    DataLength = 6,
                    IsRequired = false,
                    Order = 7,
                    ValidationPattern = @"^\d{6}$"
                }
            };

            // Структура для сигарет с фильтром
            _structures[ProductGroup.CigarettesWithFilter] = new ProductGroupAIStructure
            {
                ProductGroup = ProductGroup.CigarettesWithFilter,
                AISpecifications = new List<AISpecification>(commonSpecs)
            };

            // Структура для сигарет без фильтра
            _structures[ProductGroup.CigarettesWithoutFilter] = new ProductGroupAIStructure
            {
                ProductGroup = ProductGroup.CigarettesWithoutFilter,
                AISpecifications = new List<AISpecification>(commonSpecs)
            };

            // Структура для сигарилл
            _structures[ProductGroup.Cigarillos] = new ProductGroupAIStructure
            {
                ProductGroup = ProductGroup.Cigarillos,
                AISpecifications = new List<AISpecification>(commonSpecs)
            };

            // Структура для сигар
            _structures[ProductGroup.Cigars] = new ProductGroupAIStructure
            {
                ProductGroup = ProductGroup.Cigars,
                AISpecifications = new List<AISpecification>(commonSpecs)
            };

            // Структура для курительного табака (включает вес)
            _structures[ProductGroup.SmokingTobacco] = new ProductGroupAIStructure
            {
                ProductGroup = ProductGroup.SmokingTobacco,
                AISpecifications = new List<AISpecification>(commonSpecs)
            };
            // Для курительного табака вес является обязательным
            _structures[ProductGroup.SmokingTobacco].AISpecifications
                .First(spec => spec.AI == "3103").IsRequired = true;

            // Структура для трубочного табака (включает вес)
            _structures[ProductGroup.PipeTobacco] = new ProductGroupAIStructure
            {
                ProductGroup = ProductGroup.PipeTobacco,
                AISpecifications = new List<AISpecification>(commonSpecs)
            };
            // Для трубочного табака вес является обязательным
            _structures[ProductGroup.PipeTobacco].AISpecifications
                .First(spec => spec.AI == "3103").IsRequired = true;

            // Структура для насвайного табака (включает вес)
            _structures[ProductGroup.NaswayTobacco] = new ProductGroupAIStructure
            {
                ProductGroup = ProductGroup.NaswayTobacco,
                AISpecifications = new List<AISpecification>(commonSpecs)
            };
            // Для насвайного табака вес является обязательным
            _structures[ProductGroup.NaswayTobacco].AISpecifications
                .First(spec => spec.AI == "3103").IsRequired = true;

            // Структура для электронных систем доставки никотина
            _structures[ProductGroup.ElectronicNicotineDeliverySystems] = new ProductGroupAIStructure
            {
                ProductGroup = ProductGroup.ElectronicNicotineDeliverySystems,
                AISpecifications = new List<AISpecification>(commonSpecs)
            };

            // Структура для жидкостей для электронных систем доставки никотина (включает вес)
            _structures[ProductGroup.LiquidsForElectronicNicotineDeliverySystems] = new ProductGroupAIStructure
            {
                ProductGroup = ProductGroup.LiquidsForElectronicNicotineDeliverySystems,
                AISpecifications = new List<AISpecification>(commonSpecs)
            };
            // Для жидкостей вес является обязательным
            _structures[ProductGroup.LiquidsForElectronicNicotineDeliverySystems].AISpecifications
                .First(spec => spec.AI == "3103").IsRequired = true;

            // Структура для прочей табачной продукции
            _structures[ProductGroup.OtherTobaccoProducts] = new ProductGroupAIStructure
            {
                ProductGroup = ProductGroup.OtherTobaccoProducts,
                AISpecifications = new List<AISpecification>(commonSpecs)
            };
        }

        /// <summary>
        /// Получает структуру AI для товарной группы
        /// </summary>
        /// <param name="productGroup">Товарная группа</param>
        /// <returns>Структура AI</returns>
        public static ProductGroupAIStructure GetStructure(ProductGroup productGroup)
        {
            return _structures.TryGetValue(productGroup, out var structure) ? structure : null;
        }

        /// <summary>
        /// Получает все доступные структуры AI
        /// </summary>
        /// <returns>Словарь всех структур</returns>
        public static Dictionary<ProductGroup, ProductGroupAIStructure> GetAllStructures()
        {
            return new Dictionary<ProductGroup, ProductGroupAIStructure>(_structures);
        }

        /// <summary>
        /// Проверяет валидность AI для товарной группы
        /// </summary>
        /// <param name="productGroup">Товарная группа</param>
        /// <param name="ai">Код AI</param>
        /// <param name="data">Данные AI</param>
        /// <returns>Результат валидации</returns>
        public static bool ValidateAI(ProductGroup productGroup, string ai, string data)
        {
            var structure = GetStructure(productGroup);
            if (structure == null) return false;

            var spec = structure.GetSpecificationByAI(ai);
            if (spec == null) return false;

            // Проверка длины
            if (spec.DataLength > 0 && data.Length != spec.DataLength)
                return false;

            // Проверка по регулярному выражению
            if (!string.IsNullOrEmpty(spec.ValidationPattern))
                return Regex.IsMatch(data, spec.ValidationPattern);

            return true;
        }

        /// <summary>
        /// Получает ожидаемую длину данных для AI
        /// </summary>
        /// <param name="ai">Код AI</param>
        /// <returns>Длина данных (-1 для переменной)</returns>
        public static int GetDataLengthForAI(string ai)
        {
            var allSpecs = _structures.Values.SelectMany(s => s.AISpecifications);
            var spec = allSpecs.FirstOrDefault(s => s.AI == ai);
            return spec?.DataLength ?? -1;
        }
    }
}