using System.Text.RegularExpressions;

namespace TbkQRParser.Specifications
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
        /// Минимальная длина данных для AI с переменной длиной (0 для фиксированной длины)
        /// </summary>
        public int MinDataLength { get; set; }

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
}