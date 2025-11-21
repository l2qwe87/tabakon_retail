using System;
using System.Collections.Generic;
using System.Linq;

namespace TbkIsmpCrptApi
{
    /// <summary>
    /// Разбирает QR-коды, содержащие данные GS1, для извлечения информации CIS (Consumer Identification System).
    /// </summary>
    public class QRParser
    {
        private QRParser() { }

        private string _gtin;
        private string _serialNumber;
        private string _price;
        private string _sign;

        /// <summary>
        /// Получает разобранную строку CIS.
        /// </summary>
        public string CIS { get; private set; }

        /// <summary>
        /// Инициализирует новый экземпляр класса QRParser с предоставленной строкой QR.
        /// </summary>
        /// <param name="qr">Строка QR-кода для разбора.</param>
        public QRParser(string qr)
        {
            if (qr.StartsWith("(01)") && qr.IndexOf("(21)", 2) > 0)
            {
                qr = qr.Replace("(01)", "01").Replace("(21)", "21");
            }

            var fields = ParseGS1String(qr);
            if (fields.ContainsKey("01") && fields.ContainsKey("21"))
            {
                // Согласно документации DataMatrix, CIS должен возвращать "Код товара" + "Серийный номер"
                // Используем результаты GS1 парсинга для получения полей
                CIS = ("01" + fields["01"] + "21" + fields["21"]).Trim();
            }
            else
            {
                var gtin_length = 14;
                var serialNumber_length = 7;
                var price_length = 4;
                var sign_length = 4;

                if (qr.Length == gtin_length + serialNumber_length)
                {
                    price_length = 0;
                    sign_length = 0;
                }
                if (qr.Length == gtin_length + serialNumber_length + price_length + sign_length + 2)
                {
                    price_length += 2;
                }
                if (qr.Length == gtin_length + serialNumber_length + price_length)
                {
                    sign_length = 0;
                }

                if (qr.Length != gtin_length + serialNumber_length + price_length + sign_length)
                {
                    CIS = qr.Trim();
                }
                else
                {
                    _gtin = qr.Substring(0, gtin_length);
                    _serialNumber = qr.Substring(gtin_length, serialNumber_length);
                    _price = qr.Substring(gtin_length + serialNumber_length, price_length);
                    _sign = qr.Substring(gtin_length + serialNumber_length + price_length, sign_length);

                    CIS = $"{_gtin}{_serialNumber}".Trim();
                }
            }

        }

        /// <summary>
        /// Находит начальную позицию следующего допустимого AI в строке.
        /// Для поля 21 (серийный номер) использует более строгие правила поиска.
        /// </summary>
        /// <param name="s">Строка для поиска.</param>
        /// <param name="startPos">Начальная позиция для поиска.</param>
        /// <param name="currentAI">Текущий AI для определения правил поиска.</param>
        /// <returns>Позиция следующего AI или длина строки, если не найдено.</returns>
        private static int FindNextAIStart(string s, int startPos, string currentAI)
        {
            for (int pos = startPos; pos < s.Length; pos++)
            {
                for (int len = 2; len <= 4; len++)
                {
                    if (pos + len <= s.Length)
                    {
                        string candidate = s.Substring(pos, len);
                        if (IsValidAI(candidate) && candidate != currentAI)
                        {
                            // Для поля 21 (серийный номер) используем более строгую проверку
                            if (currentAI == "21")
                            {
                                // Проверяем, что это действительно начало нового AI
                                if (IsStartOfNewAI(s, pos, candidate))
                                {
                                    return pos;
                                }
                            }
                            else
                            {
                                return pos;
                            }
                        }
                    }
                }
            }
            return s.Length;
        }

        /// <summary>
        /// Проверяет, является ли позиция действительно началом нового AI.
        /// </summary>
        /// <param name="s">Строка для анализа.</param>
        /// <param name="pos">Позиция кандидата.</param>
        /// <param name="candidate">Кандидат AI.</param>
        /// <returns>True, если это начало нового AI.</returns>
        private static bool IsStartOfNewAI(string s, int pos, string candidate)
        {
            // Для AI с фиксированной длиной проверяем наличие достаточного количества данных
            if (candidate == "93")
            {
                return pos + 2 + 4 <= s.Length; // AI + 4 символа данных
            }
            if (candidate == "3103")
            {
                return pos + 4 + 6 <= s.Length; // AI + 6 символов данных
            }
            
            // Для AI с переменной длиной (91, 92, 8005) проверяем, что после данных есть другой AI
            if (candidate == "91" || candidate == "92" || candidate == "8005")
            {
                // Ищем следующий AI после этого
                int nextPos = pos + 2;
                while (nextPos < s.Length)
                {
                    for (int len = 2; len <= 4; len++)
                    {
                        if (nextPos + len <= s.Length)
                        {
                            string nextCandidate = s.Substring(nextPos, len);
                            if (IsValidAI(nextCandidate) && nextCandidate != candidate)
                            {
                                return true; // Нашли следующий AI
                            }
                        }
                    }
                    nextPos++;
                }
                return false; // Следующий AI не найден
            }
            
            return true;
        }

        /// <summary>
        /// Разбирает строку в формате GS1 в словарь полей AI.
        /// </summary>
        /// <param name="gs1String">Строка GS1 для разбора.</param>
        /// <returns>Словарь, содержащий ключи AI и соответствующие значения данных.</returns>
        private static Dictionary<string, string> ParseGS1String(string gs1String)
        {
            var fields = new Dictionary<string, string>();
            int pos = 0;

            while (pos < gs1String.Length)
            {
                string ai = "";
                for (int i = pos; i < Math.Min(pos + 4, gs1String.Length); i++)
                {
                    ai += gs1String[i];
                    if (IsValidAI(ai))
                    {
                        pos += ai.Length;
                        break;
                    }
                }

                if (string.IsNullOrEmpty(ai) || !IsValidAI(ai))
                    break;

                int dataLength = GetDataLengthForAI(ai);
                string data = "";

                if (dataLength > 0)
                {
                    if (pos + dataLength > gs1String.Length)
                    {
                        break;
                    }
                    data = gs1String.Substring(pos, dataLength);
                    pos += dataLength;
                }
                else
                {
                    int nextAIStart = FindNextAIStart(gs1String, pos, ai);
                    data = gs1String.Substring(pos, nextAIStart - pos);
                    pos = nextAIStart;
                }

                fields[ai] = data;
            }

            return fields;
        }

        /// <summary>
        /// Проверяет, является ли данная строка допустимым Application Identifier (AI).
        /// </summary>
        /// <param name="ai">Строка AI для проверки.</param>
        /// <returns>True, если AI допустим, иначе false.</returns>
        private static bool IsValidAI(string ai)
        {
            string[] validAI = { "01", "21", "10", "91", "92", "93", "8005", "3103" };
            return validAI.Contains(ai);
        }



        /// <summary>
        /// Получает ожидаемую длину данных для данного AI. Возвращает -1 для переменной длины.
        /// </summary>
        /// <param name="ai">Application Identifier.</param>
        /// <returns>Длина данных или -1, если переменная.</returns>
        private static int GetDataLengthForAI(string ai)
        {
            switch (ai)
            {
                case "01": return 14;
                case "21": return -1;
                case "10": return -1;
                case "91": return -1;
                case "92": return -1;
                case "93": return 4;
                case "8005": return -1;
                case "3103": return 6;
                default: return -1;
            }
        }
    }
}