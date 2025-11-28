namespace TbkAiParser
{
    /// <summary>
    /// Обработчик AI.
    /// </summary>
    public interface IAiHandler
    {
        /// <summary>
        /// Определяет, может ли обработчик обработать данный AI.
        /// </summary>
        /// <param name="ai">AI код.</param>
        /// <returns>True, если может обработать.</returns>
        bool CanHandle(string ai);

        /// <summary>
        /// Обрабатывает AI начиная с указанной позиции.
        /// </summary>
        /// <param name="input">Входная строка.</param>
        /// <param name="start">Начальная позиция.</param>
        /// <param name="ai">AI код.</param>
        /// <returns>Результат обработки.</returns>
        AiResult Handle(string input, int start, string ai);
    }
}