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

namespace HotelFuen31.APIs.Controllers.Guanyu
{
    [Route("api/[controller]")]
    [ApiController]
    public class MembersController : ControllerBase
    {
        private readonly AppDbContext _context;
        private readonly JwtService _jwt;
        private readonly IUser _iuser;

        public MembersController(AppDbContext context,IUser iuser)
        {
            _context = context;
            _iuser = iuser;
            _jwt = new JwtService(context);
        }

        //GET: api/Members/{str}
        [HttpGet("{str}")]
        public async Task<string> GetMember(string str)
        {
            int id = 0;
            //foreach (var item in _iuser.tokenDatas)
            //{
            //    if (item.cipher == str)
            //    {
            //        id = item.num;
            //    }
            //}
            return _jwt.Decrypt(str, id);
        }

        [HttpGet("Test")]
        public async Task<string> Test([FromQuery] string phone, [FromQuery] string pwd)
        {
            var memberid = _iuser.GetMemberId(phone, pwd);
            var memberkey = _iuser.GetMemberKey(memberid);
            var membername = _iuser.GetMemberData(phone, pwd).Name;

            return $"{memberid} , {memberkey} , {membername}";
        }

        // GET: api/Members/Login?
        [HttpGet("Login")]
        public async Task<string> GetMember([FromQuery] string phone, [FromQuery] string pwd)
        {
            var memberid = _iuser.GetMemberId(phone, pwd);
            var memberkey = _iuser.GetMemberKey(memberid);

            var EncryptedString = _jwt.EncryptWithJWT(memberid, memberkey);

            var data = new TokenData
            {
                num = memberid,
                cipher = EncryptedString
            };
            //_iuser.tokenDatas(data);

            if (EncryptedString != null) return EncryptedString;
            else return $"{memberid}";

        }

    }
}
