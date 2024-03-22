using HotelFuen31.APIs.Dtos.RenYu;
using HotelFuen31.APIs.Models;
using Microsoft.EntityFrameworkCore;

namespace HotelFuen31.APIs.Services.RenYu
{
    public class RestaurantSeatService
    {
        private readonly AppDbContext _context;

        public RestaurantSeatService(AppDbContext context)
        {
            _context = context;
        }

        public IQueryable<RestaurantSeatDto> GetAll()
        {
            var dto = _context.RestaurantSeats
                .AsNoTracking()
                .Select(rs => new RestaurantSeatDto
                {
                    Id = rs.Id,
                    Type = rs.Type,
                    Capacity = rs.Capacity,
                });

            return dto;
        }
    }
}
