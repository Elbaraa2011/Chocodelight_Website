<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true"
    CodeBehind="ProductEdit.aspx.cs" Inherits="Chocodelight_Website.Admin.AdminProductEditPage" %>

<asp:Content ContentPlaceHolderID="TitleContent" runat="server">
  <asp:Literal ID="litTitle" runat="server" /> — Choco Delight
</asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
  <div class="admin-page-head">
    <div><h1><asp:Literal ID="litHeading" runat="server" /></h1></div>
    <a class="admin-table-link" href="<%= ResolveUrl("~/Admin/Products.aspx") %>">&larr; كل المنتجات</a>
  </div>

  <asp:Panel ID="pnlError" runat="server" Visible="false" CssClass="field-error" style="display:block;margin-block-end:var(--sp-4);">
    <asp:Literal ID="litError" runat="server" />
  </asp:Panel>

  <section class="admin-panel">
    <div style="padding:var(--sp-6);display:grid;grid-template-columns:1fr 1fr;gap:var(--sp-5);">

      <div class="form-field">
        <label class="form-label">الاسم (عربي)</label>
        <asp:TextBox ID="txtNameAr" runat="server" CssClass="form-input" MaxLength="150" />
        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtNameAr" CssClass="field-error" Display="Dynamic" Text="مطلوب" ValidationGroup="p" />
      </div>
      <div class="form-field">
        <label class="form-label">الاسم (إنجليزي)</label>
        <asp:TextBox ID="txtNameEn" runat="server" CssClass="form-input" MaxLength="150" />
        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtNameEn" CssClass="field-error" Display="Dynamic" Text="Required" ValidationGroup="p" />
      </div>

      <div class="form-field">
        <label class="form-label">الوصف (عربي)</label>
        <asp:TextBox ID="txtDescAr" runat="server" CssClass="form-textarea" TextMode="MultiLine" Rows="3" MaxLength="2000" />
      </div>
      <div class="form-field">
        <label class="form-label">الوصف (إنجليزي)</label>
        <asp:TextBox ID="txtDescEn" runat="server" CssClass="form-textarea" TextMode="MultiLine" Rows="3" MaxLength="2000" />
      </div>

      <div class="form-field">
        <label class="form-label">المجموعة</label>
        <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-select" />
      </div>
      <div class="form-field">
        <label class="form-label">السعر الأساسي (جنيه)</label>
        <asp:TextBox ID="txtBasePrice" runat="server" CssClass="form-input" TextMode="Number" />
        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtBasePrice" CssClass="field-error" Display="Dynamic" Text="مطلوب" ValidationGroup="p" />
        <asp:RangeValidator runat="server" ControlToValidate="txtBasePrice" Type="Currency" MinimumValue="0" MaximumValue="1000000"
          CssClass="field-error" Display="Dynamic" Text="رقم غير صحيح" ValidationGroup="p" />
      </div>

      <div class="form-field">
        <label class="form-label">ملاحظة الوزن (عربي) — مثال: لعبوة 300 جم</label>
        <asp:TextBox ID="txtWeightNoteAr" runat="server" CssClass="form-input" MaxLength="100" />
      </div>
      <div class="form-field">
        <label class="form-label">ملاحظة الوزن (إنجليزي)</label>
        <asp:TextBox ID="txtWeightNoteEn" runat="server" CssClass="form-input" MaxLength="100" />
      </div>

      <div class="form-field">
        <label class="form-label">ترتيب العرض</label>
        <asp:TextBox ID="txtSortOrder" runat="server" CssClass="form-input" TextMode="Number" Text="0" />
      </div>
      <div class="form-field" style="display:flex;gap:var(--sp-5);align-items:center;flex-wrap:wrap;">
        <label class="check-label"><asp:CheckBox ID="chkActive" runat="server" Checked="true" /> مفعّل</label>
        <label class="check-label"><asp:CheckBox ID="chkBestSeller" runat="server" /> الأكثر مبيعًا</label>
        <label class="check-label"><asp:CheckBox ID="chkNew" runat="server" /> جديد</label>
      </div>

      <div class="form-field" style="grid-column:1 / -1;">
        <label class="form-label">خيارات الوزن (اختياري) — سطر لكل خيار بالشكل: <code>الاسم عربي | الاسم إنجليزي | الوزن | السعر</code></label>
        <asp:TextBox ID="txtWeightOptions" runat="server" CssClass="form-textarea" TextMode="MultiLine" Rows="4"
          placeholder="200 جم | 200g | 200g | 180&#10;300 جم | 300g | 300g | 260" />
      </div>

      <div class="form-field" style="grid-column:1 / -1;">
        <label class="form-label">النكهات (اختياري) — سطر لكل نكهة بالشكل: <code>الاسم عربي | الاسم إنجليزي</code></label>
        <asp:TextBox ID="txtFlavors" runat="server" CssClass="form-textarea" TextMode="MultiLine" Rows="3"
          placeholder="كيندر | Kinder&#10;لوتس | Lotus" />
      </div>
    </div>

    <div style="padding:var(--sp-5) var(--sp-6);border-block-start:1px solid var(--line);display:flex;gap:var(--sp-3);">
      <asp:Button ID="btnSave" runat="server" CssClass="btn btn-primary btn-lg" Text="حفظ" ValidationGroup="p" OnClick="btnSave_Click" />
      <asp:Button ID="btnDelete" runat="server" CssClass="btn btn-ghost" Text="حذف المنتج" Visible="false"
        OnClick="btnDelete_Click" OnClientClick="return confirm('متأكد من حذف المنتج؟');" CausesValidation="false" />
    </div>
  </section>
</asp:Content>
