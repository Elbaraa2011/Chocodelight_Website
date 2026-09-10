using System;
using System.Collections.Generic;
using Chocodelight_Website.DataAccess;
using Chocodelight_Website.Helpers;
using Chocodelight_Website.Models;

namespace Chocodelight_Website
{
    public partial class MenuPage : BasePage
    {
        public string CurrentSlug { get; private set; }
        public string PageTitle { get; private set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            CurrentSlug = (Request.QueryString["cat"] ?? "all").Trim().ToLowerInvariant();

            var categories = CategoryRepository.GetAll(activeOnly: true);
            BindTabs(categories);

            string slugFilter = CurrentSlug == "all" ? null : CurrentSlug;
            var products = ProductRepository.GetList(categorySlug: slugFilter, activeOnly: true);

            // Attach weight options so "starting from" price is accurate.
            foreach (var p in products)
            {
                var full = ProductRepository.GetById(p.Id);
                if (full != null) p.WeightOptions = full.WeightOptions;
            }

            rptProducts.DataSource = products;
            rptProducts.DataBind();

            pnlEmpty.Visible = products.Count == 0;
            litCount.Text = products.Count + " " + T("منتج متاح", "items available");

            string catName = "all";
            var current = categories.Find(c => c.Slug == CurrentSlug);
            if (current != null) catName = current.Name;
            PageTitle = T("المنيو", "Menu") + " — Choco Delight"
                        + (CurrentSlug != "all" ? " · " + catName : "");
        }

        private void BindTabs(List<Category> categories)
        {
            var tabs = new List<Category>
            {
                new Category { Slug = "all", NameAr = "الكل", NameEn = "All" }
            };
            tabs.AddRange(categories);

            rptTabs.DataSource = tabs;
            rptTabs.DataBind();
        }

        // ---- Repeater item helpers ----
        protected string GetName(object item) { return ((Product)item).Name; }
        protected string GetCategoryName(object item) { return ((Product)item).CategoryName; }
        protected decimal GetFromPrice(object item) { return ((Product)item).DisplayFromPrice; }
        protected string GetWeightNote(object item) { return ((Product)item).WeightNote; }

        protected string ShowBadge(object item)
        {
            var p = (Product)item;
            if (p.IsBestSeller)
                return "<span class=\"product-badge\"><svg viewBox=\"0 0 24 24\"><use href=\"#ic-star\"/></svg><span>"
                       + T("الأكثر مبيعًا", "Best Seller") + "</span></span>";
            if (p.IsNew)
                return "<span class=\"product-badge\"><span>" + T("جديد", "New") + "</span></span>";
            return string.Empty;
        }
    }
}
