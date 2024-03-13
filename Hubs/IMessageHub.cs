namespace HotelFuen31.APIs.Hubs
{
    public interface IMessageHub
    {
        Task sendToAllConnection(List<string> message);
    }
}
