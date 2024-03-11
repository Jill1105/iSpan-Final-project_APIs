using HotelFuen31.APIs.Dtos.RenYu;
using HotelFuen31.APIs.Models;
using Microsoft.EntityFrameworkCore;

namespace HotelFuen31.APIs.Services.RenYu
{
    public class RestaurantPeriodService
    {
        private readonly AppDbContext _context;

        public RestaurantPeriodService(AppDbContext context)
        {
            _context = context;
        }

        public IQueryable<RestaurantPeriodDto> GetrAll()
        {
            var dto = _context.RestaurantPeriods
                .AsNoTracking()
                .Select(rp => new RestaurantPeriodDto
                {
                    Id = rp.Id,
                    Name = rp.Name,
                    UnitPrice = rp.UnitPrice,
                });

            return dto;
        }
    }
}
