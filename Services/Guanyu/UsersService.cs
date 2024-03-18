using HotelFuen31.APIs.Dtos;
using HotelFuen31.APIs.Interface.Guanyu;
using HotelFuen31.APIs.Models;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Security.Cryptography;

namespace HotelFuen31.APIs.Services.Guanyu
{
    public class UsersService : IUser
    {
        private AppDbContext _db;
        private readonly JwtService _jwt;
        
        public UsersService(AppDbContext db,JwtService jwt)
        {
            _db = db;
            _jwt = jwt;
        }

        public int GetMemberId(string phone, string pwd)
        {
            var members = _db.Members.Where(m => m.Phone.Contains(phone) && m.Password.Contains(pwd));
            if (members != null)
            {
                foreach (var item in members) return item.Id;
                return -1;
            }
            else
            {
                return -1;
            }
        }

        public Member GetMemberData(int id)
        {
            return _db.Members.Where(m => m.Id == id).FirstOrDefault();
        }

        public Member GetMemberData(string phone, string pwd)
        {
            return _db.Members.Where(m => m.Phone.Contains(phone) && m.Password.Contains(pwd)).FirstOrDefault();
        }

        public string GetMemberKey(int id)
        {
            return _db.Members.Where(m => m.Id == id).FirstOrDefault().Phone;
        }

        public void NewCipher(Cipher cipher)
        {
            var check = _db.Ciphers.Where(c => c.UserId == cipher.UserId).FirstOrDefault();

            if (check != null)
            {
                check.CipherString = cipher.CipherString;
            }
            else
            {
                _db.Ciphers.Add(cipher);
            }
            _db.SaveChanges();
        }

        public int GetCipherId(string str)
        {
            int? id = _db.Ciphers.Where(c => c.CipherString == str).FirstOrDefault().UserId;

            return id != null ? (int)id : -1;
        }
        public Cipher GetCipher(string str)
        {
            return _db.Ciphers.Where(c => c.CipherString == str).FirstOrDefault();
        }

        //產生一組亂數的Key字串
        public string GetRandomKey()
        {
            byte[] randomBytes = new byte[32];

            // 使用RandomNumberGenerator來填充字節數組
            using (RandomNumberGenerator rng = RandomNumberGenerator.Create())
            {
                rng.GetBytes(randomBytes);
            }

            // 將字節數組轉換為十六進制字符串
            string randomString = BitConverter.ToString(randomBytes).Replace("-", "");
            return randomString;
        }

        //解密 => 多載:1
        //回傳文字(Id)
        public string Decrypt(string str, int id)
        {
            string key = _db.Members.Where(m => m.Id == id).FirstOrDefault().Phone;
            string original = key != null ? _jwt.Decrypt(str, key) : "";
            return original;
        }


        public string Decrypt(Cipher cipher)
        {
            string key = _db.Members.Where(m => m.Id == cipher.UserId).FirstOrDefault().Phone;
            string original = key != null ? _jwt.Decrypt(cipher.CipherString, key) : "";
            return original;
        }


        //將資料進行加密
        //給值 => id = 用戶的ID || key = 用戶的Key
        public string EncryptWithJWT(int id, string key)
        {
            //呼叫JwtService的Method進行加密
            //將傳回來的密文字串回傳出去
            return _jwt.EncryptWithJWT(id, key);
        }
    }
}
