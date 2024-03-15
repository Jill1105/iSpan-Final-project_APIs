using HotelFuen31.APIs.Dtos.RenYu;

namespace HotelFuen31.APIs.Hubs
{
    public interface INotificationHub
    {
        Task SendToAllConnection(IEnumerable<NotificationDto> dto);
        
        Task JsonDataTransfer(dynamic message);

        Task StringDataTransfer(string message);
    }
}
