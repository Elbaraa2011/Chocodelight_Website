<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true"
    CodeBehind="Orders.aspx.cs" Inherits="Chocodelight_Website.Admin.AdminOrdersPage" %>

<asp:Content ContentPlaceHolderID="TitleContent" runat="server">إدارة الطلبات — Choco Delight</asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
  <div class="admin-page-head">
    <div>
      <h1>إدارة الطلبات</h1>
      <p class="admin-page-sub">راجع الطلبات وحدّث حالتها</p>
    </div>
  </div>

  <asp:Panel ID="pnlMsg" runat="server" Visible="false" CssClass="form-success" style="display:block;margin-block-end:var(--sp-4);">
    <asp:Literal ID="litMsg" runat="server" />
  </asp:Panel>

  <section class="admin-panel">
    <div class="admin-toolbar">
      <div class="admin-search">
        <svg viewBox="0 0 24 24"><use href="#ic-search"/></svg>
        <asp:TextBox ID="txtSearch" runat="server" placeholder="ابحث برقم الطلب أو اسم العميل / التليفون" />
      </div>
      <asp:Button ID="btnSearch" runat="server" CssClass="btn btn-ghost" Text="بحث" OnClick="btnSearch_Click" />
    </div>

    <div class="filter-tabs" role="group" aria-label="Filter by status" style="padding-inline:var(--sp-5);">
      <asp:Repeater ID="rptFilters" runat="server">
        <ItemTemplate>
          <a class='filter-tab <%# (string)Eval("Key") == CurrentStatus ? "is-active" : "" %>'
             href='<%# FilterUrl((string)Eval("Key")) %>'>
            <span><%# GetFilterLabel((string)Eval("Key")) %></span> <span class="count">(<%# Eval("Value") %>)</span>
          </a>
        </ItemTemplate>
      </asp:Repeater>
    </div>

    <div class="table-wrap">
      <table class="admin-table">
        <thead>
          <tr><th>رقم الطلب</th><th>العميل</th><th>التليفون</th><th>المنطقة</th><th>التاريخ</th><th>الحالة</th><th>الإجمالي</th><th></th></tr>
        </thead>
        <tbody>
          <asp:Repeater ID="rptOrders" runat="server" OnItemDataBound="rptOrders_ItemDataBound">
            <ItemTemplate>
              <tr>
                <td class="order-num">#<%# Eval("OrderNumber") %></td>
                <td><%# Server.HtmlEncode((string)Eval("RecipientName")) %></td>
                <td><%# Eval("RecipientPhone") %></td>
                <td><%# Server.HtmlEncode((string)Eval("ZoneNameSnapshot")) %></td>
                <td><%# ((System.DateTime)Eval("CreatedAt")).ToString("yyyy-MM-dd") %></td>
                <td>
                  <asp:HiddenField runat="server" ID="hfOrderId" Value='<%# Eval("Id") %>' />
                  <asp:DropDownList runat="server" ID="ddlStatus" CssClass="status-select"
                    AutoPostBack="true" OnSelectedIndexChanged="ddlStatus_Changed" />
                </td>
                <td><%# Chocodelight_Website.Helpers.CultureHelper.Money((decimal)Eval("Total")) %></td>
                <td><a class="admin-table-link" href='<%# ResolveUrl("~/Admin/OrderDetail.aspx?id=" + Eval("Id")) %>'>عرض</a></td>
              </tr>
            </ItemTemplate>
          </asp:Repeater>
        </tbody>
      </table>
    </div>

    <asp:Panel ID="pnlEmpty" runat="server" Visible="false" style="padding:var(--sp-6);color:var(--text-muted);">
      لا توجد طلبات مطابقة.
    </asp:Panel>

    <div class="admin-pager" style="display:flex;gap:var(--sp-3);justify-content:center;padding:var(--sp-4);">
      <asp:HyperLink ID="lnkPrev" runat="server" CssClass="btn btn-ghost" Text="السابق" Visible="false" />
      <asp:HyperLink ID="lnkNext" runat="server" CssClass="btn btn-ghost" Text="التالي" Visible="false" />
    </div>
  </section>
</asp:Content>
