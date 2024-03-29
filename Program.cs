
using HotelFuen31.APIs.Hubs;
using HotelFuen31.APIs.Interface.Guanyu;
using HotelFuen31.APIs.Models;
using HotelFuen31.APIs.Repository.FC;
using HotelFuen31.APIs.Services.FC;
using HotelFuen31.APIs.Services;
using HotelFuen31.APIs.Services.Guanyu;
using HotelFuen31.APIs.Services.Jill;
using HotelFuen31.APIs.Services.RenYu;
using HotelFuen31.APIs.Services.Yee;
using HotelFuen31.APIs.Library;
using Microsoft.CodeAnalysis.Options;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection.Extensions;
using Microsoft.Extensions.FileProviders;
using HotelFuen31.APIs.Interfaces.FC;
using Hangfire;
using Hangfire.SqlServer;
using HotelFuen31.APIs.Services.Haku;

namespace HotelFuen31.APIs
{
    public class Program
    {
        public static void Main(string[] args)
        {
            var builder = WebApplication.CreateBuilder(args);

            // Add services to the container.
            builder.Services.AddSignalR();

            builder.Services.AddCors(options =>
            {
                options.AddDefaultPolicy(builder =>
                {
                    builder.SetIsOriginAllowed(origin => true)
                        .AllowAnyHeader()
                        .AllowAnyMethod()
                        .AllowCredentials();
                });
            });

            builder.Services.AddDbContext<AppDbContext>(options =>
            {
                options.UseSqlServer(builder.Configuration.GetConnectionString("AppDbContext"));
            });

            var connStr = builder.Configuration.GetConnectionString("AppDbContext");
            // Hangfire Service 
            builder.Services.AddHangfire(configuration =>
                configuration.SetDataCompatibilityLevel(CompatibilityLevel.Version_180)
                             .UseSimpleAssemblyNameTypeSerializer()
                             .UseRecommendedSerializerSettings()
                             .UseSqlServerStorage(connStr, new SqlServerStorageOptions
                             {
                                 CommandBatchMaxTimeout = TimeSpan.FromMinutes(5),
                                 SlidingInvisibilityTimeout = TimeSpan.FromMinutes(5),
                                 QueuePollInterval = TimeSpan.FromMinutes(5),
                                 UseRecommendedIsolationLevel = true,
                                 DisableGlobalLocks = true,
                             }));
            

            builder.Services.AddScoped<SendEmailService>();
            builder.Services.AddScoped<NotificationService>();


            builder.Services.AddScoped<HallItemService>();
            builder.Services.AddScoped<HallMenuService>();
            builder.Services.AddScoped<RestaurantReservationService>();
            builder.Services.AddScoped<RestaurantSeatService>();
            builder.Services.AddScoped<RestaurantPeriodService>();

            // yee
            builder.Services.AddScoped<CartRoomService>();
            builder.Services.AddScoped<OrderService>();
          
            //FC
            builder.Services.AddScoped<IReservationServRepo, ReservationServEFRepo>();
            builder.Services.AddScoped<ReservationServService>();
			builder.Services.AddScoped<IReservationServTypeRepo, ReservationServTypeEFRepo>();
			builder.Services.AddScoped<ReservationServTypeService>();


			builder.Services.AddScoped<IUser,UsersService>();
            builder.Services.AddScoped<JwtService>();
            builder.Services.AddScoped<CryptoPwd>();
            

            builder.Services.AddScoped<RoomTypeService>();

			//Haku
			builder.Services.AddScoped<DispatchService>();



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

            app.UseCors();

            app.UseHttpsRedirection();

            app.UseAuthorization();

			//靜態檔案存放路徑
			app.UseStaticFiles(new StaticFileOptions
            {
                FileProvider = new PhysicalFileProvider(Path.Combine(builder.Environment.ContentRootPath, "StaticFiles")),
                RequestPath = "/StaticFiles",
            });

            app.MapControllers();

            app.UseFileServer();

            app.UseHangfireDashboard();

            app.MapHub<NotificationHub>("/notificationHub");

            app.Run();
        }
    }
}
