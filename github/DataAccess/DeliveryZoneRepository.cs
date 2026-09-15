using System.Collections.Generic;
using System.Data;
using Chocodelight_Website.Models;

namespace Chocodelight_Website.DataAccess
{
    public static class DeliveryZoneRepository
    {
        private static DeliveryZone Map(DataRow r)
        {
            return new DeliveryZone
            {
                Id = r.Int("Id"),
                NameAr = r.Str("NameAr"),
                NameEn = r.Str("NameEn"),
                Fee = r.Dec("Fee"),
                IsActive = r.Bool("IsActive"),
                SortOrder = r.Int("SortOrder")
            };
        }

        public static List<DeliveryZone> GetAll(bool activeOnly = true)
        {
            var list = new List<DeliveryZone>();
            var dt = Db.GetTable("dbo.sp_DeliveryZone_GetAll", Db.P("@ActiveOnly", activeOnly));
            foreach (DataRow r in dt.Rows) list.Add(Map(r));
            return list;
        }

        public static DeliveryZone GetById(int id)
        {
            var dt = Db.GetTable("dbo.sp_DeliveryZone_GetById", Db.P("@Id", id));
            return dt.Rows.Count == 0 ? null : Map(dt.Rows[0]);
        }
    }
}
