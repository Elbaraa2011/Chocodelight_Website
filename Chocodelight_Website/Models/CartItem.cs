using System;

namespace Chocodelight_Website.Models
{
    /// <summary>A line in the session-based shopping cart.</summary>
    [Serializable]
    public class CartItem
    {
        public int ProductId { get; set; }
        public string ProductNameAr { get; set; }
        public string ProductNameEn { get; set; }
        public int? WeightOptionId { get; set; }
        public string WeightLabelAr { get; set; }
        public string WeightLabelEn { get; set; }
        public string FlavorAr { get; set; }
        public string FlavorEn { get; set; }
        public decimal UnitPrice { get; set; }
        public int Quantity { get; set; }
        public string ImageUrl { get; set; }

        public decimal LineTotal { get { return UnitPrice * Quantity; } }
        public string ProductName { get { return Helpers.CultureHelper.IsArabic ? ProductNameAr : ProductNameEn; } }
        public string WeightLabel { get { return Helpers.CultureHelper.IsArabic ? WeightLabelAr : WeightLabelEn; } }
        public string Flavor { get { return Helpers.CultureHelper.IsArabic ? FlavorAr : FlavorEn; } }

        /// <summary>Human-readable options line for cart / order display.</summary>
        public string OptionsText
        {
            get
            {
                var parts = new System.Collections.Generic.List<string>();
                if (!string.IsNullOrEmpty(WeightLabel)) parts.Add(WeightLabel);
                if (!string.IsNullOrEmpty(Flavor)) parts.Add(Flavor);
                return string.Join(" · ", parts);
            }
        }

        /// <summary>Identity key: same product + same weight option + same flavour = same line.</summary>
        public string Key
        {
            get { return ProductId + ":" + (WeightOptionId?.ToString() ?? "0") + ":" + (FlavorEn ?? FlavorAr ?? ""); }
        }
    }
}
