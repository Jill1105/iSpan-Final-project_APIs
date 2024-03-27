using HotelFuen31.APIs.Dtos.RenYu;

namespace HotelFuen31.APIs.Hubs
{
    public interface INotificationHub
    {
       
        Task SendNotification(IEnumerable<SendedNotificationDto> dto);

        Task sendToAllConnections(List<string> message);

        Task JsonDataTransfer(dynamic message);
        
        Task StringDataTransfer(string message);
    }
}
