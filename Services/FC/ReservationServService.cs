using HotelFuen31.APIs.Dtos.FC;
using HotelFuen31.APIs.Interfaces.FC;
using HotelFuen31.APIs.Repository.FC;

namespace HotelFuen31.APIs.Services.FC
{
	public class ReservationServService
	{
		private IReservationServRepo _repo;
		public ReservationServService(IReservationServRepo repo)
		{
			_repo = repo;
		}
		public IQueryable<ReservationServiceDetailDto> Read()
		{
			return _repo.Read();
		}
	}
}
