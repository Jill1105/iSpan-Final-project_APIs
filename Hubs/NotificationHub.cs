using HotelFuen31.APIs.Dtos.RenYu;
using HotelFuen31.APIs.Models;
using HotelFuen31.APIs.Services.RenYu;
using Microsoft.AspNetCore.SignalR;
using Newtonsoft.Json;

namespace HotelFuen31.APIs.Hubs
{
    public class NotificationHub : Hub<INotificationHub>
    {
        public async Task SendNotification(IEnumerable<NotificationDto> dto)
        {

            await Clients.All.SendNotification(dto);
        }
    }
}
