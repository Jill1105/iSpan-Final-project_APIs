using HotelFuen31.APIs.Dtos.Chen;
using HotelFuen31.APIs.Models;

namespace HotelFuen31.APIs.Services
{
    public class RoomTypeService
    {
        private readonly AppDbContext _context;

        public RoomTypeService(AppDbContext context)
        {
            _context = context;
        }

        public IQueryable<RoomTypeDtos> GetAllRoomTypes(int id)
        {

            var query = _context.RoomTypes
                .Where(x => (x.RoomTypeId == id || id==0))
                .Select(rr => new RoomTypeDtos
                {
                    RoomTypeId = rr.RoomTypeId,
                    TypeName = rr.TypeName,
                    Description = rr.Description,
                    Capacity = rr.Capacity,
                    BedType = rr.BedType,
                    RoomCount = rr.RoomCount,
                    ImageUrl = rr.ImageUrl,
                    WeekdayPrice = rr.WeekdayPrice,
                    Size = rr.Size

                });
            return query;
        }
        public IQueryable<RoomDetailDtos> GetRoomDetail(int id)
        {
            var query = _context.RoomDaysPrices
                .Select(rr => new RoomDetailDtos
                {
                    RoomTypeId = rr.RoomTypeId,
                    Date = rr.Date,
                    Description = rr.Description,
                    IsHoliday = rr.IsHoliday,
                    Price = rr.Price
                });
            return query;
        }
    }
}
