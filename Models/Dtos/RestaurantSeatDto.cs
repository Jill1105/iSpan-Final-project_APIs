namespace HotelFuen31.APIs.Models.Dtos
{
    public class RestaurantSeatDto
    {
        public int Id { get; set; }

        public required string Type { get; set; }

        public int Capacity { get; set; }
    }
}
