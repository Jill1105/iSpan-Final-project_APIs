using HotelFuen31.APIs.Dtos.RenYu;

namespace HotelFuen31.APIs.Hubs
{
    public interface IMessageHub
    {
        Task sendToAllConnection(IEnumerable<NotificationDto> dto);
        
        Task JsonDataTransfer(dynamic message);

        Task StringDataTransfer(string message);
    }
}
