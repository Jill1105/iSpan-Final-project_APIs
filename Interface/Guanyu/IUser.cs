using HotelFuen31.APIs.Dtos;
using HotelFuen31.APIs.Models;

namespace HotelFuen31.APIs.Interface.Guanyu
{
    public interface IUser
    {
        int GetMemberId(string phone, string pwd);

        Member GetMemberData(int id);

        Member GetMemberData(string phone, string pwd);

        string GetMemberKey(int id);

        List<TokenData> tokenDatas(TokenData data);
    }
}
