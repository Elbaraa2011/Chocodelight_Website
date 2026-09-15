using System;
using Chocodelight_Website.DataAccess;
using Chocodelight_Website.Helpers;

namespace Chocodelight_Website.Admin
{
    public partial class AdminDashboardPage : BaseAdminPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (IsPostBack) return;

            litToday.Text = DateTime.Now.ToString("dddd, dd MMMM yyyy",
                new System.Globalization.CultureInfo("ar-EG"));

            var stats = DashboardRepository.GetStats();
            litTotalOrders.Text = stats.TotalOrders.ToString("#,0");
            litPending.Text = stats.PendingOrders.ToString("#,0");
            litTodayRevenue.Text = CultureHelper.Money(stats.TodayRevenue);
            litDeliveredRevenue.Text = CultureHelper.Money(stats.DeliveredRevenue);
            litProducts.Text = stats.ActiveProducts.ToString("#,0");
            litCustomers.Text = stats.TotalCustomers.ToString("#,0");

            rptRecent.DataSource = DashboardRepository.GetRecentOrders(8);
            rptRecent.DataBind();
        }
    }
}
