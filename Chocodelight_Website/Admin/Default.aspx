<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true"
    CodeBehind="Default.aspx.cs" Inherits="Chocodelight_Website.Admin.AdminDashboardPage" %>

<asp:Content ContentPlaceHolderID="TitleContent" runat="server">لوحة التحكم — Choco Delight</asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
  <div class="admin-page-head">
    <div>
      <h1>لوحة التحكم</h1>
      <p class="admin-page-sub">نظرة سريعة على أداء المتجر ومتابعة آخر الطلبات</p>
    </div>
    <span class="admin-page-date"><asp:Literal ID="litToday" runat="server" /></span>
  </div>

  <div class="stats-grid">
    <div class="stat-card">
      <div class="stat-icon"><svg viewBox="0 0 24 24"><use href="#ic-receipt"/></svg></div>
      <div><div class="stat-value"><asp:Literal ID="litTotalOrders" runat="server" /></div>
        <div class="stat-label">إجمالي الطلبات</div></div>
    </div>
    <div class="stat-card is-accent">
      <div class="stat-icon"><svg viewBox="0 0 24 24"><use href="#ic-clock"/></svg></div>
      <div><div class="stat-value"><asp:Literal ID="litPending" runat="server" /></div>
        <div class="stat-label">طلبات قيد المراجعة</div></div>
    </div>
    <div class="stat-card">
      <div class="stat-icon"><svg viewBox="0 0 24 24"><use href="#ic-cash"/></svg></div>
      <div><div class="stat-value"><asp:Literal ID="litTodayRevenue" runat="server" /></div>
        <div class="stat-label">مبيعات اليوم</div></div>
    </div>
    <div class="stat-card">
      <div class="stat-icon"><svg viewBox="0 0 24 24"><use href="#ic-cash"/></svg></div>
      <div><div class="stat-value"><asp:Literal ID="litDeliveredRevenue" runat="server" /></div>
        <div class="stat-label">إجمالي المبيعات المسلّمة</div></div>
    </div>
    <div class="stat-card">
      <div class="stat-icon"><svg viewBox="0 0 24 24"><use href="#ic-box"/></svg></div>
      <div><div class="stat-value"><asp:Literal ID="litProducts" runat="server" /></div>
        <div class="stat-label">منتجات مفعّلة</div></div>
    </div>
    <div class="stat-card">
      <div class="stat-icon"><svg viewBox="0 0 24 24"><use href="#ic-user"/></svg></div>
      <div><div class="stat-value"><asp:Literal ID="litCustomers" runat="server" /></div>
        <div class="stat-label">عملاء مسجّلين</div></div>
    </div>
  </div>

  <section class="admin-panel" style="margin-block-start:var(--sp-6);">
    <div class="admin-panel-head">
      <h2>آخر الطلبات</h2>
      <a class="admin-table-link" href="<%= ResolveUrl("~/Admin/Orders.aspx") %>">عرض الكل</a>
    </div>
    <div class="table-wrap">
      <table class="admin-table">
        <thead>
          <tr><th>رقم الطلب</th><th>العميل</th><th>التاريخ</th><th>الحالة</th><th>الإجمالي</th><th></th></tr>
        </thead>
        <tbody>
          <asp:Repeater ID="rptRecent" runat="server">
            <ItemTemplate>
              <tr>
                <td class="order-num">#<%# Eval("OrderNumber") %></td>
                <td><%# Server.HtmlEncode((string)Eval("RecipientName")) %></td>
                <td><%# ((System.DateTime)Eval("CreatedAt")).ToString("yyyy-MM-dd") %></td>
                <td><span class="status-pill"><%# Chocodelight_Website.Models.OrderStatus.LabelAr((string)Eval("Status")) %></span></td>
                <td><%# Chocodelight_Website.Helpers.CultureHelper.Money((decimal)Eval("Total")) %></td>
                <td><a class="admin-table-link" href='<%# ResolveUrl("~/Admin/OrderDetail.aspx?id=" + Eval("Id")) %>'>عرض</a></td>
              </tr>
            </ItemTemplate>
          </asp:Repeater>
        </tbody>
      </table>
    </div>
  </section>
</asp:Content>
