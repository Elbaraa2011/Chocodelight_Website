using System.Collections.Generic;
using System.Data;
using Chocodelight_Website.Models;

namespace Chocodelight_Website.DataAccess
{
    public static class CategoryRepository
    {
        public static Category Map(DataRow r)
        {
            return new Category
            {
                Id = r.Int("Id"),
                NameAr = r.Str("NameAr"),
                NameEn = r.Str("NameEn"),
                Slug = r.Str("Slug"),
                SortOrder = r.Int("SortOrder"),
                IsActive = r.Bool("IsActive"),
                CreatedAt = r.Date("CreatedAt")
            };
        }

        public static List<Category> GetAll(bool activeOnly = false)
        {
            var list = new List<Category>();
            var dt = Db.GetTable("dbo.sp_Category_GetAll", Db.P("@ActiveOnly", activeOnly));
            foreach (DataRow r in dt.Rows) list.Add(Map(r));
            return list;
        }

        public static Category GetById(int id)
        {
            var dt = Db.GetTable("dbo.sp_Category_GetById", Db.P("@Id", id));
            return dt.Rows.Count == 0 ? null : Map(dt.Rows[0]);
        }

        public static int Insert(Category c)
        {
            var result = Db.GetScalar("dbo.sp_Category_Insert",
                Db.P("@NameAr", c.NameAr), Db.P("@NameEn", c.NameEn), Db.P("@Slug", c.Slug),
                Db.P("@SortOrder", c.SortOrder), Db.P("@IsActive", c.IsActive));
            return System.Convert.ToInt32(result);
        }

        public static void Update(Category c)
        {
            Db.Execute("dbo.sp_Category_Update",
                Db.P("@Id", c.Id), Db.P("@NameAr", c.NameAr), Db.P("@NameEn", c.NameEn),
                Db.P("@Slug", c.Slug), Db.P("@SortOrder", c.SortOrder), Db.P("@IsActive", c.IsActive));
        }

        public static void Delete(int id)
        {
            Db.Execute("dbo.sp_Category_Delete", Db.P("@Id", id));
        }
    }
}
