using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;

namespace TbkQRParser
{
    /// <summary>
    /// Парсер QR-кодов и марок табачной продукции
    /// </summary>
    public class QRCodeParser
    {
        /// <summary>
        /// Полный парсинг QR-кода с определением товарной группы и разбором AI полей
        /// </summary>
        /// <param name="qrCode">Строка QR-кода для парсинга</param>
        /// <returns>Результат парсинга с товарной группой и разобранными полями</returns>
        public QRParseResult ParseFull(string qrCode)
        {
            if (string.IsNullOrWhiteSpace(qrCode))
            {
                return new QRParseResult
                {
                    OriginalQR = qrCode,
                    IsSuccess = false,
                    ErrorMessage = "QR-код не может быть пустым"
                };
            }

            try
            {
                // Очистка и нормализация QR-кода
                var normalizedQR = NormalizeQRCode(qrCode);

                Dictionary<string, string> parsedFields;
                
                // Если длина 21 - простая структура без AI
                if (normalizedQR.Length == 21)
                {
                    parsedFields = ParseSimpleFormat(normalizedQR);
                }
                else
                {
                    // Парсинг AI полей с использованием спецификаций
                    var parseResult = ParseGS1WithSpecifications(normalizedQR);
                    
                    if (!parseResult.IsSuccess)
                    {
                        return new QRParseResult
                        {
                            OriginalQR = qrCode,
                            IsSuccess = false,
                            ErrorMessage = parseResult.ErrorMessage
                        };
                    }

                    parsedFields = parseResult.ParsedFields;
                }

                // Формирование CIS
                var cis = GenerateCIS(parsedFields);

                // Определение возможных товарных групп по длине кода
                var possibleGroups = ProductGroupCodeLengthDictionary.GetPossibleProductGroups(normalizedQR.Length);

                // Уточнение товарной группы по наличию обязательных полей и валидации
                var productGroup = DetermineProductGroup(parsedFields, possibleGroups);

                return new QRParseResult
                {
                    OriginalQR = qrCode,
                    ProductGroup = productGroup,
                    CIS = cis,
                    ParsedFields = parsedFields,
                    IsSuccess = true
                };
            }
            catch (Exception ex)
            {
                return new QRParseResult
                {
                    OriginalQR = qrCode,
                    IsSuccess = false,
                    ErrorMessage = $"Ошибка при парсинге QR-кода: {ex.Message}"
                };
            }
        }

        /// <summary>
        /// Нормализация QR-кода (удаление скобок и пробелов)
        /// </summary>
        /// <param name="qrCode">Исходный QR-код</param>
        /// <returns>Нормализованный QR-код</returns>
        private string NormalizeQRCode(string qrCode)
        {
            return qrCode
                .Trim()
                .Replace("(01)", "01")
                .Replace("(21)", "21")
                .Replace("(10)", "10")
                .Replace("(91)", "91")
                .Replace("(92)", "92")
                .Replace("(93)", "93")
                .Replace("(8005)", "8005")
                .Replace("(3103)", "3103")
                .Replace(" ", "");
        }

        /// <summary>
        /// Разбор строки в формате GS1 с использованием спецификаций
        /// </summary>
        /// <param name="gs1String">Строка GS1 для разбора</param>
        /// <returns>Результат парсинга с полями и валидацией</returns>
        private (bool IsSuccess, string ErrorMessage, Dictionary<string, string> ParsedFields) ParseGS1WithSpecifications(string gs1String)
        {
            var fields = new Dictionary<string, string>();
            var usedAIs = new HashSet<string>();
            int lastOrder = 0;
            int pos = 0;

            while (pos < gs1String.Length)
            {
                // Поиск следующего AI
                var (ai, aiLength) = FindNextAI(gs1String, pos);
                if (string.IsNullOrEmpty(ai))
                {
                    return (false, $"Не удалось распознать AI в позиции {pos}", fields);
                }

                // Проверка на повторное использование AI
                if (usedAIs.Contains(ai))
                {
                    return (false, $"AI {ai} встречается более одного раза", fields);
                }

                // Получение спецификации AI
                var spec = GetAISpecification(ai);
                if (spec == null)
                {
                    return (false, $"Неизвестный AI: {ai}", fields);
                }

                // Проверка порядка AI
                if (spec.Order <= lastOrder)
                {
                    return (false, $"Нарушен порядок AI: {ai} (Order={spec.Order}) после AI с Order={lastOrder}", fields);
                }

                pos += aiLength;
                lastOrder = spec.Order;

                // Извлечение данных AI
                var (data, dataLength) = ExtractAIData(gs1String, pos, spec);
                if (data == null)
                {
                    return (false, $"Ошибка извлечения данных для AI {ai}", fields);
                }

                // Валидация данных
                if (!ValidateAIData(ai, data, spec))
                {
                    return (false, $"Невалидные данные для AI {ai}: {data}", fields);
                }

                fields[ai] = data;
                usedAIs.Add(ai);
                pos += dataLength;
            }

            return (true, null, fields);
        }

        /// <summary>
        /// Поиск следующего AI в строке
        /// </summary>
        /// <param name="s">Строка для поиска</param>
        /// <param name="startPos">Начальная позиция</param>
        /// <returns>Найденный AI и его длина</returns>
        private (string AI, int Length) FindNextAI(string s, int startPos)
        {
            for (int pos = startPos; pos < s.Length; pos++)
            {
                for (int len = 2; len <= 4; len++)
                {
                    if (pos + len <= s.Length)
                    {
                        string candidate = s.Substring(pos, len);
                        if (IsValidAI(candidate))
                        {
                            return (candidate, len);
                        }
                    }
                }
            }
            return (null, 0);
        }

        /// <summary>
        /// Извлечение данных для AI с учетом спецификации и возможных длин кодов
        /// </summary>
        /// <param name="gs1String">Исходная строка</param>
        /// <param name="pos">Позиция начала данных</param>
        /// <param name="spec">Спецификация AI</param>
        /// <returns>Данные AI и их длина</returns>
        private (string Data, int Length) ExtractAIData(string gs1String, int pos, AISpecification spec)
        {
            if (spec.DataLength > 0)
            {
                // Фиксированная длина
                if (pos + spec.DataLength > gs1String.Length)
                {
                    return (null, 0);
                }
                return (gs1String.Substring(pos, spec.DataLength), spec.DataLength);
            }
            else
            {
                // Переменная длина - ищем следующий AI с учетом возможных длин кодов
                int nextPos = FindNextAIStartWithCodeLengths(gs1String, pos, spec.AI);
                return (gs1String.Substring(pos, nextPos - pos), nextPos - pos);
            }
        }

        /// <summary>
        /// Находит начальную позицию следующего AI в строке
        /// </summary>
        /// <param name="s">Строка для поиска</param>
        /// <param name="startPos">Начальная позиция</param>
        /// <param name="currentAI">Текущий AI</param>
        /// <returns>Позиция следующего AI</returns>
        private int FindNextAIStart(string s, int startPos, string currentAI)
        {
            for (int pos = startPos; pos < s.Length; pos++)
            {
                var (nextAI, _) = FindNextAI(s, pos);
                if (!string.IsNullOrEmpty(nextAI) && nextAI != currentAI)
                {
                    return pos;
                }
            }
            return s.Length;
        }

        /// <summary>
        /// Находит начальную позицию следующего AI с учетом возможных длин кодов
        /// </summary>
        /// <param name="s">Строка для поиска</param>
        /// <param name="startPos">Начальная позиция</param>
        /// <param name="currentAI">Текущий AI</param>
        /// <returns>Позиция следующего AI</returns>
        private int FindNextAIStartWithCodeLengths(string s, int startPos, string currentAI)
        {
            for (int pos = startPos; pos < s.Length; pos++)
            {
                var (nextAI, _) = FindNextAI(s, pos);
                if (!string.IsNullOrEmpty(nextAI) && nextAI != currentAI)
                {
                    // Проверяем, что оставшаяся длина соответствует возможным длинам кодов
                    int remainingLength = s.Length - pos;
                    var possibleGroups = ProductGroupCodeLengthDictionary.GetPossibleProductGroups(remainingLength);
                    
                    if (possibleGroups.Count > 0)
                    {
                        return pos;
                    }
                }
            }
            return s.Length;
        }

        /// <summary>
        /// Получает спецификацию AI из всех доступных структур
        /// </summary>
        /// <param name="ai">Код AI</param>
        /// <returns>Спецификация AI или null</returns>
        private AISpecification GetAISpecification(string ai)
        {
            var allStructures = ProductGroupAIDictionary.GetAllStructures();
            foreach (var structure in allStructures.Values)
            {
                var spec = structure.GetSpecificationByAI(ai);
                if (spec != null)
                    return spec;
            }
            return null;
        }

        /// <summary>
        /// Валидация данных AI с использованием спецификации
        /// </summary>
        /// <param name="ai">Код AI</param>
        /// <param name="data">Данные для валидации</param>
        /// <param name="spec">Спецификация AI</param>
        /// <returns>True, если данные валидны</returns>
        private bool ValidateAIData(string ai, string data, AISpecification spec)
        {
            // Проверка длины
            if (spec.DataLength > 0 && data.Length != spec.DataLength)
                return false;

            // Проверка по регулярному выражению
            if (!string.IsNullOrEmpty(spec.ValidationPattern))
                return Regex.IsMatch(data, spec.ValidationPattern);

            return true;
        }

        /// <summary>
        /// Генерирует CIS на основе разобранных полей
        /// </summary>
        /// <param name="parsedFields">Разобранные AI поля</param>
        /// <returns>CIS строка</returns>
        private string GenerateCIS(Dictionary<string, string> parsedFields)
        {
            if (parsedFields.ContainsKey("01") && parsedFields.ContainsKey("21"))
            {
                return ("01" + parsedFields["01"] + "21" + parsedFields["21"]).Trim();
            }
            
            // Если нет AI полей, возвращаем исходную строку
            return parsedFields.Values.FirstOrDefault() ?? "";
        }

        /// <summary>
        /// Определяет товарную группу на основе разобранных полей и возможных вариантов
        /// </summary>
        /// <param name="parsedFields">Разобранные AI поля</param>
        /// <param name="possibleGroups">Возможные товарные группы по длине</param>
        /// <returns>Определенная товарная группа</returns>
        private ProductGroup? DetermineProductGroup(Dictionary<string, string> parsedFields, List<ProductGroup> possibleGroups)
        {
            if (possibleGroups.Count == 0)
                return null;

            if (possibleGroups.Count == 1)
                return possibleGroups.First();

            // Проверяем наличие обязательных полей для каждой группы
            foreach (var group in possibleGroups)
            {
                var structure = ProductGroupAIDictionary.GetStructure(group);
                if (structure != null)
                {
                    var requiredSpecs = structure.GetRequiredSpecifications();
                    bool allRequiredPresent = requiredSpecs.All(spec => parsedFields.ContainsKey(spec.AI));
                    
                    if (allRequiredPresent)
                        return group;
                }
            }

            // Если не удалось определить однозначно, возвращаем первую возможную
            return possibleGroups.First();
        }

        /// <summary>
        /// Парсинг простого формата (21 символ) без AI полей
        /// </summary>
        /// <param name="qrCode">QR-код длиной 21 символ</param>
        /// <returns>Словарь с GTIN и серийным номером</returns>
        private Dictionary<string, string> ParseSimpleFormat(string qrCode)
        {
            var fields = new Dictionary<string, string>();
            
            if (qrCode.Length >= 21)
            {
                // Первые 14 символов - GTIN
                fields["01"] = qrCode.Substring(0, 14);
                
                // Следующие 7 символов - серийный номер
                fields["21"] = qrCode.Substring(14, 7);
            }
            
            return fields;
        }

        /// <summary>
        /// Проверяет, является ли строка допустимым AI
        /// </summary>
        /// <param name="ai">Строка AI для проверки</param>
        /// <returns>True, если AI допустим</returns>
        private bool IsValidAI(string ai)
        {
            // Используем словарь для проверки валидности AI
            return ProductGroupAIDictionary.GetDataLengthForAI(ai) != -1 || 
                   ProductGroupAIDictionary.GetDataLengthForAI(ai) > 0;
        }
    }
}