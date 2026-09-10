using System;
using System.Web.UI.WebControls;
using Chocodelight_Website.Helpers;
using Chocodelight_Website.Models;
using Chocodelight_Website.Services;

namespace Chocodelight_Website
{
    public partial class CartPage : BasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack) BindCart();
        }

        private void BindCart()
        {
            var items = CartManager.Items;
            bool hasItems = items.Count > 0;

            pnlCart.Visible = hasItems;
            pnlEmpty.Visible = !hasItems;
            if (!hasItems) return;

            rptItems.DataSource = items;
            rptItems.DataBind();

            litCount.Text = CartManager.Count.ToString();
            litSubtotal.Text = CultureHelper.Money(CartManager.Subtotal);
            litTotal.Text = CultureHelper.Money(CartManager.Subtotal);
        }

        protected void rptItems_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            string key = Convert.ToString(e.CommandArgument);
            if (string.IsNullOrEmpty(key)) return;

            var existing = CartManager.Items.Find(i => i.Key == key);
            int current = existing != null ? existing.Quantity : 0;

            switch (e.CommandName)
            {
                case "inc":
                    CartManager.UpdateQuantity(key, Math.Min(99, current + 1));
                    break;
                case "dec":
                    CartManager.UpdateQuantity(key, current - 1);
                    break;
                case "del":
                    CartManager.Remove(key);
                    break;
            }

            BindCart();
        }

        protected string GetName(object item)
        {
            return Server.HtmlEncode(((CartItem)item).ProductName);
        }

        protected string GetMeta(object item)
        {
            var ci = (CartItem)item;
            return string.IsNullOrEmpty(ci.OptionsText) ? "" : Server.HtmlEncode(ci.OptionsText);
        }
    }
}
