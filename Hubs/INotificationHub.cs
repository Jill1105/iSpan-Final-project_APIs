﻿using HotelFuen31.APIs.Dtos.RenYu;

namespace HotelFuen31.APIs.Hubs
{
    public interface INotificationHub
    {
        Task SendNotification(IEnumerable<NotificationDto> dto);
    }
}
