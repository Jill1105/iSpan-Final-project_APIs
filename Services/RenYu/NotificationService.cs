using HotelFuen31.APIs.Dtos.RenYu;
using HotelFuen31.APIs.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;

namespace HotelFuen31.APIs.Services.RenYu
{
    public class NotificationService
    {
        private readonly AppDbContext _context;

        public NotificationService(AppDbContext context)
        {
            _context = context;
        }

        public IQueryable<NotificationDto> GetNotifications()
        {

            var result = _context.SendedNotifications
                   .AsNoTracking()
                   .Where(x => !x.IsSended)
                   .Select(sn => new SendedNotification
                   {
                       MemberId = sn.MemberId,
                       NotificationId = sn.NotificationId,
                   });

            var dto = _context.Notifications
                .AsNoTracking()
                .Include(n => n.Level)
                .Select(notification => new NotificationDto
                {
                    Id = notification.Id,
                    Name = notification.Name,
                    Description = notification.Description,
                    PushTime = notification.PushTime,
                    Image = notification.Image,
                    LevelId = notification.Level.Id,
                    LevelName = notification.Level.Name
                });

             return dto;
        }
        public IQueryable<MemberLevel> GetLevels()
        {

            var dto = _context.MemberLevels
                .AsNoTracking()
                .Select(level => new MemberLevel
                {
                    Id = level.Id,
                    Name = level.Name,
                });

            return dto;
        }

        public async Task<string> Create(NotificationDto dto)
        {
            var model = new Notification
            {
               Id= dto.Id,
               Name = dto.Name,
               Description = dto.Description,
               PushTime = dto.PushTime,
               Image = dto.Image,
               LevelId = dto.LevelId,
            };

            _context.Notifications.Add(model);
            await _context.SaveChangesAsync();

            return "新增成功";
        }
    }
}
