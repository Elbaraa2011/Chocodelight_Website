using BCryptNet = BCrypt.Net.BCrypt;

namespace Chocodelight_Website.Services
{
    /// <summary>Wraps BCrypt.Net-Next so the rest of the app never references it directly.</summary>
    public static class PasswordHasher
    {
        private const int WorkFactor = 11;

        public static string Hash(string plainText)
        {
            return BCryptNet.HashPassword(plainText, WorkFactor);
        }

        public static bool Verify(string plainText, string hash)
        {
            if (string.IsNullOrEmpty(plainText) || string.IsNullOrEmpty(hash)) return false;
            try
            {
                return BCryptNet.Verify(plainText, hash);
            }
            catch (BCrypt.Net.SaltParseException)
            {
                return false;
            }
        }
    }
}
