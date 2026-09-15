using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI.WebControls;
using Chocodelight_Website.DataAccess;
using Chocodelight_Website.Helpers;
using Chocodelight_Website.Models;

namespace Chocodelight_Website.Admin
{
    public partial class AdminOrdersPage : BaseAdminPage
    {
        private const int PageSize = 20;

        public string CurrentStatus { get; private set; }
        private int CurrentPage;
        private string SearchTerm;

        protected void Page_Load(object sender, EventArgs e)
        {
            CurrentStatus = (Request.QueryString["status"] ?? "all").Trim();
            if (!IsValidStatus(CurrentStatus)) CurrentStatus = "all";

            int p;
            CurrentPage = int.TryParse(Request.QueryString["page"], out p) && p > 0 ? p : 1;
            SearchTerm = Request.QueryString["q"];

            if (!IsPostBack)
            {
                txtSearch.Text = SearchTerm;
                BindFilters();
                BindGrid();
            }
        }

        private static bool IsValidStatus(string s)
        {
            if (s == "all") return true;
            return Array.IndexOf(OrderStatus.All, s) >= 0;
        }

        private void BindFilters()
        {
            var counts = OrderRepository.GetStatusCounts();
            var ordered = new List<KeyValuePair<string, int>>
            {
                new KeyValuePair<string, int>("all", counts.ContainsKey("all") ? counts["all"] : 0)
            };
            foreach (var s in OrderStatus.All)
                ordered.Add(new KeyValuePair<string, int>(s, counts.ContainsKey(s) ? counts[s] : 0));

            rptFilters.DataSource = ordered;
            rptFilters.DataBind();
        }

        private void BindGrid()
        {
            string statusFilter = CurrentStatus == "all" ? null : CurrentStatus;
            string search = string.IsNullOrWhiteSpace(SearchTerm) ? null : SearchTerm.Trim();

            var list = OrderRepository.GetListAdmin(statusFilter, search, CurrentPage, PageSize);

            rptOrders.DataSource = list.Orders;
            rptOrders.DataBind();
            pnlEmpty.Visible = list.Orders.Count == 0;

            int totalPages = (int)Math.Ceiling(list.TotalCount / (double)PageSize);
            lnkPrev.Visible = CurrentPage > 1;
            lnkNext.Visible = CurrentPage < totalPages;
            lnkPrev.NavigateUrl = PageUrl(CurrentPage - 1);
            lnkNext.NavigateUrl = PageUrl(CurrentPage + 1);
        }

        protected void rptOrders_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType != ListItemType.Item && e.Item.ItemType != ListItemType.AlternatingItem) return;

            var order = (Order)e.Item.DataItem;
            var ddl = (DropDownList)e.Item.FindControl("ddlStatus");
            ddl.Items.Clear();
            foreach (var s in OrderStatus.All)
                ddl.Items.Add(new ListItem(OrderStatus.LabelAr(s), s));
            ddl.SelectedValue = order.Status;
        }

        protected void ddlStatus_Changed(object sender, EventArgs e)
        {
            var ddl = (DropDownList)sender;
            var item = (RepeaterItem)ddl.NamingContainer;
            var hf = (HiddenField)item.FindControl("hfOrderId");

            int orderId;
            if (!int.TryParse(hf.Value, out orderId)) return;

            string newStatus = ddl.SelectedValue;
            if (Array.IndexOf(OrderStatus.All, newStatus) < 0) return;

            OrderRepository.UpdateStatus(orderId, newStatus, CurrentAdminId, "تغيير من قائمة الطلبات");

            pnlMsg.Visible = true;
            litMsg.Text = "تم تحديث حالة الطلب.";

            BindFilters();
            BindGrid();
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            string q = txtSearch.Text.Trim();
            Response.Redirect("~/Admin/Orders.aspx?status=" + HttpUtility.UrlEncode(CurrentStatus)
                + (string.IsNullOrEmpty(q) ? "" : "&q=" + HttpUtility.UrlEncode(q)));
        }

        protected string FilterUrl(string status)
        {
            return ResolveUrl("~/Admin/Orders.aspx?status=" + HttpUtility.UrlEncode(status)
                + (string.IsNullOrWhiteSpace(SearchTerm) ? "" : "&q=" + HttpUtility.UrlEncode(SearchTerm)));
        }

        private string PageUrl(int page)
        {
            return ResolveUrl("~/Admin/Orders.aspx?status=" + HttpUtility.UrlEncode(CurrentStatus)
                + (string.IsNullOrWhiteSpace(SearchTerm) ? "" : "&q=" + HttpUtility.UrlEncode(SearchTerm))
                + "&page=" + page);
        }

        protected string GetFilterLabel(string key)
        {
            return key == "all" ? "الكل" : OrderStatus.LabelAr(key);
        }
    }
}
