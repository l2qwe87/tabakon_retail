﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using RetailClient.Web.Contracts;
using Tabakon.DAL;
using Tabakon.Entity;

namespace RetailClient.Web.Controllers {
    [ApiController]
    [Route("api/[controller]")]
    public class RetailEndpointVersionController : ControllerBase {
        private readonly IRetailEndpointsRepo retailEndpointsRepo;

        public RetailEndpointVersionController(IRetailEndpointsRepo retailEndpointsRepo) {
            this.retailEndpointsRepo = retailEndpointsRepo;
        }
        [HttpGet]
        public async Task<IEnumerable<RetailVersion>> Get() {
            var versions = retailEndpointsRepo.GetRetailEndpointsVersion();

            return await versions.AsNoTracking().ToListAsync();
        }
    }
}
