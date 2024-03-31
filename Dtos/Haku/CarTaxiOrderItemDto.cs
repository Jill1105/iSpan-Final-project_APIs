using HotelFuen31.APIs.Models;

namespace HotelFuen31.APIs.Dtos.Haku
{
	public class CarTaxiOrderItemDto
	{
		public int Id { get; set; }

		public int CarId { get; set; }

		public string PickUpLongtitude { get; set; }

		public string PickUpLatitude { get; set; }

		public string DestinationLatitude { get; set; }

		public string DestinationLongtitude { get; set; }

		public decimal SubTotal { get; set; }

		public string StartTime { get; set; }

		public string? ActualStartTime { get; set; }

		public string EndTime { get; set; }

		public string? ActualEndTime { get; set; }

		public int EmpId { get; set; }

		public int MemberId { get; set; }
	}
}
