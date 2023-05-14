using System.Threading.Tasks;

namespace Tabakon.Queue.Contracts {
    public interface IAsyncQueue<T> where T : class {
        Task Enqueue(T item);
        Task<T> Dequeue();
        int Count();
    }
}
