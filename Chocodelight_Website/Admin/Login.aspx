<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="Chocodelight_Website.Admin.AdminLoginPage" %>
<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head runat="server">
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>دخول لوحة التحكم — Choco Delight</title>
  <link rel="preconnect" href="https://fonts.googleapis.com" />
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="crossorigin" />
  <link href="https://fonts.googleapis.com/css2?family=El+Messiri:wght@500;600;700&amp;family=Almarai:wght@400;700&amp;family=Outfit:wght@300;400;500;600&amp;display=swap" rel="stylesheet" />
  <link href="<%= Chocodelight_Website.Helpers.CultureHelper.Asset(this, "~/assets/css/site.css") %>" rel="stylesheet" />
</head>
<body>
  <form id="form1" runat="server">
    <section class="section">
      <div class="wrap">
        <div class="auth-wrap">
          <div class="auth-card">
            <div class="auth-icon"><svg viewBox="0 0 100 100"><polygon points="50,4 90,27 90,73 50,96 10,73 10,27" fill="none" stroke="currentColor" stroke-width="4"/></svg></div>
            <h1 class="auth-title">دخول لوحة التحكم</h1>
            <p class="auth-sub">هذه المنطقة مخصّصة لفريق Choco Delight فقط.</p>

            <asp:Panel ID="pnlError" runat="server" CssClass="field-error" Visible="false" style="display:block;margin-block-end:var(--sp-4);">
              <asp:Literal ID="litError" runat="server" />
            </asp:Panel>

            <div class="auth-form">
              <div class="form-field">
                <label class="form-label" for="<%= txtUsername.ClientID %>">اسم المستخدم</label>
                <asp:TextBox ID="txtUsername" runat="server" CssClass="form-input" MaxLength="50" />
                <asp:RequiredFieldValidator runat="server" ControlToValidate="txtUsername" CssClass="field-error"
                  Display="Dynamic" Text="اسم المستخدم مطلوب" ValidationGroup="al" />
              </div>
              <div class="form-field">
                <label class="form-label" for="<%= txtPassword.ClientID %>">كلمة السر</label>
                <asp:TextBox ID="txtPassword" runat="server" CssClass="form-input" TextMode="Password" MaxLength="100" />
                <asp:RequiredFieldValidator runat="server" ControlToValidate="txtPassword" CssClass="field-error"
                  Display="Dynamic" Text="كلمة السر مطلوبة" ValidationGroup="al" />
              </div>
              <asp:Button ID="btnLogin" runat="server" CssClass="btn btn-primary btn-lg"
                Text="دخول" ValidationGroup="al" OnClick="btnLogin_Click" />
            </div>

            <p class="auth-switch"><a href="<%= ResolveUrl("~/Default.aspx") %>">الرجوع للموقع</a></p>
          </div>
        </div>
      </div>
    </section>
  </form>
</body>
</html>
