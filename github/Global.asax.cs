using System;
using System.Web;
using System.Web.Security;
using System.Security.Principal;
using Chocodelight_Website.Services;

namespace Chocodelight_Website
{
    public class Global : HttpApplication
    {
        protected void Application_Start(object sender, EventArgs e)
        {
            try
            {
                DbSeeder.EnsureSeedData();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Trace.TraceError("Application_Start seeding error: " + ex);
            }
        }

        /// <summary>
        /// Rebuilds the role list from the forms-auth ticket so
        /// <c>User.IsInRole("Admin")</c> and &lt;authorization&gt; work.
        /// </summary>
        protected void Application_PostAuthenticateRequest(object sender, EventArgs e)
        {
            var authCookie = Request.Cookies[FormsAuthentication.FormsCookieName];
            if (authCookie == null || string.IsNullOrEmpty(authCookie.Value)) return;

            try
            {
                var ticket = FormsAuthentication.Decrypt(authCookie.Value);
                if (ticket == null || ticket.Expired) return;

                string[] roles = string.IsNullOrEmpty(ticket.UserData)
                    ? new string[0]
                    : ticket.UserData.Split(',');

                var identity = new FormsIdentity(ticket);
                Context.User = new GenericPrincipal(identity, roles);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Trace.TraceError("PostAuthenticate error: " + ex);
            }
        }

        protected void Application_Error(object sender, EventArgs e)
        {
            var ex = Server.GetLastError();
            if (ex != null)
                System.Diagnostics.Trace.TraceError("Unhandled: " + ex);
        }
    }
}
