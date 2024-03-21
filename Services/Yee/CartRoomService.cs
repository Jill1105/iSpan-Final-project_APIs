using HotelFuen31.APIs.Controllers.Yee;
using HotelFuen31.APIs.Dtos.Yee;
using HotelFuen31.APIs.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Internal;
using System.Text.RegularExpressions;

namespace HotelFuen31.APIs.Services.Yee
{
    public class CartRoomService
    {
        private readonly AppDbContext _db;
        public CartRoomService(AppDbContext db)
        {
            _db = db;
        }

        public RoomStockInfo GetRoomStock(string checkInDate, string checkOutDate)
        {
            DateTime startDate;
            DateTime endDate;

            if(!DateTime.TryParse(checkInDate, out startDate) || !DateTime.TryParse(checkOutDate, out endDate)) {
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
            var lsit = _db.RoomTypes
                               .AsNoTracking()
                               .Include(rt => rt.Rooms)
                               //.ThenInclude(r => r.RoomBookings)
                               .ToList()
                               .Select(rt => new RoomStokDto
                               {
                                   Id = rt.RoomTypeId,
                                   Name = rt.TypeName,
                                   Desc = rt.Description,
                                   Capacity = rt.Capacity,
                                   BedType = rt.BedType,
                                   Price = GetPrice(startDate, endDate, rt.RoomTypeId),
                                   WeekdayPrice = rt.WeekdayPrice,
                                   WeekendPrice = rt.WeekendPrice,
                                   HolidayPrice = rt.HolidayPrice,
                                   Picture = rt.ImageUrl,
                                   Size = rt.Size,
                                   CheckInDate = startDate.ToString("yyyy-MM-dd"),
                                   CheckOutDate = endDate.ToString("yyyy-MM-dd"),
                                   Rooms = rt.Rooms
                                               .Where(r => !r.RoomBookings.Any(rb => (startDate < rb.CheckOutDate && endDate > rb.CheckInDate)))
                                               .Select(r => new RoomDto
                                               {
                                                   UId = $"{startDate.ToString("yyyy-MM-dd")},{endDate.ToString("yyyy-MM-dd")},{r.RoomId},{r.RoomTypeId}",
                                                   RoomId = r.RoomId,
                                                   TypeId = r.RoomTypeId,
                                               }).ToList(),
                               }).ToList();

            // 封裝資炫
            var info = new RoomStockInfo
            {
                RequestTime = DateTime.Now,
                CheckInDate = startDate.ToString("yyyy-MM-dd"),
                CheckOutDate = endDate.ToString("yyyy-MM-dd"),
                RoomStocks = lsit
            };

            return info;
        }

        public IEnumerable<CartRoomItemDto> CartListUser(string phone)
        {
            string pattern = @"^\d{9,}$"; // 這會匹配長度大於等於 10 的數字

            // 使用正規表達式來驗證 phone
            if (!Regex.IsMatch(phone, pattern)) return Enumerable.Empty<CartRoomItemDto>();

            var dtos = _db.CartRoomItems
                .Include(cri => cri.Type)
                .Where(cri => cri.Phone == phone)
                .ToList()
                .Select(cri => new CartRoomItemDto
                {
                    Id = cri.Id,
                    Uid = cri.Uid,
                    Selected = cri.Selected,
                    TypeId = cri.TypeId,
                    Name = cri.Type.TypeName,
                    Picture = cri.Type.ImageUrl,
                    CheckInDate = cri.CheckInDate.ToString("yy-MM-dd"),
                    CheckOutDate = cri.CheckOutDate.ToString("yy-MM-dd"),
                    Info = $"入住時間: {cri.CheckInDate}, 退房時間: {cri.CheckOutDate}, 備註: {cri.Remark}",
                    Price = GetPrice(cri.CheckInDate, cri.CheckOutDate, cri.TypeId),
                    Count = 1,
                    Phone = phone,
                }).ToList();

            return dtos;
        }

        public int GetPrice(string start, string end, int roomTypeId)
        {
            DateTime startDate;
            DateTime endDate;
            if (!DateTime.TryParse(start, out startDate) || !DateTime.TryParse(end, out endDate))
            {
                throw new Exception("字串轉日期異常");
            }

            // 日期錯置
            if (startDate > endDate)
            {
                DateTime temp = startDate;
                startDate = endDate;
                endDate = temp;
            }

            // 取得房型
            var roomeType = _db.RoomTypes.Find(roomTypeId);
            if (roomeType == null) throw new Exception("並沒有該房型");


            var query = _db.RoomCalendars
                .AsNoTracking()
                .Where(rc => startDate <= rc.Date && rc.Date < endDate)
                .AsEnumerable();

            var price = query
                .Select(rc => rc.IsHoliday == "true" ?
                    roomeType.HolidayPrice : rc.Week == "五" || rc.Week == "六" || rc.Week == "日" ?
                    roomeType.WeekendPrice : roomeType.WeekdayPrice)
                .Aggregate((total, next) => total + next);

            return price;
        }

        public int GetPrice(DateTime startDate, DateTime endDate, int roomTypeId)
        {
            // 日期錯置
            if (startDate > endDate)
            {
                DateTime temp = startDate;
                startDate = endDate;
                endDate = temp;
            }

            var roomeType = _db.RoomTypes.Find(roomTypeId);
            if (roomeType == null) throw new Exception("並沒有該房型");

            var query = _db.RoomCalendars
                .AsNoTracking()
                .Where(rc => startDate <= rc.Date && rc.Date < endDate)
                .AsEnumerable();

            var price = query
                .Select(rc => rc.IsHoliday == "true" ?
                    roomeType.HolidayPrice : rc.Week == "五" || rc.Week == "六" || rc.Week == "日" ?
                    roomeType.WeekendPrice : roomeType.WeekdayPrice)
                .Aggregate((total, next) => total + next);

            return price;
        }
    }
}
