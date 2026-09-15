<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="MyAccount.aspx.cs" Inherits="Chocodelight_Website.Account.MyAccountPage" %>

<asp:Content ContentPlaceHolderID="TitleContent" runat="server"><%= T("حسابي","My Account") %> — Choco Delight</asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
  <section class="section">
    <div class="wrap">
      <div class="cart-head">
        <h1 class="cart-title"><%= T("حسابي","My Account") %></h1>
        <a class="auth-forgot" href="<%= ResolveUrl("~/Account/Logout.ashx") %>"><%= T("تسجيل الخروج","Sign out") %></a>
      </div>

      <div class="account-tabs" style="display:flex;gap:var(--sp-2);border-block-end:1px solid var(--line);margin-block-end:var(--sp-6);">
        <a class='cat-tab <%= Tab == "orders" ? "is-active" : "" %>' href="?tab=orders" aria-selected='<%= Tab == "orders" %>'><%= T("طلباتي","Orders") %></a>
        <a class='cat-tab <%= Tab == "addresses" ? "is-active" : "" %>' href="?tab=addresses" aria-selected='<%= Tab == "addresses" %>'><%= T("العناوين","Addresses") %></a>
        <a class='cat-tab <%= Tab == "profile" ? "is-active" : "" %>' href="?tab=profile" aria-selected='<%= Tab == "profile" %>'><%= T("البيانات","Profile") %></a>
      </div>

      <asp:Panel ID="pnlMsg" runat="server" Visible="false" CssClass="form-success" style="display:block;margin-block-end:var(--sp-4);">
        <asp:Literal ID="litMsg" runat="server" />
      </asp:Panel>
      <asp:Panel ID="pnlErr" runat="server" Visible="false" CssClass="field-error" style="display:block;margin-block-end:var(--sp-4);">
        <asp:Literal ID="litErr" runat="server" />
      </asp:Panel>

      <%-- ORDERS --%>
      <asp:Panel ID="pnlOrders" runat="server">
        <asp:Panel ID="pnlNoOrders" runat="server" Visible="false" style="color:var(--text-muted);padding-block:var(--sp-6);">
          <%= T("لسه معملتش أي طلب. ابدأ من المنيو.","No orders yet. Start from the menu.") %>
        </asp:Panel>
        <asp:Repeater ID="rptOrders" runat="server">
          <HeaderTemplate><div style="display:flex;flex-direction:column;gap:var(--sp-3);"></HeaderTemplate>
          <ItemTemplate>
            <a class="order-row" href='<%# ResolveUrl("~/Account/OrderDetail.aspx?id=" + Eval("Id")) %>'
               style="display:flex;justify-content:space-between;align-items:center;gap:var(--sp-4);padding:var(--sp-4);border:1px solid var(--line);background:var(--surface);">
              <span>
                <strong><%# Eval("OrderNumber") %></strong>
                <span style="color:var(--text-muted);"> · <%# ((System.DateTime)Eval("CreatedAt")).ToString("yyyy-MM-dd") %></span>
                <span style="color:var(--text-muted);"> · <%# Eval("ItemCount") %> <%= T("منتج","items") %></span>
              </span>
              <span>
                <span class="status-pill"><%# Chocodelight_Website.Models.OrderStatus.Label((string)Eval("Status")) %></span>
                <strong style="margin-inline-start:var(--sp-3);"><%# Chocodelight_Website.Helpers.CultureHelper.Money((decimal)Eval("Total")) %></strong>
              </span>
            </a>
          </ItemTemplate>
          <FooterTemplate></div></FooterTemplate>
        </asp:Repeater>
      </asp:Panel>

      <%-- ADDRESSES --%>
      <asp:Panel ID="pnlAddresses" runat="server" Visible="false">
        <asp:Repeater ID="rptAddresses" runat="server" OnItemCommand="rptAddresses_ItemCommand">
          <ItemTemplate>
            <div class="address-card" style="border:1px solid var(--line);padding:var(--sp-4);margin-block-end:var(--sp-3);background:var(--surface);">
              <div style="display:flex;justify-content:space-between;gap:var(--sp-3);">
                <div>
                  <strong><%# string.IsNullOrEmpty((string)Eval("Label")) ? Eval("ZoneName") : Eval("Label") %></strong>
                  <%# (bool)Eval("IsDefault") ? "<span class=\"status-pill\">افتراضي</span>" : "" %>
                  <p style="color:var(--text-muted);margin-block-start:var(--sp-1);">
                    <%# Server.HtmlEncode((string)Eval("ZoneName")) %> — <%# Server.HtmlEncode((string)Eval("Details")) %>
                    <br /><%# Eval("Phone") %>
                  </p>
                </div>
                <div class="admin-table-actions" style="display:flex;gap:var(--sp-2);flex-wrap:wrap;align-items:flex-start;">
                  <asp:LinkButton runat="server" CssClass="admin-table-link" CommandName="edit" CommandArgument='<%# Eval("Id") %>' Text="تعديل" CausesValidation="false" />
                  <asp:LinkButton runat="server" CssClass="admin-table-link" CommandName="default" CommandArgument='<%# Eval("Id") %>' Text="اجعله افتراضي" CausesValidation="false" Visible='<%# !(bool)Eval("IsDefault") %>' />
                  <asp:LinkButton runat="server" CssClass="admin-table-link" CommandName="del" CommandArgument='<%# Eval("Id") %>' Text="حذف" CausesValidation="false" OnClientClick="return confirm('حذف العنوان؟');" />
                </div>
              </div>
            </div>
          </ItemTemplate>
        </asp:Repeater>

        <section class="admin-panel" style="margin-block-start:var(--sp-5);">
          <div class="admin-panel-head"><h2><asp:Literal ID="litAddrFormTitle" runat="server" Text="إضافة عنوان" /></h2></div>
          <div style="padding:var(--sp-5);display:grid;grid-template-columns:1fr 1fr;gap:var(--sp-4);">
            <asp:HiddenField ID="hfAddrId" runat="server" Value="0" />
            <div class="form-field"><label class="form-label">اسم العنوان (اختياري)</label>
              <asp:TextBox ID="txtAddrLabel" runat="server" CssClass="form-input" MaxLength="50" placeholder="المنزل / الشغل" /></div>
            <div class="form-field"><label class="form-label">منطقة التوصيل</label>
              <asp:DropDownList ID="ddlAddrZone" runat="server" CssClass="form-select" /></div>
            <div class="form-field" style="grid-column:1 / -1;"><label class="form-label">تفاصيل العنوان</label>
              <asp:TextBox ID="txtAddrDetails" runat="server" CssClass="form-textarea" TextMode="MultiLine" Rows="2" MaxLength="500" />
              <asp:RequiredFieldValidator runat="server" ControlToValidate="txtAddrDetails" CssClass="field-error" Display="Dynamic" Text="مطلوب" ValidationGroup="addr" /></div>
            <div class="form-field"><label class="form-label">علامة مميزة (اختياري)</label>
              <asp:TextBox ID="txtAddrLandmark" runat="server" CssClass="form-input" MaxLength="200" /></div>
            <div class="form-field"><label class="form-label">رقم التليفون</label>
              <asp:TextBox ID="txtAddrPhone" runat="server" CssClass="form-input" TextMode="Phone" MaxLength="20" placeholder="01xxxxxxxxx" />
              <asp:RequiredFieldValidator runat="server" ControlToValidate="txtAddrPhone" CssClass="field-error" Display="Dynamic" Text="مطلوب" ValidationGroup="addr" />
              <asp:RegularExpressionValidator runat="server" ControlToValidate="txtAddrPhone" CssClass="field-error" Display="Dynamic" ValidationExpression="^01[0-2,5]{1}[0-9]{8}$" Text="رقم موبايل غير صحيح" ValidationGroup="addr" /></div>
            <div class="form-field" style="grid-column:1 / -1;">
              <label class="check-label"><asp:CheckBox ID="chkAddrDefault" runat="server" /> اجعله العنوان الافتراضي</label>
            </div>
          </div>
          <div style="padding:var(--sp-4) var(--sp-6);border-block-start:1px solid var(--line);display:flex;gap:var(--sp-2);">
            <asp:Button ID="btnAddrSave" runat="server" CssClass="btn btn-primary" Text="حفظ العنوان" ValidationGroup="addr" OnClick="btnAddrSave_Click" />
            <asp:Button ID="btnAddrCancel" runat="server" CssClass="btn btn-ghost" Text="إلغاء" CausesValidation="false" Visible="false" OnClick="btnAddrCancel_Click" />
          </div>
        </section>
      </asp:Panel>

      <%-- PROFILE --%>
      <asp:Panel ID="pnlProfile" runat="server" Visible="false">
        <div style="display:grid;grid-template-columns:1fr 1fr;gap:var(--sp-8);align-items:start;">
          <section class="admin-panel">
            <div class="admin-panel-head"><h2>البيانات الشخصية</h2></div>
            <div style="padding:var(--sp-5);">
              <div class="form-field"><label class="form-label">الاسم الكامل</label>
                <asp:TextBox ID="txtProfileName" runat="server" CssClass="form-input" MaxLength="150" />
                <asp:RequiredFieldValidator runat="server" ControlToValidate="txtProfileName" CssClass="field-error" Display="Dynamic" Text="مطلوب" ValidationGroup="prof" /></div>
              <div class="form-field"><label class="form-label">البريد الإلكتروني</label>
                <asp:TextBox ID="txtProfileEmail" runat="server" CssClass="form-input" ReadOnly="true" /></div>
              <div class="form-field"><label class="form-label">رقم التليفون</label>
                <asp:TextBox ID="txtProfilePhone" runat="server" CssClass="form-input" TextMode="Phone" MaxLength="20" /></div>
              <asp:Button ID="btnProfileSave" runat="server" CssClass="btn btn-primary" Text="حفظ" ValidationGroup="prof" OnClick="btnProfileSave_Click" />
            </div>
          </section>
          <section class="admin-panel">
            <div class="admin-panel-head"><h2>تغيير كلمة السر</h2></div>
            <div style="padding:var(--sp-5);">
              <div class="form-field"><label class="form-label">كلمة السر الحالية</label>
                <asp:TextBox ID="txtCurrentPw" runat="server" CssClass="form-input" TextMode="Password" MaxLength="100" />
                <asp:RequiredFieldValidator runat="server" ControlToValidate="txtCurrentPw" CssClass="field-error" Display="Dynamic" Text="مطلوب" ValidationGroup="pw" /></div>
              <div class="form-field"><label class="form-label">كلمة السر الجديدة</label>
                <asp:TextBox ID="txtNewPw" runat="server" CssClass="form-input" TextMode="Password" MaxLength="100" placeholder="8 أحرف على الأقل" />
                <asp:RegularExpressionValidator runat="server" ControlToValidate="txtNewPw" CssClass="field-error" Display="Dynamic" ValidationExpression=".{8,}" Text="8 أحرف على الأقل" ValidationGroup="pw" /></div>
              <div class="form-field"><label class="form-label">تأكيد كلمة السر</label>
                <asp:TextBox ID="txtNewPwConfirm" runat="server" CssClass="form-input" TextMode="Password" MaxLength="100" />
                <asp:CompareValidator runat="server" ControlToValidate="txtNewPwConfirm" ControlToCompare="txtNewPw" CssClass="field-error" Display="Dynamic" Text="مش متطابقتين" ValidationGroup="pw" /></div>
              <asp:Button ID="btnChangePw" runat="server" CssClass="btn btn-primary" Text="تغيير كلمة السر" ValidationGroup="pw" OnClick="btnChangePw_Click" />
            </div>
          </section>
        </div>
      </asp:Panel>

    </div>
  </section>
</asp:Content>
