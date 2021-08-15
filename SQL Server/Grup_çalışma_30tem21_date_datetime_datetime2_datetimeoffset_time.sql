
----------------- CURRENT TIME--------------
SELECT 
    GETDATE() current_date_time;

----------------- SAMPLE DATE--------------------


-- LOOK UP THE DATE FORMAT
SELECT    
	order_id, 
	customer_id, 
	order_status, 
	order_date
FROM    
	sales.orders
WHERE order_date < '2016-01-05'
ORDER BY 
	order_date DESC;

------ CREATE A NEW TABLE
CREATE TABLE sales.list_prices 
	(product_id INT NOT NULL,
     valid_from DATE NOT NULL,
     valid_to DATE NOT NULL,
     amount DEC (10, 2) NOT NULL,
     PRIMARY KEY (product_id,
				  valid_from,
				  valid_to),
     FOREIGN KEY (product_id) 
     REFERENCES production.products (product_id)
	 );

INSERT INTO sales.list_prices (product_id,
							   valid_from,
							   valid_to,
							   amount)
VALUES (1,
       '2019-01-01',
       '2019-12-31',
        400);

SELECT *
FROM sales.list_prices 



-------------------- DATETIME--------------------


DROP TABLE IF EXISTS production.product_colors

CREATE TABLE production.product_colors (color_id INT PRIMARY KEY IDENTITY,
										color_name VARCHAR (50) NOT NULL,
										created_at DATETIME2);
SELECT *
FROM production.product_colors

INSERT INTO production.product_colors (color_name, created_at)
VALUES
    ('Red', GETDATE()); 

SELECT *
FROM production.product_colors

INSERT INTO production.product_colors (color_name, created_at)
VALUES
    ('Green', '2018-06-23 07:30:20');

SELECT *
FROM production.product_colors

ALTER TABLE production.product_colors 
ADD CONSTRAINT df_current_time 
DEFAULT CURRENT_TIMESTAMP FOR created_at;
-- created_at sütununa current time'ý default olarak ekledik.  
-- BU KOD SAYESÝNDE ARTIK INSERT INTO ÝLE GÝRÝLEN VALUE'A KARÞILIK "created_at" SÜTUNUNA OTOMATÝK OLARAK CURRENT_TIME'I EKLEYECEK

SELECT *
FROM production.product_colors

INSERT INTO production.product_colors (color_name)
VALUES
    ('Blue');

SELECT *
FROM production.product_colors


-------------------TIMEOFFSET--------------------

DROP TABLE IF EXISTS  messages
CREATE TABLE messages(
    id         INT PRIMARY KEY IDENTITY, 
    message    VARCHAR(255) NOT NULL, 
    created_at DATETIMEOFFSET NOT NULL
);

SELECT *
FROM messages

INSERT INTO messages(message,created_at)
VALUES('DATETIMEOFFSET demo',
        CAST('2019-02-28 01:45:00.0000000 -08:00' AS DATETIMEOFFSET));

SELECT *
FROM messages

SELECT 
    id, 
    message, 
	created_at AS 'Pacific Standard Time',
    created_at AT TIME ZONE 'SE Asia Standard Time' AS 'SE Asia Standard Time'
FROM 
    messages;

-- time zone list
-- https://dzone.com/articles/dates-and-times-in-sql-server-at-time-zone

-- code gets the time zone list
SELECT 
		name,
		current_utc_offset
FROM sys.time_zone_info
WHERE is_currently_dst = 1;


-------------------- TIME -----------------

CREATE TABLE sales.visits (    visit_id INT PRIMARY KEY IDENTITY,    customer_name VARCHAR (50) NOT NULL,    phone VARCHAR (25),    store_id INT NOT NULL,    visit_on DATE NOT NULL,    start_at TIME (0) NOT NULL,    end_at TIME (0) NOT NULL,    FOREIGN KEY (store_id) REFERENCES sales.stores (store_id));INSERT INTO sales.visits (    customer_name,    phone,    store_id,    visit_on,    start_at,    end_at)VALUES    (        'John Doe',        '(408)-993-3853',        1,        '2018-06-23',        '09:10:00',        '09:30:00'    );select * from sales.visits


SELECT *
from messages

SELECT created_at, CONVERT(char(10), created_at, 103) as '103 format'
FROM messages

SELECT created_at, CONVERT(char(10), created_at, 103) as '103 Format', 
				DATENAME(DW, created_at) + ' ' + DATENAME(DD, created_at)
				+ ' ' + DATENAME(MM, created_at) + ' ' + DATENAME(YY, created_at) as 'CHANGED FORMAT'		
FROM messages

