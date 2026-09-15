<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="ForgotPassword.aspx.cs" Inherits="Chocodelight_Website.Account.ForgotPasswordPage" %>

<asp:Content ContentPlaceHolderID="TitleContent" runat="server"><%= T("استعادة كلمة السر","Reset password") %> — Choco Delight</asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
  <section class="section">
    <div class="wrap">
      <div class="auth-wrap">
        <div class="auth-card">
          <div class="auth-icon"><svg viewBox="0 0 100 100"><use href="#ic-hex"/></svg></div>

          <asp:Panel ID="pnlRequest" runat="server">
            <h1 class="auth-title"><%= T("نسيت كلمة السر؟","Forgot your password?") %></h1>
            <p class="auth-sub"><%= T("اكتب بريدك وهنبعتلك رابط لإعادة التعيين.",
                  "Enter your email and we'll send you a reset link.") %></p>

            <asp:Panel ID="pnlRequestDone" runat="server" Visible="false" CssClass="form-success" style="display:block;">
              <%= T("لو البريد ده مسجّل عندنا، هيوصلك رابط إعادة التعيين خلال دقائق.",
                    "If that email is registered, a reset link is on its way.") %>
            </asp:Panel>

            <asp:Panel ID="pnlRequestForm" runat="server">
              <div class="form-field">
                <label class="form-label" for="<%= txtEmail.ClientID %>"><%= T("البريد الإلكتروني","Email") %></label>
                <div class="input-wrap">
                  <svg class="field-icon" viewBox="0 0 24 24"><use href="#ic-mail"/></svg>
                  <asp:TextBox ID="txtEmail" runat="server" CssClass="form-input" TextMode="Email" MaxLength="256" />
                </div>
                <asp:RequiredFieldValidator runat="server" ControlToValidate="txtEmail" CssClass="field-error"
                  Display="Dynamic" Text="البريد مطلوب" ValidationGroup="req" />
              </div>
              <asp:Button ID="btnRequest" runat="server" CssClass="btn btn-primary btn-lg"
                Text="أرسل الرابط" ValidationGroup="req" OnClick="btnRequest_Click" />

              <asp:Panel ID="pnlDevLink" runat="server" Visible="false" CssClass="form-field" style="margin-block-start:var(--sp-4);">
                <small style="color:var(--text-muted);">رابط التطوير (SMTP غير مفعّل):</small><br />
                <asp:HyperLink ID="lnkDev" runat="server" />
              </asp:Panel>
            </asp:Panel>
          </asp:Panel>

          <asp:Panel ID="pnlReset" runat="server" Visible="false">
            <h1 class="auth-title"><%= T("كلمة سر جديدة","Set a new password") %></h1>

            <asp:Panel ID="pnlResetInvalid" runat="server" Visible="false" CssClass="field-error" style="display:block;">
              <%= T("الرابط غير صحيح أو انتهت صلاحيته. اطلب رابط جديد.",
                    "This link is invalid or has expired. Please request a new one.") %>
            </asp:Panel>

            <asp:Panel ID="pnlResetDone" runat="server" Visible="false" CssClass="form-success" style="display:block;">
              <%= T("تم تغيير كلمة السر. تقدر تسجّل دخول دلوقتي.","Your password has been changed. You can sign in now.") %>
              <br /><a class="btn btn-primary" style="margin-block-start:var(--sp-4);" href="<%= ResolveUrl("~/Account/Login.aspx") %>"><%= T("تسجيل الدخول","Sign in") %></a>
            </asp:Panel>

            <asp:Panel ID="pnlResetForm" runat="server">
              <div class="form-field">
                <label class="form-label" for="<%= txtNewPassword.ClientID %>"><%= T("كلمة السر الجديدة","New password") %></label>
                <div class="input-wrap">
                  <svg class="field-icon" viewBox="0 0 24 24"><use href="#ic-lock"/></svg>
                  <asp:TextBox ID="txtNewPassword" runat="server" CssClass="form-input" TextMode="Password" MaxLength="100" placeholder="8 أحرف على الأقل" />
                </div>
                <asp:RequiredFieldValidator runat="server" ControlToValidate="txtNewPassword" CssClass="field-error"
                  Display="Dynamic" Text="مطلوب" ValidationGroup="rst" />
                <asp:RegularExpressionValidator runat="server" ControlToValidate="txtNewPassword" CssClass="field-error"
                  Display="Dynamic" ValidationExpression=".{8,}" Text="8 أحرف على الأقل" ValidationGroup="rst" />
              </div>
              <div class="form-field">
                <label class="form-label" for="<%= txtConfirm.ClientID %>"><%= T("تأكيد كلمة السر","Confirm password") %></label>
                <div class="input-wrap">
                  <svg class="field-icon" viewBox="0 0 24 24"><use href="#ic-lock"/></svg>
                  <asp:TextBox ID="txtConfirm" runat="server" CssClass="form-input" TextMode="Password" MaxLength="100" />
                </div>
                <asp:CompareValidator runat="server" ControlToValidate="txtConfirm" ControlToCompare="txtNewPassword"
                  CssClass="field-error" Display="Dynamic" Text="كلمتا السر مش متطابقتين" ValidationGroup="rst" />
              </div>
              <asp:Button ID="btnReset" runat="server" CssClass="btn btn-primary btn-lg"
                Text="تغيير كلمة السر" ValidationGroup="rst" OnClick="btnReset_Click" />
            </asp:Panel>
          </asp:Panel>

          <p class="auth-switch"><a href="<%= ResolveUrl("~/Account/Login.aspx") %>"><%= T("رجوع لتسجيل الدخول","Back to sign in") %></a></p>
        </div>
      </div>
    </div>
  </section>
</asp:Content>
