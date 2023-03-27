using System;
using System.Threading.Tasks;

namespace Tabakon.Queue.Contracts {
    public abstract class AbstractWorkerByAsyncQueue<T> : IWorkerByAsyncQueue<T> where T : class {

        protected abstract Task Do(T item);

        private readonly IAsyncQueue<T> _asyncQueue = new AsyncQueue<T>();

        public Task Add(T item) {
            return _asyncQueue.Enqueue(item);
        }

        private bool stopping = false;
        private Task _worker;
        public void Start() {

            _worker = Task.Run(async () => {
                while (!stopping) {
                    var item = await _asyncQueue.Dequeue();
                    if (item != null) {
                        await Do(item);
                        await Task.Delay(100);
                    }
                    else { 
                        await Task.Delay(1000);
                    }
                }
            });
        }

        public async ValueTask DisposeAsync() {

            stopping = true;
            await _worker;

            T item = null;
            do {
                item = await _asyncQueue.Dequeue();
                if (item != null) {
                    await Do(item);
                }
            } while (item != null);

            GC.SuppressFinalize(this);
        }
    }
}
