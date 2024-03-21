using HotelFuen31.APIs.Controllers.Yee;
using HotelFuen31.APIs.Dtos.Yee;
using HotelFuen31.APIs.Models;
using Humanizer;
using Microsoft.AspNetCore.DataProtection.Repositories;
using Microsoft.EntityFrameworkCore;
using System;

namespace HotelFuen31.APIs.Services.Yee
{
    public class CartRoomItemService
    {
        private readonly AppDbContext _db;
        public CartRoomItemService(AppDbContext db)
        {
            _db = db;
        }

        //public IEnumerable<CartRoomItem> CartListUser(string phone)
        //{
        //    if(string.IsNullOrEmpty(phone)) return Enumerable.Empty<CartRoomItem>();

            //    var vms = _db.CartRoomItems
            //        .AsNoTracking()
            //        .Include(cri => cri.Room)
            //        .ThenInclude(r => r.RoomType)
            //        .Where(cri => cri.Phone == phone)
            //        .Select(cri => new 
            //        {
            //            uid = uid,
            //              selected = true,
            //              typeid = id,
            //              name = name,
            //              picture = picture,
            //              startDate = startDate,
            //              endDate = endDate,
            //              info = $"入住時間: { startDate}, 退房時間: { endDate}",
            //              price = weekdayPrice,
            //              count = 1,
            //              weekdayPrice = weekdayPrice,
            //              weekendPrice = weekendPrice,
            //              holidayPrice = holidayPrice,
            //        })



            //        .Join(
            //            _context.RoomTypes,
            //            cri => cri.Room.RoomTypeId,
            //            rt => rt.RoomTypeId,
            //            (cri, rt) => new CartItemVm
            //            {
            //                Id = cri.Id,
            //                Picture = rt.ImageUrl,
            //                Name = rt.TypeName,
            //                Price = rt.WeekdayPrice,
            //                Count = 1,
            //                Selected = false,
            //                Phone = cri.Phone,
            //                Info = $"入住時間: {cri.CheckInDate.ToString("yyyy-MM-dd")},退房時間: {cri.CheckOutDate.ToString("yyyy-MM-dd")}",
            //            })
            //        .Where(vm => vm.Phone == dto.Phone)
            //        .ToList();

            //    vms.ForEach(vm =>
            //    {
            //        var pic = string.IsNullOrEmpty(vm.Picture) ? "noImage.png" : vm.Picture;
            //        vm.Picture = $"{HttpContext.Request.Scheme}://{HttpContext.Request.Host}{Url.Content($"~/StaticFiles/Chen/{pic}")}";
            //    });


            //    return vms;
        //}
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


            var price = _db.RoomCalendars
                .AsNoTracking()
                .Where(rc => startDate >= rc.Date &&
                           rc.Date < endDate)
                .Select(rc => rc.IsHoliday == "true" ?
                    roomeType.HolidayPrice : rc.Week == "日" || rc.Week == "六" ?
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

            var price = _db.RoomCalendars
                .AsNoTracking()
                .Where(rc => startDate >= rc.Date &&
                           rc.Date < endDate)
                .Select(rc => rc.IsHoliday == "true" ?
                    roomeType.HolidayPrice : rc.Week == "日" || rc.Week == "六" ?
                    roomeType.WeekendPrice : roomeType.WeekdayPrice)
                .Aggregate((total, next) => total + next);

            return price;
        }
    }
}
