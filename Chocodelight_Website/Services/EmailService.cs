using System;
using System.Configuration;
using System.Net.Mail;
using System.Web;

namespace Chocodelight_Website.Services
{
    /// <summary>
    /// Sends transactional email. Configuration comes from &lt;system.net&gt;&lt;mailSettings&gt;
    /// in Web.config. In development that is a SpecifiedPickupDirectory (App_Data/mail),
    /// so no real SMTP server is needed — the .eml files land on disk.
    /// </summary>
    public static class EmailService
    {
        private static string FromAddress
        {
            get { return ConfigurationManager.AppSettings["MailFrom"] ?? "no-reply@chocodelight.local"; }
        }

        private static string FromName
        {
            get { return ConfigurationManager.AppSettings["MailFromName"] ?? "Choco Delight"; }
        }

        public static bool Send(string toEmail, string subject, string htmlBody)
        {
            try
            {
                using (var msg = new MailMessage())
                {
                    msg.From = new MailAddress(FromAddress, FromName);
                    msg.To.Add(new MailAddress(toEmail));
                    msg.Subject = subject;
                    msg.Body = htmlBody;
                    msg.IsBodyHtml = true;

                    using (var client = new SmtpClient())
                    {
                        // Ensure the pickup directory exists when that's the delivery method.
                        if (client.DeliveryMethod == SmtpDeliveryMethod.SpecifiedPickupDirectory
                            && !string.IsNullOrEmpty(client.PickupDirectoryLocation))
                        {
                            string dir = client.PickupDirectoryLocation;
                            if (!System.IO.Path.IsPathRooted(dir))
                            {
                                string rel = dir.Replace("~/", "").Replace("/", "\\").TrimStart('\\');
                                dir = System.IO.Path.Combine(HttpRuntime.AppDomainAppPath, rel);
                            }
                            System.IO.Directory.CreateDirectory(dir);
                            client.PickupDirectoryLocation = dir;
                        }
                        client.Send(msg);
                    }
                }
                return true;
            }
            catch (Exception ex)
            {
                System.Diagnostics.Trace.TraceError("EmailService.Send failed: " + ex);
                return false;
            }
        }

        public static string PasswordResetBody(string name, string resetUrl)
        {
            return "<div style=\"font-family:Arial,sans-serif;direction:rtl;text-align:right\">"
                 + "<h2>إعادة تعيين كلمة السر</h2>"
                 + "<p>أهلاً " + HttpUtility.HtmlEncode(name) + "،</p>"
                 + "<p>وصلنا طلب لإعادة تعيين كلمة السر لحسابك في Choco Delight. اضغط الرابط ده خلال ساعتين:</p>"
                 + "<p><a href=\"" + HttpUtility.HtmlEncode(resetUrl) + "\">" + HttpUtility.HtmlEncode(resetUrl) + "</a></p>"
                 + "<p>لو مش إنت اللي طلبت، تجاهل الرسالة دي.</p>"
                 + "</div>";
        }

        public static string ContactNotificationBody(string name, string email, string phone, string message)
        {
            return "<div style=\"font-family:Arial,sans-serif;direction:rtl;text-align:right\">"
                 + "<h2>رسالة جديدة من فورم الاتصال</h2>"
                 + "<p><strong>الاسم:</strong> " + HttpUtility.HtmlEncode(name) + "</p>"
                 + "<p><strong>البريد:</strong> " + HttpUtility.HtmlEncode(email) + "</p>"
                 + "<p><strong>التليفون:</strong> " + HttpUtility.HtmlEncode(phone ?? "-") + "</p>"
                 + "<p><strong>الرسالة:</strong><br/>" + HttpUtility.HtmlEncode(message).Replace("\n", "<br/>") + "</p>"
                 + "</div>";
        }
    }
}
