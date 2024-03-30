using HotelFuen31.APIs.Dtos.FC;
using HotelFuen31.APIs.Services.FC;
using HotelFuen31.APIs.Services.Yee;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace HotelFuen31.APIs.Controllers.FC
{
	[Route("api/[controller]")]
	[ApiController]
	public class ReservationServiceController : ControllerBase
	{
		private readonly ReservationServTimePeriodService _roomService;
		private readonly ReservationServOrderService _orderService;
		public ReservationServiceController(ReservationServTimePeriodService roomService, ReservationServOrderService orderService)
		{
			_roomService = roomService;
			_orderService = orderService;
		}

		[HttpGet]
		public  IEnumerable<ReservationServiceTimePeriodDto> CheckRoomCount(int typeId, DateTime? selectdate)
		{
			if (selectdate == null) selectdate = DateTime.Today;
			var dtos = _roomService.ReadTime(typeId, selectdate);


			var model = dtos.Select(x => new ReservationServiceTimePeriodDto
			{
				Id = x.Id,
				TimePeriod = x.TimePeriod,
				Count = x.Count
			});

			return model;
		}

		[HttpPost]
		public ActionResult<Object> CreateOrderAll([FromForm] ReservationVueDto dto)
		{
			int newId = _orderService.Create(dto);
			if (newId > 0)
			{
				return Ok();
			}
			else
			{
				return BadRequest();
			}

		}
	}
}
