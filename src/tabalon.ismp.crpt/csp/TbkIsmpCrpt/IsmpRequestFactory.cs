using Microsoft.Extensions.DependencyInjection;
using System;
using TbkIsmpCrpt.Contracts;

namespace TbkIsmpCrpt
{
    public class IsmpRequestFactory : IIsmpRequestFactory
    {
        private readonly IServiceProvider _serviceProvider;
        private readonly IsmpClientConfig _config;
        
        public IsmpRequestFactory(IServiceProvider serviceProvider, IsmpClientConfig config)
        {
            _serviceProvider = serviceProvider;
            _config = config;
        }
        
        public IIsmRequestBuilder Create()
        {
            return new IsmpRequest(_serviceProvider, _config);
        }
    }
}