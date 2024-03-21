namespace HotelFuen31.APIs.Dtos.Yee
{
    public class RoomStokDto
    {
        public int Id { get; set; }
        public string? Name { get; set; }
        public string? Desc { get; set; }
        public int Capacity { get; set; }
        public string? BedType { get; set; }
        public int WeekdayPrice { get; set; }
        public int WeekendPrice { get; set; }
        public int HolidayPrice { get; set; }
        public string? Picture { get; set; }
        public int? Size { get; set; }
        public string? StartDate { get; set; }
        public string? EndDate { get; set; }
        public IEnumerable<RoomDto>? Rooms { get; set; }
        public int? Stock => this.Rooms?.Count();
    }
}
