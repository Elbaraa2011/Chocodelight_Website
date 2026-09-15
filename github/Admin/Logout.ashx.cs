using System.Web;
using Chocodelight_Website.Services;

namespace Chocodelight_Website.Admin
{
    public class AdminLogout : IHttpHandler
    {
        public bool IsReusable { get { return false; } }

        public void ProcessRequest(HttpContext context)
        {
            AuthService.SignOut();
            context.Response.Redirect("~/Admin/Login.aspx");
        }
    }
}
