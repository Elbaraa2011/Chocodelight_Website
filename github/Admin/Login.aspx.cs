using System;
using System.Web.UI;
using Chocodelight_Website.DataAccess;
using Chocodelight_Website.Services;

namespace Chocodelight_Website.Admin
{
    public partial class AdminLoginPage : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (AuthService.IsAdmin && !IsPostBack)
                RedirectIn();
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            string username = txtUsername.Text.Trim();
            var admin = AdminRepository.GetByUsername(username);

            string generic = "اسم المستخدم أو كلمة السر غير صحيحة.";

            if (admin == null)
            {
                ShowError(generic);
                return;
            }
            if (admin.IsLockedOut)
            {
                ShowError("الحساب مقفول مؤقتًا بسبب محاولات كتير. حاول تاني بعد شوية.");
                return;
            }
            if (!admin.IsActive)
            {
                ShowError("هذا الحساب موقوف.");
                return;
            }

            bool ok = PasswordHasher.Verify(txtPassword.Text, admin.PasswordHash);
            AdminRepository.RecordLoginResult(admin.Id, ok);

            if (!ok)
            {
                ShowError(generic);
                return;
            }

            AuthService.SignInAdmin(admin.Id, admin.FullName);
            RedirectIn();
        }

        private void RedirectIn()
        {
            string back = Request.QueryString["return"];
            if (!string.IsNullOrEmpty(back) && back.StartsWith("/Admin", StringComparison.OrdinalIgnoreCase) && !back.StartsWith("//"))
                Response.Redirect(back);
            Response.Redirect("~/Admin/Default.aspx");
        }

        private void ShowError(string msg)
        {
            pnlError.Visible = true;
            litError.Text = Server.HtmlEncode(msg);
        }
    }
}
