using System;
using System.Globalization;
using System.Linq;
using System.Web.UI;
using Chocodelight_Website.DataAccess;
using Chocodelight_Website.Helpers;
using Chocodelight_Website.Models;
using Chocodelight_Website.Services;

namespace Chocodelight_Website
{
    public partial class ProductPage : BasePage
    {
        private Product _product;

        public string PageTitle { get; private set; }
        public string JsBasePrice { get; private set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            int id;
            if (!int.TryParse(Request.QueryString["id"], out id) || id <= 0)
            {
                ShowNotFound();
                return;
            }

            _product = ProductRepository.GetById(id);
            if (_product == null || !_product.IsActive)
            {
                ShowNotFound();
                return;
            }

            PageTitle = _product.Name + " — Choco Delight";
            JsBasePrice = _product.BasePrice.ToString(CultureInfo.InvariantCulture);

            if (!IsPostBack)
                BindProduct();
        }

        private void ShowNotFound()
        {
            pnlProduct.Visible = false;
            pnlNotFound.Visible = true;
            PageTitle = T("المنتج مش موجود", "Product not found");
        }

        private void BindProduct()
        {
            litCrumb.Text = Server.HtmlEncode(_product.Name);
            litCat.Text = Server.HtmlEncode(_product.CategoryName);
            litTitle.Text = Server.HtmlEncode(_product.Name);
            litDesc.Text = Server.HtmlEncode(_product.Description ?? string.Empty);

            decimal startPrice = _product.DisplayFromPrice;
            litPrice.Text = CultureHelper.Money(startPrice);
            litPriceNote.Text = Server.HtmlEncode(_product.WeightNote ?? string.Empty);

            if (_product.IsBestSeller)
                litBadge.Text = "<span class=\"pdp-badge\"><svg viewBox=\"0 0 24 24\"><use href=\"#ic-star\"/></svg><span>"
                                + T("الأكثر مبيعًا", "Best Seller") + "</span></span>";
            else if (_product.IsNew)
                litBadge.Text = "<span class=\"pdp-badge\"><span>" + T("جديد", "New") + "</span></span>";

            if (_product.HasWeightOptions)
            {
                var ordered = _product.WeightOptions.OrderBy(w => w.SortOrder).ThenBy(w => w.Price).ToList();
                rptWeights.DataSource = ordered;
                rptWeights.DataBind();
                hfWeightId.Value = ordered[0].Id.ToString();
            }
            else
            {
                pnlWeights.Visible = false;
            }

            if (_product.HasFlavors)
            {
                var flavors = _product.Flavors.OrderBy(f => f.SortOrder).ToList();
                pnlFlavors.Visible = true;
                rptFlavors.DataSource = flavors;
                rptFlavors.DataBind();
                hfFlavorAr.Value = flavors[0].NameAr;
                hfFlavorEn.Value = flavors[0].NameEn;
            }

            if (!string.IsNullOrWhiteSpace(_product.Description))
            {
                pnlLongDesc.Visible = true;
                litLongDesc.Text = Server.HtmlEncode(_product.Description);
            }

            btnAddToCart.Text = T("أضف للسلة", "Add to Cart");

            var related = ProductRepository.GetList(categoryId: _product.CategoryId, activeOnly: true)
                                           .Where(p => p.Id != _product.Id)
                                           .Take(3)
                                           .ToList();
            if (related.Count > 0)
            {
                pnlRelated.Visible = true;
                rptRelated.DataSource = related;
                rptRelated.DataBind();
            }
        }

        protected void btnAddToCart_Click(object sender, EventArgs e)
        {
            int id;
            if (_product == null || !int.TryParse(Request.QueryString["id"], out id))
            {
                ShowNotFound();
                return;
            }

            // Re-fetch to validate against the live catalogue (never trust posted price).
            var product = ProductRepository.GetById(id);
            if (product == null || !product.IsActive)
            {
                ShowNotFound();
                return;
            }

            int qty;
            if (!int.TryParse(hfQty.Value, out qty) || qty < 1) qty = 1;
            if (qty > 99) qty = 99;

            ProductWeightOption chosen = null;
            int weightId;
            if (int.TryParse(hfWeightId.Value, out weightId) && weightId > 0)
                chosen = product.WeightOptions.FirstOrDefault(w => w.Id == weightId);

            if (product.HasWeightOptions && chosen == null)
                chosen = product.WeightOptions.OrderBy(w => w.SortOrder).ThenBy(w => w.Price).First();

            decimal unitPrice = chosen != null ? chosen.Price : product.BasePrice;

            // Validate the posted flavour against the live list.
            string flavorAr = null, flavorEn = null;
            if (product.HasFlavors)
            {
                var match = product.Flavors.FirstOrDefault(f =>
                    f.NameAr == hfFlavorAr.Value || f.NameEn == hfFlavorEn.Value);
                if (match == null) match = product.Flavors.OrderBy(f => f.SortOrder).First();
                flavorAr = match.NameAr;
                flavorEn = match.NameEn;
            }

            CartManager.Add(new CartItem
            {
                ProductId = product.Id,
                ProductNameAr = product.NameAr,
                ProductNameEn = product.NameEn,
                WeightOptionId = chosen?.Id,
                WeightLabelAr = chosen?.LabelAr,
                WeightLabelEn = chosen?.LabelEn,
                FlavorAr = flavorAr,
                FlavorEn = flavorEn,
                UnitPrice = unitPrice,
                Quantity = qty,
                ImageUrl = product.ImageUrl
            });

            Response.Redirect("~/Cart.aspx");
        }

        protected string GetPName(object item) { return ((Product)item).Name; }
        protected string GetCatName(object item) { return ((Product)item).CategoryName; }
    }
}
