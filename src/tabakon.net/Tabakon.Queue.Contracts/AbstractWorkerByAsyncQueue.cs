using System;
using System.Collections;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Tabakon.Queue.Contracts {
    public abstract class AbstractWorkerByAsyncQueue<T> : IWorkerByAsyncQueue<T> where T : class {


        protected abstract void LoggingStatus();
        protected abstract Task Do(T item);
        protected virtual int WorkerCount { get; } = 1;

        private readonly IAsyncQueue<T> _asyncQueue = new AsyncQueue<T>();

        public Task Add(T item) {
            return _asyncQueue.Enqueue(item);
        }

        private bool stopping = false;
        private ConcurrentQueue<Task> _workers = new ConcurrentQueue<Task>();
        public void Start() {

            for (int i = 0; i < WorkerCount; i++) {
                var worker = Task.Run(async () => {
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
                _workers.Enqueue(worker);
            }
        }

        public async ValueTask DisposeAsync() {

            stopping = true;
            foreach(var worker in _workers) {
                await worker;
            }
            
            T item = null;
            do {
                item = await _asyncQueue.Dequeue();
                if (item != null) {
                    await Do(item);
                }
            } while (item != null);

            GC.SuppressFinalize(this);
        }

        public string GetStatus() {
            return $" workers:{_workers.Count} / in queue:{_asyncQueue.Count()}";
        } 

        public async Task WaitAll()
        {
            await InternalWaitAll(false);

        }

        public async Task InternalWaitAll(bool doublecheck) {
            await Task.Delay(1000);
            if (doublecheck) {
                if (_asyncQueue.Count() > 0) {
                    await InternalWaitAll(false);
                }
            }
            
            else {
                while (_asyncQueue.Count() > 0) {
                    await Task.Delay(25);
                }
            }

            if (!doublecheck) {
                await InternalWaitAll(true);
            }

        }
    }
}
