using HotelFuen31.APIs.Dtos.RenYu;
using HotelFuen31.APIs.Hubs;
using HotelFuen31.APIs.Services.RenYu;
using Microsoft.AspNetCore.Cors;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.SignalR;
using Microsoft.EntityFrameworkCore;

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

        [HttpGet]
        public async Task<IEnumerable<NotificationDto>> GetNotifications()
        {
            return await _service.GetNotifications().ToListAsync();
        }

        [HttpPost]
        public string SendNotifiction()
        {
            var dto = _service.GetNotifications().ToList();
            _hub.Clients.All.SendNotification(dto);

            return "成功推播通知至全體";
        }
    }
}
