using System;
using System.Linq;
using System.Web;
using System.Web.UI.WebControls;
using Chocodelight_Website.DataAccess;
using Chocodelight_Website.Helpers;
using Chocodelight_Website.Models;
using Chocodelight_Website.Services;

namespace Chocodelight_Website
{
    public partial class CheckoutPage : BasePage
    {
        private int CustomerId
        {
            get { return AuthService.CurrentCustomerId ?? 0; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!AuthService.CurrentCustomerId.HasValue)
            {
                Response.Redirect("~/Account/Login.aspx?return=" + HttpUtility.UrlEncode("/Checkout.aspx"));
                return;
            }

            if (CartManager.IsEmpty)
            {
                Response.Redirect("~/Cart.aspx");
                return;
            }

            if (!IsPostBack)
            {
                BindZones();
                BindSavedAddresses();
                PrefillFromCustomer();
                BindSummary();
            }
        }

        private void BindZones()
        {
            var zones = DeliveryZoneRepository.GetAll(activeOnly: true);
            ddlZone.Items.Clear();
            foreach (var z in zones)
                ddlZone.Items.Add(new ListItem(
                    (CultureHelper.IsArabic ? z.NameAr : z.NameEn) + " (" + CultureHelper.Money(z.Fee) + ")",
                    z.Id.ToString()));
        }

        private void BindSavedAddresses()
        {
            var addresses = AddressRepository.GetByCustomer(CustomerId);
            if (addresses.Count == 0) return;

            pnlSavedAddresses.Visible = true;
            ddlSavedAddress.Items.Clear();
            ddlSavedAddress.Items.Add(new ListItem(T("— عنوان جديد —", "— New address —"), "0"));
            foreach (var a in addresses)
            {
                string label = (string.IsNullOrEmpty(a.Label) ? a.ZoneName : a.Label) + " · " + a.Details;
                if (label.Length > 60) label = label.Substring(0, 57) + "...";
                ddlSavedAddress.Items.Add(new ListItem(label, a.Id.ToString()));
            }

            var def = addresses.FirstOrDefault(x => x.IsDefault) ?? addresses[0];
            ddlSavedAddress.SelectedValue = def.Id.ToString();
            FillAddress(def);
        }

        private void PrefillFromCustomer()
        {
            if (!string.IsNullOrEmpty(txtRecipient.Text)) return; // already filled from saved address
            var c = CustomerRepository.GetById(CustomerId);
            if (c == null) return;
            txtRecipient.Text = c.FullName;
            if (string.IsNullOrEmpty(txtPhone.Text)) txtPhone.Text = c.Phone;
        }

        private void FillAddress(Address a)
        {
            txtDetails.Text = a.Details;
            txtLandmark.Text = a.Landmark;
            txtPhone.Text = a.Phone;
            if (ddlZone.Items.FindByValue(a.ZoneId.ToString()) != null)
                ddlZone.SelectedValue = a.ZoneId.ToString();
        }

        protected void ddlSavedAddress_Changed(object sender, EventArgs e)
        {
            int addressId;
            if (int.TryParse(ddlSavedAddress.SelectedValue, out addressId) && addressId > 0)
            {
                var a = AddressRepository.GetById(addressId);
                if (a != null && a.CustomerId == CustomerId) FillAddress(a);
            }
            BindSummary();
        }

        protected void ddlZone_Changed(object sender, EventArgs e)
        {
            BindSummary();
        }

        private DeliveryZone SelectedZone()
        {
            int zoneId;
            if (int.TryParse(ddlZone.SelectedValue, out zoneId))
                return DeliveryZoneRepository.GetById(zoneId);
            return null;
        }

        private void BindSummary()
        {
            rptItems.DataSource = CartManager.Items;
            rptItems.DataBind();

            decimal subtotal = CartManager.Subtotal;
            var zone = SelectedZone();
            decimal fee = zone != null ? zone.Fee : 0m;

            litSubtotal.Text = CultureHelper.Money(subtotal);
            litDeliveryFee.Text = CultureHelper.Money(fee);
            litTotal.Text = CultureHelper.Money(subtotal + fee);
            btnPlaceOrder.Text = T("أكّد الطلب — الدفع عند الاستلام", "Place order — Cash on delivery");
        }

        protected void btnPlaceOrder_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            if (CartManager.IsEmpty)
            {
                Response.Redirect("~/Cart.aspx");
                return;
            }

            var zone = SelectedZone();
            if (zone == null)
            {
                ShowError(T("اختار منطقة توصيل صحيحة.", "Please choose a valid delivery area."));
                return;
            }

            string details = txtDetails.Text.Trim();
            string landmark = string.IsNullOrWhiteSpace(txtLandmark.Text) ? null : txtLandmark.Text.Trim();
            string phone = txtPhone.Text.Trim();
            string recipient = txtRecipient.Text.Trim();
            string gift = string.IsNullOrWhiteSpace(txtGift.Text) ? null : txtGift.Text.Trim();
            string note = string.IsNullOrWhiteSpace(txtNote.Text) ? null : txtNote.Text.Trim();

            OrderCreateResult result;
            try
            {
                result = OrderRepository.Create(
                    customerId: CustomerId,
                    recipientName: recipient,
                    recipientPhone: phone,
                    zoneId: zone.Id,
                    addressDetails: details,
                    landmark: landmark,
                    giftMessage: gift,
                    customerNote: note,
                    items: CartManager.Items);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Trace.TraceError("Order create failed: " + ex);
                ShowError(T("حصلت مشكلة أثناء تأكيد الطلب. جرّب تاني.",
                            "Something went wrong placing the order. Please try again."));
                return;
            }

            if (result == null)
            {
                ShowError(T("حصلت مشكلة أثناء تأكيد الطلب. جرّب تاني.",
                            "Something went wrong placing the order. Please try again."));
                return;
            }

            if (chkSaveAddress.Checked)
            {
                try
                {
                    AddressRepository.Insert(new Address
                    {
                        CustomerId = CustomerId,
                        Label = null,
                        ZoneId = zone.Id,
                        Details = details,
                        Landmark = landmark,
                        Phone = phone,
                        IsDefault = false
                    });
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Trace.TraceError("Save address failed: " + ex);
                }
            }

            CartManager.Clear();
            Response.Redirect("~/OrderConfirmation.aspx?order=" + HttpUtility.UrlEncode(result.OrderNumber));
        }

        private void ShowError(string message)
        {
            pnlError.Visible = true;
            litError.Text = Server.HtmlEncode(message);
        }

        protected string GetItemLabel(object item)
        {
            var ci = (CartItem)item;
            return string.IsNullOrEmpty(ci.OptionsText) ? ci.ProductName : ci.ProductName + " (" + ci.OptionsText + ")";
        }
    }
}
