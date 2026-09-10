using System;

namespace Chocodelight_Website.Models
{
    public class Category
    {
        public int Id { get; set; }
        public string NameAr { get; set; }
        public string NameEn { get; set; }
        public string Slug { get; set; }
        public int SortOrder { get; set; }
        public bool IsActive { get; set; }
        public DateTime CreatedAt { get; set; }

        /// <summary>Localized name for the current UI language.</summary>
        public string Name
        {
            get { return Helpers.CultureHelper.IsArabic ? NameAr : NameEn; }
        }
    }
}
