using System;
using System.Collections.Generic;
using System.Data;
using Chocodelight_Website.Models;

namespace Chocodelight_Website.DataAccess
{
    public class OrderCreateResult
    {
        public int OrderId { get; set; }
        public string OrderNumber { get; set; }
        public decimal Subtotal { get; set; }
        public decimal DeliveryFee { get; set; }
        public decimal Total { get; set; }
    }

    public static class OrderRepository
    {
        private static DataTable BuildItemsTable(IEnumerable<CartItem> items)
        {
            var dt = new DataTable();
            dt.Columns.Add("ProductId", typeof(int));
            dt.Columns.Add("ProductNameAr", typeof(string));
            dt.Columns.Add("ProductNameEn", typeof(string));
            dt.Columns.Add("WeightLabel", typeof(string));
            dt.Columns.Add("UnitPrice", typeof(decimal));
            dt.Columns.Add("Quantity", typeof(int));

            foreach (var i in items)
            {
                string weight = i.WeightLabelAr;
                if (string.IsNullOrEmpty(weight)) weight = i.WeightLabelEn;
                string flavour = i.FlavorAr;
                if (string.IsNullOrEmpty(flavour)) flavour = i.FlavorEn;

                var bits = new System.Collections.Generic.List<string>();
                if (!string.IsNullOrEmpty(weight)) bits.Add(weight);
                if (!string.IsNullOrEmpty(flavour)) bits.Add(flavour);
                string snapshot = bits.Count > 0 ? string.Join(" · ", bits) : null;

                dt.Rows.Add(
                    (object)i.ProductId ?? DBNull.Value,
                    i.ProductNameAr,
                    i.ProductNameEn,
                    (object)snapshot ?? DBNull.Value,
                    i.UnitPrice,
                    i.Quantity);
            }
            return dt;
        }

        public static OrderCreateResult Create(
            int? customerId, string recipientName, string recipientPhone, int zoneId,
            string addressDetails, string landmark, string giftMessage, string customerNote,
            IEnumerable<CartItem> items)
        {
            var tvp = Db.PStructured("@Items", "dbo.OrderItemTVP", BuildItemsTable(items));

            var dt = Db.GetTable("dbo.sp_Order_Create",
                Db.P("@CustomerId", (object)customerId ?? DBNull.Value),
                Db.P("@RecipientName", recipientName),
                Db.P("@RecipientPhone", recipientPhone),
                Db.P("@ZoneId", zoneId),
                Db.P("@AddressDetails", addressDetails),
                Db.P("@Landmark", (object)landmark ?? DBNull.Value),
                Db.P("@GiftMessage", (object)giftMessage ?? DBNull.Value),
                Db.P("@CustomerNote", (object)customerNote ?? DBNull.Value),
                tvp);

            if (dt.Rows.Count == 0) return null;
            var r = dt.Rows[0];
            return new OrderCreateResult
            {
                OrderId = r.Int("OrderId"),
                OrderNumber = r.Str("OrderNumber"),
                Subtotal = r.Dec("Subtotal"),
                DeliveryFee = r.Dec("DeliveryFee"),
                Total = r.Dec("Total")
            };
        }

        private static Order MapOrder(DataRow r)
        {
            return new Order
            {
                Id = r.Int("Id"),
                OrderNumber = r.Str("OrderNumber"),
                CustomerId = r.IntN("CustomerId"),
                RecipientName = r.Str("RecipientName"),
                RecipientPhone = r.Str("RecipientPhone"),
                ZoneId = r.Int("ZoneId"),
                ZoneNameSnapshot = r.Str("ZoneNameSnapshot"),
                AddressDetails = r.Str("AddressDetails"),
                Landmark = r.Str("Landmark"),
                Subtotal = r.Dec("Subtotal"),
                DeliveryFee = r.Dec("DeliveryFee"),
                Total = r.Dec("Total"),
                GiftMessage = r.Str("GiftMessage"),
                PaymentMethod = r.Str("PaymentMethod"),
                Status = r.Str("Status"),
                CustomerNote = r.Str("CustomerNote"),
                AdminNote = r.Str("AdminNote"),
                CreatedAt = r.Date("CreatedAt"),
                UpdatedAt = r.DateN("UpdatedAt"),
                ItemCount = r.Table.Columns.Contains("ItemCount") ? r.Int("ItemCount") : 0
            };
        }

        public static List<Order> GetByCustomer(int customerId)
        {
            var list = new List<Order>();
            var dt = Db.GetTable("dbo.sp_Order_GetByCustomer", Db.P("@CustomerId", customerId));
            foreach (DataRow r in dt.Rows)
            {
                list.Add(new Order
                {
                    Id = r.Int("Id"),
                    OrderNumber = r.Str("OrderNumber"),
                    Status = r.Str("Status"),
                    Subtotal = r.Dec("Subtotal"),
                    DeliveryFee = r.Dec("DeliveryFee"),
                    Total = r.Dec("Total"),
                    CreatedAt = r.Date("CreatedAt"),
                    ItemCount = r.Int("ItemCount")
                });
            }
            return list;
        }

        /// <summary>Full order with items and history. When customerId is supplied, ownership is enforced.</summary>
        public static Order GetById(int id, int? customerId = null)
        {
            var ds = Db.GetDataSet("dbo.sp_Order_GetById",
                Db.P("@Id", id), Db.P("@CustomerId", (object)customerId ?? DBNull.Value));

            if (ds.Tables.Count == 0 || ds.Tables[0].Rows.Count == 0) return null;
            var order = MapOrder(ds.Tables[0].Rows[0]);

            if (ds.Tables.Count > 1)
                foreach (DataRow r in ds.Tables[1].Rows)
                    order.Items.Add(new OrderItem
                    {
                        Id = r.Int("Id"),
                        ProductId = r.IntN("ProductId"),
                        ProductNameAr = r.Str("ProductNameAr"),
                        ProductNameEn = r.Str("ProductNameEn"),
                        WeightLabel = r.Str("WeightLabel"),
                        UnitPrice = r.Dec("UnitPrice"),
                        Quantity = r.Int("Quantity"),
                        LineTotal = r.Dec("LineTotal")
                    });

            if (ds.Tables.Count > 2)
                foreach (DataRow r in ds.Tables[2].Rows)
                    order.History.Add(new OrderStatusHistoryEntry
                    {
                        Id = r.Int("Id"),
                        OldStatus = r.Str("OldStatus"),
                        NewStatus = r.Str("NewStatus"),
                        Note = r.Str("Note"),
                        ChangedAt = r.Date("ChangedAt")
                    });

            return order;
        }

        public static Order GetByNumber(string orderNumber)
        {
            var ds = Db.GetDataSet("dbo.sp_Order_GetByNumber", Db.P("@OrderNumber", orderNumber));
            if (ds.Tables.Count == 0 || ds.Tables[0].Rows.Count == 0) return null;
            var order = MapOrder(ds.Tables[0].Rows[0]);
            if (ds.Tables.Count > 1)
                foreach (DataRow r in ds.Tables[1].Rows)
                    order.Items.Add(new OrderItem
                    {
                        Id = r.Int("Id"),
                        ProductNameAr = r.Str("ProductNameAr"),
                        ProductNameEn = r.Str("ProductNameEn"),
                        WeightLabel = r.Str("WeightLabel"),
                        UnitPrice = r.Dec("UnitPrice"),
                        Quantity = r.Int("Quantity"),
                        LineTotal = r.Dec("LineTotal")
                    });
            return order;
        }

        public static void UpdateStatus(int orderId, string newStatus, int? adminId, string note)
        {
            Db.Execute("dbo.sp_Order_UpdateStatus",
                Db.P("@Id", orderId), Db.P("@NewStatus", newStatus),
                Db.P("@ChangedByAdminId", (object)adminId ?? DBNull.Value),
                Db.P("@Note", (object)note ?? DBNull.Value));
        }

        public class AdminOrderList
        {
            public List<Order> Orders { get; set; } = new List<Order>();
            public int TotalCount { get; set; }
        }

        public static AdminOrderList GetListAdmin(string status, string search, int page, int pageSize)
        {
            var ds = Db.GetDataSet("dbo.sp_Order_GetListAdmin",
                Db.P("@Status", (object)status ?? DBNull.Value),
                Db.P("@Search", (object)search ?? DBNull.Value),
                Db.P("@PageNumber", page), Db.P("@PageSize", pageSize));

            var result = new AdminOrderList();
            if (ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                result.TotalCount = ds.Tables[0].Rows[0].Int("TotalCount");

            if (ds.Tables.Count > 1)
                foreach (DataRow r in ds.Tables[1].Rows)
                    result.Orders.Add(new Order
                    {
                        Id = r.Int("Id"),
                        OrderNumber = r.Str("OrderNumber"),
                        RecipientName = r.Str("RecipientName"),
                        RecipientPhone = r.Str("RecipientPhone"),
                        ZoneNameSnapshot = r.Str("ZoneNameSnapshot"),
                        Total = r.Dec("Total"),
                        Status = r.Str("Status"),
                        CreatedAt = r.Date("CreatedAt"),
                        ItemCount = r.Int("ItemCount")
                    });

            return result;
        }

        public static System.Collections.Generic.Dictionary<string, int> GetStatusCounts()
        {
            var dt = Db.GetTable("dbo.sp_Order_StatusCounts");
            var d = new System.Collections.Generic.Dictionary<string, int>();
            if (dt.Rows.Count == 0) return d;
            var r = dt.Rows[0];
            d["all"] = r.Int("AllCount");
            d["Review"] = r.Int("ReviewCount");
            d["Confirmed"] = r.Int("ConfirmedCount");
            d["Preparing"] = r.Int("PreparingCount");
            d["Delivering"] = r.Int("DeliveringCount");
            d["Delivered"] = r.Int("DeliveredCount");
            d["Cancelled"] = r.Int("CancelledCount");
            return d;
        }
    }
}
