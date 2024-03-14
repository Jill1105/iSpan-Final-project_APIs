using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using HotelFuen31.APIs.Models;
using HotelFuen31.APIs.Interface.Guanyu;
using Microsoft.IdentityModel.JsonWebTokens;
using HotelFuen31.APIs.Services.Guanyu;
using HotelFuen31.APIs.Dtos;
using System.Security.Cryptography;

namespace HotelFuen31.APIs.Controllers.Guanyu
{
    [Route("api/[controller]")]
    [ApiController]
    public class MembersController : ControllerBase
    {
        private AppDbContext _db;
        private readonly IUser _iuser;

        public MembersController(AppDbContext db, IUser iuser)
        {
            _db = db;
            _iuser = iuser;
        }

        //GET: api/Members/密文
        [HttpGet("{str}")]
        public async Task<string> GetMember(string str)
        {
            int CipherId = _iuser.GetCipherId(str);

            Cipher cipher = _iuser.GetCipher(str);

            //return _iuser.Decrypt(str, CipherId);
            return _iuser.Decrypt(cipher);
        }

        [HttpGet("setkey")]
        public async Task<string> SetKey()
        {
            // 創建一個32字節的字節數組
            return _iuser.GetRandomKey();
        }

        // GET: api/Members/Login?
        [HttpGet("Login")]
        public async Task<string> GetMember([FromQuery] string phone, [FromQuery] string pwd)
        {
            var memberid = _iuser.GetMemberId(phone, pwd);
            var memberkey = _iuser.GetMemberKey(memberid);

            var EncryptedString = _iuser.EncryptWithJWT(memberid, memberkey);

            Cipher cipher = new Cipher();
            cipher.UserId = memberid;
            cipher.CipherString = EncryptedString;
            _iuser.NewCipher(cipher);

            if (EncryptedString != null) return EncryptedString;
            else return "登入失敗";
        }

        //GET: api/Members?
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Member>>> GetMembers([FromQuery] int id)
        {
            return await _db.Members.Where(m => m.Id == id).ToListAsync();
        }
    }
}
