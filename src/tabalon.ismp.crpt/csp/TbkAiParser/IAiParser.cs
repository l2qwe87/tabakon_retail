using System.Collections.Generic;

namespace TbkAiParser
{
    /// <summary>
    /// Интерфейс для парсинга AI кодов из строк Base64.
    /// </summary>
    public interface IAiParser
    {
        /// <summary>
        /// Разбирает входную строку на пары AI и значения.
        /// </summary>
        /// <param name="input">Входная строка Base64.</param>
        /// <returns>Список пар (AI, значение).</returns>
        List<KeyValuePair<string, string>> Parse(string input);
    }
}