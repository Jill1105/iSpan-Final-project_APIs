using HotelFuen31.APIs.Dtos.Haku;
using HotelFuen31.APIs.Dtos.Yee;
using HotelFuen31.APIs.Interface.Guanyu;
using HotelFuen31.APIs.Models;
using HotelFuen31.APIs.Services;
using HotelFuen31.APIs.Services.Guanyu;
using HotelFuen31.APIs.Services.Yee;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace HotelFuen31.APIs.Controllers.Haku
{
	[Route("api/[controller]")]
	[ApiController]
	public class DispatchController : ControllerBase
	{
		private readonly AppDbContext _context;
		private readonly IUser _userService;
		private readonly DispatchService _dispatchService;

		public DispatchController(AppDbContext context, IUser userService, DispatchService service)
		{
			_context = context;
			_userService = userService;
			_dispatchService = service;
		}

		// 取得最新的搭車訂單細項列表
		// GET: api/Dispatch/list
		[HttpGet]
		[Route("list")]
		public ActionResult<IEnumerable<CarTaxiOrderItemDto>> GetOrderListUser()
		{
			try
			{
				string phone = ValidateToken();
				if (phone == "401") return Unauthorized();

				var orderList = _dispatchService.OrderListUser(phone).ToList();

				return orderList;
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
