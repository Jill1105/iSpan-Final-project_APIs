using Microsoft.AspNetCore.SignalR;
using Newtonsoft.Json;

namespace HotelFuen31.APIs.Hubs
{
    public class MessageHub : Hub<IMessageHub>
    {
        public static Dictionary<string, string> userInfoDict = new Dictionary<string, string>();

        public async Task sendToAllConnection(List<string> message)
        {
            await Clients.All.sendToAllConnection(message);
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
