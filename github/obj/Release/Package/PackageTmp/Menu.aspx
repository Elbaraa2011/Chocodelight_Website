<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="Menu.aspx.cs" Inherits="Chocodelight_Website.MenuPage" %>

<asp:Content ContentPlaceHolderID="TitleContent" runat="server"><%: PageTitle %></asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <section class="page-banner">
      <svg class="page-banner-motif" viewBox="0 0 100 100"><use href="#ic-hex"/></svg>
      <div class="wrap">
        <div class="breadcrumb">
          <a href="<%= ResolveUrl("~/Default.aspx") %>"><%= T("الرئيسية","Home") %></a>
          <span class="sep">/</span>
          <span class="current"><%= T("المنيو","Menu") %></span>
        </div>
        <h1 class="page-title"><%= T("تشكيلتنا الكاملة", "Our Full Collection") %></h1>
        <p class="page-sub"><%= T("اختار المجموعة اللي عايزها، وكل قطعة بنصنعها بإيدينا وتوصلك بالدفع عند الاستلام.",
                 "Pick a collection below — every piece is handmade and delivered cash on arrival.") %></p>
      </div>
    </section>

    <div class="menu-toolbar">
      <div class="wrap">
        <div class="cat-tabs" role="tablist" aria-label="Categories">
          <asp:Repeater ID="rptTabs" runat="server">
            <ItemTemplate>
              <a class="cat-tab" role="tab"
                 aria-selected='<%# ((string)Eval("Slug") == CurrentSlug).ToString().ToLowerInvariant() %>'
                 href='<%# Eval("Slug").ToString() == "all" ? ResolveUrl("~/Menu.aspx") : ResolveUrl("~/Menu.aspx?cat=" + Eval("Slug")) %>'>
                <%# Chocodelight_Website.Helpers.CultureHelper.IsArabic ? Eval("NameAr") : Eval("NameEn") %>
              </a>
            </ItemTemplate>
          </asp:Repeater>
        </div>
        <p class="result-count"><b><asp:Literal ID="litCount" runat="server" /></b> <%= T("منتج متاح","items available") %></p>
      </div>
    </div>

    <section class="section">
      <div class="wrap">
        <asp:Panel ID="pnlEmpty" runat="server" Visible="false" CssClass="menu-empty" style="text-align:center;padding-block:4rem;color:var(--text-muted);">
          <%= T("مفيش منتجات في القسم ده حاليًا.", "No products in this collection yet.") %>
        </asp:Panel>

        <div class="products-grid">
          <asp:Repeater ID="rptProducts" runat="server">
            <ItemTemplate>
              <div class="product-card">
                <a class="product-visual" href='<%# ResolveUrl("~/Product.aspx?id=" + Eval("Id")) %>'>
                  <%# ShowBadge(Container.DataItem) %>
                  <svg viewBox="0 0 100 100"><use href="#ic-hex"/></svg>
                </a>
                <div class="product-body">
                  <span class="product-cat"><%# GetCategoryName(Container.DataItem) %></span>
                  <a class="product-name" href='<%# ResolveUrl("~/Product.aspx?id=" + Eval("Id")) %>'><%# GetName(Container.DataItem) %></a>
                  <div class="product-foot">
                    <span class="product-price">
                      <%= T("يبدأ من","from") %> <%# Chocodelight_Website.Helpers.CultureHelper.Money(GetFromPrice(Container.DataItem)) %>
                      <small><%# GetWeightNote(Container.DataItem) %></small>
                    </span>
                    <a class="add-btn" href='<%# ResolveUrl("~/Product.aspx?id=" + Eval("Id")) %>'
                       aria-label='<%# T("اختيارات","Options") %>'>
                      <svg viewBox="0 0 24 24"><use href="#ic-plus"/></svg>
                    </a>
                  </div>
                </div>
              </div>
            </ItemTemplate>
          </asp:Repeater>
        </div>
      </div>
    </section>
</asp:Content>
