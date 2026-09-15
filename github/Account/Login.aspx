<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="Login.aspx.cs" Inherits="Chocodelight_Website.Account.LoginPage" %>

<asp:Content ContentPlaceHolderID="TitleContent" runat="server"><%= T("تسجيل الدخول","Sign In") %> — Choco Delight</asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
  <section class="section">
    <div class="wrap">
      <div class="auth-wrap">
        <div class="auth-card">
          <div class="auth-icon"><svg viewBox="0 0 100 100"><use href="#ic-hex"/></svg></div>
          <h1 class="auth-title"><%= T("تسجيل الدخول","Sign In") %></h1>
          <p class="auth-sub"><%= T("أهلاً بيك تاني! ادخل بياناتك عشان تكمل طلبك وتتابع أوردراتك.",
                "Welcome back! Sign in to finish your order and track your deliveries.") %></p>

          <asp:Panel ID="pnlError" runat="server" CssClass="field-error" Visible="false" style="display:block;margin-block-end:var(--sp-4);">
            <asp:Literal ID="litError" runat="server" />
          </asp:Panel>

          <div class="auth-form">
            <div class="form-field">
              <label class="form-label" for="<%= txtEmail.ClientID %>"><%= T("البريد الإلكتروني","Email") %></label>
              <div class="input-wrap">
                <svg class="field-icon" viewBox="0 0 24 24"><use href="#ic-mail"/></svg>
                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-input" TextMode="Email"
                  MaxLength="256" placeholder="example@email.com" />
              </div>
              <asp:RequiredFieldValidator runat="server" ControlToValidate="txtEmail" CssClass="field-error"
                Display="Dynamic" Text="البريد الإلكتروني مطلوب" ValidationGroup="login" />
            </div>

            <div class="form-field">
              <label class="form-label" for="<%= txtPassword.ClientID %>"><%= T("كلمة السر","Password") %></label>
              <div class="input-wrap">
                <svg class="field-icon" viewBox="0 0 24 24"><use href="#ic-lock"/></svg>
                <asp:TextBox ID="txtPassword" runat="server" CssClass="form-input" TextMode="Password"
                  MaxLength="100" placeholder="كلمة السر" />
              </div>
              <asp:RequiredFieldValidator runat="server" ControlToValidate="txtPassword" CssClass="field-error"
                Display="Dynamic" Text="كلمة السر مطلوبة" ValidationGroup="login" />
            </div>

            <div class="check-row login-check-row">
              <label class="check-label">
                <asp:CheckBox ID="chkRemember" runat="server" /> <%= T("تذكرني","Remember me") %>
              </label>
              <a class="auth-forgot" href="<%= ResolveUrl("~/Account/ForgotPassword.aspx") %>"><%= T("نسيت كلمة السر؟","Forgot password?") %></a>
            </div>

            <asp:Button ID="btnLogin" runat="server" CssClass="btn btn-primary btn-lg"
              Text="تسجيل الدخول" ValidationGroup="login" OnClick="btnLogin_Click" />
          </div>

          <p class="auth-switch">
            <%= T("مستخدم جديد؟","New here?") %>
            <a href="<%= ResolveUrl("~/Account/Register.aspx" + ReturnQuery) %>"><%= T("سجّل حساب من هنا","Create an account") %></a>
          </p>
        </div>
      </div>
    </div>
  </section>
</asp:Content>
