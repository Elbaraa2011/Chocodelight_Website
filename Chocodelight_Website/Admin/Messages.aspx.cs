using System;
using System.Web.UI.WebControls;
using Chocodelight_Website.DataAccess;
using Chocodelight_Website.Helpers;

namespace Chocodelight_Website.Admin
{
    public partial class AdminMessagesPage : BaseAdminPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack) BindGrid();
        }

        private void BindGrid()
        {
            var messages = ContactRepository.GetAll();
            rptMessages.DataSource = messages;
            rptMessages.DataBind();
            pnlEmpty.Visible = messages.Count == 0;
        }

        protected void rptMessages_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int id;
            if (!int.TryParse(Convert.ToString(e.CommandArgument), out id)) return;

            if (e.CommandName == "handle") ContactRepository.MarkHandled(id, true);
            else if (e.CommandName == "unhandle") ContactRepository.MarkHandled(id, false);
            else return;

            pnlMsg.Visible = true;
            litMsg.Text = "تم تحديث حالة الرسالة.";
            BindGrid();
        }
    }
}
