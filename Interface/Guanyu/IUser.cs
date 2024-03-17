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

        void NewCipher(Cipher cipher);

        int GetCipherId(string str);

        public Cipher GetCipher(string str);

        public string Decrypt(Cipher cipher);


        string Decrypt(string str, int id);

        string EncryptWithJWT(int id, string key);

        string GetRandomKey();
    }
}
