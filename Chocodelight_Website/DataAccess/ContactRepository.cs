using System;
using System.Collections.Generic;
using System.Data;

namespace Chocodelight_Website.DataAccess
{
    public class ContactMessage
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Email { get; set; }
        public string Phone { get; set; }
        public string Subject { get; set; }
        public string Message { get; set; }
        public bool IsHandled { get; set; }
        public DateTime CreatedAt { get; set; }
    }

    public static class ContactRepository
    {
        public static int Insert(string name, string email, string phone, string subject, string message)
        {
            var result = Db.GetScalar("dbo.sp_ContactMessage_Insert",
                Db.P("@Name", name), Db.P("@Email", email),
                Db.P("@Phone", (object)phone ?? DBNull.Value),
                Db.P("@Subject", (object)subject ?? DBNull.Value),
                Db.P("@Message", message));
            return Convert.ToInt32(result);
        }

        public static List<ContactMessage> GetAll(bool unhandledOnly = false)
        {
            var list = new List<ContactMessage>();
            var dt = Db.GetTable("dbo.sp_ContactMessage_GetAll", Db.P("@UnhandledOnly", unhandledOnly));
            foreach (DataRow r in dt.Rows)
            {
                list.Add(new ContactMessage
                {
                    Id = r.Int("Id"),
                    Name = r.Str("Name"),
                    Email = r.Str("Email"),
                    Phone = r.Str("Phone"),
                    Subject = r.Str("Subject"),
                    Message = r.Str("Message"),
                    IsHandled = r.Bool("IsHandled"),
                    CreatedAt = r.Date("CreatedAt")
                });
            }
            return list;
        }

        public static void MarkHandled(int id, bool handled)
        {
            Db.Execute("dbo.sp_ContactMessage_MarkHandled", Db.P("@Id", id), Db.P("@Handled", handled));
        }
    }
}
