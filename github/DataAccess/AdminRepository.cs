using System;
using System.Data;
using Chocodelight_Website.Models;

namespace Chocodelight_Website.DataAccess
{
    public static class AdminRepository
    {
        private static AdminUser Map(DataRow r)
        {
            return new AdminUser
            {
                Id = r.Int("Id"),
                Username = r.Str("Username"),
                PasswordHash = r.Str("PasswordHash"),
                FullName = r.Str("FullName"),
                Email = r.Str("Email"),
                Role = r.Str("Role"),
                IsActive = r.Bool("IsActive"),
                FailedLoginCount = r.Int("FailedLoginCount"),
                LockoutEndUtc = r.DateN("LockoutEndUtc"),
                LastLoginAt = r.DateN("LastLoginAt")
            };
        }

        public static AdminUser GetByUsername(string username)
        {
            var dt = Db.GetTable("dbo.sp_AdminUser_GetByUsername", Db.P("@Username", username));
            return dt.Rows.Count == 0 ? null : Map(dt.Rows[0]);
        }

        public static void RecordLoginResult(int adminId, bool success)
        {
            Db.Execute("dbo.sp_AdminUser_RecordLoginResult",
                Db.P("@Id", adminId), Db.P("@Success", success));
        }
    }
}
