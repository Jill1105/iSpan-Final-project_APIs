using HotelFuen31.APIs.Dtos.RenYu;
using HotelFuen31.APIs.Models;
using HotelFuen31.APIs.Services.RenYu;
using Microsoft.AspNetCore.SignalR;
using Newtonsoft.Json;

namespace HotelFuen31.APIs.Hubs
{
    public class MessageHub : Hub<IMessageHub>
    {
        public static Dictionary<string, string> userInfoDict = new Dictionary<string, string>();
        
        private readonly NotificationService _service;

        public MessageHub(NotificationService service)
        {
            _service = service;
        }

        public async Task sendToAllConnection(IEnumerable<NotificationDto> dto)
        {

            await Clients.All.sendToAllConnection(dto);
        }

        public async Task LoadUserInfo(dynamic message)
        {
            dynamic dynParam = JsonConvert.DeserializeObject(Convert.ToString(message));
            string userId = dynParam.userId;
            var Id = Context.ConnectionId;
            userInfoDict[userId] = Id;
            await Clients.Client(Id).StringDataTransfer("Login successfully");
        }
        
        public async Task SendToConnection(string userId, string message)
        {
            if(userInfoDict.ContainsKey(userId))
            {
                await Clients.Client(userInfoDict[userId]).StringDataTransfer(message);
            }
        }

    }
}
