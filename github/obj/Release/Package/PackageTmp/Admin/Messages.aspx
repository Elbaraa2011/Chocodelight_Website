<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true"
    CodeBehind="Messages.aspx.cs" Inherits="Chocodelight_Website.Admin.AdminMessagesPage" %>

<asp:Content ContentPlaceHolderID="TitleContent" runat="server">رسائل الاتصال — Choco Delight</asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
  <div class="admin-page-head">
    <div><h1>رسائل الاتصال</h1><p class="admin-page-sub">الرسائل الواردة من فورم "اتصل بينا"</p></div>
  </div>

  <asp:Panel ID="pnlMsg" runat="server" Visible="false" CssClass="form-success" style="display:block;margin-block-end:var(--sp-4);">
    <asp:Literal ID="litMsg" runat="server" />
  </asp:Panel>

  <section class="admin-panel">
    <div class="table-wrap">
      <table class="admin-table">
        <thead><tr><th>الاسم</th><th>وسيلة التواصل</th><th>الرسالة</th><th>التاريخ</th><th>الحالة</th><th></th></tr></thead>
        <tbody>
          <asp:Repeater ID="rptMessages" runat="server" OnItemCommand="rptMessages_ItemCommand">
            <ItemTemplate>
              <tr>
                <td><%# Server.HtmlEncode((string)Eval("Name")) %></td>
                <td>
                  <%# Server.HtmlEncode((string)Eval("Email")) %>
                  <%# string.IsNullOrEmpty((string)Eval("Phone")) ? "" : "<br/>" + Server.HtmlEncode((string)Eval("Phone")) %>
                </td>
                <td style="max-width:340px;"><%# Server.HtmlEncode((string)Eval("Message")) %></td>
                <td><%# ((System.DateTime)Eval("CreatedAt")).ToString("yyyy-MM-dd HH:mm") %></td>
                <td><%# (bool)Eval("IsHandled") ? "تمت المعالجة" : "جديدة" %></td>
                <td>
                  <asp:LinkButton runat="server" CssClass="admin-table-link"
                    CommandName='<%# (bool)Eval("IsHandled") ? "unhandle" : "handle" %>'
                    CommandArgument='<%# Eval("Id") %>'
                    Text='<%# (bool)Eval("IsHandled") ? "إرجاع كجديدة" : "علّم كمعالجة" %>' />
                </td>
              </tr>
            </ItemTemplate>
          </asp:Repeater>
        </tbody>
      </table>
    </div>
    <asp:Panel ID="pnlEmpty" runat="server" Visible="false" style="padding:var(--sp-6);color:var(--text-muted);">لا توجد رسائل.</asp:Panel>
  </section>
</asp:Content>
