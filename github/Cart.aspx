<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="Cart.aspx.cs" Inherits="Chocodelight_Website.CartPage" %>

<asp:Content ContentPlaceHolderID="TitleContent" runat="server"><%= T("سلة التسوق","Your Cart") %> — Choco Delight</asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
  <section class="section">
    <div class="wrap">

      <asp:Panel ID="pnlEmpty" runat="server" CssClass="cart-empty is-visible" Visible="false">
        <div class="cart-empty-icon"><svg viewBox="0 0 24 24"><use href="#ic-cart"/></svg></div>
        <h2><%= T("سلتك فاضية","Your cart is empty") %></h2>
        <p><%= T("لسه مضفتش أي منتجات. اتصفح المنيو واختار اللي يعجبك.",
                 "You haven't added anything yet. Browse the menu and pick what you like.") %></p>
        <a class="btn btn-primary" href="<%= ResolveUrl("~/Menu.aspx") %>"><%= T("تصفح المنيو","Browse the Menu") %></a>
      </asp:Panel>

      <asp:Panel ID="pnlCart" runat="server">
        <div class="cart-head">
          <h1 class="cart-title"><%= T("سلة التسوق","Your Cart") %></h1>
          <span class="cart-count-label"><b><asp:Literal ID="litCount" runat="server" /></b>
            <%= T("منتج في سلتك","items in your cart") %></span>
        </div>

        <div class="cart-layout">
          <div class="cart-items">
            <asp:Repeater ID="rptItems" runat="server" OnItemCommand="rptItems_ItemCommand">
              <ItemTemplate>
                <div class="cart-item">
                  <div class="cart-item-visual"><svg viewBox="0 0 100 100"><use href="#ic-hex"/></svg></div>
                  <div class="cart-item-info">
                    <span class="cart-item-name"><%# GetName(Container.DataItem) %></span>
                    <p class="cart-item-meta"><%# GetMeta(Container.DataItem) %></p>
                    <div class="cart-item-controls">
                      <div class="cart-qty">
                        <asp:LinkButton runat="server" CssClass="qty-minus" CommandName="dec"
                          CommandArgument='<%# Eval("Key") %>' ToolTip="Decrease">
                          <svg viewBox="0 0 24 24"><use href="#ic-minus"/></svg>
                        </asp:LinkButton>
                        <span class="qty-value"><%# Eval("Quantity") %></span>
                        <asp:LinkButton runat="server" CssClass="qty-plus" CommandName="inc"
                          CommandArgument='<%# Eval("Key") %>' ToolTip="Increase">
                          <svg viewBox="0 0 24 24"><use href="#ic-plus"/></svg>
                        </asp:LinkButton>
                      </div>
                      <asp:LinkButton runat="server" CssClass="cart-remove" CommandName="del"
                        CommandArgument='<%# Eval("Key") %>' ToolTip="Remove">
                        <svg viewBox="0 0 24 24"><use href="#ic-close"/></svg>
                      </asp:LinkButton>
                    </div>
                  </div>
                  <div class="cart-item-price-col">
                    <span class="cart-item-line-total"><%# Chocodelight_Website.Helpers.CultureHelper.Money((decimal)Eval("LineTotal")) %></span>
                    <span class="cart-item-unit"><%# Chocodelight_Website.Helpers.CultureHelper.Money((decimal)Eval("UnitPrice")) %> / <%= T("قطعة","each") %></span>
                  </div>
                </div>
              </ItemTemplate>
            </asp:Repeater>
          </div>

          <div class="summary-card">
            <h2 class="summary-title"><%= T("ملخص الطلب","Order Summary") %></h2>
            <div class="summary-row">
              <span><%= T("الإجمالي الفرعي","Subtotal") %></span>
              <span class="val"><asp:Literal ID="litSubtotal" runat="server" /></span>
            </div>
            <div class="summary-row">
              <span><%= T("مصاريف الشحن","Delivery") %></span>
              <span class="val"><%= T("هتتحدد لاحقًا","Set at checkout") %></span>
            </div>
            <p class="summary-shipping-note"><%= T("بتتحدد حسب منطقتك في صفحة إتمام الطلب","Calculated from your area at checkout") %></p>
            <div class="summary-divider"></div>
            <div class="summary-total">
              <span><%= T("الإجمالي","Total") %></span>
              <span class="val"><asp:Literal ID="litTotal" runat="server" /></span>
            </div>
            <asp:HyperLink ID="lnkCheckout" runat="server" NavigateUrl="~/Checkout.aspx"
              CssClass="btn btn-primary btn-lg" style="margin-block-start:var(--sp-6);">
              <%= T("متابعة لإتمام الطلب","Proceed to Checkout") %>
            </asp:HyperLink>
            <p class="summary-note"><%= T("هتحتاج تسجّل دخول قبل إتمام الطلب","You'll need to sign in before checkout") %></p>

            <div class="trust-row">
              <div class="trust-item"><svg viewBox="0 0 24 24"><use href="#ic-truck"/></svg><span><%= T("توصيل لكل مناطق الإسكندرية","Delivery across Alexandria") %></span></div>
              <div class="trust-item"><svg viewBox="0 0 24 24"><use href="#ic-cash"/></svg><span><%= T("الدفع عند الاستلام","Cash on delivery") %></span></div>
            </div>
          </div>
        </div>
      </asp:Panel>

    </div>
  </section>
</asp:Content>
