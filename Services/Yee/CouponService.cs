using HotelFuen31.APIs.Interfaces.Yee;
using HotelFuen31.APIs.Models;

namespace HotelFuen31.APIs.Services.Yee
{
    public class CouponService
    {
        private AppDbContext _db;

        public CouponService(AppDbContext db)
        {
            _db = db;
        }

        public int Create(ICoupon coupon)
        {
            throw new NotImplementedException();
        }
    }
}
