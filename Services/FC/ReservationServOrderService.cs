using HotelFuen31.APIs.Dtos.FC;
using HotelFuen31.APIs.Interfaces.FC;

namespace HotelFuen31.APIs.Services.FC
{
	public class ReservationServOrderService
	{
		private IReservationServOrderRepo _repo;
		public ReservationServOrderService(IReservationServOrderRepo repo)
		{
			_repo = repo;
		}

		public IEnumerable<ReservationServiceOrderDto> Read()
		{
			return _repo.Read();
		}
	}
}
