using System;
using System.Collections.Generic;
using System.Linq;

namespace TbkAiParser
{
    /// <summary>
    /// Класс для парсинга AI кодов из строк Base64.
    /// </summary>
    public class AiParser : IAiParser
    {
        private readonly IEnumerable<IAiHandler> handlers;
        private readonly string[] possibleNextAis = { "8005", "91", "92", "93" };

        public AiParser(IEnumerable<IAiHandler> handlers)
        {
            this.handlers = handlers;
        }

        /// <inheritdoc />
        public List<KeyValuePair<string, string>> Parse(string input)
        {
            var result = new List<KeyValuePair<string, string>>();
            int pos = 0;

            // Проверка и разбор 01
            if (input.Length < 2 || input.Substring(0, 2) != "01")
                throw new ArgumentException("Входная строка должна начинаться с '01'");
            pos += 2;
            if (pos + 14 > input.Length)
                throw new ArgumentException("Недостаточно символов для значения '01'");
            string ai = "01";
            string value = input.Substring(pos, 14);
            result.Add(new KeyValuePair<string, string>(ai, value));
            pos += 14;

            // Проверка и разбор 21
            if (pos + 2 > input.Length || input.Substring(pos, 2) != "21")
                throw new ArgumentException("'21' должен следовать за '01'");
            ai = "21";
            pos += 2;
            result.Add(new KeyValuePair<string, string>(ai, ""));

            // Теперь разбираем остаток
            while (pos < input.Length)
            {
                var (nextAiPos, foundAi) = FindNextValidAi(input, pos, possibleNextAis);
                if (nextAiPos == -1)
                {
                    // Больше нет AI, добавляем остаток к последнему
                    if (result.Count > 0)
                    {
                        var last = result.Last();
                        result[result.Count - 1] = new KeyValuePair<string, string>(last.Key, last.Value + input.Substring(pos));
                    }
                    pos = input.Length;
                    break;
                }
                else
                {
                    // Found valid AI
                    var handler = handlers.FirstOrDefault(h => h.CanHandle(foundAi));
                    if (handler != null)
                    {
                        var aiResult = handler.Handle(input, nextAiPos, foundAi);
                        if (aiResult != null)
                        {
                            int valueLen = nextAiPos - pos;
                            // Добавляем значение к последнему AI
                            if (result.Count > 0)
                            {
                                var last = result.Last();
                                result[result.Count - 1] = new KeyValuePair<string, string>(last.Key, last.Value + input.Substring(pos, valueLen));
                            }

                            // Добавляем новый AI
                            pos = aiResult.NewPos;
                            result.Add(new KeyValuePair<string, string>(foundAi, aiResult.Value));
                        }
                        else
                        {
                            // Not valid, skip
                            pos = nextAiPos + foundAi.Length;
                        }
                    }
                }
            }

            return result;
        }

        /// <summary>
        /// Находит следующий допустимый AI начиная с указанной позиции.
        /// </summary>
        /// <param name="input">Входная строка.</param>
        /// <param name="start">Начальная позиция поиска.</param>
        /// <param name="ais">Массив возможных AI.</param>
        /// <returns>Кортеж с позицией и найденным AI, или (-1, null).</returns>
        private (int pos, string? ai) FindNextValidAi(string input, int start, string[] ais)
        {
            int minPos = int.MaxValue;
            string foundAi = null;

            foreach (var ai in ais)
            {
                int index = input.IndexOf(ai, start);
                if (index != -1)
                {
                    var handler = handlers.FirstOrDefault(h => h.CanHandle(ai));
                    if (handler != null)
                    {
                        var result = handler.Handle(input, index, ai);
                        if (result != null)
                        {
                            if (index < minPos)
                            {
                                minPos = index;
                                foundAi = ai;
                            }
                        }
                    }
                }
            }

            return minPos == int.MaxValue ? (-1, null) : (minPos, foundAi!);
        }

        /// <summary>
        /// Находит позицию следующего AI из массива начиная с указанной позиции.
        /// </summary>
        /// <param name="input">Входная строка.</param>
        /// <param name="start">Начальная позиция поиска.</param>
        /// <param name="ais">Массив AI для поиска.</param>
        /// <returns>Позиция найденного AI или -1.</returns>
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