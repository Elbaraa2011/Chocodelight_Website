namespace Chocodelight_Website.Models
{
    public class DeliveryZone
    {
        public int Id { get; set; }
        public string NameAr { get; set; }
        public string NameEn { get; set; }
        public decimal Fee { get; set; }
        public bool IsActive { get; set; }
        public int SortOrder { get; set; }

        public string Name { get { return Helpers.CultureHelper.IsArabic ? NameAr : NameEn; } }
    }
}
