namespace HotelFuen31.APIs.Dtos.Yee
{
    public class RoomStockInfo
    {
        public DateTime RequestTime { get; set; }
        public string? CheckinDate { get; set; }
        public string? CheckOutDate { get; set; }
        public IEnumerable<RoomStokDto>? RoomStocks { get; set; }
    }
}
