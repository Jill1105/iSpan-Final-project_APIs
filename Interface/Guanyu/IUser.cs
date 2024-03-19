using HotelFuen31.APIs.Dtos;
using HotelFuen31.APIs.Models;

namespace HotelFuen31.APIs.Interface.Guanyu
{
    public interface IUser
    {
        string GetMember(string str);

        int NewMember(Member member);

        string CryptoHash(string pwd, string key);

        string GetCryptostring(string phone, string pwd);

    }
}
