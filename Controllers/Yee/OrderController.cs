using HotelFuen31.APIs.Interface.Guanyu;
using HotelFuen31.APIs.Services.Yee;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

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

        // POST: api/Order/create
        [HttpPost]
        [Route("create")]
        public ActionResult<Object> PostCreateOrderLogged()
        {
            try
            {
                string phone = ValidateToken();
                if (phone == "401") return Unauthorized();

                int newOrderId = _orderService.CreateOrder(phone);

                return new
                {
                   Success = true,
                   OrderId = newOrderId,
                };
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        // GET: api/Order/
        [HttpGet]
        public ActionResult<Object> GetOrder([FromQuery] int orderId)
        {
            try
            {
                string phone = ValidateToken();
                if (phone == "401") return Unauthorized();

                var order = _orderService.GetOrder(phone, orderId);

                return new
                {
                    Success = true,
                    result = order,
                };
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        // GET: api/Order/ECPay
        [HttpGet]
        [Route("ECPay")]
        public ActionResult<Object> GetECPayForm([FromQuery] int orderId)
        {
            try
            {
                string phone = ValidateToken();
                if (phone == "401") return Unauthorized();

                var orderDto = _orderService.GetOrder(phone, orderId);

                if (orderDto.RtnCode == 1 || orderDto.Status == 1) return BadRequest("該訂單已付款");

                string backEnd = $"{HttpContext.Request.Scheme}://{HttpContext.Request.Host}";
                //string backEnd = $"https://111.184.154.28:7245";
                string frontEnd = $"localhost:5173";

                var orderDic = _orderService.GetECPayDic(orderDto, backEnd, frontEnd);

                return orderDic;
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        // POST: api/Order/ECPay
        [HttpPost]
        [Route("ECPay")]
        public Task<ActionResult> PostFromECPay([FromForm]IFormCollection col)
        {
            var data = new Dictionary<string, string>();
            foreach (string key in col.Keys)
            {
                data.Add(key, col[key]);
            }
            //var Orders = _context.EcpayOrders.ToList().Where(m => m.MerchantTradeNo == col["MerchantTradeNo"]).FirstOrDefault();
            //Orders.RtnCode = int.Parse(col["RtnCode"]);
            //if (col["RtnMsg"] == "Succeeded")
            //{
            //    Orders.RtnMsg = "已付款";
            //    Orders.PaymentDate = Convert.ToDateTime(col["PaymentDate"]);
            //    Orders.SimulatePaid = int.Parse(col["SimulatePaid"]);
            //    await _context.SaveChangesAsync();
            //}

            //return View("ECpayView", data);
            return null;
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
