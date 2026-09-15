using System;
using Chocodelight_Website.DataAccess;
using Chocodelight_Website.Helpers;
using Chocodelight_Website.Models;
using Chocodelight_Website.Services;

namespace Chocodelight_Website.Account
{
    public partial class OrderDetailPage : BasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            var customerId = AuthService.CurrentCustomerId;
            if (!customerId.HasValue)
            {
                Response.Redirect("~/Account/Login.aspx?return=" + Server.UrlEncode(Request.Url.PathAndQuery));
                return;
            }

            int id;
            if (!int.TryParse(Request.QueryString["id"], out id) || id <= 0)
            {
                ShowNotFound();
                return;
            }

            var order = OrderRepository.GetById(id, customerId.Value);
            if (order == null)
            {
                ShowNotFound();
                return;
            }

            Bind(order);
        }

        private void ShowNotFound()
        {
            pnlOrder.Visible = false;
            pnlNotFound.Visible = true;
        }

        private void Bind(Order o)
        {
            litOrderNumber.Text = Server.HtmlEncode(o.OrderNumber);
            litStatus.Text = OrderStatus.Label(o.Status);
            litRecipient.Text = Server.HtmlEncode(o.RecipientName);
            litPhone.Text = Server.HtmlEncode(o.RecipientPhone);
            litZone.Text = Server.HtmlEncode(o.ZoneNameSnapshot);
            litAddress.Text = Server.HtmlEncode(o.AddressDetails);

            if (!string.IsNullOrEmpty(o.GiftMessage))
            {
                pnlGift.Visible = true;
                litGift.Text = Server.HtmlEncode(o.GiftMessage);
            }

            rptItems.DataSource = o.Items;
            rptItems.DataBind();
            rptHistory.DataSource = o.History;
            rptHistory.DataBind();

            litSubtotal.Text = CultureHelper.Money(o.Subtotal);
            litFee.Text = CultureHelper.Money(o.DeliveryFee);
            litTotal.Text = CultureHelper.Money(o.Total);
        }

        protected string GetItemLabel(object item)
        {
            var oi = (OrderItem)item;
            return string.IsNullOrEmpty(oi.WeightLabel) ? oi.ProductName : oi.ProductName + " (" + oi.WeightLabel + ")";
        }
    }
}
