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

        public IEnumerable<NotificationDto> GetNotifications()
        {
            var dto = _context.Notifications
                .AsNoTracking()
                .Include(n => n.Level)
                .OrderByDescending(n => n.Id)
                .Take(3)
                .Select(notification => new NotificationDto
                {
                    Id = notification.Id,
                    Name = notification.Name,
                    Description = notification.Description,
                    PushTime = notification.PushTime,
                    Image = notification.Image,
                    LevelId = notification.Level.Id,
                    LevelName = notification.Level.Name
                })
                .ToList();  

             return dto;
        }

        public IQueryable<SendedNotificationDto> SendedNotifications(int id)
        {
            var dto = _context.SendedNotifications
                .Where(sn => id == sn.MemberId)
                .Include(sn => sn.Notification)
                .Take(5)
                .Select(sn => new SendedNotificationDto
                {
                    MemberId = sn.MemberId,
                    NotificationId = sn.NotificationId,
                    NotificationTitle = sn.Notification.Name,
                    NotificationDescription = sn.Notification.Description,
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

        public IQueryable<NotificationType> GetTypes() 
        {
            var dto = _context.NotificationTypes
                .AsNoTracking()
                .Select(type => new NotificationType
                {
                    Id = type.Id,
                    Name = type.Name,
                });

            return dto;
        }

        public IQueryable<BirthdayDto> SendBirthdayNotification()
        {
            int birthdayNotifi = 2;

            var dto = _context.SendedNotifications
                .AsNoTracking()
                .Include(x => x.Member)
                .Include(x => x.Notification)
                .Where(x => x.Notification.TypeId == birthdayNotifi)
                .Select(x => new BirthdayDto
                {
                    Id = x.Id,
                    Name = x.Notification.Name,
                    Description = x.Notification.Description,
                });
               

            return dto;
        }

        public async Task<string> Create(SendedNotificationDto dto)
        {
            var notiModel = new Notification
            {
               Name = dto.NotificationTitle,
               Description = dto.NotificationDescription,
               PushTime = dto.PushTime,
               Image = dto.Image,
               LevelId = dto.LevelId,
               TypeId = dto.TypeId,
            };

            _context.Notifications.Add(notiModel);
            await _context.SaveChangesAsync();

            int count = _context.Members.Count();
            var memberId = _context.Members.Select(x => x.Id).ToList();

            if (dto.LevelId != null)
            {
                count = _context.Members
                      .Where(x => x.LevelId == dto.LevelId)
                      .Count();

                memberId = _context.Members
                    .Where(x => x.LevelId == dto.LevelId)
                    .Select(x => x.Id)
                    .ToList();
            }

            for (int i = 0; i < count; i++)
            {
                var snModel = new SendedNotification
                {
                    NotificationId = notiModel.Id,
                    MemberId = memberId[i],
                    IsSended = false
                };

                _context.SendedNotifications.Add(snModel);
            }

            await _context.SaveChangesAsync();

            return "新增成功";
        }
    }
}
