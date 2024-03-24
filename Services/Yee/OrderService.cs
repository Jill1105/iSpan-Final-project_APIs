using HotelFuen31.APIs.Dtos.Yee;
using HotelFuen31.APIs.Models;
using Microsoft.AspNetCore.Routing.Matching;
using Microsoft.EntityFrameworkCore;
using System.ComponentModel.DataAnnotations;
using System.Transactions;
using static NuGet.Packaging.PackagingConstants;

namespace HotelFuen31.APIs.Services.Yee
{
    public class OrderService
    {
        private readonly AppDbContext _db;
        private readonly CartRoomService _crService;

        public OrderService(AppDbContext db, CartRoomService crService)
        {
            _db = db;
            _crService = crService;
        }

        public int CreateOrder(string phone)
        {
            var selectedItem = _db.CartRoomItems.Where(cri => cri.Phone == phone && cri.Selected);
            if (!selectedItem.Any()) throw new Exception("訂單項目為空");


            using (var scope = new TransactionScope())
            {
                // 建立訂單
                var order = new Order
                {
                    Phone = phone,
                    Status = 0,
                    OrderTime = DateTime.Now,
                };
                _db.Orders.Add(order);
                _db.SaveChanges();

                // 逐一寫入
                selectedItem.ToList().ForEach(item =>
                {
                    // 確認有無空房
                    var room = _db.Rooms
                                   .Include(r => r.RoomBookings)
                                   .Where(r => r.RoomTypeId == item.TypeId)
                                   .FirstOrDefault(r => !r.RoomBookings.Any(rb => (item.CheckInDate < rb.CheckOutDate && item.CheckOutDate > rb.CheckInDate)));

                    if (room == null) throw new Exception("已無空房");

                    // 新建訂單項目
                    var newBooking = new RoomBooking
                    {
                        RoomId = room.RoomId,
                        OrderId = order.Id,
                        CheckInDate = item.CheckInDate,
                        CheckOutDate = item.CheckOutDate,
                        MemberId = _db.Members.FirstOrDefault(m => m.Phone == phone)?.Id ?? null,
                        Remark = item.Remark,
                        BookingStatusId = 2,
                        BookingDate = order.OrderTime,
                        OrderPirce = _crService.GetPrice(item.CheckInDate, item.CheckOutDate, item.TypeId),
                        Phone = phone,
                    };

                    _db.RoomBookings.Add(newBooking);
                    _db.SaveChanges();
                });

                // 購物車排除已提交訂單
                _db.CartRoomItems.RemoveRange(selectedItem);
                _db.SaveChanges();

                // 提交事务
                scope.Complete();

                return order.Id;
            }
            
        }
    }
}
