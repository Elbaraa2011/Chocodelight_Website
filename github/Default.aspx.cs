using System;
using Chocodelight_Website.DataAccess;
using Chocodelight_Website.Helpers;
using Chocodelight_Website.Models;

namespace Chocodelight_Website
{
    public partial class DefaultPage : BasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                var featured = ProductRepository.GetFeatured(8);
                foreach (var p in featured)
                {
                    var full = ProductRepository.GetById(p.Id);
                    if (full != null) p.WeightOptions = full.WeightOptions;
                }
                rptFeatured.DataSource = featured;
                rptFeatured.DataBind();
            }
        }

        protected string GetName(object item) { return ((Product)item).Name; }
        protected string GetCategoryName(object item) { return ((Product)item).CategoryName; }
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
