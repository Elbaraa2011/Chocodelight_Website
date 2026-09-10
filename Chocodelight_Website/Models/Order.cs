using System;
using System.Collections.Generic;

namespace Chocodelight_Website.Models
{
    public static class OrderStatus
    {
        public const string Review = "Review";
        public const string Confirmed = "Confirmed";
        public const string Preparing = "Preparing";
        public const string Delivering = "Delivering";
        public const string Delivered = "Delivered";
        public const string Cancelled = "Cancelled";

        public static readonly string[] All =
            { Review, Confirmed, Preparing, Delivering, Delivered, Cancelled };

        public static string LabelAr(string status)
        {
            switch (status)
            {
                case Review: return "قيد المراجعة";
                case Confirmed: return "تم التأكيد";
                case Preparing: return "قيد التحضير";
                case Delivering: return "خرج للتوصيل";
                case Delivered: return "تم التسليم";
                case Cancelled: return "ملغي";
                default: return status;
            }
        }

        public static string LabelEn(string status)
        {
            switch (status)
            {
                case Review: return "Under Review";
                case Confirmed: return "Confirmed";
                case Preparing: return "Preparing";
                case Delivering: return "Out for Delivery";
                case Delivered: return "Delivered";
                case Cancelled: return "Cancelled";
                default: return status;
            }
        }

        public static string Label(string status)
        {
            return Helpers.CultureHelper.IsArabic ? LabelAr(status) : LabelEn(status);
        }
    }

    public class Order
    {
        public int Id { get; set; }
        public string OrderNumber { get; set; }
        public int? CustomerId { get; set; }
        public string RecipientName { get; set; }
        public string RecipientPhone { get; set; }
        public int ZoneId { get; set; }
        public string ZoneNameSnapshot { get; set; }
        public string AddressDetails { get; set; }
        public string Landmark { get; set; }
        public decimal Subtotal { get; set; }
        public decimal DeliveryFee { get; set; }
        public decimal Total { get; set; }
        public string GiftMessage { get; set; }
        public string PaymentMethod { get; set; }
        public string Status { get; set; }
        public string CustomerNote { get; set; }
        public string AdminNote { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime? UpdatedAt { get; set; }
        public int ItemCount { get; set; }

        public List<OrderItem> Items { get; set; } = new List<OrderItem>();
        public List<OrderStatusHistoryEntry> History { get; set; } = new List<OrderStatusHistoryEntry>();

        public string StatusLabel { get { return OrderStatus.Label(Status); } }
    }

    public class OrderItem
    {
        public int Id { get; set; }
        public int? ProductId { get; set; }
        public string ProductNameAr { get; set; }
        public string ProductNameEn { get; set; }
        public string WeightLabel { get; set; }
        public decimal UnitPrice { get; set; }
        public int Quantity { get; set; }
        public decimal LineTotal { get; set; }

        public string ProductName { get { return Helpers.CultureHelper.IsArabic ? ProductNameAr : ProductNameEn; } }
    }

    public class OrderStatusHistoryEntry
    {
        public int Id { get; set; }
        public string OldStatus { get; set; }
        public string NewStatus { get; set; }
        public string Note { get; set; }
        public DateTime ChangedAt { get; set; }
    }
}
