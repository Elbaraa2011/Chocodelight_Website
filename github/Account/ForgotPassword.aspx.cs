using System;
using System.Configuration;
using System.Web;
using Chocodelight_Website.DataAccess;
using Chocodelight_Website.Helpers;
using Chocodelight_Website.Services;

namespace Chocodelight_Website.Account
{
    public partial class ForgotPasswordPage : BasePage
    {
        private string Token { get { return Request.QueryString["token"]; } }

        protected void Page_Load(object sender, EventArgs e)
        {
            bool resetMode = !string.IsNullOrEmpty(Token);
            pnlRequest.Visible = !resetMode;
            pnlReset.Visible = resetMode;

            if (resetMode && !IsPostBack)
            {
                var customer = CustomerRepository.GetByResetToken(Token);
                if (customer == null)
                {
                    pnlResetInvalid.Visible = true;
                    pnlResetForm.Visible = false;
                }
            }
        }

        protected void btnRequest_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            string email = txtEmail.Text.Trim().ToLowerInvariant();
            int hours;
            if (!int.TryParse(ConfigurationManager.AppSettings["PasswordResetTokenHours"], out hours) || hours <= 0)
                hours = 2;

            string token = Guid.NewGuid().ToString("N") + Guid.NewGuid().ToString("N");
            bool exists = CustomerRepository.SetResetToken(email, token, DateTime.UtcNow.AddHours(hours));

            // Always show the same message regardless of whether the email exists.
            pnlRequestForm.Visible = false;
            pnlRequestDone.Visible = true;

            if (exists)
            {
                string resetUrl = new Uri(Request.Url, ResolveUrl("~/Account/ForgotPassword.aspx?token=" + token)).AbsoluteUri;
                var customer = CustomerRepository.GetByEmail(email);
                string name = customer != null ? customer.FullName : "";

                bool sent = EmailService.Send(email, "إعادة تعيين كلمة السر — Choco Delight",
                    EmailService.PasswordResetBody(name, resetUrl));

                // Local convenience: if mail isn't really delivered, surface the link.
                if (HttpContext.Current.IsDebuggingEnabled)
                {
                    pnlRequestForm.Visible = true;
                    pnlDevLink.Visible = true;
                    lnkDev.NavigateUrl = resetUrl;
                    lnkDev.Text = resetUrl;
                }
            }
        }

        protected void btnReset_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            var customer = CustomerRepository.GetByResetToken(Token);
            if (customer == null)
            {
                pnlResetInvalid.Visible = true;
                pnlResetForm.Visible = false;
                return;
            }

            if (txtNewPassword.Text.Length < 8) return;

            CustomerRepository.UpdatePassword(customer.Id, PasswordHasher.Hash(txtNewPassword.Text));

            pnlResetForm.Visible = false;
            pnlResetDone.Visible = true;
        }
    }
}
