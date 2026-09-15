<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true"
    CodeBehind="OrderDetail.aspx.cs" Inherits="Chocodelight_Website.Admin.AdminOrderDetailPage" %>

<asp:Content ContentPlaceHolderID="TitleContent" runat="server">تفاصيل الطلب — Choco Delight</asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
  <asp:Panel ID="pnlNotFound" runat="server" Visible="false">
    <div class="admin-page-head"><div><h1>الطلب غير موجود</h1></div></div>
    <a class="btn btn-ghost" href="<%= ResolveUrl("~/Admin/Orders.aspx") %>">رجوع للطلبات</a>
  </asp:Panel>

  <asp:Panel ID="pnlOrder" runat="server">
    <div class="admin-page-head">
      <div>
        <h1>#<asp:Literal ID="litOrderNumber" runat="server" /></h1>
        <p class="admin-page-sub"><asp:Literal ID="litDate" runat="server" /></p>
      </div>
      <a class="admin-table-link" href="<%= ResolveUrl("~/Admin/Orders.aspx") %>">&larr; كل الطلبات</a>
    </div>

    <asp:Panel ID="pnlMsg" runat="server" Visible="false" CssClass="form-success" style="display:block;margin-block-end:var(--sp-4);">
      <asp:Literal ID="litMsg" runat="server" />
    </asp:Panel>

    <div class="admin-grid-2" style="display:grid;grid-template-columns:1.4fr 1fr;gap:var(--sp-6);align-items:start;">
      <div>
        <section class="admin-panel">
          <div class="admin-panel-head"><h2>تغيير حالة الطلب</h2></div>
          <div style="padding:var(--sp-5);display:flex;gap:var(--sp-3);flex-wrap:wrap;align-items:flex-end;">
            <div class="form-field" style="margin:0;">
              <label class="form-label">الحالة</label>
              <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-select" />
            </div>
            <div class="form-field" style="margin:0;flex:1;">
              <label class="form-label">ملاحظة (اختياري)</label>
              <asp:TextBox ID="txtNote" runat="server" CssClass="form-input" MaxLength="300" />
            </div>
            <asp:Button ID="btnUpdate" runat="server" CssClass="btn btn-primary" Text="حفظ الحالة" OnClick="btnUpdate_Click" />
          </div>
        </section>

        <section class="admin-panel" style="margin-block-start:var(--sp-5);">
          <div class="admin-panel-head"><h2>بيانات التوصيل</h2></div>
          <div class="info-block" style="padding:var(--sp-5);">
            <p><strong>المستلم:</strong> <asp:Literal ID="litRecipient" runat="server" /></p>
            <p><strong>التليفون:</strong> <asp:Literal ID="litPhone" runat="server" /></p>
            <p><strong>المنطقة:</strong> <asp:Literal ID="litZone" runat="server" /></p>
            <p><strong>العنوان:</strong> <asp:Literal ID="litAddress" runat="server" /></p>
            <asp:Panel ID="pnlLandmark" runat="server" Visible="false"><p><strong>علامة مميزة:</strong> <asp:Literal ID="litLandmark" runat="server" /></p></asp:Panel>
            <asp:Panel ID="pnlGift" runat="server" Visible="false"><p><strong>رسالة الهدية:</strong> <asp:Literal ID="litGift" runat="server" /></p></asp:Panel>
            <asp:Panel ID="pnlCustNote" runat="server" Visible="false"><p><strong>ملاحظات العميل:</strong> <asp:Literal ID="litCustNote" runat="server" /></p></asp:Panel>
          </div>
        </section>

        <section class="admin-panel" style="margin-block-start:var(--sp-5);">
          <div class="admin-panel-head"><h2>سجل الحالة</h2></div>
          <div style="padding:var(--sp-5);">
            <asp:Repeater ID="rptHistory" runat="server">
              <HeaderTemplate><ul style="list-style:none;padding:0;margin:0;display:flex;flex-direction:column;gap:var(--sp-2);"></HeaderTemplate>
              <ItemTemplate>
                <li style="padding:var(--sp-2) 0;border-block-end:1px solid var(--line);">
                  <strong><%# Chocodelight_Website.Models.OrderStatus.LabelAr((string)Eval("NewStatus")) %></strong>
                  <span style="color:var(--text-muted);"> — <%# ((System.DateTime)Eval("ChangedAt")).ToString("yyyy-MM-dd HH:mm") %></span>
                  <%# string.IsNullOrEmpty((string)Eval("Note")) ? "" : " · " + Server.HtmlEncode((string)Eval("Note")) %>
                </li>
              </ItemTemplate>
              <FooterTemplate></ul></FooterTemplate>
            </asp:Repeater>
          </div>
        </section>
      </div>

      <section class="admin-panel">
        <div class="admin-panel-head"><h2>محتوى الطلب</h2></div>
        <div style="padding:var(--sp-5);">
          <asp:Repeater ID="rptItems" runat="server">
            <ItemTemplate>
              <div class="summary-row">
                <span><%# Server.HtmlEncode(GetItemLabel(Container.DataItem)) %> &times; <%# Eval("Quantity") %></span>
                <span class="val"><%# Chocodelight_Website.Helpers.CultureHelper.Money((decimal)Eval("LineTotal")) %></span>
              </div>
            </ItemTemplate>
          </asp:Repeater>
          <div class="summary-divider"></div>
          <div class="summary-row"><span>الإجمالي الفرعي</span><span class="val"><asp:Literal ID="litSubtotal" runat="server" /></span></div>
          <div class="summary-row"><span>التوصيل</span><span class="val"><asp:Literal ID="litFee" runat="server" /></span></div>
          <div class="summary-divider"></div>
          <div class="summary-total"><span>الإجمالي</span><span class="val"><asp:Literal ID="litTotal" runat="server" /></span></div>
          <div class="summary-row" style="margin-block-start:var(--sp-3);"><span>الدفع</span><span class="val">عند الاستلام</span></div>
        </div>
      </section>
    </div>
  </asp:Panel>
</asp:Content>
