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

        // POST: api/Cart/list
        [HttpPost]
        [Route("list")]
        public ActionResult<IEnumerable<CartRoomItemDto>> CartListUser([FromBody] string Phone)
        {
            //string? token = HttpContext.Request.Headers["Authorization"];

            //if(string.IsNullOrWhiteSpace(token)) return Unauthorized();

            // todo: 驗證 token 有沒有效

            try
            {
                var cartList = _cartRoomService.CartListUser(Phone).ToList();

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
    }
}
