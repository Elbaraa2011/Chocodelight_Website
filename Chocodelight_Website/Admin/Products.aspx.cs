using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI.WebControls;
using Chocodelight_Website.DataAccess;
using Chocodelight_Website.Helpers;
using Chocodelight_Website.Models;

namespace Chocodelight_Website.Admin
{
    public partial class AdminProductsPage : BaseAdminPage
    {
        public string CurrentSlug { get; private set; }
        private string SearchTerm;

        protected void Page_Load(object sender, EventArgs e)
        {
            CurrentSlug = (Request.QueryString["cat"] ?? "all").Trim().ToLowerInvariant();
            SearchTerm = Request.QueryString["q"];

            if (!IsPostBack)
            {
                txtSearch.Text = SearchTerm;
                BindCats();
                BindGrid();
            }
        }

        private void BindCats()
        {
            var cats = new List<Category> { new Category { Slug = "all", NameAr = "الكل", NameEn = "All" } };
            cats.AddRange(CategoryRepository.GetAll(activeOnly: false));
            rptCats.DataSource = cats;
            rptCats.DataBind();
        }

        private void BindGrid()
        {
            string slug = CurrentSlug == "all" ? null : CurrentSlug;
            string search = string.IsNullOrWhiteSpace(SearchTerm) ? null : SearchTerm.Trim();

            var products = ProductRepository.GetList(categorySlug: slug, search: search, activeOnly: false);
            rptProducts.DataSource = products;
            rptProducts.DataBind();
            pnlEmpty.Visible = products.Count == 0;
        }

        protected void rptProducts_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName != "toggle") return;

            int id;
            if (!int.TryParse(Convert.ToString(e.CommandArgument), out id)) return;

            bool nowActive = ProductRepository.ToggleActive(id);
            pnlMsg.Visible = true;
            litMsg.Text = nowActive ? "تم تفعيل المنتج." : "تم إيقاف المنتج.";
            BindGrid();
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            string q = txtSearch.Text.Trim();
            Response.Redirect("~/Admin/Products.aspx?cat=" + HttpUtility.UrlEncode(CurrentSlug)
                + (string.IsNullOrEmpty(q) ? "" : "&q=" + HttpUtility.UrlEncode(q)));
        }
    }
}
