using System;
using System.Web;
using System.Web.UI;
using Chocodelight_Website.Services;

namespace Chocodelight_Website.Helpers
{
    /// <summary>Base for every back-office page: enforces an authenticated Admin-role session.</summary>
    public class BaseAdminPage : Page
    {
        protected override void OnInit(EventArgs e)
        {
            base.OnInit(e);

            if (Session != null)
                ViewStateUserKey = Session.SessionID;

            if (!AuthService.IsAdmin)
            {
                string ret = HttpUtility.UrlEncode(Request.Url.PathAndQuery);
                Response.Redirect("~/Admin/Login.aspx?return=" + ret, true);
            }
        }

        public int CurrentAdminId
        {
            get { return AuthService.CurrentAdminId ?? 0; }
        }

        /// <summary>Inline localization for literal strings in markup (Arabic-first back office).</summary>
        public string T(string ar, string en)
        {
            return CultureHelper.IsArabic ? ar : en;
        }

        public string Money(decimal amount) { return CultureHelper.Money(amount); }
    }
}
