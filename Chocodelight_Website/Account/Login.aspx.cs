using System;
using System.Web;
using Chocodelight_Website.DataAccess;
using Chocodelight_Website.Helpers;
using Chocodelight_Website.Services;

namespace Chocodelight_Website.Account
{
    public partial class LoginPage : BasePage
    {
        public string ReturnQuery
        {
            get
            {
                string r = Request.QueryString["return"];
                return string.IsNullOrEmpty(r) ? "" : "?return=" + HttpUtility.UrlEncode(r);
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (AuthService.CurrentCustomerId.HasValue && !IsPostBack)
                RedirectAfterAuth();
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            string email = txtEmail.Text.Trim().ToLowerInvariant();
            string password = txtPassword.Text;

            var customer = CustomerRepository.GetByEmail(email);

            // Uniform failure message; never reveal which part was wrong.
            string genericError = T("البريد الإلكتروني أو كلمة السر غير صحيحة.",
                                    "Incorrect email or password.");

            if (customer == null)
            {
                ShowError(genericError);
                return;
            }

            if (customer.IsLockedOut)
            {
                ShowError(T("الحساب مقفول مؤقتًا بسبب محاولات كتير. جرّب تاني بعد شوية.",
                            "Account is temporarily locked after too many attempts. Try again shortly."));
                return;
            }

            if (!customer.IsActive)
            {
                ShowError(T("الحساب ده موقوف. تواصل معانا.", "This account is disabled. Please contact us."));
                return;
            }

            bool ok = PasswordHasher.Verify(password, customer.PasswordHash);
            CustomerRepository.RecordLoginResult(customer.Id, ok);

            if (!ok)
            {
                ShowError(genericError);
                return;
            }

            AuthService.SignInCustomer(customer.Id, customer.FullName, chkRemember.Checked);
            RedirectAfterAuth();
        }

        private void ShowError(string message)
        {
            pnlError.Visible = true;
            litError.Text = Server.HtmlEncode(message);
        }

        private void RedirectAfterAuth()
        {
            string back = Request.QueryString["return"];
            if (!string.IsNullOrEmpty(back) && back.StartsWith("/") && !back.StartsWith("//"))
                Response.Redirect(back);
            Response.Redirect("~/Account/MyAccount.aspx");
        }
    }
}
