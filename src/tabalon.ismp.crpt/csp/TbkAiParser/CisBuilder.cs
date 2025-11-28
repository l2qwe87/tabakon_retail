using System.Linq;

namespace TbkAiParser
{
    /// <summary>
    /// Статический класс для построения CIS строк из Base64 входа.
    /// </summary>
    public static class CisBuilder
    {
        /// <summary>
        /// Строит CIS строку из входной Base64 строки.
        /// </summary>
        /// <param name="input">Входная строка Base64.</param>
        /// <returns>CIS строка или первые 21 символов если не подходит.</returns>
        public static string Build(string input)
        {
            // Подготавливаем вход: заменяем (01) на 01, (21) на 21
            input = input.Replace("(01)", "01").Replace("(21)", "21");
            // Проверяем, начинается ли с 01 и есть ли 21 на позициях 16-17
            if (input.Length >= 18 && input.Substring(0, 2) == "01" && input.Substring(16, 2) == "21")
            {
                var result = AiParser.Parse(input);
                var ai01 = result.FirstOrDefault(r => r.Key == "01");
                var ai21 = result.FirstOrDefault(r => r.Key == "21");
                if (!string.IsNullOrEmpty(ai01.Key) && !string.IsNullOrEmpty(ai21.Key))
                {
                    return "01" + ai01.Value.Trim() + "21" + ai21.Value.Trim();
                }
                else
                {
                    throw new ArgumentException("Разбор не удался");
                }
            }
            else
            {
                // Возвращаем первые 21 символов с обрезкой пробелов
                return input.Substring(0, Math.Min(21, input.Length)).Trim();
            }
        }
    }
}