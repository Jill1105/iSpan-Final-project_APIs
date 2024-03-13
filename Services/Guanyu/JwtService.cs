using HotelFuen31.APIs.Models;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;

namespace HotelFuen31.APIs.Services.Guanyu
{
    public class JwtService
    {
        private readonly AppDbContext _db;
        public JwtService(AppDbContext db)
        {
            _db = db;
        }

        //加密
        public string EncryptWithJWT(int id, string str)
        {
            //byte[] keyBytes = new byte[32];
            //using (var rng = new RNGCryptoServiceProvider())
            //{
            //    rng.GetBytes(keyBytes);
            //}
            //string randomBase64String = Convert.ToBase64String(keyBytes);

            byte[] keyBytes2 = Encoding.UTF8.GetBytes(str);

            //建立SymmetricSecurityKey
            var securityKey = new SymmetricSecurityKey(keyBytes2);

            var signingCredentials = new SigningCredentials(securityKey, SecurityAlgorithms.HmacSha256);

            var claims = new List<Claim> {
                new Claim("ID",$"{id}")
            };
            try
            {
                var token = new JwtSecurityToken(
                issuer: "issuer",
                audience: "Audience",
                claims: claims,
                expires: DateTime.UtcNow.AddHours(5),
                signingCredentials: signingCredentials
                );
                var tokenString = new JwtSecurityTokenHandler().WriteToken(token);

                return tokenString;
            }
            catch (Exception ex)
            {
                return $"錯誤訊息：{ex.Message}";
            }
        }

        //解密
        public string Decrypt(string str, int id)
        {
            id = 2;
            string key = _db.Members.Where(m => m.Id == id).FirstOrDefault().Key;
            SecurityKey securityKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(key));

            var tokenHandler = new JwtSecurityTokenHandler();
            var token = tokenHandler.ReadJwtToken(str);

            var validationParameters = new TokenValidationParameters
            {
                // 這裡設置驗證金鑰
                IssuerSigningKey = securityKey,
                ValidateIssuer = false, // 是否驗證Issuer
                ValidIssuer = "issuer", // 有效的Issuer
                ValidateAudience = false, // 是否驗證Audience
                ValidAudience = "Audience", // 有效的Audience
                ValidateLifetime = false, // 是否驗證Token有效期
                ClockSkew = TimeSpan.Zero // Token有效期的允许偏移量
            };
            try
            {
                var principal = tokenHandler.ValidateToken(str, validationParameters, out SecurityToken validatedToken);

                foreach (var claim in principal.Claims) return claim.Value;
                return "解密失敗";
            }
            catch
            {
                return "解密失敗";
            }
        }

    }
}
