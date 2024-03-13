using HotelFuen31.APIs.Dtos;
using HotelFuen31.APIs.Interface.Guanyu;
using HotelFuen31.APIs.Models;
using System.Collections.Generic;

namespace HotelFuen31.APIs.Services.Guanyu
{
    public class UsersService : IUser
    {
        private AppDbContext _db;
        private List<TokenData> tokens;
        

        public UsersService(AppDbContext db)
        {
            _db = db;
            List<TokenData> tokens = new List<TokenData>();
        }

        public List<TokenData> tokenDatas(TokenData data)
        {
            tokens.Add(data);
            return tokens;
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
            return _db.Members.Where(m => m.Id == id).FirstOrDefault().Key;
        }
    }
}
