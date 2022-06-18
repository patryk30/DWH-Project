USE master
GO

if exists(select * from sysdatabases where name = 'ErgastF1_DWH')
	drop database ErgastF1_DWH
GO

CREATE DATABASE ErgastF1_DWH
GO

USE ErgastF1_DWH
GO


-- Fact table

--mozna dodac jakies statystyki z tabeli lap_times
--ewentualnie dodalbym q1,q2,q3 z tabeli qualifying
-- mozna dodac jeszcze contructor_points
CREATE TABLE [dbo].[ResultsFact] (
  ResultId int NOT NULL,
  RaceId int NOT NULL,
  DriverId int NOT NULL,
  ConstructorId int NOT NULL,
  Number int NOT NULL, -- default null - trzeba bedzie kombinowac w etl
  Grid int NOT NULL,
  Position int NOT NULL, -- default null - trzeba bedzie kombinowac w etl
--  "positionText" varchar(255) NOT NULL DEFAULT '',
--  PositionOrder int NOT NULL DEFAULT '0',
  DriverPoints float NOT NULL,
  Laps int NOT NULL, --Number of completed laps  
  [Time] varchar(255) NOT NULL, -- default null - trzeba bedzie kombinowac w etl
  Milliseconds int NOT NULL, -- default null - trzeba bedzie kombinowac w etl
  FastestLap int NOT NULL, -- default null - trzeba bedzie kombinowac w etl
  [Rank] int NOT NULL,
  FastestLapTime varchar(255) NOT NULL, -- default null - trzeba bedzie kombinowac w etl
  FastestLapSpeed varchar(255) NOT NULL, -- default null - trzeba bedzie kombinowac w etl
  DateId int NOT NULL,
  Qual1_Time varchar(255) NOT NULL,
  Qual2_Time varchar(255) NOT NULL,
  Qual3_Time varchar(255) NOT NULL,
  QualPosition int NOT NULL,
  [Status] varchar(255) NOT NULL,
  Temperature decimal(18,1) NOT NULL,				-- Temperature in degrees Celcius.
  Wind_speed decimal(18,1) NOT NULL,				-- Wind speed in meters/second.
  Wind_direction decimal(18,1) NOT NULL,	-- Wind direction degrees. 0 = North, 90 = East, 180 = South, 270 = West.
  -- Weather_type_id: OpenWeatherMaps weather ID. Matching descriptions can be found in the OpenWeatherMap documentation.
  Cloudiness decimal(18,1) NOT NULL,				-- In percentages.
  Humidity decimal(18,2) NOT NULL,				-- In percentages.
  Air_pressure decimal(18,1) NOT NULL,			-- Atmospheric pressure in hPa.
  Precipitation decimal(18,2) NOT NULL,
  PRIMARY KEY (ResultId)
  );

	--CREATE TABLE [dbo].[ResultsFact] (
	--  ResultId int NOT NULL,
	--  RaceId int NOT NULL,
	--  DriverId int NOT NULL,
	--  ConstructorId int NOT NULL,
	--  Number int NOT NULL, -- default null - trzeba bedzie kombinowac w etl
	--  Grid int NOT NULL,
	--  Position int NOT NULL, -- default null - trzeba bedzie kombinowac w etl
	----  "positionText" varchar(255) NOT NULL DEFAULT '',
	----  PositionOrder int NOT NULL DEFAULT '0',
	--  DriverPoints float NOT NULL,
	--  Laps int NOT NULL, --Number of completed laps  
	--  [Time] varchar(255) NOT NULL, -- default null - trzeba bedzie kombinowac w etl
	--  Milliseconds int NOT NULL, -- default null - trzeba bedzie kombinowac w etl
	--  FastestLap int NOT NULL, -- default null - trzeba bedzie kombinowac w etl
	--  [Rank] int NOT NULL,
	--  FastestLapTime varchar(255) NOT NULL, -- default null - trzeba bedzie kombinowac w etl
	--  FastestLapSpeed varchar(255) NOT NULL, -- default null - trzeba bedzie kombinowac w etl
	--  DateId int NOT NULL,
	--  Qual1_Time varchar(255) NOT NULL,
	--  Qual2_Time varchar(255) NOT NULL,
	--  Qual3_Time varchar(255) NOT NULL,
	--  QualPosition int NOT NULL,
	--  [Status] varchar(255) NOT NULL,
	--  Temperature int NOT NULL,				-- Temperature in degrees Celcius.
	--  Wind_speed int NOT NULL,				-- Wind speed in meters/second.
	--  Wind_direction varchar(15) NOT NULL,	-- Wind direction degrees. 0 = North, 90 = East, 180 = South, 270 = West.
	--  -- Weather_type_id: OpenWeatherMaps weather ID. Matching descriptions can be found in the OpenWeatherMap documentation.
	--  Cloudiness int NOT NULL,				-- In percentages.
	--  Humidity int NOT NULL,				-- In percentages.
	--  Air_pressure int NOT NULL,			-- Atmospheric pressure in hPa.
	--  Rain_last_hour_in_mm INT NOT NULL,		-- Rainfall in millimeters in the last hour. 
	--  Rain_last_3_hours_in_mm INT NOT NULL,		-- Rainfall in millimeters in the last 3 hours.
	--  Snow_last_hour_in_mm INT NOT NULL,		-- Snowfall in millimeters in the last hour.,
	--  Snow_last_3_hours_in_mm INT NOT NULL,		-- Snowfall in millimeters in the last 3 hours.
	--  PRIMARY KEY (ResultId)
	--);


-- dimension tables

CREATE TABLE [dbo].[ConstructorsDimension] (  
  ConstructorId int NOT NULL,
  ConstructorRef varchar(255) NOT NULL,
  [Name] varchar(255) NOT NULL,
  Nationality varchar(255) NOT NULL,
--  "url" varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (ConstructorId)
);


--join races and circuits table
CREATE TABLE [dbo].[RacesDimension] (
  RaceId int NOT NULL,
--  Year int NOT NULL DEFAULT '0',
  [Round] int NOT NULL,
  CircuitId int NOT NULL,
  [RaceName] varchar(255) NOT NULL,
  RaceDateId int NOT NULL, --dodana data do tabeli faktow
  RaceTime time NOT NULL,
--  "url" varchar(255) DEFAULT NULL,
--  "fp1_date" date DEFAULT NULL,
--  "fp1_time" time DEFAULT NULL,
--  "fp2_date" date DEFAULT NULL,
--  "fp2_time" time DEFAULT NULL,
--  "fp3_date" date DEFAULT NULL,
--  "fp3_time" time DEFAULT NULL,
--  "quali_date" date DEFAULT NULL,
--  "quali_time" time DEFAULT NULL,
--  SprintDateId int NOT NULL, 
--  SprintTime time NOT NULL,
-- ------   
--  "circuitId" int NOT NULL IDENTITY(1, 1), 
-- "circuitRef" varchar(255) NOT NULL DEFAULT '',  --do przemyslenia - i tak jest nazwa wyscigu
  CircuitName varchar(255) NOT NULL,
  [Location] varchar(255) NOT NULL,
  Country varchar(255) NOT NULL,
  Lattitude float NOT NULL,
  Longitude float NOT NULL,
  Altitude int NOT NULL,
--  "url" varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (RaceId),
--  UNIQUE ("url")
);


--CREATE TABLE [dbo].[StatusDimension] (
--  StatusId int NOT NULL IDENTITY(1, 1),
--  [Status] varchar(255) NOT NULL DEFAULT '',
--  PRIMARY KEY (StatusId)
--);


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DateDimension](
	[DateID] [int] NOT NULL,
	[Date] [date] NOT NULL,
	[Day] [tinyint] NOT NULL,
	[DaySuffix] [char](2) NOT NULL,
	[Weekday] [tinyint] NOT NULL,
	[WeekDayName] [varchar](10) NOT NULL,
	[IsWeekend] [bit] NOT NULL,
	[IsHoliday] [bit] NOT NULL,
	[HolidayText] [varchar](64) SPARSE  NULL,
	[DOWInMonth] [tinyint] NOT NULL,
	[DayOfYear] [smallint] NOT NULL,
	[WeekOfMonth] [tinyint] NOT NULL,
	[WeekOfYear] [tinyint] NOT NULL,
	[ISOWeekOfYear] [tinyint] NOT NULL,
	[Month] [tinyint] NOT NULL,
	[MonthName] [varchar](10) NOT NULL,
	[Quarter] [tinyint] NOT NULL,
	[QuarterName] [varchar](6) NOT NULL,
	[Year] [int] NOT NULL,
	[MMYYYY] [char](6) NOT NULL,
	[MonthYear] [char](7) NOT NULL,
--	[FirstDayOfMonth] [date] NOT NULL,
--	[LastDayOfMonth] [date] NOT NULL,
--	[FirstDayOfQuarter] [date] NOT NULL,
--	[LastDayOfQuarter] [date] NOT NULL,
--	[FirstDayOfYear] [date] NOT NULL,
--	[LastDayOfYear] [date] NOT NULL,
--	[FirstDayOfNextMonth] [date] NOT NULL,
--	[FirstDayOfNextYear] [date] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[DateID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


CREATE TYPE [dbo].[Flag] FROM [char](3) NOT NULL
GO

CREATE TABLE [dbo].[DriversDimension] (
  DriverId int IDENTITY(1,1) NOT NULL,
  OriginalDriverId int not null,
  DriverRef varchar(255) NOT NULL,
  Number int NOT NULL,
  Code varchar(10) NOT NULL,
  Forename varchar(255) NOT NULL,
  Surname varchar(255) NOT NULL,
  FullName nvarchar(80) not null,
  BirthDate int NOT NULL,
  Nationality varchar(255) NOT NULL,
  ValidFrom datetime not null,
  ValidTo datetime not null,
  Active [dbo].[Flag] not null
--  "url" varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (DriverId)
--  UNIQUE ("url")
);

 
--CREATE TABLE [dbo].[WeatherDimension] (  
--  WeatherId int NOT NULL IDENTITY(1, 1),
--  -- Round: A number that indicates which round in the current Formula 1 World Championship season this race is.
--  -- Timestamp_W: An epoch unix formatted timestamp. Google for unix timestamp for documentation on this type of timestamp.
--  Temperature int NOT NULL,				-- Temperature in degrees Celcius.
--  Wind_speed int NOT NULL,				-- Wind speed in meters/second.
--  Wind_direction varchar(15) NOT NULL,	-- Wind direction degrees. 0 = North, 90 = East, 180 = South, 270 = West.
-- -- Weather_type_id: OpenWeatherMaps weather ID. Matching descriptions can be found in the OpenWeatherMap documentation.
--  Cloudiness int NOT NULL,				-- In percentages.
--  Humidity int NOT NULL,				-- In percentages.
--  Air_pressure int NOT NULL,			-- Atmospheric pressure in hPa.
--  Rain_last_hour_in_mm INT NULL,		-- Rainfall in millimeters in the last hour. 
--  Rain_last_3_hours_in_mm INT NULL,		-- Rainfall in millimeters in the last 3 hours.
--  Snow_last_hour_in_mm INT NULL,		-- Snowfall in millimeters in the last hour.,
--  Snow_last_3_hours_in_mm INT NULL,		-- Snowfall in millimeters in the last 3 hours.
--  PRIMARY KEY (WeatherId)
--);


ALTER TABLE [dbo].[ResultsFact]  WITH CHECK ADD FOREIGN KEY([DriverId])
REFERENCES [dbo].[DriversDimension] ([DriverId])
GO

--ALTER TABLE [dbo].[ResultsFact]  WITH CHECK ADD FOREIGN KEY([WeatherId])
--REFERENCES [dbo].[WeatherDimension] ([WeatherId])
--GO

--ALTER TABLE [dbo].[ResultsFact]  WITH CHECK ADD FOREIGN KEY([StatusId])
--REFERENCES [dbo].[StatusDimension] ([StatusId])
--GO

ALTER TABLE [dbo].[ResultsFact]  WITH CHECK ADD FOREIGN KEY([RaceId])
REFERENCES [dbo].[RacesDimension] ([RaceId])
GO

ALTER TABLE [dbo].[ResultsFact]  WITH CHECK ADD FOREIGN KEY([ConstructorId])
REFERENCES [dbo].[ConstructorsDimension] ([ConstructorId])
GO

ALTER TABLE [dbo].[ResultsFact]  WITH CHECK ADD FOREIGN KEY([DateId])
REFERENCES [dbo].[DateDimension] ([DateID])
GO

ALTER TABLE [dbo].[DriversDimension]  WITH CHECK ADD FOREIGN KEY([BirthDate])
REFERENCES [dbo].[DateDimension] ([DateID])
GO

ALTER TABLE [dbo].[RacesDimension]  WITH CHECK ADD FOREIGN KEY([RaceDateId])
REFERENCES [dbo].[DateDimension] ([DateID])
GO

ALTER TABLE [dbo].[RacesDimension]  WITH CHECK ADD FOREIGN KEY([SprintDateId])
REFERENCES [dbo].[DateDimension] ([DateID])
GO


-- Korekty zmiennych:
-- Weather(Wind_direction) ---> varchar(15) NOT NULL ---> Wind direction degrees. 0 = North, 90 = East, 180 = South, 270 = West
-- ResultsFact(Time,FastestLapTime) ---> change type from varchar to time 
-- ResultsFact(Qual1_Time,Qual2_Time,Qual3_Time) ---> change type from varchar to time 
-- RacesDimension(RaceDateId,SprintDateId) ---> change type from date into int, foreign key to DateDimension
-- DriversDimension(BirthDate) ---> change type from date to int, foreign key to DateDimension
-- ResultsFacts --- add DateId as attribute (from RacesDimension table) 





-- Staging table
CREATE TABLE [dbo].[ResultsFactStaging] (
  ResultId int NOT NULL,
  RaceId int NOT NULL,
  DriverId int NOT NULL,
  ConstructorId int NOT NULL,
  Number int NULL, -- default null - trzeba bedzie kombinowac w etl
  Grid int NOT NULL,
  Position int NULL, -- default null - trzeba bedzie kombinowac w etl
--  "positionText" varchar(255) NOT NULL DEFAULT '',
--  PositionOrder int NOT NULL DEFAULT '0',
  DriverPoints float NULL,
  Laps int NULL, --Number of completed laps  
  [Time] varchar(255) NULL, -- default null - trzeba bedzie kombinowac w etl
  Milliseconds int NULL, -- default null - trzeba bedzie kombinowac w etl
  FastestLap int NULL, -- default null - trzeba bedzie kombinowac w etl
  [Rank] int NULL,
  FastestLapTime varchar(255)  NULL, -- default null - trzeba bedzie kombinowac w etl
  FastestLapSpeed varchar(255)  NULL, -- default null - trzeba bedzie kombinowac w etl
  Date [date]  NULL,
  Qual1_Time varchar(255)  NULL,
  Qual2_Time varchar(255)  NULL,
  Qual3_Time varchar(255)  NULL,
  QualPosition int  NULL,
  [Status] varchar(255)  NULL,
  Temperature varchar(50) NULL,				-- Temperature in degrees Celcius.
  Wind_speed varchar(50) NULL,				-- Wind speed in meters/second.
  Wind_direction varchar(50) NULL,	-- Wind direction degrees. 0 = North, 90 = East, 180 = South, 270 = West.
  -- Weather_type_id: OpenWeatherMaps weather ID. Matching descriptions can be found in the OpenWeatherMap documentation.
  Cloudiness varchar(50) NULL,				-- In percentages.
  Humidity varchar(50) NULL,				-- In percentages.
  Air_pressure varchar(50) NULL,			-- Atmospheric pressure in hPa.
  Precipitation varchar(50) NULL
--  Rain_last_hour_in_mm INT NOT NULL,		-- Rainfall in millimeters in the last hour. 
--  Rain_last_3_hours_in_mm INT NOT NULL,		-- Rainfall in millimeters in the last 3 hours.
--  Snow_last_hour_in_mm INT NOT NULL,		-- Snowfall in millimeters in the last hour.,
-- Snow_last_3_hours_in_mm INT NOT NULL,		-- Snowfall in millimeters in the last 3 hours.
);