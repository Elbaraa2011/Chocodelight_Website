<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" Inherits="Chocodelight_Website.Helpers.BasePage" %>
<asp:Content ContentPlaceHolderID="TitleContent" runat="server">من نحن — Choco Delight</asp:Content>
<asp:Content ContentPlaceHolderID="MainContent" runat="server">
  <% var ar = Chocodelight_Website.Helpers.CultureHelper.IsArabic; %>
  <section class="page-banner">
    <div class="wrap">
      <h1 class="page-title"><%= ar ? "من نحن" : "About Us" %></h1>
      <p class="page-sub"><%= ar ? "قصتنا مع الشوكولاتة اليدوية في الإسكندرية." : "Our story of handmade chocolate in Alexandria." %></p>
    </div>
  </section>
  <section class="section">
    <div class="wrap" style="max-width:70ch;">
      <h2><%= ar ? "صنعنا Choco Delight عشان اللحظات الحلوة تستاهل أكتر" : "We built Choco Delight so sweet moments could mean more" %></h2>
      <p style="margin-block:var(--sp-4);">
        <%= ar
          ? "بدأنا من مطبخ صغير وفكرة بسيطة: إن كل قطعة شوكولاتة تُصنع بإيدينا من مكونات مختارة بعناية، وتتغلّف بحب قبل ما توصل لمن تحب. من يومها وإحنا بنكبر بنفس الاهتمام."
          : "We started from a small kitchen and a simple idea: every piece of chocolate made by hand from carefully chosen ingredients, wrapped with care before it reaches the people you love. We've grown with that same attention ever since." %>
      </p>
      <p style="margin-block:var(--sp-4);">
        <%= ar
          ? "النهارده، Choco Delight اسم موثوق عند أكتر من 2000 عميل في الإسكندرية، وكل قطعة لسه بتتصنع بنفس العناية اللي بدأنا بيها في أول يوم."
          : "Today, Choco Delight is trusted by over 2,000 customers across Alexandria, and every piece is still made with the same care we started with on day one." %>
      </p>
      <ul style="margin-block:var(--sp-5);padding-inline-start:1.2rem;display:flex;flex-direction:column;gap:var(--sp-2);">
        <li><%= ar ? "توصيل داخل الإسكندرية بمواعيد واضحة" : "Delivery across Alexandria on clear schedules" %></li>
        <li><%= ar ? "الدفع عند الاستلام" : "Cash on delivery" %></li>
        <li><%= ar ? "كرت تهنئة مجاني مع كل طلب" : "A free gift card with every order" %></li>
        <li><%= ar ? "تشكيلات خاصة للشركات والمناسبات" : "Custom assortments for companies and occasions" %></li>
      </ul>
      <a class="btn btn-primary" href="<%= ResolveUrl("~/Menu.aspx") %>"><%= ar ? "تصفح المنيو" : "Browse the Menu" %></a>
    </div>
  </section>
</asp:Content>
