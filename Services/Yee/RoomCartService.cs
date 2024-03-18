using HotelFuen31.APIs.Controllers.Yee;
using HotelFuen31.APIs.Dtos.Yee;
using HotelFuen31.APIs.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Internal;

namespace HotelFuen31.APIs.Services.Yee
{
    public class RoomCartService
    {
        private readonly AppDbContext _context;
        public RoomCartService(AppDbContext context)
        {
            _context = context;
        }

        public RoomStockInfo GetRoomStock(string start, string end)
        {
            DateTime startDate;
            DateTime endDate;

            if(!DateTime.TryParse(start, out startDate) || !DateTime.TryParse(end, out endDate)) {
                throw new Exception("日期格式異常");
            }

            // 日期錯置
            if(startDate > endDate)
            {
                DateTime temp = startDate;
                startDate = endDate;
                endDate = temp;
            }

            // 查詢日期內剩餘房間
            var lsit = _context.RoomTypes
                               .AsNoTracking()
                               .Include(rt => rt.Rooms)
                               //.ThenInclude(r => r.RoomBookings)
                               .Select(rt => new RoomStokDto
                               {
                                   Id = rt.RoomTypeId,
                                   Name = rt.TypeName,
                                   Desc = rt.Description,
                                   Capacity = rt.Capacity,
                                   BedType = rt.BedType,
                                   WeekdayPrice = rt.WeekdayPrice,
                                   WeekendPrice = rt.WeekendPrice,
                                   HolidayPrice = rt.HolidayPrice,
                                   Picture = rt.ImageUrl,
                                   Size = rt.Size,
                                   Rooms = rt.Rooms
                                               .Where(r => !r.RoomBookings.Any(rb => (startDate < rb.CheckOutDate && endDate > rb.CheckInDate)))
                                               .Select(r => new RoomDto
                                               {
                                                   RoomId = r.RoomId,
                                                   TypeId = r.RoomTypeId,
                                               }).ToList(),
                               }).ToList();

            // 封裝資炫
            var info = new RoomStockInfo
            {
                RequestTime = DateTime.Now,
                StartDate = startDate.ToString("yyyy-MM-dd"),
                EndDate = endDate.ToString("yyyy-MM-dd"),
                RoomStocks = lsit
            };

            return info;
        }
    }
}
