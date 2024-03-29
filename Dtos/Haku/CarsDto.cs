using HotelFuen31.APIs.Models;

namespace HotelFuen31.APIs.Dtos.Haku
{
	public class CarsDto
	{
		public int Id { get; set; }

		public int Capacity { get; set; }

		public int PlusPrice { get; set; }

		public string Comment { get; set; }

		public IEnumerable<CarTaxiOrderItemDto> CarTaxiOrderItem { get; set;}

		public CarTaxiOrderItemDto ASC { get; set; }
		public CarTaxiOrderItemDto DESC { get; set; }

	}
}
