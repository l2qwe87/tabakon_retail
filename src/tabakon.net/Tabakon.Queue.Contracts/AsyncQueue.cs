using System.Collections.Concurrent;
using System.Threading.Tasks;

namespace Tabakon.Queue.Contracts {
    public class AsyncQueue<T> : IAsyncQueue<T> where T : class {
        static private readonly ConcurrentQueue<T> _queue = new ConcurrentQueue<T>();
        public Task<T> Dequeue() {
            if (_queue.TryDequeue(out var result)) {
                return Task.FromResult(result);
            }
            return Task.FromResult(null as T);
        }

        public Task Enqueue(T item) {
            _queue.Enqueue(item);
            return Task.CompletedTask;
        }

        public int Count() => _queue.Count;
    }
}
