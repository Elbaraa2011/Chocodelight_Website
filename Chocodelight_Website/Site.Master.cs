using System;
using System.Web;
using System.Web.UI;
using Chocodelight_Website.Helpers;
using Chocodelight_Website.Services;

namespace Chocodelight_Website
{
    public partial class SiteMaster : MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            HandleLanguageSwitch();
            RenderCartCount();
        }

        /// <summary>Reads ?setlang=xx, stores the choice, and redirects to a clean URL.</summary>
        private void HandleLanguageSwitch()
        {
            string lang = Request.QueryString["setlang"];
            if (string.IsNullOrEmpty(lang)) return;

            CultureHelper.SetLanguage(lang);

            string back = Request.QueryString["return"];
            if (string.IsNullOrEmpty(back) || !back.StartsWith("/") || back.StartsWith("//"))
                back = Request.Url.AbsolutePath;
            Response.Redirect(back, false);
            Context.ApplicationInstance.CompleteRequest();
        }

        private void RenderCartCount()
        {
            int count = CartManager.Count;
            litCartCount.Text = count > 0
                ? "<span class=\"cart-count\">" + count + "</span>"
                : string.Empty;
        }

        /// <summary>Inline localization helper for static chrome text.</summary>
        protected string T(string ar, string en)
        {
            return CultureHelper.IsArabic ? ar : en;
        }

        protected string LangSwitchUrl(string lang)
        {
            return Request.Url.AbsolutePath
                   + "?setlang=" + lang
                   + "&return=" + HttpUtility.UrlEncode(Request.Url.PathAndQuery);
        }

        protected string AccountUrl()
        {
            return ResolveUrl(AuthService.CurrentCustomerId.HasValue
                ? "~/Account/MyAccount.aspx"
                : "~/Account/Login.aspx");
        }
    }
}
