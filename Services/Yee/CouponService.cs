using HotelFuen31.APIs.Dtos.Yee;
using HotelFuen31.APIs.Interfaces.Yee;
using HotelFuen31.APIs.Models;
using Microsoft.EntityFrameworkCore;
using System.Runtime.CompilerServices;

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

        public IEnumerable<IRuleBase> GetUserCoupons(string phone)
        {
            var member = _db.Members
                .AsNoTracking()
                .Include(m => m.CouponMembers)
                    .ThenInclude(cm => cm.Coupon)
                .FirstOrDefault(m => m.Phone == phone);

            if(member == null) throw new Exception("優惠券錯誤: 查無會員");


            var coupons = member.CouponMembers.Select(cm => cm.Coupon);

            if (!coupons.Any()) yield break;

            foreach (var c in coupons)
            {
                switch (c.TypeId)
                {
                    case 1:
                        var couponTD = _db.CouponThresholdDiscounts.FirstOrDefault(crts => crts.CouponId == c.Id);
                        if (couponTD != null)
                        {
                            yield return new TotalPriceDiscountRule(couponTD.CouponId, couponTD.Threshold, couponTD.Discount);
                        }
                        break;

                    case 2:
                        var couponRTS = _db.CouponRoomTimeSpans.FirstOrDefault(crts => crts.CouponId == c.Id);
                        if (couponRTS != null)
                        {
                            yield return new RoomTypeSpanDiscountRule(couponRTS.CouponId, couponRTS.RoomTypeId, couponRTS.StartTime, couponRTS.EndTime, couponRTS.PercentOff, _db);
                        }
                        break;

                    case 3:
                        var couponRCSD = _db.CouponRoomCountSameDates.FirstOrDefault(crts => crts.CouponId == c.Id);
                        if (couponRCSD != null)
                        {
                            yield return new RoomTypeCountDiscountRule(couponRCSD.CouponId, couponRCSD.RoomTypeId, couponRCSD.Count, couponRCSD.PercentOff, _db);
                        }
                        break;

                    default:
                        break;
                }
            }
        }
    }
}
