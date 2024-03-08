using HotelFuen31.APIs.Models.Dtos;
using HotelFuen31.APIs.Services.RenYu;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace HotelFuen31.APIs.Controllers.RenYu
{
    [Route("api/[controller]")]
    [ApiController]
    public class RestaurantPeriodsController : ControllerBase
    {
        private readonly RestaurantPeriodService _service;

        public RestaurantPeriodsController(RestaurantPeriodService service)
        {
            _service = service;
        }

        [HttpGet]
        public async Task<IEnumerable<RestaurantPeriodDto>> GetRestaurantPriods()
        {
            return await _service.GetrAll().ToListAsync();
        }
    }
}
