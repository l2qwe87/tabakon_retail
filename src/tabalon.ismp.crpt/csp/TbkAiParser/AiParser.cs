using System;
using System.Collections.Generic;
using System.Linq;

namespace TbkAiParser
{
    /// <summary>
    /// Статический класс для парсинга AI кодов из строк Base64.
    /// </summary>
    public static class AiParser
    {
        private static readonly Dictionary<string, int> aiMinLengths = new()
        {
            { "01", 14 },
            { "21", 6 },
            { "8005", 6 },
            { "91", 4 },
            { "92", 4 },
            { "93", 4 }
        };

        private static readonly string[] possibleNextAis = { "8005", "91", "92", "93" };

        /// <summary>
        /// Разбирает входную строку на пары AI и значения.
        /// </summary>
        /// <param name="input">Входная строка Base64.</param>
        /// <returns>Список пар (AI, значение).</returns>
        public static List<KeyValuePair<string, string>> Parse(string input)
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
                    int valueLen = nextAiPos - pos;
                    // Добавляем значение к последнему AI
                    if (result.Count > 0)
                    {
                        var last = result.Last();
                        result[result.Count - 1] = new KeyValuePair<string, string>(last.Key, last.Value + input.Substring(pos, valueLen));
                    }

                    // Добавляем новый AI
                    pos = nextAiPos + foundAi.Length;
                    result.Add(new KeyValuePair<string, string>(foundAi, ""));
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
        private static (int pos, string? ai) FindNextValidAi(string input, int start, string[] ais)
        {
            int minPos = int.MaxValue;
            string foundAi = null;

            foreach (var ai in ais)
            {
                int index = input.IndexOf(ai, start);
                if (index != -1)
                {
                    if (ai == "93")
                    {
                        // 93 всегда последний, значение ровно 4 символа
                        int valueStart = index + 2;
                        if (valueStart + 4 == input.Length)
                        {
                            if (index < minPos)
                            {
                                minPos = index;
                                foundAi = ai;
                            }
                        }
                    }
                    else
                    {
                        // Проверяем, достаточно ли длины значения для этого AI
                        int valueStart = index + ai.Length;
                        int nextAiPos = FindNextAi(input, valueStart, ais);
                        int valueLen = nextAiPos == -1 ? input.Length - valueStart : nextAiPos - valueStart;
                        if (valueLen >= aiMinLengths[ai])
                        {
                            if (index < minPos)
                            {
                                minPos = index;
                                foundAi = ai;
                            }
                        }
                        // Иначе, этот AI считается частью значения предыдущего, пропускаем
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
        private static int FindNextAi(string input, int start, string[] ais)
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