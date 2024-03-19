using HotelFuen31.APIs.Dtos.RenYu;
using HotelFuen31.APIs.Hubs;
using HotelFuen31.APIs.Services.RenYu;
using Microsoft.AspNetCore.Cors;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.SignalR;
using Microsoft.EntityFrameworkCore;
using System.Text.Json;

namespace HotelFuen31.APIs.Controllers.RenYu
{
    [Route("api/[controller]")]
    [ApiController]
    public class NotificationController : ControllerBase
    {
        private readonly NotificationService _service;
        private IHubContext<NotificationHub, INotificationHub> _hub;

        public NotificationController(NotificationService service, IHubContext<NotificationHub, INotificationHub> hub)
        {
            _service = service;
            _hub = hub;
        }

        [HttpPost]
        public string SendNotifiction()
        {
            var dto = _service.GetNotifications().ToList();
            _hub.Clients.All.SendNotification(dto);

            return "成功推播通知至全體";
        }

        [HttpPost]
        [Route("toAll")]
        public string ToAll()
        {
            List<string> msgs = new List<string>();
            msgs.Add("Don't forget, the deadline for submitting your expense reports is this Friday.");
            msgs.Add("Friendly reminder, please refrain from using the conference room for personal calls or meetings without prior approval.");
            _hub.Clients.All.sendToAllConnections(msgs);
            return "Msg sent successfully to all users!";
        }

        [HttpPost]
        [Route("toUser")]
        public string toUser([FromBody] JsonElement jobJ)
        {
            var userId = jobJ.GetProperty("userId").GetString();
            var msg = jobJ.GetProperty("msg").GetString();
            if(NotificationHub.userInfoDict.ContainsKey(userId))
            {
                _hub.Clients.Client(NotificationHub.userInfoDict[userId]).StringDataTransfer(msg);
                return "Msg sent succefully to user!";
            }
            else
            {
                return "Msg sent failed to user!";
            }
        }

        [HttpPost("Create")]
        public async Task<string> CreateNotifiction(NotificationDto dto)
        {
            return await _service.Create(dto); 
        }
    }
}
