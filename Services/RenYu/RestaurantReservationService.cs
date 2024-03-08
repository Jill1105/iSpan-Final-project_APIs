using HotelFuen31.APIs.Models;
using HotelFuen31.APIs.Models.Dtos;
using Microsoft.EntityFrameworkCore;

namespace HotelFuen31.APIs.Services.RenYu
{
    public class RestaurantReservationService
    {

        private readonly AppDbContext _context;

        public RestaurantReservationService(AppDbContext context)
        {
            _context = context;
        }

        public IQueryable<RestaurantReservationDto> Search(string? name, string? phone)
        {


            var query = _context.RestaurantReservations
                .AsNoTracking()
                .Include(rr => rr.Customer)
                .Include(rr => rr.Period)
                .AsQueryable();

            if (!string.IsNullOrEmpty(name))
            {
                query = query.Where(rr => rr.Customer.Name.Contains(name));
            }

            if (!string.IsNullOrEmpty(phone))
            {
                query = query.Where(rr => rr.Customer.Phone.Contains(phone));
            }

            var dto = query.Select(rr => new RestaurantReservationDto
                {
                    Id = rr.Id,
                    Name = rr.Customer.Name,
                    Phone = rr.Customer.Phone,
                    Email = rr.Customer.Email,
                    Date = rr.Date,
                    Counts = rr.Counts,
                    Period = rr.Period.Name,
                    UnitPrice = rr.Period.UnitPrice,
                    Seat_Id = rr.SeatId,
            });

            return dto;
        }

        public async Task<string> Create(RestaurantReservationCreateDto dto)
        {
            string successMessage = "新增成功";
            string failMessage = "新增失敗";

            bool isExitsed = _context.RestaurantReservations
                .AsNoTracking()
                .Any(rr => rr.Date == dto.Date && rr.PeriodId == dto.Period_id && rr.SeatId == dto.Seat_Id);

            if (isExitsed) 
            {
                throw new Exception(failMessage);
            }

            try
            {
                var rcModel = new RestaurantCustomer
                {
                    Name = dto.Name,
                    Phone = dto.Phone,
                    Email = dto.Email
                };
                _context.RestaurantCustomers.Add(rcModel);
                await _context.SaveChangesAsync();

                var rrModel = new RestaurantReservation
                {
                    CustomerId = rcModel.Id,
                    Date = dto.Date,
                    Counts = dto.Counts,
                    PeriodId = dto.Period_id,
                    SeatId = dto.Seat_Id
                };
                _context.RestaurantReservations.Add(rrModel);
                await _context.SaveChangesAsync();
            }
            catch(Exception ex)
            {
                return ex.Message;
            }

            return successMessage;
        }
    }
}