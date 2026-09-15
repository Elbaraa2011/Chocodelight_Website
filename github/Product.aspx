<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="Product.aspx.cs" Inherits="Chocodelight_Website.ProductPage" %>

<asp:Content ContentPlaceHolderID="TitleContent" runat="server"><%: PageTitle %></asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
  <asp:Panel ID="pnlNotFound" runat="server" Visible="false">
    <section class="section">
      <div class="wrap" style="text-align:center;padding-block:4rem;">
        <h1><%= T("المنتج مش موجود","Product not found") %></h1>
        <p><a class="btn btn-ghost" href="<%= ResolveUrl("~/Menu.aspx") %>"><%= T("رجوع للمنيو","Back to Menu") %></a></p>
      </div>
    </section>
  </asp:Panel>

  <asp:Panel ID="pnlProduct" runat="server">
    <div class="page-banner" style="padding-block:var(--sp-6);">
      <div class="wrap">
        <div class="breadcrumb">
          <a href="<%= ResolveUrl("~/Default.aspx") %>"><%= T("الرئيسية","Home") %></a>
          <span class="sep">/</span>
          <a href="<%= ResolveUrl("~/Menu.aspx") %>"><%= T("المنيو","Menu") %></a>
          <span class="sep">/</span>
          <span class="current"><asp:Literal ID="litCrumb" runat="server" /></span>
        </div>
      </div>
    </div>

    <section class="section">
      <div class="wrap pdp-grid">
        <div class="pdp-gallery">
          <div class="pdp-visual">
            <asp:Literal ID="litBadge" runat="server" />
            <svg viewBox="0 0 100 100"><use href="#ic-hex"/></svg>
          </div>
        </div>

        <div class="pdp-info">
          <span class="pdp-cat"><asp:Literal ID="litCat" runat="server" /></span>
          <h1 class="pdp-title"><asp:Literal ID="litTitle" runat="server" /></h1>
          <p class="pdp-desc"><asp:Literal ID="litDesc" runat="server" /></p>

          <div class="pdp-price-row">
            <span class="pdp-price" id="pdpPrice"><asp:Literal ID="litPrice" runat="server" /></span>
            <span class="pdp-price-note"><asp:Literal ID="litPriceNote" runat="server" /></span>
          </div>

          <asp:Panel ID="pnlWeights" runat="server" CssClass="option-group">
            <div class="option-label"><span><%= T("الوزن","Weight") %></span></div>
            <div class="pill-row" id="weightPills">
              <asp:Repeater ID="rptWeights" runat="server">
                <ItemTemplate>
                  <button type="button" class="weight-pill" data-id='<%# Eval("Id") %>'
                          data-price='<%# Eval("Price") %>'
                          aria-pressed='<%# Container.ItemIndex == 0 ? "true" : "false" %>'>
                    <%# Chocodelight_Website.Helpers.CultureHelper.IsArabic ? Eval("LabelAr") : Eval("LabelEn") %>
                    — <%# Chocodelight_Website.Helpers.CultureHelper.Money((decimal)Eval("Price")) %>
                  </button>
                </ItemTemplate>
              </asp:Repeater>
            </div>
          </asp:Panel>

          <asp:Panel ID="pnlFlavors" runat="server" CssClass="option-group" Visible="false">
            <div class="option-label"><span><%= T("النكهة","Flavor") %></span></div>
            <div class="option-hint"><%= T("اختار نكهتك المفضلة — من غير أي فرق في السعر.","Pick your favourite — no price difference.") %></div>
            <div class="pill-row" id="flavorPills">
              <asp:Repeater ID="rptFlavors" runat="server">
                <ItemTemplate>
                  <button type="button" class="flavor-pill"
                    data-ar='<%# Server.HtmlEncode((string)Eval("NameAr")) %>'
                    data-en='<%# Server.HtmlEncode((string)Eval("NameEn")) %>'
                    aria-pressed='<%# Container.ItemIndex == 0 ? "true" : "false" %>'>
                    <%# Chocodelight_Website.Helpers.CultureHelper.IsArabic ? Eval("NameAr") : Eval("NameEn") %>
                  </button>
                </ItemTemplate>
              </asp:Repeater>
            </div>
          </asp:Panel>

          <asp:HiddenField ID="hfFlavorAr" runat="server" Value="" />
          <asp:HiddenField ID="hfFlavorEn" runat="server" Value="" />

          <div class="qty-row">
            <div class="option-label" style="margin:0;"><span><%= T("الكمية","Quantity") %></span></div>
            <div class="qty-stepper">
              <button type="button" class="qty-btn" id="qtyMinus" aria-label="Decrease"><svg viewBox="0 0 24 24" style="stroke:currentColor;fill:none;stroke-width:2"><use href="#ic-minus"/></svg></button>
              <span class="qty-value" id="qtyValue">1</span>
              <button type="button" class="qty-btn" id="qtyPlus" aria-label="Increase"><svg viewBox="0 0 24 24" style="stroke:currentColor;fill:none;stroke-width:2"><use href="#ic-plus"/></svg></button>
            </div>
          </div>

          <asp:HiddenField ID="hfWeightId" runat="server" Value="" />
          <asp:HiddenField ID="hfQty" runat="server" Value="1" />

          <div class="pdp-cta-row">
            <asp:Button ID="btnAddToCart" runat="server" CssClass="btn btn-primary btn-lg"
                        Text="أضف للسلة" OnClick="btnAddToCart_Click" />
          </div>
          <asp:Label ID="lblMsg" runat="server" CssClass="pdp-msg" Visible="false" />

          <div class="trust-row">
            <div class="trust-item"><svg viewBox="0 0 24 24"><use href="#ic-truck"/></svg><span><%= T("توصيل لكل مناطق الإسكندرية","Delivery across Alexandria") %></span></div>
            <div class="trust-item"><svg viewBox="0 0 24 24"><use href="#ic-cash"/></svg><span><%= T("الدفع عند الاستلام","Cash on delivery") %></span></div>
            <div class="trust-item"><svg viewBox="0 0 24 24"><use href="#ic-card"/></svg><span><%= T("كرت تهنئة مجاني","Free gift card") %></span></div>
          </div>

          <asp:Panel ID="pnlLongDesc" runat="server" CssClass="info-block" Visible="false">
            <h3><%= T("تفاصيل المنتج","Product details") %></h3>
            <p><asp:Literal ID="litLongDesc" runat="server" /></p>
          </asp:Panel>
        </div>
      </div>
    </section>

    <asp:Panel ID="pnlRelated" runat="server" Visible="false">
      <section class="section section-alt" style="background:var(--surface-alt);border-block:1px solid var(--line);">
        <div class="wrap">
          <header class="section-head"><h2><%= T("منتجات مشابهة","You may also like") %></h2></header>
          <div class="products-grid">
            <asp:Repeater ID="rptRelated" runat="server">
              <ItemTemplate>
                <div class="product-card">
                  <a class="product-visual" href='<%# ResolveUrl("~/Product.aspx?id=" + Eval("Id")) %>'>
                    <svg viewBox="0 0 100 100"><use href="#ic-hex"/></svg>
                  </a>
                  <div class="product-body">
                    <span class="product-cat"><%# GetCatName(Container.DataItem) %></span>
                    <a class="product-name" href='<%# ResolveUrl("~/Product.aspx?id=" + Eval("Id")) %>'><%# GetPName(Container.DataItem) %></a>
                    <div class="product-foot">
                      <span class="product-price"><%= T("يبدأ من","from") %> <%# Chocodelight_Website.Helpers.CultureHelper.Money((decimal)Eval("BasePrice")) %></span>
                    </div>
                  </div>
                </div>
              </ItemTemplate>
            </asp:Repeater>
          </div>
        </div>
      </section>
    </asp:Panel>
  </asp:Panel>
</asp:Content>

<asp:Content ContentPlaceHolderID="ScriptContent" runat="server">
  <script>
  (function () {
    var pills = document.querySelectorAll('#weightPills .weight-pill');
    var priceEl = document.getElementById('pdpPrice');
    var hfWeight = document.getElementById('<%= hfWeightId.ClientID %>');
    var hfQty = document.getElementById('<%= hfQty.ClientID %>');
    var qtyEl = document.getElementById('qtyValue');
    var currency = <%= Chocodelight_Website.Helpers.CultureHelper.IsArabic ? "'ar'" : "'en'" %>;
    var basePrice = <%= JsBasePrice %>;

    function money(n) {
      n = Math.round(n).toLocaleString('en-US');
      return currency === 'ar' ? (n + ' جنيه') : ('EGP ' + n);
    }
    function selectedPrice() {
      var on = document.querySelector('#weightPills .weight-pill[aria-pressed="true"]');
      return on ? parseFloat(on.getAttribute('data-price')) : basePrice;
    }
    function refresh() {
      if (priceEl) priceEl.textContent = money(selectedPrice());
      var on = document.querySelector('#weightPills .weight-pill[aria-pressed="true"]');
      if (hfWeight) hfWeight.value = on ? (on.getAttribute('data-id') || '') : '';
      if (hfQty) hfQty.value = qtyEl ? qtyEl.textContent : '1';
    }

    pills.forEach(function (p) {
      p.addEventListener('click', function () {
        pills.forEach(function (x) { x.setAttribute('aria-pressed', 'false'); });
        p.setAttribute('aria-pressed', 'true');
        refresh();
      });
    });

    var flavorPills = document.querySelectorAll('#flavorPills .flavor-pill');
    var hfFlavorAr = document.getElementById('<%= hfFlavorAr.ClientID %>');
    var hfFlavorEn = document.getElementById('<%= hfFlavorEn.ClientID %>');
    function refreshFlavor() {
      var on = document.querySelector('#flavorPills .flavor-pill[aria-pressed="true"]');
      if (hfFlavorAr) hfFlavorAr.value = on ? (on.getAttribute('data-ar') || '') : '';
      if (hfFlavorEn) hfFlavorEn.value = on ? (on.getAttribute('data-en') || '') : '';
    }
    flavorPills.forEach(function (p) {
      p.addEventListener('click', function () {
        flavorPills.forEach(function (x) { x.setAttribute('aria-pressed', 'false'); });
        p.setAttribute('aria-pressed', 'true');
        refreshFlavor();
      });
    });
    refreshFlavor();

    var minus = document.getElementById('qtyMinus'), plus = document.getElementById('qtyPlus');
    if (minus) minus.addEventListener('click', function () {
      var v = Math.max(1, parseInt(qtyEl.textContent, 10) - 1); qtyEl.textContent = v; refresh();
    });
    if (plus) plus.addEventListener('click', function () {
      var v = Math.min(99, parseInt(qtyEl.textContent, 10) + 1); qtyEl.textContent = v; refresh();
    });

    refresh();
  })();
  </script>
</asp:Content>
