using System;
using System.Threading.Tasks;

namespace Tabakon.Queue.Contracts {
    public interface IWorkerByAsyncQueue<T> : IAsyncDisposable where T : class { 
        void Start();
        Task Add(T item);
        Task WaitAll();
    }
}
