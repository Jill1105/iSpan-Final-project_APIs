using HotelFuen31.APIs.Dtos.Yee;
using System.Text.RegularExpressions;
using HotelFuen31.APIs.Models;
using Microsoft.EntityFrameworkCore;
using HotelFuen31.APIs.Dtos.Haku;

namespace HotelFuen31.APIs.Services
{
	public class DispatchService
	{
		private readonly AppDbContext _db;
		public DispatchService(AppDbContext db)
		{
			_db = db;
		}

		//找到那個會員的訂單細項資料
		public IEnumerable<CarTaxiOrderItemDto> OrderListUser(string phone)
		{
			string pattern = @"^\d{9,}$"; // 這會匹配長度大於等於 10 的數字

			// 使用正規表達式來驗證 phone
			if (!Regex.IsMatch(phone, pattern)) return Enumerable.Empty<CarTaxiOrderItemDto>();

			int memId = _db.Members
				.Where(m => m.Phone == phone)
				.Select(m => m.Id)
				.FirstOrDefault();

			var dtos = _db.CarTaxiOrderItems
				.Include(ctoi => ctoi.Member)
				.Where(ctoi => ctoi.MemberId == memId)
				.Select(ctoi => new CarTaxiOrderItemDto
				{
					Id = ctoi.Id,
					CarId = ctoi.CarId,
					PickUpLongtitude = ctoi.PickUpLongtitude,
					PickUpLatitude = ctoi.PickUpLatitude,
					DestinationLatitude = ctoi.DestinationLatitude,
					DestinationLongtitude = ctoi.DestinationLongtitude,
					SubTotal = ctoi.SubTotal,
					StartTime = ctoi.StartTime,
					ActualStartTime = ctoi.ActualStartTime,
					EndTime = ctoi.EndTime,
					ActualEndTime = ctoi.ActualEndTime,
					EmpId = ctoi.EmpId,
					MemberId = ctoi.MemberId,
				}).ToList();

			return dtos;
		}
	}
}
