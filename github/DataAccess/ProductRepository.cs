using System;
using System.Collections.Generic;
using System.Data;
using Chocodelight_Website.Models;

namespace Chocodelight_Website.DataAccess
{
    public static class ProductRepository
    {
        private static Product MapProduct(DataRow r)
        {
            return new Product
            {
                Id = r.Int("Id"),
                CategoryId = r.Int("CategoryId"),
                CategoryNameAr = r.Str("CategoryNameAr"),
                CategoryNameEn = r.Str("CategoryNameEn"),
                CategorySlug = r.Str("CategorySlug"),
                NameAr = r.Str("NameAr"),
                NameEn = r.Str("NameEn"),
                DescriptionAr = r.Str("DescriptionAr"),
                DescriptionEn = r.Str("DescriptionEn"),
                BasePrice = r.Dec("BasePrice"),
                WeightNoteAr = r.Str("WeightNoteAr"),
                WeightNoteEn = r.Str("WeightNoteEn"),
                ImageUrl = r.Str("ImageUrl"),
                IsActive = r.Bool("IsActive"),
                IsBestSeller = r.Bool("IsBestSeller"),
                IsNew = r.Bool("IsNew"),
                SortOrder = r.Int("SortOrder"),
                CreatedAt = r.Date("CreatedAt"),
                UpdatedAt = r.DateN("UpdatedAt")
            };
        }

        private static ProductWeightOption MapOption(DataRow r)
        {
            return new ProductWeightOption
            {
                Id = r.Int("Id"),
                ProductId = r.Int("ProductId"),
                LabelAr = r.Str("LabelAr"),
                LabelEn = r.Str("LabelEn"),
                Weight = r.Str("Weight"),
                Price = r.Dec("Price"),
                SortOrder = r.Int("SortOrder")
            };
        }

        public static List<Product> GetList(int? categoryId = null, string categorySlug = null,
            string search = null, bool activeOnly = true)
        {
            var list = new List<Product>();
            var dt = Db.GetTable("dbo.sp_Product_GetList",
                Db.P("@CategoryId", (object)categoryId ?? DBNull.Value),
                Db.P("@CategorySlug", (object)categorySlug ?? DBNull.Value),
                Db.P("@Search", (object)search ?? DBNull.Value),
                Db.P("@ActiveOnly", activeOnly));
            foreach (DataRow r in dt.Rows) list.Add(MapProduct(r));
            return list;
        }

        public static List<Product> GetFeatured(int take = 6)
        {
            var list = new List<Product>();
            var dt = Db.GetTable("dbo.sp_Product_GetFeatured", Db.P("@Take", take));
            foreach (DataRow r in dt.Rows)
            {
                list.Add(new Product
                {
                    Id = r.Int("Id"),
                    CategoryId = r.Int("CategoryId"),
                    NameAr = r.Str("NameAr"),
                    NameEn = r.Str("NameEn"),
                    BasePrice = r.Dec("BasePrice"),
                    WeightNoteAr = r.Str("WeightNoteAr"),
                    WeightNoteEn = r.Str("WeightNoteEn"),
                    ImageUrl = r.Str("ImageUrl"),
                    IsBestSeller = r.Bool("IsBestSeller"),
                    IsNew = r.Bool("IsNew"),
                    IsActive = true
                });
            }
            return list;
        }

        /// <summary>Full product with its weight options, or null if not found.</summary>
        public static Product GetById(int id)
        {
            var ds = Db.GetDataSet("dbo.sp_Product_GetById", Db.P("@Id", id));
            if (ds.Tables.Count == 0 || ds.Tables[0].Rows.Count == 0) return null;

            var p = MapProduct(ds.Tables[0].Rows[0]);
            if (ds.Tables.Count > 1)
                foreach (DataRow r in ds.Tables[1].Rows)
                    p.WeightOptions.Add(MapOption(r));
            if (ds.Tables.Count > 2)
                foreach (DataRow r in ds.Tables[2].Rows)
                    p.Flavors.Add(new ProductFlavor
                    {
                        Id = r.Int("Id"),
                        ProductId = r.Int("ProductId"),
                        NameAr = r.Str("NameAr"),
                        NameEn = r.Str("NameEn"),
                        SortOrder = r.Int("SortOrder")
                    });
            return p;
        }

        public static void ClearFlavors(int productId)
        {
            Db.Execute("dbo.sp_ProductFlavor_ClearByProduct", Db.P("@ProductId", productId));
        }

        public static int AddFlavor(ProductFlavor f)
        {
            var result = Db.GetScalar("dbo.sp_ProductFlavor_Add",
                Db.P("@ProductId", f.ProductId), Db.P("@NameAr", f.NameAr),
                Db.P("@NameEn", f.NameEn), Db.P("@SortOrder", f.SortOrder));
            return Convert.ToInt32(result);
        }

        public static int Insert(Product p)
        {
            var result = Db.GetScalar("dbo.sp_Product_Insert",
                Db.P("@CategoryId", p.CategoryId), Db.P("@NameAr", p.NameAr), Db.P("@NameEn", p.NameEn),
                Db.P("@DescriptionAr", (object)p.DescriptionAr ?? DBNull.Value),
                Db.P("@DescriptionEn", (object)p.DescriptionEn ?? DBNull.Value),
                Db.P("@BasePrice", p.BasePrice),
                Db.P("@WeightNoteAr", (object)p.WeightNoteAr ?? DBNull.Value),
                Db.P("@WeightNoteEn", (object)p.WeightNoteEn ?? DBNull.Value),
                Db.P("@ImageUrl", (object)p.ImageUrl ?? DBNull.Value),
                Db.P("@IsActive", p.IsActive), Db.P("@IsBestSeller", p.IsBestSeller),
                Db.P("@IsNew", p.IsNew), Db.P("@SortOrder", p.SortOrder));
            return Convert.ToInt32(result);
        }

        public static void Update(Product p)
        {
            Db.Execute("dbo.sp_Product_Update",
                Db.P("@Id", p.Id), Db.P("@CategoryId", p.CategoryId),
                Db.P("@NameAr", p.NameAr), Db.P("@NameEn", p.NameEn),
                Db.P("@DescriptionAr", (object)p.DescriptionAr ?? DBNull.Value),
                Db.P("@DescriptionEn", (object)p.DescriptionEn ?? DBNull.Value),
                Db.P("@BasePrice", p.BasePrice),
                Db.P("@WeightNoteAr", (object)p.WeightNoteAr ?? DBNull.Value),
                Db.P("@WeightNoteEn", (object)p.WeightNoteEn ?? DBNull.Value),
                Db.P("@ImageUrl", (object)p.ImageUrl ?? DBNull.Value),
                Db.P("@IsActive", p.IsActive), Db.P("@IsBestSeller", p.IsBestSeller),
                Db.P("@IsNew", p.IsNew), Db.P("@SortOrder", p.SortOrder));
        }

        public static bool ToggleActive(int id)
        {
            var result = Db.GetScalar("dbo.sp_Product_ToggleActive", Db.P("@Id", id));
            return result != null && result != DBNull.Value && Convert.ToBoolean(result);
        }

        public static void Delete(int id)
        {
            Db.Execute("dbo.sp_Product_Delete", Db.P("@Id", id));
        }

        public static void ClearWeightOptions(int productId)
        {
            Db.Execute("dbo.sp_ProductWeightOption_ClearByProduct", Db.P("@ProductId", productId));
        }

        public static int AddWeightOption(ProductWeightOption o)
        {
            var result = Db.GetScalar("dbo.sp_ProductWeightOption_Add",
                Db.P("@ProductId", o.ProductId), Db.P("@LabelAr", o.LabelAr), Db.P("@LabelEn", o.LabelEn),
                Db.P("@Weight", (object)o.Weight ?? DBNull.Value), Db.P("@Price", o.Price),
                Db.P("@SortOrder", o.SortOrder));
            return Convert.ToInt32(result);
        }
    }
}
