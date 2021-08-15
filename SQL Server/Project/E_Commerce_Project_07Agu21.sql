--DAwSQL Session -8 

--E-Commerce Project Solution

-- market_fact alanında FOREIGN KEY ataması:
	-- tablom zaten var olduğu için ALTER TABLE ile yapacağım

select cust_id
from market_fact --18287 / 8399

select ord_id
from orders_dimen  --5506 / 5506

select Prod_id
from prod_dimen --17 / 17

select ship_id
from shipping_dimen --7701 / 7701


ALTER TABLE market_fact
ADD CONSTRAINT fk_ord_id FOREIGN KEY (Ord_id) REFERENCES orders_dimen(Ord_id)
-- Şu hatayı aldım: Column 'orders_dimen.Ord_id' is not the same length or scale as referencing column 'market_fact.Ord_id' in foreign key 'fk_ord_id'.

ALTER TABLE market_fact
ADD CONSTRAINT fk_prod_id FOREIGN KEY (Prod_id) REFERENCES prod_dimen(Prod_id)
-- Bu alana Foreign key ataması yapabildim.

ALTER TABLE market_fact
ADD CONSTRAINT fk_ship_id FOREIGN KEY (Ship_id) REFERENCES shipping_dimen(Ship_id)
-- 

ALTER TABLE market_fact
ADD CONSTRAINT fk_cust_id FOREIGN KEY (Cust_id) REFERENCES cust_dimen(Cust_id)


--1. Join all the tables and create a new table called combined_table. (market_fact, cust_dimen, orders_dimen, prod_dimen, shipping_dimen)


-- checking the tables
SELECT *
FROM cust_dimen
SELECT *
FROM market_fact
SELECT *
FROM orders_dimen
SELECT * 
FROM prod_dimen
SELECT *
FROM shipping_dimen

---Join Method 1 with WHERE---

SELECT *
FROM market_fact a, cust_dimen b, orders_dimen c, prod_dimen d, shipping_dimen e
WHERE a.ord_id = c.ord_id
AND a.cust_id = b.cust_id
AND a.prod_id = d.prod_id
AND a.ship_id = e.ship_id

----- we will use LEFT JOIN---

SELECT *
FROM market_fact a 
LEFT JOIN cust_dimen b
ON a.cust_id = b.cust_id
LEFT JOIN orders_dimen c
ON a.ord_id = c.ord_id
LEFT JOIN prod_dimen d
ON a.prod_id = d.prod_id
LEFT JOIN shipping_dimen e
ON a.ship_id = e.ship_id

CREATE VIEW [combined_view] AS
SELECT a.Ord_id, a.prod_id, a.Ship_id, a.Cust_id, a.Sales, a.Discount, a.Order_Quantity, a.Product_Base_Margin,
	   b.Customer_Name, b.Province, b.Region, b.Customer_Segment,
	   c.Order_Date, c.Order_Priority,
	   d.Product_Category, d.Product_Sub_Category,
	   e.Order_ID, e.Ship_Date, e.Ship_Mode
FROM market_fact a 
LEFT JOIN cust_dimen b
ON a.cust_id = b.cust_id
LEFT JOIN orders_dimen c
ON a.ord_id = c.ord_id
LEFT JOIN prod_dimen d
ON a.prod_id = d.prod_id
LEFT JOIN shipping_dimen e
ON a.ship_id = e.ship_id


SELECT *
FROM combined_view;

SELECT *
INTO combined_table
FROM dbo.combined_view

SELECT  *
FROM   combined_table

--- create combined_table from combined_view
INSERT INTO combined_table
SELECT *
FROM combined_view

--####################################################################

--2. Find the top 3 customers who have the maximum count of orders.

SELECT TOP 3 Cust_id, Customer_Name, SUM(Order_Quantity) 
FROM combined_table
GROUP BY Cust_id, Customer_Name
ORDER BY SUM(Order_Quantity) DESC;
-- biz order quantityleri topladık. hoca aşağıda orderları toplamış.

----------------
SELECT TOP (3) cust_id, COUNT(Ord_id) total_ord
FROM combined_table
GROUP BY cust_id
ORDER BY total_ord DESC

--####################################################################

--3.Create a new column at combined_table as DaysTakenForDelivery that contains 
--the date difference of Order_Date and Ship_Date.
--Use "ALTER TABLE", "UPDATE" etc.

-- DATEIFF fonksiyonu ile gün farklarını bulalım:
SELECT Ship_Date, Order_Date, DATEDIFF(day, Order_Date, Ship_Date) AS DaysTakenForDelivery
FROM combined_table
ORDER BY 3 DESC

-- DATEIFF ile return ettiğimiz sütunu combined_table'a sütun olarak create ediyoruz:
ALTER TABLE combined_table
DROP COLUMN IF EXISTS DaysTakenForDelivery 

ALTER TABLE combined_table
ADD DaysTakenForDelivery AS
DATEDIFF(DAY, Order_Date, Ship_Date)

SELECT *
FROM combined_table

--------------------------------
ALTER TABLE combined_table
ADD DaysTakenForDelivery2 INT;

SELECT order_date, ship_date, DATEDIFF(DAY, Order_Date, Ship_Date)
FROM combined_table

UPDATE combined_table
SET DaysTakenForDelivery2 = DATEDIFF(Day, Order_Date, Ship_Date)

select * from combined_table
--################################################################################

--4. Find the customer whose order took the maximum time to get delivered.
--Use "MAX" or "TOP"

SELECT TOP 1 Customer_name, DATEDIFF(DAY, Order_Date, Ship_Date) AS DaysTakenForDelivery 
FROM combined_table
ORDER BY 2 DESC

------------------------------
SELECT Cust_id, Customer_Name, Order_Date, Ship_Date, DaysTakenForDelivery
FROM combined_table
WHERE DaysTakenForDelivery = (
							SELECT MAX(DaysTakenForDelivery)
							FROM combined_table
							)

------------------------------

SELECT top 1 Customer_Name, Cust_id, DaysTakenForDelivery
FROM combined_table
order by DaysTakenForDelivery desc

--################################################################################


--5. Count the total number of unique customers in January and how many of them came back every month 
--over the entire year in 2011
--You can use such date functions and subqueries

SELECT DISTINCT(Cust_id), Customer_Name, Order_Date, 
				CASE WHEN MONTH(Order_Date) = 1 THEN 1 ELSE 0 END AS January,
				CASE WHEN MONTH(Order_Date) = 2 THEN 1 ELSE 0 END AS February,
				CASE WHEN MONTH(Order_Date) = 3 THEN 1 ELSE 0 END AS March,
				CASE WHEN MONTH(Order_Date) = 4 THEN 1 ELSE 0 END AS April,
				CASE WHEN MONTH(Order_Date) = 5 THEN 1 ELSE 0 END AS May,
				CASE WHEN MONTH(Order_Date) = 6 THEN 1 ELSE 0 END AS June,
				CASE WHEN MONTH(Order_Date) = 7 THEN 1 ELSE 0 END AS July,
				CASE WHEN MONTH(Order_Date) = 8 THEN 1 ELSE 0 END AS August,
				CASE WHEN MONTH(Order_Date) = 9 THEN 1 ELSE 0 END AS September,
				CASE WHEN MONTH(Order_Date) = 10 THEN 1 ELSE 0 END AS October,
				CASE WHEN MONTH(Order_Date) = 11 THEN 1 ELSE 0 END AS November,
				CASE WHEN MONTH(Order_Date) = 12 THEN 1 ELSE 0 END AS December
FROM combined_table
WHERE cust_id IN (
					SELECT DISTINCT (Cust_id) 
					FROM combined_table
					WHERE MONTH(Order_Date) = 1
					AND YEAR(Order_Date) = 2011
				 )
AND YEAR(Order_Date) = 2011
GROUP BY Cust_id, Customer_Name, Order_Date


SELECT DISTINCT(Cust_id), Customer_Name, Order_Date,
				CASE WHEN MONTH(Order_Date) = 1 THEN 1 ELSE 0 END AS January,
				CASE WHEN MONTH(Order_Date) = 2 THEN 1 ELSE 0 END AS February,
				CASE WHEN MONTH(Order_Date) = 3 THEN 1 ELSE 0 END AS March,
				CASE WHEN MONTH(Order_Date) = 4 THEN 1 ELSE 0 END AS April,
				CASE WHEN MONTH(Order_Date) = 5 THEN 1 ELSE 0 END AS May,
				CASE WHEN MONTH(Order_Date) = 6 THEN 1 ELSE 0 END AS June,
				CASE WHEN MONTH(Order_Date) = 7 THEN 1 ELSE 0 END AS July,
				CASE WHEN MONTH(Order_Date) = 8 THEN 1 ELSE 0 END AS August,
				CASE WHEN MONTH(Order_Date) = 9 THEN 1 ELSE 0 END AS September,
				CASE WHEN MONTH(Order_Date) = 10 THEN 1 ELSE 0 END AS October,
				CASE WHEN MONTH(Order_Date) = 11 THEN 1 ELSE 0 END AS November,
				CASE WHEN MONTH(Order_Date) = 12 THEN 1 ELSE 0 END AS December
FROM combined_table
WHERE MONTH(Order_Date) = 1	AND YEAR(Order_Date) = 2011
GROUP BY Cust_id, Customer_Name, Order_Date

SELECT Cust_id, Customer_Name, Order_Date, 
				CASE WHEN MONTH(Order_Date) = 1 THEN 1 ELSE 0 END AS January,
				CASE WHEN MONTH(Order_Date) = 2 THEN 1 ELSE 0 END AS February,
				CASE WHEN MONTH(Order_Date) = 3 THEN 1 ELSE 0 END AS March,
				CASE WHEN MONTH(Order_Date) = 4 THEN 1 ELSE 0 END AS April,
				CASE WHEN MONTH(Order_Date) = 5 THEN 1 ELSE 0 END AS May,
				CASE WHEN MONTH(Order_Date) = 6 THEN 1 ELSE 0 END AS June,
				CASE WHEN MONTH(Order_Date) = 7 THEN 1 ELSE 0 END AS July,
				CASE WHEN MONTH(Order_Date) = 8 THEN 1 ELSE 0 END AS August,
				CASE WHEN MONTH(Order_Date) = 9 THEN 1 ELSE 0 END AS September,
				CASE WHEN MONTH(Order_Date) = 10 THEN 1 ELSE 0 END AS October,
				CASE WHEN MONTH(Order_Date) = 11 THEN 1 ELSE 0 END AS November,
				CASE WHEN MONTH(Order_Date) = 12 THEN 1 ELSE 0 END AS December
FROM combined_table
WHERE cust_id IN (
					SELECT DISTINCT (Cust_id) 
					FROM combined_table
					WHERE MONTH(Order_Date) = 1
				 )
AND YEAR(Order_Date) = 2011
GROUP BY Cust_id, Customer_Name, Order_Date

SELECT DISTINCT(Cust_id), Customer_Name, Order_Date, 
				SUM(CASE WHEN MONTH(Order_Date) = 1 THEN 1 ELSE 0 END ) AS sum_january,
				CASE WHEN MONTH(Order_Date) = 2 THEN 1 ELSE 0 END AS February,
				CASE WHEN MONTH(Order_Date) = 3 THEN 1 ELSE 0 END AS March,
				CASE WHEN MONTH(Order_Date) = 4 THEN 1 ELSE 0 END AS April,
				CASE WHEN MONTH(Order_Date) = 5 THEN 1 ELSE 0 END AS May,
				CASE WHEN MONTH(Order_Date) = 6 THEN 1 ELSE 0 END AS June,
				CASE WHEN MONTH(Order_Date) = 7 THEN 1 ELSE 0 END AS July,
				CASE WHEN MONTH(Order_Date) = 8 THEN 1 ELSE 0 END AS August,
				CASE WHEN MONTH(Order_Date) = 9 THEN 1 ELSE 0 END AS September,
				CASE WHEN MONTH(Order_Date) = 10 THEN 1 ELSE 0 END AS October,
				CASE WHEN MONTH(Order_Date) = 11 THEN 1 ELSE 0 END AS November,
				CASE WHEN MONTH(Order_Date) = 12 THEN 1 ELSE 0 END AS December
FROM combined_table
WHERE cust_id IN (
					SELECT DISTINCT (Cust_id) 
					FROM combined_table
					WHERE MONTH(Order_Date) = 1
					AND YEAR(Order_Date) = 2011
				 )
AND YEAR(Order_Date) = 2011
GROUP BY Cust_id, Customer_Name, Order_Date


--Raife Hoca----
SELECT DATENAME(MONTH, order_date) AS month_name, MONTH(order_date) AS month_number,  COUNT(DISTINCT cust_id) AS come_back 
FROM combined_table
WHERE 	cust_id in (
		SELECT Cust_id
		FROM combined_table
		WHERE MONTH(Order_Date) = 1)
and YEAR(order_date ) = 2011
GROUP BY DATENAME(MONTH, order_date), MONTH(order_date)
ORDER BY MONTH(order_date)

---SOLUTION---
SELECT DATENAME(Month,order_date) AS month_name, MONTH(order_date) AS month_number, COUNT(DISTINCT cust_id) AS come_back 
FROM combined_table
WHERE cust_id in (
				  SELECT Cust_id
				  FROM combined_table
				  WHERE MONTH(Order_Date ) = 1
				  and YEAR(order_date ) = 2011)
group by DATENAME(MONTH,order_date), MONTH(order_date)
order by MONTH(order_date)
-- WHERE satırında bir kez daha 2011 yılını sınırlamalıyız. bu eksik sorgu oldu!!
----------------------------------

SELECT COUNT(DISTINCT cust_id) num_of_cust
FROM combined_table
WHERE YEAR(Order_Date) = 2011
AND MONTH(Order_Date) = 1
-- bu tablodaki müşterileri bulmak istiyorum

SELECT DISTINCT cust_id
FROM combined_table
WHERE YEAR(Order_Date) = 2011
AND MONTH(Order_Date) = 1
-- 99 cust_id yi buldum

SELECT MONTH(Order_Date), COUNT(DISTINCT cust_id) MONTHLY_NUM_OF_CUST
FROM combined_table A --exists te içerdeki query ile dışardakini bağlamam gerektiği için A dedim.
WHERE
EXISTS 
(
SELECT cust_id
FROM combined_table B
WHERE YEAR(Order_Date) = 2011
AND MONTH(Order_Date) = 1
AND A.Cust_id = B.Cust_id
)
AND YEAR(Order_Date) = 2011
GROUP BY MONTH(order_date)

--////////////////////////////////////////////


--6. write a query to return for each user the time elapsed between the first purchasing and the third purchasing,
--in ascending order by Customer ID
--Use "MIN" with Window Functions

DROP VIEW IF EXISTS elepsed_time_view;
CREATE VIEW elepsed_time_view AS
SELECT cust_id, Customer_Name, order_date, 
	   LEAD(order_date, 3) OVER (PARTITION BY cust_id ORDER BY order_date) next_order_date,
	   DATEDIFF(D, order_date, LEAD(order_date, 3) OVER (PARTITION BY cust_id ORDER BY order_date)) elapsed_time	
FROM combined_table

SELECT cust_id, Customer_Name, order_date, next_order_date, elapsed_time
FROM (
     SELECT ROW_NUMBER() OVER (PARTITION BY cust_id ORDER BY cust_id) as RowNum, *
     FROM elepsed_time_view
	 ) X
WHERE RowNum = 1

----------------------------------
SELECT *
FROM combined_table
where cust_id = 'cust_1000'
order by order_date
-- order_id lerde çoklama mevcut. birden fazla kayıt girilmiş. mesela 2. 3. ve 4. satırlar aynı sipariş. 5 ve 5 da aynı sipariş
-- biz sadece LEAD dersek 1. siparişin yanına 3.sipariş olarak getirdiği şey 2.sipariş olacaktır. yanlış sonuç verecektir.
-- ROW ile yaparsak da üstten aşağıya doğru numaralandıracak ve yine aynı şekilde 3.sipariş olarak 2. siparişi getirecek. 
-- DENCE_RANK() ile sıralama yaparsam tekrar satırlarına aynı numarayı vermekle birlikte sonraki farklı satıra bir sonraki numarayı verir.

SELECT Cust_id, ord_id, order_date,
		MIN(order_date) OVER (PARTITION BY cust_id) FIRST_ORDER_DATE,
		DENSE_RANK() OVER(PARTITION BY cust_id ORDER BY Order_date) dence_number
FROM combined_table
-- min(order_date) i tekrar eden aynı orderları kontrol için aldım.
-- DENCE_RANK() uyguladıktan sonra tkrar eden 3. orderları görebiliyorum. şimdi onları seçmem lazım.


SELECT DISTINCT
		cust_id,
		order_date,
		dense_number,
		FIRST_ORDER_DATE,
		DATEDIFF(day, FIRST_ORDER_DATE, order_date) DAYS_ELAPSED
FROM	
		(
		SELECT	Cust_id, ord_id, order_DATE,
				MIN (Order_Date) OVER (PARTITION BY cust_id) FIRST_ORDER_DATE,
				DENSE_RANK () OVER (PARTITION BY cust_id ORDER BY Order_date) dense_number
		FROM	combined_table
		) A
WHERE	dense_number = 3 
-- dence_numberları 3 olanları seçtim. 
-- soruda istenen de bunlar ile ilk siparişler arasında geçen süre idi. 
-- where de dance_number=3 yaparak; order_date olarak 3.sipariş tarihlerine ait satırları seçmesini 
	-- ve select içinde DATEDIFF ile bu satırların first order date ten farklarını aldım.


--##################################################################################

--7. Write a query that returns customers who purchased both product 11 and product 14, 
--as well as the ratio of these products to the total number of products purchased by the customer.
--Use CASE Expression, CTE, CAST AND such Aggregate Functions


SELECT DISTINCT cust_id, Customer_Name,
			COUNT(prod_id) Total_order, 
			100*SUM(case when prod_id = 'Prod_11' or prod_id = 'Prod_14' THEN 1 ELSE 0 END)/COUNT(prod_id) Ratio,
			SUM(CASE WHEN prod_id = 'Prod_11' or prod_id = 'Prod_14' THEN 1 ELSE 0 END) Selected_order 

FROM combined_table
WHERE cust_id in (		
				  SELECT  cust_id
				  FROM combined_table
				  WHERE prod_id = 'Prod_11' 

				  INTERSECT

				  SELECT  cust_id
				  FROM combined_table
				  WHERE prod_id = 'Prod_14'
				  )
GROUP BY cust_id, Customer_Name

------------------------------------

SELECT *
FROM combined_table

SELECT cust_id,
		SUM (CASE WHEN Prod_id = 'Prod_11' THEN Order_Quantity ELSE 0 END) P11,
		SUM (CASE WHEN Prod_id = 'Prod_14' THEN Order_Quantity ELSE 0 END) P14
FROM combined_table
GROUP BY cust_id
-- P11 ve P14 sütunları oluşturup SUM ile bu productlara ait sipariş sayılarını altına yapıştırıyorum. diğer productlar 0 olarak gelecek.


WITH T1 AS
(
SELECT	Cust_id,
		SUM (CASE WHEN Prod_id = 'Prod_11' THEN Order_Quantity ELSE 0 END) P11,
		SUM (CASE WHEN Prod_id = 'Prod_14' THEN Order_Quantity ELSE 0 END) P14,
		SUM (Order_Quantity) TOTAL_PROD
FROM	combined_table
GROUP BY Cust_id
HAVING
		SUM (CASE WHEN Prod_id = 'Prod_11' THEN Order_Quantity ELSE 0 END) >= 1 AND
		SUM (CASE WHEN Prod_id = 'Prod_14' THEN Order_Quantity ELSE 0 END) >= 1
)
SELECT	Cust_id, P11, P14, TOTAL_PROD,
		CAST (1.0*P11/TOTAL_PROD AS NUMERIC (3,2)) AS RATIO_P11,
		CAST (1.0*P14/TOTAL_PROD AS NUMERIC (3,2)) AS RATIO_P14
FROM T1


--#####################################################################################

--CUSTOMER RETENTION ANALYSIS


--1. Create a view that keeps visit logs of customers on a monthly basis. 
--(For each log, three field is kept: Cust_id, Year, Month)
--Use such date functions. Don't forget to call up columns you might need later.

CREATE VIEW [Visit_Logs_Basic] AS
SELECT  customer_name, 
		Cust_id, 
		DATENAME(YEAR, order_date) Visit_Year, 
		DATENAME(MONTH, order_date) Visit_Month,
		COUNT(ord_id) Order_Numbers
FROM combined_table
GROUP BY customer_name, Cust_id, DATENAME(YEAR, order_date), DATENAME(MONTH, order_date) 


CREATE VIEW [Visit_Logs_Expanded] AS
SELECT  customer_name, 
		Cust_id, 
		DATENAME(YEAR, order_date) Visit_Year, 
		DATENAME(MONTH, order_date) Visit_Month,
		COUNT(ord_id) Order_Numbers,
		Province,
		Region
FROM combined_table
GROUP BY customer_name, Cust_id, province, region, DATENAME(YEAR, order_date), DATENAME(MONTH, order_date) 


SELECT *
FROM Visit_Logs_Basic
SELECT *
FROM Visit_Logs_Expanded

----------------------------------------

CREATE VIEW customer_logs AS

SELECT cust_id,
		YEAR (order_date) [YEAR],
		MONTH(order_date) [MONTH]
FROM combined_table


SELECT *
FROM customer_logs
ORDER BY 1,2,3


--#####################################################################################

--2. Create a view that keeps the number of monthly visits by users. 
--(Separately for all months from the business beginning)
--Don't forget to call up columns you might need later.

CREATE VIEW [Visit_Logs_Basic] AS

SELECT  customer_name, 
		Cust_id, 
		DATENAME(YEAR, order_date) [Visit Year], 
		DATENAME(MONTH, order_date) [Visit Month],
		COUNT(ord_id) [Number of Order]
FROM combined_table
GROUP BY customer_name, Cust_id, DATENAME(YEAR, order_date), DATENAME(MONTH, order_date) 

SELECT *
FROM Visit_Logs_Basic

--------------------------------

CREATE VIEW NUMBER_OF_VISITS AS
SELECT	Cust_id, [YEAR], [MONTH], COUNT(*) NUM_OF_LOG
FROM	customer_logs
GROUP BY Cust_id, [YEAR], [MONTH]

SELECT  *,
		DENSE_RANK () OVER (PARTITION BY Cust_id ORDER BY [YEAR] , [MONTH])
FROM	NUMBER_OF_VISITS

--//////////////////////////////////


--3. For each visit of customers, create the next month of the visit as a separate column.
--You can number the months with "DENSE_RANK" function.
--then create a new column for each month showing the next month using the numbering you have made. (use "LEAD" function.)
--Don't forget to call up columns you might need later.

SELECT *
FROM Visit_Logs_Basic

SELECT *,   
       DENSE_RANK() OVER (PARTITION BY Customer_Name ORDER BY Visit_Month) AS Month 
FROM Visit_Logs_Basic

SELECT *,   
       DENSE_RANK() OVER (ORDER BY Customer_Name) AS Month 
FROM Visit_Logs_Basic

SELECT Customer_Name, Visit_Month,   
       LEAD (Visit_Month, 1, 'NONE') OVER (PARTITION BY Customer_Name ORDER BY Visit_Month DESC) AS Next_Order_Month  
FROM Visit_Logs_Basic  

--------------------------------------

SELECT  [YEAR], [MONTH],
		DENSE_RANK () OVER (PARTITION BY Cust_id ORDER BY [YEAR] , [MONTH])		
FROM	NUMBER_OF_VISITS
-- cust_id partitiona alıp DENSE_RANK yapınca, müşteri bazında yıl ve ay ikililerine cust_id bazında numara vermiş oldum.


SELECT  *,
		DENSE_RANK () OVER (ORDER BY [YEAR] , [MONTH]) CURRENT_MONTH		
FROM	NUMBER_OF_VISITS
ORDER BY 1,2,3
-- yıl ve ay ikilileri için sıra numaraları verdirdim (12.aydan sonra gelen ayları 13,14... diye sıralayacak) 
	-- müşterileri bir sonraki adımda gruplayacağım.


CREATE VIEW NEXT_VISIT AS
SELECT *,
		LEAD(CURRENT_MONTH, 1) OVER (PARTITION BY Cust_id ORDER BY CURRENT_MONTH) NEXT_VISIT_MONTH
FROM
(
SELECT  *,
		DENSE_RANK () OVER (ORDER BY [YEAR] , [MONTH]) CURRENT_MONTH
		
FROM	NUMBER_OF_VISITS
) A

select *
from NEXT_VISIT

--###############################################################################

--4. Calculate the monthly time gap between two consecutive visits by each customer.
--Don't forget to call up columns you might need later.


CREATE VIEW time_gaps AS
SELECT *,
		NEXT_VISIT_MONTH - CURRENT_MONTH time_gaps
FROM	NEXT_VISIT


select *
from time_gaps


--/////////////////////////////////////////


--5.Categorise customers using time gaps. Choose the most fitted labeling model for you.
--  For example: 
--	Labeled as churn if the customer hasn't made another purchase in the months since they made their first purchase.
--	Labeled as regular if the customer has made a purchase every month.
--  Etc.

select * from time_gaps
-- alışveriş tarihlerinden bir sonraki alışveriş tarihlerini yan yana getirip aralarındaki farkları aldım
	

SELECT cust_id, AVG(time_gaps) avg_time_gap
FROM time_gaps
GROUP BY cust_id
-- burada da her müşterinin alışverişleri arasında geçen ortalama zamanları getirdim.
	-- buna göre artık müşterilerin alışveriş yapma sıklıklarını görebiliyorum.


SELECT cust_id, avg_time_gap,
		CASE WHEN avg_time_gap = 1 THEN 'retained'
			WHEN avg_time_gap > 1 THEN 'irregular'
			WHEN avg_time_gap IS NULL THEN 'Churn'
			ELSE 'UNKNOWN DATA' END CUST_LABELS
FROM
		(
		SELECT Cust_id, AVG(time_gaps) avg_time_gap
		FROM	time_gaps
		GROUP BY Cust_id
		) A
-- müşterilerin alışverişleri arasında geçen ortalama zamanlara göre sınıflandırma yapmış oldum.
	-- örneğin ortalama 1 olan yani her ay alışveriş yapan retained (tutulan) müşteri yaptım


--/////////////////////////////////////

Month-Wise Retention Rate = 1.0 * Number of Customers Retained in The Next Nonth / Total Number of Customers in The Previous Month


--MONTH-WİSE RETENTİON RATE
--Find month-by-month customer retention rate  since the start of the business.
--1. Find the number of customers retained month-wise. (You can use time gaps)
--Use Time Gaps


SELECT DISTINCT [YEAR],
				[MONTH],
				CURRENT_MONTH,
				NEXT_VISIT_MONTH,
				COUNT(cust_id) OVER (PARTITION BY NEXT_VISIT_MONTH) RETENTION_MONTH_WISE
FROM			time_gaps
ORDER BY		NEXT_VISIT_MONTH



SELECT	DISTINCT cust_id, [YEAR],
		[MONTH],
		CURRENT_MONTH,
		NEXT_VISIT_MONTH,
		time_gaps,
		COUNT (cust_id)	OVER (PARTITION BY NEXT_VISIT_MONTH) RETENTITON_MONTH_WISE
FROM	time_gaps
where	time_gaps =1
ORDER BY cust_id, NEXT_VISIT_MONTH

-- önceki aylarda alışverişi olmayan müşterileri bulup onları kazanmak istiyorum


--//////////////////////


--2. Calculate the month-wise retention rate.

--Basic formula: o	Month-Wise Retention Rate = 1.0 * Total Number of Customers in The Previous Month / Number of Customers Retained in The Next Nonth

--It is easier to divide the operations into parts rather than in a single ad-hoc query. It is recommended to use View. 
--You can also use CTE or Subquery if you want.

--You should pay attention to the join type and join columns between your views or tables.


--2. Calculate the month-wise retention rate.
--Basic formula: o	Month-Wise Retention Rate = 1.0 * Number of Customers Retained in The Next Nonth / Total Number of Customers in The Previous Month
--It is easier to divide the operations into parts rather than in a single ad-hoc query. It is recommended to use View.
--You can also use CTE or Subquery if you want.
--You should pay attention to the join type and join columns between your views or tables.
CREATE VIEW CURRENT_NUM_OF_CUST AS
SELECT	DISTINCT cust_id, [YEAR],
		[MONTH],
		CURRENT_MONTH,
		COUNT (cust_id)	OVER (PARTITION BY CURRENT_MONTH) RETENTITON_MONTH_WISE
FROM	time_gaps
SELECT *
FROM	CURRENT_NUM_OF_CUST
---
DROP VIEW NEXT_NUM_OF_CUST
CREATE VIEW NEXT_NUM_OF_CUST AS
SELECT	DISTINCT cust_id, [YEAR],
		[MONTH],
		CURRENT_MONTH,
		NEXT_VISIT_MONTH,
		COUNT (cust_id)	OVER (PARTITION BY NEXT_VISIT_MONTH) RETENTITON_MONTH_WISE
FROM	time_gaps
WHERE	time_gaps = 1
AND		CURRENT_MONTH > 1
SELECT DISTINCT
		B.[YEAR],
		B.[MONTH],
		B.CURRENT_MONTH,
		B.NEXT_VISIT_MONTH,
		1.0 * B.RETENTITON_MONTH_WISE / A.RETENTITON_MONTH_WISE RETENTION_RATE
FROM	CURRENT_NUM_OF_CUST A LEFT JOIN NEXT_NUM_OF_CUST B
ON		A.CURRENT_MONTH + 1 = B.NEXT_VISIT_MONTH





---///////////////////////////////////
--Good luck!