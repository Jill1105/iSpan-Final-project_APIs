namespace HotelFuen31.APIs.Hubs
{
    public interface IMessageHub
    {
        Task sendToAllConnection(List<string> message);
        
        Task JsonDataTransfer(dynamic message);

        Task StringDataTransfer(string message);
    }
}
