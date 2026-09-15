using System;
using System.Web;

namespace Chocodelight_Website.Helpers
{
    /// <summary>
    /// Tracks the visitor's UI language (Arabic default) via a cookie.
    /// Content is stored bilingually in the DB; models expose localized
    /// properties that read <see cref="IsArabic"/>.
    /// </summary>
    public static class CultureHelper
    {
        public const string CookieName = "cd_lang";
        public const string Arabic = "ar";
        public const string English = "en";

        public static string CurrentLanguage
        {
            get
            {
                var ctx = HttpContext.Current;
                if (ctx == null) return Arabic;

                // Cached per request
                if (ctx.Items["cd_lang"] is string cached) return cached;

                string lang = Arabic;
                var cookie = ctx.Request.Cookies[CookieName];
                if (cookie != null && string.Equals(cookie.Value, English, StringComparison.OrdinalIgnoreCase))
                    lang = English;

                ctx.Items["cd_lang"] = lang;
                return lang;
            }
        }

        public static bool IsArabic { get { return CurrentLanguage == Arabic; } }
        public static bool IsEnglish { get { return CurrentLanguage == English; } }

        public static string Dir { get { return IsArabic ? "rtl" : "ltr"; } }
        public static string HtmlLang { get { return IsArabic ? "ar" : "en"; } }

        public static void SetLanguage(string lang)
        {
            var ctx = HttpContext.Current;
            if (ctx == null) return;

            lang = string.Equals(lang, English, StringComparison.OrdinalIgnoreCase) ? English : Arabic;
            var cookie = new HttpCookie(CookieName, lang)
            {
                Expires = DateTime.UtcNow.AddYears(1),
                HttpOnly = true,
                Path = "/"
            };
            ctx.Response.Cookies.Add(cookie);
            ctx.Items["cd_lang"] = lang;
        }

        /// <summary>
        /// App-relative URL with a cache-busting <c>?v=</c> stamp from the file's last write time,
        /// so CSS/JS changes are picked up without a manual hard-refresh.
        /// </summary>
        public static string Asset(System.Web.UI.Control control, string appRelativePath)
        {
            string url = control.ResolveUrl(appRelativePath);
            try
            {
                string physical = HttpContext.Current.Server.MapPath(appRelativePath);
                if (System.IO.File.Exists(physical))
                {
                    long v = System.IO.File.GetLastWriteTimeUtc(physical).Ticks;
                    url += (url.Contains("?") ? "&" : "?") + "v=" + v;
                }
            }
            catch { /* fall back to the plain URL */ }
            return url;
        }

        /// <summary>Formats a money amount with the localized currency label.</summary>
        public static string Money(decimal amount)
        {
            // No fractional piastres in the catalogue; show whole pounds.
            string n = Math.Round(amount, 0).ToString("#,0");
            return IsArabic ? (n + " جنيه") : ("EGP " + n);
        }
    }
}
