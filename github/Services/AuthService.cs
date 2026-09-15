using System;
using System.Web;
using System.Web.Security;
using Chocodelight_Website.Helpers;

namespace Chocodelight_Website.Services
{
    /// <summary>Issues and clears the forms-auth ticket for both customers and admins.</summary>
    public static class AuthService
    {
        public const string AdminRole = "Admin";
        public const string CustomerRole = "Customer";

        private static void IssueTicket(string name, string role, bool persistent, int minutes)
        {
            var ticket = new FormsAuthenticationTicket(
                version: 1,
                name: name,
                issueDate: DateTime.Now,
                expiration: DateTime.Now.AddMinutes(minutes),
                isPersistent: persistent,
                userData: role,
                cookiePath: FormsAuthentication.FormsCookiePath);

            string encrypted = FormsAuthentication.Encrypt(ticket);
            var cookie = new HttpCookie(FormsAuthentication.FormsCookieName, encrypted)
            {
                HttpOnly = true,
                Secure = FormsAuthentication.RequireSSL,
                Path = FormsAuthentication.FormsCookiePath
            };
            if (persistent) cookie.Expires = ticket.Expiration;
            HttpContext.Current.Response.Cookies.Add(cookie);
        }

        public static void SignInCustomer(int customerId, string displayName, bool remember)
        {
            // Ticket name = customer id; a claim-style prefix keeps it unambiguous.
            IssueTicket("c:" + customerId, CustomerRole, remember, remember ? 7 * 24 * 60 : 24 * 60);
            SetDisplayName(displayName, remember);
        }

        public static void SignInAdmin(int adminId, string displayName)
        {
            IssueTicket("a:" + adminId, AdminRole, false, 8 * 60);
            SetDisplayName(displayName, false);
        }

        private const string NameCookie = "cd_name";

        private static void SetDisplayName(string displayName, bool persistent)
        {
            HttpContext.Current.Items["cd_displayName"] = displayName;
            var cookie = new HttpCookie(NameCookie, HttpUtility.UrlEncode(displayName ?? ""))
            {
                HttpOnly = true,
                Path = "/"
            };
            if (persistent) cookie.Expires = DateTime.Now.AddDays(7);
            HttpContext.Current.Response.Cookies.Add(cookie);
        }

        public static string DisplayName
        {
            get
            {
                var ctx = HttpContext.Current;
                if (ctx == null) return null;
                if (ctx.Items["cd_displayName"] is string s && !string.IsNullOrEmpty(s)) return s;
                var cookie = ctx.Request.Cookies[NameCookie];
                return cookie != null ? HttpUtility.UrlDecode(cookie.Value) : null;
            }
        }

        public static void SignOut()
        {
            FormsAuthentication.SignOut();
            var expired = new HttpCookie(NameCookie, "") { Expires = DateTime.Now.AddDays(-1), Path = "/" };
            HttpContext.Current.Response.Cookies.Add(expired);
            HttpContext.Current.Session?.Clear();
        }

        private static string RawName
        {
            get
            {
                var u = HttpContext.Current?.User;
                return u != null && u.Identity.IsAuthenticated ? u.Identity.Name : null;
            }
        }

        public static bool IsAuthenticated { get { return RawName != null; } }

        public static bool IsAdmin
        {
            get
            {
                var u = HttpContext.Current?.User;
                return u != null && u.IsInRole(AdminRole);
            }
        }

        public static bool IsCustomer
        {
            get
            {
                var u = HttpContext.Current?.User;
                return u != null && u.IsInRole(CustomerRole);
            }
        }

        /// <summary>The signed-in customer id, or null when the visitor is a guest / admin.</summary>
        public static int? CurrentCustomerId
        {
            get
            {
                var name = RawName;
                if (name != null && name.StartsWith("c:") && int.TryParse(name.Substring(2), out int id))
                    return id;
                return null;
            }
        }

        public static int? CurrentAdminId
        {
            get
            {
                var name = RawName;
                if (name != null && name.StartsWith("a:") && int.TryParse(name.Substring(2), out int id))
                    return id;
                return null;
            }
        }
    }
}
