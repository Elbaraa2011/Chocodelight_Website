<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="OrderDetail.aspx.cs" Inherits="Chocodelight_Website.Account.OrderDetailPage" %>

<asp:Content ContentPlaceHolderID="TitleContent" runat="server"><%= T("تفاصيل الطلب","Order details") %> — Choco Delight</asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
  <section class="section">
    <div class="wrap">
      <asp:Panel ID="pnlNotFound" runat="server" Visible="false" style="text-align:center;padding-block:4rem;">
        <h1><%= T("الطلب مش موجود","Order not found") %></h1>
        <p><a class="btn btn-ghost" href="<%= ResolveUrl("~/Account/MyAccount.aspx") %>"><%= T("طلباتي","My Orders") %></a></p>
      </asp:Panel>

      <asp:Panel ID="pnlOrder" runat="server">
        <div class="cart-head">
          <h1 class="cart-title"><asp:Literal ID="litOrderNumber" runat="server" /></h1>
          <span class="status-pill"><asp:Literal ID="litStatus" runat="server" /></span>
        </div>

        <div class="checkout-layout" style="display:grid;grid-template-columns:1.4fr 1fr;gap:var(--sp-8);align-items:start;">
          <div>
            <h2 class="summary-title"><%= T("تفاصيل التوصيل","Delivery details") %></h2>
            <div class="info-block">
              <p><strong><%= T("المستلم","Recipient") %>:</strong> <asp:Literal ID="litRecipient" runat="server" /></p>
              <p><strong><%= T("التليفون","Phone") %>:</strong> <asp:Literal ID="litPhone" runat="server" /></p>
              <p><strong><%= T("المنطقة","Area") %>:</strong> <asp:Literal ID="litZone" runat="server" /></p>
              <p><strong><%= T("العنوان","Address") %>:</strong> <asp:Literal ID="litAddress" runat="server" /></p>
              <asp:Panel ID="pnlGift" runat="server" Visible="false">
                <p><strong><%= T("رسالة الهدية","Gift message") %>:</strong> <asp:Literal ID="litGift" runat="server" /></p>
              </asp:Panel>
            </div>

            <h2 class="summary-title" style="margin-block-start:var(--sp-6);"><%= T("تتبّع الطلب","Order tracking") %></h2>
            <asp:Repeater ID="rptHistory" runat="server">
              <HeaderTemplate><ul class="timeline" style="list-style:none;padding:0;margin:0;display:flex;flex-direction:column;gap:var(--sp-2);"></HeaderTemplate>
              <ItemTemplate>
                <li style="padding:var(--sp-2) 0;border-block-end:1px solid var(--line);">
                  <strong><%# Chocodelight_Website.Models.OrderStatus.Label((string)Eval("NewStatus")) %></strong>
                  <span style="color:var(--text-muted);"> — <%# ((System.DateTime)Eval("ChangedAt")).ToString("yyyy-MM-dd HH:mm") %></span>
                </li>
              </ItemTemplate>
              <FooterTemplate></ul></FooterTemplate>
            </asp:Repeater>
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
            <div class="summary-row" style="margin-block-start:var(--sp-4);"><span><%= T("الدفع","Payment") %></span><span class="val"><%= T("عند الاستلام","On delivery") %></span></div>
          </div>
        </div>
      </asp:Panel>
    </div>
  </section>
</asp:Content>
