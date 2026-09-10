using System;

namespace Chocodelight_Website.Models
{
    public class AdminUser
    {
        public int Id { get; set; }
        public string Username { get; set; }
        public string PasswordHash { get; set; }
        public string FullName { get; set; }
        public string Email { get; set; }
        public string Role { get; set; }
        public bool IsActive { get; set; }
        public int FailedLoginCount { get; set; }
        public DateTime? LockoutEndUtc { get; set; }
        public DateTime? LastLoginAt { get; set; }

        public bool IsLockedOut
        {
            get { return LockoutEndUtc.HasValue && LockoutEndUtc.Value > DateTime.UtcNow; }
        }
    }
}
