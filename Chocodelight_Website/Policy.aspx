<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" Inherits="Chocodelight_Website.Helpers.BasePage" %>
<asp:Content ContentPlaceHolderID="TitleContent" runat="server">سياسة الاستخدام والخصوصية — Choco Delight</asp:Content>
<asp:Content ContentPlaceHolderID="MainContent" runat="server">
  <% var ar = Chocodelight_Website.Helpers.CultureHelper.IsArabic; %>
  <section class="page-banner">
    <div class="wrap">
      <h1 class="page-title"><%= ar ? "سياسة الاستخدام والخصوصية" : "Terms of Use & Privacy Policy" %></h1>
      <p class="page-sub"><%= ar ? "آخر تحديث: سبتمبر 2026" : "Last updated: September 2026" %></p>
    </div>
  </section>
  <section class="section">
    <div class="wrap" style="max-width:72ch;display:flex;flex-direction:column;gap:var(--sp-5);">

      <div><h2><%= ar ? "استخدام الموقع" : "Use of the Site" %></h2>
        <p><%= ar
          ? "الموقع ده مخصص لعرض منتجات Choco Delight واستقبال الطلبات داخل الإسكندرية. باستخدامك للموقع بتوافق على تقديم بيانات صحيحة وعدم إساءة استخدام الخدمة."
          : "This site is for showcasing Choco Delight products and receiving orders within Alexandria. By using it you agree to provide accurate information and not to misuse the service." %></p></div>

      <div><h2><%= ar ? "الطلبات والدفع" : "Orders & Payment" %></h2>
        <p><%= ar
          ? "الدفع عند الاستلام نقدًا فقط حاليًا. الأسعار وتوافر المنتجات قابلة للتغيير، وبنأكد كل طلب بالتواصل معاك قبل التوصيل."
          : "Payment is cash on delivery only for now. Prices and availability may change, and we confirm every order by contacting you before delivery." %></p></div>

      <div><h2><%= ar ? "التوصيل والإلغاء" : "Delivery & Cancellation" %></h2>
        <p><%= ar
          ? "مصاريف التوصيل بتتحدد حسب المنطقة وبتظهر في صفحة إتمام الطلب. تقدر تلغي الطلب قبل ما يخرج للتوصيل بالتواصل معانا."
          : "Delivery fees depend on your area and are shown at checkout. You can cancel an order before it is dispatched by contacting us." %></p></div>

      <div><h2><%= ar ? "البيانات اللي بنجمعها" : "Data We Collect" %></h2>
        <p><%= ar
          ? "بنجمع الاسم، البريد الإلكتروني، رقم التليفون، وعناوين التوصيل عشان نقدر نجهّز طلبك ونتواصل معاك. كلمات السر بتتخزن مشفّرة."
          : "We collect your name, email, phone, and delivery addresses to prepare your order and contact you. Passwords are stored hashed." %></p></div>

      <div><h2><%= ar ? "الكوكيز" : "Cookies" %></h2>
        <p><%= ar
          ? "بنستخدم كوكيز أساسية لحفظ جلسة الدخول وتفضيل اللغة فقط، ومش بنستخدم كوكيز تتبّع إعلانية."
          : "We use essential cookies only to keep your session and language preference. We do not use advertising trackers." %></p></div>

      <div><h2><%= ar ? "حقوقك والتواصل معانا" : "Your Rights & Contact" %></h2>
        <p><%= ar
          ? "تقدر في أي وقت تطلب تعديل أو حذف بياناتك من خلال "
          : "You can request to update or delete your data at any time via " %><a href="<%= ResolveUrl("~/Contact.aspx") %>"><%= ar ? "صفحة الاتصال" : "the contact page" %></a>.</p></div>

    </div>
  </section>
</asp:Content>
