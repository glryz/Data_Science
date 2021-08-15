---------------- SQL_RECAP_1(25.07.2021)Tr --------------------------

----1. All the cities in the Texas and the numbers of customers in each city.---

SELECT A.city, COUNT(A.city) AS number_of_customer
FROM sales.customers AS A
WHERE A.state = 'TX'
GROUP BY A.city
ORDER BY A.city

----2. All the cities in the California which has more than 5 customer, by showing the cities which have more customers first.---

SELECT A.city, COUNT(A.city) AS number_of_customer
FROM sales.customers AS A
WHERE A.state = 'CA'
GROUP BY A.city
HAVING COUNT(A.city) > 5
ORDER BY COUNT(A.city) DESC;

-----3. The top 10 most expensive products------

SELECT TOP 10 product_name, list_price
FROM production.products
ORDER BY list_price DESC

-----4. Product name and list price of the products which are located in the store id 2 and the quantity is greater than 25------

SELECT A.product_name, A.list_price
FROM production.products AS A, production.stocks AS B
WHERE A.product_id = B.product_id AND B.store_id = 2 AND B.quantity > 25
ORDER BY product_name;

-----5. Find the customers who locate in the same zip code------

SELECT A.zip_code,
A.first_name+' '+A.last_name AS customer1,
B.first_name+' '+B.last_name AS customer2
FROM sales.customers AS A
JOIN sales.customers AS B
ON A.zip_code = B.zip_code
WHERE a.customer_id != b.customer_id
ORDER BY zip_code, customer1, customer2

-- 2. WAY

SELECT a.zip_code,
a.first_name+' '+a.last_name as customer1,
b.first_name+' '+b.last_name as customer2
FROM sales.customers as  a, sales.customers b 
WHERE a.customer_id > b.customer_id
AND a.zip_code = b.zip_code
ORDER BY zip_code,
customer1,
customer2



-----6. Return first name, last name, e-mail and phone number of the customers------

SELECT first_name+' '+last_name as full_name, email, COALESCE(phone, 'n/a') AS phone 
FROM sales.customers

-- 2. WAY

SELECT ISNULL(first_name, ' ') + ' ' + ISNULL(last_name, ' ') AS full_name, email, ISNULL(phone, 'n/a')
FROM sales.customers;


-----7. Find the sales order of the customers who lives in Houston order by order date------

SELECT order_id, order_date, customer_id
FROM sales.orders
WHERE customer_id 
IN (
	SELECT customer_id
	FROM sales.customers
	WHERE city = 'Houston'
	)
ORDER BY order_date

-- 2. WAY

SELECT A.order_id, A.order_date, B.customer_id
FROM sales.orders A
JOIN sales.customers B
ON A.customer_id = B.customer_id
WHERE B.city = 'Houston'
ORDER BY A.order_date

-----8. Find the products whose list price is greater than the average list price of all products with the Electra or Heller ------

SELECT DISTINCT A.product_name, A.list_price
FROM production.products AS A
WHERE A.list_price >   (SELECT AVG(B.list_price)
						FROM production.products AS B
						JOIN production.brands AS C
						ON B.brand_id = C.brand_id
						WHERE brand_name='Electra' OR brand_name='Heller'
						)
ORDER BY list_price;

-- 2. WAY

SELECT DISTINCT(product_name), list_price
FROM production.products
WHERE list_price > (
					SELECT AVG(list_price)
					FROM production.brands A
					INNER JOIN production.products B
					ON A.brand_id = B.brand_id
					WHERE A.brand_name IN ('Electra', 'Heller'))
ORDER BY list_price ASC;

-- 3. WAY

SELECT DISTINCT product_name,list_price
FROM production.products
WHERE list_price > (
					SELECT AVG (list_price)
					FROM production.products
					WHERE brand_id IN  (SELECT brand_id
										FROM production.brands
										WHERE brand_name = 'Electra'
										OR brand_name='Heller')
					)
ORDER by list_price


-----9. Find the products that have no sales ------

SELECT product_id
FROM production.products
EXCEPT
SELECT product_id
FROM sales.order_items

-- 2. WAY

SELECT product_id
FROM production.products
WHERE product_id NOT IN (
						 SELECT product_id
						 FROM sales.order_items);


---- 10. Return the average number of sales orders in 2017 sales----

SELECT staff_id, COUNT(order_id) AS sales_count
FROM sales.orders
WHERE YEAR(order_date)=2017  -- order_date LIKE '2017%'
GROUP BY staff_id;


WITH cte_avg_sale AS (
					  SELECT staff_id, COUNT(order_id) AS sales_count
					  FROM sales.orders
					  WHERE YEAR(order_date)=2017
					  GROUP BY staff_id
					  )
SELECT AVG(sales_count) as 'Average Number of Sales'
FROM cte_avg_sale

-- 2. WAY

--Total_Orders_2017 adýnda bir Tablo oluþtur
SELECT COUNT(order_id) AS Count_of_Sales
INTO Total_Orders_2017
FROM sales.orders
WHERE YEAR(order_date) = 2017; -- order_date LIKE '2017%'

--Staffs_Sold_2017 adýnda bir Tablo oluþtur
SELECT COUNT(first_name) AS Count_of_Staffs
INTO Staffs_Sold_2017
FROM sales.staffs
WHERE staff_id IN  (
					SELECT staff_id
					FROM sales.orders
					WHERE YEAR(order_date) = 2017
					);

SELECT A.Count_of_Sales / B.Count_of_Staffs AS 'Average Number of Sales'
FROM Total_Orders_2017 A, Staffs_Sold_2017 B;

-- 3.WAY

SELECT AVG(A.sales_amounts) AS 'Average Number of Sales'
FROM   (
		SELECT COUNT(order_id) AS sales_amounts
		FROM sales.orders
		WHERE order_date LIKE '%2017%' 
		GROUP BY staff_id
		) as A


----11  By using view get the sales by staffs and years using the AVG() aggregate function:

SELECT S.first_name, S.last_name, YEAR(O.order_date) as year, AVG((I.list_price - I.discount) * I.quantity) AS avg_amount
FROM sales.staffs AS S
JOIN sales.orders AS O
ON S.staff_id = O.staff_id
JOIN sales.order_items AS I
ON O.order_id = I.order_id
GROUP BY S.first_name, S.last_name, YEAR(O.order_date)
order by first_name, last_name, YEAR(O.order_date)

-- 2. WAY

CREATE VIEW sales.staff_sales (first_name, last_name, year, avg_amount)
AS 
SELECT first_name, last_name, YEAR(order_date), AVG(list_price * quantity) as avg_amount
FROM sales.order_items i
JOIN sales.orders o
ON i.order_id = o.order_id
JOIN sales.staffs s
ON s.staff_id = o.staff_id
GROUP BY first_name, last_name, YEAR(order_date);
--------------
SELECT * 
FROM sales.staff_sales
ORDER BY first_name, last_name, year;
