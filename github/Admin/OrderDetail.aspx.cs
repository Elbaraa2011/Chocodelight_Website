using System;
using System.Web.UI.WebControls;
using Chocodelight_Website.DataAccess;
using Chocodelight_Website.Helpers;
using Chocodelight_Website.Models;

namespace Chocodelight_Website.Admin
{
    public partial class AdminOrderDetailPage : BaseAdminPage
    {
        private int _orderId;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!int.TryParse(Request.QueryString["id"], out _orderId) || _orderId <= 0)
            {
                ShowNotFound();
                return;
            }

            if (!IsPostBack)
            {
                var order = OrderRepository.GetById(_orderId);
                if (order == null) { ShowNotFound(); return; }
                BindStatusOptions(order.Status);
                Bind(order);
            }
        }

        private void ShowNotFound()
        {
            pnlOrder.Visible = false;
            pnlNotFound.Visible = true;
        }

        private void BindStatusOptions(string current)
        {
            ddlStatus.Items.Clear();
            foreach (var s in OrderStatus.All)
                ddlStatus.Items.Add(new ListItem(OrderStatus.LabelAr(s), s));
            ddlStatus.SelectedValue = current;
        }

        private void Bind(Order o)
        {
            litOrderNumber.Text = Server.HtmlEncode(o.OrderNumber);
            litDate.Text = o.CreatedAt.ToString("yyyy-MM-dd HH:mm");
            litRecipient.Text = Server.HtmlEncode(o.RecipientName);
            litPhone.Text = Server.HtmlEncode(o.RecipientPhone);
            litZone.Text = Server.HtmlEncode(o.ZoneNameSnapshot);
            litAddress.Text = Server.HtmlEncode(o.AddressDetails);

            if (!string.IsNullOrEmpty(o.Landmark)) { pnlLandmark.Visible = true; litLandmark.Text = Server.HtmlEncode(o.Landmark); }
            if (!string.IsNullOrEmpty(o.GiftMessage)) { pnlGift.Visible = true; litGift.Text = Server.HtmlEncode(o.GiftMessage); }
            if (!string.IsNullOrEmpty(o.CustomerNote)) { pnlCustNote.Visible = true; litCustNote.Text = Server.HtmlEncode(o.CustomerNote); }

            rptItems.DataSource = o.Items; rptItems.DataBind();
            rptHistory.DataSource = o.History; rptHistory.DataBind();

            litSubtotal.Text = CultureHelper.Money(o.Subtotal);
            litFee.Text = CultureHelper.Money(o.DeliveryFee);
            litTotal.Text = CultureHelper.Money(o.Total);
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            if (_orderId <= 0) return;

            string newStatus = ddlStatus.SelectedValue;
            if (Array.IndexOf(OrderStatus.All, newStatus) < 0) return;

            string note = string.IsNullOrWhiteSpace(txtNote.Text) ? null : txtNote.Text.Trim();
            OrderRepository.UpdateStatus(_orderId, newStatus, CurrentAdminId, note);

            var order = OrderRepository.GetById(_orderId);
            if (order == null) { ShowNotFound(); return; }

            txtNote.Text = "";
            pnlMsg.Visible = true;
            litMsg.Text = "تم تحديث حالة الطلب.";
            BindStatusOptions(order.Status);
            Bind(order);
        }

        protected string GetItemLabel(object item)
        {
            var oi = (OrderItem)item;
            return string.IsNullOrEmpty(oi.WeightLabel) ? oi.ProductName : oi.ProductName + " (" + oi.WeightLabel + ")";
        }
    }
}
