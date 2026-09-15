<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="Register.aspx.cs" Inherits="Chocodelight_Website.Account.RegisterPage" %>

<asp:Content ContentPlaceHolderID="TitleContent" runat="server"><%= T("إنشاء حساب","Create Account") %> — Choco Delight</asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
  <section class="section">
    <div class="wrap">
      <div class="auth-wrap">
        <div class="auth-card">
          <div class="auth-icon"><svg viewBox="0 0 100 100"><use href="#ic-hex"/></svg></div>
          <h1 class="auth-title"><%= T("إنشاء حساب جديد","Create a new account") %></h1>
          <p class="auth-sub"><%= T("قرّب من طلبك في أقل من دقيقة، وتابع طلباتك بسهولة.",
                "Get closer to your order in under a minute and track it easily.") %></p>

          <asp:Panel ID="pnlError" runat="server" CssClass="field-error" Visible="false" style="display:block;margin-block-end:var(--sp-4);">
            <asp:Literal ID="litError" runat="server" />
          </asp:Panel>

          <div class="auth-form">
            <div class="form-field">
              <label class="form-label" for="<%= txtName.ClientID %>"><%= T("الاسم الكامل","Full name") %></label>
              <div class="input-wrap">
                <svg class="field-icon" viewBox="0 0 24 24"><use href="#ic-user"/></svg>
                <asp:TextBox ID="txtName" runat="server" CssClass="form-input" MaxLength="150"
                  placeholder="اكتب اسمك بالكامل" />
              </div>
              <asp:RequiredFieldValidator runat="server" ControlToValidate="txtName" CssClass="field-error"
                Display="Dynamic" Text="الاسم مطلوب" ValidationGroup="reg" />
            </div>

            <div class="form-field">
              <label class="form-label" for="<%= txtPhone.ClientID %>"><%= T("رقم التليفون","Phone number") %></label>
              <div class="input-wrap">
                <svg class="field-icon" viewBox="0 0 24 24"><use href="#ic-phone"/></svg>
                <asp:TextBox ID="txtPhone" runat="server" CssClass="form-input" TextMode="Phone"
                  MaxLength="20" placeholder="01xxxxxxxxx" />
              </div>
              <asp:RequiredFieldValidator runat="server" ControlToValidate="txtPhone" CssClass="field-error"
                Display="Dynamic" Text="رقم التليفون مطلوب" ValidationGroup="reg" />
              <asp:RegularExpressionValidator runat="server" ControlToValidate="txtPhone" CssClass="field-error"
                Display="Dynamic" ValidationExpression="^01[0-2,5]{1}[0-9]{8}$"
                Text="رقم موبايل مصري غير صحيح" ValidationGroup="reg" />
            </div>

            <div class="form-field">
              <label class="form-label" for="<%= txtEmail.ClientID %>"><%= T("البريد الإلكتروني","Email") %></label>
              <div class="input-wrap">
                <svg class="field-icon" viewBox="0 0 24 24"><use href="#ic-mail"/></svg>
                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-input" TextMode="Email"
                  MaxLength="256" placeholder="example@email.com" />
              </div>
              <asp:RequiredFieldValidator runat="server" ControlToValidate="txtEmail" CssClass="field-error"
                Display="Dynamic" Text="البريد الإلكتروني مطلوب" ValidationGroup="reg" />
              <asp:RegularExpressionValidator runat="server" ControlToValidate="txtEmail" CssClass="field-error"
                Display="Dynamic" ValidationExpression="^[^@\s]+@[^@\s]+\.[^@\s]+$"
                Text="بريد إلكتروني غير صحيح" ValidationGroup="reg" />
            </div>

            <div class="form-field">
              <label class="form-label" for="<%= txtPassword.ClientID %>"><%= T("كلمة السر","Password") %></label>
              <div class="input-wrap">
                <svg class="field-icon" viewBox="0 0 24 24"><use href="#ic-lock"/></svg>
                <asp:TextBox ID="txtPassword" runat="server" CssClass="form-input" TextMode="Password"
                  MaxLength="100" placeholder="8 أحرف على الأقل" />
              </div>
              <asp:RequiredFieldValidator runat="server" ControlToValidate="txtPassword" CssClass="field-error"
                Display="Dynamic" Text="كلمة السر مطلوبة" ValidationGroup="reg" />
              <asp:RegularExpressionValidator runat="server" ControlToValidate="txtPassword" CssClass="field-error"
                Display="Dynamic" ValidationExpression=".{8,}" Text="8 أحرف على الأقل" ValidationGroup="reg" />
            </div>

            <div class="form-field">
              <label class="form-label" for="<%= txtPasswordConfirm.ClientID %>"><%= T("تأكيد كلمة السر","Confirm password") %></label>
              <div class="input-wrap">
                <svg class="field-icon" viewBox="0 0 24 24"><use href="#ic-lock"/></svg>
                <asp:TextBox ID="txtPasswordConfirm" runat="server" CssClass="form-input" TextMode="Password"
                  MaxLength="100" placeholder="8 أحرف على الأقل" />
              </div>
              <asp:CompareValidator runat="server" ControlToValidate="txtPasswordConfirm"
                ControlToCompare="txtPassword" CssClass="field-error" Display="Dynamic"
                Text="كلمتا السر مش متطابقتين" ValidationGroup="reg" />
            </div>

            <asp:Button ID="btnRegister" runat="server" CssClass="btn btn-primary btn-lg"
              Text="إنشاء الحساب" ValidationGroup="reg" OnClick="btnRegister_Click" />
          </div>

          <p class="auth-switch">
            <%= T("عندك حساب بالفعل؟","Already have an account?") %>
            <a href="<%= ResolveUrl("~/Account/Login.aspx" + ReturnQuery) %>"><%= T("سجّل دخول","Sign in") %></a>
          </p>
        </div>
      </div>
    </div>
  </section>
</asp:Content>
