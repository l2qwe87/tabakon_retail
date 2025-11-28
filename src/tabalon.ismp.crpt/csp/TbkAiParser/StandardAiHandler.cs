using System.Collections.Generic;

namespace TbkAiParser
{
    /// <summary>
    /// Стандартный обработчик AI.
    /// </summary>
    public class StandardAiHandler : IAiHandler
    {
        private readonly Dictionary<string, int> aiMinLengths = new()
        {
            { "01", 14 },
            { "21", 6 },
            { "8005", 6 },
            { "91", 4 },
            { "92", 4 },
            { "93", 4 }
        };

        private readonly string[] possibleNextAis = { "8005", "91", "92", "93" };

        /// <inheritdoc />
        public bool CanHandle(string ai) => aiMinLengths.ContainsKey(ai) && ai != "93";

        /// <inheritdoc />
        public AiResult Handle(string input, int start, string ai)
        {
            int aiLen = ai.Length;
            int valueStart = start + aiLen;
            int nextAiPos = FindNextAi(input, valueStart, possibleNextAis);
            int valueLen = nextAiPos == -1 ? input.Length - valueStart : nextAiPos - valueStart;
            if (valueLen >= aiMinLengths[ai])
            {
                string value = input.Substring(valueStart, valueLen);
                return new AiResult { NewPos = nextAiPos == -1 ? input.Length : nextAiPos, Ai = ai, Value = value };
            }
            return null; // Not valid
        }

        private int FindNextAi(string input, int start, string[] ais)
        {
            int minPos = int.MaxValue;
            foreach (var ai in ais)
            {
                int index = input.IndexOf(ai, start);
                if (index != -1 && index < minPos)
                {
                    minPos = index;
                }
            }
            return minPos == int.MaxValue ? -1 : minPos;
        }
    }
}