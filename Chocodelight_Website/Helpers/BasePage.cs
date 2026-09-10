using System;
using System.Web.UI;

namespace Chocodelight_Website.Helpers
{
    /// <summary>Shared helpers for public-facing pages.</summary>
    public class BasePage : Page
    {
        protected override void OnInit(EventArgs e)
        {
            base.OnInit(e);
            // Ties the ViewState MAC to the session, mitigating one-click / CSRF replay.
            if (Session != null)
                ViewStateUserKey = Session.SessionID;
        }

        /// <summary>Inline localization for literal strings in markup.</summary>
        public string T(string ar, string en)
        {
            return CultureHelper.IsArabic ? ar : en;
        }

        public bool IsArabic { get { return CultureHelper.IsArabic; } }

        public string Money(decimal amount) { return CultureHelper.Money(amount); }
    }
}
