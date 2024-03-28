using HotelFuen31.APIs.Dtos.FC;
using HotelFuen31.APIs.Services.FC;
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
		public ReservationServiceController(ReservationServTimePeriodService roomService)
		{
			_roomService = roomService;
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
	}
}
