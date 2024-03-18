namespace HotelFuen31.APIs.Dtos.Yee
{
    public class RoomStockInfo
    {
        public DateTime RequestTime { get; set; }
        public string StartDate { get; set; }
        public string EndDate { get; set; }
        public IEnumerable<RoomStokDto> RoomStocks { get; set; }
    }
}
