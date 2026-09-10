using System;
using System.Configuration;
using Chocodelight_Website.DataAccess;
using Chocodelight_Website.Helpers;
using Chocodelight_Website.Services;

namespace Chocodelight_Website
{
    public partial class ContactPage : BasePage
    {
        protected void btnSend_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            string name = txtName.Text.Trim();
            string email = txtEmail.Text.Trim();
            string phone = string.IsNullOrWhiteSpace(txtPhone.Text) ? null : txtPhone.Text.Trim();
            string subject = string.IsNullOrWhiteSpace(txtSubject.Text) ? null : txtSubject.Text.Trim();
            string message = txtMessage.Text.Trim();

            try
            {
                ContactRepository.Insert(name, email, phone, subject, message);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Trace.TraceError("Contact insert failed: " + ex);
            }

            string recipient = ConfigurationManager.AppSettings["ContactRecipient"];
            if (!string.IsNullOrEmpty(recipient))
            {
                EmailService.Send(recipient,
                    "رسالة اتصال جديدة" + (subject != null ? " — " + subject : ""),
                    EmailService.ContactNotificationBody(name, email, phone, message));
            }

            pnlForm.Visible = false;
            pnlDone.Visible = true;
        }
    }
}
