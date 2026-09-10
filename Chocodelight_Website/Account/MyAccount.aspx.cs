using System;
using System.Web.UI.WebControls;
using Chocodelight_Website.DataAccess;
using Chocodelight_Website.Helpers;
using Chocodelight_Website.Models;
using Chocodelight_Website.Services;

namespace Chocodelight_Website.Account
{
    public partial class MyAccountPage : BasePage
    {
        public string Tab { get; private set; }

        private int CustomerId { get { return AuthService.CurrentCustomerId ?? 0; } }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!AuthService.CurrentCustomerId.HasValue)
            {
                Response.Redirect("~/Account/Login.aspx?return=" + Server.UrlEncode("/Account/MyAccount.aspx"));
                return;
            }

            Tab = (Request.QueryString["tab"] ?? "orders").ToLowerInvariant();
            if (Tab != "orders" && Tab != "addresses" && Tab != "profile") Tab = "orders";

            pnlOrders.Visible = Tab == "orders";
            pnlAddresses.Visible = Tab == "addresses";
            pnlProfile.Visible = Tab == "profile";

            if (!IsPostBack)
            {
                if (Tab == "orders") BindOrders();
                else if (Tab == "addresses") { BindZones(); BindAddresses(); }
                else BindProfile();
            }
            else if (Tab == "addresses" && ddlAddrZone.Items.Count == 0)
            {
                BindZones();
            }
        }

        // ---------- Orders ----------
        private void BindOrders()
        {
            var orders = OrderRepository.GetByCustomer(CustomerId);
            pnlNoOrders.Visible = orders.Count == 0;
            rptOrders.DataSource = orders;
            rptOrders.DataBind();
        }

        // ---------- Addresses ----------
        private void BindZones()
        {
            ddlAddrZone.Items.Clear();
            foreach (var z in DeliveryZoneRepository.GetAll(activeOnly: true))
                ddlAddrZone.Items.Add(new ListItem(z.NameAr + " (" + CultureHelper.Money(z.Fee) + ")", z.Id.ToString()));
        }

        private void BindAddresses()
        {
            rptAddresses.DataSource = AddressRepository.GetByCustomer(CustomerId);
            rptAddresses.DataBind();
        }

        private void ResetAddrForm()
        {
            hfAddrId.Value = "0";
            txtAddrLabel.Text = txtAddrDetails.Text = txtAddrLandmark.Text = txtAddrPhone.Text = "";
            chkAddrDefault.Checked = false;
            litAddrFormTitle.Text = "إضافة عنوان";
            btnAddrCancel.Visible = false;
        }

        protected void rptAddresses_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int id;
            if (!int.TryParse(Convert.ToString(e.CommandArgument), out id)) return;

            var addr = AddressRepository.GetById(id);
            if (addr == null || addr.CustomerId != CustomerId) return;

            switch (e.CommandName)
            {
                case "edit":
                    hfAddrId.Value = addr.Id.ToString();
                    txtAddrLabel.Text = addr.Label;
                    txtAddrDetails.Text = addr.Details;
                    txtAddrLandmark.Text = addr.Landmark;
                    txtAddrPhone.Text = addr.Phone;
                    chkAddrDefault.Checked = addr.IsDefault;
                    if (ddlAddrZone.Items.FindByValue(addr.ZoneId.ToString()) != null)
                        ddlAddrZone.SelectedValue = addr.ZoneId.ToString();
                    litAddrFormTitle.Text = "تعديل عنوان";
                    btnAddrCancel.Visible = true;
                    break;
                case "default":
                    AddressRepository.SetDefault(id, CustomerId);
                    ShowMsg("تم تعيين العنوان الافتراضي.");
                    BindAddresses();
                    break;
                case "del":
                    AddressRepository.Delete(id, CustomerId);
                    ShowMsg("تم حذف العنوان.");
                    ResetAddrForm();
                    BindAddresses();
                    break;
            }
        }

        protected void btnAddrSave_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            int zoneId;
            int.TryParse(ddlAddrZone.SelectedValue, out zoneId);

            var addr = new Address
            {
                CustomerId = CustomerId,
                Label = string.IsNullOrWhiteSpace(txtAddrLabel.Text) ? null : txtAddrLabel.Text.Trim(),
                ZoneId = zoneId,
                Details = txtAddrDetails.Text.Trim(),
                Landmark = string.IsNullOrWhiteSpace(txtAddrLandmark.Text) ? null : txtAddrLandmark.Text.Trim(),
                Phone = txtAddrPhone.Text.Trim(),
                IsDefault = chkAddrDefault.Checked
            };

            int editId;
            int.TryParse(hfAddrId.Value, out editId);

            if (editId > 0)
            {
                var existing = AddressRepository.GetById(editId);
                if (existing == null || existing.CustomerId != CustomerId) return;
                addr.Id = editId;
                AddressRepository.Update(addr);
                ShowMsg("تم تحديث العنوان.");
            }
            else
            {
                AddressRepository.Insert(addr);
                ShowMsg("تم إضافة العنوان.");
            }

            ResetAddrForm();
            BindAddresses();
        }

        protected void btnAddrCancel_Click(object sender, EventArgs e)
        {
            ResetAddrForm();
        }

        // ---------- Profile ----------
        private void BindProfile()
        {
            var c = CustomerRepository.GetById(CustomerId);
            if (c == null) return;
            txtProfileName.Text = c.FullName;
            txtProfileEmail.Text = c.Email;
            txtProfilePhone.Text = c.Phone;
        }

        protected void btnProfileSave_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;
            CustomerRepository.UpdateProfile(CustomerId, txtProfileName.Text.Trim(),
                string.IsNullOrWhiteSpace(txtProfilePhone.Text) ? null : txtProfilePhone.Text.Trim());
            ShowMsg("تم حفظ البيانات.");
        }

        protected void btnChangePw_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            var c = CustomerRepository.GetByEmail(CustomerRepository.GetById(CustomerId)?.Email);
            if (c == null) return;

            if (!PasswordHasher.Verify(txtCurrentPw.Text, c.PasswordHash))
            {
                ShowErr("كلمة السر الحالية غير صحيحة.");
                return;
            }
            if (txtNewPw.Text.Length < 8)
            {
                ShowErr("كلمة السر الجديدة قصيرة.");
                return;
            }

            CustomerRepository.UpdatePassword(CustomerId, PasswordHasher.Hash(txtNewPw.Text));
            txtCurrentPw.Text = txtNewPw.Text = txtNewPwConfirm.Text = "";
            ShowMsg("تم تغيير كلمة السر.");
        }

        private void ShowMsg(string m) { pnlMsg.Visible = true; litMsg.Text = Server.HtmlEncode(m); }
        private void ShowErr(string m) { pnlErr.Visible = true; litErr.Text = Server.HtmlEncode(m); }
    }
}
