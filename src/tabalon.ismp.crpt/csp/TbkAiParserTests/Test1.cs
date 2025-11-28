using TbkAiParser;

namespace TbkAiParserTests;

[TestClass]
public sealed class AiParserTests
{
        [TestMethod]
        public void TestParse()
        {
            var handlers = new List<IAiHandler> { new StandardAiHandler(), new SpecialAiHandler() };
            var parser = new AiParser(handlers);
            var result = parser.Parse("0104640030090754210001%ix800515000093vRdW");
        Assert.AreEqual(4, result.Count);
        Assert.AreEqual("01", result[0].Key);
        Assert.AreEqual("04640030090754", result[0].Value);
        Assert.AreEqual("21", result[1].Key);
        Assert.AreEqual("0001%ix", result[1].Value);
        Assert.AreEqual("8005", result[2].Key);
        Assert.AreEqual("150000", result[2].Value);
        Assert.AreEqual("93", result[3].Key);
        Assert.AreEqual("vRdW", result[3].Value);
    }

        [DataTestMethod]
        [DataRow("0104640030090754210001%ix800515000093vRdW", "0104640030090754210001%ix")]
        [DataRow("010600179201211421LABtf,B 93gJWU", "010600179201211421LABtf,B")]
        [DataRow("(01)04680127995555(21)fGHwsVi", "010468012799555521fGHwsVi")]
        [DataRow("010400639605740221RU11121825238122948", "010400639605740221RU11121825238122948")]
        [DataRow("010401292285163521RU13120225293131337", "010401292285163521RU13120225293131337")]
        public void TestCisBuilder(string input, string expected)
        {
            var handlers = new List<IAiHandler> { new StandardAiHandler(), new SpecialAiHandler() };
            var parser = new AiParser(handlers);
            var cisBuilder = new CisBuilder(parser);
            var result = cisBuilder.Build(input);
        Assert.AreEqual(expected, result);
    }
}
