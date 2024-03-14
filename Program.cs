using HotelFuen31.APIs.Interface.Guanyu;
using HotelFuen31.APIs.Models;
using HotelFuen31.APIs.Services.Guanyu;
using HotelFuen31.APIs.Services.Jill;
using HotelFuen31.APIs.Services.RenYu;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.FileProviders;

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

            builder.Services.AddScoped<IUser,UsersService>();
            builder.Services.AddScoped<JwtService>();




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

            //靜態檔案存放路徑
            app.UseStaticFiles(new StaticFileOptions
            {
                FileProvider = new PhysicalFileProvider(Path.Combine(builder.Environment.ContentRootPath, "StaticFiles")),
                RequestPath = "/StaticFiles",
            });

            app.MapControllers();

            app.Run();
        }
    }
}
