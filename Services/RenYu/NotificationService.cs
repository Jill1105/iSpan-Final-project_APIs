using HotelFuen31.APIs.Dtos.RenYu;
using HotelFuen31.APIs.Models;
using Microsoft.EntityFrameworkCore;

namespace HotelFuen31.APIs.Services.RenYu
{
    public class NotificationService
    {
        private readonly AppDbContext _context;

        public NotificationService(AppDbContext context)
        {
            _context = context;
        }

        public  IQueryable<NotificationDto> GetNotification()
        {
            var dto = _context.Notifications
                .AsNoTracking()
                .Select(notification => new NotificationDto
                {
                    Id = notification.Id,
                    Name = notification.Name,
                    Description = notification.Description,
                    PushTime = notification.PushTime,
                    Image = notification.Image,
                    LevelId = notification.LevelId,
                });

             return dto;
        }
    }
}
