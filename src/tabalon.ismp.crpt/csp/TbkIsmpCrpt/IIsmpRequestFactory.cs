using TbkIsmpCrpt.Contracts;

namespace TbkIsmpCrpt
{
    public interface IIsmpRequestFactory
    {
        IIsmRequestBuilder Create();
    }
}