namespace TbkAiParser
{
    /// <summary>
    /// Специальный обработчик для AI '93'.
    /// </summary>
    public class SpecialAiHandler : IAiHandler
    {
        /// <inheritdoc />
        public bool CanHandle(string ai) => ai == "93";

        /// <inheritdoc />
        public AiResult Handle(string input, int start, string ai)
        {
            int valueStart = start + 2;
            if (valueStart + 4 == input.Length)
            {
                string value = input.Substring(valueStart, 4);
                return new AiResult { NewPos = input.Length, Ai = ai, Value = value };
            }
            return null; // Not valid
        }
    }
}