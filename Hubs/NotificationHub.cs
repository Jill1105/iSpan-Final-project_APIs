using HotelFuen31.APIs.Dtos.RenYu;
using HotelFuen31.APIs.Models;
using HotelFuen31.APIs.Services.RenYu;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.SignalR;
using Newtonsoft.Json;

namespace HotelFuen31.APIs.Hubs
{
    public class NotificationHub : Hub<INotificationHub>
    {
        public static Dictionary<string,string> userInfoDict = new Dictionary<string,string>();

        public async Task SendNotification(IEnumerable<SendedNotificationDto> dto)
        {
            await Clients.All.SendNotification(dto);
        }

        public async Task sendToAllConnections(List<string> message)
        {
            await Clients.All.sendToAllConnections(message);
        }

        public async Task LoadUserInfo(dynamic message)
        {
            dynamic dynParam = JsonConvert.DeserializeObject(Convert.ToString(message));
            string userId = dynParam.userId;
            var Id = Context.ConnectionId;
            userInfoDict[userId] = Id;
            await Clients.Clients(Id).StringDataTransfer("Login Successfully");
        }
         
        public async Task SendToConnection(string inputUserId, string message)
        {
            if(userInfoDict.ContainsKey(inputUserId))
            {
                await Clients.Client(userInfoDict[inputUserId]).StringDataTransfer(message);
            }
        }

        public override Task OnConnectedAsync()
        {
            string connectionId = Context.ConnectionId;
            return base.OnConnectedAsync(); 
        }

        public override Task OnDisconnectedAsync(Exception? exception)
        {
            string Id = Context.ConnectionId;
            string userId = string.Empty;
            if(userInfoDict.ContainsValue(Id))
            {
                string key = userInfoDict.FirstOrDefault(x => x.Value == Id).Key;   

                userInfoDict.Remove(userId);
            }

            return base.OnDisconnectedAsync(exception);
        }
    }
}
