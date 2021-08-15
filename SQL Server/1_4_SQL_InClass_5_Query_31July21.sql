------------- 2021-7-31 DAwSQL Session 5 (Data Functions) --------------------


-- ÖNCEKÝ DERS KONUSUNDAN BÝR SORU ÝLE BAÞLIYORUZ:

-- List customer who bought both 'Electric Bikes' and 'Comfort Bicycles' and 'Children Bicycles' in the same order.


-- önce istenen kategorilerden elektric bikes'a bir bakalým.
select category_id
from production.categories
where category_name = 'Electric Bikes' 

-- category_id products tablosunda olduðundan join için products'a gitmem gerek.
	-- order lara ulaþmam gerektiðinden product_id üzerinden order_items'a gitmem gerekecek.
SELECT B.order_id
FROM production.products A, sales.order_items B
WHERE A.product_id = B.product_id
AND   A.category_id = (

					select category_id
					from production.categories
					where category_name = 'Electric Bikes'
					)

INTERSECT

SELECT B.order_id
FROM production.products A, sales.order_items B
WHERE A.product_id = B.product_id
AND   A.category_id = (

					select category_id
					from production.categories
					where category_name = 'Comfort Bicycles'
					)

INTERSECT

SELECT B.order_id
FROM production.products A, sales.order_items B
WHERE A.product_id = B.product_id
AND   A.category_id = (

					select category_id
					from production.categories
					where category_name = 'Children Bicycles'
					)

-- order_id'lere ulaþtým. bizden customerlarý istiyordu. 
	-- yukardaki query sonucunda gelen order_id leri subquery yapýyorum ve bu id leri sipariþ veren customerlara ulaþýyorum

SELECT	A.customer_id, A.first_name, A.last_name
FROM	sales.customers A, sales.orders B
WHERE	A.customer_id = B.customer_id
AND		B.order_id IN (
						SELECT B.order_id
						FROM production.products A, sales.order_items B
						WHERE A.product_id = B.product_id
						AND   A.category_id = (

											select category_id
											from production.categories
											where category_name = 'Electric Bikes'
											)

						INTERSECT

						SELECT B.order_id
						FROM production.products A, sales.order_items B
						WHERE A.product_id = B.product_id
						AND   A.category_id = (

											select category_id
											from production.categories
											where category_name = 'Comfort Bicycles'
											)

						INTERSECT

						SELECT B.order_id
						FROM production.products A, sales.order_items B
						WHERE A.product_id = B.product_id
						AND   A.category_id = (

											select category_id
											from production.categories
											where category_name = 'Children Bicycles'
											)
											)

--- order_id leri bu þekilde de çekebilirdik.
SELECT B.order_id
FROM production.products A, sales.order_items B
WHERE A.product_id = B.product_id
AND   A.category_id IN (

					select category_id
					from production.categories
					where category_name = 'Electric Bikes' or category_name = 'Children Bicycles' or 
					category_name = 'Comfort Bicycles' 
					)



------------------------		DATE FUNCTIONS		-----------------------

CREATE TABLE t_date_time (
	A_time time,
	A_date date,
	A_smalldatetime smalldatetime,
	A_datetime datetime,
	A_datetime2 datetime2,
	A_datetimeoffset datetimeoffset )


SELECT *
FROM t_date_time

-- INSERT VALUES TO THE TABLE

INSERT t_date_time (A_time, A_date, A_smalldatetime, A_datetime, A_datetime2, A_datetimeoffset)
VALUES
('12:00:00', '2021-07-17', '2021-07-17', '2021-07-17', '2021-07-17', '2021-07-17')

SELECT * 
FROM t_date_time
-- girilen value larý sütunlarýn (tablo oluþturulurken tanýmlanan) date ve datetime tiplerine otomatik olarak çevirdi.


----------------------------------
		-- TIMEFROMPART() FUNCTION

-- The TIMEFROMPARTS() function returns a fully initialized time value. 
	-- It requires five arguments as shown in the following syntax:
		--TIMEFROMPARTS ( hour, minute, seconds, fractions, precision)
		-- EXAMPLE:
		SELECT 
    TIMEFROMPARTS(23, 59, 59, 0, 0) AS Time;
		-- EXAMPLE:
		SELECT 
    TIMEFROMPARTS(06, 30, 15, 5, 2) Time;
	-- sondaki precision'ýn 2 verildiðinde nasýl gözüktüðüne dikkat et.(saniye fraction'u iki basamaklý gösteriyor)
	-- 2 verirsek saniyenin 100 de 1'ine kadar kesinlik saðlarýz. 3 verirsek 1000 de biri kadar kesinlik saðlarýz.

-- Bizim örneðimize dönersek:
INSERT t_date_time (A_time) VALUES (TIMEFROMPARTS(12,0,0,0,0));
-- saat 12, dakika ve saniye 0 girildi. precision 0 verildiðinde nasýl gözüktüðüne dikkat et!

SELECT * 
FROM t_date_time

INSERT INTO t_date_time (A_date) VALUES (DATEFROMPARTS(2021,05,17));

SELECT * 
FROM t_date_time


-- FORMATI DEÐÝÞTÝRMEK ÝÇÝN:
SELECT CONVERT(varchar, GETDATE(), 6)
-- Burada 6, formatý belirliyor.

SELECT GETDATE()


INSERT INTO t_date_time(A_datetime) VALUES(DATETIMEFROMPARTS(2021,05,17,020,0,0,0));


INSERT INTO t_date_time (A_datetimeoffset) VALUES (DATETIMEOFFSETFROMPARTS(2021,05,17, 20,0,0,0, 2,0,0));


-- DATENAME() : DATENAME() function returns a string, NVARCHAR type, that represents a specified date part e.g., 
	--year, month and day of a specified date

	--SYNTAX: DATENAME(date_part,input_date)
	-- parametreler için : https://www.sqlservertutorial.net/sql-server-date-functions/sql-server-datename-function/

-- DATEPART() fonksiyonu da benzerdir.
SELECT
    DATEPART(year, '2018-05-10') [datepart], 
    DATENAME(year, '2018-05-10') [datename],
	DATENAME(month, '2018-05-10') [monthname],
	DATEPART(month, '2018-05-10') [monthname],
	DATENAME(day, '2018-05-10') [dayname];


SELECT A_time,
		DATENAME(D, A_date) [DAY] -- 1.paramtre:hangi parçayý istiyorsun, 2.parametre:nerden istiyorsun?
from t_date_time


SELECT	A_date,
		DATENAME(DW, A_date) [WeekDay],
		DAY (A_date) [DAY2],
		MONTH(A_date) [MONTH],
		YEAR (A_date) [YEAR],
		A_time,
		DATEPART (NANOSECOND, A_time),
		DATEPART (MONTH, A_date)
FROM	t_date_time


-- DATEDIFF () : Returns a value of integer indicating the difference between the start_date and end_date,
	-- with the unit specified by date_part
--iki tarih arasýndaki farký getiriyor.

SELECT A_date,
		A_datetime,
		DATEDIFF (DAY, A_date, A_datetime) Date_diff -- iki tarih arasýndaki DAY farkýný getir.
FROM t_date_time
-- Biri null ise deðer getirmiyor, ikisi birden dolu ise getiriyor.


-- shipdate ile order date arasýnda kaç gün fark var?

SELECT DATEDIFF (DAY, order_date, shipped_date), order_date, shipped_date
from sales.orders
where order_id = 1
-- Dikkat!! sonraki tarihi (shipped_date) önceki tarihten (order_date) sonra yazdýk

SELECT DATEDIFF (DAY, order_date, shipped_date), order_date, shipped_date,
		DATEDIFF (DAY, shipped_date, order_date)
from sales.orders
where order_id = 1
-- ters yazýnca ikinci DATEDIFF eksi çýktý..



-- DATEADD : The DATEADD() function adds a number to a specified date part of an input date and returns the modified value.
	--tarihin belirtilen kýsmýna, belirtilen miktarda (yýl, ay, gün) ekliyor

SELECT DATEADD (D, 5, order_date), order_date --order_date'e 5 gün ekle dedik.
FROM sales.orders
WHERE order_id = 1

SELECT DATEADD (YEAR, 5, order_date), DATEADD(DAY, 5, order_date), order_date
FROM sales.orders
WHERE order_id = 1

SELECT DATEADD (YEAR, 5, order_date), 
		DATEADD(DAY, 5, order_date), 
		DATEADD(DAY, -5, order_date), order_date -- eksi ile çýkartabiliriz de.
FROM sales.orders
WHERE order_id = 1


--- EOMONTH: ayýn son gününü getiriyor

-- order_date lerin þubat aylarý kaç çekiyor bakalým:
SELECT EOMONTH(order_date), order_date
FROM sales.orders
WHERE MONTH(order_date) = '02' 


--- ISDATE(): accepts an argument and returns 1 if that argument is a valid DATE, TIME, or DATETIME value; 
	-- otherwise, it returns 0.

SELECT ISDATE(CAST (order_date AS nvarchar)), order_date
FROM sales.orders
-- Burada ISDATE, orde_date'in içerisinin varchar olup olmadýðýný denetler. 1 True, 0 False


SELECT	ISDATE( CAST (order_date AS nvarchar)), order_date
FROM	sales.orders
SELECT ISDATE ('1234568779')
SELECT ISDATE ('WHERE')
SELECT ISDATE ('2021-12-02')
SELECT ISDATE ('2021.12.02')



--- GETDATE() : The GETDATE() function returns the current system timestamp as a DATETIME value without the database time zone offset
	-- saat dilimi farkýna bakmaksýzýn bilgisayar sisteminizdeki o an ki zamaný getirir.
SELECT GETDATE()

SELECT CURRENT_TIMESTAMP

SELECT GETUTCDATE()  -- UTC time'ý getiriyor.(Zulu time'ý)
-- Aralarýnda önemli bir fark yok.


-- ÖRNEÐÝMÝZE DÖNELÝM:

INSERT t_date_time
VALUES (GETDATE(), GETDATE(), GETDATE(), GETDATE(), GETDATE(), GETDATE())
-- SON SATIR VALUE'SU OLARAK HER SÜTUNDA BUGÜNÜN DATE'ÝNÝ GETÝRDÝ. 
	-- TABÝ KÝ HER BÝR SÜTUNUN KENDÝ FORMATLARINDA GETÝRDÝ.

SELECT *
FROM t_date_time



---- SORU: Create a new column that contains labels of the shipping speed of products.
	-- 1. If the product has not been shipped yet, it will be marked as "Not Shipped"
	-- 2. If the product was shipped on the day of order, it will be labeled as "Fast"
	-- 3. If the product is shipped no later than two days after the order day, it will be labeled as "Normal"
	-- 4. If the product was shipped three or more days after the day of order, it will be labeled as "Slow" 

-- 1. þart için: order status 4 deðilse kargolanmamýþ demek. 4 ise kargolanmýþ demek.
-- diðer þartlar için ise order_date ile shipped_date arasýndaki farka bakacaðýz.
SELECT *, 
		CASE WHEN order_status <> 4 THEN 'Not Shipped'
			WHEN order_date = shipped_date THEN 'Fast' -- DATEDIFF ( DAY, order_date, shipped_date) = 0 THAN 'Fast' dersek de gün farkýný almýþ olacaktýk.
			WHEN DATEDIFF (DAY, order_date, shipped_date) BETWEEN 1 AND 2 THEN 'Normal'
			ELSE 'Slow' -- geriye kalan tüm durumlarý Slow olarak ata
		END AS ORDER_LABEL
FROM sales.orders

-- bir sütun daha ekleyelim ve DATEDIFF i de getirsin, aradaki gün sayýsýný da görelim.
SELECT *, 
		CASE WHEN order_status <> 4 THEN 'Not Shipped'
			WHEN order_date = shipped_date THEN 'Fast' -- DATEDIFF ( DAY, order_date, shipped_date) = 0 THAN 'Fast' dersek de gün farkýný almýþ olacaktýk.
			WHEN DATEDIFF (DAY, order_date, shipped_date) BETWEEN 1 AND 2 THEN 'Normal'
			ELSE 'Slow' -- geriye kalan tüm durumlarý Slow olarak ata
		END AS ORDER_LABEL,
		DATEDIFF(DAY, order_date, shipped_date) Date_diff
FROM sales.orders
ORDER BY Date_diff



-- SORU: Write a query returns orders that are shipped more than two days after the ordered date.

SELECT *, DATEDIFF ( DAY, order_date, shipped_date) DATE_DIFF
FROM sales.orders
WHERE DATEDIFF(DAY, order_date, shipped_date) > 2



-- SORU: Write o query that returns the number distributions of the orders in the previous query result,
	-- according to the days of the week.

	-- sipariþ aldýktan sonra 2 günden geç kargolanmýþsa buna geç kargolanmýþ diyoruz.
		--burada hangi günler sipariþ alýndýðýnda geç kargolanmýþ oluyor onu bulmaya çalýþýyoruz.
		-- gecikmenin sebebi ne onu bulmak için bir çalýþma yaptýðýmýzý hayal edelim.

		--DATENAME'i kullanacaðýz.. ve CASE() fonksiyonu kullanacaðýz.

SELECT SUM(CASE WHEN DATENAME (DW, order_date) = 'Monday' THEN 1 ELSE 0 END) AS MONDAY, 
-- order_date varchar idi o yüzden týrnak içine yazdým. haftanýn gününü kýyaslayacaðým için DATENAME fonksiyonunda DW (Weekday) kullandým.
		SUM(CASE WHEN DATENAME (DW, order_date) = 'Tuesday' THEN 1 ELSE 0 END) AS TUESDAY, 
		SUM(CASE WHEN DATENAME (DW, order_date) = 'Wednesday' THEN 1 ELSE 0 END) AS WEDNESDAY,
		SUM(CASE WHEN DATENAME (DW, order_date) = 'Thursday' THEN 1 ELSE 0 END) AS THURSDAY,
		SUM(CASE WHEN DATENAME (DW, order_date) = 'Friday' THEN 1 ELSE 0 END) AS FRIDAY,
		SUM(CASE WHEN DATENAME (DW, order_date) = 'Saturday' THEN 1 ELSE 0 END) AS SATURDAY,
		SUM(CASE WHEN DATENAME (DW, order_date) = 'Sunday' THEN 1 ELSE 0 END) AS SUNDAY
FROM sales.orders
WHERE DATEDIFF(DAY, order_date, shipped_date) > 2

-- PIVOT table kullanarak da yapýlabilir. Owen hoca bunu ödev olarak býraktý!!


-- SORU : Write a query that returns the order numbers of the states by months.

	-- states --> sales.custormers tablosunda
SELECT A.state, MONTH(B.order_date) MONTHS, -- order tarihinin aylarýný seçmek için..
				COUNT(DISTINCT order_id) NUM_OF_ORDERS -- bu aylara ait farklý sipariþleri bulmak için..
FROM sales.customers A, sales.orders B
WHERE A.customer_id = B.customer_id 
GROUP BY A.state, MONTH(B.order_date)-- state'leri aylara göre grupladým.
ORDER BY 1 --state lere göre sýraladýk.
-- sorgu cevabýný ay ay getirdik. yani 3 yýlýn aylarý iþin içine katýlmýþ. yýl yýl bir ayýrým yok.

-- YIL boyutunu da ekleyelim..
SELECT A.state, YEAR(B.order_date) YEARS, MONTH(B.order_date) MONTHS, -- order tarihinin aylarýný seçmek için..
				COUNT(DISTINCT order_id) NUM_OF_ORDERS -- bu aylara ait farklý sipariþleri bulmak için..
FROM sales.customers A, sales.orders B
WHERE A.customer_id = B.customer_id 
GROUP BY A.state, YEAR(B.order_date), MONTH(B.order_date)-- state'leri aylara göre grupladým.
ORDER BY state, YEARS, MONTHS


-- database'de month ve year bilgileri zaten sýralý olduðu için order by satýrýnda years ve months almasak da onlarý sýraya koyuyor. ama yine de yazmakta fayda var.
SELECT A.state, YEAR(B.order_date) YEARS, MONTH(B.order_date) MONTHS, -- order tarihinin aylarýný seçmek için..
				COUNT(DISTINCT order_id) NUM_OF_ORDERS -- bu aylara ait farklý sipariþleri bulmak için..
FROM sales.customers A, sales.orders B
WHERE A.customer_id = B.customer_id 
GROUP BY A.state, YEAR(B.order_date), MONTH(B.order_date)-- state'leri aylara göre grupladým.
ORDER BY state