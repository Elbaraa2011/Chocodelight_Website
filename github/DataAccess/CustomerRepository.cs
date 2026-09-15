using System;
using System.Data;
using Chocodelight_Website.Models;

namespace Chocodelight_Website.DataAccess
{
    public static class CustomerRepository
    {
        private static Customer Map(DataRow r)
        {
            return new Customer
            {
                Id = r.Int("Id"),
                FullName = r.Str("FullName"),
                Email = r.Str("Email"),
                PasswordHash = r.Str("PasswordHash"),
                Phone = r.Str("Phone"),
                IsActive = r.Table.Columns.Contains("IsActive") ? r.Bool("IsActive") : true,
                FailedLoginCount = r.Int("FailedLoginCount"),
                LockoutEndUtc = r.DateN("LockoutEndUtc"),
                CreatedAt = r.Date("CreatedAt"),
                LastLoginAt = r.DateN("LastLoginAt")
            };
        }

        public static Customer GetByEmail(string email)
        {
            var dt = Db.GetTable("dbo.sp_Customer_GetByEmail", Db.P("@Email", email));
            return dt.Rows.Count == 0 ? null : Map(dt.Rows[0]);
        }

        public static Customer GetById(int id)
        {
            var dt = Db.GetTable("dbo.sp_Customer_GetById", Db.P("@Id", id));
            return dt.Rows.Count == 0 ? null : Map(dt.Rows[0]);
        }

        /// <summary>Returns the new customer id, or -1 if the email is already registered.</summary>
        public static int Insert(string fullName, string email, string passwordHash, string phone)
        {
            try
            {
                var result = Db.GetScalar("dbo.sp_Customer_Insert",
                    Db.P("@FullName", fullName), Db.P("@Email", email),
                    Db.P("@PasswordHash", passwordHash), Db.P("@Phone", (object)phone ?? DBNull.Value));
                return Convert.ToInt32(result);
            }
            catch (System.Data.SqlClient.SqlException ex) when (ex.Message.Contains("EMAIL_EXISTS"))
            {
                return -1;
            }
        }

        public static void UpdateProfile(int id, string fullName, string phone)
        {
            Db.Execute("dbo.sp_Customer_UpdateProfile",
                Db.P("@Id", id), Db.P("@FullName", fullName), Db.P("@Phone", (object)phone ?? DBNull.Value));
        }

        public static void UpdatePassword(int id, string passwordHash)
        {
            Db.Execute("dbo.sp_Customer_UpdatePassword", Db.P("@Id", id), Db.P("@PasswordHash", passwordHash));
        }

        public static void RecordLoginResult(int id, bool success)
        {
            Db.Execute("dbo.sp_Customer_RecordLoginResult", Db.P("@Id", id), Db.P("@Success", success));
        }

        public static bool SetResetToken(string email, string token, DateTime expiryUtc)
        {
            var result = Db.GetScalar("dbo.sp_Customer_SetResetToken",
                Db.P("@Email", email), Db.P("@Token", token), Db.P("@ExpiryUtc", expiryUtc));
            return result != null && result != DBNull.Value && Convert.ToInt32(result) > 0;
        }

        public static Customer GetByResetToken(string token)
        {
            var dt = Db.GetTable("dbo.sp_Customer_GetByResetToken", Db.P("@Token", token));
            if (dt.Rows.Count == 0) return null;
            var r = dt.Rows[0];
            return new Customer
            {
                Id = r.Int("Id"),
                FullName = r.Str("FullName"),
                Email = r.Str("Email")
            };
        }
    }
}
