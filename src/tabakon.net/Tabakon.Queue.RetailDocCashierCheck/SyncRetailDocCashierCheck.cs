using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Net;
using System.Threading.Channels;
using Tabakon.Entity;

namespace Tabakon.Queue.RetailDocCashierCheck {

    public class SyncRetailDocCashierCheck {
        public RetailEndpoint RetailEndpoint { get; set; }
        public DateTime Date { get; set; }
    }
}
