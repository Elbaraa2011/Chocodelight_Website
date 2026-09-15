using System.Collections.Generic;
using System.Linq;
using System.Web;
using Chocodelight_Website.Models;

namespace Chocodelight_Website.Services
{
    /// <summary>Session-backed shopping cart. Persisted to the DB only when an order is placed.</summary>
    public static class CartManager
    {
        private const string SessionKey = "cd_cart";

        public static List<CartItem> Items
        {
            get
            {
                var session = HttpContext.Current.Session;
                var items = session[SessionKey] as List<CartItem>;
                if (items == null)
                {
                    items = new List<CartItem>();
                    session[SessionKey] = items;
                }
                return items;
            }
        }

        public static int Count
        {
            get { return Items.Sum(i => i.Quantity); }
        }

        public static decimal Subtotal
        {
            get { return Items.Sum(i => i.LineTotal); }
        }

        public static bool IsEmpty { get { return Items.Count == 0; } }

        public static void Add(CartItem item)
        {
            if (item == null || item.Quantity < 1) return;
            var existing = Items.FirstOrDefault(i => i.Key == item.Key);
            if (existing != null)
                existing.Quantity += item.Quantity;
            else
                Items.Add(item);
        }

        public static void UpdateQuantity(string key, int quantity)
        {
            var existing = Items.FirstOrDefault(i => i.Key == key);
            if (existing == null) return;
            if (quantity <= 0) Items.Remove(existing);
            else existing.Quantity = quantity;
        }

        public static void Remove(string key)
        {
            var existing = Items.FirstOrDefault(i => i.Key == key);
            if (existing != null) Items.Remove(existing);
        }

        public static void Clear()
        {
            HttpContext.Current.Session[SessionKey] = new List<CartItem>();
        }
    }
}
