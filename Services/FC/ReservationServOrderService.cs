using HotelFuen31.APIs.Dtos.FC;
using HotelFuen31.APIs.Interfaces.FC;
using HotelFuen31.APIs.Models;

namespace HotelFuen31.APIs.Services.FC
{
	public class ReservationServOrderService
	{
		private IReservationServOrderRepo _repo;
		private ReservationServRoomService _roomService;
		public ReservationServOrderService(IReservationServOrderRepo repo, ReservationServRoomService roomService)
		{
			_repo = repo;
			_roomService = roomService;
		}

		public IEnumerable<ReservationServiceOrderDto> Read()
		{
			return _repo.Read();
		}

		public int Create(ReservationVueDto dto)
		{
			var checkmodel = _roomService.ReadBytypeId(1).ToList();
			int maxRoomAmount = checkmodel.Count() - 1; //排除預設包廂

			var checkedRoomCount = dto.AppointmentDate == null && dto.AppointmentTimePeriodId == 0
				? _repo.ReadByDateTime(DateTime.Now, 1) //待確定
				: _repo.ReadByDateTime(dto.AppointmentDate, dto.AppointmentTimePeriodId);
			int totalCount = checkedRoomCount.Count();


			var model = new ReservationOrderDto
			{
				ClientId = dto.ClientId,
				ReservationStatusId = 1,
				CreateTime = DateTime.Now,
				ClientName = dto.ClientName,
				PhoneNumber = dto.PhoneNumber,
			};
			int newId = _repo.CreateOrder(model);

			if (newId > 0)
			{
				var model2 = new ReservationServiceOrderDto
				{
					ReservationId = newId,
					ServiceDetailId = dto.ServiceDetailId,
					AppointmentDate = dto.AppointmentDate,
					AppointmentTimePeriodId = dto.AppointmentTimePeriodId,
					TotalDuration = dto.TotalDuration,
					RoomId = 1, //預設值:待安排
					RoomStatusId = 1, //預設值:待安排
					Subtotal = dto.Subtotal
				};
				return _repo.CreateOrderItem(model2);

			}

			return 0;


		}
	}
}
