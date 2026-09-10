using System.Web;
using Chocodelight_Website.Services;

namespace Chocodelight_Website.Account
{
    public class Logout : IHttpHandler
    {
        public bool IsReusable { get { return false; } }

        public void ProcessRequest(HttpContext context)
        {
            AuthService.SignOut();
            context.Response.Redirect("~/Default.aspx");
        }
    }
}
