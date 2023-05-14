using System;
using System.Threading.Tasks;

namespace Common.Logger.Contracts {
    public interface IEventLogger<T> {
        Task Info(string Event, string message);
        Task Error(string Event, string message);
    }
}
