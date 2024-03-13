using HotelFuen31.APIs.Models;
using HotelFuen31.APIs.Services.Jill;
using HotelFuen31.APIs.Services.RenYu;
using Microsoft.EntityFrameworkCore;

namespace HotelFuen31.APIs
{
    public class Program
    {
        public static void Main(string[] args)
        {
            var builder = WebApplication.CreateBuilder(args);

            // Add services to the container.
            builder.Services.AddDbContext<AppDbContext>(options =>
            {
                options.UseSqlServer(builder.Configuration.GetConnectionString("AppDbContext"));
            });


            builder.Services.AddScoped<SendEmailService>();

            builder.Services.AddScoped<HallItemService>();
            builder.Services.AddScoped<HallMenuService>();
            builder.Services.AddScoped<RestaurantReservationService>();
            builder.Services.AddScoped<RestaurantSeatService>();
            builder.Services.AddScoped<RestaurantPeriodService>();

            builder.Services.AddControllers();
            // Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
            builder.Services.AddEndpointsApiExplorer();
            builder.Services.AddSwaggerGen();

            var app = builder.Build();

            // Configure the HTTP request pipeline.
            if (app.Environment.IsDevelopment())
            {
                app.UseSwagger();
                app.UseSwaggerUI();
            }

            app.UseCors(option => 
                option.AllowAnyOrigin()
                      .AllowAnyMethod()
                      .AllowAnyHeader());

            app.UseHttpsRedirection();

            app.UseAuthorization();


            app.MapControllers();

            app.Run();
        }
    }
}
