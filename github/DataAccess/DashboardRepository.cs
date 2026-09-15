using System.Collections.Generic;
using System.Data;
using Chocodelight_Website.Models;

namespace Chocodelight_Website.DataAccess
{
    public class DashboardStats
    {
        public int TotalOrders { get; set; }
        public int PendingOrders { get; set; }
        public int ActiveOrders { get; set; }
        public decimal DeliveredRevenue { get; set; }
        public decimal TodayRevenue { get; set; }
        public int ActiveProducts { get; set; }
        public int TotalCustomers { get; set; }
        public int UnreadMessages { get; set; }
    }

    public static class DashboardRepository
    {
        public static DashboardStats GetStats()
        {
            var dt = Db.GetTable("dbo.sp_Dashboard_GetStats");
            if (dt.Rows.Count == 0) return new DashboardStats();
            var r = dt.Rows[0];
            return new DashboardStats
            {
                TotalOrders = r.Int("TotalOrders"),
                PendingOrders = r.Int("PendingOrders"),
                ActiveOrders = r.Int("ActiveOrders"),
                DeliveredRevenue = r.Dec("DeliveredRevenue"),
                TodayRevenue = r.Dec("TodayRevenue"),
                ActiveProducts = r.Int("ActiveProducts"),
                TotalCustomers = r.Int("TotalCustomers"),
                UnreadMessages = r.Int("UnreadMessages")
            };
        }

        public static List<Order> GetRecentOrders(int take = 8)
        {
            var list = new List<Order>();
            var dt = Db.GetTable("dbo.sp_Dashboard_GetRecentOrders", Db.P("@Take", take));
            foreach (DataRow r in dt.Rows)
            {
                list.Add(new Order
                {
                    Id = r.Int("Id"),
                    OrderNumber = r.Str("OrderNumber"),
                    RecipientName = r.Str("RecipientName"),
                    Total = r.Dec("Total"),
                    Status = r.Str("Status"),
                    CreatedAt = r.Date("CreatedAt")
                });
            }
            return list;
        }
    }
}
