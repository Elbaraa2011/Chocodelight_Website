namespace Chocodelight_Website.Models
{
    public class Address
    {
        public int Id { get; set; }
        public int CustomerId { get; set; }
        public string Label { get; set; }
        public int ZoneId { get; set; }
        public string ZoneNameAr { get; set; }
        public string ZoneNameEn { get; set; }
        public decimal ZoneFee { get; set; }
        public string Details { get; set; }
        public string Landmark { get; set; }
        public string Phone { get; set; }
        public bool IsDefault { get; set; }

        public string ZoneName { get { return Helpers.CultureHelper.IsArabic ? ZoneNameAr : ZoneNameEn; } }
    }
}
