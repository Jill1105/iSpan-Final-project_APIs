using HotelFuen31.APIs.Models;
using HotelFuen31.APIs.Models.Dtos;
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
          // AAAAA
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
