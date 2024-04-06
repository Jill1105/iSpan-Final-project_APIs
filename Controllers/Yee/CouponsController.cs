using HotelFuen31.APIs.Interface.Guanyu;
using HotelFuen31.APIs.Services.Guanyu;
using HotelFuen31.APIs.Services.Yee;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace HotelFuen31.APIs.Controllers.Yee
{
    [Route("api/[controller]")]
    [ApiController]
    public class CouponsController : ControllerBase
    {
        private CouponService _couponService;
        private readonly IUser _userService;

        public CouponsController(CouponService couponService, IUser userService)
        {
            _couponService = couponService;
            _userService = userService;
        }

        // GET: api/Coupons/user
        [HttpGet]
        [Route("user")]
        public ActionResult<Object> GetUserCoupons()
        {
            try
            {
                string phone = ValidateToken();
                if (phone == "401") return Unauthorized();

                var coupons = _couponService.GetUserCoupons(phone);

                return new
                {
                    Success = true,
                    result = coupons,
                };
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        private string ValidateToken()
        {
            // 取得 request 置於 Header 中的 token
            string? authorization = HttpContext.Request.Headers["Authorization"];
            if (string.IsNullOrWhiteSpace(authorization))
            {
                return "401";
            }

            // 將字串中的 token 拆出來
            string token = authorization.Split(" ")[1];
            if (string.IsNullOrWhiteSpace(token))
            {
                return "401";
            }

            // 驗證 token 有沒有效
            string phone = _userService.GetMemberPhone(token);
            return phone;
        }
    }
}
