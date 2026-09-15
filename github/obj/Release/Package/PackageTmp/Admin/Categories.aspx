<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true"
    CodeBehind="Categories.aspx.cs" Inherits="Chocodelight_Website.Admin.AdminCategoriesPage" %>

<asp:Content ContentPlaceHolderID="TitleContent" runat="server">التصنيفات — Choco Delight</asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
  <div class="admin-page-head">
    <div><h1>التصنيفات</h1><p class="admin-page-sub">مجموعات المنتجات</p></div>
  </div>

  <asp:Panel ID="pnlMsg" runat="server" Visible="false" CssClass="form-success" style="display:block;margin-block-end:var(--sp-4);">
    <asp:Literal ID="litMsg" runat="server" />
  </asp:Panel>
  <asp:Panel ID="pnlError" runat="server" Visible="false" CssClass="field-error" style="display:block;margin-block-end:var(--sp-4);">
    <asp:Literal ID="litError" runat="server" />
  </asp:Panel>

  <section class="admin-panel">
    <div class="admin-panel-head"><h2><asp:Literal ID="litFormTitle" runat="server" Text="إضافة تصنيف" /></h2></div>
    <div style="padding:var(--sp-5);display:grid;grid-template-columns:1fr 1fr 1fr auto;gap:var(--sp-4);align-items:flex-end;">
      <asp:HiddenField ID="hfEditId" runat="server" Value="0" />
      <div class="form-field" style="margin:0;">
        <label class="form-label">الاسم (عربي)</label>
        <asp:TextBox ID="txtNameAr" runat="server" CssClass="form-input" MaxLength="100" />
        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtNameAr" CssClass="field-error" Display="Dynamic" Text="مطلوب" ValidationGroup="c" />
      </div>
      <div class="form-field" style="margin:0;">
        <label class="form-label">الاسم (إنجليزي)</label>
        <asp:TextBox ID="txtNameEn" runat="server" CssClass="form-input" MaxLength="100" />
        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtNameEn" CssClass="field-error" Display="Dynamic" Text="Required" ValidationGroup="c" />
      </div>
      <div class="form-field" style="margin:0;">
        <label class="form-label">Slug (إنجليزي بدون مسافات)</label>
        <asp:TextBox ID="txtSlug" runat="server" CssClass="form-input" MaxLength="60" />
        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtSlug" CssClass="field-error" Display="Dynamic" Text="مطلوب" ValidationGroup="c" />
      </div>
      <div style="display:flex;gap:var(--sp-2);">
        <asp:Button ID="btnSave" runat="server" CssClass="btn btn-primary" Text="حفظ" ValidationGroup="c" OnClick="btnSave_Click" />
        <asp:Button ID="btnCancel" runat="server" CssClass="btn btn-ghost" Text="إلغاء" CausesValidation="false" OnClick="btnCancel_Click" Visible="false" />
      </div>
    </div>
  </section>

  <section class="admin-panel" style="margin-block-start:var(--sp-5);">
    <div class="table-wrap">
      <table class="admin-table">
        <thead><tr><th>عربي</th><th>إنجليزي</th><th>Slug</th><th>الترتيب</th><th>الحالة</th><th></th></tr></thead>
        <tbody>
          <asp:Repeater ID="rptCats" runat="server" OnItemCommand="rptCats_ItemCommand">
            <ItemTemplate>
              <tr>
                <td><%# Server.HtmlEncode((string)Eval("NameAr")) %></td>
                <td><%# Server.HtmlEncode((string)Eval("NameEn")) %></td>
                <td><code><%# Eval("Slug") %></code></td>
                <td><%# Eval("SortOrder") %></td>
                <td><%# (bool)Eval("IsActive") ? "مفعّل" : "موقوف" %></td>
                <td>
                  <div class="admin-table-actions">
                    <asp:LinkButton runat="server" CssClass="admin-table-link" CommandName="edit" CommandArgument='<%# Eval("Id") %>' Text="تعديل" CausesValidation="false" />
                    <asp:LinkButton runat="server" CssClass="admin-table-link" CommandName="del" CommandArgument='<%# Eval("Id") %>' Text="حذف" CausesValidation="false"
                      OnClientClick="return confirm('حذف التصنيف؟ (لازم يكون فاضي من المنتجات)');" />
                  </div>
                </td>
              </tr>
            </ItemTemplate>
          </asp:Repeater>
        </tbody>
      </table>
    </div>
  </section>
</asp:Content>
