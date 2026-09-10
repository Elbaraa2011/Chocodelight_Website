using System;
using System.IO;
using System.Web.UI;
using Chocodelight_Website.Services;

namespace Chocodelight_Website.Admin
{
    public partial class AdminMaster : MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string name = AuthService.DisplayName;
            litAdminName.Text = Server.HtmlEncode(string.IsNullOrEmpty(name) ? "حساب الأدمن" : name);
        }

        /// <summary>Marks the current section's nav link active based on the page file name.</summary>
        protected string Active(string section)
        {
            string file = Path.GetFileNameWithoutExtension(Request.CurrentExecutionFilePath);
            if (string.Equals(file, section, StringComparison.OrdinalIgnoreCase)) return "is-active";
            // Order/Product detail + edit pages keep their parent highlighted
            if (section == "Orders" && file.StartsWith("Order", StringComparison.OrdinalIgnoreCase)) return "is-active";
            if (section == "Products" && file.StartsWith("Product", StringComparison.OrdinalIgnoreCase)) return "is-active";
            return string.Empty;
        }
    }
}
