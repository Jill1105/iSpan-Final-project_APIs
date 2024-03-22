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
        public IActionResult GetMember(string str)
        {
            if(_iuser.GetMember(str) == "401") return Unauthorized();
            return Content(_iuser.GetMember(str));
        }

        // GET: api/Members/Login?
        [HttpGet("Login")]
        public string MemberLogin([FromQuery] string phone, [FromQuery] string pwd)
        {
            return _iuser.GetCryptostring(phone, pwd);
        }

        //GET: api/Members?
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Member>>> GetMembers([FromQuery] int id)
        {
            return await _db.Members.Where(m => m.Id == id).ToListAsync();
        }

        [HttpGet("pwd")]
        public string GetEncryptPwd([FromQuery] string pwd, [FromQuery] string key)
        {
            return _iuser.CryptoHash(pwd, key);
        }

        [HttpPost]
        public string NewMember(Member member)
        {
            string status = _iuser.NewMember(member);
            return status;
        }
        [HttpGet("check")]
        public string Check([FromQuery] string str)
        {
            return _iuser.GetMemberPhone(str);
        }
    }
}
