using HotelFuen31.APIs.Dto.Jill;
using HotelFuen31.APIs.Dtos.Jill;
using HotelFuen31.APIs.Models;
using Microsoft.EntityFrameworkCore;

namespace HotelFuen31.APIs.Services.Jill
{
    public class HallMenuService
    {

        private readonly AppDbContext _context;
        public HallMenuService(AppDbContext context)
        {
            _context = context;
        }

        public IQueryable<HallMenuDto> GetrAll()
        {
            var dto = _context.HallMenus
                .AsNoTracking()
                .Select(h => new HallMenuDto
                {
                    Id = h.Id,
                    DishName = h.DishName,
                    Description = h.Description,
                    Price = h.Price,
                    CategoryId = h.CategoryId,
                    CategoryName = h.Category.Category,
                    Keywords = h.Keywords,
                });

            return dto;
        }

        public IQueryable<HallCategoryDto> Getrcategory()
        {
            var dto = _context.HallDishCategories
                .AsNoTracking()
                .Select(h => new HallCategoryDto
                {
                    Id = h.Id,
                    Category = h.Category,
                });

            return dto;
        }

        public IQueryable<HallMenuDto> GetCategoryMenu(int id)
        {
            var query = _context.HallMenus
                .AsNoTracking()
                .Where(h => h.CategoryId == id)
                .Select(h => new HallMenuDto
                {
                    Id = h.Id,
                    DishName = h.DishName,
                    Description = h.Description,
                    Price = h.Price,
                    CategoryId = h.CategoryId,
                    CategoryName = h.Category.Category,
                    Keywords = h.Keywords,
                });

            return query;
        }

    }
}
