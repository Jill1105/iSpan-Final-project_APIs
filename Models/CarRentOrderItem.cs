﻿// <auto-generated> This file has been auto generated by EF Core Power Tools. </auto-generated>
#nullable disable
using System;
using System.Collections.Generic;

namespace HotelFuen31.APIs.Models;

public partial class CarRentOrderItem
{
    public int Id { get; set; }

    public int CarId { get; set; }

    public decimal SubTotal { get; set; }

    public DateTime StartTime { get; set; }

    public DateTime EndTime { get; set; }

    public int EmpId { get; set; }

    public int MemberId { get; set; }

    public int OrderId { get; set; }

    public virtual CarManagement Car { get; set; }

    public virtual Employee Emp { get; set; }

    public virtual Member Member { get; set; }
}