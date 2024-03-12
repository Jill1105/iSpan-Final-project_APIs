using HotelFuen31.APIs.Dtos.RenYu;
using HotelFuen31.APIs.Services.RenYu;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace HotelFuen31.APIs.Controllers.RenYu
{
    [Route("api/[controller]")]
    [ApiController]
    public class NotificationController : ControllerBase
    {
        private readonly NotificationService _service;

        public NotificationController(NotificationService service)
        {
            _service = service;
        }

        public async Task<IEnumerable<NotificationDto>> GetNotifications()
        {
            return await _service.GetNotification().ToListAsync();
        }
    }
}
