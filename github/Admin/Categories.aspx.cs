using System;
using System.Web.UI.WebControls;
using Chocodelight_Website.DataAccess;
using Chocodelight_Website.Helpers;
using Chocodelight_Website.Models;

namespace Chocodelight_Website.Admin
{
    public partial class AdminCategoriesPage : BaseAdminPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack) BindGrid();
        }

        private void BindGrid()
        {
            rptCats.DataSource = CategoryRepository.GetAll(activeOnly: false);
            rptCats.DataBind();
        }

        private void ResetForm()
        {
            hfEditId.Value = "0";
            txtNameAr.Text = txtNameEn.Text = txtSlug.Text = "";
            litFormTitle.Text = "إضافة تصنيف";
            btnCancel.Visible = false;
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            string slug = txtSlug.Text.Trim().ToLowerInvariant().Replace(" ", "-");
            var cat = new Category
            {
                NameAr = txtNameAr.Text.Trim(),
                NameEn = txtNameEn.Text.Trim(),
                Slug = slug,
                IsActive = true,
                SortOrder = 0
            };

            int editId;
            int.TryParse(hfEditId.Value, out editId);

            try
            {
                if (editId > 0)
                {
                    var existing = CategoryRepository.GetById(editId);
                    if (existing == null) { ShowError("التصنيف غير موجود."); return; }
                    cat.Id = editId;
                    cat.SortOrder = existing.SortOrder;
                    cat.IsActive = existing.IsActive;
                    CategoryRepository.Update(cat);
                    ShowMsg("تم تحديث التصنيف.");
                }
                else
                {
                    CategoryRepository.Insert(cat);
                    ShowMsg("تم إضافة التصنيف.");
                }
            }
            catch (Exception ex)
            {
                ShowError("تعذّر الحفظ — تأكد إن الـ Slug مش مكرر. " );
                System.Diagnostics.Trace.TraceError(ex.ToString());
                return;
            }

            ResetForm();
            BindGrid();
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            ResetForm();
        }

        protected void rptCats_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int id;
            if (!int.TryParse(Convert.ToString(e.CommandArgument), out id)) return;

            if (e.CommandName == "edit")
            {
                var c = CategoryRepository.GetById(id);
                if (c == null) return;
                hfEditId.Value = c.Id.ToString();
                txtNameAr.Text = c.NameAr;
                txtNameEn.Text = c.NameEn;
                txtSlug.Text = c.Slug;
                litFormTitle.Text = "تعديل تصنيف";
                btnCancel.Visible = true;
            }
            else if (e.CommandName == "del")
            {
                try
                {
                    CategoryRepository.Delete(id);
                    ShowMsg("تم حذف التصنيف.");
                }
                catch (Exception)
                {
                    ShowError("مينفعش تحذف تصنيف فيه منتجات.");
                }
                ResetForm();
                BindGrid();
            }
        }

        private void ShowMsg(string m) { pnlMsg.Visible = true; litMsg.Text = Server.HtmlEncode(m); }
        private void ShowError(string m) { pnlError.Visible = true; litError.Text = Server.HtmlEncode(m); }
    }
}
