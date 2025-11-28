using System.Collections.Generic;

namespace TbkAiParser
{
    public interface IAiParser
    {
        List<KeyValuePair<string, string>> Parse(string input);
    }
}