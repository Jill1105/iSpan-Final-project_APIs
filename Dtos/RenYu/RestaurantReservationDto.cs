using System.ComponentModel.DataAnnotations;

namespace HotelFuen31.APIs.Dtos.RenYu
{
    public class RestaurantReservationDto
    {
        public int? Id { get; set; }

        public required string Name { get; set; }

        public required string Phone { get; set; }

        public string? Email { get; set; }

        public DateTime Date { get; set; }

        public int Counts { get; set; }

        public int Period_id { get; set; }

        public int? Status_Id { get; set; }

        public string? Period { get; set; }

        public int? UnitPrice { get; set; }

        public int Seat_Id { get; set; }
    }
}
