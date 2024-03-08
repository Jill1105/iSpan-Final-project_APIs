namespace HotelFuen31.APIs.Models.Dtos
{
    public class RestaurantReservationCreateDto
    {
        public required string Name { get; set; }

        public required string Phone { get; set; }

        public string? Email { get; set; }

        public DateTime Date { get; set; }

        public int Counts { get; set; }

        public int Period_id { get; set; }

        public int Seat_Id { get; set; }
    }
}
