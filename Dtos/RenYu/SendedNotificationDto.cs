using HotelFuen31.APIs.Models;

namespace HotelFuen31.APIs.Dtos.RenYu
{
    public class SendedNotificationDto
    {
        public int MemberId {  get; set; }

        public int NotificationId { get; set; }
        
        public bool IsSended { get; set; }

        public required string NotificationTitle { get; set; }

        public DateTime PushTime { get; set; }

        public string? Image { get; set; }

        public int? LevelId { get; set; }
    }
}
