using HotelFuen31.APIs.Dtos.Yee;
using HotelFuen31.APIs.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace HotelFuen31.APIs.Controllers.Yee
{
    [Route("api/[controller]")]
    [ApiController]
    public class YeeController : ControllerBase
    {
        private readonly AppDbContext _db;
        public YeeController(AppDbContext db)
        {
            _db = db;
        }

        // GET: api/Yee/
        [HttpGet]
        public ActionResult<Object> Get(string checkInDate, string checkOutDate)
        {
            DateTime startDate;
            DateTime endDate;

            if (!DateTime.TryParse(checkInDate, out startDate) || !DateTime.TryParse(checkOutDate, out endDate))
            {
                throw new Exception("日期格式異常");
            }

            // 日期錯置
            if (startDate > endDate)
            {
                DateTime temp = startDate;
                startDate = endDate;
                endDate = temp;
            }


            //DateTime startDate = new DateTime(2024, 3, 24);
            //DateTime endDate = new DateTime(2024, 3, 25);

            var list = _db.RoomTypes
                .Where(rt => rt.RoomTypeId == 2)
                .Select(rt => new RoomStokDto
                {
                    Id = rt.RoomTypeId,
                    Name = rt.TypeName,
                    Desc = rt.Description,
                    Capacity = rt.Capacity,
                    BedType = rt.BedType,
                    Price = 87,
                    WeekdayPrice = rt.WeekdayPrice,
                    WeekendPrice = rt.WeekendPrice,
                    HolidayPrice = rt.HolidayPrice,
                    Picture = rt.ImageUrl,
                    Size = rt.Size,
                    CheckInDate = startDate.ToString("yyyy-MM-dd"),
                    CheckOutDate = endDate.ToString("yyyy-MM-dd"),
                    Info = $"入住時間: {startDate.ToString("yyyy-MM-dd")}, 退房時間: {endDate.ToString("yyyy-MM-dd")}, 備註: 共計 {(endDate - startDate).Days} 日",
                    Rooms = rt.Rooms
                    .Where(r => !r.RoomBookings.Any(rb => (startDate < rb.CheckOutDate && endDate > rb.CheckInDate)))
                        .Select(r => new RoomDto
                        {
                            UId = $"{startDate.ToString("yyyy-MM-dd")},{endDate.ToString("yyyy-MM-dd")},{r.RoomId},{r.RoomTypeId}",
                            RoomId = r.RoomId,
                            TypeId = r.RoomTypeId,
                        }).ToList(),
                }).ToList();



                //.Where(r => r.RoomTypeId == 2)
                //.Where(r => !r.RoomBookings.Any(rb => (startDate < rb.CheckOutDate && endDate > rb.CheckInDate)))
                //.ToList();

            return list;
        }
    }
}
