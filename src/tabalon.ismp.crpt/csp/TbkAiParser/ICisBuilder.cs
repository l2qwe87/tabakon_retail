namespace TbkAiParser
{
    /// <summary>
    /// Интерфейс для построения CIS строк из Base64 входа.
    /// </summary>
    public interface ICisBuilder
    {
        /// <summary>
        /// Строит CIS строку из входной Base64 строки.
        /// </summary>
        /// <param name="input">Входная строка Base64.</param>
        /// <returns>CIS строка или первые 21 символов если не подходит.</returns>
        string Build(string input);
    }
}