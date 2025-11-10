using System;
using System.Net;
using System.Net.Http;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Moq;
using Moq.Protected;
using TbkIsmpCrpt;

namespace QRParserTest
{
    [TestClass]
    public class IsmpRequestTests
    {
        private readonly IServiceProvider _serviceProvider;

        public IsmpRequestTests()
        {
            var services = new ServiceCollection();
            services.AddTransient<HttpClient>((sp) => new HttpClient(new Mock<HttpMessageHandler>().Object)); // Mock handler per client
            services.AddSingleton(new IsmpClientConfig { BaseUrlTobacco = "https://test.com", BaseUrlOther = "https://test.com", HttpTimeoutInSeconds = 5 });
            services.AddLogging(); // Add logging
            _serviceProvider = services.BuildServiceProvider();
        }

        /// <summary>
        /// Проверяет, что успешный HTTP-запрос возвращает ожидаемый ответ без повторных попыток.
        /// </summary>
        [TestMethod]
        public async Task SendAsync_SuccessfulRequest_ReturnsResponse()
        {
            // Arrange
            var handlerMock = new Mock<HttpMessageHandler>();
            handlerMock.Protected()
                .Setup<Task<HttpResponseMessage>>("SendAsync", ItExpr.IsAny<HttpRequestMessage>(), ItExpr.IsAny<CancellationToken>())
                .ReturnsAsync(new HttpResponseMessage(HttpStatusCode.OK) { Content = new StringContent("{\"test\":\"data\"}") });

            var services = new ServiceCollection();
            services.AddTransient<HttpClient>((sp) => new HttpClient(handlerMock.Object));
            services.AddSingleton(new IsmpClientConfig { BaseUrlTobacco = "https://test.com", BaseUrlOther = "https://test.com", HttpTimeoutInSeconds = 5 });
            services.AddLogging();
            var sp = services.BuildServiceProvider();

            var request = IsmpRequest.Create(sp)
                .SetRequestUrl("test")
                .Build();

            // Act
            var result = await request.SendAsync();

            // Assert
            Assert.AreEqual(200, result.StatusCode);
            Assert.AreEqual("{\"test\":\"data\"}", result.Body);
            handlerMock.Protected().Verify("SendAsync", Times.Once(), ItExpr.IsAny<HttpRequestMessage>(), ItExpr.IsAny<CancellationToken>());
        }

        /// <summary>
        /// Проверяет, что исключение таймаута вызывает повторные попытки до 10 раз перед выбросом исключения.
        /// </summary>
        [TestMethod]
        public async Task SendAsync_TimeoutException_RetriesUpToTenTimes()
        {
            // Arrange
            var handlerMock = new Mock<HttpMessageHandler>();
            handlerMock.Protected()
                .Setup<Task<HttpResponseMessage>>("SendAsync", ItExpr.IsAny<HttpRequestMessage>(), ItExpr.IsAny<CancellationToken>())
                .ThrowsAsync(new TaskCanceledException("Timeout"));

            var services = new ServiceCollection();
            services.AddTransient<HttpClient>((sp) => new HttpClient(handlerMock.Object));
            services.AddSingleton(new IsmpClientConfig { BaseUrlTobacco = "https://test.com", BaseUrlOther = "https://test.com", HttpTimeoutInSeconds = 5 });
            services.AddLogging();
            var sp = services.BuildServiceProvider();

            var request = IsmpRequest.Create(sp)
                .SetRequestUrl("test")
                .Build();

            // Act & Assert
            await Assert.ThrowsExceptionAsync<TaskCanceledException>(() => request.SendAsync());
            handlerMock.Protected().Verify("SendAsync", Times.Exactly(10), ItExpr.IsAny<HttpRequestMessage>(), ItExpr.IsAny<CancellationToken>());
        }

        /// <summary>
        /// Проверяет, что статус код 403 Forbidden вызывает повторные попытки до 20 раз (по 10 на URL) перед возвратом ответа.
        /// </summary>
        [TestMethod]
        public async Task SendAsync_403Status_RetriesUpToTenTimes()
        {
            // Arrange
            var handlerMock = new Mock<HttpMessageHandler>();
            handlerMock.Protected()
                .Setup<Task<HttpResponseMessage>>("SendAsync", ItExpr.IsAny<HttpRequestMessage>(), ItExpr.IsAny<CancellationToken>())
                .Returns(() => Task.FromResult(new HttpResponseMessage(HttpStatusCode.Forbidden) { Content = new StringContent("Forbidden") }));

            var services = new ServiceCollection();
            services.AddTransient<HttpClient>((sp) => new HttpClient(handlerMock.Object));
            services.AddSingleton(new IsmpClientConfig { BaseUrlTobacco = "https://test.com", BaseUrlOther = "https://test.com", HttpTimeoutInSeconds = 5 });
            services.AddLogging();
            var sp = services.BuildServiceProvider();

            var request = IsmpRequest.Create(sp)
                .SetRequestUrl("test")
                .Build();

            // Act
            var result = await request.SendAsync();

            // Assert
            Assert.AreEqual(403, result.StatusCode);
            handlerMock.Protected().Verify("SendAsync", Times.Exactly(20), ItExpr.IsAny<HttpRequestMessage>(), ItExpr.IsAny<CancellationToken>());
        }

        /// <summary>
        /// Проверяет, что после нескольких неудачных попыток успешный ответ возвращается без дальнейших повторных попыток.
        /// </summary>
        [TestMethod]
        public async Task SendAsync_SuccessAfterRetries_ReturnsResponse()
        {
            // Arrange
            var callCount = 0;
            var handlerMock = new Mock<HttpMessageHandler>();
            handlerMock.Protected()
                .Setup<Task<HttpResponseMessage>>("SendAsync", ItExpr.IsAny<HttpRequestMessage>(), ItExpr.IsAny<CancellationToken>())
                .Returns(() =>
                {
                    callCount++;
                    if (callCount < 3)
                        return Task.FromResult(new HttpResponseMessage(HttpStatusCode.Forbidden)); // 403 to retry
                    return Task.FromResult(new HttpResponseMessage(HttpStatusCode.OK) { Content = new StringContent("Success") });
                });

            var services = new ServiceCollection();
            services.AddTransient<HttpClient>((sp) => new HttpClient(handlerMock.Object));
            services.AddSingleton(new IsmpClientConfig { BaseUrlTobacco = "https://test.com", BaseUrlOther = "https://test.com", HttpTimeoutInSeconds = 5 });
            services.AddLogging();
            var sp = services.BuildServiceProvider();

            var request = IsmpRequest.Create(sp)
                .SetRequestUrl("test")
                .Build();

            // Act
            var result = await request.SendAsync();

            // Assert
            Assert.AreEqual(200, result.StatusCode);
            Assert.AreEqual("Success", result.Body);
            handlerMock.Protected().Verify("SendAsync", Times.Exactly(3), ItExpr.IsAny<HttpRequestMessage>(), ItExpr.IsAny<CancellationToken>());
        }

        /// <summary>
        /// Проверяет, что параметры запроса корректно добавляются к URI запроса.
        /// </summary>
        [TestMethod]
        public async Task SendAsync_WithQueryParams_BuildsCorrectUri()
        {
            // Arrange
            var handlerMock = new Mock<HttpMessageHandler>();
            handlerMock.Protected()
                .Setup<Task<HttpResponseMessage>>("SendAsync", ItExpr.IsAny<HttpRequestMessage>(), ItExpr.IsAny<CancellationToken>())
                .ReturnsAsync(new HttpResponseMessage(HttpStatusCode.OK) { Content = new StringContent("OK") });

            var services = new ServiceCollection();
            services.AddTransient<HttpClient>((sp) => new HttpClient(handlerMock.Object));
            services.AddSingleton(new IsmpClientConfig { BaseUrlTobacco = "https://test.com", BaseUrlOther = "https://test.com", HttpTimeoutInSeconds = 5 });
            services.AddLogging();
            var sp = services.BuildServiceProvider();

            var request = IsmpRequest.Create(sp)
                .SetRequestUrl("test")
                .AddQueryParam("key", "value")
                .Build();

            // Act
            await request.SendAsync();

            // Assert
            handlerMock.Protected().Verify("SendAsync", Times.Once(),
                ItExpr.Is<HttpRequestMessage>(req => req.RequestUri.ToString() == "https://test.com/test?key=value"),
                ItExpr.IsAny<CancellationToken>());
        }
    }
}