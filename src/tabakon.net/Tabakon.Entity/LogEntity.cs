using System;

namespace Tabakon.Entity {
    public class LogEntity { 
        public DateTime Timestamp { get; set; }
        public string Siverity { get; set; }
        public string Source { get; set; }
        public string Event { get; set; }
        public string Message { get; set; }
    }
}
