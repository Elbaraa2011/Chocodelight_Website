<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="Default.aspx.cs" Inherits="Chocodelight_Website.DefaultPage" %>

<asp:Content ContentPlaceHolderID="TitleContent" runat="server">Choco Delight — <%= T("تذوق طعم السعادة","Taste Happiness") %></asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <section class="hero" aria-label="Highlights">
      <svg class="hero-bg-motif" viewBox="0 0 100 100"><use href="#ic-hex"/></svg>
      <div class="wrap" style="position:relative;">
        <div class="hero-slides">
          <div class="hero-slide is-active">
            <div class="hero-copy">
              <span class="eyebrow"><%= T("تشكيلة جديدة","New Arrivals") %></span>
              <h1 class="hero-title"><%= T("هدية تُشعر من تحبهم بالتقدير","A gift that says you were thought of") %></h1>
              <p class="hero-sub"><%= T("شوكولاتة يدوية الصنع بمكونات مختارة بعناية، معبأة بأناقة لتليق بأعز الناس.",
                   "Handcrafted chocolate made from carefully sourced ingredients, wrapped to delight the people you love.") %></p>
              <div class="hero-cta">
                <a class="btn btn-primary" href="<%= ResolveUrl("~/Menu.aspx") %>"><%= T("تسوّق الآن","Shop Now") %></a>
                <a class="btn btn-ghost" href="<%= ResolveUrl("~/About.aspx") %>"><%= T("اعرف قصتنا","Our Story") %></a>
              </div>
            </div>
            <div class="hero-visual">
              <img class="hero-logo" src="<%= Chocodelight_Website.Helpers.CultureHelper.Asset(this, "~/assets/img/logo.jpg") %>" alt="Choco Delight" width="360" height="360" />
            </div>
          </div>
        </div>
      </div>
    </section>

    <section class="section section-alt" id="featured">
      <div class="wrap">
        <div class="section-head reveal">
          <div class="heading-block">
            <span class="eyebrow"><%= T("اختيارات الفريق","Team Picks") %></span>
            <h2 class="section-title"><%= T("الأكثر طلبًا","Best Sellers") %></h2>
            <p class="section-sub"><%= T("تشكيلة مختارة بعناية من أكثر المنتجات التي يعشقها عملاؤنا.",
                   "A hand-picked edit of the pieces our customers keep coming back for.") %></p>
          </div>
        </div>

        <div class="products-grid">
          <asp:Repeater ID="rptFeatured" runat="server">
            <ItemTemplate>
              <div class="product-card reveal">
                <a class="product-visual" href='<%# ResolveUrl("~/Product.aspx?id=" + Eval("Id")) %>'>
                  <%# ShowBadge(Container.DataItem) %>
                  <svg viewBox="0 0 100 100"><use href="#ic-hex"/></svg>
                </a>
                <div class="product-body">
                  <span class="product-cat"><%# GetCategoryName(Container.DataItem) %></span>
                  <a class="product-name" href='<%# ResolveUrl("~/Product.aspx?id=" + Eval("Id")) %>'><%# GetName(Container.DataItem) %></a>
                  <div class="product-foot">
                    <span class="product-price">
                      <%= T("يبدأ من","from") %> <%# Chocodelight_Website.Helpers.CultureHelper.Money((decimal)Eval("BasePrice")) %>
                      <small><%# GetWeightNote(Container.DataItem) %></small>
                    </span>
                    <a class="add-btn" href='<%# ResolveUrl("~/Product.aspx?id=" + Eval("Id")) %>' aria-label='<%# T("اختيارات","Options") %>'>
                      <svg viewBox="0 0 24 24"><use href="#ic-plus"/></svg>
                    </a>
                  </div>
                </div>
              </div>
            </ItemTemplate>
          </asp:Repeater>
        </div>

        <div class="section-head reveal" style="margin-block:var(--sp-8) 0;">
          <a class="btn btn-ghost" href="<%= ResolveUrl("~/Menu.aspx") %>"><%= T("عرض كل المنيو","View Full Menu") %></a>
        </div>
      </div>
    </section>

    <section class="section" id="why">
      <div class="wrap">
        <div class="section-head reveal">
          <div class="heading-block">
            <span class="eyebrow"><%= T("تجربة تسوق مريحة","An easier way to shop") %></span>
            <h2 class="section-title"><%= T("ليه تختارنا","Why Choose Us") %></h2>
          </div>
        </div>
        <div class="features-grid">
          <div class="feature-card reveal">
            <div class="feature-icon"><svg viewBox="0 0 24 24"><use href="#ic-truck"/></svg></div>
            <span class="feature-title"><%= T("توصيل سريع وموثوق","Fast, reliable delivery") %></span>
            <span class="feature-desc"><%= T("لكل مناطقك المفضلة بمواعيد واضحة.","To all your favorite areas, on clear schedules.") %></span>
          </div>
          <div class="feature-card reveal">
            <div class="feature-icon"><svg viewBox="0 0 24 24"><use href="#ic-cash"/></svg></div>
            <span class="feature-title"><%= T("الدفع عند الاستلام","Cash on delivery") %></span>
            <span class="feature-desc"><%= T("ادفع نقدًا بارتياح لحظة وصول طلبك.","Pay in cash, with confidence, the moment it arrives.") %></span>
          </div>
          <div class="feature-card reveal">
            <div class="feature-icon"><svg viewBox="0 0 24 24"><use href="#ic-leaf"/></svg></div>
            <span class="feature-title"><%= T("مكونات مختارة بعناية","Carefully sourced ingredients") %></span>
            <span class="feature-desc"><%= T("جودة فاخرة في كل قطعة نصنعها.","Premium quality in every piece we make.") %></span>
          </div>
          <div class="feature-card reveal">
            <div class="feature-icon"><svg viewBox="0 0 24 24"><use href="#ic-card"/></svg></div>
            <span class="feature-title"><%= T("كرت تهنئة مجاني","Free gift card") %></span>
            <span class="feature-desc"><%= T("لمسة شخصية مع كل طلب دون أي تكلفة.","A personal touch on every order, at no cost.") %></span>
          </div>
        </div>
      </div>
    </section>
</asp:Content>
