using HotelFuen31.APIs.Dtos.RenYu;
using HotelFuen31.APIs.Models;
using HotelFuen31.APIs.Services.RenYu;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace HotelFuen31.APIs.Controllers.RenYu
{
    [Route("api/[controller]")]
    [ApiController]
    public class RestaurantSeatsController : ControllerBase
    {
        private readonly RestaurantSeatService _service;

        public RestaurantSeatsController(RestaurantSeatService service)
        {
            _service = service;
        }

        [HttpGet]
        public async Task<IEnumerable<RestaurantSeatDto>> GetRestaurantSeats()
        {
            return await _service.GetAll().ToListAsync();
        }
    }
}
