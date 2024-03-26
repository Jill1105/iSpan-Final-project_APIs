using HotelFuen31.APIs.Interface.Guanyu;
using HotelFuen31.APIs.Services.Yee;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace HotelFuen31.APIs.Controllers.Yee
{
    [Route("api/[controller]")]
    [ApiController]
    public class OrderController : ControllerBase
    {
        private readonly OrderService _orderService;
        private readonly IUser _userService;

        public OrderController(OrderService orderService, IUser userService)
        {
            _orderService = orderService;
            _userService = userService;
        }

        // GET: api/Order/create
        [HttpPost]
        [Route("create")]
        public ActionResult PostCreateOrderLogged()
        {
            try
            {
                string phone = ValidateToken();
                if (phone == "401") return Unauthorized();

                _orderService.CreateOrder(phone);

                return Ok("訂單建立成功");
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
                throw new ArgumentException("Authorization token is missing.");
            }

            // 將字串中的 token 拆出來
            string token = authorization.Split(" ")[1];
            if (string.IsNullOrWhiteSpace(token))
            {
                throw new ArgumentException("Invalid Authorization token format.");
            }

            // 驗證 token 有沒有效
            string phone = _userService.GetMemberPhone(token);
            return phone;
        }
    }
}
