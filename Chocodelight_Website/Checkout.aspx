<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="Checkout.aspx.cs" Inherits="Chocodelight_Website.CheckoutPage" %>

<asp:Content ContentPlaceHolderID="TitleContent" runat="server"><%= T("إتمام الطلب","Checkout") %> — Choco Delight</asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
  <section class="section">
    <div class="wrap">
      <div class="checkout-head">
        <h1><%= T("إتمام الطلب","Checkout") %></h1>
        <a class="breadcrumb" href="<%= ResolveUrl("~/Cart.aspx") %>">&larr; <%= T("رجوع للسلة","Back to cart") %></a>
      </div>

      <asp:Panel ID="pnlError" runat="server" CssClass="field-error" Visible="false" style="display:block;margin-block:var(--sp-4);">
        <asp:Literal ID="litError" runat="server" />
      </asp:Panel>

      <div class="checkout-layout" style="display:grid;grid-template-columns:1.4fr 1fr;gap:var(--sp-8);align-items:start;">

        <div class="checkout-forms">
          <asp:Panel ID="pnlSavedAddresses" runat="server" Visible="false" CssClass="option-group">
            <div class="option-label"><span><%= T("عنوان محفوظ","Saved address") %></span></div>
            <asp:DropDownList ID="ddlSavedAddress" runat="server" CssClass="form-select"
              AutoPostBack="true" OnSelectedIndexChanged="ddlSavedAddress_Changed" />
          </asp:Panel>

          <h2 class="summary-title"><%= T("بيانات المستلم","Recipient details") %></h2>

          <div class="form-field">
            <label class="form-label" for="<%= txtRecipient.ClientID %>"><%= T("اسم المستلم","Recipient name") %></label>
            <asp:TextBox ID="txtRecipient" runat="server" CssClass="form-input" MaxLength="150" />
            <asp:RequiredFieldValidator runat="server" ControlToValidate="txtRecipient" CssClass="field-error"
              Display="Dynamic" Text="اسم المستلم مطلوب" ValidationGroup="co" />
          </div>

          <div class="form-field">
            <label class="form-label" for="<%= txtPhone.ClientID %>"><%= T("رقم تليفون المستلم","Recipient phone") %></label>
            <asp:TextBox ID="txtPhone" runat="server" CssClass="form-input" TextMode="Phone" MaxLength="20" placeholder="01xxxxxxxxx" />
            <asp:RequiredFieldValidator runat="server" ControlToValidate="txtPhone" CssClass="field-error"
              Display="Dynamic" Text="رقم التليفون مطلوب" ValidationGroup="co" />
            <asp:RegularExpressionValidator runat="server" ControlToValidate="txtPhone" CssClass="field-error"
              Display="Dynamic" ValidationExpression="^01[0-2,5]{1}[0-9]{8}$" Text="رقم موبايل مصري غير صحيح" ValidationGroup="co" />
          </div>

          <div class="form-field">
            <label class="form-label" for="<%= ddlZone.ClientID %>"><%= T("منطقة التوصيل","Delivery area") %></label>
            <asp:DropDownList ID="ddlZone" runat="server" CssClass="form-select"
              AutoPostBack="true" OnSelectedIndexChanged="ddlZone_Changed" />
          </div>

          <div class="form-field">
            <label class="form-label" for="<%= txtDetails.ClientID %>"><%= T("تفاصيل العنوان","Address details") %></label>
            <asp:TextBox ID="txtDetails" runat="server" CssClass="form-textarea" TextMode="MultiLine" Rows="2"
              MaxLength="500" placeholder="الشارع، رقم العمارة، الدور، الشقة" />
            <asp:RequiredFieldValidator runat="server" ControlToValidate="txtDetails" CssClass="field-error"
              Display="Dynamic" Text="تفاصيل العنوان مطلوبة" ValidationGroup="co" />
          </div>

          <div class="form-field">
            <label class="form-label" for="<%= txtLandmark.ClientID %>"><%= T("علامة مميزة (اختياري)","Landmark (optional)") %></label>
            <asp:TextBox ID="txtLandmark" runat="server" CssClass="form-input" MaxLength="200" placeholder="مثال: جنب صيدلية العزبي" />
          </div>

          <div class="form-field">
            <label class="check-label">
              <asp:CheckBox ID="chkSaveAddress" runat="server" /> <%= T("احفظ العنوان ده في حسابي","Save this address to my account") %>
            </label>
          </div>

          <h2 class="summary-title" style="margin-block-start:var(--sp-6);"><%= T("رسالة الهدية","Gift message") %></h2>
          <div class="form-field">
            <label class="form-label" for="<%= txtGift.ClientID %>"><%= T("كرت تهنئة مجاني مع كل طلب","A free gift card with every order") %></label>
            <asp:TextBox ID="txtGift" runat="server" CssClass="form-textarea" TextMode="MultiLine" Rows="2"
              MaxLength="500" placeholder="اكتب رسالتك هنا... (اختياري)" />
          </div>

          <div class="form-field">
            <label class="form-label" for="<%= txtNote.ClientID %>"><%= T("ملاحظات للطلب (اختياري)","Order notes (optional)") %></label>
            <asp:TextBox ID="txtNote" runat="server" CssClass="form-textarea" TextMode="MultiLine" Rows="2" MaxLength="500" />
          </div>
        </div>

        <div class="summary-card">
          <h2 class="summary-title"><%= T("ملخص الطلب","Order Summary") %></h2>

          <asp:Repeater ID="rptItems" runat="server">
            <ItemTemplate>
              <div class="summary-row">
                <span><%# Server.HtmlEncode(GetItemLabel(Container.DataItem)) %> &times; <%# Eval("Quantity") %></span>
                <span class="val"><%# Chocodelight_Website.Helpers.CultureHelper.Money((decimal)Eval("LineTotal")) %></span>
              </div>
            </ItemTemplate>
          </asp:Repeater>

          <div class="summary-divider"></div>
          <div class="summary-row">
            <span><%= T("الإجمالي الفرعي","Subtotal") %></span>
            <span class="val"><asp:Literal ID="litSubtotal" runat="server" /></span>
          </div>
          <div class="summary-row">
            <span><%= T("مصاريف التوصيل","Delivery fee") %></span>
            <span class="val"><asp:Literal ID="litDeliveryFee" runat="server" /></span>
          </div>
          <div class="summary-divider"></div>
          <div class="summary-total">
            <span><%= T("الإجمالي","Total") %></span>
            <span class="val"><asp:Literal ID="litTotal" runat="server" /></span>
          </div>

          <div class="summary-row" style="margin-block-start:var(--sp-4);">
            <span><%= T("طريقة الدفع","Payment") %></span>
            <span class="val"><%= T("الدفع عند الاستلام","Cash on delivery") %></span>
          </div>

          <asp:Button ID="btnPlaceOrder" runat="server" CssClass="btn btn-primary btn-lg"
            style="margin-block-start:var(--sp-6);" Text="أكّد الطلب" ValidationGroup="co"
            OnClick="btnPlaceOrder_Click" />

          <div class="trust-row">
            <div class="trust-item"><svg viewBox="0 0 24 24"><use href="#ic-truck"/></svg><span><%= T("توصيل لكل مناطق الإسكندرية","Delivery across Alexandria") %></span></div>
            <div class="trust-item"><svg viewBox="0 0 24 24"><use href="#ic-cash"/></svg><span><%= T("الدفع عند الاستلام","Cash on delivery") %></span></div>
          </div>
        </div>

      </div>
    </div>
  </section>
</asp:Content>
