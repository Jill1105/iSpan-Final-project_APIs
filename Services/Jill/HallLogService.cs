using HotelFuen31.APIs.Dtos.Jill;
using HotelFuen31.APIs.Models;
using Humanizer;
using Microsoft.EntityFrameworkCore;

namespace HotelFuen31.APIs.Services.Jill
{
    public class HallLogService
    {
        private readonly AppDbContext _context;
        public HallLogService(AppDbContext context)
        { 
            _context = context; 
        }

        public IQueryable<HallLogDto> GetAll() {

            var dto = _context.HallLogs
                .AsNoTracking()
                .Select(h => new HallLogDto
                {
                    Id = h.Id,
                    HallId = h.HallId,
                    UserId = h.UserId,
                    Guests = h.Guests,
                    StartTime = h.StartTime,
                    EndTime = h.EndTime,
                    BookingStatus = h.BookingStatus,
                    Name = h.Name,
                    CellPhone = h.CellPhone,
                    Email = h.Email,
                    FilePath = h.FilePath,
                    HallName = h.Hall.HallName,
                });

            return dto;
        }

        public IQueryable<HallLogDto> SearchLog(int id) 
        {
            var query = _context.HallLogs
                .AsNoTracking()
                .Where(h => h.Hall.Id == id)
                .Select(h => new HallLogDto
                {
                    Id = h.Id,
                    HallId = h.HallId,
                    UserId = h.UserId,
                    Guests = h.Guests,
                    StartTime = h.StartTime,
                    EndTime = h.EndTime,
                    BookingStatus = h.BookingStatus,
                    Name = h.Name,
                    CellPhone = h.CellPhone,
                    Email = h.Email,
                    FilePath = h.FilePath,
                    HallName = h.Hall.HallName,
                });

            return query;
        }
    }
}
