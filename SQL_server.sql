USE [master]
GO
/****** Object:  Database [dbHotel]    Script Date: 2024/4/24 下午 09:53:35 ******/
CREATE DATABASE [dbHotel]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'dbHotel', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQL2024\MSSQL\DATA\dbHotel.mdf' , SIZE = 1384448KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'dbHotel_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQL2024\MSSQL\DATA\dbHotel_log.ldf' , SIZE = 11018240KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [dbHotel] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [dbHotel].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [dbHotel] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [dbHotel] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [dbHotel] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [dbHotel] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [dbHotel] SET ARITHABORT OFF 
GO
ALTER DATABASE [dbHotel] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [dbHotel] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [dbHotel] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [dbHotel] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [dbHotel] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [dbHotel] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [dbHotel] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [dbHotel] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [dbHotel] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [dbHotel] SET  DISABLE_BROKER 
GO
ALTER DATABASE [dbHotel] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [dbHotel] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [dbHotel] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [dbHotel] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [dbHotel] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [dbHotel] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [dbHotel] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [dbHotel] SET RECOVERY FULL 
GO
ALTER DATABASE [dbHotel] SET  MULTI_USER 
GO
ALTER DATABASE [dbHotel] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [dbHotel] SET DB_CHAINING OFF 
GO
ALTER DATABASE [dbHotel] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [dbHotel] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [dbHotel] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [dbHotel] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'dbHotel', N'ON'
GO
ALTER DATABASE [dbHotel] SET QUERY_STORE = ON
GO
ALTER DATABASE [dbHotel] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [dbHotel]
GO
/****** Object:  User [hotel]    Script Date: 2024/4/24 下午 09:53:36 ******/
CREATE USER [hotel] FOR LOGIN [hotel] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [hotel]
GO
/****** Object:  Schema [HangFire]    Script Date: 2024/4/24 下午 09:53:36 ******/
CREATE SCHEMA [HangFire]
GO
/****** Object:  Table [dbo].[HallOrderItem]    Script Date: 2024/4/24 下午 09:53:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HallOrderItem](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[HallLogId] [int] NOT NULL,
	[Price] [int] NULL,
	[Qty] [int] NOT NULL,
	[SubTotal]  AS ([Price]*[Qty]),
 CONSTRAINT [PK_HallOrderItem] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HallLogs]    Script Date: 2024/4/24 下午 09:53:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HallLogs](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[HallId] [int] NOT NULL,
	[UserId] [int] NULL,
	[Guests] [int] NULL,
	[StartTime] [datetime] NOT NULL,
	[EndTime] [datetime] NOT NULL,
	[BookingStatus] [bit] NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[CellPhone] [varchar](10) NOT NULL,
	[Email] [nvarchar](256) NOT NULL,
	[FilePath] [nvarchar](max) NULL,
 CONSTRAINT [PK_HallLogs_1] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[HallOrderVw]    Script Date: 2024/4/24 下午 09:53:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[HallOrderVw]
AS
SELECT   dbo.HallLogs.Id, dbo.HallLogs.HallId, dbo.HallLogs.UserId, dbo.HallLogs.Guests, dbo.HallLogs.StartTime, dbo.HallLogs.EndTime, dbo.HallLogs.BookingStatus, dbo.HallLogs.Name, dbo.HallLogs.CellPhone, 
              dbo.HallLogs.Email, dbo.HallLogs.FilePath, SUM(dbo.HallOrderItem.Qty) AS TotalQty, SUM(dbo.HallOrderItem.SubTotal) AS TotalPrice, dbo.HallOrderItem.ProductName, dbo.HallOrderItem.ProductId, 
              dbo.HallOrderItem.Price, dbo.HallOrderItem.Qty, dbo.HallOrderItem.SubTotal
FROM     dbo.HallLogs INNER JOIN
              dbo.HallOrderItem ON dbo.HallLogs.Id = dbo.HallOrderItem.HallLogId
GROUP BY dbo.HallLogs.Id, dbo.HallLogs.HallId, dbo.HallLogs.UserId, dbo.HallLogs.Guests, dbo.HallLogs.StartTime, dbo.HallLogs.EndTime, dbo.HallLogs.BookingStatus, dbo.HallLogs.Name, dbo.HallLogs.CellPhone, 
              dbo.HallLogs.Email, dbo.HallLogs.FilePath, dbo.HallOrderItem.ProductName, dbo.HallOrderItem.ProductId, dbo.HallOrderItem.Price, dbo.HallOrderItem.Qty, dbo.HallOrderItem.SubTotal
GO
/****** Object:  Table [dbo].[ShoppingCartDiscounts_PriceReduce]    Script Date: 2024/4/24 下午 09:53:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ShoppingCartDiscounts_PriceReduce](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Price] [int] NOT NULL,
	[Discount] [int] NOT NULL,
 CONSTRAINT [PK_ShoppingCartDiscounts_PriceReduce] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ShoppingCartDiscounts]    Script Date: 2024/4/24 下午 09:53:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ShoppingCartDiscounts](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[FormName] [nvarchar](50) NOT NULL,
	[ActivityName] [nvarchar](max) NOT NULL,
	[StartTime] [datetime2](7) NOT NULL,
	[EndTime] [datetime2](7) NOT NULL,
	[Note] [nvarchar](max) NULL,
 CONSTRAINT [PK_ShoppingCartDiscounts] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[SCDs_PR]    Script Date: 2024/4/24 下午 09:53:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[SCDs_PR] AS
SELECT d.Id , d.FormName , d.ActivityName , d.StartTime , d.EndTime , p.Price , p.Discount , d.Note
FROM ShoppingCartDiscounts AS d JOIN ShoppingCartDiscounts_PriceReduce AS p ON (d.FormName = CONCAT('PriceReduce','_',p.Id)); 
GO
/****** Object:  Table [dbo].[ShoppingCartDiscounts_TheQuantities]    Script Date: 2024/4/24 下午 09:53:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ShoppingCartDiscounts_TheQuantities](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Quantity] [int] NOT NULL,
	[Discount] [decimal](3, 2) NOT NULL,
 CONSTRAINT [PK_ShoppingCartDiscounts_TheQuantities] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[SCDs_OQ]    Script Date: 2024/4/24 下午 09:53:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[SCDs_OQ] AS
SELECT d.Id , d.FormName , d.ActivityName , d.StartTime , d.EndTime , p.Quantity , p.Discount , d.Note
FROM ShoppingCartDiscounts AS d JOIN ShoppingCartDiscounts_TheQuantities AS p ON (d.FormName = CONCAT('TheQuantities','_',p.Id)); 

GO
/****** Object:  Table [dbo].[ShoppingCartDiscounts_PriceEquals]    Script Date: 2024/4/24 下午 09:53:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ShoppingCartDiscounts_PriceEquals](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[MainProductID] [nvarchar](50) NOT NULL,
	[MatchProductID] [nvarchar](50) NOT NULL,
	[Price] [int] NOT NULL,
 CONSTRAINT [PK_ShoppingCartDiscounts_PriceEquals] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[SCDs_PE]    Script Date: 2024/4/24 下午 09:53:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[SCDs_PE] AS
SELECT d.Id , d.FormName , d.ActivityName , d.StartTime , d.EndTime , p.MainProductID , p.MatchProductID , p.Price , d.Note
FROM ShoppingCartDiscounts AS d JOIN ShoppingCartDiscounts_PriceEquals AS p ON (d.FormName = CONCAT('PriceEquals','_',p.Id)); 

GO
/****** Object:  Table [dbo].[ShoppingCartDiscounts_TotalQuantities]    Script Date: 2024/4/24 下午 09:53:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ShoppingCartDiscounts_TotalQuantities](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Quantity] [int] NOT NULL,
	[Discount] [decimal](3, 2) NOT NULL,
 CONSTRAINT [PK_ShoppingCartDiscounts_TotalQuantities] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[SCDs_TQ]    Script Date: 2024/4/24 下午 09:53:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[SCDs_TQ] AS
SELECT d.Id , d.FormName , d.ActivityName , d.StartTime , d.EndTime , p.Quantity , p.Discount , d.Note
FROM ShoppingCartDiscounts AS d JOIN ShoppingCartDiscounts_TotalQuantities AS p ON (d.FormName = CONCAT('TotalQuantities','_',p.Id));



GO
/****** Object:  Table [dbo].[RoomCalendar]    Script Date: 2024/4/24 下午 09:53:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RoomCalendar](
	[Date] [date] NOT NULL,
	[Week] [varchar](10) NOT NULL,
	[IsHoliday] [varchar](10) NULL,
	[Description] [varchar](30) NULL,
PRIMARY KEY CLUSTERED 
(
	[Date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RoomTypes]    Script Date: 2024/4/24 下午 09:53:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RoomTypes](
	[RoomTypeId] [int] IDENTITY(1,1) NOT NULL,
	[TypeName] [varchar](50) NOT NULL,
	[Description] [varchar](max) NOT NULL,
	[Capacity] [int] NOT NULL,
	[BedType] [varchar](20) NOT NULL,
	[RoomCount] [int] NOT NULL,
	[WeekdayPrice] [int] NOT NULL,
	[WeekendPrice] [int] NOT NULL,
	[HolidayPrice] [int] NOT NULL,
	[ImageURL] [varchar](100) NOT NULL,
	[Size] [int] NULL,
 CONSTRAINT [PK__RoomType__BCC8963138C8FFE4] PRIMARY KEY CLUSTERED 
(
	[RoomTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[RoomDaysPrice]    Script Date: 2024/4/24 下午 09:53:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[RoomDaysPrice]
AS
SELECT  A.Date, A.Week, A.IsHoliday, A.Description, B.RoomTypeId, B.TypeName, CASE WHEN A.IsHoliday = 'true' AND 
                   A.Description <> '' THEN B.HolidayPrice WHEN A.Week = '六' OR
                   A.Week = '日' THEN B.WeekendPrice ELSE B.WeekdayPrice END AS PRICE
FROM      dbo.RoomCalendar AS A CROSS JOIN
                   dbo.RoomTypes AS B
GO
/****** Object:  Table [dbo].[Reservation]    Script Date: 2024/4/24 下午 09:53:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Reservation](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Client_id] [int] NULL,
	[Reservation_Status_id] [int] NOT NULL,
	[CreateTime] [datetime] NOT NULL,
	[Client_Name] [nvarchar](16) NULL,
	[PhoneNumber] [nchar](10) NULL,
 CONSTRAINT [Reservation_PK] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Reservation_Item]    Script Date: 2024/4/24 下午 09:53:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Reservation_Item](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Reservation_id] [int] NOT NULL,
	[Service_detail_id] [int] NOT NULL,
	[Appointment_date] [date] NOT NULL,
	[Appointment_time_period_id] [int] NOT NULL,
	[Total_Duration] [int] NOT NULL,
	[Room_id] [int] NULL,
	[Room_status_id] [int] NULL,
	[Subtotal] [int] NOT NULL,
 CONSTRAINT [Reservation_Item_PK] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[Reservation_TotalPriceView]    Script Date: 2024/4/24 下午 09:53:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Reservation_TotalPriceView]
AS
SELECT          dbo.Reservation.Id, dbo.Reservation.Client_id, dbo.Reservation.Reservation_Status_id, dbo.Reservation.CreateTime, 
                            SUM(dbo.Reservation_Item.Subtotal) AS TotalSubtotal
FROM              dbo.Reservation INNER JOIN
                            dbo.Reservation_Item ON dbo.Reservation.Id = dbo.Reservation_Item.Reservation_id
GROUP BY   dbo.Reservation.Id, dbo.Reservation.Client_id, dbo.Reservation.Reservation_Status_id, dbo.Reservation.CreateTime
GO
/****** Object:  Table [dbo].[Authorizations]    Script Date: 2024/4/24 下午 09:53:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Authorizations](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](16) NOT NULL,
	[Description] [nvarchar](max) NULL,
 CONSTRAINT [PK_Authorizations] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BusRoutes]    Script Date: 2024/4/24 下午 09:53:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BusRoutes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[StarterStop] [nvarchar](50) NOT NULL,
	[StarterLongtitude] [nvarchar](50) NOT NULL,
	[StarterLatitude] [nvarchar](50) NOT NULL,
	[DestinationStop] [nvarchar](50) NOT NULL,
	[DestinationLongtitude] [nvarchar](50) NOT NULL,
	[DestinationLatitude] [nvarchar](50) NOT NULL,
	[DepartureTime] [datetime2](7) NOT NULL,
	[ArrivalTime] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_BusRoutes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UC_StarterDestination] UNIQUE NONCLUSTERED 
(
	[StarterStop] ASC,
	[DestinationStop] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BusTrackers]    Script Date: 2024/4/24 下午 09:53:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BusTrackers](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[BusId] [int] NOT NULL,
	[Latitude] [int] NOT NULL,
	[Longtitude] [int] NOT NULL,
	[Status] [nvarchar](50) NOT NULL,
	[LastUpdate] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_BusTrackers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CarMaintenance]    Script Date: 2024/4/24 下午 09:53:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CarMaintenance](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CarId] [int] NOT NULL,
	[StartTime] [datetime2](7) NOT NULL,
	[ActualStartTime] [datetime2](7) NOT NULL,
	[EndTime] [datetime2](7) NOT NULL,
	[ActualEndTime] [datetime2](7) NOT NULL,
	[Action] [nvarchar](50) NOT NULL,
	[Expense] [decimal](18, 0) NOT NULL,
	[EmpId] [int] NOT NULL,
 CONSTRAINT [PK_Maintenance] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CarManagements]    Script Date: 2024/4/24 下午 09:53:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CarManagements](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Capacity] [int] NOT NULL,
	[Brand] [nvarchar](50) NOT NULL,
	[Goal] [nvarchar](50) NOT NULL,
	[CarModel] [nvarchar](50) NOT NULL,
	[CarIdentity] [nvarchar](50) NOT NULL,
	[ImgUrl] [nvarchar](50) NOT NULL,
	[Status] [bit] NOT NULL,
 CONSTRAINT [PK_CarManagements] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CarPrices]    Script Date: 2024/4/24 下午 09:53:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CarPrices](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[LowDistance] [nvarchar](50) NOT NULL,
	[HighDistance] [nvarchar](50) NOT NULL,
	[Price] [decimal](18, 0) NOT NULL,
 CONSTRAINT [PK_CarPrices] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UC_Distance] UNIQUE NONCLUSTERED 
(
	[LowDistance] ASC,
	[HighDistance] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CarRentCartItems]    Script Date: 2024/4/24 下午 09:53:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CarRentCartItems](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CarId] [int] NOT NULL,
	[SubTotal] [decimal](18, 0) NOT NULL,
	[StartTime] [datetime2](7) NOT NULL,
	[EndTime] [datetime2](7) NOT NULL,
	[MemberId] [int] NOT NULL,
	[EmpId] [int] NOT NULL,
 CONSTRAINT [PK_CarRentCartItems] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UC_Member_StartEnd_CarId] UNIQUE NONCLUSTERED 
(
	[CarId] ASC,
	[StartTime] ASC,
	[EndTime] ASC,
	[MemberId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CarRentOrderItems]    Script Date: 2024/4/24 下午 09:53:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CarRentOrderItems](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CarId] [int] NOT NULL,
	[SubTotal] [decimal](18, 0) NOT NULL,
	[StartTime] [datetime2](7) NOT NULL,
	[EndTime] [datetime2](7) NOT NULL,
	[EmpId] [int] NOT NULL,
	[MemberId] [int] NOT NULL,
	[OrderId] [int] NOT NULL,
 CONSTRAINT [PK_CarRentOrderItems] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CarRentOrders]    Script Date: 2024/4/24 下午 09:53:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CarRentOrders](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[MemberId] [int] NOT NULL,
	[EmpId] [int] NOT NULL,
	[BookingTime] [datetime2](7) NOT NULL,
	[Total] [decimal](18, 0) NOT NULL,
 CONSTRAINT [PK_CarRentOrders] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CarResponsible]    Script Date: 2024/4/24 下午 09:53:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CarResponsible](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CarId] [int] NOT NULL,
	[EmpId] [int] NOT NULL,
 CONSTRAINT [PK_CarResponsible] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UC_EmpCar] UNIQUE NONCLUSTERED 
(
	[CarId] ASC,
	[EmpId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Cars]    Script Date: 2024/4/24 下午 09:53:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Cars](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EmpId] [int] NOT NULL,
	[Capacity] [int] NOT NULL,
	[PlusPrice] [int] NOT NULL,
	[Comment] [nvarchar](50) NOT NULL,
	[Picture] [nvarchar](100) NOT NULL,
	[Description] [nvarchar](500) NOT NULL,
 CONSTRAINT [PK_Cars] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CarTaxiCartItems]    Script Date: 2024/4/24 下午 09:53:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CarTaxiCartItems](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CarId] [int] NOT NULL,
	[PickUpLongtitude] [varchar](50) NOT NULL,
	[PickUpLatitude] [varchar](50) NOT NULL,
	[DestinationLatitude] [varchar](50) NOT NULL,
	[DestinationLongtitude] [varchar](50) NOT NULL,
	[SubTotal] [decimal](18, 0) NOT NULL,
	[StartTime] [datetime2](7) NOT NULL,
	[ActualStartTime] [datetime2](7) NOT NULL,
	[EndTime] [datetime2](7) NOT NULL,
	[ActualEndTime] [datetime2](7) NOT NULL,
	[MemberId] [int] NOT NULL,
	[EmpId] [int] NOT NULL,
 CONSTRAINT [PK_CarCartItems] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CarTaxiOrderItems]    Script Date: 2024/4/24 下午 09:53:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CarTaxiOrderItems](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CarId] [int] NOT NULL,
	[PickUpLongtitude] [nvarchar](50) NOT NULL,
	[PickUpLatitude] [nvarchar](50) NOT NULL,
	[PickUpLocation] [nvarchar](150) NOT NULL,
	[DestinationLatitude] [nvarchar](50) NOT NULL,
	[DestinationLongtitude] [nvarchar](50) NOT NULL,
	[DestinationLocation] [nvarchar](150) NOT NULL,
	[Total] [decimal](18, 0) NOT NULL,
	[StartTime] [datetime2](7) NOT NULL,
	[EndTime] [datetime2](7) NOT NULL,
	[EmpId] [int] NOT NULL,
	[MemberId] [int] NOT NULL,
 CONSTRAINT [PK_CarTaxiOrderItems] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CarTaxiOrders]    Script Date: 2024/4/24 下午 09:53:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CarTaxiOrders](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EmpId] [int] NOT NULL,
	[MemberId] [int] NOT NULL,
	[BookingTime] [datetime2](7) NOT NULL,
	[Total] [decimal](18, 0) NOT NULL,
 CONSTRAINT [PK_CarTaxiOrders] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CartRoomItems]    Script Date: 2024/4/24 下午 09:53:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CartRoomItems](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Phone] [varchar](16) NOT NULL,
	[Uid] [nvarchar](max) NOT NULL,
	[Selected] [bit] NOT NULL,
	[TypeId] [int] NOT NULL,
	[RoomId] [int] NOT NULL,
	[CheckInDate] [datetime2](7) NOT NULL,
	[CheckOutDate] [datetime2](7) NOT NULL,
	[Remark] [nvarchar](max) NULL,
 CONSTRAINT [PK_RoomCarts] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[cipher]    Script Date: 2024/4/24 下午 09:53:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cipher](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NOT NULL,
	[CipherString] [nvarchar](max) NULL,
	[CipherKey] [nvarchar](max) NULL,
 CONSTRAINT [PK_cipher] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CouponMember]    Script Date: 2024/4/24 下午 09:53:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CouponMember](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[MemberId] [int] NOT NULL,
	[CouponId] [int] NOT NULL,
 CONSTRAINT [PK_CouponMember] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CouponRoomCountSameDate]    Script Date: 2024/4/24 下午 09:53:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CouponRoomCountSameDate](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CouponId] [int] NOT NULL,
	[RoomTypeId] [int] NOT NULL,
	[Count] [int] NOT NULL,
	[percentOff] [int] NOT NULL,
 CONSTRAINT [PK_CouponRoomCountSameDate] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [IX_CouponRoomCountSameDate] UNIQUE NONCLUSTERED 
(
	[CouponId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CouponRoomTimeSpan]    Script Date: 2024/4/24 下午 09:53:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CouponRoomTimeSpan](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CouponId] [int] NOT NULL,
	[RoomTypeId] [int] NOT NULL,
	[StartTime] [datetime2](7) NOT NULL,
	[EndTime] [datetime2](7) NOT NULL,
	[PercentOff] [int] NOT NULL,
 CONSTRAINT [PK_CouponRoomTimeSpan] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [IX_CouponRoomTimeSpan] UNIQUE NONCLUSTERED 
(
	[CouponId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Coupons]    Script Date: 2024/4/24 下午 09:53:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Coupons](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[TypeId] [int] NOT NULL,
	[AllowStart] [datetime2](7) NOT NULL,
	[AllowEnd] [datetime2](7) NOT NULL,
	[Cumulative] [bit] NOT NULL,
	[Comment] [nvarchar](50) NULL,
 CONSTRAINT [PK_Coupons] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CouponThresholdDiscount]    Script Date: 2024/4/24 下午 09:53:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CouponThresholdDiscount](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CouponId] [int] NOT NULL,
	[Threshold] [int] NOT NULL,
	[Discount] [int] NOT NULL,
 CONSTRAINT [PK_CouponThresholdDiscount] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [IX_CouponThresholdDiscount] UNIQUE NONCLUSTERED 
(
	[CouponId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CouponTypes]    Script Date: 2024/4/24 下午 09:53:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CouponTypes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_CouponTypes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Employee]    Script Date: 2024/4/24 下午 09:53:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Employee](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](32) NOT NULL,
	[Email] [nvarchar](128) NOT NULL,
	[Password] [varchar](256) NOT NULL,
	[Salt] [varchar](64) NOT NULL,
	[HireDate] [datetime2](7) NOT NULL,
	[LeaveDate] [datetime2](7) NULL,
	[BloodType] [varchar](8) NOT NULL,
	[IdentityNumber] [varchar](16) NOT NULL,
	[Birthday] [datetime2](7) NOT NULL,
	[Gender] [bit] NOT NULL,
	[Phone] [varchar](16) NOT NULL,
	[Address] [nvarchar](1024) NOT NULL,
 CONSTRAINT [PK_Employee] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EmployeeRoles]    Script Date: 2024/4/24 下午 09:53:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeeRoles](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeId] [int] NOT NULL,
	[RoleId] [int] NOT NULL,
 CONSTRAINT [PK_EmployeeRoles] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [IX_EmployeeRoles_UK] UNIQUE NONCLUSTERED 
(
	[EmployeeId] ASC,
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HallDishCategory]    Script Date: 2024/4/24 下午 09:53:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HallDishCategory](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Category] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_HallDishCategory] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HallItems]    Script Date: 2024/4/24 下午 09:53:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HallItems](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[HallName] [nvarchar](50) NOT NULL,
	[Capacity] [nvarchar](50) NOT NULL,
	[MinRent] [decimal](18, 0) NOT NULL,
	[Description] [nvarchar](256) NOT NULL,
	[MaxRent] [decimal](18, 0) NOT NULL,
	[PhotoPath] [nvarchar](max) NULL,
	[HallStatus] [bit] NOT NULL,
	[DDescription] [nvarchar](256) NULL,
	[Location] [nvarchar](50) NULL,
 CONSTRAINT [PK_HallItems] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HallMenus]    Script Date: 2024/4/24 下午 09:53:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HallMenus](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[DishName] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](256) NOT NULL,
	[Price] [decimal](18, 0) NOT NULL,
	[CategoryId] [int] NOT NULL,
	[PhotoPath] [nvarchar](max) NULL,
	[Keywords] [nvarchar](max) NULL,
 CONSTRAINT [PK_HallMenus] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HallMenuSchedules]    Script Date: 2024/4/24 下午 09:53:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HallMenuSchedules](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[HallMenuId] [int] NULL,
	[HallOrderItemId] [int] NULL,
 CONSTRAINT [PK_HallMenuSchedules] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MemberLevels]    Script Date: 2024/4/24 下午 09:53:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MemberLevels](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](16) NOT NULL,
	[LowerSpending] [int] NOT NULL,
	[LowerOrders] [int] NOT NULL,
	[Comment] [nvarchar](max) NULL,
 CONSTRAINT [PK_MemberLevels] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Members]    Script Date: 2024/4/24 下午 09:53:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Members](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](32) NOT NULL,
	[Email] [nvarchar](128) NOT NULL,
	[Password] [varchar](256) NOT NULL,
	[IsConfirmed] [bit] NOT NULL,
	[ConfirmCode] [varchar](64) NULL,
	[RegistrationDate] [datetime2](7) NOT NULL,
	[IdentityNumber] [varchar](50) NOT NULL,
	[BirthDay] [datetime2](7) NULL,
	[Gender] [bit] NOT NULL,
	[Phone] [varchar](16) NOT NULL,
	[Address] [nvarchar](1024) NULL,
	[Ban] [bit] NOT NULL,
	[LevelId] [int] NOT NULL,
	[Salt] [nvarchar](50) NULL,
 CONSTRAINT [PK_Members] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Notifications]    Script Date: 2024/4/24 下午 09:53:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Notifications](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[Description] [nvarchar](max) NOT NULL,
	[PushTime] [datetime2](7) NOT NULL,
	[Image] [nvarchar](max) NULL,
	[TypeId] [int] NOT NULL,
	[LevelId] [int] NULL,
 CONSTRAINT [PK_Notification] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NotificationTypes]    Script Date: 2024/4/24 下午 09:53:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NotificationTypes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_NotificationTypes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Orders]    Script Date: 2024/4/24 下午 09:53:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Orders](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Phone] [nchar](10) NOT NULL,
	[Status] [int] NOT NULL,
	[OrderTime] [datetime2](7) NOT NULL,
	[MerchantTradeNo] [nvarchar](50) NULL,
	[RtnCode] [int] NULL,
	[RtnMsg] [nvarchar](50) NULL,
	[TradeNo] [nvarchar](50) NULL,
	[TradeAmt] [int] NULL,
	[PaymentDate] [datetime2](7) NULL,
	[PaymentType] [nvarchar](50) NULL,
	[PaymentTypeChargeFee] [nvarchar](50) NULL,
	[TradeDate] [nvarchar](50) NULL,
	[SimulatePaid] [int] NULL,
	[CheckMacValue] [nvarchar](max) NULL,
 CONSTRAINT [PK_Orders] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Reservation_Appointment_Time_Period]    Script Date: 2024/4/24 下午 09:53:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Reservation_Appointment_Time_Period](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Time_Period] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](100) NOT NULL,
	[TimeValue] [int] NOT NULL,
 CONSTRAINT [Appointment_time_period_PK] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Reservation_Room]    Script Date: 2024/4/24 下午 09:53:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Reservation_Room](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Room_Name] [nvarchar](30) NOT NULL,
	[Room_Type_id] [int] NOT NULL,
	[Capacity] [int] NOT NULL,
 CONSTRAINT [Room_PK] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Reservation_Room_Status]    Script Date: 2024/4/24 下午 09:53:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Reservation_Room_Status](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Room_Status_Name] [nvarchar](30) NOT NULL,
 CONSTRAINT [Room_Status_PK] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Reservation_Room_Type]    Script Date: 2024/4/24 下午 09:53:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Reservation_Room_Type](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Room_Type_Name] [nvarchar](30) NOT NULL,
 CONSTRAINT [Room_Type_PK] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Reservation_Service_detail]    Script Date: 2024/4/24 下午 09:53:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Reservation_Service_detail](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Services_Type_id] [int] NOT NULL,
	[Service_detail_Name] [nvarchar](50) NOT NULL,
	[Time] [int] NOT NULL,
	[Price] [int] NOT NULL,
	[Description] [nvarchar](200) NULL,
	[ImgURL] [varchar](100) NULL,
 CONSTRAINT [Service_detail_PK] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Reservation_Services_Type]    Script Date: 2024/4/24 下午 09:53:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Reservation_Services_Type](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Services_Type_Name] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](200) NULL,
	[Services_Type_ImageURL] [nvarchar](200) NULL,
 CONSTRAINT [Services_Type_PK] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Reservation_Status]    Script Date: 2024/4/24 下午 09:53:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Reservation_Status](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Status_Name] [nvarchar](30) NOT NULL,
 CONSTRAINT [Reservation_Status_PK] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RestaurantCustomers]    Script Date: 2024/4/24 下午 09:53:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RestaurantCustomers](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Phone] [nvarchar](50) NOT NULL,
	[Email] [nvarchar](50) NULL,
 CONSTRAINT [PK_Customers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RestaurantPeriods]    Script Date: 2024/4/24 下午 09:53:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RestaurantPeriods](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[UnitPrice] [int] NOT NULL,
 CONSTRAINT [PK_Periods] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RestaurantReservations]    Script Date: 2024/4/24 下午 09:53:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RestaurantReservations](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Customer_Id] [int] NOT NULL,
	[Date] [date] NOT NULL,
	[Counts] [int] NOT NULL,
	[Period_id] [int] NOT NULL,
	[Status_Id] [int] NULL,
	[Seat_Id] [int] NOT NULL,
 CONSTRAINT [PK_Reservations] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RestaurantSeats]    Script Date: 2024/4/24 下午 09:53:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RestaurantSeats](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[type] [nvarchar](10) NOT NULL,
	[Capacity] [int] NOT NULL,
 CONSTRAINT [PK_Seats] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RestaurantStatuses]    Script Date: 2024/4/24 下午 09:53:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RestaurantStatuses](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Status] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RoleAuthorizations]    Script Date: 2024/4/24 下午 09:53:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RoleAuthorizations](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[RoleId] [int] NOT NULL,
	[AuthorizationId] [int] NOT NULL,
 CONSTRAINT [PK_RoleAuthorizations] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [IX_RoleAuthorizations_UK] UNIQUE NONCLUSTERED 
(
	[AuthorizationId] ASC,
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Roles]    Script Date: 2024/4/24 下午 09:53:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Roles](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[RoleName] [nvarchar](16) NOT NULL,
	[Description] [nvarchar](max) NULL,
 CONSTRAINT [PK_Roles] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RoomBookings]    Script Date: 2024/4/24 下午 09:53:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RoomBookings](
	[BookingId] [int] IDENTITY(1,1) NOT NULL,
	[OrderId] [int] NOT NULL,
	[RoomId] [int] NOT NULL,
	[CheckInDate] [datetime] NOT NULL,
	[CheckOutDate] [datetime] NOT NULL,
	[MemberId] [int] NULL,
	[Remark] [varchar](max) NULL,
	[BookingStatusId] [int] NOT NULL,
	[BookingCancelDate] [datetime] NULL,
	[BookingDate] [datetime] NOT NULL,
	[OrderPrice] [int] NOT NULL,
	[Phone] [varchar](20) NOT NULL,
 CONSTRAINT [PK__Bookings__73951AED2B45D90B] PRIMARY KEY CLUSTERED 
(
	[BookingId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RoomDetailImg]    Script Date: 2024/4/24 下午 09:53:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RoomDetailImg](
	[RoomTypeId] [int] NOT NULL,
	[ImgUrl] [varchar](100) NULL,
	[ImgSeq] [int] NOT NULL,
 CONSTRAINT [PK_RoomDetailImg] PRIMARY KEY CLUSTERED 
(
	[RoomTypeId] ASC,
	[ImgSeq] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Rooms]    Script Date: 2024/4/24 下午 09:53:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Rooms](
	[RoomId] [int] NOT NULL,
	[RoomTypeId] [int] NOT NULL,
 CONSTRAINT [PK__Rooms__328639398538E86F] PRIMARY KEY CLUSTERED 
(
	[RoomId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RoomStatusSetting]    Script Date: 2024/4/24 下午 09:53:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RoomStatusSetting](
	[StatusId] [int] NOT NULL,
	[StatusName] [varchar](10) NOT NULL,
 CONSTRAINT [PK__StatusSe__C8EE20633ED3749B] PRIMARY KEY CLUSTERED 
(
	[StatusId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SendedNotifications]    Script Date: 2024/4/24 下午 09:53:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SendedNotifications](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[MemberId] [int] NOT NULL,
	[NotificationId] [int] NOT NULL,
	[IsSended] [bit] NOT NULL,
 CONSTRAINT [PK_SendedNotifications] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ShoppingCartOrders]    Script Date: 2024/4/24 下午 09:53:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ShoppingCartOrders](
	[Id] [nvarchar](50) NOT NULL,
	[OrderId] [nvarchar](50) NOT NULL,
	[MemberId] [nvarchar](50) NULL,
	[Price] [int] NOT NULL,
	[states] [bit] NOT NULL,
	[Note] [nvarchar](max) NULL,
 CONSTRAINT [PK_ShoppingCartOrders] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [HangFire].[AggregatedCounter]    Script Date: 2024/4/24 下午 09:53:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HangFire].[AggregatedCounter](
	[Key] [nvarchar](100) NOT NULL,
	[Value] [bigint] NOT NULL,
	[ExpireAt] [datetime] NULL,
 CONSTRAINT [PK_HangFire_CounterAggregated] PRIMARY KEY CLUSTERED 
(
	[Key] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [HangFire].[Counter]    Script Date: 2024/4/24 下午 09:53:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HangFire].[Counter](
	[Key] [nvarchar](100) NOT NULL,
	[Value] [int] NOT NULL,
	[ExpireAt] [datetime] NULL,
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_HangFire_Counter] PRIMARY KEY CLUSTERED 
(
	[Key] ASC,
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [HangFire].[Hash]    Script Date: 2024/4/24 下午 09:53:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HangFire].[Hash](
	[Key] [nvarchar](100) NOT NULL,
	[Field] [nvarchar](100) NOT NULL,
	[Value] [nvarchar](max) NULL,
	[ExpireAt] [datetime2](7) NULL,
 CONSTRAINT [PK_HangFire_Hash] PRIMARY KEY CLUSTERED 
(
	[Key] ASC,
	[Field] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = ON, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [HangFire].[Job]    Script Date: 2024/4/24 下午 09:53:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HangFire].[Job](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[StateId] [bigint] NULL,
	[StateName] [nvarchar](20) NULL,
	[InvocationData] [nvarchar](max) NOT NULL,
	[Arguments] [nvarchar](max) NOT NULL,
	[CreatedAt] [datetime] NOT NULL,
	[ExpireAt] [datetime] NULL,
 CONSTRAINT [PK_HangFire_Job] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [HangFire].[JobParameter]    Script Date: 2024/4/24 下午 09:53:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HangFire].[JobParameter](
	[JobId] [bigint] NOT NULL,
	[Name] [nvarchar](40) NOT NULL,
	[Value] [nvarchar](max) NULL,
 CONSTRAINT [PK_HangFire_JobParameter] PRIMARY KEY CLUSTERED 
(
	[JobId] ASC,
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [HangFire].[JobQueue]    Script Date: 2024/4/24 下午 09:53:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HangFire].[JobQueue](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[JobId] [bigint] NOT NULL,
	[Queue] [nvarchar](50) NOT NULL,
	[FetchedAt] [datetime] NULL,
 CONSTRAINT [PK_HangFire_JobQueue] PRIMARY KEY CLUSTERED 
(
	[Queue] ASC,
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [HangFire].[List]    Script Date: 2024/4/24 下午 09:53:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HangFire].[List](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Key] [nvarchar](100) NOT NULL,
	[Value] [nvarchar](max) NULL,
	[ExpireAt] [datetime] NULL,
 CONSTRAINT [PK_HangFire_List] PRIMARY KEY CLUSTERED 
(
	[Key] ASC,
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [HangFire].[Schema]    Script Date: 2024/4/24 下午 09:53:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HangFire].[Schema](
	[Version] [int] NOT NULL,
 CONSTRAINT [PK_HangFire_Schema] PRIMARY KEY CLUSTERED 
(
	[Version] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [HangFire].[Server]    Script Date: 2024/4/24 下午 09:53:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HangFire].[Server](
	[Id] [nvarchar](200) NOT NULL,
	[Data] [nvarchar](max) NULL,
	[LastHeartbeat] [datetime] NOT NULL,
 CONSTRAINT [PK_HangFire_Server] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [HangFire].[Set]    Script Date: 2024/4/24 下午 09:53:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HangFire].[Set](
	[Key] [nvarchar](100) NOT NULL,
	[Score] [float] NOT NULL,
	[Value] [nvarchar](256) NOT NULL,
	[ExpireAt] [datetime] NULL,
 CONSTRAINT [PK_HangFire_Set] PRIMARY KEY CLUSTERED 
(
	[Key] ASC,
	[Value] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = ON, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [HangFire].[State]    Script Date: 2024/4/24 下午 09:53:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HangFire].[State](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[JobId] [bigint] NOT NULL,
	[Name] [nvarchar](20) NOT NULL,
	[Reason] [nvarchar](100) NULL,
	[CreatedAt] [datetime] NOT NULL,
	[Data] [nvarchar](max) NULL,
 CONSTRAINT [PK_HangFire_State] PRIMARY KEY CLUSTERED 
(
	[JobId] ASC,
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Index [IX_HangFire_AggregatedCounter_ExpireAt]    Script Date: 2024/4/24 下午 09:53:36 ******/
CREATE NONCLUSTERED INDEX [IX_HangFire_AggregatedCounter_ExpireAt] ON [HangFire].[AggregatedCounter]
(
	[ExpireAt] ASC
)
WHERE ([ExpireAt] IS NOT NULL)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_HangFire_Hash_ExpireAt]    Script Date: 2024/4/24 下午 09:53:36 ******/
CREATE NONCLUSTERED INDEX [IX_HangFire_Hash_ExpireAt] ON [HangFire].[Hash]
(
	[ExpireAt] ASC
)
WHERE ([ExpireAt] IS NOT NULL)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_HangFire_Job_ExpireAt]    Script Date: 2024/4/24 下午 09:53:36 ******/
CREATE NONCLUSTERED INDEX [IX_HangFire_Job_ExpireAt] ON [HangFire].[Job]
(
	[ExpireAt] ASC
)
INCLUDE([StateName]) 
WHERE ([ExpireAt] IS NOT NULL)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_HangFire_Job_StateName]    Script Date: 2024/4/24 下午 09:53:36 ******/
CREATE NONCLUSTERED INDEX [IX_HangFire_Job_StateName] ON [HangFire].[Job]
(
	[StateName] ASC
)
WHERE ([StateName] IS NOT NULL)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_HangFire_List_ExpireAt]    Script Date: 2024/4/24 下午 09:53:36 ******/
CREATE NONCLUSTERED INDEX [IX_HangFire_List_ExpireAt] ON [HangFire].[List]
(
	[ExpireAt] ASC
)
WHERE ([ExpireAt] IS NOT NULL)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_HangFire_Server_LastHeartbeat]    Script Date: 2024/4/24 下午 09:53:36 ******/
CREATE NONCLUSTERED INDEX [IX_HangFire_Server_LastHeartbeat] ON [HangFire].[Server]
(
	[LastHeartbeat] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_HangFire_Set_ExpireAt]    Script Date: 2024/4/24 下午 09:53:36 ******/
CREATE NONCLUSTERED INDEX [IX_HangFire_Set_ExpireAt] ON [HangFire].[Set]
(
	[ExpireAt] ASC
)
WHERE ([ExpireAt] IS NOT NULL)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_HangFire_Set_Score]    Script Date: 2024/4/24 下午 09:53:36 ******/
CREATE NONCLUSTERED INDEX [IX_HangFire_Set_Score] ON [HangFire].[Set]
(
	[Key] ASC,
	[Score] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_HangFire_State_CreatedAt]    Script Date: 2024/4/24 下午 09:53:36 ******/
CREATE NONCLUSTERED INDEX [IX_HangFire_State_CreatedAt] ON [HangFire].[State]
(
	[CreatedAt] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CarMaintenance]  WITH CHECK ADD  CONSTRAINT [FK_CarMaintenance_CarManagements] FOREIGN KEY([CarId])
REFERENCES [dbo].[CarManagements] ([Id])
GO
ALTER TABLE [dbo].[CarMaintenance] CHECK CONSTRAINT [FK_CarMaintenance_CarManagements]
GO
ALTER TABLE [dbo].[CarMaintenance]  WITH CHECK ADD  CONSTRAINT [FK_CarMaintenance_Employee] FOREIGN KEY([EmpId])
REFERENCES [dbo].[Employee] ([Id])
GO
ALTER TABLE [dbo].[CarMaintenance] CHECK CONSTRAINT [FK_CarMaintenance_Employee]
GO
ALTER TABLE [dbo].[CarRentCartItems]  WITH CHECK ADD  CONSTRAINT [FK_CarRentCartItems_CarManagements] FOREIGN KEY([CarId])
REFERENCES [dbo].[CarManagements] ([Id])
GO
ALTER TABLE [dbo].[CarRentCartItems] CHECK CONSTRAINT [FK_CarRentCartItems_CarManagements]
GO
ALTER TABLE [dbo].[CarRentCartItems]  WITH CHECK ADD  CONSTRAINT [FK_CarRentCartItems_Employee] FOREIGN KEY([EmpId])
REFERENCES [dbo].[Employee] ([Id])
GO
ALTER TABLE [dbo].[CarRentCartItems] CHECK CONSTRAINT [FK_CarRentCartItems_Employee]
GO
ALTER TABLE [dbo].[CarRentCartItems]  WITH CHECK ADD  CONSTRAINT [FK_CarRentCartItems_Members] FOREIGN KEY([MemberId])
REFERENCES [dbo].[Members] ([Id])
GO
ALTER TABLE [dbo].[CarRentCartItems] CHECK CONSTRAINT [FK_CarRentCartItems_Members]
GO
ALTER TABLE [dbo].[CarRentOrderItems]  WITH CHECK ADD  CONSTRAINT [FK_CarRentOrderItems_CarManagements] FOREIGN KEY([CarId])
REFERENCES [dbo].[CarManagements] ([Id])
GO
ALTER TABLE [dbo].[CarRentOrderItems] CHECK CONSTRAINT [FK_CarRentOrderItems_CarManagements]
GO
ALTER TABLE [dbo].[CarRentOrderItems]  WITH CHECK ADD  CONSTRAINT [FK_CarRentOrderItems_Employee] FOREIGN KEY([EmpId])
REFERENCES [dbo].[Employee] ([Id])
GO
ALTER TABLE [dbo].[CarRentOrderItems] CHECK CONSTRAINT [FK_CarRentOrderItems_Employee]
GO
ALTER TABLE [dbo].[CarRentOrderItems]  WITH CHECK ADD  CONSTRAINT [FK_CarRentOrderItems_Members] FOREIGN KEY([MemberId])
REFERENCES [dbo].[Members] ([Id])
GO
ALTER TABLE [dbo].[CarRentOrderItems] CHECK CONSTRAINT [FK_CarRentOrderItems_Members]
GO
ALTER TABLE [dbo].[CarResponsible]  WITH CHECK ADD  CONSTRAINT [FK_CarResponsible_CarId] FOREIGN KEY([CarId])
REFERENCES [dbo].[CarManagements] ([Id])
GO
ALTER TABLE [dbo].[CarResponsible] CHECK CONSTRAINT [FK_CarResponsible_CarId]
GO
ALTER TABLE [dbo].[CarResponsible]  WITH CHECK ADD  CONSTRAINT [FK_CarResponsible_EmpId] FOREIGN KEY([EmpId])
REFERENCES [dbo].[Employee] ([Id])
GO
ALTER TABLE [dbo].[CarResponsible] CHECK CONSTRAINT [FK_CarResponsible_EmpId]
GO
ALTER TABLE [dbo].[CarTaxiCartItems]  WITH CHECK ADD  CONSTRAINT [FK_CarTaxiCartItems_CarManagements] FOREIGN KEY([CarId])
REFERENCES [dbo].[CarManagements] ([Id])
GO
ALTER TABLE [dbo].[CarTaxiCartItems] CHECK CONSTRAINT [FK_CarTaxiCartItems_CarManagements]
GO
ALTER TABLE [dbo].[CarTaxiCartItems]  WITH CHECK ADD  CONSTRAINT [FK_CarTaxiCartItems_Employee] FOREIGN KEY([EmpId])
REFERENCES [dbo].[Employee] ([Id])
GO
ALTER TABLE [dbo].[CarTaxiCartItems] CHECK CONSTRAINT [FK_CarTaxiCartItems_Employee]
GO
ALTER TABLE [dbo].[CarTaxiCartItems]  WITH CHECK ADD  CONSTRAINT [FK_CarTaxiCartItems_Members] FOREIGN KEY([MemberId])
REFERENCES [dbo].[Members] ([Id])
GO
ALTER TABLE [dbo].[CarTaxiCartItems] CHECK CONSTRAINT [FK_CarTaxiCartItems_Members]
GO
ALTER TABLE [dbo].[CarTaxiOrderItems]  WITH CHECK ADD  CONSTRAINT [FK_CarTaxiOrderItems_Cars] FOREIGN KEY([CarId])
REFERENCES [dbo].[Cars] ([Id])
GO
ALTER TABLE [dbo].[CarTaxiOrderItems] CHECK CONSTRAINT [FK_CarTaxiOrderItems_Cars]
GO
ALTER TABLE [dbo].[CarTaxiOrderItems]  WITH CHECK ADD  CONSTRAINT [FK_CarTaxiOrderItems_Employee] FOREIGN KEY([EmpId])
REFERENCES [dbo].[Employee] ([Id])
GO
ALTER TABLE [dbo].[CarTaxiOrderItems] CHECK CONSTRAINT [FK_CarTaxiOrderItems_Employee]
GO
ALTER TABLE [dbo].[CarTaxiOrderItems]  WITH CHECK ADD  CONSTRAINT [FK_CarTaxiOrderItems_Members] FOREIGN KEY([MemberId])
REFERENCES [dbo].[Members] ([Id])
GO
ALTER TABLE [dbo].[CarTaxiOrderItems] CHECK CONSTRAINT [FK_CarTaxiOrderItems_Members]
GO
ALTER TABLE [dbo].[CartRoomItems]  WITH CHECK ADD  CONSTRAINT [FK_CartRoomItems_RoomTypeId] FOREIGN KEY([TypeId])
REFERENCES [dbo].[RoomTypes] ([RoomTypeId])
GO
ALTER TABLE [dbo].[CartRoomItems] CHECK CONSTRAINT [FK_CartRoomItems_RoomTypeId]
GO
ALTER TABLE [dbo].[CouponMember]  WITH CHECK ADD  CONSTRAINT [FK_CouponMember_CouponId] FOREIGN KEY([CouponId])
REFERENCES [dbo].[Coupons] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[CouponMember] CHECK CONSTRAINT [FK_CouponMember_CouponId]
GO
ALTER TABLE [dbo].[CouponMember]  WITH CHECK ADD  CONSTRAINT [FK_CouponMember_MemberId] FOREIGN KEY([MemberId])
REFERENCES [dbo].[Members] ([Id])
GO
ALTER TABLE [dbo].[CouponMember] CHECK CONSTRAINT [FK_CouponMember_MemberId]
GO
ALTER TABLE [dbo].[CouponRoomCountSameDate]  WITH CHECK ADD  CONSTRAINT [FK_CouponRoomCountSameDate_CouponId] FOREIGN KEY([CouponId])
REFERENCES [dbo].[Coupons] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[CouponRoomCountSameDate] CHECK CONSTRAINT [FK_CouponRoomCountSameDate_CouponId]
GO
ALTER TABLE [dbo].[CouponRoomCountSameDate]  WITH CHECK ADD  CONSTRAINT [FK_CouponRoomCountSameDate_RoomTypeId] FOREIGN KEY([RoomTypeId])
REFERENCES [dbo].[RoomTypes] ([RoomTypeId])
GO
ALTER TABLE [dbo].[CouponRoomCountSameDate] CHECK CONSTRAINT [FK_CouponRoomCountSameDate_RoomTypeId]
GO
ALTER TABLE [dbo].[CouponRoomTimeSpan]  WITH CHECK ADD  CONSTRAINT [FK_CouponRoomTimeSpan_CouponId] FOREIGN KEY([CouponId])
REFERENCES [dbo].[Coupons] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[CouponRoomTimeSpan] CHECK CONSTRAINT [FK_CouponRoomTimeSpan_CouponId]
GO
ALTER TABLE [dbo].[CouponRoomTimeSpan]  WITH CHECK ADD  CONSTRAINT [FK_CouponRoomTimeSpan_RoomTypeId] FOREIGN KEY([RoomTypeId])
REFERENCES [dbo].[RoomTypes] ([RoomTypeId])
GO
ALTER TABLE [dbo].[CouponRoomTimeSpan] CHECK CONSTRAINT [FK_CouponRoomTimeSpan_RoomTypeId]
GO
ALTER TABLE [dbo].[Coupons]  WITH CHECK ADD  CONSTRAINT [FK_Coupons_TypeId] FOREIGN KEY([TypeId])
REFERENCES [dbo].[CouponTypes] ([Id])
GO
ALTER TABLE [dbo].[Coupons] CHECK CONSTRAINT [FK_Coupons_TypeId]
GO
ALTER TABLE [dbo].[CouponThresholdDiscount]  WITH CHECK ADD  CONSTRAINT [FK_CouponThresholdDiscount_CouponId] FOREIGN KEY([CouponId])
REFERENCES [dbo].[Coupons] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[CouponThresholdDiscount] CHECK CONSTRAINT [FK_CouponThresholdDiscount_CouponId]
GO
ALTER TABLE [dbo].[EmployeeRoles]  WITH CHECK ADD  CONSTRAINT [FK_EmployeeRoles_EmployeeId] FOREIGN KEY([EmployeeId])
REFERENCES [dbo].[Employee] ([Id])
GO
ALTER TABLE [dbo].[EmployeeRoles] CHECK CONSTRAINT [FK_EmployeeRoles_EmployeeId]
GO
ALTER TABLE [dbo].[EmployeeRoles]  WITH CHECK ADD  CONSTRAINT [FK_EmployeeRoles_RoleId] FOREIGN KEY([RoleId])
REFERENCES [dbo].[Roles] ([Id])
GO
ALTER TABLE [dbo].[EmployeeRoles] CHECK CONSTRAINT [FK_EmployeeRoles_RoleId]
GO
ALTER TABLE [dbo].[HallLogs]  WITH CHECK ADD  CONSTRAINT [FK_HallLogs_HallItems] FOREIGN KEY([HallId])
REFERENCES [dbo].[HallItems] ([Id])
GO
ALTER TABLE [dbo].[HallLogs] CHECK CONSTRAINT [FK_HallLogs_HallItems]
GO
ALTER TABLE [dbo].[HallMenus]  WITH CHECK ADD  CONSTRAINT [FK_HallMenus_HallDishCategory] FOREIGN KEY([CategoryId])
REFERENCES [dbo].[HallDishCategory] ([Id])
GO
ALTER TABLE [dbo].[HallMenus] CHECK CONSTRAINT [FK_HallMenus_HallDishCategory]
GO
ALTER TABLE [dbo].[HallMenuSchedules]  WITH CHECK ADD  CONSTRAINT [FK_HallMenuSchedules_HallMenus] FOREIGN KEY([HallMenuId])
REFERENCES [dbo].[HallMenus] ([Id])
GO
ALTER TABLE [dbo].[HallMenuSchedules] CHECK CONSTRAINT [FK_HallMenuSchedules_HallMenus]
GO
ALTER TABLE [dbo].[HallMenuSchedules]  WITH CHECK ADD  CONSTRAINT [FK_HallMenuSchedules_HallOrderItem] FOREIGN KEY([HallOrderItemId])
REFERENCES [dbo].[HallOrderItem] ([Id])
GO
ALTER TABLE [dbo].[HallMenuSchedules] CHECK CONSTRAINT [FK_HallMenuSchedules_HallOrderItem]
GO
ALTER TABLE [dbo].[HallOrderItem]  WITH CHECK ADD  CONSTRAINT [FK_HallOrderItem_HallLogs] FOREIGN KEY([HallLogId])
REFERENCES [dbo].[HallLogs] ([Id])
GO
ALTER TABLE [dbo].[HallOrderItem] CHECK CONSTRAINT [FK_HallOrderItem_HallLogs]
GO
ALTER TABLE [dbo].[Members]  WITH CHECK ADD  CONSTRAINT [FK_Members_LevelId] FOREIGN KEY([LevelId])
REFERENCES [dbo].[MemberLevels] ([Id])
GO
ALTER TABLE [dbo].[Members] CHECK CONSTRAINT [FK_Members_LevelId]
GO
ALTER TABLE [dbo].[Notifications]  WITH CHECK ADD  CONSTRAINT [FK_Notifications_MemberLevels] FOREIGN KEY([LevelId])
REFERENCES [dbo].[MemberLevels] ([Id])
GO
ALTER TABLE [dbo].[Notifications] CHECK CONSTRAINT [FK_Notifications_MemberLevels]
GO
ALTER TABLE [dbo].[Notifications]  WITH CHECK ADD  CONSTRAINT [FK_Notifications_NotificationTypes1] FOREIGN KEY([TypeId])
REFERENCES [dbo].[NotificationTypes] ([Id])
GO
ALTER TABLE [dbo].[Notifications] CHECK CONSTRAINT [FK_Notifications_NotificationTypes1]
GO
ALTER TABLE [dbo].[Reservation]  WITH CHECK ADD  CONSTRAINT [FK_Reservation_Reservation_Status] FOREIGN KEY([Reservation_Status_id])
REFERENCES [dbo].[Reservation_Status] ([Id])
GO
ALTER TABLE [dbo].[Reservation] CHECK CONSTRAINT [FK_Reservation_Reservation_Status]
GO
ALTER TABLE [dbo].[Reservation_Item]  WITH CHECK ADD  CONSTRAINT [FK_Reservation_Item_Reservation] FOREIGN KEY([Reservation_id])
REFERENCES [dbo].[Reservation] ([Id])
GO
ALTER TABLE [dbo].[Reservation_Item] CHECK CONSTRAINT [FK_Reservation_Item_Reservation]
GO
ALTER TABLE [dbo].[Reservation_Item]  WITH CHECK ADD  CONSTRAINT [FK_Reservation_Item_Reservation_Appointment_Time_Period] FOREIGN KEY([Appointment_time_period_id])
REFERENCES [dbo].[Reservation_Appointment_Time_Period] ([Id])
GO
ALTER TABLE [dbo].[Reservation_Item] CHECK CONSTRAINT [FK_Reservation_Item_Reservation_Appointment_Time_Period]
GO
ALTER TABLE [dbo].[Reservation_Item]  WITH CHECK ADD  CONSTRAINT [FK_Reservation_Item_Reservation_Room] FOREIGN KEY([Room_id])
REFERENCES [dbo].[Reservation_Room] ([Id])
GO
ALTER TABLE [dbo].[Reservation_Item] CHECK CONSTRAINT [FK_Reservation_Item_Reservation_Room]
GO
ALTER TABLE [dbo].[Reservation_Item]  WITH CHECK ADD  CONSTRAINT [FK_Reservation_Item_Reservation_Room_Status] FOREIGN KEY([Room_status_id])
REFERENCES [dbo].[Reservation_Room_Status] ([Id])
GO
ALTER TABLE [dbo].[Reservation_Item] CHECK CONSTRAINT [FK_Reservation_Item_Reservation_Room_Status]
GO
ALTER TABLE [dbo].[Reservation_Item]  WITH CHECK ADD  CONSTRAINT [FK_Reservation_Item_Reservation_Service_detail] FOREIGN KEY([Service_detail_id])
REFERENCES [dbo].[Reservation_Service_detail] ([Id])
GO
ALTER TABLE [dbo].[Reservation_Item] CHECK CONSTRAINT [FK_Reservation_Item_Reservation_Service_detail]
GO
ALTER TABLE [dbo].[Reservation_Room]  WITH CHECK ADD  CONSTRAINT [FK_Reservation_Room_Reservation_Room_Type] FOREIGN KEY([Room_Type_id])
REFERENCES [dbo].[Reservation_Room_Type] ([Id])
GO
ALTER TABLE [dbo].[Reservation_Room] CHECK CONSTRAINT [FK_Reservation_Room_Reservation_Room_Type]
GO
ALTER TABLE [dbo].[Reservation_Service_detail]  WITH CHECK ADD  CONSTRAINT [FK_Reservation_Service_detail_Reservation_Services_Type] FOREIGN KEY([Services_Type_id])
REFERENCES [dbo].[Reservation_Services_Type] ([Id])
GO
ALTER TABLE [dbo].[Reservation_Service_detail] CHECK CONSTRAINT [FK_Reservation_Service_detail_Reservation_Services_Type]
GO
ALTER TABLE [dbo].[RestaurantReservations]  WITH CHECK ADD  CONSTRAINT [FK_Reservations_Customers] FOREIGN KEY([Customer_Id])
REFERENCES [dbo].[RestaurantCustomers] ([Id])
GO
ALTER TABLE [dbo].[RestaurantReservations] CHECK CONSTRAINT [FK_Reservations_Customers]
GO
ALTER TABLE [dbo].[RestaurantReservations]  WITH CHECK ADD  CONSTRAINT [FK_Reservations_Periods] FOREIGN KEY([Period_id])
REFERENCES [dbo].[RestaurantPeriods] ([Id])
GO
ALTER TABLE [dbo].[RestaurantReservations] CHECK CONSTRAINT [FK_Reservations_Periods]
GO
ALTER TABLE [dbo].[RestaurantReservations]  WITH CHECK ADD  CONSTRAINT [FK_Reservations_Seats] FOREIGN KEY([Seat_Id])
REFERENCES [dbo].[RestaurantSeats] ([Id])
GO
ALTER TABLE [dbo].[RestaurantReservations] CHECK CONSTRAINT [FK_Reservations_Seats]
GO
ALTER TABLE [dbo].[RestaurantReservations]  WITH CHECK ADD  CONSTRAINT [FK_RestaurantReservations_RestaurantStatuses] FOREIGN KEY([Status_Id])
REFERENCES [dbo].[RestaurantStatuses] ([Id])
GO
ALTER TABLE [dbo].[RestaurantReservations] CHECK CONSTRAINT [FK_RestaurantReservations_RestaurantStatuses]
GO
ALTER TABLE [dbo].[RoleAuthorizations]  WITH CHECK ADD  CONSTRAINT [FK_RoleAuthorizations_AuthorizationId] FOREIGN KEY([AuthorizationId])
REFERENCES [dbo].[Authorizations] ([Id])
GO
ALTER TABLE [dbo].[RoleAuthorizations] CHECK CONSTRAINT [FK_RoleAuthorizations_AuthorizationId]
GO
ALTER TABLE [dbo].[RoleAuthorizations]  WITH CHECK ADD  CONSTRAINT [FK_RoleAuthorizations_RoleId] FOREIGN KEY([RoleId])
REFERENCES [dbo].[Roles] ([Id])
GO
ALTER TABLE [dbo].[RoleAuthorizations] CHECK CONSTRAINT [FK_RoleAuthorizations_RoleId]
GO
ALTER TABLE [dbo].[RoomBookings]  WITH CHECK ADD  CONSTRAINT [FK_RoomBookings_OrderId] FOREIGN KEY([OrderId])
REFERENCES [dbo].[Orders] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RoomBookings] CHECK CONSTRAINT [FK_RoomBookings_OrderId]
GO
ALTER TABLE [dbo].[RoomBookings]  WITH CHECK ADD  CONSTRAINT [FK_RoomBookings_RoomId] FOREIGN KEY([RoomId])
REFERENCES [dbo].[Rooms] ([RoomId])
GO
ALTER TABLE [dbo].[RoomBookings] CHECK CONSTRAINT [FK_RoomBookings_RoomId]
GO
ALTER TABLE [dbo].[Rooms]  WITH CHECK ADD  CONSTRAINT [FK_Rooms_RoomTypeId] FOREIGN KEY([RoomTypeId])
REFERENCES [dbo].[RoomTypes] ([RoomTypeId])
GO
ALTER TABLE [dbo].[Rooms] CHECK CONSTRAINT [FK_Rooms_RoomTypeId]
GO
ALTER TABLE [dbo].[SendedNotifications]  WITH CHECK ADD  CONSTRAINT [FK_SendedNotifications_Members] FOREIGN KEY([MemberId])
REFERENCES [dbo].[Members] ([Id])
GO
ALTER TABLE [dbo].[SendedNotifications] CHECK CONSTRAINT [FK_SendedNotifications_Members]
GO
ALTER TABLE [dbo].[SendedNotifications]  WITH CHECK ADD  CONSTRAINT [FK_SendedNotifications_Notifications] FOREIGN KEY([NotificationId])
REFERENCES [dbo].[Notifications] ([Id])
GO
ALTER TABLE [dbo].[SendedNotifications] CHECK CONSTRAINT [FK_SendedNotifications_Notifications]
GO
ALTER TABLE [HangFire].[JobParameter]  WITH CHECK ADD  CONSTRAINT [FK_HangFire_JobParameter_Job] FOREIGN KEY([JobId])
REFERENCES [HangFire].[Job] ([Id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [HangFire].[JobParameter] CHECK CONSTRAINT [FK_HangFire_JobParameter_Job]
GO
ALTER TABLE [HangFire].[State]  WITH CHECK ADD  CONSTRAINT [FK_HangFire_State_Job] FOREIGN KEY([JobId])
REFERENCES [HangFire].[Job] ([Id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [HangFire].[State] CHECK CONSTRAINT [FK_HangFire_State_Job]
GO
/****** Object:  StoredProcedure [dbo].[usp_房間查詢]    Script Date: 2024/4/24 下午 09:53:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_房間查詢]
	@B_DATE DATETIME, --必填
	@E_DATE DATETIME,--必填
	@SEARCH_TYPE VARCHAR(1),--必填
	@ROOM_ID INT,
	@ROOM_TYPE_ID INT,
	@CAPACITY INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
		WITH DateRangeCTE AS (
		SELECT @B_DATE AS DateColumn
		UNION ALL
		SELECT DATEADD(DAY, 1, DateColumn)
		FROM DateRangeCTE
		WHERE DateColumn < @E_DATE
	)

	SELECT DateColumn AS 日期 INTO #AA 
	FROM DateRangeCTE;
	DECLARE @NUM INT 
	SELECT @NUM=COUNT(*) FROM #AA
	
	SELECT CONVERT(VARCHAR,日期,111) AS DATE,A.RoomId,A.RoomTypeId INTO #CC
	FROM #AA AS D,Rooms AS A


IF @SEARCH_TYPE = '1'
BEGIN
	-- 計算相差的天數
	DECLARE @DayDifference INT = DATEDIFF(DAY, @B_DATE, @E_DATE);

	SELECT CONVERT(VARCHAR,A.DATE,111) AS DATE,A.RoomId,A.RoomTypeId,E.TypeName AS RoomTypeName,E.Capacity,CASE WHEN C.StatusName IS NULL THEN '空房' ELSE C.StatusName END AS StatusName INTO #BB
	FROM #CC AS A
	LEFT JOIN RoomBookings AS B ON(A.RoomId = B.RoomId AND B.BookingStatusId IN('2','3','4') AND A.DATE BETWEEN B.CheckInDate AND DATEADD(DAY, -1, B.CheckOutDate))
	LEFT JOIN RoomStatusSetting AS C ON(B.BookingStatusId = C.StatusId)
	LEFT JOIN RoomTypes AS E ON(A.RoomTypeId = E.RoomTypeId)
	WHERE (A.RoomId = @ROOM_ID OR @ROOM_ID=0)
	AND (A.RoomTypeId = @ROOM_TYPE_ID OR @ROOM_TYPE_ID =0)
	AND (E.Capacity = @CAPACITY OR @CAPACITY =0)
	AND @NUM >0

	--
	SELECT * FROM #BB WHERE RoomId IN(
	SELECT RoomId FROM #BB
	WHERE StatusName ='空房'
	GROUP BY RoomId
	HAVING COUNT(*) >=@DayDifference)
	 DROP TABLE #BB
 END
 ELSE IF @SEARCH_TYPE = '2'
 BEGIN
	SELECT CONVERT(VARCHAR,A.DATE,111) AS DATE,A.RoomId,A.RoomTypeId,E.TypeName AS RoomTypeName,E.Capacity,CASE WHEN C.StatusName IS NULL THEN '空房' ELSE C.StatusName END AS StatusName
	FROM #CC AS A
	LEFT JOIN RoomBookings AS B ON(A.RoomId = B.RoomId AND B.BookingStatusId IN('2','3','4') AND A.DATE BETWEEN B.CheckInDate AND DATEADD(DAY, -1, B.CheckOutDate))
	LEFT JOIN RoomStatusSetting AS C ON(B.BookingStatusId = C.StatusId)
	LEFT JOIN RoomTypes AS E ON(A.RoomTypeId = E.RoomTypeId)
	WHERE (A.RoomId = @ROOM_ID OR @ROOM_ID=0)
	AND (A.RoomTypeId = @ROOM_TYPE_ID OR @ROOM_TYPE_ID =0)
	AND (E.Capacity = @CAPACITY OR @CAPACITY =0)
	AND @NUM >0
 END
 ELSE
 BEGIN
 	SELECT CONVERT(VARCHAR,A.DATE,111) AS DATE,A.RoomId,A.RoomTypeId,E.TypeName AS RoomTypeName,E.Capacity,CASE WHEN C.StatusName IS NULL THEN '空房' ELSE C.StatusName END AS StatusName
	FROM #CC AS A
	LEFT JOIN RoomBookings AS B ON(A.RoomId = B.RoomId AND B.BookingStatusId IN('2','3','4') AND A.DATE BETWEEN B.CheckInDate AND DATEADD(DAY, -1, B.CheckOutDate))
	LEFT JOIN RoomStatusSetting AS C ON(B.BookingStatusId = C.StatusId)
	LEFT JOIN RoomTypes AS E ON(A.RoomTypeId = E.RoomTypeId)
	WHERE (A.RoomId = @ROOM_ID OR @ROOM_ID=0)
	AND (A.RoomTypeId = @ROOM_TYPE_ID OR @ROOM_TYPE_ID =0)
	AND (E.Capacity = @CAPACITY OR @CAPACITY =0)
	AND @NUM >0
	AND B.BookingStatusId='2'
 END
 	 DROP TABLE #AA
END
GO
/****** Object:  StoredProcedure [dbo].[usp_計算訂房價格]    Script Date: 2024/4/24 下午 09:53:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		CHEN
-- Create date: 2024/01/27
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_計算訂房價格] 
@BookingId INT 
AS

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
DECLARE @RoomId INT-- 房間編號
DECLARE @CheckInDate DATETIME  -- 入住日期
DECLARE @CheckOutDate DATETIME -- 退房日期
DECLARE @RoomTypeId INT-- 房型編號
SELECT @RoomId=RoomId,@CheckInDate=CheckInDate,@CheckOutDate=CheckOutDate FROM RoomBookings WHERE BookingId=@BookingId
SELECT @RoomTypeId = RoomTypeId FROM Rooms WHERE RoomId=@RoomId
UPDATE RoomBookings SET OrderPirce = (SELECT SUM(Price)
FROM RoomDaysPrice
WHERE Date >= @CheckInDate AND Date <@CheckOutDate
AND RoomTypeId=@RoomTypeId)
WHERE BookingId=@BookingId;

END
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "HallOrderItem"
            Begin Extent = 
               Top = 121
               Left = 758
               Bottom = 480
               Right = 1182
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "HallLogs"
            Begin Extent = 
               Top = 12
               Left = 76
               Bottom = 416
               Right = 447
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'HallOrderVw'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'HallOrderVw'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Reservation"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 186
               Right = 232
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Reservation_Item"
            Begin Extent = 
               Top = 49
               Left = 562
               Bottom = 263
               Right = 815
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Reservation_TotalPriceView'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Reservation_TotalPriceView'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "A"
            Begin Extent = 
               Top = 7
               Left = 48
               Bottom = 165
               Right = 239
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "B"
            Begin Extent = 
               Top = 7
               Left = 287
               Bottom = 165
               Right = 482
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1176
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1356
         SortOrder = 1416
         GroupBy = 1350
         Filter = 1356
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'RoomDaysPrice'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'RoomDaysPrice'
GO
USE [master]
GO
ALTER DATABASE [dbHotel] SET  READ_WRITE 
GO
