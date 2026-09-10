using System;
using Chocodelight_Website.DataAccess;
using Chocodelight_Website.Helpers;
using Chocodelight_Website.Models;
using Chocodelight_Website.Services;

namespace Chocodelight_Website
{
    public partial class OrderConfirmationPage : BasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string number = Request.QueryString["order"];
            if (string.IsNullOrWhiteSpace(number))
            {
                ShowNotFound();
                return;
            }

            var order = OrderRepository.GetByNumber(number.Trim());

            // Only the owning customer may view a confirmation.
            var customerId = AuthService.CurrentCustomerId;
            if (order == null || (order.CustomerId.HasValue && order.CustomerId != customerId))
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
            litRecipient.Text = Server.HtmlEncode(o.RecipientName);
            litPhone.Text = Server.HtmlEncode(o.RecipientPhone);
            litZone.Text = Server.HtmlEncode(o.ZoneNameSnapshot);
            litAddress.Text = Server.HtmlEncode(o.AddressDetails);

            if (!string.IsNullOrEmpty(o.Landmark))
            {
                pnlLandmark.Visible = true;
                litLandmark.Text = Server.HtmlEncode(o.Landmark);
            }
            if (!string.IsNullOrEmpty(o.GiftMessage))
            {
                pnlGift.Visible = true;
                litGift.Text = Server.HtmlEncode(o.GiftMessage);
            }

            rptItems.DataSource = o.Items;
            rptItems.DataBind();

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
