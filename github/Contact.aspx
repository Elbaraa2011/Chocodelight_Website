<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="Contact.aspx.cs" Inherits="Chocodelight_Website.ContactPage" %>

<asp:Content ContentPlaceHolderID="TitleContent" runat="server"><%= T("اتصل بينا","Contact") %> — Choco Delight</asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
  <section class="page-banner">
    <div class="wrap">
      <h1 class="page-title"><%= T("اتصل بينا","Get in Touch") %></h1>
      <p class="page-sub"><%= T("أي استفسار أو طلب خاص، ابعتلنا وهنرد عليك في أقرب وقت.",
            "Any question or special request — send us a message and we'll get back to you quickly.") %></p>
    </div>
  </section>

  <section class="section">
    <div class="wrap" style="display:grid;grid-template-columns:1.3fr 1fr;gap:var(--sp-8);align-items:start;">
      <div>
        <asp:Panel ID="pnlDone" runat="server" Visible="false" CssClass="form-success" style="display:block;">
          <svg viewBox="0 0 24 24" width="18" height="18" style="stroke:currentColor;fill:none;stroke-width:2"><use href="#ic-check"/></svg>
          <%= T("وصلتنا رسالتك، شكراً لتواصلك معانا! هنرد عليك قريب.",
                "We got your message — thank you! We'll reply soon.") %>
        </asp:Panel>

        <asp:Panel ID="pnlForm" runat="server" CssClass="auth-form">
          <div class="form-field">
            <label class="form-label" for="<%= txtName.ClientID %>"><%= T("الاسم","Name") %></label>
            <asp:TextBox ID="txtName" runat="server" CssClass="form-input" MaxLength="150" />
            <asp:RequiredFieldValidator runat="server" ControlToValidate="txtName" CssClass="field-error" Display="Dynamic" Text="الاسم مطلوب" ValidationGroup="ct" />
          </div>
          <div class="form-field">
            <label class="form-label" for="<%= txtEmail.ClientID %>"><%= T("البريد الإلكتروني","Email") %></label>
            <asp:TextBox ID="txtEmail" runat="server" CssClass="form-input" TextMode="Email" MaxLength="256" />
            <asp:RequiredFieldValidator runat="server" ControlToValidate="txtEmail" CssClass="field-error" Display="Dynamic" Text="البريد مطلوب" ValidationGroup="ct" />
            <asp:RegularExpressionValidator runat="server" ControlToValidate="txtEmail" CssClass="field-error" Display="Dynamic" ValidationExpression="^[^@\s]+@[^@\s]+\.[^@\s]+$" Text="بريد غير صحيح" ValidationGroup="ct" />
          </div>
          <div class="form-field">
            <label class="form-label" for="<%= txtPhone.ClientID %>"><%= T("رقم التليفون (اختياري)","Phone (optional)") %></label>
            <asp:TextBox ID="txtPhone" runat="server" CssClass="form-input" TextMode="Phone" MaxLength="20" placeholder="01xxxxxxxxx" />
          </div>
          <div class="form-field">
            <label class="form-label" for="<%= txtSubject.ClientID %>"><%= T("الموضوع (اختياري)","Subject (optional)") %></label>
            <asp:TextBox ID="txtSubject" runat="server" CssClass="form-input" MaxLength="200" />
          </div>
          <div class="form-field">
            <label class="form-label" for="<%= txtMessage.ClientID %>"><%= T("الرسالة","Message") %></label>
            <asp:TextBox ID="txtMessage" runat="server" CssClass="form-textarea" TextMode="MultiLine" Rows="5" MaxLength="2000" />
            <asp:RequiredFieldValidator runat="server" ControlToValidate="txtMessage" CssClass="field-error" Display="Dynamic" Text="الرسالة مطلوبة" ValidationGroup="ct" />
          </div>
          <asp:Button ID="btnSend" runat="server" CssClass="btn btn-primary btn-lg" Text="إرسال" ValidationGroup="ct" OnClick="btnSend_Click" />
        </asp:Panel>
      </div>

      <aside class="info-block">
        <h3><%= T("وسائل التواصل","Reach us") %></h3>
        <p class="footer-phone"><svg viewBox="0 0 24 24" width="18" height="18" style="stroke:currentColor;fill:none;stroke-width:1.6"><use href="#ic-phone"/></svg> +20 120 272 9855</p>
        <p><a href="https://wa.me/201202729855" target="_blank" rel="noopener">WhatsApp</a></p>
        <p><a href="https://www.instagram.com/chocoldelight22" target="_blank" rel="noopener">Instagram</a></p>
        <p><a href="https://www.facebook.com/ChocoDelight22/" target="_blank" rel="noopener">Facebook</a></p>
        <hr style="border:none;border-block-start:1px solid var(--line);margin-block:var(--sp-4);" />
        <p style="color:var(--text-muted);"><%= T("التوصيل داخل الإسكندرية فقط حاليًا، والدفع عند الاستلام.",
              "Delivery within Alexandria only for now, payment on delivery.") %></p>
      </aside>
    </div>
  </section>
</asp:Content>
