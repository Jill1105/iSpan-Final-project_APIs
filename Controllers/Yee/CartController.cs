using HotelFuen31.APIs.Dtos.Yee;
using HotelFuen31.APIs.Interface.Guanyu;
using HotelFuen31.APIs.Services.Yee;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Drawing;
using System.Linq;

namespace HotelFuen31.APIs.Controllers.Yee
{
    [Route("api/[controller]")]
    [ApiController]
    public class CartController : ControllerBase
    {
        private readonly CartRoomService _cartRoomService;

        private readonly IUser _userService;

        public CartController(CartRoomService service, IUser userService)
        {
            _cartRoomService = service;
            _userService = userService;
        }

        // GET: api/Cart/list
        [HttpGet]
        [Route("list")]
        public ActionResult<IEnumerable<CartRoomItemDto>> GetCartListUser()
        {
            //// 取得 request 置於 Header 中的 token
            //string? authorization = HttpContext.Request.Headers["Authorization"];
            //if (string.IsNullOrWhiteSpace(authorization)) return BadRequest();

            //// 將字串中的 token 拆出來
            //string token = authorization.Split(" ")[1];
            //if (string.IsNullOrWhiteSpace(token)) return BadRequest();

            //// 驗證 token 有沒有效
            //string phone = _userService.GetMemberPhone(token);

            try
            {
                string phone = ValidateToken();
                var cartList = _cartRoomService.CartListUser(phone).ToList();

                cartList.ForEach(item =>
                {
                    var pic = string.IsNullOrEmpty(item.Picture) ? "noImage.png" : item.Picture;
                    item.Picture = $"{HttpContext.Request.Scheme}://{HttpContext.Request.Host}{Url.Content($"~/StaticFiles/Chen/{pic}")}";
                });

                return cartList;
            }
            catch (Exception ex) {
                return BadRequest(ex.Message);
            }
        }

        // GET: api/cart/roomStock?start=2024-01-01?end=2024-01-03
        [HttpGet]
        [Route("roomStock")]
        public ActionResult<RoomStockInfo>? GetRoomStock([FromQuery] string checkInDate, string checkOutDate)
        {
            try
            {
                var info = _cartRoomService.GetRoomStock(checkInDate, checkOutDate);
                if (info == null) return null;

                info.RoomStocks?.ToList().ForEach(ele =>
                {
                    var pic = string.IsNullOrEmpty(ele.Picture) ? "noImage.png" : ele.Picture;
                    ele.Picture = $"{HttpContext.Request.Scheme}://{HttpContext.Request.Host}{Url.Content($"~/StaticFiles/Chen/{pic}")}";
                });

                return info;

            }
            catch (Exception ex)
            {
                return Content(ex.Message);
            }
        }

        // POST: api/cart/merge
        [HttpPost]
        [Route("merge")]
        public ActionResult PostMergeCart([FromBody] IEnumerable<CartRoomItemDto> dtos)
        {
            try
            {
                string phone = ValidateToken();
                _cartRoomService.MergeCart(phone, dtos);
                return Ok();
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
