using System;
using System.Collections.Generic;

namespace Chocodelight_Website.Models
{
    public class Product
    {
        public int Id { get; set; }
        public int CategoryId { get; set; }
        public string CategoryNameAr { get; set; }
        public string CategoryNameEn { get; set; }
        public string CategorySlug { get; set; }

        public string NameAr { get; set; }
        public string NameEn { get; set; }
        public string DescriptionAr { get; set; }
        public string DescriptionEn { get; set; }

        public decimal BasePrice { get; set; }
        public string WeightNoteAr { get; set; }
        public string WeightNoteEn { get; set; }
        public string ImageUrl { get; set; }

        public bool IsActive { get; set; }
        public bool IsBestSeller { get; set; }
        public bool IsNew { get; set; }
        public int SortOrder { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime? UpdatedAt { get; set; }

        public List<ProductWeightOption> WeightOptions { get; set; } = new List<ProductWeightOption>();
        public List<ProductFlavor> Flavors { get; set; } = new List<ProductFlavor>();
        public bool HasFlavors { get { return Flavors != null && Flavors.Count > 0; } }

        public string Name { get { return Helpers.CultureHelper.IsArabic ? NameAr : NameEn; } }
        public string Description { get { return Helpers.CultureHelper.IsArabic ? DescriptionAr : DescriptionEn; } }
        public string WeightNote { get { return Helpers.CultureHelper.IsArabic ? WeightNoteAr : WeightNoteEn; } }
        public string CategoryName { get { return Helpers.CultureHelper.IsArabic ? CategoryNameAr : CategoryNameEn; } }

        /// <summary>Lowest available price (base price or cheapest weight option).</summary>
        public decimal DisplayFromPrice
        {
            get
            {
                decimal min = BasePrice;
                foreach (var w in WeightOptions)
                    if (w.Price < min) min = w.Price;
                return min;
            }
        }

        public bool HasWeightOptions { get { return WeightOptions != null && WeightOptions.Count > 0; } }
    }

    public class ProductWeightOption
    {
        public int Id { get; set; }
        public int ProductId { get; set; }
        public string LabelAr { get; set; }
        public string LabelEn { get; set; }
        public string Weight { get; set; }
        public decimal Price { get; set; }
        public int SortOrder { get; set; }

        public string Label { get { return Helpers.CultureHelper.IsArabic ? LabelAr : LabelEn; } }
    }

    public class ProductFlavor
    {
        public int Id { get; set; }
        public int ProductId { get; set; }
        public string NameAr { get; set; }
        public string NameEn { get; set; }
        public int SortOrder { get; set; }

        public string Name { get { return Helpers.CultureHelper.IsArabic ? NameAr : NameEn; } }
    }
}
