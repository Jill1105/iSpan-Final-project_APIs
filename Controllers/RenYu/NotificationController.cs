using HotelFuen31.APIs.Dtos.RenYu;
using HotelFuen31.APIs.Hubs;
using HotelFuen31.APIs.Interface.Guanyu;
using HotelFuen31.APIs.Models;
using HotelFuen31.APIs.Services.RenYu;
using Microsoft.AspNetCore.Cors;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.SignalR;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using System.Text.Json;

namespace HotelFuen31.APIs.Controllers.RenYu
{
    [Route("api/[controller]")]
    [ApiController]
    public class NotificationController : ControllerBase
    {
        private readonly NotificationService _service;
        private IHubContext<NotificationHub, INotificationHub> _hub;
        private readonly IUser _user;

        public NotificationController(NotificationService service, IHubContext<NotificationHub, INotificationHub> hub, IUser user)
        {
            _service = service;
            _hub = hub;
            _user = user;
        }

        [HttpGet]
        public async Task<IEnumerable<NotificationDto>> GetNotification()
        {
            return await _service.GetNotifications().ToListAsync();
        }

        [HttpGet("GetLevels")]
        public async Task<IEnumerable<MemberLevel>> GetLevel()
        {
            return await _service.GetLevels().ToListAsync();
        }

        [HttpPost("{id}")]
        public ActionResult<IEnumerable<SendedNotificationDto>> SendNotification(int id)
        {
            try
            {
                string phone = ValidateToken();
                if(phone == "401")
                {
                    return Unauthorized();
                }

                return _service.SendedNotifications(id).ToList();
            }
            catch (Exception ex) 
            { 
               return BadRequest(ex.Message);
            }
        }

        [HttpPost("GetMemberId")]
        public IActionResult GetMemberId(string token)
        {
            
            bool isAuthorized = _user.GetMember(token) != "401";

            if(!isAuthorized)
            {
                return Unauthorized();
            };

            return Content(_user.GetMember(token));
        }

        [HttpPost]
        public string SendAllNotifiction()
        {
            var dto = _service.GetNotifications().ToList();
            _hub.Clients.All.SendNotification(dto);

            return "成功推播通知至全體";
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
                return "Msg sent succefully to usTCer!";
            }
            else
            {
                return "Msg sent failed to user!";
            }
        }

        [HttpPost("Create")]
        public async Task<string> CreateNotifiction(SendedNotificationDto dto)
        {
            return await _service.Create(dto); 
        }

        private string ValidateToken()
        {
            string? authoriztion = HttpContext.Request.Headers["Authorization"];

            if (string.IsNullOrEmpty(authoriztion))
            {
                throw new ArgumentException("Authoriztion token is missing");
            }

            string token = authoriztion.Split(" ")[1];

            if (string.IsNullOrEmpty(token))
            {
                throw new ArgumentException("Invalid Authorization token format.");
            }

            string phone = _user.GetMemberPhone(token);
            return phone;
        }
    }
}
