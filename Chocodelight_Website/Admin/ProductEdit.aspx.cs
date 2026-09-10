using System;
using System.Globalization;
using System.Linq;
using System.Web.UI.WebControls;
using Chocodelight_Website.DataAccess;
using Chocodelight_Website.Helpers;
using Chocodelight_Website.Models;

namespace Chocodelight_Website.Admin
{
    public partial class AdminProductEditPage : BaseAdminPage
    {
        private int _productId;
        private bool IsEdit { get { return _productId > 0; } }

        protected void Page_Load(object sender, EventArgs e)
        {
            int.TryParse(Request.QueryString["id"], out _productId);

            if (!IsPostBack)
            {
                BindCategories();
                litTitle.Text = litHeading.Text = IsEdit ? "تعديل منتج" : "منتج جديد";
                btnDelete.Visible = IsEdit;

                if (IsEdit)
                {
                    var p = ProductRepository.GetById(_productId);
                    if (p == null) { Response.Redirect("~/Admin/Products.aspx"); return; }
                    LoadProduct(p);
                }
            }
        }

        private void BindCategories()
        {
            ddlCategory.Items.Clear();
            foreach (var c in CategoryRepository.GetAll(activeOnly: false))
                ddlCategory.Items.Add(new ListItem(c.NameAr + " / " + c.NameEn, c.Id.ToString()));
        }

        private void LoadProduct(Product p)
        {
            txtNameAr.Text = p.NameAr;
            txtNameEn.Text = p.NameEn;
            txtDescAr.Text = p.DescriptionAr;
            txtDescEn.Text = p.DescriptionEn;
            if (ddlCategory.Items.FindByValue(p.CategoryId.ToString()) != null)
                ddlCategory.SelectedValue = p.CategoryId.ToString();
            txtBasePrice.Text = p.BasePrice.ToString("0.##", CultureInfo.InvariantCulture);
            txtWeightNoteAr.Text = p.WeightNoteAr;
            txtWeightNoteEn.Text = p.WeightNoteEn;
            txtSortOrder.Text = p.SortOrder.ToString();
            chkActive.Checked = p.IsActive;
            chkBestSeller.Checked = p.IsBestSeller;
            chkNew.Checked = p.IsNew;

            txtWeightOptions.Text = string.Join(Environment.NewLine,
                p.WeightOptions.OrderBy(w => w.SortOrder).ThenBy(w => w.Price)
                 .Select(w => w.LabelAr + " | " + w.LabelEn + " | " + (w.Weight ?? "") + " | " +
                              w.Price.ToString("0.##", CultureInfo.InvariantCulture)));

            txtFlavors.Text = string.Join(Environment.NewLine,
                p.Flavors.OrderBy(f => f.SortOrder).Select(f => f.NameAr + " | " + f.NameEn));
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            decimal basePrice;
            if (!decimal.TryParse(txtBasePrice.Text.Trim(), NumberStyles.Any, CultureInfo.InvariantCulture, out basePrice) || basePrice < 0)
            {
                ShowError("السعر الأساسي غير صحيح.");
                return;
            }

            int sortOrder;
            int.TryParse(txtSortOrder.Text.Trim(), out sortOrder);

            int categoryId;
            int.TryParse(ddlCategory.SelectedValue, out categoryId);

            var product = new Product
            {
                Id = _productId,
                CategoryId = categoryId,
                NameAr = txtNameAr.Text.Trim(),
                NameEn = txtNameEn.Text.Trim(),
                DescriptionAr = NullIfBlank(txtDescAr.Text),
                DescriptionEn = NullIfBlank(txtDescEn.Text),
                BasePrice = basePrice,
                WeightNoteAr = NullIfBlank(txtWeightNoteAr.Text),
                WeightNoteEn = NullIfBlank(txtWeightNoteEn.Text),
                IsActive = chkActive.Checked,
                IsBestSeller = chkBestSeller.Checked,
                IsNew = chkNew.Checked,
                SortOrder = sortOrder
            };

            int id;
            if (IsEdit)
            {
                ProductRepository.Update(product);
                id = _productId;
            }
            else
            {
                id = ProductRepository.Insert(product);
            }

            SaveWeightOptions(id);
            SaveFlavors(id);

            Response.Redirect("~/Admin/Products.aspx");
        }

        private void SaveFlavors(int productId)
        {
            ProductRepository.ClearFlavors(productId);

            var lines = (txtFlavors.Text ?? "").Split(new[] { '\r', '\n' }, StringSplitOptions.RemoveEmptyEntries);
            int order = 0;
            foreach (var raw in lines)
            {
                var parts = raw.Split('|');
                if (parts.Length < 2) continue;
                string ar = parts[0].Trim(), en = parts[1].Trim();
                if (ar.Length == 0 || en.Length == 0) continue;

                ProductRepository.AddFlavor(new ProductFlavor
                {
                    ProductId = productId,
                    NameAr = ar,
                    NameEn = en,
                    SortOrder = order++
                });
            }
        }

        private void SaveWeightOptions(int productId)
        {
            ProductRepository.ClearWeightOptions(productId);

            var lines = (txtWeightOptions.Text ?? "").Split(new[] { '\r', '\n' }, StringSplitOptions.RemoveEmptyEntries);
            int order = 0;
            foreach (var raw in lines)
            {
                var parts = raw.Split('|');
                if (parts.Length < 4) continue;

                decimal price;
                if (!decimal.TryParse(parts[3].Trim(), NumberStyles.Any, CultureInfo.InvariantCulture, out price) || price < 0)
                    continue;

                ProductRepository.AddWeightOption(new ProductWeightOption
                {
                    ProductId = productId,
                    LabelAr = parts[0].Trim(),
                    LabelEn = parts[1].Trim(),
                    Weight = NullIfBlank(parts[2]),
                    Price = price,
                    SortOrder = order++
                });
            }
        }

        protected void btnDelete_Click(object sender, EventArgs e)
        {
            if (!IsEdit) return;
            ProductRepository.Delete(_productId);
            Response.Redirect("~/Admin/Products.aspx");
        }

        private static string NullIfBlank(string s)
        {
            return string.IsNullOrWhiteSpace(s) ? null : s.Trim();
        }

        private void ShowError(string msg)
        {
            pnlError.Visible = true;
            litError.Text = Server.HtmlEncode(msg);
        }
    }
}
