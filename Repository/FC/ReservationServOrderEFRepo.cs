using HotelFuen31.APIs.Dtos.FC;
using HotelFuen31.APIs.Interfaces.FC;
using HotelFuen31.APIs.Models;
using Microsoft.EntityFrameworkCore;

namespace HotelFuen31.APIs.Repository.FC
{
	public class ReservationServOrderEFRepo : IReservationServOrderRepo
	{
		private AppDbContext _db;
		public ReservationServOrderEFRepo(AppDbContext db)
		{
			_db = db;
		}

		public IEnumerable<ReservationServiceOrderDto> Read()
		{
			var model = _db.ReservationItems
				.AsNoTracking()
				.Include(x => x.ServiceDetail)
				.Include(x => x.AppointmentTimePeriod)
				.Include(x => x.Room)
				.Include(x => x.RoomStatus)
				.Select(x => new ReservationServiceOrderDto
				{
					Id = x.Id,
					ReservationId = x.ReservationId,
					ServiceDetailId = x.ServiceDetailId,
					ServiceDetailName = x.ServiceDetail.ServiceDetailName,
					AppointmentDate = x.AppointmentDate,
					AppointmentTimePeriodId = x.AppointmentTimePeriodId,
					AppointmentTimePeriodName = x.AppointmentTimePeriod.TimePeriod,
					TotalDuration = x.TotalDuration,
					RoomId = x.RoomId,
					RoomName = x.Room.RoomName,
					RoomStatusId = x.RoomStatusId,
					RoomStatusName = x.RoomStatus.RoomStatusName,
					Subtotal = x.Subtotal

				});
			return model;
		}
	}
}
