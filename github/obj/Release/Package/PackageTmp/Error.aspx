<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" Inherits="Chocodelight_Website.Helpers.BasePage" %>
<asp:Content ContentPlaceHolderID="TitleContent" runat="server">خطأ — Choco Delight</asp:Content>
<asp:Content ContentPlaceHolderID="MainContent" runat="server">
  <section class="section">
    <div class="wrap" style="text-align:center;padding-block:4rem;">
      <h1><%= Chocodelight_Website.Helpers.CultureHelper.IsArabic ? "حصل خطأ" : "Something went wrong" %></h1>
      <p style="color:var(--text-muted);max-width:38ch;margin-inline:auto;">
        <%= Chocodelight_Website.Helpers.CultureHelper.IsArabic ? "حصلت مشكلة غير متوقعة، جرّب تاني." : "An unexpected error occurred. Please try again." %>
      </p>
      <p><a class="btn btn-ghost" href="<%= ResolveUrl("~/Default.aspx") %>"><%= Chocodelight_Website.Helpers.CultureHelper.IsArabic ? "الرجوع للرئيسية" : "Back to home" %></a></p>
    </div>
  </section>
</asp:Content>
