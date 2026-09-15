<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="OrderConfirmation.aspx.cs" Inherits="Chocodelight_Website.OrderConfirmationPage" %>

<asp:Content ContentPlaceHolderID="TitleContent" runat="server"><%= T("تم استلام طلبك","Order received") %> — Choco Delight</asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
  <section class="section">
    <div class="wrap">
      <asp:Panel ID="pnlNotFound" runat="server" Visible="false" style="text-align:center;padding-block:4rem;">
        <h1><%= T("الطلب مش موجود","Order not found") %></h1>
        <p><a class="btn btn-ghost" href="<%= ResolveUrl("~/Default.aspx") %>"><%= T("الرئيسية","Home") %></a></p>
      </asp:Panel>

      <asp:Panel ID="pnlOrder" runat="server">
        <div class="confirm-hero" style="text-align:center;padding-block:var(--sp-8);">
          <div class="auth-icon"><svg viewBox="0 0 24 24"><use href="#ic-check"/></svg></div>
          <h1><%= T("تم استلام طلبك بنجاح","Your order is in") %></h1>
          <p style="color:var(--text-muted);">
            <%= T("رقم الطلب","Order number") %>:
            <strong><asp:Literal ID="litOrderNumber" runat="server" /></strong>
          </p>
          <p style="color:var(--text-muted);max-width:46ch;margin-inline:auto;">
            <%= T("هنراجع الطلب ونتواصل معاك لتأكيد التوصيل. الدفع عند الاستلام.",
                  "We'll review your order and contact you to confirm delivery. Payment is on arrival.") %>
          </p>
        </div>

        <div class="checkout-layout" style="display:grid;grid-template-columns:1.4fr 1fr;gap:var(--sp-8);align-items:start;">
          <div>
            <h2 class="summary-title"><%= T("تفاصيل التوصيل","Delivery details") %></h2>
            <div class="info-block">
              <p><strong><%= T("المستلم","Recipient") %>:</strong> <asp:Literal ID="litRecipient" runat="server" /></p>
              <p><strong><%= T("التليفون","Phone") %>:</strong> <asp:Literal ID="litPhone" runat="server" /></p>
              <p><strong><%= T("المنطقة","Area") %>:</strong> <asp:Literal ID="litZone" runat="server" /></p>
              <p><strong><%= T("العنوان","Address") %>:</strong> <asp:Literal ID="litAddress" runat="server" /></p>
              <asp:Panel ID="pnlLandmark" runat="server" Visible="false">
                <p><strong><%= T("علامة مميزة","Landmark") %>:</strong> <asp:Literal ID="litLandmark" runat="server" /></p>
              </asp:Panel>
              <asp:Panel ID="pnlGift" runat="server" Visible="false">
                <p><strong><%= T("رسالة الهدية","Gift message") %>:</strong> <asp:Literal ID="litGift" runat="server" /></p>
              </asp:Panel>
            </div>
          </div>

          <div class="summary-card">
            <h2 class="summary-title"><%= T("ملخص الطلب","Order summary") %></h2>
            <asp:Repeater ID="rptItems" runat="server">
              <ItemTemplate>
                <div class="summary-row">
                  <span><%# Server.HtmlEncode(GetItemLabel(Container.DataItem)) %> &times; <%# Eval("Quantity") %></span>
                  <span class="val"><%# Chocodelight_Website.Helpers.CultureHelper.Money((decimal)Eval("LineTotal")) %></span>
                </div>
              </ItemTemplate>
            </asp:Repeater>
            <div class="summary-divider"></div>
            <div class="summary-row"><span><%= T("الإجمالي الفرعي","Subtotal") %></span><span class="val"><asp:Literal ID="litSubtotal" runat="server" /></span></div>
            <div class="summary-row"><span><%= T("التوصيل","Delivery") %></span><span class="val"><asp:Literal ID="litFee" runat="server" /></span></div>
            <div class="summary-divider"></div>
            <div class="summary-total"><span><%= T("الإجمالي","Total") %></span><span class="val"><asp:Literal ID="litTotal" runat="server" /></span></div>
            <a class="btn btn-ghost btn-lg" style="margin-block-start:var(--sp-6);" href="<%= ResolveUrl("~/Menu.aspx") %>"><%= T("أكمل التسوق","Continue shopping") %></a>
          </div>
        </div>
      </asp:Panel>
    </div>
  </section>
</asp:Content>
