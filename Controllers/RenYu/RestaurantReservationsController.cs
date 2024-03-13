using HotelFuen31.APIs.Dtos.RenYu;
using HotelFuen31.APIs.Models;
using HotelFuen31.APIs.Services.RenYu;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using NuGet.Packaging.Signing;

namespace HotelFuen31.APIs.Controllers.RenYu
{

    [Route("api/[controller]")]
    [ApiController]
    public class RestaurantReservationsController : ControllerBase
    {

        private readonly RestaurantReservationService _service;

        public RestaurantReservationsController(RestaurantReservationService service)
        {
            _service = service;
        }

        // api/RestaurantReservation
        [HttpGet]
        public async Task<IEnumerable<RestaurantReservationDto>> GetRestaurantReservations(string? name, string? phone)
        {
            return await _service.Search(name, phone).ToListAsync();
        }

        //api/RestaurantReservation
        [HttpPost]
        public async Task<string> PostRestaurantReservations(RestaurantReservationCreateDto dto)
        {
            return await _service.Create(dto);
        }
    }
}
