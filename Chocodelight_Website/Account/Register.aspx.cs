using System;
using System.Web;
using Chocodelight_Website.DataAccess;
using Chocodelight_Website.Helpers;
using Chocodelight_Website.Services;

namespace Chocodelight_Website.Account
{
    public partial class RegisterPage : BasePage
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
                Response.Redirect("~/Account/MyAccount.aspx");
        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            string name = txtName.Text.Trim();
            string email = txtEmail.Text.Trim().ToLowerInvariant();
            string phone = txtPhone.Text.Trim();
            string password = txtPassword.Text;

            if (password.Length < 8)
            {
                ShowError(T("كلمة السر لازم تكون 8 أحرف على الأقل.", "Password must be at least 8 characters."));
                return;
            }

            int newId = CustomerRepository.Insert(name, email, PasswordHasher.Hash(password), phone);
            if (newId == -1)
            {
                ShowError(T("البريد الإلكتروني ده مسجّل بالفعل. جرّب تسجّل دخول.",
                            "That email is already registered. Try signing in."));
                return;
            }

            AuthService.SignInCustomer(newId, name, remember: false);
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
