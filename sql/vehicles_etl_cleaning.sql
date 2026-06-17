CREATE TABLE vehicles_clean (
	id BIGINT NOT NULL,
	region NVARCHAR(50),
	price BIGINT,
	year INT,
	manufacturer NVARCHAR(50),
	model NVARCHAR(MAX),
	condition NVARCHAR(50),
	cylinders NVARCHAR(50),
	fuel NVARCHAR(50),
	odometer INT,
	title_status NVARCHAR(50),
	transmission NVARCHAR(50),
	VIN NVARCHAR(50),
	drive NVARCHAR(50),
	size NVARCHAR(50),
	type NVARCHAR(50),
	paint_color NVARCHAR(50),
	state NVARCHAR(50),
	latitude FLOAT,
	longitude FLOAT,
	posting_date DATETIME
);
GO

INSERT INTO vehicles_clean (
    id, region, price, year, manufacturer, model,
    condition, cylinders, fuel, odometer,
    title_status, transmission, VIN, drive, size,
    type, paint_color, state, latitude, longitude, posting_date
)
SELECT
id,
region,

CASE WHEN price <= 0 THEN NULL
		ELSE price
END AS price,

year,
manufacturer,

CASE WHEN model NOT LIKE '%[A-Za-z0-9]%' THEN NULL
	 WHEN LEN(TRIM(model)) <= 1 THEN NULL
	 ELSE model
END AS model,

condition,
cylinders,
fuel,
odometer,
title_status,
transmission,
VIN,
drive,
size,
type,
paint_color,
state,
lat AS latitude,
long AS longitude,
posting_date
FROM vehicles