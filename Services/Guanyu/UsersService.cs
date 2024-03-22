using HotelFuen31.APIs.Dtos;
using HotelFuen31.APIs.Interface.Guanyu;
using HotelFuen31.APIs.Models;
using HotelFuen31.APIs.Library;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Security.Cryptography;
using System.Text;

namespace HotelFuen31.APIs.Services.Guanyu
{
    public class UsersService : IUser
    {
        private AppDbContext _db;
        private readonly JwtService _jwt;
        private readonly CryptoPwd _pwd;
        
        public UsersService(AppDbContext db, JwtService jwt, CryptoPwd pwd)
        {
            _db = db;
            _jwt = jwt;
            _pwd = pwd;
        }

        public string GetMember(string str)
        {
            int CipherId = GetCipherId(str);

            Cipher cipher = GetCipher(str);

            //return _iuser.Decrypt(str, CipherId);
            return Decrypt(cipher);
        }

        public string GetMemberPhone(string str)
        {
            if (string.IsNullOrEmpty(str)) throw new Exception("請重新登入");

            int? id = _db.Ciphers.Where(c => c.CipherString == str).FirstOrDefault().UserId;

            if (id == null) throw new Exception("請重新登入");

            string phone = _db.Members.Find(id).Phone;

            return phone;
        }

        //登入後，回傳Token密文
        public string GetCryptostring(string phone,string pwd)
        {
            try
            {
                var memberid = _db.Members.Where(m => m.Phone.Contains(phone) && m.Password.Contains(pwd))
                                    .FirstOrDefault().Id;

                var memberkey = _pwd.NewKey();
                var EncryptedString = EncryptWithJWT(memberid, memberkey);

                Cipher cipher = new Cipher();
                cipher.UserId = memberid;
                cipher.CipherString = EncryptedString;
                cipher.CipherKey = memberkey;
                NewCipher(cipher);

                return EncryptedString;
            }
            catch
            {
                return "登入失敗";
            }
        }

        //新增資料庫內Cipher Table的資料
        //若有相同使用者時，進行更新
        public void NewCipher(Cipher cipher)
        {
            var check = _db.Ciphers.Where(c => c.UserId == cipher.UserId).FirstOrDefault();

            if (check != null)
            {
                check.CipherString = cipher.CipherString;
                check.CipherKey = cipher.CipherKey;
            }
            else
            {
                _db.Ciphers.Add(cipher);
            }
            _db.SaveChanges();
        }

        //依照給予的密文取得在Cipher Property中的ID
        public int GetCipherId(string str)
        {
            int? id = _db.Ciphers.Where(c => c.CipherString == str).FirstOrDefault().UserId;

            return id != null ? (int)id : -1;
        }

        //依照給予的密文取得在Cipher Property中的值
        public Cipher GetCipher(string str)
        {
            return _db.Ciphers.Where(c => c.CipherString == str).FirstOrDefault();
        }

        public string CryptoHash(string pwd,string salt)
        {
            return _pwd.CryptoPWD(pwd, salt);
        }

        //解密 => 多載:1
        //需給密文 & UserID
        public string Decrypt(string str, int id)
        {
            string key = _db.Ciphers.Where(m => m.UserId == id).FirstOrDefault().CipherKey;
            string original = key != null ? _jwt.Decrypt(str, key) : "";
            return original;
        }

        //解密 => 多載:2
        //只需給Cipher的
        public string Decrypt(Cipher cipher)
        {
            return _jwt.Decrypt(cipher.CipherString, cipher.CipherKey);
        }

        //將資料進行加密
        //給值 => id = 用戶的ID || key = 用戶的Key
        public string EncryptWithJWT(int id, string key)
        {
            //呼叫JwtService的Method進行加密
            //將傳回來的密文字串回傳出去
            return _jwt.EncryptWithJWT(id, key);
        }

        public string NewMember(Member member)
        {
            member.IsConfirmed = false;
            member.ConfirmCode = _pwd.NewConfirmCode();
            member.RegistrationDate = DateTime.Now;
            member.Ban = false;
            member.LevelId = 13;

            //產生一組新的Salt字串，並儲存到Member的Salt欄位中
            member.Salt = _pwd.NewSalt();
            
            //給一組密碼&鹽進行雜湊加密，並更新密碼
            member.Password = CryptoHash(member.Password, member.Salt);

            //新增該項目到資料庫中

            try
            {
                _db.Members.Add(member);
                _db.SaveChanges();
                return $"新增成功";
            }
            catch
            {
                return "新增失敗";
            }
        }

        public string TestCheck()
        {
            return _pwd.NewConfirmCode();
        }
    }
}
