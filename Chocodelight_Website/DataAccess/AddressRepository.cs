using System;
using System.Collections.Generic;
using System.Data;
using Chocodelight_Website.Models;

namespace Chocodelight_Website.DataAccess
{
    public static class AddressRepository
    {
        private static Address Map(DataRow r)
        {
            return new Address
            {
                Id = r.Int("Id"),
                CustomerId = r.Int("CustomerId"),
                Label = r.Str("Label"),
                ZoneId = r.Int("ZoneId"),
                ZoneNameAr = r.Str("ZoneNameAr"),
                ZoneNameEn = r.Str("ZoneNameEn"),
                ZoneFee = r.Dec("ZoneFee"),
                Details = r.Str("Details"),
                Landmark = r.Str("Landmark"),
                Phone = r.Str("Phone"),
                IsDefault = r.Bool("IsDefault")
            };
        }

        public static List<Address> GetByCustomer(int customerId)
        {
            var list = new List<Address>();
            var dt = Db.GetTable("dbo.sp_Address_GetByCustomer", Db.P("@CustomerId", customerId));
            foreach (DataRow r in dt.Rows) list.Add(Map(r));
            return list;
        }

        public static Address GetById(int id)
        {
            var dt = Db.GetTable("dbo.sp_Address_GetById", Db.P("@Id", id));
            return dt.Rows.Count == 0 ? null : Map(dt.Rows[0]);
        }

        public static int Insert(Address a)
        {
            var result = Db.GetScalar("dbo.sp_Address_Insert",
                Db.P("@CustomerId", a.CustomerId), Db.P("@Label", (object)a.Label ?? DBNull.Value),
                Db.P("@ZoneId", a.ZoneId), Db.P("@Details", a.Details),
                Db.P("@Landmark", (object)a.Landmark ?? DBNull.Value),
                Db.P("@Phone", a.Phone), Db.P("@IsDefault", a.IsDefault));
            return Convert.ToInt32(result);
        }

        public static void Update(Address a)
        {
            Db.Execute("dbo.sp_Address_Update",
                Db.P("@Id", a.Id), Db.P("@CustomerId", a.CustomerId),
                Db.P("@Label", (object)a.Label ?? DBNull.Value), Db.P("@ZoneId", a.ZoneId),
                Db.P("@Details", a.Details), Db.P("@Landmark", (object)a.Landmark ?? DBNull.Value),
                Db.P("@Phone", a.Phone), Db.P("@IsDefault", a.IsDefault));
        }

        public static void Delete(int id, int customerId)
        {
            Db.Execute("dbo.sp_Address_Delete", Db.P("@Id", id), Db.P("@CustomerId", customerId));
        }

        public static void SetDefault(int id, int customerId)
        {
            Db.Execute("dbo.sp_Address_SetDefault", Db.P("@Id", id), Db.P("@CustomerId", customerId));
        }
    }
}
