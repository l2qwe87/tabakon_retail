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
        [TestInitialize]
        public void Setup()
        {
            var services = new ServiceCollection();
            services.AddSingleton(new IsmpClientConfig { BaseUrlTobacco = "https://test.com", BaseUrlOther = "https://test.com", HttpTimeoutInSeconds = 5, RetryCount = 10, RetryDelayMs = 100 });
            services.AddLogging();
        }

        /// <summary>
        /// Проверяет базовый функционал отправки запроса.
        /// </summary>
        [TestMethod]
        public async Task SendAsync_SuccessfulRequest_ReturnsResponse()
        {
            // Arrange
            var handlerMock = new Mock<HttpMessageHandler>();
            handlerMock.Protected()
                .Setup<Task<HttpResponseMessage>>("SendAsync", ItExpr.IsAny<HttpRequestMessage>(), ItExpr.IsAny<CancellationToken>())
                .ReturnsAsync(new HttpResponseMessage(HttpStatusCode.OK) { Content = new StringContent("{\"test\":\"data\"}") });

            var httpClient = new HttpClient(handlerMock.Object);
            var httpClientFactoryMock = new Mock<IHttpClientFactory>();
            httpClientFactoryMock.Setup(x => x.CreateClient(It.IsAny<string>())).Returns(httpClient);

            var services = new ServiceCollection();
            services.AddSingleton(httpClientFactoryMock.Object);
            services.AddSingleton(new IsmpClientConfig { BaseUrlTobacco = "https://test.com", BaseUrlOther = "https://test.com", HttpTimeoutInSeconds = 5, RetryCount = 10, RetryDelayMs = 100 });
            services.AddLogging();
            var sp = services.BuildServiceProvider();

            var config = sp.GetRequiredService<IsmpClientConfig>();
            var request = IsmpRequest.Create(sp, config)
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

            var httpClient = new HttpClient(handlerMock.Object);
            var httpClientFactoryMock = new Mock<IHttpClientFactory>();
            httpClientFactoryMock.Setup(x => x.CreateClient(It.IsAny<string>())).Returns(httpClient);

            var services = new ServiceCollection();
            services.AddSingleton(httpClientFactoryMock.Object);
            services.AddSingleton(new IsmpClientConfig { BaseUrlTobacco = "https://test.com", BaseUrlOther = "https://test.com", HttpTimeoutInSeconds = 5, RetryCount = 10, RetryDelayMs = 100 });
            services.AddLogging();
            var sp = services.BuildServiceProvider();

            var config = sp.GetRequiredService<IsmpClientConfig>();
            var request = IsmpRequest.Create(sp, config)
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
            var callCount = 0;
            handlerMock.Protected()
                .Setup<Task<HttpResponseMessage>>("SendAsync", ItExpr.IsAny<HttpRequestMessage>(), ItExpr.IsAny<CancellationToken>())
                .Returns(() =>
                {
                    callCount++;
                    return Task.FromResult(new HttpResponseMessage(HttpStatusCode.Forbidden));
                });

            var httpClient = new HttpClient(handlerMock.Object);
            var httpClientFactoryMock = new Mock<IHttpClientFactory>();
            httpClientFactoryMock.Setup(x => x.CreateClient(It.IsAny<string>())).Returns(httpClient);

            var services = new ServiceCollection();
            services.AddSingleton(httpClientFactoryMock.Object);
            services.AddSingleton(new IsmpClientConfig { BaseUrlTobacco = "https://test.com", BaseUrlOther = "https://test.com", HttpTimeoutInSeconds = 5, RetryCount = 10, RetryDelayMs = 100 });
            services.AddLogging();
            var sp = services.BuildServiceProvider();

            var config = sp.GetRequiredService<IsmpClientConfig>();
            var request = IsmpRequest.Create(sp, config)
                .SetRequestUrl("test")
                .Build();

            // Act
            var result = await request.SendAsync();

            // Assert
            Assert.AreEqual(403, result.StatusCode);
            Assert.AreEqual(20, callCount); // 10 retries for each of 2 URLs
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

            var httpClient = new HttpClient(handlerMock.Object);
            var httpClientFactoryMock = new Mock<IHttpClientFactory>();
            httpClientFactoryMock.Setup(x => x.CreateClient(It.IsAny<string>())).Returns(httpClient);

            var services = new ServiceCollection();
            services.AddSingleton(httpClientFactoryMock.Object);
            services.AddSingleton(new IsmpClientConfig { BaseUrlTobacco = "https://test.com", BaseUrlOther = "https://test.com", HttpTimeoutInSeconds = 5, RetryCount = 10, RetryDelayMs = 100 });
            services.AddLogging();
            var sp = services.BuildServiceProvider();

            var config = sp.GetRequiredService<IsmpClientConfig>();
            var request = IsmpRequest.Create(sp, config)
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

        /// <summary>
        /// Проверяет, что специальные символы в query параметрах корректно кодируются.
        /// </summary>
        [TestMethod]
        public async Task SendAsync_WithSpecialCharsInQueryParams_EncodesCorrectly()
        {
            // Arrange
            var handlerMock = new Mock<HttpMessageHandler>();
            handlerMock.Protected()
                .Setup<Task<HttpResponseMessage>>("SendAsync", ItExpr.IsAny<HttpRequestMessage>(), ItExpr.IsAny<CancellationToken>())
                .ReturnsAsync(new HttpResponseMessage(HttpStatusCode.OK) { Content = new StringContent("OK") });

            var httpClient = new HttpClient(handlerMock.Object);
            var httpClientFactoryMock = new Mock<IHttpClientFactory>();
            httpClientFactoryMock.Setup(x => x.CreateClient(It.IsAny<string>())).Returns(httpClient);

            var services = new ServiceCollection();
            services.AddSingleton(httpClientFactoryMock.Object);
            services.AddSingleton(new IsmpClientConfig { 
                BaseUrlTobacco = "https://test.com", 
                BaseUrlOther = "https://test.com", 
                HttpTimeoutInSeconds = 5, 
                RetryCount = 10, 
                RetryDelayMs = 100 
            });
            services.AddLogging();
            var sp = services.BuildServiceProvider();

            var config = sp.GetRequiredService<IsmpClientConfig>();
            var request = IsmpRequest.Create(sp, config)
                .SetRequestUrl("test")
                .AddQueryParam("search", "test+value&special=chars")
                .AddQueryParam("filter", "name=John&age=25")
                .Build();

            // Act
            await request.SendAsync();

            // Assert
            handlerMock.Protected().Verify("SendAsync", Times.Once(),
                ItExpr.Is<HttpRequestMessage>(req => 
                    req.RequestUri.ToString() == "https://test.com/test?search=test%2Bvalue%26special%3Dchars&filter=name%3DJohn%26age%3D25"),
                ItExpr.IsAny<CancellationToken>());
        }

        /// <summary>
        /// Проверяет, что кириллица в query параметрах корректно кодируется.
        /// </summary>
        [TestMethod]
        public async Task SendAsync_WithCyrillicInQueryParams_EncodesCorrectly()
        {
            // Arrange
            var handlerMock = new Mock<HttpMessageHandler>();
            handlerMock.Protected()
                .Setup<Task<HttpResponseMessage>>("SendAsync", ItExpr.IsAny<HttpRequestMessage>(), ItExpr.IsAny<CancellationToken>())
                .ReturnsAsync(new HttpResponseMessage(HttpStatusCode.OK) { Content = new StringContent("OK") });

            var httpClient = new HttpClient(handlerMock.Object);
            var httpClientFactoryMock = new Mock<IHttpClientFactory>();
            httpClientFactoryMock.Setup(x => x.CreateClient(It.IsAny<string>())).Returns(httpClient);

            var services = new ServiceCollection();
            services.AddSingleton(httpClientFactoryMock.Object);
            services.AddSingleton(new IsmpClientConfig { 
                BaseUrlTobacco = "https://test.com", 
                BaseUrlOther = "https://test.com", 
                HttpTimeoutInSeconds = 5, 
                RetryCount = 10, 
                RetryDelayMs = 100 
            });
            services.AddLogging();
            var sp = services.BuildServiceProvider();

            var config = sp.GetRequiredService<IsmpClientConfig>();
            var request = IsmpRequest.Create(sp, config)
                .SetRequestUrl("test")
                .AddQueryParam("название", "тестовое значение")
                .AddQueryParam("фильтр", "параметр=значение")
                .Build();

            // Act
            await request.SendAsync();

            // Assert
            handlerMock.Protected().Verify("SendAsync", Times.Once(),
                ItExpr.Is<HttpRequestMessage>(req => 
                    req.RequestUri.ToString() == "https://test.com/test?название=тестовое значение&фильтр=параметр%3Dзначение"),
                ItExpr.IsAny<CancellationToken>());
        }

        /// <summary>
        /// Проверяет, что количество ретраев можно настроить через конфигурацию.
        /// </summary>
        [TestMethod]
        public async Task SendAsync_CustomRetryCount_UsesConfiguredValue()
        {
            // Arrange
            var handlerMock = new Mock<HttpMessageHandler>();
            handlerMock.Protected()
                .Setup<Task<HttpResponseMessage>>("SendAsync", ItExpr.IsAny<HttpRequestMessage>(), ItExpr.IsAny<CancellationToken>())
                .ThrowsAsync(new TaskCanceledException("Timeout"));

            var httpClient = new HttpClient(handlerMock.Object);
            var httpClientFactoryMock = new Mock<IHttpClientFactory>();
            httpClientFactoryMock.Setup(x => x.CreateClient(It.IsAny<string>())).Returns(httpClient);

            var services = new ServiceCollection();
            services.AddSingleton(httpClientFactoryMock.Object);
            services.AddSingleton(new IsmpClientConfig { 
                BaseUrlTobacco = "https://test.com", 
                BaseUrlOther = "https://test.com", 
                HttpTimeoutInSeconds = 5, 
                RetryCount = 3, 
                RetryDelayMs = 50 
            });
            services.AddLogging();
            var sp = services.BuildServiceProvider();

            var config = sp.GetRequiredService<IsmpClientConfig>();
            var request = IsmpRequest.Create(sp, config)
                .SetRequestUrl("test")
                .Build();

            // Act & Assert
            await Assert.ThrowsExceptionAsync<TaskCanceledException>(() => request.SendAsync());
            handlerMock.Protected().Verify("SendAsync", Times.Exactly(3), ItExpr.IsAny<HttpRequestMessage>(), ItExpr.IsAny<CancellationToken>());
        }
    }
}