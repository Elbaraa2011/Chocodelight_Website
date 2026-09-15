<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true"
    CodeBehind="Products.aspx.cs" Inherits="Chocodelight_Website.Admin.AdminProductsPage" %>

<asp:Content ContentPlaceHolderID="TitleContent" runat="server">إدارة المنتجات — Choco Delight</asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
  <div class="admin-page-head">
    <div>
      <h1>إدارة المنتجات</h1>
      <p class="admin-page-sub">أضف، عدّل، أو أوقف المنتجات</p>
    </div>
    <a class="btn btn-primary" href="<%= ResolveUrl("~/Admin/ProductEdit.aspx") %>">
      <svg viewBox="0 0 24 24" width="16" height="16" style="stroke:currentColor;fill:none;stroke-width:2"><use href="#ic-plus"/></svg>
      منتج جديد
    </a>
  </div>

  <asp:Panel ID="pnlMsg" runat="server" Visible="false" CssClass="form-success" style="display:block;margin-block-end:var(--sp-4);">
    <asp:Literal ID="litMsg" runat="server" />
  </asp:Panel>

  <section class="admin-panel">
    <div class="admin-toolbar">
      <div class="admin-search">
        <svg viewBox="0 0 24 24"><use href="#ic-search"/></svg>
        <asp:TextBox ID="txtSearch" runat="server" placeholder="ابحث باسم المنتج" />
      </div>
      <asp:Button ID="btnSearch" runat="server" CssClass="btn btn-ghost" Text="بحث" OnClick="btnSearch_Click" />
    </div>

    <div class="filter-tabs" role="group" style="padding-inline:var(--sp-5);">
      <asp:Repeater ID="rptCats" runat="server">
        <ItemTemplate>
          <a class='filter-tab <%# (string)Eval("Slug") == CurrentSlug ? "is-active" : "" %>'
             href='<%# Eval("Slug").ToString() == "all" ? ResolveUrl("~/Admin/Products.aspx") : ResolveUrl("~/Admin/Products.aspx?cat=" + Eval("Slug")) %>'>
            <span><%# Eval("NameAr") %></span>
          </a>
        </ItemTemplate>
      </asp:Repeater>
    </div>

    <div class="table-wrap">
      <table class="admin-table">
        <thead>
          <tr><th>المنتج</th><th>المجموعة</th><th>السعر</th><th>الحالة</th><th></th></tr>
        </thead>
        <tbody>
          <asp:Repeater ID="rptProducts" runat="server" OnItemCommand="rptProducts_ItemCommand">
            <ItemTemplate>
              <tr>
                <td>
                  <div class="product-name-cell">
                    <div class="product-thumb"><svg viewBox="0 0 100 100"><use href="#ic-hex"/></svg></div>
                    <span class="product-name-text"><%# Server.HtmlEncode((string)Eval("NameAr")) %></span>
                  </div>
                </td>
                <td><%# Server.HtmlEncode((string)Eval("CategoryNameAr")) %></td>
                <td><%# Chocodelight_Website.Helpers.CultureHelper.Money((decimal)Eval("BasePrice")) %></td>
                <td>
                  <asp:LinkButton runat="server" CssClass="status-toggle" CommandName="toggle" CommandArgument='<%# Eval("Id") %>'>
                    <span class="dot"></span>
                    <span class="txt"><%# (bool)Eval("IsActive") ? "مفعّل" : "موقوف" %></span>
                  </asp:LinkButton>
                </td>
                <td>
                  <div class="admin-table-actions">
                    <a class="admin-table-link" href='<%# ResolveUrl("~/Admin/ProductEdit.aspx?id=" + Eval("Id")) %>'>
                      <svg viewBox="0 0 24 24"><use href="#ic-edit"/></svg><span>تعديل</span>
                    </a>
                  </div>
                </td>
              </tr>
            </ItemTemplate>
          </asp:Repeater>
        </tbody>
      </table>
    </div>
    <asp:Panel ID="pnlEmpty" runat="server" Visible="false" style="padding:var(--sp-6);color:var(--text-muted);">لا توجد منتجات.</asp:Panel>
  </section>
</asp:Content>
