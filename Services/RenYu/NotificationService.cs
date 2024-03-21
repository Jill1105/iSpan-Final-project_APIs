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
                   .Include(x => x.Notification)
                   .Include(x => x.Member)
                   .Take(5)
                   .Select(sn => new SendedNotificationDto
                   {
                       MemberId = sn.MemberId,
                       NotificationId = sn.NotificationId,
                       NotificationTitle = sn.Notification.Name,

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

        public IQueryable<SendedNotificationDto> SendedNotifications(int id)
        {
            var dto = _context.SendedNotifications
                .Where(sn => id == sn.MemberId)
                .Include(sn => sn.Notification)
                .Select(sn => new SendedNotificationDto
                {
                    MemberId = sn.MemberId,
                    NotificationId = sn.NotificationId,
                    NotificationTitle = sn.Notification.Name,
                    PushTime = sn.Notification.PushTime,
                    Image = sn.Notification.Image,
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
