using System;
using System.Configuration;
using System.Data;
using Chocodelight_Website.DataAccess;

namespace Chocodelight_Website.Services
{
    /// <summary>
    /// One-time bootstrap run at application start: makes sure a default
    /// admin account exists so the back-office is reachable on a fresh DB.
    /// Catalogue/zone seed data lives in Database/03_SeedData.sql.
    /// </summary>
    public static class DbSeeder
    {
        public static void EnsureSeedData()
        {
            EnsureDefaultAdmin();
        }

        private static void EnsureDefaultAdmin()
        {
            try
            {
                var countObj = Db.GetScalar("dbo.sp_AdminUser_Count");
                int count = countObj == null || countObj == DBNull.Value ? 0 : Convert.ToInt32(countObj);
                if (count > 0) return;

                string username = ConfigurationManager.AppSettings["DefaultAdminUsername"] ?? "admin";
                string password = ConfigurationManager.AppSettings["DefaultAdminPassword"] ?? "ChangeMe@123";
                string fullName = ConfigurationManager.AppSettings["DefaultAdminFullName"] ?? "Store Administrator";

                Db.GetScalar("dbo.sp_AdminUser_Insert",
                    Db.P("@Username", username),
                    Db.P("@PasswordHash", PasswordHasher.Hash(password)),
                    Db.P("@FullName", fullName),
                    Db.P("@Email", DBNull.Value),
                    Db.P("@Role", "Admin"));

                System.Diagnostics.Trace.TraceInformation(
                    "DbSeeder: created default admin '{0}'.", username);
            }
            catch (Exception ex)
            {
                // Never take the app down over seeding; log and continue.
                System.Diagnostics.Trace.TraceError("DbSeeder failed: " + ex);
            }
        }
    }
}
