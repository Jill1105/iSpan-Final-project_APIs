using Microsoft.AspNetCore.SignalR;

namespace HotelFuen31.APIs.Hubs
{
    public class MessageHub : Hub<IMessageHub>
    {
        public async Task sendToAllConnection(List<string> message)
        {
            await Clients.All.sendToAllConnection(message);
        }
    }
}
