using HotelFuen31.APIs.Models;

namespace HotelFuen31.APIs.Dtos.Haku
{
	public class CarTaxiOrderItemDto
	{
		public int Id { get; set; }

		public int CarId { get; set; }

		public int PickUpLongtitude { get; set; }

		public int PickUpLatitude { get; set; }

		public int DestinationLatitude { get; set; }

		public int DestinationLongtitude { get; set; }

		public decimal SubTotal { get; set; }

		public DateTime StartTime { get; set; }

		public DateTime? ActualStartTime { get; set; }

		public DateTime EndTime { get; set; }

		public DateTime? ActualEndTime { get; set; }

		public int EmpId { get; set; }

		public int MemberId { get; set; }
	}
}
